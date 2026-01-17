using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Expo_Panel.Admin
{
    // IMPORTANT: Note the class name 'TeamDashboard' to avoid conflict with SuperAdmin
    public partial class TeamDashboard : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. CHECK TEAM SESSION
            if (Session["IsTeamAdminLoggedIn"] == null || !(bool)Session["IsTeamAdminLoggedIn"])
            {
                Response.Redirect("Default.aspx"); // Go to TEAM Login
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                LoadUserData();
                LoadStats();
            }
        }

        private void LoadUserData()
        {
            string username = Session["AdminUsername"] != null ? Session["AdminUsername"].ToString() : "Team";
            lblUsername.Text = username;
            lblWelcomeUser.Text = username;
            lblUserInitial.Text = !string.IsNullOrEmpty(username) ? username.Substring(0, 1).ToUpper() : "T";
        }

        private void LoadStats()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    //con.Open();
                    //// Get simple counts for the team view
                    //lblAdvisorCount.Text = GetCount(con, "TBL.Advisory");
                    //lblSpeakerCount.Text = GetCount(con, "TBL.Speaker");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Stats Error: " + ex.Message);
            }
        }

        private string GetCount(SqlConnection con, string tableName)
        {
            try
            {
                // Simple Active Count
                string query = $"SELECT COUNT(1) FROM {tableName} WHERE IS_ACTIVE = 1";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    object result = cmd.ExecuteScalar();
                    return result != null ? result.ToString() : "0";
                }
            }
            catch
            {
                return "0";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx"); // Redirect to TEAM Login
        }
    }
}