using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;

namespace Expo_Panel.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        /// <summary>
        /// Reads connection string "ExpoPanelDB" from web.config; throws if missing.
        /// </summary>
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
            // Redirect to login page if not logged in as admin
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

        /// <summary>
        /// Logout button click - clears session and redirects to login.
        /// </summary>
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

        /// <summary>
        /// Loads advisor/speaker/exhibitor counts and populates label controls.
        /// </summary>
        private void LoadDashboardStats()
        {
            try
            {
                using (var con = new SqlConnection(ConnectionString))
                {
                    con.Open();

                    // Use schema-qualified names (your DB uses schema "TBL")
                    lblAdvisorCount.Text = GetActiveCount(con, "TBL", "Advisory");
                    lblSpeakerCount.Text = GetActiveCount(con, "TBL", "Speaker");
                    lblExhibitorCount.Text = GetActiveCount(con, "TBL", "Exhibitor");
                }
            }
            catch (Exception ex)
            {
                // Log the error for debugging. Replace with proper logger in production.
                Debug.WriteLine($"LoadDashboardStats Exception: {ex.Message}");
                lblAdvisorCount.Text = "0";
                lblSpeakerCount.Text = "0";
                lblExhibitorCount.Text = "0";
            }
        }

        /// <summary>
        /// Returns number of rows with IS_ACTIVE = 1 for the given schema/table.
        /// Returns "0" if table doesn't exist or an error occurs.
        /// </summary>
        private string GetActiveCount(SqlConnection con, string schema, string table)
        {
            try
            {
                // Basic safety/whitelist so table names are not arbitrary
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

        /// <summary>
        /// Quick whitelist of allowed tables used by the dashboard.
        /// Add additional allowed schema.table values here if you expand the dashboard.
        /// </summary>
        private bool IsAllowedTable(string schema, string table)
        {
            if (string.IsNullOrWhiteSpace(schema) || string.IsNullOrWhiteSpace(table)) return false;

            // Normalized form: "TBL.Advisory"
            string full = $"{schema}.{table}".Trim();

            string[] allowed = new[]
            {
                "TBL.Advisory",
                "TBL.Speaker",
                "TBL.Exhibitor"
                // add more if needed
            };

            foreach (var a in allowed)
                if (string.Equals(a, full, StringComparison.OrdinalIgnoreCase))
                    return true;

            return false;
        }

        /// <summary>
        /// Checks existence of a schema-qualified table using OBJECT_ID('schema.table','U').
        /// Expects schema and table separately (no brackets).
        /// </summary>
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

        /// <summary>
        /// Safely checks the session entry "IsAdminLoggedIn" (handles bool or string values).
        /// </summary>
        private bool IsAdminLoggedIn()
        {
            if (Session == null) return false;
            var s = Session["IsAdminLoggedIn"];
            if (s == null) return false;
            if (s is bool b) return b;
            bool parsed;
            return bool.TryParse(s.ToString(), out parsed) && parsed;
        }

        /// <summary>
        /// Sets username and avatar label values from session.
        /// </summary>
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
                // Fallbacks
                lblUsername.Text = "Administrator";
                lblWelcomeUser.Text = "Administrator";
                lblUserInitial.Text = "A";
            }
        }

        #endregion
    }
}
