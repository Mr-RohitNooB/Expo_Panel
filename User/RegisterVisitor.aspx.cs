using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Net.Mime; // Required for AlternateView and LinkedResource
using System.IO;       // Required to check if file exists
using System.Web;      // Required for Server.MapPath;

namespace Expo_Panel
{
    public partial class RegisterVisitor : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Nothing needed here for load
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // 1. Validation
            if (!chkConsent.Checked)
            {
                ShowMessage("Please agree to the Consent Terms & Conditions.", "danger");
                return;
            }

            try
            {
                // 2. Gather Data
                string ticketType = ddlTicket.SelectedValue;
                string fullName = txtName.Text.Trim();
                string jobTitle = txtJob.Text.Trim();
                string email = txtEmail.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                string company = txtCompany.Text.Trim();
                string address = txtAddress.Text.Trim();
                string city = txtCity.Text.Trim();
                string state = txtState.Text.Trim();
                string country = txtCountry.Text.Trim();
                string pinCode = txtPin.Text.Trim();
                string jobFunction = ddlJobFunction.SelectedValue;
                string natureOfBusiness = ddlNature.SelectedValue;

                // Gather Checkbox Lists
                string purpose = GetSelectedItems(chkPurpose);
                string products = GetSelectedItems(chkProducts);

                // 3. Generate Password & Set Status
                string autoPassword = GeneratePassword(8);
                string status = "Approved"; // Auto-approve

                // 4. Save to Database
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_RegisterVisitor", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.AddWithValue("@TicketType", ticketType);
                        cmd.Parameters.AddWithValue("@FullName", fullName);
                        cmd.Parameters.AddWithValue("@JobTitle", jobTitle);
                        cmd.Parameters.AddWithValue("@CompanyName", company);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Mobile", mobile);
                        cmd.Parameters.AddWithValue("@Address", address);
                        cmd.Parameters.AddWithValue("@City", city);
                        cmd.Parameters.AddWithValue("@State", state);
                        cmd.Parameters.AddWithValue("@Country", country);
                        cmd.Parameters.AddWithValue("@PinCode", pinCode);
                        cmd.Parameters.AddWithValue("@JobFunction", jobFunction);
                        cmd.Parameters.AddWithValue("@NatureOfBusiness", natureOfBusiness);
                        cmd.Parameters.AddWithValue("@PurposeOfVisit", purpose);
                        cmd.Parameters.AddWithValue("@ProductInterest", products);

                        // Auto-Approval Logic
                        cmd.Parameters.AddWithValue("@ApprovalStatus", status);
                        cmd.Parameters.AddWithValue("@IsActive", 1);
                        cmd.Parameters.AddWithValue("@Password", autoPassword); // Save the generated password

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // 5. Send Emails
                // Admin gets a notification
                SendAdminNotification(fullName, company, email, ticketType);

                // User gets the "Approved" email with credentials
                SendUserAcknowledgement(fullName, email, autoPassword);

                // 6. Success Message & Reset
                ShowMessage("Registration Approved! Check your email for login details.", "success");
                ClearForm();
            }
            catch (SqlException ex)
            {
                if (ex.Message.Contains("UNIQUE KEY") || ex.Message.Contains("Email"))
                {
                    ShowMessage("This email is already registered.", "danger");
                }
                else
                {
                    ShowMessage("Database Error: " + ex.Message, "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        // --- Helper Methods ---

        private string GeneratePassword(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#";
            Random random = new Random();
            return new string(Enumerable.Repeat(chars, length).Select(s => s[random.Next(s.Length)]).ToArray());
        }

        private string GetSelectedItems(CheckBoxList list)
        {
            List<string> selected = new List<string>();
            foreach (ListItem item in list.Items)
            {
                if (item.Selected) selected.Add(item.Value);
            }
            return string.Join(", ", selected);
        }

        private void SendAdminNotification(string name, string company, string email, string ticket)
        {
            string subject = "New Visitor Registered (Auto-Approved): " + company;
            string body = string.Format(@"
                <div style='font-family: Arial, sans-serif; color: #333;'>
                    <h3>New Visitor Registration</h3>
                    <p><strong>Name:</strong> {0}</p>
                    <p><strong>Company:</strong> {1}</p>
                    <p><strong>Email:</strong> {2}</p>
                    <p><strong>Ticket Type:</strong> {3}</p>
                    <p style='color:green;'><strong>Status:</strong> Approved Automatically</p>
                </div>",
                name, company, email, ticket);

            SendEmail("admin@lubricantindia.com", subject, body);
            //SendEmail("rohitchauhaninfo@gmail.com", subject, body);
        }

        private void SendUserAcknowledgement(string name, string email, string password)
        {
            // 1. Setup Configuration & Paths
            string smtpHost = ConfigurationManager.AppSettings["SMTP_Host"];
            int smtpPort = Convert.ToInt32(ConfigurationManager.AppSettings["SMTP_Port"]);
            string smtpUser = ConfigurationManager.AppSettings["SMTP_User"];
            string smtpPass = ConfigurationManager.AppSettings["SMTP_Pass"];
            string imagePath = Server.MapPath("~/Images/Expo_logo_Full.png");
            string loginUrl = Request.Url.Scheme + "://" + Request.Url.Authority + "/User/VisitorLogin.aspx";

            if (string.IsNullOrEmpty(smtpHost) || string.IsNullOrEmpty(smtpUser)) return;

            // 2. Define Calendar Event Details
            string eventStart = "20260910T043000Z"; // UTC: Sept 10 10:00 AM IST
            string eventEnd = "20260912T123000Z"; // UTC: Sept 12 06:00 PM IST
            string eventName = "LUBEiNX - LUBRICANT INDIA EXPO 2026";
            string location = "Bharat Mandapam, Pragati Maidan, New Delhi";
            string mapLink = "https://maps.app.goo.gl/8ANvB29YDhRzKsgp6";
            string descText = "Opening Times:\\nThu, Sept 10: 10:00 AM – 6:30 PM\\nFri, Sept 11: 10:00 AM – 6:30 PM\\nSat, Sept 12: 10:00 AM – 6:00 PM\\n\\nContacts:\\nBooth Bookings: Amit Gautam (sales@lubricantindia.com)\\nSpeaking: Hema Sharma (confex@lubricantindia.com)\\nSponsorship: Shubham Kumar (partner@lubricantindia.com)";

            // 3. JSON-LD Script (Gmail Silent Integration)
            string jsonLd = $@"
    <script type='application/ld+json'>
    {{
        ""@context"": ""http://schema.org"",
        ""@type"": ""Event"",
        ""name"": ""{eventName}"",
        ""startDate"": ""2026-09-10T10:00:00+05:30"",
        ""endDate"": ""2026-09-12T18:00:00+05:30"",
        ""location"": {{
        ""@type"": ""Place"",
        ""name"": ""Bharat Mandapam"",
        ""hasMap"": ""{mapLink}"",
        ""address"": {{
            ""@type"": ""PostalAddress"",
            ""streetAddress"": ""Pragati Maidan"",
            ""addressLocality"": ""New Delhi"",
            ""addressCountry"": ""IN""
        }}
        }},
        ""description"": ""{descText.Replace("\\n", " ")}"",
        ""organizer"": {{
        ""@type"": ""Organization"",
        ""name"": ""Lubricant India Expo"",
        ""email"": ""sales@lubricantindia.com""
        }}
    }}
    </script>";

            // 4. Create HTML Body Content (Preserving your styling)
            string contentBody = string.Format(@"
        <div style='font-family: ""Poppins"", Arial, sans-serif; color: #1f2937; line-height: 1.6; max-width: 600px; background-color: #ffffff; border: 1px solid #e5e7eb; border-radius: 12px; overflow: hidden; margin: 0 auto;'>
            <div style='background: linear-gradient(135deg, #f59e0b 0%, #b45309 100%); padding: 30px; text-align: center;'>
                <h1 style='color: white; margin: 0; font-size: 24px;'>Registration Approved!</h1>
            </div>
            <div style='padding: 30px;'>
                <p>Dear <strong>{0}</strong>,</p>
                <p>We are delighted to confirm that your registration has been <strong>approved</strong>.</p>
                <div style='background: #fffbeb; border: 1px solid #fed7aa; border-radius: 8px; padding: 20px; margin: 25px 0; text-align: center;'>
                    <h3 style='color: #d97706; margin-top: 0; margin-bottom: 15px;'>Your Login Credentials</h3>
                    <p style='margin: 5px 0;'><strong>Username:</strong> {2}</p>
                    <div style='margin: 15px 0;'>
                        <span style='background: #fef3c7; color: #92400e; padding: 8px 16px; border-radius: 4px; font-weight: 600; font-size: 18px; letter-spacing: 1px;'>{3}</span>
                    </div>
                    <div style='margin-top: 20px;'>
                        <a href='{1}' style='background: #d97706; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: 500;'>Login to Dashboard</a>
                    </div>
                </div>
                <p style='font-size: 14px; color: #6b7280; text-align: center;'>* The event dates have been added to your calendar attachment.</p>
            </div>
            <div style='background: #f9fafb; padding: 20px; text-align: center; border-top: 1px solid #e5e7eb;'>
                <div style='margin-bottom: 15px;'>
                    <img src='cid:ExpoLogo' alt='Lubricant India Expo' style='width: 100%; max-width: 250px; height: auto;' />
                </div>
                <p style='font-size: 12px; color: #9ca3af; margin: 0;'>&copy; 2026 Lubricant India Expo. All rights reserved.</p>
            </div>
        </div>", name, loginUrl, email, password);

            // 5. Wrap Body in HTML/Head for Script
            string fullHtmlBody = $@"<!DOCTYPE html><html><head>{jsonLd}</head><body>{contentBody}</body></html>";

            // 6. Send Email
            // We removed the inner try-catch so errors bubble up to btnSubmit_Click
            using (MailMessage msg = new MailMessage())
            {
                msg.From = new MailAddress(smtpUser, "Lubricant India Expo");
                msg.To.Add(email);
                msg.Subject = "Registration Approved - Lubricant India Expo";

                // A. Add HTML View (Body + JSON-LD)
                AlternateView htmlView = AlternateView.CreateAlternateViewFromString(fullHtmlBody, null, MediaTypeNames.Text.Html);

                // B. Embed Logo
                if (File.Exists(imagePath))
                {
                    LinkedResource logo = new LinkedResource(imagePath, "image/png");
                    logo.ContentId = "ExpoLogo";
                    htmlView.LinkedResources.Add(logo);
                }
                msg.AlternateViews.Add(htmlView);

                // C. Create ICS Attachment (Outlook/Apple)
                StringBuilder sb = new StringBuilder();
                sb.AppendLine("BEGIN:VCALENDAR");
                sb.AppendLine("VERSION:2.0");
                sb.AppendLine("PRODID:-//Lubricant India Expo//LUBEiNX 2026//EN");
                sb.AppendLine("METHOD:REQUEST");
                sb.AppendLine("BEGIN:VEVENT");
                sb.AppendLine("UID:" + Guid.NewGuid().ToString());
                sb.AppendLine("DTSTAMP:" + DateTime.UtcNow.ToString("yyyyMMddTHHmmssZ"));
                sb.AppendLine("ORGANIZER;CN=Lubricant India Expo:MAILTO:sales@lubricantindia.com");
                sb.AppendLine("DTSTART:" + eventStart);
                sb.AppendLine("DTEND:" + eventEnd);
                sb.AppendLine("SUMMARY:" + eventName);
                sb.AppendLine("LOCATION:" + location);
                sb.AppendLine("DESCRIPTION:" + descText);
                sb.AppendLine("PRIORITY:5");
                sb.AppendLine("TRANSP:OPAQUE");
                sb.AppendLine("END:VEVENT");
                sb.AppendLine("END:VCALENDAR");

                byte[] calendarBytes = Encoding.UTF8.GetBytes(sb.ToString());
                using (MemoryStream stream = new MemoryStream(calendarBytes))
                {
                    Attachment icsAttachment = new Attachment(stream, "invite.ics", "text/calendar");
                    icsAttachment.ContentType.Parameters.Add("method", "REQUEST");
                    // Note: 'name' is automatically added by constructor, do not add it again
                    msg.Attachments.Add(icsAttachment);

                    using (SmtpClient client = new SmtpClient(smtpHost))
                    {
                        client.Port = int.Parse(smtpPort.ToString());
                        client.Credentials = new NetworkCredential(smtpUser, smtpPass);
                        client.EnableSsl = true;
                        client.Send(msg);
                    }
                }
            }
        }

        private void SendEmail(string toEmail, string subject, string body)
        {
            try
            {
                string smtpHost = ConfigurationManager.AppSettings["SMTP_Host"];
                string smtpPort = ConfigurationManager.AppSettings["SMTP_Port"];
                string smtpUser = ConfigurationManager.AppSettings["SMTP_User"];
                string smtpPass = ConfigurationManager.AppSettings["SMTP_Pass"];

                if (string.IsNullOrEmpty(smtpHost) || string.IsNullOrEmpty(smtpUser)) return;

                using (MailMessage msg = new MailMessage())
                {
                    msg.From = new MailAddress(smtpUser, "Lubricant India Expo");
                    msg.To.Add(toEmail);
                    msg.Subject = subject;
                    msg.Body = body;
                    msg.IsBodyHtml = true;

                    using (SmtpClient client = new SmtpClient(smtpHost))
                    {
                        client.Port = int.Parse(smtpPort);
                        client.Credentials = new NetworkCredential(smtpUser, smtpPass);
                        client.EnableSsl = true;
                        client.Send(msg);
                    }
                }
            }
            catch { /* Log error silently */ }
        }

        private void ShowMessage(string msg, string type)
        {
            string color = type == "success" ? "#d1fae5" : "#fee2e2";
            string border = type == "success" ? "#10b981" : "#ef4444";
            litMessage.Text = string.Format("<div style='padding:15px; margin-bottom:20px; background:{0}; border-left:5px solid {1}; border-radius:4px;'>{2}</div>", color, border, msg);
        }

        private void ClearForm()
        {
            txtName.Text = "";
            txtJob.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
            txtCompany.Text = "";
            txtAddress.Text = "";
            txtCity.Text = "";
            txtState.Text = "";
            txtCountry.Text = "";
            txtPin.Text = "";
            ddlTicket.SelectedIndex = 0;
            ddlJobFunction.SelectedIndex = 0;
            ddlNature.SelectedIndex = 0;
            chkPurpose.ClearSelection();
            chkProducts.ClearSelection();
            chkConsent.Checked = false;
        }
    }
}