using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Expo_Panel.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["IsAdminLoggedIn"] == null || !(bool)Session["IsAdminLoggedIn"])
            {
                Response.Redirect("Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                // Display username
                if (Session["AdminUsername"] != null)
                {
                    string username = Session["AdminUsername"].ToString();
                    lblUsername.Text = username;
                    lblWelcomeUser.Text = username;

                    // Get first letter for avatar
                    lblUserInitial.Text = username.Substring(0, 1).ToUpper();
                }

                // Load statistics
                LoadDashboardStats();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private void LoadDashboardStats()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    con.Open();

                    // Get Advisor Count
                    string advisorQuery = "SELECT COUNT(*) FROM TBL_ADVISORY WHERE IS_ACTIVE = 1";
                    using (SqlCommand cmd = new SqlCommand(advisorQuery, con))
                    {
                        object result = cmd.ExecuteScalar();
                        lblAdvisorCount.Text = result != null ? result.ToString() : "0";
                    }

                    // Get Speaker Count
                    string speakerQuery = "SELECT COUNT(*) FROM TBL_Speaker WHERE IS_ACTIVE = 1";
                    using (SqlCommand cmd = new SqlCommand(speakerQuery, con))
                    {
                        object result = cmd.ExecuteScalar();
                        lblSpeakerCount.Text = result != null ? result.ToString() : "0";
                    }

                    // Get Exhibitor Count (if table exists)
                    try
                    {
                        string exhibitorQuery = "SELECT COUNT(*) FROM TBL_Exhibitor WHERE IS_ACTIVE = 1";
                        using (SqlCommand cmd = new SqlCommand(exhibitorQuery, con))
                        {
                            object result = cmd.ExecuteScalar();
                            lblExhibitorCount.Text = result != null ? result.ToString() : "0";
                        }
                    }
                    catch
                    {
                        // Exhibitor table doesn't exist yet
                        lblExhibitorCount.Text = "0";
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error
                System.Diagnostics.Debug.WriteLine($"Dashboard Stats Error: {ex.Message}");

                // Set default values
                lblAdvisorCount.Text = "0";
                lblSpeakerCount.Text = "0";
                lblExhibitorCount.Text = "0";
            }
        }
    }
}