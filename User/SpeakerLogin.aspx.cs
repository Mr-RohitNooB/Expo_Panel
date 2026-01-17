using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Net.Mime; // Required for AlternateView
using System.IO;       // Required to check if file exists
using System.Web;      // Required for Server.MapPath

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

            // 1. Check status for "Speaker" (Not Exhibitor)
            int emailStatus = CheckEmailStatus(email, "Speaker");

            if (emailStatus == 1)
            {
                // --- SCENARIO 1: User is Valid ---

                // Generate OTP
                Random rnd = new Random();
                string otp = rnd.Next(100000, 999999).ToString();

                // Store in Session
                Session["ResetOTP"] = otp;
                Session["ResetEmail"] = email;

                // Prepare variable to catch error
                string technicalError = "";

                // Send Email (Pass 3 arguments: email, otp, out technicalError)
                bool emailSent = SendOTPEmail(email, otp, out technicalError);

                if (emailSent)
                {
                    // Success
                    pnlVerify.Visible = false;
                    pnlOTP.Visible = true;
                    pnlReset.Visible = false;
                    ShowMessage("OTP sent successfully to " + email, "success");
                }
                else
                {
                    // Failure - Show the specific error from the server
                    ShowMessage("Failed: " + technicalError, "danger");
                }
            }
            else if (emailStatus == -1)
            {
                // --- SCENARIO 2: Inactive / Not Approved ---
                ShowMessage("Account is not approved or inactive.", "info");
            }
            else
            {
                // --- SCENARIO 3: Not Found ---
                ShowMessage("Email not found.", "danger");
            }
        }

        protected void btnSubmitOTP_Click(object sender, EventArgs e)
        {
            string enteredOTP = txtOTP.Text.Trim();
            string sessionOTP = Session["ResetOTP"] as string;

            if (!string.IsNullOrEmpty(sessionOTP) && enteredOTP == sessionOTP)
            {
                // Success! Flow: OTP Panel -> Reset Password Panel
                pnlOTP.Visible = false;
                pnlReset.Visible = true;
                ShowMessage("OTP Verified. Please set a new password.", "success");

                // Security: Clear OTP so it can't be used again
                Session["ResetOTP"] = null;
            }
            else
            {
                ShowMessage("Invalid or expired OTP.", "danger");
            }
        }

        // 3. NEW: Helper function to send Email using Hostinger
        public bool SendOTPEmail(string toEmail, string otpCode, out string errorMsg)
        {
            errorMsg = "";
            try
            {
                // 1. Fetch Config Data (Securely from Web.config)
                string smtpHost = ConfigurationManager.AppSettings["SMTP_Host"];
                int smtpPort = int.Parse(ConfigurationManager.AppSettings["SMTP_Port"]);
                string smtpUser = ConfigurationManager.AppSettings["SMTP_User"];
                string smtpPass = ConfigurationManager.AppSettings["SMTP_Pass"];

                // 2. Force TLS 1.2 for security
                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12;

                // 3. Define HTML Body
                string imagePath = HttpContext.Current.Server.MapPath("~/Images/Expo_logo_Full.png");
                string emailBody = $@"
        <div style='font-family: Segoe UI, sans-serif; max-width: 600px; border: 1px solid #e0e0e0; margin: 0 auto;'>
            <div style='background-color: #2d2d2d; padding: 30px; text-align: center; border-bottom: 5px solid #dd6b20;'>
                <h2 style='color: #ffffff; margin: 0;'>PASSWORD RESET</h2>
            </div>
            <div style='padding: 40px 30px; color: #4a5568;'>
                <p>Use the code below to complete the process:</p>
                <div style='text-align: center; margin: 35px 0;'>
                     <span style='font-family: Consolas, monospace; font-size: 42px; font-weight: bold; color: #dd6b20; letter-spacing: 8px;'>{otpCode}</span>
                </div>
            </div>
            <div style='background-color: #f8f9fa; padding: 15px; text-align: center; border-top: 1px solid #e0e0e0;'>
                    <img src='cid:ExpoLogo' 
             alt='Lubricant India Expo' 
             style='display: block; width: 400px; height: auto; margin: 0 auto; border: 0;' />
               <p style='font-size:11px;color:#a0aec0;'>© 2026 Lubricant India Expo</p>
            </div>
        </div>";

                // 4. Create Email Message
                using (MailMessage EmailMsg = new MailMessage())
                {
                    EmailMsg.From = new MailAddress(smtpUser, "Lubricant India Expo");
                    EmailMsg.To.Add(new MailAddress(toEmail));
                    EmailMsg.Subject = "Your Reset Code";
                    EmailMsg.Priority = MailPriority.Normal;

                    // 5. Embed Image Logic
                    using (AlternateView htmlView = AlternateView.CreateAlternateViewFromString(emailBody, null, MediaTypeNames.Text.Html))
                    {
                        if (File.Exists(imagePath))
                        {
                            LinkedResource logo = new LinkedResource(imagePath, "image/png");
                            logo.ContentId = "ExpoLogo";
                            htmlView.LinkedResources.Add(logo);
                        }

                        EmailMsg.AlternateViews.Add(htmlView);
                        EmailMsg.IsBodyHtml = true;

                        // 6. SMTP Configuration (Secure)
                        using (SmtpClient MailClient = new SmtpClient(smtpHost, smtpPort))
                        {
                            MailClient.Credentials = new NetworkCredential(smtpUser, smtpPass);
                            MailClient.EnableSsl = true; // Required for Titan/Gmail/etc.
                            MailClient.Send(EmailMsg);
                        }
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                errorMsg = ex.Message;
                if (ex.InnerException != null)
                {
                    errorMsg += " | " + ex.InnerException.Message;
                }
                return false;
            }
        }

        // 4. Logic: Update the password in database
        protected void btnUpdatePass_Click(object sender, EventArgs e)
        {
            string newPass = txtNewPass.Text.Trim();
            string email = Session["ResetEmail"] as string;

            if (string.IsNullOrEmpty(email))
            {
                ShowMessage("Session expired. Please start over.", "danger");
                lnkBackToLogin_Click(sender, e);
                return;
            }

            try
            {
                // Explicitly set to "Speaker" for this page
                UpdatePassword(email, "Speaker", newPass);

                // Success! Go back to login screen
                pnlLogin.Visible = true;
                pnlVerify.Visible = false;
                pnlReset.Visible = false;

                // Auto-fill the email field
                txtEmail.Text = email;

                // Clear fields and session
                txtResetEmail.Text = "";
                txtNewPass.Text = "";
                txtConfirmPass.Text = "";
                Session["ResetEmail"] = null;

                ShowMessage("Password updated successfully! Please login.", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }


        private int CheckEmailStatus(string email, string userType)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                // Use the updated Stored Procedure
                using (SqlCommand cmd = new SqlCommand("sp_ValidateEmailForReset", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserType", userType);
                    con.Open();

                    // ExecuteScalar returns the first column (@Status) from our SP
                    // 1 = Valid, -1 = Not Approved/Inactive, 0 = Not Found
                    object result = cmd.ExecuteScalar();
                    return (result != null) ? Convert.ToInt32(result) : 0;
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
