using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace Expo_Panel.Admin
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if already logged in
                if (Session["IsAdminLoggedIn"] != null && (bool)Session["IsAdminLoggedIn"])
                {
                    Response.Redirect("~/SuperAdmin/Dashboard.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                }

                // Set focus to username field
                txtUsername.Focus();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string username = txtUsername.Text.Trim();
                string password = txtPassword.Text.Trim();


                if (ValidateAdmin(username, password))
                {
                    // Set all required session variables
                    Session["AdminUsername"] = username;
                    Session["IsAdminLoggedIn"] = true;
                    Session["IsAuthenticated"] = true;

                    // Redirect to dashboard
                    Response.Redirect("~/SuperAdmin/Dashboard.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
                else
                {
                    ShowError("Invalid username or password. Please try again.");
                    txtPassword.Text = string.Empty;
                    txtUsername.Focus();
                }
            }
        }

        // *** REPLACE THIS FUNCTION IN Default.aspx.cs ***
        private bool ValidateAdmin(string username, string password)
        {
            bool isValid = false;
            string connectionString = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // This query now joins to TBL.Advisory to find the "bridge"
                    string query = @"
                SELECT 
                    a.AdminID, 
                    a.IsActive,
                    adv.AdvisorID AS LinkedAdvisorID,
                    adv.Name AS AdvisorName
                FROM 
                    TBL.Admin a
                LEFT JOIN 
                    TBL.Advisory adv ON a.AdminID = adv.LinkedAdminID AND adv.IS_ACTIVE = 1
                WHERE 
                    a.Username = @Username 
                    AND a.Password = @Password";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Password", password);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                bool isActive = reader.GetBoolean(reader.GetOrdinal("IsActive"));
                                int adminId = reader.GetInt32(reader.GetOrdinal("AdminID"));

                                if (isActive)
                                {
                                    Session["AdminID"] = adminId; // Standard Admin ID

                                    // *** NEW CODE (The "Bridge") ***
                                    // Check if we found a linked advisor profile
                                    if (reader["LinkedAdvisorID"] != DBNull.Value)
                                    {
                                        // This is your "Advisor Hat" session
                                        Session["AdminAdvisorID"] = Convert.ToInt32(reader["LinkedAdvisorID"]);
                                        Session["AdvisorUsername"] = reader["AdvisorName"].ToString();
                                        Session["IsAdvisorLoggedIn"] = true; // This is the key for the rating page
                                    }
                                    // *** END NEW CODE ***

                                    isValid = true;
                                }
                                else
                                {
                                    ShowError("Your account is inactive. Please contact administrator.");
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred during login. Please try again later.");
                System.Diagnostics.Debug.WriteLine($"Login Error: {ex.Message}");
            }

            return isValid;
        }

        private void ShowError(string message)
        {
            lblError.Text = message;
            pnlError.Visible = true;
        }
    }
}
