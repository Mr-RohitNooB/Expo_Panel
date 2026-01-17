using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace Expo_Panel
{
    public partial class VisitorDashboard : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["VisitorID"] == null)
            {
                Response.Redirect("VisitorLogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile((int)Session["VisitorID"]);
            }
        }

        // ==================================================================
        // 1. ORIGINAL METHODS (Restored to fix CS0103 Error)
        // ==================================================================

        private void LoadProfile(int id)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetVisitorProfile", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VisitorID", id);
                    con.Open();
                    SqlDataReader r = cmd.ExecuteReader();
                    if (r.Read())
                    {
                        litUserName.Text = r["FullName"].ToString();
                        litName.Text = r["FullName"].ToString();
                        litTicket.Text = r["TicketType"].ToString();
                        litCompany.Text = r["CompanyName"].ToString();
                        litJob.Text = r["JobTitle"].ToString();
                        litEmail.Text = r["Email"].ToString();
                        litMobile.Text = r["Mobile"].ToString();
                    }
                }
            }
        }

        protected void btnChangePass_Click(object sender, EventArgs e)
        {
            int id = (int)Session["VisitorID"];
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_ChangeVisitorPassword", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VisitorID", id);
                    cmd.Parameters.AddWithValue("@OldPassword", txtOld.Text);
                    cmd.Parameters.AddWithValue("@NewPassword", txtNew.Text);
                    con.Open();
                    int result = (int)cmd.ExecuteScalar();

                    if (result == 1)
                        litMessage.Text = "<div style='color:green; padding:10px; background:#d1fae5; border-radius:6px; margin-bottom:15px; text-align:center;'>Password Changed Successfully!</div>";
                    else
                        litMessage.Text = "<div style='color:red; padding:10px; background:#fee2e2; border-radius:6px; margin-bottom:15px; text-align:center;'>Incorrect Current Password.</div>";
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("VisitorLogin.aspx");
        }

        // ==================================================================
        // 2. NEW BOOKMARKING LOGIC
        // ==================================================================

        public class ExhibitorDashDTO
        {
            public int ExhibitorID { get; set; }
            public string Company { get; set; }
            public string LogoPath { get; set; }
            public string City { get; set; }
            public string Country { get; set; }
            public string BoothNo { get; set; }
            public bool IsBookmarked { get; set; }
        }

        [WebMethod(EnableSession = true)]
        public static List<ExhibitorDashDTO> GetAllExhibitorsForDashboard()
        {
            if (System.Web.HttpContext.Current.Session["VisitorID"] == null) return null;

            int visitorId = (int)System.Web.HttpContext.Current.Session["VisitorID"];
            List<ExhibitorDashDTO> list = new List<ExhibitorDashDTO>();
            string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetExhibitorsWithBookmarkStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VisitorID", visitorId);
                    con.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            list.Add(new ExhibitorDashDTO
                            {
                                ExhibitorID = Convert.ToInt32(rdr["ExhibitorID"]),
                                Company = rdr["Company"].ToString(),
                                LogoPath = rdr["LogoPath"].ToString(),
                                City = rdr["City"].ToString(),
                                Country = rdr["Country"].ToString(),
                                BoothNo = rdr["BoothNo"].ToString(),
                                IsBookmarked = Convert.ToInt32(rdr["IsBookmarked"]) == 1
                            });
                        }
                    }
                }
            }
            return list;
        }

        [WebMethod(EnableSession = true)]
        public static object ToggleBookmark(int exhibitorId)
        {
            if (System.Web.HttpContext.Current.Session["VisitorID"] == null)
                return new { status = "SESSION_EXPIRED" };

            int visitorId = (int)System.Web.HttpContext.Current.Session["VisitorID"];
            string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_ToggleVisitorBookmark", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@VisitorID", visitorId);
                        cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
                        con.Open();
                        int result = Convert.ToInt32(cmd.ExecuteScalar());
                        return new { status = "SUCCESS", isBookmarked = (result == 1) };
                    }
                }
            }
            catch (Exception ex)
            {
                return new { status = "ERROR", message = ex.Message };
            }
        }
    }
}