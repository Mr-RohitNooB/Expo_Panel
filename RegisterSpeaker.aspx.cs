using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

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
                // Initialize page
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                // Basic Information
                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                string designation = txtDesignation.Text.Trim();
                string company = txtCompany.Text.Trim();

                // New Fields
                int? yearsOfExperience = null;
                if (!string.IsNullOrEmpty(txtYearsOfExperience.Text.Trim()))
                {
                    yearsOfExperience = Convert.ToInt32(txtYearsOfExperience.Text.Trim());
                }

                // COMMENTED OUT FOR FUTURE USE
                // string linkedInProfile = txtLinkedInProfile.Text.Trim();
                string linkedInProfile = null;
                string photoPath = null;
                string logoPath = null;

                string professionalBio = txtProfessionalBio.Text.Trim();
                string areasOfExpertise = hdnAreasOfExpertise.Value;
                string currentWorkProjects = txtCurrentWorkProjects.Text.Trim();
                string suggestedTopics = txtSuggestedTopics.Text.Trim();
                string preferredDiscussionFormat = hdnPreferredFormat.Value;
                string previousSpeakingEngagements = txtPreviousSpeakingEngagements.Text.Trim();
                string isAvailable = ddlIsAvailable.SelectedValue;
                bool marketingConsent = chkMarketingConsent.Checked;

                // Registration Settings
                string registrationType = "Online"; // Always set to Online for public registration
                bool isActive = true; // Set to true by default

                // Add speaker to database
                int speakerId = AddSpeaker(
                    name, email, mobile, designation, company, isActive, registrationType,
                    yearsOfExperience, linkedInProfile, photoPath, logoPath,
                    professionalBio, areasOfExpertise, currentWorkProjects,
                    suggestedTopics, preferredDiscussionFormat, previousSpeakingEngagements,
                    isAvailable, marketingConsent
                );

                if (speakerId > 0)
                {
                    ShowMessage("Your registration has been submitted successfully! Our team will review your application and contact you soon.", "success");
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

        private int AddSpeaker(
            string name, string email, string mobile, string designation, string company,
            bool isActive, string registrationType,
            int? yearsOfExperience, string linkedInProfile, string photoPath, string logoPath,
            string professionalBio, string areasOfExpertise, string currentWorkProjects,
            string suggestedTopics, string preferredDiscussionFormat, string previousSpeakingEngagements,
            string isAvailable, bool marketingConsent)
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

                    // New fields
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
            // Basic fields
            txtName.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
            txtDesignation.Text = "";
            txtCompany.Text = "";

            // New fields
            txtYearsOfExperience.Text = "";
            txtProfessionalBio.Text = "";
            txtCurrentWorkProjects.Text = "";
            txtSuggestedTopics.Text = "";
            txtPreviousSpeakingEngagements.Text = "";
            txtOtherExpertise.Text = "";
            ddlIsAvailable.SelectedIndex = 0;
            chkMarketingConsent.Checked = false;
            hdnAreasOfExpertise.Value = "";
            hdnPreferredFormat.Value = "";
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
    }
}