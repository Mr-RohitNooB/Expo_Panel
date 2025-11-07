using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

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
                LoadAvailableAgendas();
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


        }

        protected void btnTriggerEdit_Click(object sender, EventArgs e)
        {
            int speakerId = Convert.ToInt32(hdnApproveSpeakerID.Value);
            LoadSpeakerForEdit(speakerId);
        }

        private void LoadSpeakerApplications(int speakerId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    // First, get speaker details
                    using (SqlCommand cmd = new SqlCommand("sp_GetSpeakerById", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            hdnViewSpeakerID.Value = speakerId.ToString();
                            lblApplicationsSpeakerName.Text = reader["Name"].ToString();
                            lblApplicationsSpeakerEmail.Text = reader["Email"].ToString();
                        }
                        reader.Close();
                    }

                    // Then load applications - using query since we need to get data by SpeakerID
                    string query = @"
                SELECT 
                    sai.InterestID,
                    a.Day,
                    a.Title AS AgendaTitle,
                    a.Track,
                    a.Time,
                    sai.MotivationStatement,
                    sai.RelevanceToExpertise,
                    sai.AdvisoryRating,
                    sai.Status,
                    sai.ApplicationDate
                FROM TBL.SpeakerAgendaInterest sai
                INNER JOIN TBL.Agenda a ON sai.AgendaID = a.AgendaID
                WHERE sai.SpeakerID = @SpeakerID
                  AND sai.IS_ACTIVE = 1
                ORDER BY sai.ApplicationDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        gvSpeakerApplications.DataSource = dt;
                        gvSpeakerApplications.DataBind();
                    }
                }

                // Open the modal
                ScriptManager.RegisterStartupScript(this, GetType(), "openApplicationsModal", "openApplicationsModal();", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading applications: " + ex.Message, "danger");
            }
        }

        protected void gvSpeakerApplications_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ReviewApplication")
            {
                int interestId = Convert.ToInt32(e.CommandArgument);
                LoadApplicationForReview(interestId);
            }
        }

        private void LoadApplicationForReview(int interestId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string query = @"
                SELECT 
                    sai.InterestID,
                    s.Name AS SpeakerName,
                    s.Company,
                    s.Designation,
                    s.YearsOfExperience,
                    s.AreasOfExpertise,
                    a.Day,
                    a.Track,
                    a.Title AS AgendaTitle,
                    a.Brief AS AgendaBrief,
                    sai.MotivationStatement,
                    sai.RelevanceToExpertise,
                    sai.AdvisoryRating,
                    sai.Status,
                    sai.AdminRemarks
                FROM TBL.SpeakerAgendaInterest sai
                INNER JOIN TBL.Speaker s ON sai.SpeakerID = s.SpeakerID
                INNER JOIN TBL.Agenda a ON sai.AgendaID = a.AgendaID
                WHERE sai.InterestID = @InterestID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@InterestID", interestId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            hdnReviewInterestID.Value = interestId.ToString();

                            // Speaker Info
                            txtReviewSpeakerName.Text = reader["SpeakerName"].ToString();
                            txtReviewCompany.Text = reader["Company"].ToString();
                            txtReviewDesignation.Text = reader["Designation"].ToString();
                            txtReviewExperience.Text = reader["YearsOfExperience"] != DBNull.Value
                                ? reader["YearsOfExperience"].ToString() + " years"
                                : "N/A";
                            txtReviewExpertise.Text = reader["AreasOfExpertise"].ToString();

                            // Agenda Info
                            txtReviewDay.Text = reader["Day"].ToString();
                            txtReviewTrack.Text = reader["Track"].ToString();
                            txtReviewAgendaTitle.Text = reader["AgendaTitle"].ToString();
                            txtReviewAgendaBrief.Text = reader["AgendaBrief"].ToString();

                            // Application Details
                            txtReviewMotivation.Text = reader["MotivationStatement"].ToString();
                            txtReviewRelevance.Text = reader["RelevanceToExpertise"].ToString();

                            if (reader["AdvisoryRating"] != DBNull.Value)
                            {
                                decimal rating = Convert.ToDecimal(reader["AdvisoryRating"]);
                                txtReviewRating.Text = $"{Math.Round(rating, 1)}/5 ⭐";
                            }
                            else
                            {
                                txtReviewRating.Text = "No Rating";
                            }

                            // Current Status
                            ddlApplicationStatus.SelectedValue = reader["Status"].ToString();
                            txtApplicationRemarks.Text = reader["AdminRemarks"] != DBNull.Value
                                ? reader["AdminRemarks"].ToString()
                                : "";
                        }
                        reader.Close();
                    }
                }

                // Close the applications modal and open review modal
                string script = @"
            closeApplicationsModal();
            setTimeout(function() { openApplicationReviewModal(); }, 300);
        ";
                ScriptManager.RegisterStartupScript(this, GetType(), "openReviewModal", script, true);
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading application details: " + ex.Message, "danger");
            }
        }
        protected void btnSaveApplicationReview_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int interestId = Convert.ToInt32(hdnReviewInterestID.Value);
                string status = ddlApplicationStatus.SelectedValue;
                string remarks = txtApplicationRemarks.Text.Trim();

                if (status == "Rejected" && string.IsNullOrEmpty(remarks))
                {
                    ShowMessage("Remarks are required when rejecting an application.", "danger");
                    return;
                }

                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string updateQuery = @"
                UPDATE TBL.SpeakerAgendaInterest
                SET 
                    Status = @Status,
                    AdminRemarks = @AdminRemarks,
                    ApprovedBy = @ApprovedBy,
                    ApprovalDate = GETDATE(),
                    ModifiedDate = GETDATE()
                WHERE InterestID = @InterestID";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@InterestID", interestId);
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.Parameters.AddWithValue("@AdminRemarks", string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks);
                        cmd.Parameters.AddWithValue("@ApprovedBy", CurrentAdminID);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }

                    // If approved, update the Agenda table to mark speaker as confirmed
                    if (status == "Approved")
                    {
                        string agendaUpdateQuery = @"
                    UPDATE TBL.Agenda
                    SET IsSpeakerConfirmed = 1,
                        ModifiedDate = GETDATE()
                    WHERE AgendaID = (
                        SELECT AgendaID FROM TBL.SpeakerAgendaInterest 
                        WHERE InterestID = @InterestID
                    )";

                        using (SqlCommand cmd = new SqlCommand(agendaUpdateQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@InterestID", interestId);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }

                Session["FlashMessage"] = $"Application {status.ToLower()} successfully!";
                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating application: " + ex.Message, "danger");
            }
        }

        protected void cvApplicationRemarks_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string status = ddlApplicationStatus.SelectedValue;
            string remarks = txtApplicationRemarks.Text.Trim();

            if (status == "Rejected" && string.IsNullOrEmpty(remarks))
            {
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        private void UpdateSpeakerAgendas(int speakerId, string agendaIds)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {

                con.Open();

                string updateQuery = @"
            UPDATE TBL.Speaker
            SET SelectedAgendas = @SelectedAgendas,
                ModifiedDate = GETDATE()
            WHERE SpeakerID = @SpeakerID";

                using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                {
                    cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                    cmd.Parameters.AddWithValue("@SelectedAgendas", agendaIds);
                    cmd.ExecuteNonQuery();
                }

                // Then delete old agenda interests (they'll be recreated when approved)
                string deleteQuery = @"
            DELETE FROM TBL.SpeakerAgendaInterest
            WHERE SpeakerID = @SpeakerID
            AND Status = 'Pending'";

                using (SqlCommand cmd = new SqlCommand(deleteQuery, con))
                {
                    cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                    cmd.ExecuteNonQuery();
                }
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
                    yearsOfExperience = Convert.ToInt32(txtYearsOfExperience.Text.Trim());

                string linkedInProfile = txtLinkedInProfile.Text.Trim();
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

                if (fuPhoto.HasFile)
                {
                    photoPath = UploadPhoto();
                    if (string.IsNullOrEmpty(photoPath))
                    {
                        ShowMessage("Error uploading photo. Please try again.", "danger");
                        return;
                    }
                }

                if (mode == "add")
                {
                    int newSpeakerId = AddSpeaker(name, email, mobile, designation, company, isActive,
                        yearsOfExperience, linkedInProfile, photoPath, logoPath,
                        professionalBio, areasOfExpertise, currentWorkProjects,
                        suggestedTopics, preferredDiscussionFormat, previousSpeakingEngagements,
                        isAvailable, marketingConsent);

                    // DEBUG: show new id so you can confirm the stored proc completed
                    ShowMessage($"DEBUG: AddSpeaker returned ID = {newSpeakerId}", "info");

                    if (newSpeakerId > 0)
                    {
                        string selectedAgendaIds = hdnSelectedAgendas.Value;
                        if (!string.IsNullOrEmpty(selectedAgendaIds))
                        {
                            UpdateSpeakerAgendas(newSpeakerId, selectedAgendaIds);
                        }

                        Session["FlashMessage"] = "Speaker added successfully!";
                    }
                    else
                    {
                        ShowMessage("Could not create speaker. Please try again.", "danger");
                        return;
                    }
                }
                else if (mode == "edit")
                {
                    UpdateSpeaker(speakerId, name, email, mobile, designation, company, isActive,
                        yearsOfExperience, linkedInProfile, photoPath, logoPath,
                        professionalBio, areasOfExpertise, currentWorkProjects,
                        suggestedTopics, preferredDiscussionFormat, previousSpeakingEngagements,
                        isAvailable, marketingConsent);

                    string selectedAgendaIds = hdnSelectedAgendas.Value;
                    if (!string.IsNullOrEmpty(selectedAgendaIds))
                    {
                        UpdateSpeakerAgendas(speakerId, selectedAgendaIds);
                    }

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

                // Message is set in UpdateApprovalStatus method
                if (Session["FlashMessage"] == null)
                {
                    Session["FlashMessage"] = $"Speaker {approvalStatus.ToLower()} successfully!";
                }

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

        private string UploadPhoto()
        {
            try
            {
                if (!fuPhoto.HasFile)
                    return null;

                string fileExtension = Path.GetExtension(fuPhoto.FileName).ToLower();
                if (fileExtension != ".jpg" && fileExtension != ".jpeg" && fileExtension != ".png")
                {
                    ShowMessage("Only JPG and PNG files are allowed.", "danger");
                    return null;
                }

                if (fuPhoto.PostedFile.ContentLength > 2 * 1024 * 1024) // 2MB
                {
                    ShowMessage("File size must be less than 2MB.", "danger");
                    return null;
                }

                string uploadsFolder = Server.MapPath("~/Uploads/SpeakerPhotos/");
                if (!Directory.Exists(uploadsFolder))
                    Directory.CreateDirectory(uploadsFolder);

                string fileName = $"SPK_{DateTime.Now:yyyyMMddHHmmss}_{Path.GetFileName(fuPhoto.FileName)}";
                string filePath = Path.Combine(uploadsFolder, fileName);
                fuPhoto.SaveAs(filePath);

                return "~/Uploads/SpeakerPhotos/" + fileName;
            }
            catch (Exception ex)
            {
                ShowMessage("Error uploading photo: " + ex.Message, "danger");
                return null;
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
                // Reload agendas to ensure they're available in the modal
                LoadAvailableAgendas();

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

                            // Read values from database
                            string isAvailable = reader["IsAvailable"].ToString();
                            bool marketingConsent = reader["MarketingConsent"] != DBNull.Value && Convert.ToBoolean(reader["MarketingConsent"]);
                            string selectedAgendaIds = reader["SelectedAgendas"] != DBNull.Value ? reader["SelectedAgendas"].ToString() : "";




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
                            jsData.AppendFormat("isAvailable: '{0}',", EscapeJsString(isAvailable));
                            jsData.AppendFormat("marketingConsent: {0},", marketingConsent ? "true" : "false");
                            jsData.AppendFormat("linkedInProfile: '{0}',", EscapeJsString(reader["LinkedInProfile"].ToString() ?? ""));
                            jsData.AppendFormat("photoPath: '{0}',", EscapeJsString(reader["PhotoPath"].ToString() ?? ""));
                            jsData.AppendFormat("selectedAgendaIds: '{0}'", EscapeJsString(selectedAgendaIds));
                            jsData.Append("}");


                            reader.Close();

                            // Build additional script for agenda selection
                            StringBuilder agendaScript = new StringBuilder();

                            // Handle selected agendas
                            if (!string.IsNullOrEmpty(selectedAgendaIds))
                            {
                                agendaScript.AppendFormat("$('#{0}').val('{1}');", hdnSelectedAgendas.ClientID, selectedAgendaIds);

                                // Check the corresponding checkboxes
                                string[] agendaIdArray = selectedAgendaIds.Split(',');
                                foreach (string agendaId in agendaIdArray)
                                {
                                    agendaScript.AppendFormat("$('.agenda-checkbox[value=\"{0}\"]').prop('checked', true);", agendaId.Trim());
                                }

                                // Update count
                                agendaScript.AppendFormat("$('#topicCount').text('{0}');", agendaIdArray.Length);

                                // Disable unchecked if 3 are selected
                                if (agendaIdArray.Length >= 3)
                                {
                                    agendaScript.Append("$('.agenda-checkbox:not(:checked)').prop('disabled', true);");
                                }
                            }

                            // Register script to open modal with data
                            string fullScript = $@"
                        openModal('edit', {jsData.ToString()});
                        setTimeout(function() {{
                            {agendaScript.ToString()}
                        }}, 500);
                    ";

                            ScriptManager.RegisterStartupScript(this, GetType(), "openEditModal", fullScript, true);
                        }
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
                            string remarks = reader["Remarks"] != DBNull.Value ? reader["Remarks"].ToString() : "";

                            // Handle Password field safely - check if column exists
                            string password = "";
                            try
                            {
                                if (reader.GetOrdinal("Password") >= 0 && reader["Password"] != DBNull.Value)
                                {
                                    password = reader["Password"].ToString();
                                }
                            }
                            catch
                            {
                                // Password column doesn't exist, use empty string
                                password = "";
                            }

                            // Escape single quotes for JavaScript
                            name = EscapeJsString(name);
                            email = EscapeJsString(email);
                            regType = EscapeJsString(regType);
                            designation = EscapeJsString(designation);
                            company = EscapeJsString(company);
                            remarks = EscapeJsString(remarks);
                            password = EscapeJsString(password);

                            string script = $@"
                        setTimeout(function() {{
                            openApprovalModal({speakerId}, '{name}', '{email}', '{regType}', '{designation}', '{company}', '{approvalStatus}', '{remarks}', '{password}');
                        }}, 100);";

                            ScriptManager.RegisterStartupScript(this, GetType(), "openApprovalModal_" + speakerId, script, true);
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
        protected void btnTriggerApproval_Click(object sender, EventArgs e)
        {
            int speakerId = Convert.ToInt32(hdnApproveSpeakerID.Value);
            LoadSpeakerForApproval(speakerId);
        }
        private int AddSpeaker(string name, string email, string mobile, string designation, string company, bool isActive,
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
                    if (outParam.Value != DBNull.Value && outParam.Value != null)
                    {
                        return Convert.ToInt32(outParam.Value);
                    }
                }
            }
            return 0;
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
                // Generate password if approving and no password provided
                string password = txtPassword.Text.Trim();

                if (approvalStatus == "Approved" && string.IsNullOrEmpty(password))
                {
                    password = GeneratePassword(8); // Auto-generate 8-character password

                    // Store it back in the textbox so it can be displayed
                    txtPassword.Text = password;
                    txtPassword.TextMode = TextBoxMode.SingleLine; // Show the generated password
                }

                using (SqlCommand cmd = new SqlCommand("sp_UpdateSpeakerApprovalStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                    cmd.Parameters.AddWithValue("@ApprovalStatus", approvalStatus);
                    cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks);
                    cmd.Parameters.AddWithValue("@ApprovedBy", CurrentAdminID);
                    cmd.Parameters.AddWithValue("@Password", string.IsNullOrEmpty(password) ? (object)DBNull.Value : password);

                    con.Open();

                    // Execute and get the email and name
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read() && approvalStatus == "Approved")
                    {
                        string email = reader["Email"].ToString();
                        string name = reader["Name"].ToString();

                        // Show success message with password
                        Session["FlashMessage"] = $"Speaker approved successfully! Generated Password: <strong>{password}</strong>";
                    }

                    reader.Close();
                }
            }
        }

        // Add this helper method to generate random passwords
        private string GeneratePassword(int length = 8)
        {
            const string validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@#$";
            Random random = new Random();
            char[] chars = new char[length];

            for (int i = 0; i < length; i++)
            {
                chars[i] = validChars[random.Next(validChars.Length)];
            }

            return new string(chars);
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
            txtLinkedInProfile.Text = "";
            lblCurrentPhoto.Visible = false;
            lblCurrentPhoto.Text = "";

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

        private void LoadAvailableAgendas()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string query = @"
                SELECT 
                    AgendaID, 
                    Title, 
                    Brief AS Description,
                    Time AS StartTime,
                    Time AS EndTime
                FROM TBL.Agenda 
                WHERE IS_ACTIVE = 1 
                ORDER BY Day, Time";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        rptAvailableAgendas.DataSource = dt;
                        rptAvailableAgendas.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading agendas: " + ex.Message, "danger");
            }
        }

    }
}