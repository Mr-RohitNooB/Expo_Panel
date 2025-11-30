using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Data;

namespace Expo_Panel
{
    public partial class SpeakerLogin : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if speaker is already logged in
                if (Session["IsSpeakerLoggedIn"] != null && (bool)Session["IsSpeakerLoggedIn"])
                {
                    Response.Redirect("SpeakerDashboard.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text.Trim();

                int speakerId = AuthenticateSpeaker(email, password);

                if (speakerId > 0)
                {
                    var speakerDetails = GetSpeakerDetails(speakerId);
                    if (speakerDetails != null)
                    {
                        Session["IsSpeakerLoggedIn"] = true;
                        Session["SpeakerID"] = speakerId;
                        Session["SpeakerName"] = speakerDetails.Name;
                        Session["SpeakerEmail"] = speakerDetails.Email;
                        Session["SpeakerApprovalStatus"] = speakerDetails.ApprovalStatus;

                        Response.Redirect("SpeakerDashboard.aspx", false);
                        Context.ApplicationInstance.CompleteRequest();
                    }
                    else
                    {
                        ShowMessage("Unable to retrieve speaker details.", "danger");
                    }
                }
                else
                {
                    ShowMessage("Invalid email or password.", "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Login error: " + ex.Message, "danger");
            }
        }


        private int AuthenticateSpeaker(string email, string password)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = @"SELECT SpeakerID, ApprovalStatus FROM TBL.Speaker WHERE Email = @Email AND Password = @Password AND IS_ACTIVE = 1";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        if (reader["ApprovalStatus"].ToString() != "Approved")
                        {
                            ShowMessage("Your account is not yet approved.", "info");
                            return 0;
                        }
                        return Convert.ToInt32(reader["SpeakerID"]);
                    }
                    return 0;
                }
            }
        }

        private SpeakerInfo GetSpeakerDetails(int speakerId)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = "SELECT SpeakerID, Name, Email, ApprovalStatus FROM TBL.Speaker WHERE SpeakerID = @SpeakerID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        return new SpeakerInfo
                        {
                            SpeakerID = Convert.ToInt32(reader["SpeakerID"]),
                            Name = reader["Name"].ToString(),
                            Email = reader["Email"].ToString(),
                            ApprovalStatus = reader["ApprovalStatus"].ToString()
                        };
                    }
                    return null;
                }
            }
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "success" ? "alert-success" : type == "info" ? "alert-info" : "alert-danger";
            string icon = type == "success" ? "fa-check-circle" : type == "info" ? "fa-info-circle" : "fa-exclamation-circle";
            litMessage.Text = $"<div class='alert {cssClass}'><i class='fas {icon}'></i> <span>{message}</span></div>";
        }

        protected void lnkForgot_Click(object sender, EventArgs e)
        {
            // Switch to Verify View
            pnlLogin.Visible = false;
            pnlVerify.Visible = true;
            pnlReset.Visible = false;
            litMessage.Text = ""; // Clear errors
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

            if (CheckEmailExists(email, "Speaker"))
            {
                ViewState["ResetEmail"] = email;
                pnlVerify.Visible = false;
                pnlReset.Visible = true;
                litMessage.Text = "";
            }
            else
            {
                ShowMessage("Email not found in Speaker records.", "danger");
            }
        }

        // 4. Logic: Update the password in database
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
                UpdatePassword(email, "Speaker", newPass);

                pnlLogin.Visible = true;
                pnlVerify.Visible = false;
                pnlReset.Visible = false;

                txtEmail.Text = email;
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

        // --- ADD THESE NEW HELPER METHODS ---

        private bool CheckEmailExists(string email, string userType)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_ValidateEmailForReset", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure; // <--- NEEDS System.Data
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
                    cmd.CommandType = CommandType.StoredProcedure; // <--- NEEDS System.Data
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserType", userType);
                    cmd.Parameters.AddWithValue("@NewPassword", password);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // Helper class for speaker info
        private class SpeakerInfo
        {
            public int SpeakerID { get; set; }
            public string Name { get; set; }
            public string Email { get; set; }
            public string ApprovalStatus { get; set; }
        }
    }
}
