using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace Expo_Panel.Admin
{
    public partial class AdminLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 1. Check if ALREADY logged in
                if (Session["IsAdminLoggedIn"] != null && (bool)Session["IsAdminLoggedIn"])
                {
                    // 2. NOW check the role (only if logged in)
                    string role = Session["Role"] != null ? Session["Role"].ToString() : "Admin";

                    if (role == "SuperAdmin")
                    {
                        Response.Redirect("~/SuperAdmin/Dashboard.aspx", false);
                    }
                    else
                    {
                        // If they are logged in but NOT SuperAdmin (e.g. Team Admin),
                        // send them to the Team Dashboard or logout.
                        Response.Redirect("~/Admin/Dashboard.aspx", false);
                    }
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

                if (ValidateTeamAdmin(username, password))
                {
                    // Set specific TEAM ADMIN sessions
                    Session["IsTeamAdminLoggedIn"] = true; // This is the KEY key
                    Session["IsAuthenticated"] = true;     // General auth
                    Session["Role"] = "Admin";             // Force role to Admin
                    Session["AdminUsername"] = username;

                    // Redirect to the Team Dashboard (must exist in Admin folder)
                    Response.Redirect("Dashboard.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
                else
                {
                    ShowError("Invalid credentials or account is inactive.");
                    txtPassword.Text = string.Empty;
                    txtUsername.Focus();
                }
            }
        }

        private bool ValidateTeamAdmin(string username, string password)
        {
            bool isValid = false;
            string connectionString = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Query ensuring Role is 'Admin' (so SuperAdmins don't login here accidentally)
                    string query = @"
                        SELECT AdminID, IsActive 
                        FROM TBL.Admin 
                        WHERE Username = @Username 
                        AND Password = @Password 
                        AND Role = 'Admin'"; // <--- Ensures only Team Admins

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
                                if (isActive)
                                {
                                    Session["AdminID"] = reader.GetInt32(reader.GetOrdinal("AdminID"));
                                    isValid = true;
                                }
                                else
                                {
                                    ShowError("Account is inactive. Contact Super Admin.");
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("System error. Please try again.");
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