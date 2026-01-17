using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Web;
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
                    ShowMessage("Invalid email or password. Please try again.", "error");
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
                ShowMessage("An error occurred during login. Please try again later.", "error");
                System.Diagnostics.Debug.WriteLine($"Advisory Login Error: {ex.Message}");
            }

            return false;
        }

        // --- UI & Navigation Helpers ---

        protected void lnkForgot_Click(object sender, EventArgs e)
        {
            pnlLogin.Visible = false;
            pnlVerify.Visible = true;
            pnlOTP.Visible = false;
            pnlReset.Visible = false;
            litMessage.Text = "";
        }

        protected void lnkBackToLogin_Click(object sender, EventArgs e)
        {
            pnlLogin.Visible = true;
            pnlVerify.Visible = false;
            pnlOTP.Visible = false;
            pnlReset.Visible = false;
            litMessage.Text = "";
        }

        private void ShowMessage(string message, string type)
        {
            // Maps "danger" to "error" style in your CSS
            string cssClass = type == "success" ? "alert-success" : type == "info" ? "alert-info" : "alert-error";
            string icon = type == "success" ? "fa-check-circle" : type == "info" ? "fa-info-circle" : "fa-exclamation-triangle";

            // This uses the NEW litMessage control we added to the HTML
            litMessage.Text = $@"
            <div class='alert {cssClass}'>
                <div class='alert-icon'><i class='fas {icon}'></i></div>
                <span>{message}</span>
            </div>";
        }

        // --- Step 1: Verify Email ---

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            string email = txtResetEmail.Text.Trim();

            // Check specifically for "Advisor"
            int emailStatus = CheckEmailStatus(email, "Advisor");

            if (emailStatus == 1)
            {
                Random rnd = new Random();
                string otp = rnd.Next(100000, 999999).ToString();

                Session["ResetOTP"] = otp;
                Session["ResetEmail"] = email;

                string errorMsg = "";
                if (SendOTPEmail(email, otp, out errorMsg))
                {
                    pnlVerify.Visible = false;
                    pnlOTP.Visible = true;
                    ShowMessage("OTP sent successfully to " + email, "success");
                }
                else
                {
                    ShowMessage("Failed to send email: " + errorMsg, "danger");
                }
            }
            else if (emailStatus == -1)
            {
                ShowMessage("Account exists but is inactive or not approved.", "info");
            }
            else
            {
                ShowMessage("Email not found in Advisory records.", "danger");
            }
        }

        // --- Step 2: Verify OTP ---

        protected void btnSubmitOTP_Click(object sender, EventArgs e)
        {
            string enteredOTP = txtOTP.Text.Trim();
            string sessionOTP = Session["ResetOTP"] as string;

            if (!string.IsNullOrEmpty(sessionOTP) && enteredOTP == sessionOTP)
            {
                pnlOTP.Visible = false;
                pnlReset.Visible = true;
                ShowMessage("OTP Verified. Set your new password.", "success");
                Session["ResetOTP"] = null; // Clear OTP for security
            }
            else
            {
                ShowMessage("Invalid or expired OTP.", "danger");
            }
        }

        // --- Step 3: Update Password ---

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
                // Update password specifically for "Advisor"
                UpdatePassword(email, "Advisor", newPass);

                // Reset UI to login
                pnlLogin.Visible = true;
                pnlReset.Visible = false;

                // Clear fields
                txtUsername.Text = email;
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

        // --- Database Logic ---

        private int CheckEmailStatus(string email, string userType)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_ValidateEmailForReset", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserType", userType);
                    con.Open();
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

        // --- Email Logic (Secure) ---

        public bool SendOTPEmail(string toEmail, string otpCode, out string errorMsg)
        {
            errorMsg = "";
            try
            {
                // Read from Web.config
                string smtpHost = ConfigurationManager.AppSettings["SMTP_Host"];
                int smtpPort = int.Parse(ConfigurationManager.AppSettings["SMTP_Port"]);
                string smtpUser = ConfigurationManager.AppSettings["SMTP_User"];
                string smtpPass = ConfigurationManager.AppSettings["SMTP_Pass"];

                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12;
                string imagePath = HttpContext.Current.Server.MapPath("~/Images/Expo_logo_Full.png");

                // Advisory specific email body
                string emailBody = $@"
                <div style='font-family: Segoe UI, sans-serif; max-width: 600px; border: 1px solid #e0e0e0; margin: 0 auto;'>
                    <div style='background-color: #667eea; padding: 30px; text-align: center;'>
                        <h2 style='color: #ffffff; margin: 0;'>PASSWORD RESET</h2>
                    </div>
                    <div style='padding: 40px 30px; color: #4a5568;'>
                        <p>You requested a password reset for the <strong>Advisory Panel</strong>.</p>
                        <p>Use the code below to complete the process:</p>
                        <div style='text-align: center; margin: 35px 0;'>
                             <span style='font-family: Consolas, monospace; font-size: 42px; font-weight: bold; color: #667eea; letter-spacing: 8px;'>{otpCode}</span>
                        </div>
                    </div>
                    <div style='background-color: #f8f9fa; padding: 15px; text-align: center; border-top: 1px solid #e0e0e0;'>
                             <img src='cid:ExpoLogo' 
             alt='Lubricant India Expo' 
             style='display: block; width: 400px; height: auto; margin: 0 auto; border: 0;' />
                    </div>
                </div>";

                using (MailMessage EmailMsg = new MailMessage())
                {
                    EmailMsg.From = new MailAddress(smtpUser, "Lubricant India Expo");
                    EmailMsg.To.Add(new MailAddress(toEmail));
                    EmailMsg.Subject = "Advisory Panel Reset Code";
                    EmailMsg.Priority = MailPriority.Normal;

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
                errorMsg = ex.Message + (ex.InnerException != null ? " | " + ex.InnerException.Message : "");
                return false;
            }
        }

    }
}