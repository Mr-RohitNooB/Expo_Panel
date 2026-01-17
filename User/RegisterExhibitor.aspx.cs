using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
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
                    adminBody.Append($"<tr><td style='background:#f2f2f2'><b>Email:</b></td><td>{email}</td></tr>");
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
        <div style='font-family: Arial, sans-serif; color: #333; line-height: 1.6; max-width: 600px;'>
            <h2 style='color: #dd6b20;'>Thank You for Registering!</h2>
            <p>Dear {name},</p>
            <p>Thank you for registering as an Exhibitor for the Lubricant India Expo. We have successfully received your request for <strong>{company}</strong>.</p>
            <p>Our team will review your requirements for the <strong>{boothType}</strong> ({areaInSqm} Sqm) and get back to you shortly with the floor plan and available options.</p>
            
            <hr style='border: 0; border-top: 1px solid #eee; margin: 20px 0;' />
            
            <p><strong>Contact Us:</strong></p>
            <p>If you have any questions, please feel free to reach out to us:</p>
            <p>
                Email: <a href='mailto:confex@lubricantindia.com' style='color: #1e40af; font-weight:bold;'>confex@lubricantindia.com</a><br/>
                Phone: <a href='tel:+919464700955' style='color: #1e40af; font-weight:bold;'>+91 94647 00955</a>
            </p>
            <br/>
            <p>Best Regards,<br/><strong>Lubricant India Expo Team</strong></p>
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
                // Read settings from Web.config
                string smtpHost = ConfigurationManager.AppSettings["SMTP_Host"];
                int smtpPort = Convert.ToInt32(ConfigurationManager.AppSettings["SMTP_Port"]);
                string smtpUser = ConfigurationManager.AppSettings["SMTP_User"];
                string smtpPass = ConfigurationManager.AppSettings["SMTP_Pass"];

                using (MailMessage mail = new MailMessage())
                {
                    mail.From = new MailAddress(smtpUser, "Lubricant India Expo");
                    mail.To.Add(toEmail);
                    mail.Subject = subject;
                    mail.Body = body;
                    mail.IsBodyHtml = true;

                    using (SmtpClient smtp = new SmtpClient(smtpHost, smtpPort))
                    {
                        smtp.Credentials = new NetworkCredential(smtpUser, smtpPass);
                        smtp.EnableSsl = true;
                        smtp.Send(mail);
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error safely so the user still sees the success screen
                System.Diagnostics.Debug.WriteLine("Email sending failed: " + ex.Message);
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
