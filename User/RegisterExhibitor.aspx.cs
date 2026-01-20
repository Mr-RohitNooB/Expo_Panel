using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
using System.Web.UI;

namespace Expo_Panel
{
    public partial class RegisterExhibitor : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            // Validate declaration checkbox
            if (!chkDeclaration.Checked)
            {
                ShowMessage("Please accept the declaration to proceed.", "danger");
                return;
            }

            try
            {
                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                string designation = txtDesignation.Text.Trim();
                string company = txtCompany.Text.Trim();
                string headOffice = txtHeadOffice.Text.Trim();
                string city = txtCity.Text.Trim();
                string state = txtState.Text.Trim();
                string country = txtCountry.Text.Trim();
                string gstNumber = txtGSTNumber.Text.Trim();
                string billingAddress = txtBillingAddress.Text.Trim();

                // Get booth type
                string boothType = string.Empty;
                if (rbShellScheme.Checked) boothType = "Shell Scheme";
                else if (rbRawSpace.Checked) boothType = "Raw Space";

                decimal areaInSqm = 0;
                if (!string.IsNullOrEmpty(txtAreaInSqm.Text.Trim()))
                {
                    decimal.TryParse(txtAreaInSqm.Text.Trim(), out areaInSqm);
                }

                bool interestedInConference = chkConference.Checked;
                bool interestedInSponsorship = chkSponsorship.Checked;
                bool interestedInAdvertising = chkAdvertising.Checked;
                bool interestedInCustomPackage = chkCustomPackage.Checked;
                bool acceptedDeclaration = chkDeclaration.Checked;

                string registrationType = "Online";
                bool isActive = true;

                int exhibitorId = AddExhibitor(
                    name, email, mobile, designation, company,
                    headOffice, city, state, country, gstNumber, billingAddress,
                    boothType, areaInSqm,
                    interestedInConference, interestedInSponsorship,
                    interestedInAdvertising, interestedInCustomPackage,
                    acceptedDeclaration, isActive, registrationType
                );

                if (exhibitorId > 0)
                {
                    // 1. Prepare Admin Notification (To admin@lubricantindia.com)
                    string adminSubject = $"New Exhibitor Registration: {company}";
                    StringBuilder adminBody = new StringBuilder();
                    adminBody.Append("<h3>New Exhibitor Registration Received</h3>");
                    adminBody.Append("<table border='1' cellpadding='5' cellspacing='0' style='border-collapse:collapse; width:100%; max-width:600px;'>");

                    // Basic Info
                    adminBody.Append($"<tr><td style='background:#f2f2f2; width:30%;'><b>Name:</b></td><td>{name}</td></tr>");
                    adminBody.Append($"<tr><td style='background:#f2f2f2'><b>Designation:</b></td><td>{designation}</td></tr>");
                    adminBody.Append($"<tr><td style='background:#f2f2f2'><b>Company:</b></td><td>{company}</td></tr>");
                    adminBody.Append($"<tr><td style='background:#f2f2f2'><b>EmailEmail:</b></td><td>{email}</td></tr>");
                    adminBody.Append($"<tr><td style='background:#f2f2f2'><b>Mobile:</b></td><td>{mobile}</td></tr>");
                    adminBody.Append($"<tr><td style='background:#f2f2f2'><b>GST Number:</b></td><td>{gstNumber}</td></tr>");

                    // Address Info
                    adminBody.Append($"<tr><td style='background:#f2f2f2'><b>Head Office:</b></td><td>{headOffice}, {city}, {state}, {country}</td></tr>");
                    adminBody.Append($"<tr><td style='background:#f2f2f2'><b>Billing Address:</b></td><td>{billingAddress}</td></tr>");

                    // Booth Details
                    adminBody.Append($"<tr><td style='background:#f2f2f2'><b>Booth Type:</b></td><td>{boothType}</td></tr>");
                    adminBody.Append($"<tr><td style='background:#f2f2f2'><b>Area Required:</b></td><td>{areaInSqm} Sqm</td></tr>");

                    // Interests (Checkboxes)
                    List<string> interests = new List<string>();
                    if (interestedInConference) interests.Add("Conference Speaking");
                    if (interestedInSponsorship) interests.Add("Sponsorship");
                    if (interestedInAdvertising) interests.Add("Advertising");
                    if (interestedInCustomPackage) interests.Add("Custom Package");

                    adminBody.Append($"<tr><td style='background:#f2f2f2'><b>Additional Interests:</b></td><td>{(interests.Count > 0 ? string.Join(", ", interests) : "None")}</td></tr>");

                    adminBody.Append("</table>");
                    adminBody.Append("<p>Please login to the admin panel to review details.</p>");

                    // SEND TO ADMIN
                    SendEmail("admin@lubricantindia.com", adminSubject, adminBody.ToString());
                    // SendEmail("rcbm68615@gmail.com", adminSubject, adminBody.ToString()); // Uncomment for testing

                    // 2. Prepare User Acknowledgement (To the User)
                    string userSubject = "Registration Successful - Lubricant India Expo";

                    string userBody = $@"
<div style='font-family: Segoe UI, sans-serif; max-width: 600px; border: 1px solid #e0e0e0; margin: 0 auto;'>
    
    <div style='background-color: #2d2d2d; padding: 30px; text-align: center; border-bottom: 5px solid #dd6b20;'>
        <h2 style='color: #ffffff; margin: 0; letter-spacing: 1px;'>REGISTRATION RECEIVED</h2>
    </div>

    <div style='padding: 40px 30px; color: #4a5568; background-color: #ffffff;'>
        <p style='font-size: 16px; margin-bottom: 20px;'>Dear <strong>{name}</strong>,</p>
        
        <p style='font-size: 16px; line-height: 1.5;'>Thank you for registering as an Exhibitor for the <strong>Lubricant India Expo 2026</strong>.</p>
        
        <p style='font-size: 16px; line-height: 1.5;'>We have successfully received your request for <strong>{company}</strong>.</p>
        
        <div style='background-color: #f7fafc; border-left: 4px solid #dd6b20; padding: 15px; margin: 25px 0;'>
            <p style='margin: 0; color: #2d3748; font-weight: 500;'>Requested Space:</p>
            <p style='margin: 5px 0 0 0; color: #4a5568;'>{boothType} ({areaInSqm} Sqm)</p>
        </div>

        <p style='font-size: 16px; line-height: 1.5;'>Our team will review your requirements and get back to you shortly with the floor plan and available options.</p>
        
        <hr style='border: 0; border-top: 1px solid #e0e0e0; margin: 30px 0;' />
        
        <p style='font-weight: bold; margin-bottom: 10px; color: #2d3748;'>Contact Us</p>
        <p style='font-size: 14px; margin: 5px 0;'>If you have any questions, please feel free to reach out:</p>
        
        <table style='width: 100%; margin-top: 10px;'>
            <tr>
                <td style='padding-bottom: 5px; width: 60px; color: #718096;'>Email:</td>
                <td style='padding-bottom: 5px;'>
                    <a href='mailto:confex@lubricantindia.com' style='color: #dd6b20; font-weight:bold; text-decoration: none;'>confex@lubricantindia.com</a>
                </td>
            </tr>
            <tr>
                <td style='color: #718096;'>Phone:</td>
                <td>
                    <a href='tel:+919464700955' style='color: #dd6b20; font-weight:bold; text-decoration: none;'>+91 94647 00955</a>
                </td>
            </tr>
        </table>
    </div>

    <div style='background-color: #f8f9fa; padding: 20px; text-align: center; border-top: 1px solid #e0e0e0;'>
         <img src='cid:ExpoLogo' alt='Lubricant India Expo' style='display: block; width: 200px; height: auto; margin: 0 auto; border: 0;' />
         <p style='font-size: 12px; color: #a0aec0; margin-top: 10px; margin-bottom: 0;'>© 2026 Lubricant India Expo. All rights reserved.</p>
    </div>
</div>";

                    // SEND TO USER
                    SendEmail(email, userSubject, userBody);
                    ShowMessage("Your registration has been submitted successfully!", "success");
                    ClearForm();
                }
                else
                {
                    ShowMessage("Registration failed. Please try again.", "danger");
                }
            }
            catch (SqlException sqlEx)
            {
                string errorMsg = sqlEx.Message;
                if (errorMsg.Contains("Email already exists"))
                {
                    ShowMessage("This email address is already registered.", "danger");
                }
                else
                {
                    ShowMessage("Database Error: " + errorMsg, "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        private int AddExhibitor(string name, string email, string mobile, string designation,
            string company, string headOffice, string city, string state, string country,
            string gstNumber, string billingAddress, string boothType, decimal areaInSqm,
            bool interestedInConference, bool interestedInSponsorship,
            bool interestedInAdvertising, bool interestedInCustomPackage,
            bool acceptedDeclaration, bool isActive, string registrationType)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_AddExhibitor", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                    cmd.Parameters.AddWithValue("@Designation", designation);
                    cmd.Parameters.AddWithValue("@Company", company);
                    cmd.Parameters.AddWithValue("@HeadOfficeAddress", string.IsNullOrEmpty(headOffice) ? (object)DBNull.Value : headOffice);
                    cmd.Parameters.AddWithValue("@City", string.IsNullOrEmpty(city) ? (object)DBNull.Value : city);
                    cmd.Parameters.AddWithValue("@State", string.IsNullOrEmpty(state) ? (object)DBNull.Value : state);
                    cmd.Parameters.AddWithValue("@Country", string.IsNullOrEmpty(country) ? (object)DBNull.Value : country);
                    cmd.Parameters.AddWithValue("@GSTNumber", string.IsNullOrEmpty(gstNumber) ? (object)DBNull.Value : gstNumber);
                    cmd.Parameters.AddWithValue("@BillingAddress", string.IsNullOrEmpty(billingAddress) ? (object)DBNull.Value : billingAddress);
                    cmd.Parameters.AddWithValue("@BoothType", string.IsNullOrEmpty(boothType) ? (object)DBNull.Value : boothType);
                    cmd.Parameters.AddWithValue("@AreaInSqm", areaInSqm > 0 ? (object)areaInSqm : DBNull.Value);
                    cmd.Parameters.AddWithValue("@InterestedInConference", interestedInConference);
                    cmd.Parameters.AddWithValue("@InterestedInSponsorship", interestedInSponsorship);
                    cmd.Parameters.AddWithValue("@InterestedInAdvertising", interestedInAdvertising);
                    cmd.Parameters.AddWithValue("@InterestedInCustomPackage", interestedInCustomPackage);
                    cmd.Parameters.AddWithValue("@AcceptedDeclaration", acceptedDeclaration);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);
                    cmd.Parameters.AddWithValue("@RegistrationType", registrationType);

                    SqlParameter outParam = new SqlParameter("@ExhibitorID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outParam);

                    con.Open();
                    cmd.ExecuteNonQuery();

                    return Convert.ToInt32(outParam.Value);
                }
            }
        }

        private void SendEmail(string toEmail, string subject, string body)
        {
            try
            {
                // 1. Fetch Config & Paths
                string smtpHost = ConfigurationManager.AppSettings["SMTP_Host"];
                int smtpPort = Convert.ToInt32(ConfigurationManager.AppSettings["SMTP_Port"]);
                string smtpUser = ConfigurationManager.AppSettings["SMTP_User"];
                string smtpPass = ConfigurationManager.AppSettings["SMTP_Pass"];
                string imagePath = Server.MapPath("~/Images/Expo_logo_Full.png");

                // 2. Define Event Details (For Calendar)
                string eventStart = "20260910T043000Z";
                string eventEnd = "20260912T123000Z";
                string mapLink = "https://maps.app.goo.gl/8ANvB29YDhRzKsgp6";
                string eventName = "LUBEiNX - LUBRICANT INDIA EXPO 2026";
                string descText = "Opening Times:\\nThu, Sept 10: 10:00 AM – 6:30 PM\\nFri, Sept 11: 10:00 AM – 6:30 PM\\nSat, Sept 12: 10:00 AM – 6:00 PM\\n\\nContacts:\\nBooth Bookings: Amit Gautam (sales@lubricantindia.com)";

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

                // 4. Construct Email Body (HTML + JSON-LD)
                string fullHtmlBody = $@"<!DOCTYPE html><html><head>{jsonLd}</head><body style='margin:0;padding:0;'>{body}</body></html>";

                // 5. Create Mail Message
                using (MailMessage mail = new MailMessage())
                {
                    mail.From = new MailAddress(smtpUser, "Lubricant India Expo");
                    mail.To.Add(toEmail);
                    mail.Subject = subject;

                    // --- A. Create HTML View & Embed Image ---
                    AlternateView htmlView = AlternateView.CreateAlternateViewFromString(fullHtmlBody, null, MediaTypeNames.Text.Html);

                    // Check and Attach Logo
                    if (File.Exists(imagePath))
                    {
                        LinkedResource logo = new LinkedResource(imagePath, "image/png");
                        logo.ContentId = "ExpoLogo"; // Matches src='cid:ExpoLogo' in HTML
                        htmlView.LinkedResources.Add(logo);
                    }
                    mail.AlternateViews.Add(htmlView);

                    // --- B. Generate ICS File (Outlook/Apple) ---
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
                    sb.AppendLine("LOCATION:Bharat Mandapam, Pragati Maidan, New Delhi");
                    sb.AppendLine("DESCRIPTION:" + descText);
                    sb.AppendLine("PRIORITY:5");
                    sb.AppendLine("TRANSP:OPAQUE");
                    sb.AppendLine("END:VEVENT");
                    sb.AppendLine("END:VCALENDAR");

                    // --- C. Attach ICS File ---
                    byte[] calendarBytes = Encoding.UTF8.GetBytes(sb.ToString());
                    using (MemoryStream stream = new MemoryStream(calendarBytes))
                    {
                        Attachment icsAttachment = new Attachment(stream, "invite.ics", "text/calendar");
                        icsAttachment.ContentType.Parameters.Add("method", "REQUEST");
                        // Note: 'name' is automatically added by constructor
                        mail.Attachments.Add(icsAttachment);

                        // 6. Send
                        using (SmtpClient smtp = new SmtpClient(smtpHost, smtpPort))
                        {
                            smtp.Credentials = new NetworkCredential(smtpUser, smtpPass);
                            smtp.EnableSsl = true;
                            smtp.Send(mail);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Throw exception to be caught by the button click logic
                throw ex;
            }
        }

        private void ClearForm()
        {
            txtName.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
            txtDesignation.Text = "";
            txtCompany.Text = "";
            txtHeadOffice.Text = "";
            txtCity.Text = "";
            txtState.Text = "";
            txtCountry.Text = "";
            txtGSTNumber.Text = "";
            txtBillingAddress.Text = "";
            rbShellScheme.Checked = false;
            rbRawSpace.Checked = false;
            txtAreaInSqm.Text = "";
            chkConference.Checked = false;
            chkSponsorship.Checked = false;
            chkAdvertising.Checked = false;
            chkCustomPackage.Checked = false;
            chkDeclaration.Checked = false;
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "success" ? "alert-success" : "alert-danger";
            string icon = type == "success" ? "fa-check-circle" : "fa-exclamation-circle";

            litMessage.Text = $@"
        <div class='alert {cssClass}' role='alert'>
            <i class='fas {icon}'></i> {message}
            <button type='button' class='close-btn' onclick='this.parentElement.style.display=""none""'>
                &times;
            </button>
        </div>";
        }


    }
}
