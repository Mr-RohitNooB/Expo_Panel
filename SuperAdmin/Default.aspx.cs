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
                // 1. If already logged in, redirect immediately based on role
                if (Session["IsAdminLoggedIn"] != null && (bool)Session["IsAdminLoggedIn"])
                {
                    RedirectBasedOnRole();
                }
                txtUsername.Focus();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string username = txtUsername.Text.Trim();
                string password = txtPassword.Text.Trim();

                // 2. ValidateAdmin now handles ALL Session setting (Role, ID, etc.)
                if (ValidateAdmin(username, password))
                {
                    // 3. Login Success -> Route to correct dashboard
                    RedirectBasedOnRole();
                }
                else
                {
                    ShowError("Invalid username or password. Please try again.");
                    txtPassword.Text = string.Empty;
                    txtUsername.Focus();
                }
            }
        }

        // Helper function to handle routing logic in one place
        private void RedirectBasedOnRole()
        {
            string role = Session["Role"] != null ? Session["Role"].ToString() : "Admin";

            if (role == "SuperAdmin")
            {
                Response.Redirect("~/SuperAdmin/Dashboard.aspx", false);
            }
            else
            {
                Session["IsTeamAdminLoggedIn"] = true; // Required for Admin folder
                Response.Redirect("~/Admin/Dashboard.aspx", false);
            }
            Context.ApplicationInstance.CompleteRequest();
        }

        private bool ValidateAdmin(string username, string password)
        {
            bool isValid = false;
            string connectionString = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            a.AdminID, 
                            a.IsActive,
                            a.Role, 
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
                                    // --- SET SESSIONS HERE (While Reader is Open) ---
                                    Session["AdminID"] = adminId;
                                    Session["AdminUsername"] = username;
                                    Session["IsAdminLoggedIn"] = true;
                                    Session["IsAuthenticated"] = true;

                                    // SAVE THE ROLE
                                    string role = reader["Role"] != DBNull.Value ? reader["Role"].ToString() : "Admin";
                                    Session["Role"] = role;

                                    // Bridge for Advisor
                                    if (reader["LinkedAdvisorID"] != DBNull.Value)
                                    {
                                        Session["AdminAdvisorID"] = Convert.ToInt32(reader["LinkedAdvisorID"]);
                                        Session["AdvisorUsername"] = reader["AdvisorName"].ToString();
                                        Session["IsAdvisorLoggedIn"] = true;
                                    }

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
                ShowError("An error occurred during login.");
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