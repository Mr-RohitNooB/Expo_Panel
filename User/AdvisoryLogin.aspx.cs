using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Expo_Panel.Admin
{
    // Note: The class name "AdvisoryLogin" must match the 'Inherits' tag in the ASPX file
    public partial class AdvisoryLogin : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Clear any old sessions
                Session.Clear();

                // Check if already logged in as an ADVISOR
                if (Session["IsAdvisorLoggedIn"] != null && (bool)Session["IsAdvisorLoggedIn"])
                {
                    Response.Redirect("~/User/AdvisoryRatingDashboard.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
                txtUsername.Focus();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string email = txtUsername.Text.Trim(); // This is the Email
                string password = txtPassword.Text.Trim();

                int advisorId;
                string advisorName;

                // We use your existing stored procedure!
                if (ValidateAdvisor(email, password, out advisorId, out advisorName))
                {
                    // Set NEW, DISTINCT session variables for Advisors
                    Session["AdvisorID"] = advisorId;
                    Session["AdvisorUsername"] = advisorName;
                    Session["IsAdvisorLoggedIn"] = true;
                    Session["IsAuthenticated"] = true; // You can use this if other pages just check this

                    // Redirect to the rating dashboard
                    Response.Redirect("~/User/AdvisoryRatingDashboard.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
                else
                {
                    ShowError("Invalid email or password. Please try again.");
                    txtPassword.Text = string.Empty;
                    txtUsername.Focus();
                }
            }
        }

        private bool ValidateAdvisor(string email, string password, out int advisorId, out string advisorName)
        {
            advisorId = 0;
            advisorName = string.Empty;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    // Using your existing procedure
                    using (SqlCommand cmd = new SqlCommand("sp_ValidateAdvisoryLogin", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@Email", email); // Your SP uses @Email
                        cmd.Parameters.AddWithValue("@Password", password);


                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Your SP already checks for IS_ACTIVE and ApprovalStatus
                                advisorId = Convert.ToInt32(reader["AdvisorID"]);
                                advisorName = reader["Name"].ToString();
                                return true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred during login. Please try again later.");
                System.Diagnostics.Debug.WriteLine($"Advisory Login Error: {ex.Message}");
            }

            return false;
        }

        private void ShowError(string message)
        {
            lblError.Text = message;
            pnlError.Visible = true;
        }
    }
}