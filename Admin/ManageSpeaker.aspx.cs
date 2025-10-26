using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

namespace Expo_Panel.Admin
{
    public partial class SpeakerDashboard : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        private int CurrentAdminID
        {
            get
            {
                if (Session["AdminID"] != null)
                    return Convert.ToInt32(Session["AdminID"]);
                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["IsAuthenticated"] == null || !(bool)Session["IsAuthenticated"])
            {
                Response.Redirect("Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                // Display username
                if (Session["AdminUsername"] != null)
                {
                    lblUsername.Text = Session["AdminUsername"].ToString();
                    lblSessionStatus.Text = "Active";
                    lblSessionStatus.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    lblUsername.Text = "Unknown";
                    lblSessionStatus.Text = "Invalid";
                    lblSessionStatus.ForeColor = System.Drawing.Color.Red;
                }

                // Load counts and set default filter
                LoadStatusCounts();
                LoadSpeakers(txtSearch.Text.Trim(), "Pending");
                SetActiveFilterButton("Pending");
            }

            // Handle flash messages
            if (Session["FlashMessage"] != null)
            {
                ShowMessage(Session["FlashMessage"].ToString(), "success");
                Session.Remove("FlashMessage");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchText = txtSearch.Text.Trim();
            string currentFilter = hdnCurrentFilter.Value;

            LoadSpeakers(searchText, currentFilter);

            if (!string.IsNullOrEmpty(searchText))
            {
                ShowMessage($"Search results for '{searchText}' in {currentFilter} records", "info");
            }
        }

        protected void btnStatusFilter_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string filterStatus = btn.CommandArgument;

            hdnCurrentFilter.Value = filterStatus;

            LoadSpeakers(txtSearch.Text.Trim(), filterStatus);
            LoadStatusCounts();
            SetActiveFilterButton(filterStatus);
        }

        protected void gvSpeakers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int speakerId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditSpeaker")
            {
                LoadSpeakerForEdit(speakerId);
            }
            else if (e.CommandName == "ToggleStatus")
            {
                ToggleSpeakerStatus(speakerId);
            }
            else if (e.CommandName == "QuickToggle")
            {
                ToggleSpeakerStatus(speakerId);
            }
            else if (e.CommandName == "ApprovalAction")
            {
                LoadSpeakerForApproval(speakerId);
            }
        }

        protected void btnSaveSpeaker_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int speakerId = Convert.ToInt32(hdnSpeakerID.Value);
                string mode = hdnModalMode.Value;

                // Basic Information
                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                string designation = txtDesignation.Text.Trim();
                string company = txtCompany.Text.Trim();
                bool isActive = ddlStatus.SelectedValue == "1";

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

                if (mode == "add")
                {
                    AddSpeaker(name, email, mobile, designation, company, isActive,
                        yearsOfExperience, linkedInProfile, photoPath, logoPath,
                        professionalBio, areasOfExpertise, currentWorkProjects,
                        suggestedTopics, preferredDiscussionFormat, previousSpeakingEngagements,
                        isAvailable, marketingConsent);
                    Session["FlashMessage"] = "Speaker added successfully!";
                }
                else if (mode == "edit")
                {
                    UpdateSpeaker(speakerId, name, email, mobile, designation, company, isActive,
                        yearsOfExperience, linkedInProfile, photoPath, logoPath,
                        professionalBio, areasOfExpertise, currentWorkProjects,
                        suggestedTopics, preferredDiscussionFormat, previousSpeakingEngagements,
                        isAvailable, marketingConsent);
                    Session["FlashMessage"] = "Speaker updated successfully!";
                }

                // Clear form
                ClearForm();

                // Redirect to prevent form resubmission
                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (SqlException sqlEx)
            {
                string errorMsg = sqlEx.Message;
                if (errorMsg.Contains("Email already exists"))
                {
                    ShowMessage("This email address is already registered in Speakers. Please use a different email.", "danger");
                }
                else
                {
                    ShowMessage("Database Error: " + errorMsg, "danger");
                }
                ClearForm();
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
                ClearForm();
            }
        }

        protected void btnSaveApproval_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int speakerId = Convert.ToInt32(hdnApprovalSpeakerID.Value);
                string approvalStatus = ddlApprovalStatus.SelectedValue;
                string remarks = txtApprovalRemarks.Text.Trim();

                if (approvalStatus == "Rejected" && string.IsNullOrEmpty(remarks))
                {
                    ShowMessage("Remarks are required when rejecting a speaker.", "danger");
                    return;
                }

                UpdateApprovalStatus(speakerId, approvalStatus, remarks);

                Session["FlashMessage"] = $"Speaker {approvalStatus.ToLower()} successfully!";

                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating approval status: " + ex.Message, "danger");
            }
        }

        protected void cvRemarks_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string approvalStatus = ddlApprovalStatus.SelectedValue;
            string remarks = txtApprovalRemarks.Text.Trim();

            if (approvalStatus == "Rejected" && string.IsNullOrEmpty(remarks))
            {
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        protected void gvSpeakers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                try
                {
                    DataRowView drv = (DataRowView)e.Row.DataItem;
                    bool isActive = Convert.ToBoolean(drv["IS_ACTIVE"]);

                    if (!isActive)
                    {
                        e.Row.CssClass += " inactive-row";
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error during row binding: " + ex.Message, "danger");
                }
            }
        }

        private void LoadStatusCounts()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetSpeakerStatusCounts", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            int pendingCount = Convert.ToInt32(reader["PendingCount"]);
                            int approvedCount = Convert.ToInt32(reader["ApprovedCount"]);
                            int rejectedCount = Convert.ToInt32(reader["RejectedCount"]);

                            btnPending.Text = $"Pending ({pendingCount})";
                            btnApproved.Text = $"Approved ({approvedCount})";
                            btnRejected.Text = $"Rejected ({rejectedCount})";
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading counts: " + ex.Message, "danger");
            }
        }

        private void SetActiveFilterButton(string activeFilter)
        {
            btnPending.CssClass = "btn-filter";
            btnApproved.CssClass = "btn-filter";
            btnRejected.CssClass = "btn-filter";

            switch (activeFilter)
            {
                case "Pending":
                    btnPending.CssClass = "btn-filter active";
                    break;
                case "Approved":
                    btnApproved.CssClass = "btn-filter active";
                    break;
                case "Rejected":
                    btnRejected.CssClass = "btn-filter active";
                    break;
            }
        }

        private void LoadSpeakers(string searchText, string approvalStatus)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAllSpeakers", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SearchText", string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText);
                        cmd.Parameters.AddWithValue("@ApprovalStatus", string.IsNullOrEmpty(approvalStatus) ? (object)DBNull.Value : approvalStatus);

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        gvSpeakers.DataSource = dt;
                        gvSpeakers.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading speakers: " + ex.Message, "danger");
            }
        }

        private void LoadSpeakerForEdit(int speakerId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetSpeakerById", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            hdnSpeakerID.Value = speakerId.ToString();
                            hdnModalMode.Value = "edit";

                            // Build JavaScript object for speaker data
                            StringBuilder jsData = new StringBuilder();
                            jsData.Append("{");
                            jsData.AppendFormat("id: {0},", speakerId);
                            jsData.AppendFormat("name: '{0}',", EscapeJsString(reader["Name"].ToString()));
                            jsData.AppendFormat("email: '{0}',", EscapeJsString(reader["Email"].ToString()));
                            jsData.AppendFormat("mobile: '{0}',", EscapeJsString(reader["Mobile"].ToString()));
                            jsData.AppendFormat("designation: '{0}',", EscapeJsString(reader["Designation"].ToString()));
                            jsData.AppendFormat("company: '{0}',", EscapeJsString(reader["Company"].ToString()));
                            jsData.AppendFormat("isActive: '{0}',", Convert.ToBoolean(reader["IS_ACTIVE"]) ? "1" : "0");

                            // New fields
                            jsData.AppendFormat("yearsOfExperience: '{0}',", reader["YearsOfExperience"] != DBNull.Value ? reader["YearsOfExperience"].ToString() : "");
                            jsData.AppendFormat("professionalBio: '{0}',", EscapeJsString(reader["ProfessionalBio"].ToString()));
                            jsData.AppendFormat("areasOfExpertise: '{0}',", EscapeJsString(reader["AreasOfExpertise"].ToString()));
                            jsData.AppendFormat("currentWorkProjects: '{0}',", EscapeJsString(reader["CurrentWorkProjects"].ToString()));
                            jsData.AppendFormat("suggestedTopics: '{0}',", EscapeJsString(reader["SuggestedTopics"].ToString()));
                            jsData.AppendFormat("preferredDiscussionFormat: '{0}',", EscapeJsString(reader["PreferredDiscussionFormat"].ToString()));
                            jsData.AppendFormat("previousSpeakingEngagements: '{0}',", EscapeJsString(reader["PreviousSpeakingEngagements"].ToString()));
                            jsData.AppendFormat("isAvailable: '{0}',", EscapeJsString(reader["IsAvailable"].ToString()));
                            jsData.AppendFormat("marketingConsent: {0}", reader["MarketingConsent"] != DBNull.Value && Convert.ToBoolean(reader["MarketingConsent"]) ? "true" : "false");
                            jsData.Append("}");

                            // Register script to open modal with data
                            string script = $"openModal('edit', {jsData.ToString()});";
                            ScriptManager.RegisterStartupScript(this, GetType(), "openEditModal", script, true);
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading speaker: " + ex.Message, "danger");
            }
        }

        private void LoadSpeakerForApproval(int speakerId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetSpeakerById", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            hdnApprovalSpeakerID.Value = speakerId.ToString();

                            string name = reader["Name"].ToString();
                            string email = reader["Email"].ToString();
                            string regType = reader["RegistrationType"].ToString();
                            string designation = reader["Designation"].ToString();
                            string company = reader["Company"].ToString();
                            string approvalStatus = reader["ApprovalStatus"].ToString();
                            string remarks = reader["Remarks"].ToString();

                            // Escape single quotes for JavaScript
                            name = EscapeJsString(name);
                            email = EscapeJsString(email);
                            regType = EscapeJsString(regType);
                            designation = EscapeJsString(designation);
                            company = EscapeJsString(company);
                            remarks = EscapeJsString(remarks);

                            string script = $"openApprovalModal({speakerId}, '{name}', '{email}', '{regType}', '{designation}', '{company}', '{approvalStatus}', '{remarks}');";
                            ScriptManager.RegisterStartupScript(this, GetType(), "openApprovalModal", script, true);
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading speaker for approval: " + ex.Message, "danger");
            }
        }

        private void AddSpeaker(string name, string email, string mobile, string designation, string company, bool isActive,
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

                    SqlParameter outParam = new SqlParameter("@SpeakerID", SqlDbType.Int);
                    outParam.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParam);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateSpeaker(int speakerId, string name, string email, string mobile, string designation, string company, bool isActive,
            int? yearsOfExperience, string linkedInProfile, string photoPath, string logoPath,
            string professionalBio, string areasOfExpertise, string currentWorkProjects,
            string suggestedTopics, string preferredDiscussionFormat, string previousSpeakingEngagements,
            string isAvailable, bool marketingConsent)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateSpeaker", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Basic fields
                    cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                    cmd.Parameters.AddWithValue("@Designation", designation);
                    cmd.Parameters.AddWithValue("@Company", company);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);

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

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void ToggleSpeakerStatus(int speakerId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_ToggleSpeakerStatus", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowMessage("Speaker status updated successfully!", "success");
                string currentFilter = hdnCurrentFilter.Value;
                LoadSpeakers(txtSearch.Text.Trim(), currentFilter);
                LoadStatusCounts();
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating status: " + ex.Message, "danger");
            }
        }

        private void UpdateApprovalStatus(int speakerId, string approvalStatus, string remarks)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateSpeakerApprovalStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                    cmd.Parameters.AddWithValue("@ApprovalStatus", approvalStatus);
                    cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks);
                    cmd.Parameters.AddWithValue("@ApprovedBy", CurrentAdminID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void ClearForm()
        {
            txtName.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
            txtDesignation.Text = "";
            txtCompany.Text = "";
            txtYearsOfExperience.Text = "";
            txtProfessionalBio.Text = "";
            txtCurrentWorkProjects.Text = "";
            txtSuggestedTopics.Text = "";
            txtPreviousSpeakingEngagements.Text = "";
            txtOtherExpertise.Text = "";
            ddlStatus.SelectedIndex = 0;
            ddlIsAvailable.SelectedIndex = 0;
            chkMarketingConsent.Checked = false;
            hdnSpeakerID.Value = "0";
            hdnModalMode.Value = "add";
            hdnAreasOfExpertise.Value = "";
            hdnPreferredFormat.Value = "";
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "success" ? "alert-success" : type == "info" ? "alert-info" : "alert-danger";
            string icon = type == "success" ? "fa-check-circle" : type == "info" ? "fa-info-circle" : "fa-exclamation-circle";

            litMessage.Text = $@"
        <div class='alert {cssClass}'>
            <i class='fas {icon}'></i>
            {message}
        </div>";
        }

        private string EscapeJsString(string input)
        {
            if (string.IsNullOrEmpty(input))
                return "";

            return input.Replace("\\", "\\\\")
                       .Replace("'", "\\'")
                       .Replace("\"", "\\\"")
                       .Replace("\r", "\\r")
                       .Replace("\n", "\\n");
        }
    }
}