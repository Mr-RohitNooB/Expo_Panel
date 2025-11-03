using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Expo_Panel
{
    public partial class RegisterSpeaker : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAvailableAgendas();
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                // Validate photo upload
                if (!fuPhoto.HasFile)
                {
                    ShowMessage("Please upload your photo.", "danger");
                    return;
                }

                // Validate file type and size
                string fileExtension = Path.GetExtension(fuPhoto.FileName).ToLower();
                if (fileExtension != ".jpg" && fileExtension != ".jpeg" && fileExtension != ".png")
                {
                    ShowMessage("Only JPG and PNG files are allowed.", "danger");
                    return;
                }

                if (fuPhoto.PostedFile.ContentLength > 2 * 1024 * 1024) // 2MB
                {
                    ShowMessage("File size must be less than 2MB.", "danger");
                    return;
                }

                // Upload photo
                string photoPath = UploadPhoto();
                if (string.IsNullOrEmpty(photoPath))
                {
                    ShowMessage("Error uploading photo. Please try again.", "danger");
                    return;
                }

                // Basic Information
                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                string designation = txtDesignation.Text.Trim();
                string company = txtCompany.Text.Trim();

                // Profile & Media
                string linkedIn = txtLinkedIn.Text.Trim();

                // Years of Experience
                int? yearsOfExperience = null;
                if (!string.IsNullOrEmpty(txtYearsOfExperience.Text.Trim()))
                {
                    yearsOfExperience = Convert.ToInt32(txtYearsOfExperience.Text.Trim());
                }

                // Professional Profile
                string professionalBio = txtProfessionalBio.Text.Trim();
                string areasOfExpertise = hdnAreasOfExpertise.Value;
                string currentWorkProjects = txtCurrentWorkProjects.Text.Trim();
                string suggestedTopics = txtSuggestedTopics.Text.Trim();

                // Discussion Format & Speaking Experience
                string preferredDiscussionFormat = hdnPreferredFormat.Value;
                string previousSpeakingEngagements = txtPreviousSpeakingEngagements.Text.Trim();

                // Agenda Selection
                string selectedAgendas = hdnSelectedAgendas.Value;

                // Validate agenda selection
                if (string.IsNullOrEmpty(selectedAgendas))
                {
                    ShowMessage("Please select at least 1 topic.", "danger");
                    return;
                }

                string[] agendaIds = selectedAgendas.Split(',');
                if (agendaIds.Length > 3)
                {
                    ShowMessage("You can only select up to 3 topics.", "danger");
                    return;
                }

                // Consent & Availability
                string isAvailable = ddlIsAvailable.SelectedValue;
                bool marketingConsent = chkMarketingConsent.Checked;

                // Registration Settings
                string registrationType = "Online"; // Always set to Online for public registration
                bool isActive = true; // Set to true by default

                // Add speaker to database
                int speakerId = AddSpeaker(
                    name, email, mobile, designation, company, isActive, registrationType,
                    yearsOfExperience, linkedIn, photoPath, null, // logoPath is null
                    professionalBio, areasOfExpertise, currentWorkProjects,
                    suggestedTopics, preferredDiscussionFormat, previousSpeakingEngagements,
                    isAvailable, marketingConsent, selectedAgendas
                );

                if (speakerId > 0)
                {
                    ShowMessage("Your registration has been submitted successfully! Our team will review your application and get back to you soon.", "success");
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
                    ShowMessage("This email address is already registered. If you've already registered, please wait for our team to review your application.", "danger");
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

        protected void cvAgendaSelection_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string selectedAgendas = hdnSelectedAgendas.Value;
            if (string.IsNullOrEmpty(selectedAgendas))
            {
                args.IsValid = false;
                return;
            }

            string[] agendaIds = selectedAgendas.Split(',');
            args.IsValid = (agendaIds.Length >= 1 && agendaIds.Length <= 3);
        }

        #region Private Methods

        private void LoadAvailableAgendas()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAvailableAgendasForSelection", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        if (dt.Rows.Count > 0)
                        {
                            StringBuilder html = new StringBuilder();
                            html.Append("<table class='agenda-table'>");

                            // Table Header
                            html.Append("<thead>");
                            html.Append("<tr>");
                            html.Append("<th style='width: 50px;'>Select</th>");
                            html.Append("<th style='width: 120px;'>Day</th>");
                            html.Append("<th style='width: 150px;'>Track</th>");
                            html.Append("<th style='width: 100px;'>Time</th>");
                            html.Append("<th>Title</th>");
                            html.Append("<th style='width: 120px; text-align: center;'>Details</th>");
                            html.Append("</tr>");
                            html.Append("</thead>");

                            // Table Body
                            html.Append("<tbody>");

                            foreach (DataRow row in dt.Rows)
                            {
                                int agendaId = Convert.ToInt32(row["AgendaID"]);
                                string day = row["Day"].ToString();
                                string track = row["Track"].ToString();
                                string time = row["Time"].ToString();
                                string title = row["Title"].ToString();
                                string brief = row["Brief"] != DBNull.Value ? row["Brief"].ToString() : "";
                                string synopsis = row["Synopsis"] != DBNull.Value ? row["Synopsis"].ToString() : "";

                                // Escape single quotes for JavaScript
                                string jsDay = day.Replace("'", "\\'");
                                string jsTrack = track.Replace("'", "\\'");
                                string jsTime = time.Replace("'", "\\'");
                                string jsTitle = title.Replace("'", "\\'");
                                string jsBrief = brief.Replace("'", "\\'").Replace("\n", "<br/>").Replace("\r", "");
                                string jsSynopsis = synopsis.Replace("'", "\\'").Replace("\n", "<br/>").Replace("\r", "");

                                html.Append("<tr>");

                                // Checkbox column
                                html.Append("<td style='text-align: center;'>");
                                html.Append($"<input type='checkbox' class='agenda-checkbox' value='{agendaId}' onchange='toggleAgendaSelection(this)' />");
                                html.Append("</td>");

                                // Day column
                                html.Append($"<td>{day}</td>");

                                // Track column
                                html.Append($"<td>{track}</td>");

                                // Time column
                                html.Append($"<td>{time}</td>");

                                // Title column
                                html.Append($"<td><strong>{title}</strong>");
                                if (!string.IsNullOrEmpty(brief) && brief.Length <= 100)
                                {
                                    html.Append($"<br/><small style='color: #64748b;'>{brief}</small>");
                                }
                                html.Append("</td>");

                                // View Details button column
                                html.Append("<td style='text-align: center;'>");
                                html.Append($"<button type='button' class='btn-view' onclick=\"viewAgenda({agendaId}, '{jsDay}', '{jsTrack}', '{jsTime}', '{jsTitle}', '{jsBrief}', '{jsSynopsis}')\">");
                                html.Append("<i class='fas fa-eye'></i> View");
                                html.Append("</button>");
                                html.Append("</td>");

                                html.Append("</tr>");
                            }

                            html.Append("</tbody>");
                            html.Append("</table>");

                            litAgendaTable.Text = html.ToString();
                        }
                        else
                        {
                            litAgendaTable.Text = @"
                                <div style='text-align: center; padding: 40px; color: #94a3b8;'>
                                    <i class='fas fa-inbox' style='font-size: 48px; margin-bottom: 15px; display: block;'></i>
                                    <p>No approved agenda topics available at the moment.</p>
                                </div>";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading agendas: " + ex.Message, "danger");
            }
        }

        private string UploadPhoto()
        {
            try
            {
                // Create upload directory if it doesn't exist
                string uploadFolder = Server.MapPath("~/Uploads/Speakers/Photos/");
                if (!Directory.Exists(uploadFolder))
                {
                    Directory.CreateDirectory(uploadFolder);
                }

                // Generate unique filename
                string fileExtension = Path.GetExtension(fuPhoto.FileName);
                string fileName = $"Speaker_{DateTime.Now.Ticks}{fileExtension}";
                string filePath = Path.Combine(uploadFolder, fileName);

                // Save file
                fuPhoto.SaveAs(filePath);

                // Return relative path for database
                return $"~/Uploads/Speakers/Photos/{fileName}";
            }
            catch (Exception ex)
            {
                throw new Exception("Error uploading photo: " + ex.Message);
            }
        }

        private int AddSpeaker(
            string name, string email, string mobile, string designation, string company,
            bool isActive, string registrationType,
            int? yearsOfExperience, string linkedInProfile, string photoPath, string logoPath,
            string professionalBio, string areasOfExpertise, string currentWorkProjects,
            string suggestedTopics, string preferredDiscussionFormat, string previousSpeakingEngagements,
            string isAvailable, bool marketingConsent, string selectedAgendas)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_AddSpeaker", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Basic fields
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                    cmd.Parameters.AddWithValue("@Designation", designation);
                    cmd.Parameters.AddWithValue("@Company", company);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);
                    cmd.Parameters.AddWithValue("@RegistrationType", registrationType);
                    // ApprovalStatus will default to "Pending" as per stored procedure

                    // Extended fields
                    cmd.Parameters.AddWithValue("@YearsOfExperience", yearsOfExperience.HasValue ? (object)yearsOfExperience.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@LinkedInProfile", string.IsNullOrEmpty(linkedInProfile) ? (object)DBNull.Value : linkedInProfile);
                    cmd.Parameters.AddWithValue("@PhotoPath", string.IsNullOrEmpty(photoPath) ? (object)DBNull.Value : photoPath);
                    cmd.Parameters.AddWithValue("@LogoPath", string.IsNullOrEmpty(logoPath) ? (object)DBNull.Value : logoPath);
                    cmd.Parameters.AddWithValue("@ProfessionalBio", string.IsNullOrEmpty(professionalBio) ? (object)DBNull.Value : professionalBio);
                    cmd.Parameters.AddWithValue("@AreasOfExpertise", string.IsNullOrEmpty(areasOfExpertise) ? (object)DBNull.Value : areasOfExpertise);
                    cmd.Parameters.AddWithValue("@CurrentWorkProjects", string.IsNullOrEmpty(currentWorkProjects) ? (object)DBNull.Value : currentWorkProjects);
                    cmd.Parameters.AddWithValue("@SuggestedTopics", string.IsNullOrEmpty(suggestedTopics) ? (object)DBNull.Value : suggestedTopics);
                    cmd.Parameters.AddWithValue("@PreferredDiscussionFormat", string.IsNullOrEmpty(preferredDiscussionFormat) ? (object)DBNull.Value : preferredDiscussionFormat);
                    cmd.Parameters.AddWithValue("@PreviousSpeakingEngagements", string.IsNullOrEmpty(previousSpeakingEngagements) ? (object)DBNull.Value : previousSpeakingEngagements);
                    cmd.Parameters.AddWithValue("@IsAvailable", isAvailable);
                    cmd.Parameters.AddWithValue("@MarketingConsent", marketingConsent);

                    // NEW: Selected Agendas
                    cmd.Parameters.AddWithValue("@SelectedAgendas", string.IsNullOrEmpty(selectedAgendas) ? (object)DBNull.Value : selectedAgendas);

                    SqlParameter outParam = new SqlParameter("@SpeakerID", SqlDbType.Int)
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

        private void ClearForm()
        {
            // Personal Information
            txtName.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
            txtDesignation.Text = "";
            txtCompany.Text = "";
            txtYearsOfExperience.Text = "";

            // Profile & Media
            txtLinkedIn.Text = "";

            // Professional Profile
            txtProfessionalBio.Text = "";
            txtCurrentWorkProjects.Text = "";
            txtSuggestedTopics.Text = "";
            txtOtherExpertise.Text = "";

            // Discussion Format & Speaking Experience
            txtPreviousSpeakingEngagements.Text = "";

            // Consent & Availability
            ddlIsAvailable.SelectedIndex = 0;
            chkMarketingConsent.Checked = false;

            // Hidden fields
            hdnAreasOfExpertise.Value = "";
            hdnPreferredFormat.Value = "";
            hdnSelectedAgendas.Value = "";

            // Reload agendas to reset selections
            LoadAvailableAgendas();
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "success" ? "alert-success" : "alert-danger";
            string icon = type == "success" ? "fa-check-circle" : "fa-exclamation-circle";

            litMessage.Text = $@"
                <div class='alert {cssClass}'>
                    <i class='fas {icon}'></i>
                    {message}
                </div>";
        }

        #endregion
    }
}