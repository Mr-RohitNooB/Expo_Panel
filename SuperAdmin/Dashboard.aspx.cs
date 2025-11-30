using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Web;

namespace Expo_Panel.SuperAdmin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get
            {
                var cs = ConfigurationManager.ConnectionStrings["ExpoPanelDB"];
                if (cs == null || string.IsNullOrWhiteSpace(cs.ConnectionString))
                    throw new InvalidOperationException("Connection string 'ExpoPanelDB' not found in web.config.");
                return cs.ConnectionString;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsAdminLoggedIn())
            {
                Response.Redirect("Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            string role = Session["Role"] != null ? Session["Role"].ToString() : "Admin";

            if (role != "SuperAdmin")
            {
                // Send them to the TEAM Dashboard instead
                Response.Redirect("~/Admin/Dashboard.aspx", false); // <--- ADD THIS
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                SetUserLabelsFromSession();
                LoadDashboardStats();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            try
            {
                Session.Clear();
                Session.Abandon();
            }
            finally
            {
                Response.Redirect("Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static bool LogoutUser()
        {

            if (HttpContext.Current != null && HttpContext.Current.Session != null)
            {
                HttpContext.Current.Session.Clear();
                HttpContext.Current.Session.Abandon();
                return true;

            }
            return false;
        }


        #region Dashboard Stats

        private void LoadDashboardStats()
        {
            try
            {
                using (var con = new SqlConnection(ConnectionString))
                {
                    con.Open();

                    lblAdvisorCount.Text = GetActiveCount(con, "TBL", "Advisory");
                    lblSpeakerCount.Text = GetActiveCount(con, "TBL", "Speaker");
                    lblExhibitorCount.Text = GetActiveCount(con, "TBL", "Exhibitor");
                    lblAgendaCount.Text = GetActiveCount(con, "TBL", "Agenda");
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"LoadDashboardStats Exception: {ex.Message}");
                lblAdvisorCount.Text = "0";
                lblSpeakerCount.Text = "0";
                lblExhibitorCount.Text = "0";
                lblAgendaCount.Text = "0";
            }
        }

        private string GetActiveCount(SqlConnection con, string schema, string table)
        {
            try
            {
                if (!IsAllowedTable(schema, table))
                    return "0";

                if (!TableExists(con, schema, table))
                    return "0";

                string sql = $"SELECT COUNT(1) FROM [{schema}].[{table}] WHERE IS_ACTIVE = 1";
                using (var cmd = new SqlCommand(sql, con))
                {
                    object res = cmd.ExecuteScalar();
                    return res != null ? res.ToString() : "0";
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"GetActiveCount Exception for {schema}.{table}: {ex.Message}");
                return "0";
            }
        }

        private bool IsAllowedTable(string schema, string table)
        {
            if (string.IsNullOrWhiteSpace(schema) || string.IsNullOrWhiteSpace(table)) return false;

            string full = $"{schema}.{table}".Trim();

            string[] allowed = new[]
            {
                "TBL.Advisory",
                "TBL.Speaker",
                "TBL.Exhibitor",
                "TBL.Agenda"
            };

            foreach (var a in allowed)
                if (string.Equals(a, full, StringComparison.OrdinalIgnoreCase))
                    return true;

            return false;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Request.Form["action"] == "addAdvisor")
            {
                try
                {
                    string name = Request.Form["name"];
                    string email = Request.Form["email"];
                    string mobile = Request.Form["mobile"];
                    string designation = Request.Form["designation"];
                    string company = Request.Form["company"];
                    string password = Request.Form["password"];
                    bool linkToAdmin = Request.Form["linkToAdmin"] == "1";
                    string approvalStatus = Request.Form["status"];
                    string remarks = Request.Form["remarks"];
                    int isActive = Convert.ToInt32(Request.Form["isActive"]);

                    // Get current Admin ID from session
                    int adminID = Session["AdminID"] != null ? Convert.ToInt32(Session["AdminID"]) : 0;

                    // Add the advisor with password and admin linking
                    AddAdvisorWithLogin(name, email, mobile, designation, company, password,
                                       linkToAdmin, adminID, approvalStatus, remarks, isActive);

                    Response.Clear();
                    Response.Write("Success");
                    Context.ApplicationInstance.CompleteRequest();
                }
                catch (Exception ex)
                {
                    Response.Clear();
                    Response.Write("Error: " + ex.Message);
                    Context.ApplicationInstance.CompleteRequest();
                }
            }
        }

        private void AddAdvisorWithLogin(string name, string email, string mobile, string designation,
     string company, string password, bool linkToAdmin, int adminID, string approvalStatus,
     string remarks, int isActive)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_AddAdvisorWithLogin", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Basic Information
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                    cmd.Parameters.AddWithValue("@Designation", string.IsNullOrEmpty(designation) ? (object)DBNull.Value : designation);
                    cmd.Parameters.AddWithValue("@Company", string.IsNullOrEmpty(company) ? (object)DBNull.Value : company);

                    // Login & Linking
                    cmd.Parameters.AddWithValue("@Password", password);
                    cmd.Parameters.AddWithValue("@LinkedAdminID", linkToAdmin ? (object)adminID : DBNull.Value);

                    // Status & Approval
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);
                    cmd.Parameters.AddWithValue("@ApprovalStatus", approvalStatus);
                    cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks);
                    cmd.Parameters.AddWithValue("@RegistrationType", "Admin");
                    cmd.Parameters.AddWithValue("@ApprovedBy", adminID);
                    cmd.Parameters.AddWithValue("@ApprovalDate", DateTime.Now);

                    // Output parameter
                    SqlParameter advisorIDParam = new SqlParameter("@AdvisorID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(advisorIDParam);

                    con.Open();
                    cmd.ExecuteNonQuery();

                    int newAdvisorID = (int)advisorIDParam.Value;

                    System.Diagnostics.Debug.WriteLine($"New Advisor Created - ID: {newAdvisorID}, Email: {email}, Linked to Admin: {linkToAdmin}");
                }
            }
        }



        private bool TableExists(SqlConnection con, string schema, string table)
        {
            if (con == null) return false;
            if (string.IsNullOrWhiteSpace(schema) || string.IsNullOrWhiteSpace(table)) return false;

            string fullName = $"{schema}.{table}".Replace("[", "").Replace("]", "").Trim();

            const string checkSql = "SELECT CASE WHEN OBJECT_ID(@FullName, 'U') IS NOT NULL THEN 1 ELSE 0 END";
            using (var cmd = new SqlCommand(checkSql, con))
            {
                cmd.Parameters.AddWithValue("@FullName", fullName);
                object res = cmd.ExecuteScalar();
                return res != null && Convert.ToInt32(res) == 1;
            }
        }

        #endregion

        #region Session / UI helpers

        private bool IsAdminLoggedIn()
        {
            if (Session == null) return false;
            var s = Session["IsAdminLoggedIn"];
            if (s == null) return false;
            if (s is bool b) return b;
            bool parsed;
            return bool.TryParse(s.ToString(), out parsed) && parsed;
        }

        private void SetUserLabelsFromSession()
        {
            string username = Session["AdminUsername"]?.ToString() ?? "Administrator";
            try
            {
                lblUsername.Text = username;
                lblWelcomeUser.Text = username;
                lblUserInitial.Text = !string.IsNullOrEmpty(username) ? username.Substring(0, 1).ToUpper() : "A";
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"SetUserLabelsFromSession Exception: {ex.Message}");
                lblUsername.Text = "Administrator";
                lblWelcomeUser.Text = "Administrator";
                lblUserInitial.Text = "A";
            }
        }

        #endregion
    }
}