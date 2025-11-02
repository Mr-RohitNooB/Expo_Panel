using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;

namespace Expo_Panel.Admin
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