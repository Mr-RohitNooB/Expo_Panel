using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Expo_Panel
{
    public partial class ExhibitorLogin : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // If they are already logged in, send them directly to the Dashboard
                if (Session["ExhibitorID"] != null)
                {
                    Response.Redirect("ExhibitorDashboard.aspx"); // <--- CHANGED FROM PostApprovalExhibitor.aspx
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            try
            {
                ValidateExhibitorLogin(email, password);
            }
            catch (Exception ex)
            {
                ShowMessage(ex.Message, "danger");
            }
        }

        private void ValidateExhibitorLogin(string email, string password)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_ValidateExhibitorLogin", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);

                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Login successful, check status
                            string approvalStatus = reader["ApprovalStatus"].ToString();
                            int exhibitorId = Convert.ToInt32(reader["ExhibitorID"]);

                            if (approvalStatus == "Approved")
                            {
                                // Success! Create session and redirect to DASHBOARD.
                                Session["ExhibitorID"] = exhibitorId;
                                Response.Redirect("ExhibitorDashboard.aspx"); // <--- CHANGED HERE
                            }
                            else if (approvalStatus == "Pending")
                            {
                                throw new Exception("Your registration is still pending approval.");
                            }
                            else if (approvalStatus == "Rejected")
                            {
                                throw new Exception("Your registration has been rejected. Please contact support.");
                            }
                        }
                        else
                        {
                            // No user found
                            throw new Exception("Invalid email or password.");
                        }
                    }
                }
            }
        }

        protected void lnkForgot_Click(object sender, EventArgs e)
        {
            pnlLogin.Visible = false;
            pnlVerify.Visible = true;
            pnlReset.Visible = false;
            litMessage.Text = ""; // Clear any old errors
        }

        protected void lnkBackToLogin_Click(object sender, EventArgs e)
        {
            pnlLogin.Visible = true;
            pnlVerify.Visible = false;
            pnlReset.Visible = false;
            litMessage.Text = "";
        }

        // 3. Logic: Verify if email exists
        protected void btnVerify_Click(object sender, EventArgs e)
        {
            string email = txtResetEmail.Text.Trim();

            if (CheckEmailExists(email, "Exhibitor")) // Passing "Exhibitor" type
            {
                // Success: Store email temporarily to use in the next step
                ViewState["ResetEmail"] = email;

                pnlVerify.Visible = false;
                pnlReset.Visible = true; // Show password fields
                litMessage.Text = "";
            }
            else
            {
                ShowMessage("Email not found in Exhibitor records.", "danger");
            }
        }

        protected void btnUpdatePass_Click(object sender, EventArgs e)
        {
            string newPass = txtNewPass.Text.Trim();
            string email = ViewState["ResetEmail"] as string;

            if (string.IsNullOrEmpty(email))
            {
                ShowMessage("Session expired. Please start over.", "danger");
                lnkBackToLogin_Click(sender, e);
                return;
            }

            try
            {
                UpdatePassword(email, "Exhibitor", newPass); // Passing "Exhibitor" type

                // Success! Go back to login screen
                pnlLogin.Visible = true;
                pnlVerify.Visible = false;
                pnlReset.Visible = false;

                // Auto-fill the email field for convenience
                txtEmail.Text = email;

                // Clear reset fields
                txtResetEmail.Text = "";
                txtNewPass.Text = "";
                txtConfirmPass.Text = "";

                ShowMessage("Password updated successfully! Please login.", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }
        private bool CheckEmailExists(string email, string userType)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_ValidateEmailForReset", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserType", userType);
                    con.Open();
                    return Convert.ToBoolean(cmd.ExecuteScalar());
                }
            }
        }

        private void UpdatePassword(string email, string userType, string password)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdatePasswordByEmail", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserType", userType);
                    cmd.Parameters.AddWithValue("@NewPassword", password);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
        private void ShowMessage(string message, string type)
        {
            litMessage.Text = $@"
                <div class='alert alert-{type}'>
                    {message}
                </div>";
        }
    }
}