using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Web.UI;
using System.Net.Mime; // Required for AlternateView
using System.IO;       // Required for File.Exists
using System.Web;      // Required for HttpContext


namespace Expo_Panel
{
    public partial class VisitorLogin : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["VisitorID"] != null)
            {
                Response.Redirect("VisitorDashboard.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_VisitorLogin", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim()); // Ideally Hash this

                        con.Open();
                        SqlDataReader rdr = cmd.ExecuteReader();
                        if (rdr.Read())
                        {
                            Session["VisitorID"] = rdr["VisitorID"];
                            Session["VisitorName"] = rdr["FullName"];
                            Session["VisitorEmail"] = rdr["Email"];
                            Response.Redirect("VisitorDashboard.aspx");
                        }
                        else
                        {
                            litMessage.Text = "<div class='alert alert-danger'>Invalid Email or Password.</div>";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                litMessage.Text = $"<div class='alert alert-danger'>Error: {ex.Message}</div>";
            }
        }

        protected void lnkForgot_Click(object sender, EventArgs e)
        {
            pnlLogin.Visible = false;
            pnlVerify.Visible = true;
            litMessage.Text = "";
        }

        protected void lnkBackToLogin_Click(object sender, EventArgs e)
        {
            pnlLogin.Visible = true;
            pnlVerify.Visible = false;
            pnlOTP.Visible = false;
            pnlReset.Visible = false;
        }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            string email = txtResetEmail.Text.Trim();

            // Check DB
            bool exists = false;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                // Ensure this SP exists and returns 1 or true
                using (SqlCommand cmd = new SqlCommand("sp_ValidateVisitorEmailForReset", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Email", email);
                    con.Open();
                    // Assuming SP returns a bit/boolean
                    object result = cmd.ExecuteScalar();
                    exists = (result != null && Convert.ToBoolean(result));
                }
            }

            if (exists)
            {
                string otp = new Random().Next(100000, 999999).ToString();
                Session["ResetOTP"] = otp;
                Session["ResetEmail"] = email;

                // --- UPDATED EMAIL LOGIC ---
                string errorMsg = "";
                bool emailSent = SendOTPEmail(email, otp, out errorMsg);

                if (emailSent)
                {
                    pnlVerify.Visible = false;
                    pnlOTP.Visible = true;
                    litMessage.Text = "<div class='alert alert-success'>OTP sent successfully to " + email + "</div>";
                }
                else
                {
                    litMessage.Text = $"<div class='alert alert-danger'>Failed to send email: {errorMsg}</div>";
                }
            }
            else
            {
                litMessage.Text = "<div class='alert alert-danger'>Email not found in our records.</div>";
            }
        }

        protected void btnSubmitOTP_Click(object sender, EventArgs e)
        {
            if (txtOTP.Text == (string)Session["ResetOTP"])
            {
                pnlOTP.Visible = false;
                pnlReset.Visible = true;
                litMessage.Text = "";
            }
            else
            {
                litMessage.Text = "<div class='alert alert-danger'>Invalid OTP.</div>";
            }
        }

        protected void btnUpdatePass_Click(object sender, EventArgs e)
        {
            string email = (string)Session["ResetEmail"];
            string newPass = txtNewPass.Text.Trim();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateVisitorPasswordByEmail", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@NewPassword", newPass);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            Session["ResetEmail"] = null;
            Session["ResetOTP"] = null;

            pnlReset.Visible = false;
            pnlLogin.Visible = true;
            litMessage.Text = "<div class='alert alert-success'>Password updated! Please login.</div>";
        }

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

                // 3. Define HTML Body (Gold/Orange Theme for LUBEiNX)
                string imagePath = HttpContext.Current.Server.MapPath("~/Images/Expo_logo_Full.png");
                string emailBody = $@"
        <div style='font-family: Segoe UI, sans-serif; max-width: 600px; border: 1px solid #e0e0e0; margin: 0 auto;'>
            <div style='background-color: #2d2d2d; padding: 30px; text-align: center; border-bottom: 5px solid #dd6b20;'>
                <h2 style='color: #ffffff; margin: 0;'>VISITOR RESET</h2>
            </div>
            <div style='padding: 40px 30px; color: #4a5568;'>
                <p>Use the code below to reset your visitor account password:</p>
                <div style='text-align: center; margin: 35px 0;'>
                     <span style='font-family: Consolas, monospace; font-size: 42px; font-weight: bold; color: #dd6b20; letter-spacing: 8px;'>{otpCode}</span>
                </div>
                <p>If you did not request this, please ignore this email.</p>
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
                    EmailMsg.From = new MailAddress(smtpUser, "Lubricant India Expo"); // or "LUBEiNX Support"
                    EmailMsg.To.Add(new MailAddress(toEmail));
                    EmailMsg.Subject = "Visitor Password Reset Code";
                    EmailMsg.Priority = MailPriority.High;

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

                        // 6. SMTP Configuration (Uses Titan/Web.config settings)
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
                errorMsg = ex.Message;
                if (ex.InnerException != null)
                {
                    errorMsg += " | " + ex.InnerException.Message;
                }
                return false;
            }
        }
    }
}