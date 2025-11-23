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

        // RegisterSpeaker.aspx.cs (Modified Page_Load)

        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!IsPostBack)
            {
                LoadAvailableAgendas();

                // Check if speaker is logged in (Edit Mode)
                if (Session["IsSpeakerLoggedIn"] != null && (bool)Session["IsSpeakerLoggedIn"])
                {
                    int speakerId = Convert.ToInt32(Session["SpeakerID"]);
                    LoadSpeakerData(speakerId);

                    //// --- NEW LOGIC: Lock the form immediately after loading data ---
                    //LockAllControls(this);

                    btnRegister.Text = "Update Profile";

                    // Show welcome message (with a note that agendas are locked)
                    ShowMessage($"Welcome back, {Session["SpeakerName"]}! You can update your profile below. Your agenda topic selection is locked after the first save. For agenda edit kindly contact the Expo organizer", "info");

                    // Ensure the photo/logo panels are visible but the 'remove' buttons inside them are hidden.
                    // (The buttons are already hidden by LockAllControls)
                    pnlCurrentPhoto.Visible = true;
                    pnlCurrentLogo.Visible = true;
                    string script = @"
                <style>
                    .agenda-checkbox { 
                        pointer-events: none !important; 
                        opacity: 0.5 !important; 
                        cursor: not-allowed !important; 
                    }
                    .agenda-table tbody tr {
                        opacity: 0.7 !important;
                    }
                </style>
            ";

                    ClientScript.RegisterStartupScript(this.GetType(), "disableAgendas", script, false);

                }
            }
        }


        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                // Check if this is Edit Mode (logged-in speaker)
                bool isEditMode = Session["IsSpeakerLoggedIn"] != null && (bool)Session["IsSpeakerLoggedIn"];
                int speakerId = isEditMode ? Convert.ToInt32(Session["SpeakerID"]) : 0;

                // Handle Photo Upload
                string photoPath = null;

                if (isEditMode)
                {
                    // In edit mode, check if there's an existing photo or new upload
                    if (!string.IsNullOrEmpty(hdnCurrentPhotoPath.Value))
                    {
                        // Keep existing photo
                        photoPath = hdnCurrentPhotoPath.Value;
                    }
                    else if (fuPhoto.HasFile)
                    {
                        // Upload new photo
                        photoPath = UploadPhoto();
                    }
                    else
                    {
                        ShowMessage("Please upload a photo.", "danger");
                        return;
                    }
                }
                else
                {
                    // New registration - photo is required
                    if (!fuPhoto.HasFile)
                    {
                        ShowMessage("Please upload your photo.", "danger");
                        return;
                    }

                    photoPath = UploadPhoto();
                    if (string.IsNullOrEmpty(photoPath))
                    {
                        ShowMessage("Error uploading photo. Please try again.", "danger");
                        return;
                    }
                }

                // Handle Company Logo Upload
                string logoPath = null;

                if (isEditMode)
                {
                    // In edit mode, check if there's an existing logo or new upload
                    if (!string.IsNullOrEmpty(hdnCurrentLogoPath.Value))
                    {
                        // Keep existing logo
                        logoPath = hdnCurrentLogoPath.Value;
                    }
                    else if (fuLogo.HasFile)
                    {
                        // Upload new logo
                        logoPath = UploadLogo();
                    }
                }
                else
                {
                    // New registration - logo is optional
                    if (fuLogo.HasFile)
                    {
                        logoPath = UploadLogo();
                        if (string.IsNullOrEmpty(logoPath))
                        {
                            ShowMessage("Error uploading company logo. Please try again.", "danger");
                            return;
                        }
                    }
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

                if (isEditMode)
                {
                    // Determine if we're updating photo/logo
                    bool updatePhoto = photoPath != hdnCurrentPhotoPath.Value;
                    bool updateLogo = logoPath != hdnCurrentLogoPath.Value;

                    // UPDATE MODE
                    UpdateSpeakerProfile(
                        speakerId,
                        name,
                        mobile,
                        designation,
                        company,
                        yearsOfExperience,
                        linkedIn,
                        photoPath,
                        updatePhoto,    // NEW parameter
                        logoPath,
                        updateLogo,     // NEW parameter
                        professionalBio,
                        areasOfExpertise,
                        currentWorkProjects,
                        suggestedTopics,
                        preferredDiscussionFormat,
                        previousSpeakingEngagements,
                        isAvailable,
                        marketingConsent,
                        selectedAgendas
                    );

                    ShowMessage("Your profile has been updated successfully!", "success");

                    // Reload the page to show updated data
                    Response.Redirect(Request.RawUrl);
                }
                else
                {
                    // REGISTER MODE - Add new speaker
                    string registrationType = "Online";
                    bool isActive = true;

                    int newSpeakerId = AddSpeaker(
                name, email, mobile, designation, company, isActive,
                registrationType, yearsOfExperience, linkedIn, photoPath,
                logoPath, professionalBio, areasOfExpertise, currentWorkProjects,
                suggestedTopics, preferredDiscussionFormat,
                previousSpeakingEngagements, isAvailable, marketingConsent,
                selectedAgendas
            );

                    if (newSpeakerId > 0)
                    {
                        // 1. Hide the form
                        pnlFormFields.Visible = false;

                        // 2. Hide the generic alert message (we don't need it now)
                        litMessage.Text = "";

                        // 3. Show the fancy Animation Panel
                        pnlSuccessMessage.Visible = true;
                    }
                    else
                    {
                        ShowMessage("Registration failed. Please try again.", "danger");
                    }
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



        private void UpdateSpeakerProfile(
int speakerId,
string name,
string mobile,
string designation,
string company,
int? yearsOfExperience,
string linkedInProfile,
string photoPath,
bool updatePhoto,
string logoPath,
bool updateLogo,
string professionalBio,
string areasOfExpertise,
string currentWorkProjects,
string suggestedTopics,
string preferredDiscussionFormat,
string previousSpeakingEngagements,
string isAvailable,
bool marketingConsent,
string selectedAgendas)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                // Check if speaker has already modified agenda
                string checkQuery = "SELECT HasModifiedAgenda FROM TBL.Speaker WHERE SpeakerID = @SpeakerID";
                bool hasModifiedAgenda = false;

                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                    con.Open();
                    object result = checkCmd.ExecuteScalar();
                    if (result != DBNull.Value && result != null)
                        hasModifiedAgenda = Convert.ToBoolean(result);
                }

                // Build update query
                string updateQuery = @"
            UPDATE TBL.Speaker
            SET 
                Name = @Name,
                Mobile = @Mobile,
                Designation = @Designation,
                Company = @Company,
                YearsOfExperience = @YearsOfExperience,
                LinkedInProfile = @LinkedInProfile,
                " + (updatePhoto ? "PhotoPath = @PhotoPath," : "") + @"
                " + (updateLogo ? "LogoPath = @LogoPath," : "") + @"
                ProfessionalBio = @ProfessionalBio,
                AreasOfExpertise = @AreasOfExpertise,
                CurrentWorkProjects = @CurrentWorkProjects,
                SuggestedTopics = @SuggestedTopics,
                PreferredDiscussionFormat = @PreferredDiscussionFormat,
                PreviousSpeakingEngagements = @PreviousSpeakingEngagements,
                IsAvailable = @IsAvailable,
                MarketingConsent = @MarketingConsent,
                " + (!hasModifiedAgenda ? "SelectedAgendas = @SelectedAgendas, HasModifiedAgenda = 1," : "") + @"
                ModifiedDate = GETDATE()
            WHERE SpeakerID = @SpeakerID";

                using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                {
                    cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                    cmd.Parameters.AddWithValue("@Designation", designation);
                    cmd.Parameters.AddWithValue("@Company", company);
                    cmd.Parameters.AddWithValue("@YearsOfExperience", yearsOfExperience.HasValue ? (object)yearsOfExperience.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@LinkedInProfile", string.IsNullOrEmpty(linkedInProfile) ? (object)DBNull.Value : linkedInProfile);

                    if (updatePhoto)
                        cmd.Parameters.AddWithValue("@PhotoPath", photoPath);

                    if (updateLogo)
                        cmd.Parameters.AddWithValue("@LogoPath", logoPath);

                    cmd.Parameters.AddWithValue("@ProfessionalBio", string.IsNullOrEmpty(professionalBio) ? (object)DBNull.Value : professionalBio);
                    cmd.Parameters.AddWithValue("@AreasOfExpertise", string.IsNullOrEmpty(areasOfExpertise) ? (object)DBNull.Value : areasOfExpertise);
                    cmd.Parameters.AddWithValue("@CurrentWorkProjects", string.IsNullOrEmpty(currentWorkProjects) ? (object)DBNull.Value : currentWorkProjects);
                    cmd.Parameters.AddWithValue("@SuggestedTopics", string.IsNullOrEmpty(suggestedTopics) ? (object)DBNull.Value : suggestedTopics);
                    cmd.Parameters.AddWithValue("@PreferredDiscussionFormat", string.IsNullOrEmpty(preferredDiscussionFormat) ? (object)DBNull.Value : preferredDiscussionFormat);
                    cmd.Parameters.AddWithValue("@PreviousSpeakingEngagements", string.IsNullOrEmpty(previousSpeakingEngagements) ? (object)DBNull.Value : previousSpeakingEngagements);
                    cmd.Parameters.AddWithValue("@IsAvailable", isAvailable);
                    cmd.Parameters.AddWithValue("@MarketingConsent", marketingConsent);

                    // Only add parameter if we're updating agendas
                    if (!hasModifiedAgenda)
                    {
                        cmd.Parameters.AddWithValue("@SelectedAgendas", string.IsNullOrEmpty(selectedAgendas) ? (object)DBNull.Value : selectedAgendas);
                    }

                    if (con.State != ConnectionState.Open)
                        con.Open();

                    cmd.ExecuteNonQuery();
                }
            }
        }


        /// <summary>
        /// Recursively disables all input controls to enforce read-only status.
        /// </summary>
        private void LockAllControls(Control parent)
        {
            foreach (Control c in parent.Controls)
            {
                // Disable TextBox, DropDownList, CheckBox
                if (c is TextBox textBox)
                {
                    textBox.ReadOnly = true;
                    textBox.CssClass += " bg-light-gray"; // Add a class for visual feedback
                }
                else if (c is DropDownList dropDownList)
                {
                    dropDownList.Enabled = false;
                }
                else if (c is CheckBox checkBox)
                {
                    checkBox.Enabled = false;
                }
                else if (c is Button button)
                {
                    // Disable the main submit/update button
                    if (button.ID == "btnRegister")
                    {
                        button.Visible = false;
                    }
                }
                else if (c is FileUpload fileUpload)
                {
                    fileUpload.Visible = false; // Hide file upload controls
                }

                // Recursively check child controls
                if (c.HasControls())
                {
                    LockAllControls(c);
                }
            }
        }


        private string UploadLogo()
        {
            try
            {
                if (!fuLogo.HasFile)
                    return null;

                string logoExtension = Path.GetExtension(fuLogo.FileName).ToLower();
                if (logoExtension != ".jpg" && logoExtension != ".jpeg" && logoExtension != ".png")
                {
                    throw new Exception("Company logo: Only JPG and PNG files are allowed.");
                }

                //if (fuLogo.PostedFile.ContentLength > 5 * 1024 * 1024) // 5MB
                //{
                //    throw new Exception("Company logo file size must be less than 5MB.");
                //}

                string fileName = Path.GetFileName(fuLogo.FileName);
                string uniqueFileName = "Logo_" + Guid.NewGuid().ToString() + logoExtension;

                string uploadFolder = Server.MapPath("~/Uploads/Logos/");
                if (!Directory.Exists(uploadFolder))
                {
                    Directory.CreateDirectory(uploadFolder);
                }

                string filePath = Path.Combine(uploadFolder, uniqueFileName);
                fuLogo.SaveAs(filePath);

                return "~/Uploads/Logos/" + uniqueFileName;
            }
            catch (Exception ex)
            {
                throw new Exception("Error uploading company logo: " + ex.Message);
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

        private void LoadSpeakerData(int speakerId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string query = @"
                SELECT 
                    Name, Email, Mobile, Designation, Company,
                    YearsOfExperience, LinkedInProfile, PhotoPath, LogoPath,
                    ProfessionalBio, AreasOfExpertise, CurrentWorkProjects,
                    SuggestedTopics, PreferredDiscussionFormat,
                    PreviousSpeakingEngagements, IsAvailable,
                    MarketingConsent, SelectedAgendas, HasModifiedAgenda
                FROM TBL.Speaker
                WHERE SpeakerID = @SpeakerID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            // Populate form fields
                            txtName.Text = reader["Name"].ToString();
                            txtEmail.Text = reader["Email"].ToString();
                            txtEmail.Enabled = false;
                            txtEmail.CssClass += " bg-light";

                            txtMobile.Text = reader["Mobile"].ToString();
                            txtDesignation.Text = reader["Designation"].ToString();
                            txtCompany.Text = reader["Company"].ToString();

                            if (reader["YearsOfExperience"] != DBNull.Value)
                                txtYearsOfExperience.Text = reader["YearsOfExperience"].ToString();

                            txtLinkedIn.Text = reader["LinkedInProfile"].ToString();
                            txtProfessionalBio.Text = reader["ProfessionalBio"].ToString();
                            txtCurrentWorkProjects.Text = reader["CurrentWorkProjects"].ToString();
                            txtSuggestedTopics.Text = reader["SuggestedTopics"].ToString();
                            txtPreviousSpeakingEngagements.Text = reader["PreviousSpeakingEngagements"].ToString();

                            // Hidden fields
                            hdnAreasOfExpertise.Value = reader["AreasOfExpertise"].ToString();
                            hdnPreferredFormat.Value = reader["PreferredDiscussionFormat"].ToString();

                            // Dropdowns
                            ddlIsAvailable.SelectedValue = reader["IsAvailable"].ToString();
                            chkMarketingConsent.Checked = reader["MarketingConsent"] != DBNull.Value &&
                                                          Convert.ToBoolean(reader["MarketingConsent"]);

                            // Handle Photo Display
                            if (reader["PhotoPath"] != DBNull.Value && !string.IsNullOrEmpty(reader["PhotoPath"].ToString()))
                            {
                                string photoPath = reader["PhotoPath"].ToString();
                                hdnCurrentPhotoPath.Value = photoPath;

                                // Show current photo
                                pnlCurrentPhoto.Visible = true;
                                imgCurrentPhoto.ImageUrl = ResolveUrl(photoPath);

                                // Hide upload section and disable validator
                                pnlUploadPhoto.Visible = false;
                                rfvPhoto.Enabled = false;
                            }
                            else
                            {
                                pnlCurrentPhoto.Visible = false;
                                pnlUploadPhoto.Visible = true;
                                rfvPhoto.Enabled = true;
                            }

                            // Handle Logo Display
                            if (reader["LogoPath"] != DBNull.Value && !string.IsNullOrEmpty(reader["LogoPath"].ToString()))
                            {
                                string logoPath = reader["LogoPath"].ToString();
                                hdnCurrentLogoPath.Value = logoPath;

                                // Show current logo
                                pnlCurrentLogo.Visible = true;
                                imgCurrentLogo.ImageUrl = ResolveUrl(logoPath);

                                // Hide upload section
                                pnlUploadLogo.Visible = false;
                            }
                            else
                            {
                                pnlCurrentLogo.Visible = false;
                                pnlUploadLogo.Visible = true;
                            }

                            // Agenda selection
                            string selectedAgendas = reader["SelectedAgendas"].ToString();
                            hdnSelectedAgendas.Value = selectedAgendas;

                            bool hasModifiedAgenda = reader["HasModifiedAgenda"] != DBNull.Value &&
                                                    Convert.ToBoolean(reader["HasModifiedAgenda"]);

                            // Register JavaScript to preselect ALL checkboxes (agendas, expertise, format)
                            string script = $@"
                        window.addEventListener('DOMContentLoaded', function() {{
                            // Preselect agendas if available
                            {(!string.IsNullOrEmpty(selectedAgendas) ? $"preselectAgendas('{selectedAgendas}', {hasModifiedAgenda.ToString().ToLower()});" : "")}
                            
                            // Preselect expertise and format checkboxes
                            preselectCheckboxes();
                        }});
                    ";

                            ClientScript.RegisterStartupScript(this.GetType(), "PreselectAll", script, true);
                        }
                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading your data: " + ex.Message, "danger");
            }
        }


        protected void btnRemovePhoto_Click(object sender, EventArgs e)
        {
            try
            {
                // Clear the current photo path
                hdnCurrentPhotoPath.Value = "";

                // Show upload section, hide current photo
                pnlCurrentPhoto.Visible = false;
                pnlUploadPhoto.Visible = true;

                // Enable photo validator
                rfvPhoto.Enabled = true;

                ShowMessage("Photo removed. Please upload a new photo before updating your profile.", "info");
            }
            catch (Exception ex)
            {
                ShowMessage("Error removing photo: " + ex.Message, "danger");
            }
        }
        protected void btnRemoveLogo_Click(object sender, EventArgs e)
        {
            try
            {
                // Clear the current logo path
                hdnCurrentLogoPath.Value = "";

                // Show upload section, hide current logo
                pnlCurrentLogo.Visible = false;
                pnlUploadLogo.Visible = true;

                ShowMessage("Logo removed. You can upload a new logo or update without one.", "info");
            }
            catch (Exception ex)
            {
                ShowMessage("Error removing logo: " + ex.Message, "danger");
            }
        }
        private string UploadPhoto()
        {
            try
            {
                if (!fuPhoto.HasFile)
                    return null;

                string fileExtension = Path.GetExtension(fuPhoto.FileName).ToLower();
                if (fileExtension != ".jpg" && fileExtension != ".jpeg" && fileExtension != ".png")
                {
                    throw new Exception("Photo: Only JPG and PNG files are allowed.");
                }

                //if (fuPhoto.PostedFile.ContentLength > 2 * 1024 * 1024) // 2MB
                //{
                //    throw new Exception("Photo file size must be less than 2MB.");
                //}

                // Create upload directory if it doesn't exist
                string uploadFolder = Server.MapPath("~/Uploads/Speakers/Photos/");
                if (!Directory.Exists(uploadFolder))
                {
                    Directory.CreateDirectory(uploadFolder);
                }

                // Generate unique filename
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
            string cssClass = "";
            string icon = "";

            switch (type.ToLower())
            {
                case "success":
                    cssClass = "alert-success";
                    icon = "fa-check-circle";
                    break;
                case "danger":
                    cssClass = "alert-danger";
                    icon = "fa-exclamation-circle";
                    break;
                case "info":
                    cssClass = "alert alert-info";
                    icon = "fa-info-circle";
                    break;
                default:
                    cssClass = "alert-danger";
                    icon = "fa-exclamation-circle";
                    break;
            }

            litMessage.Text = $@"
        <div class='alert {cssClass}'>
            <i class='fas {icon}'></i>
            {message}
        </div>";
        }

        #endregion
    }
}