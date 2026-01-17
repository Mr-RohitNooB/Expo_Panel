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

            // 1. Check Status specifically for "Exhibitor"
            int emailStatus = CheckEmailStatus(email, "Exhibitor");

            if (emailStatus == 1)
            {
                // --- CASE 1: Account is Valid (Approved & Active) ---

                // Generate OTP
                Random rnd = new Random();
                string otp = rnd.Next(100000, 999999).ToString();

                // Store in Session
                Session["ResetOTP"] = otp;
                Session["ResetEmail"] = email;

                // Send Email
                bool emailSent = SendOTPEmail(email, otp);

                if (emailSent)
                {
                    // Switch Panels
                    pnlVerify.Visible = false;
                    pnlOTP.Visible = true;
                    pnlReset.Visible = false;
                    ShowMessage("OTP sent successfully to " + email, "success");
                }
                else
                {
                    ShowMessage("Failed to send email. Check configuration.", "danger");
                }
            }
            else if (emailStatus == -1)
            {
                // --- CASE 2: Account exists but is Inactive or Not Approved ---
                ShowMessage("Account is not approved or inactive. Kindly contact the admin or wait for approval.", "info");
            }
            else
            {
                // --- CASE 3: Email does not exist in Exhibitor table ---
                ShowMessage("Email not found in Exhibitor records.", "danger");
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

        // 3. NEW: Helper function to send Email
        private bool SendOTPEmail(string toEmail, string otpCode)
        {
            try
            {
                // 1. Fetch Config Data
                string smtpHost = ConfigurationManager.AppSettings["SMTP_Host"];
                int smtpPort = int.Parse(ConfigurationManager.AppSettings["SMTP_Port"]);
                string smtpUser = ConfigurationManager.AppSettings["SMTP_User"];
                string smtpPass = ConfigurationManager.AppSettings["SMTP_Pass"];

                // 2. Ensure TLS 1.2 is used (Important for Gmail/Outlook/Titan)
                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12;

                // 3. Define Branding Colors (Change this Hex code to match your Exhibitor Page)
                string brandColor = "#ed8936 "; // <-- Change this to your specific Exhibitor page color
                string imagePath = HttpContext.Current.Server.MapPath("~/Images/Expo_logo_Full.png");

                // 4. Construct the Professional HTML Body
                string emailBody = $@"
<div style='font-family: Segoe UI, sans-serif; max-width: 600px; border: 1px solid #e0e0e0; margin: 0 auto;'>
    
    <div style='background-color: {brandColor}; padding: 30px; text-align: center;'>
        <h2 style='color: #ffffff; margin: 0; letter-spacing: 1px;'>PASSWORD RESET</h2>
    </div>

    <div style='padding: 40px 30px; color: #4a5568; background-color: #ffffff;'>
        <p style='font-size: 16px; margin-bottom: 20px;'>Hello,</p>
        <p style='font-size: 16px; line-height: 1.5;'>You requested a password reset for the <strong>Exhibitor Panel</strong>.</p>
        <p style='font-size: 16px; line-height: 1.5;'>Please use the verification code below to complete the process:</p>
        
        <div style='text-align: center; margin: 35px 0;'>
                <span style='font-family: Consolas, monospace; font-size: 42px; font-weight: bold; color: {brandColor}; letter-spacing: 8px; border: 2px dashed {brandColor}; padding: 10px 20px; border-radius: 5px;'>{otpCode}</span>
        </div>

        <p style='font-size: 14px; color: #718096;'>This code is valid for a limited time. If you did not request this, please ignore this email.</p>
    </div>

    <div style='background-color: #f8f9fa; padding: 0px 20px 20px 20px; text-align: center; border-top: 1px solid #e0e0e0;'>
        
        <img src='cid:ExpoLogo' 
             alt='Lubricant India Expo' 
             style='display: block; width: 400px; height: auto; margin: 0 auto; border: 0;' />
        <p style='font-size: 12px; color: #a0aec0; margin-top: 0px; margin-bottom: 0;'>&copy; 2026 Lubricant India Expo. All rights reserved.</p>
    </div>
</div>";

                // 5. Construct the Message
                using (MailMessage EmailMsg = new MailMessage())
                {
                    EmailMsg.From = new MailAddress(smtpUser, "Lubricant India Expo 2026");
                    EmailMsg.To.Add(new MailAddress(toEmail));
                    EmailMsg.Subject = "Exhibitor Panel Reset Code";
                    EmailMsg.Priority = MailPriority.Normal;

                    // 6. Embed the Image and Attach HTML
                    using (AlternateView htmlView = AlternateView.CreateAlternateViewFromString(emailBody, null, MediaTypeNames.Text.Html))
                    {
                        if (File.Exists(imagePath))
                        {
                            LinkedResource logo = new LinkedResource(imagePath, "image/png");
                            logo.ContentId = "ExpoLogo"; // Matches src='cid:ExpoLogo'
                            htmlView.LinkedResources.Add(logo);
                        }

                        EmailMsg.AlternateViews.Add(htmlView);
                        EmailMsg.IsBodyHtml = true;

                        // 7. Send
                        using (SmtpClient MailClient = new SmtpClient(smtpHost, smtpPort))
                        {
                            MailClient.Credentials = new NetworkCredential(smtpUser, smtpPass);
                            MailClient.EnableSsl = true;
                            MailClient.Send(EmailMsg);
                        }
                    }
                }

                return true;
            }
            catch (Exception ex)
            {
                // Optional: Log error
                // System.Diagnostics.Debug.WriteLine(ex.Message);
                return false;
            }
        }
        protected void btnUpdatePass_Click(object sender, EventArgs e)
        {
            string newPass = txtNewPass.Text.Trim();

            // --- FIX START: Change ViewState to Session ---
            string email = Session["ResetEmail"] as string;
            // --- FIX END ---

            if (string.IsNullOrEmpty(email))
            {
                ShowMessage("Session expired. Please start over.", "danger");
                lnkBackToLogin_Click(sender, e);
                return;
            }

            try
            {
                // For ExhibitorLogin.aspx.cs use "Exhibitor"
                // For SpeakerLogin.aspx.cs use "Speaker"
                string userType = (this is ExhibitorLogin) ? "Exhibitor" : "Speaker";

                UpdatePassword(email, userType, newPass);

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

                // Clear session for security
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
                // This calls the updated Stored Procedure that checks IS_ACTIVE and ApprovalStatus
                using (SqlCommand cmd = new SqlCommand("sp_ValidateEmailForReset", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserType", userType);

                    con.Open();

                    // ExecuteScalar gets the status code from SQL:
                    // 1  = Valid (Approved & Active)
                    // -1 = Invalid (Pending/Rejected or Inactive)
                    // 0  = Not Found
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