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
    public partial class ManageExhibitor : System.Web.UI.Page
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
            if (Session["IsAuthenticated"] == null || !(bool)Session["IsAuthenticated"])
            {
                Response.Redirect("Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            string role = Session["Role"] != null ? Session["Role"].ToString() : "Admin";

            if (role != "SuperAdmin")
            {
                // STOP! They are not allowed.
                // Redirect them back to the dashboard immediately.
                Response.Redirect("~/SuperAdmin/Dashboard.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return; // Stop processing this page
            }

            if (!IsPostBack)
            {
                if (Session["AdminUsername"] != null)
                {
                    lblUsername.Text = Session["AdminUsername"].ToString();
                }
                else
                {
                    lblUsername.Text = "Unknown";
                }

                LoadStatusCounts();
                LoadExhibitors(txtSearch.Text.Trim(), "Pending");
                SetActiveFilterButton("Pending");
            }

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

            LoadExhibitors(searchText, currentFilter);

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

            LoadExhibitors(txtSearch.Text.Trim(), filterStatus);
            LoadStatusCounts();
            SetActiveFilterButton(filterStatus);
        }

        protected void gvExhibitors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int exhibitorId = Convert.ToInt32(e.CommandArgument);

            // ADD DEBUG LOGGING
            System.Diagnostics.Debug.WriteLine($"RowCommand fired: {e.CommandName} for ID: {exhibitorId}");

            if (e.CommandName == "EditExhibitor")
            {
                System.Diagnostics.Debug.WriteLine("Edit command detected - calling LoadExhibitorForEdit");
                LoadExhibitorForEdit(exhibitorId);
            }
            else if (e.CommandName == "QuickToggle")
            {
                ToggleExhibitorStatus(exhibitorId);
            }
            else if (e.CommandName == "ApprovalAction")
            {
                LoadExhibitorForApproval(exhibitorId);
            }
        }


        protected void gvExhibitors_RowDataBound(object sender, GridViewRowEventArgs e)
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

        protected void btnSaveExhibitor_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int exhibitorId = 0;
                if (!string.IsNullOrEmpty(hdnExhibitorID.Value))
                {
                    int.TryParse(hdnExhibitorID.Value, out exhibitorId);
                }

                string mode = hdnExhibitorModalMode.Value;

                // Collect Pre-Approval Data
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

                string boothType = string.Empty;
                if (rbShellScheme.Checked) boothType = "Shell Scheme";
                else if (rbRawSpace.Checked) boothType = "Raw Space";

                decimal? areaInSqm = null;
                if (!string.IsNullOrEmpty(txtAreaInSqm.Text.Trim()))
                {
                    areaInSqm = Convert.ToDecimal(txtAreaInSqm.Text.Trim());
                }

                bool conference = chkConference.Checked;
                bool sponsorship = chkSponsorship.Checked;
                bool advertising = chkAdvertising.Checked;
                bool customPackage = chkCustomPackage.Checked;
                bool isActive = ddlStatus.SelectedValue == "1";
                string registrationType = ddlRegistrationType.SelectedValue;

                // Check if user has filled post-approval data
                bool hasPostApprovalData = HasPostApprovalData();

                // Validate post-approval fields if data is present
                if (hasPostApprovalData && !ValidatePostApprovalFields())
                {
                    return;
                }

                if (mode == "add")
                {
                    AddExhibitor(name, email, mobile, designation, company, headOffice, city, state,
                                 country, gstNumber, billingAddress, boothType, areaInSqm, conference,
                                 sponsorship, advertising, customPackage, isActive, registrationType);

                    exhibitorId = GetExhibitorIdByEmail(email);

                    if (hasPostApprovalData && exhibitorId > 0)
                    {
                        // ✅ Auto-Approve FIRST (before saving profile)
                        string autoPassword = GenerateRandomPassword();
                        UpdateApprovalStatus(exhibitorId, "Approved", "Auto-approved on full form submit",
                                           autoPassword, CurrentAdminID);

                        // NOW save the post-approval profile
                        SavePostApprovalProfile(exhibitorId, mode);

                        Session["FlashMessage"] = "Exhibitor added and automatically approved with full profile!";
                    }
                    else
                    {
                        Session["FlashMessage"] = "Exhibitor added. Approval pending.";
                    }
                }


                else if (mode == "edit")
                {
                    // EDIT MODE
                    UpdateExhibitor(exhibitorId, name, email, mobile, designation, company, headOffice, city, state,
                        country, gstNumber, billingAddress, boothType, areaInSqm, conference, sponsorship,
                        advertising, customPackage, isActive);

                    // Handle post-approval profile
                    if (hasPostApprovalData)
                    {
                        SavePostApprovalProfile(exhibitorId, mode);
                    }

                    Session["FlashMessage"] = "Exhibitor updated successfully!";
                }

                ClearExhibitorForm();
                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Message.Contains("Email already exists"))
                {
                    ShowMessage("This email address is already registered.", "danger");
                }
                else
                {
                    ShowMessage("Database Error: " + sqlEx.Message, "danger");
                }
                ClearExhibitorForm();
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
                ClearExhibitorForm();
            }
        }

        private int GetExhibitorIdByEmail(string email)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = "SELECT ExhibitorID FROM TBL.Exhibitor WHERE Email = @Email";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    return result != null ? Convert.ToInt32(result) : 0;
                }
            }
        }

        private bool PostApprovalProfileExists(int exhibitorId)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = "SELECT COUNT(*) FROM TBL.PostApprovalExhibitor WHERE ExhibitorID = @ExhibitorID AND IS_ACTIVE = 1";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
                    con.Open();
                    int count = (int)cmd.ExecuteScalar();
                    return count > 0;
                }
            }
        }

        private void SavePostApprovalProfile(int exhibitorId, string mode)
        {
            // Collect Post-Approval Data
            string boothNo = txtBoothNo.Text.Trim();
            string hallNo = txtHallNo.Text.Trim();
            string exhibitorProfile = txtExhibitorProfile.Text.Trim();
            int yearOfEstablishment = Convert.ToInt32(txtYearOfEstablishment.Text.Trim());
            string website = txtWebsite.Text.Trim();
            string linkedIn = txtLinkedIn.Text.Trim();
            string twitter = txtTwitter.Text.Trim();
            string facebook = txtFacebook.Text.Trim();
            string youtube = txtYouTube.Text.Trim();
            string supportName = txtSupportName.Text.Trim();
            string supportContact = txtSupportContact.Text.Trim();
            string supportEmail = txtSupportEmail.Text.Trim();

            string natureOfBusiness = GetNatureOfBusiness();
            string companyCategory = GetCompanyCategory();
            string marketsCatered = GetMarketsCatered();
            string geographicReach = GetGeographicReach();
            string participationObjectives = GetParticipationObjectives();

            bool powerSupplyRequired = chkPowerSupply.Checked;
            decimal? powerSupplyKwh = null;
            if (powerSupplyRequired && !string.IsNullOrEmpty(txtPowerSupplyKwh.Text.Trim()))
            {
                powerSupplyKwh = Convert.ToDecimal(txtPowerSupplyKwh.Text.Trim());
            }

            bool internetRequired = chkInternet.Checked;
            bool furnitureRequired = chkFurniture.Checked;
            bool avEquipmentRequired = chkAVEquipment.Checked;
            bool interpreterRequired = chkInterpreter.Checked;
            string otherRequirements = chkReqOther.Checked ? txtReqOther.Text.Trim() : "";
            string additionalNotes = txtAdditionalNotes.Text.Trim();

            // Handle File Uploads
            string productPicturePath = null; // Changed to null for logic consistency
            string brochurePath = null;       // Changed to null
            string logoPath = null;

            if (fuProductPicture.HasFile || fuBrochure.HasFile || fuLogo.HasFile)
            {
                string uploadFolder = Server.MapPath($"~/Uploads/Exhibitor_{exhibitorId}/");

                if (!Directory.Exists(uploadFolder))
                {
                    Directory.CreateDirectory(uploadFolder);
                }

                if (fuProductPicture.HasFile)
                {
                    string productFileName = "ProductPicture_" + DateTime.Now.Ticks + Path.GetExtension(fuProductPicture.FileName);
                    string productFullPath = Path.Combine(uploadFolder, productFileName);
                    fuProductPicture.SaveAs(productFullPath);
                    productPicturePath = $"~/Uploads/Exhibitor_{exhibitorId}/{productFileName}";
                }

                if (fuBrochure.HasFile)
                {
                    string brochureFileName = "Brochure_" + DateTime.Now.Ticks + Path.GetExtension(fuBrochure.FileName);
                    string brochureFullPath = Path.Combine(uploadFolder, brochureFileName);
                    fuBrochure.SaveAs(brochureFullPath);
                    brochurePath = $"~/Uploads/Exhibitor_{exhibitorId}/{brochureFileName}";
                }
                if (fuLogo.HasFile)
                {
                    string logoFileName = "Logo_" + DateTime.Now.Ticks + Path.GetExtension(fuLogo.FileName);
                    string logoFullPath = Path.Combine(uploadFolder, logoFileName);
                    fuLogo.SaveAs(logoFullPath);
                    logoPath = $"~/Uploads/Exhibitor_{exhibitorId}/{logoFileName}";
                }
            }

            // Check if profile exists
            bool profileExists = PostApprovalProfileExists(exhibitorId);

            if (profileExists)
            {
                // UPDATE
                int profileId = GetPostApprovalProfileId(exhibitorId);
                UpdatePostApprovalProfile(profileId, boothNo, hallNo, exhibitorProfile, yearOfEstablishment,
                    website, linkedIn, twitter, facebook, youtube,
                    supportName, supportContact, supportEmail,
                    natureOfBusiness, companyCategory, marketsCatered, geographicReach,
                    powerSupplyRequired, powerSupplyKwh, internetRequired, furnitureRequired,
                    avEquipmentRequired, interpreterRequired, otherRequirements,
                    participationObjectives, additionalNotes,
                    productPicturePath, brochurePath, logoPath);
            }
            else
            {
                // INSERT
                AddPostApprovalProfile(exhibitorId, boothNo, hallNo, exhibitorProfile, yearOfEstablishment,
                    website, linkedIn, twitter, facebook, youtube,
                    supportName, supportContact, supportEmail,
                    natureOfBusiness, companyCategory, marketsCatered, geographicReach,
                    powerSupplyRequired, powerSupplyKwh, internetRequired, furnitureRequired,
                    avEquipmentRequired, interpreterRequired, otherRequirements,
                    participationObjectives, additionalNotes,
                    productPicturePath, brochurePath, logoPath);
            }
        }

        private int GetPostApprovalProfileId(int exhibitorId)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = "SELECT ProfileID FROM TBL.PostApprovalExhibitor WHERE ExhibitorID = @ExhibitorID AND IS_ACTIVE = 1";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    return result != null ? Convert.ToInt32(result) : 0;
                }
            }
        }

        private void AddPostApprovalProfile(
            int exhibitorId, string boothNo, string hallNo, string exhibitorProfile, int yearOfEstablishment,
            string website, string linkedIn, string twitter, string facebook, string youtube,
            string supportName, string supportContact, string supportEmail,
            string natureOfBusiness, string companyCategory, string marketsCatered, string geographicReach,
            bool powerSupplyRequired, decimal? powerSupplyKwh, bool internetRequired, bool furnitureRequired,
            bool avEquipmentRequired, bool interpreterRequired, string otherRequirements,
            string participationObjectives, string additionalNotes,
            string productPicturePath, string brochurePath, string logoPath)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_AddPostApprovalExhibitorProfile", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
                    cmd.Parameters.AddWithValue("@BoothNo", boothNo);
                    cmd.Parameters.AddWithValue("@HallNo", hallNo);
                    cmd.Parameters.AddWithValue("@ExhibitorProfile", string.IsNullOrEmpty(exhibitorProfile) ? (object)DBNull.Value : exhibitorProfile);
                    cmd.Parameters.AddWithValue("@YearOfEstablishment", yearOfEstablishment);
                    cmd.Parameters.AddWithValue("@Website", string.IsNullOrEmpty(website) ? (object)DBNull.Value : website);
                    cmd.Parameters.AddWithValue("@LinkedIn", string.IsNullOrEmpty(linkedIn) ? (object)DBNull.Value : linkedIn);
                    cmd.Parameters.AddWithValue("@Twitter", string.IsNullOrEmpty(twitter) ? (object)DBNull.Value : twitter);
                    cmd.Parameters.AddWithValue("@Facebook", string.IsNullOrEmpty(facebook) ? (object)DBNull.Value : facebook);
                    cmd.Parameters.AddWithValue("@YouTube", string.IsNullOrEmpty(youtube) ? (object)DBNull.Value : youtube);
                    cmd.Parameters.AddWithValue("@CustomerSupportName", supportName);
                    cmd.Parameters.AddWithValue("@CustomerSupportContact", supportContact);
                    cmd.Parameters.AddWithValue("@CustomerSupportEmail", supportEmail);
                    cmd.Parameters.AddWithValue("@NatureOfBusiness", natureOfBusiness);
                    cmd.Parameters.AddWithValue("@CompanyCategory", companyCategory);
                    cmd.Parameters.AddWithValue("@MarketsCateredTo", marketsCatered);
                    cmd.Parameters.AddWithValue("@GeographicReach", geographicReach);
                    cmd.Parameters.AddWithValue("@PowerSupplyRequired", powerSupplyRequired);
                    cmd.Parameters.AddWithValue("@PowerSupplyKwh", powerSupplyKwh.HasValue ? (object)powerSupplyKwh.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@InternetRequired", internetRequired);
                    cmd.Parameters.AddWithValue("@FurnitureRentalRequired", furnitureRequired);
                    cmd.Parameters.AddWithValue("@AVEquipmentRequired", avEquipmentRequired);
                    cmd.Parameters.AddWithValue("@InterpreterSupportRequired", interpreterRequired);
                    cmd.Parameters.AddWithValue("@OtherRequirements", string.IsNullOrEmpty(otherRequirements) ? (object)DBNull.Value : otherRequirements);
                    cmd.Parameters.AddWithValue("@ParticipationObjectives", participationObjectives);
                    cmd.Parameters.AddWithValue("@AdditionalNotes", string.IsNullOrEmpty(additionalNotes) ? (object)DBNull.Value : additionalNotes);
                    cmd.Parameters.AddWithValue("@ProductPicturePath", string.IsNullOrEmpty(productPicturePath) ? (object)DBNull.Value : productPicturePath);
                    cmd.Parameters.AddWithValue("@BrochurePath", string.IsNullOrEmpty(brochurePath) ? (object)DBNull.Value : brochurePath);
                    cmd.Parameters.AddWithValue("@LogoPath", string.IsNullOrEmpty(logoPath) ? (object)DBNull.Value : logoPath);

                    SqlParameter outParam = new SqlParameter("@ProfileID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outParam);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdatePostApprovalProfile(
            int profileId, string boothNo, string hallNo, string exhibitorProfile, int yearOfEstablishment,
            string website, string linkedIn, string twitter, string facebook, string youtube,
            string supportName, string supportContact, string supportEmail,
            string natureOfBusiness, string companyCategory, string marketsCatered, string geographicReach,
            bool powerSupplyRequired, decimal? powerSupplyKwh, bool internetRequired, bool furnitureRequired,
            bool avEquipmentRequired, bool interpreterRequired, string otherRequirements,
            string participationObjectives, string additionalNotes,
            string productPicturePath, string brochurePath, string logoPath)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdatePostApprovalExhibitorProfile", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@ProfileID", profileId);
                    cmd.Parameters.AddWithValue("@BoothNo", boothNo);
                    cmd.Parameters.AddWithValue("@HallNo", hallNo);
                    cmd.Parameters.AddWithValue("@ExhibitorProfile", string.IsNullOrEmpty(exhibitorProfile) ? (object)DBNull.Value : exhibitorProfile);
                    cmd.Parameters.AddWithValue("@YearOfEstablishment", yearOfEstablishment);
                    cmd.Parameters.AddWithValue("@Website", string.IsNullOrEmpty(website) ? (object)DBNull.Value : website);
                    cmd.Parameters.AddWithValue("@LinkedIn", string.IsNullOrEmpty(linkedIn) ? (object)DBNull.Value : linkedIn);
                    cmd.Parameters.AddWithValue("@Twitter", string.IsNullOrEmpty(twitter) ? (object)DBNull.Value : twitter);
                    cmd.Parameters.AddWithValue("@Facebook", string.IsNullOrEmpty(facebook) ? (object)DBNull.Value : facebook);
                    cmd.Parameters.AddWithValue("@YouTube", string.IsNullOrEmpty(youtube) ? (object)DBNull.Value : youtube);
                    cmd.Parameters.AddWithValue("@CustomerSupportName", supportName);
                    cmd.Parameters.AddWithValue("@CustomerSupportContact", supportContact);
                    cmd.Parameters.AddWithValue("@CustomerSupportEmail", supportEmail);
                    cmd.Parameters.AddWithValue("@NatureOfBusiness", natureOfBusiness);
                    cmd.Parameters.AddWithValue("@CompanyCategory", companyCategory);
                    cmd.Parameters.AddWithValue("@MarketsCateredTo", marketsCatered);
                    cmd.Parameters.AddWithValue("@GeographicReach", geographicReach);
                    cmd.Parameters.AddWithValue("@PowerSupplyRequired", powerSupplyRequired);
                    cmd.Parameters.AddWithValue("@PowerSupplyKwh", powerSupplyKwh.HasValue ? (object)powerSupplyKwh.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@InternetRequired", internetRequired);
                    cmd.Parameters.AddWithValue("@FurnitureRentalRequired", furnitureRequired);
                    cmd.Parameters.AddWithValue("@AVEquipmentRequired", avEquipmentRequired);
                    cmd.Parameters.AddWithValue("@InterpreterSupportRequired", interpreterRequired);
                    cmd.Parameters.AddWithValue("@OtherRequirements", string.IsNullOrEmpty(otherRequirements) ? (object)DBNull.Value : otherRequirements);
                    cmd.Parameters.AddWithValue("@ParticipationObjectives", participationObjectives);
                    cmd.Parameters.AddWithValue("@AdditionalNotes", string.IsNullOrEmpty(additionalNotes) ? (object)DBNull.Value : additionalNotes);
                    cmd.Parameters.AddWithValue("@ProductPicturePath", string.IsNullOrEmpty(productPicturePath) ? (object)DBNull.Value : productPicturePath);
                    cmd.Parameters.AddWithValue("@BrochurePath", string.IsNullOrEmpty(brochurePath) ? (object)DBNull.Value : brochurePath);
                    cmd.Parameters.AddWithValue("@LogoPath", string.IsNullOrEmpty(logoPath) ? (object)DBNull.Value : logoPath);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
        protected void btnTriggerEdit_Click(object sender, EventArgs e)
        {
            try
            {
                int exhibitorId = Convert.ToInt32(hdnEditExhibitorID.Value);
                LoadExhibitorForEdit(exhibitorId);
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading exhibitor for edit: " + ex.Message, "danger");
            }
        }

        protected void btnTriggerApproval_Click(object sender, EventArgs e)
        {
            try
            {
                int exhibitorId = Convert.ToInt32(hdnApproveExhibitorID.Value);
                LoadExhibitorForApproval(exhibitorId);
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading exhibitor for approval: " + ex.Message, "danger");
            }
        }


        protected void btnSaveApproval_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int exhibitorId = Convert.ToInt32(hdnApprovalExhibitorID.Value);
                string approvalStatus = ddlApprovalStatus.SelectedValue;
                string remarks = txtApprovalRemarks.Text.Trim();
                string password = txtPassword.Text.Trim();
                string hallNo = txtApprovalHall.Text.Trim();
                string boothNo = txtApprovalBooth.Text.Trim();
                decimal? area = null;

                if (!string.IsNullOrEmpty(txtApprovalArea.Text.Trim()))
                {
                    area = Convert.ToDecimal(txtApprovalArea.Text.Trim());
                }

                if (approvalStatus == "Rejected" && string.IsNullOrEmpty(remarks))
                {
                    ShowMessage("Remarks are required when rejecting an exhibitor.", "danger");
                    return;
                }

                if (approvalStatus == "Approved" && string.IsNullOrEmpty(password))
                {
                    // ...generate a random one instead of showing an error.
                    password = GenerateRandomPassword();
                }

                UpdateApprovalStatusWithArea(exhibitorId, approvalStatus, remarks, password, CurrentAdminID, area);

                if (!string.IsNullOrEmpty(hallNo) || !string.IsNullOrEmpty(boothNo))
                {
                    UpdateExhibitorLogistics(exhibitorId, hallNo, boothNo);
                }

                Session["FlashMessage"] = $"Exhibitor {approvalStatus.ToLower()} successfully!";

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

        protected void cvPassword_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string approvalStatus = ddlApprovalStatus.SelectedValue;
            string password = txtPassword.Text.Trim();

            if (approvalStatus == "Approved" && string.IsNullOrEmpty(password))
            {
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        #region Private Methods

        // Add these methods after your existing private methods

        private string GetNatureOfBusiness()
        {
            StringBuilder sb = new StringBuilder();
            if (chkManufacturer.Checked) sb.Append("Manufacturer,");
            if (chkDistributor.Checked) sb.Append("Distributor / Dealer,");
            if (chkImporter.Checked) sb.Append("Importer / Exporter,");
            if (chkServiceProvider.Checked) sb.Append("Service Provider,");
            if (chkTechnologyProvider.Checked) sb.Append("Technology Provider,");
            if (chkRnDServices.Checked) sb.Append("R&D / Testing Services,");
            if (chkConsultancy.Checked) sb.Append("Consultancy,");
            if (chkIndustryAssociation.Checked) sb.Append("Industry Association,");
            if (chkNatureOther.Checked && !string.IsNullOrEmpty(txtNatureOther.Text.Trim()))
                sb.Append("Other: " + txtNatureOther.Text.Trim() + ",");

            return sb.ToString().TrimEnd(',');
        }

        private string GetCompanyCategory()
        {
            StringBuilder sb = new StringBuilder();
            if (chkAutomotiveLubricants.Checked) sb.Append("Automotive Lubricants,");
            if (chkIndustrialLubricants.Checked) sb.Append("Industrial Lubricants,");
            if (chkBaseOils.Checked) sb.Append("Base Oils,");
            if (chkAdditives.Checked) sb.Append("Additives,");
            if (chkGreases.Checked) sb.Append("Greases,");
            if (chkSpecialtyFluids.Checked) sb.Append("Specialty Fluids,");
            if (chkBioBasedLubricants.Checked) sb.Append("Bio-based / Sustainable Lubricants,");
            if (chkReRefinedOils.Checked) sb.Append("Re-refined Oils / Circular Solutions,");
            if (chkPackaging.Checked) sb.Append("Packaging / Dispensing Equipment,");
            if (chkLabEquipment.Checked) sb.Append("Laboratory / Testing Equipment,");
            if (chkLubricationSystems.Checked) sb.Append("Lubrication Systems & Services,");
            if (chkSoftwareAI.Checked) sb.Append("Software / AI Solutions for Lubricants,");
            if (chkProductOther.Checked && !string.IsNullOrEmpty(txtProductOther.Text.Trim()))
                sb.Append("Others: " + txtProductOther.Text.Trim() + ",");

            return sb.ToString().TrimEnd(',');
        }

        private string GetMarketsCatered()
        {
            StringBuilder sb = new StringBuilder();
            if (chkAutomotive.Checked) sb.Append("Automotive,");
            if (chkHeavyCommercial.Checked) sb.Append("Heavy Commercial Vehicles,");
            if (chkRailways.Checked) sb.Append("Railways,");
            if (chkMarine.Checked) sb.Append("Marine,");
            if (chkAerospace.Checked) sb.Append("Aerospace,");
            if (chkManufacturing.Checked) sb.Append("Manufacturing & Processing Industries,");
            if (chkPowerEnergy.Checked) sb.Append("Power & Energy,");
            if (chkConstruction.Checked) sb.Append("Construction & Mining,");
            if (chkAgriculture.Checked) sb.Append("Agriculture,");
            if (chkFMCG.Checked) sb.Append("FMCG / Food Processing,");
            if (chkMarketOther.Checked && !string.IsNullOrEmpty(txtMarketOther.Text.Trim()))
                sb.Append("Other: " + txtMarketOther.Text.Trim() + ",");

            return sb.ToString().TrimEnd(',');
        }

        private string GetGeographicReach()
        {
            StringBuilder sb = new StringBuilder();
            if (chkIndiaOnly.Checked) sb.Append("India Only,");
            if (chkSouthAsia.Checked) sb.Append("South Asia,");
            if (chkAsiaPacific.Checked) sb.Append("Asia-Pacific,");
            if (chkMiddleEast.Checked) sb.Append("Middle East,");
            if (chkAfrica.Checked) sb.Append("Africa,");
            if (chkEurope.Checked) sb.Append("Europe,");
            if (chkGlobal.Checked) sb.Append("Global,");

            return sb.ToString().TrimEnd(',');
        }

        private string GetParticipationObjectives()
        {
            StringBuilder sb = new StringBuilder();
            if (chkGenerateLeads.Checked) sb.Append("Generate Business Leads,");
            if (chkLaunchProducts.Checked) sb.Append("Launch New Products,");
            if (chkNetworking.Checked) sb.Append("Network with Industry Professionals,");
            if (chkFindPartners.Checked) sb.Append("Find Distribution Partners,");
            if (chkMarketResearch.Checked) sb.Append("Market Research,");
            if (chkBrandVisibility.Checked) sb.Append("Brand Visibility,");
            if (chkAttendConference.Checked) sb.Append("Attend Conference Sessions,");
            if (chkRecruitTalent.Checked) sb.Append("Recruit Talent,");
            if (chkObjectiveOther.Checked && !string.IsNullOrEmpty(txtObjectiveOther.Text.Trim()))
                sb.Append("Other: " + txtObjectiveOther.Text.Trim() + ",");

            return sb.ToString().TrimEnd(',');
        }

        private bool HasPostApprovalData()
        {
            // Check if any post-approval field has data
            return !string.IsNullOrEmpty(txtBoothNo.Text.Trim()) ||
                   !string.IsNullOrEmpty(txtHallNo.Text.Trim()) ||
                   !string.IsNullOrEmpty(txtYearOfEstablishment.Text.Trim()) ||
                   !string.IsNullOrEmpty(txtWebsite.Text.Trim()) ||
                   !string.IsNullOrEmpty(txtSupportName.Text.Trim());
        }

        private bool ValidatePostApprovalFields()
        {
            // Only validate if user has started filling post-approval data
            if (!HasPostApprovalData())
                return true; // If no data entered, no validation needed

            // If any post-approval data exists, validate required fields
            if (string.IsNullOrEmpty(txtBoothNo.Text.Trim()))
            {
                ShowMessage("Booth No is required for post-approval profile.", "danger");
                return false;
            }

            if (string.IsNullOrEmpty(txtHallNo.Text.Trim()))
            {
                ShowMessage("Hall No is required for post-approval profile.", "danger");
                return false;
            }

            if (string.IsNullOrEmpty(txtYearOfEstablishment.Text.Trim()))
            {
                ShowMessage("Year of Establishment is required for post-approval profile.", "danger");
                return false;
            }

            if (string.IsNullOrEmpty(txtWebsite.Text.Trim()))
            {
                ShowMessage("Website is required for post-approval profile.", "danger");
                return false;
            }

            if (string.IsNullOrEmpty(txtSupportName.Text.Trim()))
            {
                ShowMessage("Customer Support Name is required for post-approval profile.", "danger");
                return false;
            }

            if (string.IsNullOrEmpty(txtSupportContact.Text.Trim()))
            {
                ShowMessage("Customer Support Contact is required for post-approval profile.", "danger");
                return false;
            }

            if (string.IsNullOrEmpty(txtSupportEmail.Text.Trim()))
            {
                ShowMessage("Customer Support Email is required for post-approval profile.", "danger");
                return false;
            }

            // Validate checkbox groups
            if (!chkManufacturer.Checked && !chkDistributor.Checked && !chkImporter.Checked &&
                !chkServiceProvider.Checked && !chkTechnologyProvider.Checked && !chkRnDServices.Checked &&
                !chkConsultancy.Checked && !chkIndustryAssociation.Checked && !chkNatureOther.Checked)
            {
                ShowMessage("Please select at least one Nature of Business.", "danger");
                return false;
            }

            if (!chkAutomotiveLubricants.Checked && !chkIndustrialLubricants.Checked && !chkBaseOils.Checked &&
                !chkAdditives.Checked && !chkGreases.Checked && !chkSpecialtyFluids.Checked &&
                !chkBioBasedLubricants.Checked && !chkReRefinedOils.Checked && !chkPackaging.Checked &&
                !chkLabEquipment.Checked && !chkLubricationSystems.Checked && !chkSoftwareAI.Checked &&
                !chkProductOther.Checked)
            {
                ShowMessage("Please select at least one Company Category.", "danger");
                return false;
            }

            if (!chkAutomotive.Checked && !chkHeavyCommercial.Checked && !chkRailways.Checked &&
                !chkMarine.Checked && !chkAerospace.Checked && !chkManufacturing.Checked &&
                !chkPowerEnergy.Checked && !chkConstruction.Checked && !chkAgriculture.Checked &&
                !chkFMCG.Checked && !chkMarketOther.Checked)
            {
                ShowMessage("Please select at least one Market.", "danger");
                return false;
            }

            if (!chkIndiaOnly.Checked && !chkSouthAsia.Checked && !chkAsiaPacific.Checked &&
                !chkMiddleEast.Checked && !chkAfrica.Checked && !chkEurope.Checked && !chkGlobal.Checked)
            {
                ShowMessage("Please select at least one Geographic Reach.", "danger");
                return false;
            }

            if (!chkGenerateLeads.Checked && !chkLaunchProducts.Checked && !chkNetworking.Checked &&
                !chkFindPartners.Checked && !chkMarketResearch.Checked && !chkBrandVisibility.Checked &&
                !chkAttendConference.Checked && !chkRecruitTalent.Checked && !chkObjectiveOther.Checked)
            {
                ShowMessage("Please select at least one Participation Objective.", "danger");
                return false;
            }

            return true;
        }
        private void LoadStatusCounts()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetExhibitorStatusCounts", con))
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

        private void LoadExhibitors(string searchText, string approvalStatus)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand(@"
                        SELECT 
                            e.ExhibitorID,
                            e.Name,
                            e.Email,
                            e.Mobile,
                            e.Designation,
                            e.Company,
                            e.RegistrationType,
                            e.ApprovalStatus,
                            e.Remarks,
                            e.IS_ACTIVE,
                            e.CreatedDate,
                            e.ModifiedDate,
                            e.ApprovedBy,
                            e.ApprovalDate,
                            CASE WHEN EXISTS (
                                SELECT 1 FROM TBL.PostApprovalExhibitor pa 
                                WHERE pa.ExhibitorID = e.ExhibitorID AND pa.IS_ACTIVE = 1
                            ) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasProfile
                        FROM TBL.Exhibitor e
                        WHERE 
                            (@SearchText IS NULL OR @SearchText = '' OR
                             e.Name LIKE '%' + @SearchText + '%' OR
                             e.Email LIKE '%' + @SearchText + '%' OR
                             e.Mobile LIKE '%' + @SearchText + '%' OR
                             e.Designation LIKE '%' + @SearchText + '%' OR
                             e.Company LIKE '%' + @SearchText + '%')
                            AND (@ApprovalStatus IS NULL OR e.ApprovalStatus = @ApprovalStatus)
                        ORDER BY 
                            CASE e.ApprovalStatus
                                WHEN 'Pending' THEN 1
                                WHEN 'Approved' THEN 2
                                WHEN 'Rejected' THEN 3
                            END,
                            e.CreatedDate DESC", con))
                    {
                        cmd.Parameters.AddWithValue("@SearchText", string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText);
                        cmd.Parameters.AddWithValue("@ApprovalStatus", string.IsNullOrEmpty(approvalStatus) ? (object)DBNull.Value : approvalStatus);

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        gvExhibitors.DataSource = dt;
                        gvExhibitors.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading exhibitors: " + ex.Message, "danger");
            }
        }

        private void LoadExhibitorForEdit(int exhibitorId)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine($"=== LoadExhibitorForEdit called for ID: {exhibitorId} ===");

                StringBuilder json = new StringBuilder();
                json.Append("{");

                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    con.Open();

                    // Get pre-approval data
                    using (SqlCommand cmd = new SqlCommand("sp_GetExhibitorById", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);

                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            // Build JSON data for pre-approval fields
                            json.AppendFormat("\"id\": {0},", exhibitorId);
                            json.AppendFormat("\"name\": \"{0}\",", EscapeJson(reader["Name"]));
                            json.AppendFormat("\"designation\": \"{0}\",", EscapeJson(reader["Designation"]));
                            json.AppendFormat("\"email\": \"{0}\",", EscapeJson(reader["Email"]));
                            json.AppendFormat("\"mobile\": \"{0}\",", EscapeJson(reader["Mobile"]));
                            json.AppendFormat("\"company\": \"{0}\",", EscapeJson(reader["Company"]));
                            json.AppendFormat("\"headOffice\": \"{0}\",", EscapeJson(reader["HeadOfficeAddress"]));
                            json.AppendFormat("\"city\": \"{0}\",", EscapeJson(reader["City"]));
                            json.AppendFormat("\"state\": \"{0}\",", EscapeJson(reader["State"]));
                            json.AppendFormat("\"country\": \"{0}\",", EscapeJson(reader["Country"]));
                            json.AppendFormat("\"gst\": \"{0}\",", EscapeJson(reader["GSTNumber"]));
                            json.AppendFormat("\"billing\": \"{0}\",", EscapeJson(reader["BillingAddress"]));
                            json.AppendFormat("\"boothType\": \"{0}\",", EscapeJson(reader["BoothType"]));
                            json.AppendFormat("\"area\": \"{0}\",", reader["AreaInSqm"] != DBNull.Value ? reader["AreaInSqm"].ToString() : "");
                            json.AppendFormat("\"conference\": {0},", reader["InterestedInConference"] != DBNull.Value && Convert.ToBoolean(reader["InterestedInConference"]) ? "true" : "false");
                            json.AppendFormat("\"sponsorship\": {0},", reader["InterestedInSponsorship"] != DBNull.Value && Convert.ToBoolean(reader["InterestedInSponsorship"]) ? "true" : "false");
                            json.AppendFormat("\"advertising\": {0},", reader["InterestedInAdvertising"] != DBNull.Value && Convert.ToBoolean(reader["InterestedInAdvertising"]) ? "true" : "false");
                            json.AppendFormat("\"customPackage\": {0},", reader["InterestedInCustomPackage"] != DBNull.Value && Convert.ToBoolean(reader["InterestedInCustomPackage"]) ? "true" : "false");
                            json.AppendFormat("\"isActive\": \"{0}\",", reader["IS_ACTIVE"] != DBNull.Value && Convert.ToBoolean(reader["IS_ACTIVE"]) ? "1" : "0");
                            json.AppendFormat("\"regType\": \"{0}\"", reader["RegistrationType"] != DBNull.Value ? reader["RegistrationType"].ToString() : "Admin");

                            reader.Close();

                            System.Diagnostics.Debug.WriteLine("Pre-approval data loaded successfully");
                        }
                        else
                        {
                            ShowMessage("Exhibitor not found.", "danger");
                            return;
                        }
                    }

                    // Get post-approval data - CALL THE CORRECT METHOD
                    string postApprovalData = LoadPostApprovalDataForEdit(exhibitorId, con);
                    if (!string.IsNullOrEmpty(postApprovalData))
                    {
                        System.Diagnostics.Debug.WriteLine("Post-approval data found, appending to JSON");
                        json.Append(",");
                        json.Append(postApprovalData);
                    }
                    else
                    {
                        System.Diagnostics.Debug.WriteLine("No post-approval data found");
                    }
                }

                json.Append("}");

                // Debug: Log the complete JSON
                string jsonString = json.ToString();
                System.Diagnostics.Debug.WriteLine("=== Complete JSON ===");
                System.Diagnostics.Debug.WriteLine(jsonString);
                System.Diagnostics.Debug.WriteLine("=== End JSON ===");

                // Call JavaScript function with data
                string script = $"openExhibitorModal('edit', {jsonString});";
                ScriptManager.RegisterStartupScript(this, GetType(), "openEditModal_" + exhibitorId, script, true);
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading exhibitor for edit: " + ex.Message, "danger");
                System.Diagnostics.Debug.WriteLine("Error in LoadExhibitorForEdit: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Stack trace: " + ex.StackTrace);
            }
        }


        private string EscapeJson(object value)
        {
            if (value == null || value == DBNull.Value)
                return "";

            return value.ToString()
                .Replace("\\", "\\\\")
                .Replace("\"", "\\\"")
                .Replace("\n", "\\n")
                .Replace("\r", "")
                .Replace("\t", "\\t");
        }




        private void LoadExhibitorForApproval(int exhibitorId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string query = @"
                        SELECT 
                            e.ExhibitorID, e.Name, e.Email, e.Company, e.RegistrationType, 
                            e.ApprovalStatus, e.Remarks, e.Password, e.AreaInSqm,
                            p.HallNo, p.BoothNo
                        FROM TBL.Exhibitor e
                        LEFT JOIN TBL.PostApprovalExhibitor p ON e.ExhibitorID = p.ExhibitorID AND p.IS_ACTIVE = 1
                        WHERE e.ExhibitorID = @ExhibitorID";

                    // ✅ FIXED: Use 'query' variable and CommandType.Text
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.CommandType = CommandType.Text;
                        cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
                        con.Open();

                        SqlDataReader reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            hdnApprovalExhibitorID.Value = exhibitorId.ToString();

                            // All of these are null-safe, which is critical
                            string name = reader["Name"] != DBNull.Value ? reader["Name"].ToString().Replace("'", "\\'") : "";
                            string email = reader["Email"] != DBNull.Value ? reader["Email"].ToString().Replace("'", "\\'") : "";
                            string company = reader["Company"] != DBNull.Value ? reader["Company"].ToString().Replace("'", "\\'") : "";
                            string regType = reader["RegistrationType"] != DBNull.Value ? reader["RegistrationType"].ToString().Replace("'", "\\'") : "Admin";
                            string approvalStatus = reader["ApprovalStatus"] != DBNull.Value ? reader["ApprovalStatus"].ToString() : "Pending";
                            string remarks = reader["Remarks"] != DBNull.Value ? reader["Remarks"].ToString().Replace("'", "\\'").Replace("\r", "").Replace("\n", "\\n") : "";

                            // This is the line that reads the password you added
                            // This is the line that reads the password you added
                            string password = reader["Password"] != DBNull.Value ? reader["Password"].ToString().Replace("'", "\\'") : "";
                            string hall = reader["HallNo"] != DBNull.Value ? reader["HallNo"].ToString().Replace("'", "\\'") : "";
                            string booth = reader["BoothNo"] != DBNull.Value ? reader["BoothNo"].ToString().Replace("'", "\\'") : "";
                            string area = reader["AreaInSqm"] != DBNull.Value ? reader["AreaInSqm"].ToString() : "";

                            // ✅ FIXED: Added hall, booth, and area to the function call
                            string script = $"openApprovalModal({exhibitorId}, '{name}', '{email}', '{company}', '{regType}', '{approvalStatus}', '{remarks}', '{password}', '{hall}', '{booth}', '{area}');";
                            ScriptManager.RegisterStartupScript(this, GetType(), "openApprovalModal", script, true);
                        }
                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                // This will now properly catch and display any errors
                ShowMessage("Error loading exhibitor for approval: " + ex.Message, "danger");
            }
        }


        private string LoadPostApprovalDataForEdit(int exhibitorId, SqlConnection con)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine($"Loading post-approval data for exhibitor: {exhibitorId}");

                using (SqlCommand cmd = new SqlCommand("sp_GetPostApprovalProfileByExhibitorID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);

                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        System.Diagnostics.Debug.WriteLine("Post-approval record found!");

                        StringBuilder sb = new StringBuilder();

                        // ALL PROPERTY NAMES WITH DOUBLE QUOTES FOR PROPER JSON
                        sb.AppendFormat("\"boothNo\": \"{0}\",", EscapeJson(dr["BoothNo"]));
                        sb.AppendFormat("\"hallNo\": \"{0}\",", EscapeJson(dr["HallNo"]));
                        sb.AppendFormat("\"exhibitorProfile\": \"{0}\",", EscapeJson(dr["ExhibitorProfile"]));  // ADD THIS
                        sb.AppendFormat("\"yearOfEstablishment\": \"{0}\",", dr["YearOfEstablishment"] != DBNull.Value ? dr["YearOfEstablishment"].ToString() : "");
                        sb.AppendFormat("\"website\": \"{0}\",", EscapeJson(dr["Website"]));
                        sb.AppendFormat("\"linkedIn\": \"{0}\",", EscapeJson(dr["LinkedIn"]));
                        sb.AppendFormat("\"twitter\": \"{0}\",", EscapeJson(dr["Twitter"]));
                        sb.AppendFormat("\"facebook\": \"{0}\",", EscapeJson(dr["Facebook"]));
                        sb.AppendFormat("\"youtube\": \"{0}\",", EscapeJson(dr["YouTube"]));
                        sb.AppendFormat("\"supportName\": \"{0}\",", EscapeJson(dr["CustomerSupportName"]));
                        sb.AppendFormat("\"supportContact\": \"{0}\",", EscapeJson(dr["CustomerSupportContact"]));
                        sb.AppendFormat("\"supportEmail\": \"{0}\",", EscapeJson(dr["CustomerSupportEmail"]));
                        sb.AppendFormat("\"natureOfBusiness\": \"{0}\",", EscapeJson(dr["NatureOfBusiness"]));
                        sb.AppendFormat("\"companyCategory\": \"{0}\",", EscapeJson(dr["CompanyCategory"]));
                        sb.AppendFormat("\"marketsCatered\": \"{0}\",", EscapeJson(dr["MarketsCateredTo"]));
                        sb.AppendFormat("\"geographicReach\": \"{0}\",", EscapeJson(dr["GeographicReach"]));
                        sb.AppendFormat("\"powerSupply\": \"{0}\",", dr["PowerSupplyRequired"] != DBNull.Value ? dr["PowerSupplyRequired"].ToString() : "False");
                        sb.AppendFormat("\"powerKwh\": \"{0}\",", dr["PowerSupplyKwh"] != DBNull.Value ? dr["PowerSupplyKwh"].ToString() : "");
                        sb.AppendFormat("\"internet\": \"{0}\",", dr["InternetRequired"] != DBNull.Value ? dr["InternetRequired"].ToString() : "False");
                        sb.AppendFormat("\"furniture\": \"{0}\",", dr["FurnitureRentalRequired"] != DBNull.Value ? dr["FurnitureRentalRequired"].ToString() : "False");
                        sb.AppendFormat("\"avEquipment\": \"{0}\",", dr["AVEquipmentRequired"] != DBNull.Value ? dr["AVEquipmentRequired"].ToString() : "False");
                        sb.AppendFormat("\"interpreter\": \"{0}\",", dr["InterpreterSupportRequired"] != DBNull.Value ? dr["InterpreterSupportRequired"].ToString() : "False");
                        sb.AppendFormat("\"otherReq\": \"{0}\",", EscapeJson(dr["OtherRequirements"]));
                        sb.AppendFormat("\"objectives\": \"{0}\",", EscapeJson(dr["ParticipationObjectives"]));
                        sb.AppendFormat("\"additionalNotes\": \"{0}\",", EscapeJson(dr["AdditionalNotes"]));
                        sb.AppendFormat("\"productPicture\": \"{0}\",", EscapeJson(dr["ProductPicturePath"]));
                        sb.AppendFormat("\"brochure\": \"{0}\",", EscapeJson(dr["BrochurePath"])); // <--- Comma added
                        sb.AppendFormat("\"logo\": \"{0}\"", EscapeJson(dr["LogoPath"]));

                        dr.Close();

                        string result = sb.ToString();
                        System.Diagnostics.Debug.WriteLine("Post-approval JSON generated successfully");
                        System.Diagnostics.Debug.WriteLine("Sample data: " + result.Substring(0, Math.Min(200, result.Length)));

                        return result;
                    }

                    dr.Close();
                    System.Diagnostics.Debug.WriteLine("No post-approval data found for exhibitor: " + exhibitorId);
                    return "";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading post-approval data: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Stack trace: " + ex.StackTrace);
                return "";
            }
        }

        private void AddExhibitor(string name, string email, string mobile, string designation, string company,
            string headOffice, string city, string state, string country, string gstNumber, string billingAddress,
            string boothType, decimal? areaInSqm, bool conference, bool sponsorship, bool advertising,
            bool customPackage, bool isActive, string registrationType)
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
                    cmd.Parameters.AddWithValue("@AreaInSqm", areaInSqm.HasValue ? (object)areaInSqm.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@InterestedInConference", conference);
                    cmd.Parameters.AddWithValue("@InterestedInSponsorship", sponsorship);
                    cmd.Parameters.AddWithValue("@InterestedInAdvertising", advertising);
                    cmd.Parameters.AddWithValue("@InterestedInCustomPackage", customPackage);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);
                    cmd.Parameters.AddWithValue("@RegistrationType", registrationType);

                    SqlParameter outParam = new SqlParameter("@ExhibitorID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outParam);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateExhibitor(int exhibitorId, string name, string email, string mobile, string designation,
            string company, string headOffice, string city, string state, string country, string gstNumber,
            string billingAddress, string boothType, decimal? areaInSqm, bool conference, bool sponsorship,
            bool advertising, bool customPackage, bool isActive)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateExhibitor", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
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
                    cmd.Parameters.AddWithValue("@AreaInSqm", areaInSqm.HasValue ? (object)areaInSqm.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@InterestedInConference", conference);
                    cmd.Parameters.AddWithValue("@InterestedInSponsorship", sponsorship);
                    cmd.Parameters.AddWithValue("@InterestedInAdvertising", advertising);
                    cmd.Parameters.AddWithValue("@InterestedInCustomPackage", customPackage);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateApprovalStatus(int exhibitorId, string approvalStatus, string remarks, string password, int approvedBy)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(@"
                    UPDATE TBL.Exhibitor
                    SET 
                        ApprovalStatus = @ApprovalStatus,
                        Remarks = @Remarks,
                        Password = CASE WHEN @ApprovalStatus = 'Approved' THEN @Password ELSE Password END,
                        ApprovedBy = @ApprovedBy,
                        ApprovalDate = GETDATE(),
                        ModifiedDate = GETDATE()
                    WHERE ExhibitorID = @ExhibitorID", con))
                {
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
                    cmd.Parameters.AddWithValue("@ApprovalStatus", approvalStatus);
                    cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks);
                    cmd.Parameters.AddWithValue("@Password", string.IsNullOrEmpty(password) ? (object)DBNull.Value : password);
                    cmd.Parameters.AddWithValue("@ApprovedBy", approvedBy);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private string GenerateRandomPassword()
        {
            // This is a simple trick. It generates a random 8.3 filename (like "a1b2c3d4.e5f")
            // and we just remove the dot to get an 11-character alphanumeric password.
            return Path.GetRandomFileName().Replace(".", "");
        }
        private void ToggleExhibitorStatus(int exhibitorId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_ToggleExhibitorStatus", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowMessage("Exhibitor status updated successfully!", "success");
                string currentFilter = hdnCurrentFilter.Value;
                LoadExhibitors(txtSearch.Text.Trim(), currentFilter);
                LoadStatusCounts();
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating status: " + ex.Message, "danger");
            }
        }

        private void ClearExhibitorForm()
        {
            // Pre-Approval Fields
            txtName.Text = "";
            txtDesignation.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
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
            ddlStatus.SelectedIndex = 0;
            ddlRegistrationType.SelectedIndex = 0;

            // Post-Approval Fields
            txtBoothNo.Text = "";
            txtHallNo.Text = "";
            txtExhibitorProfile.Text = "";
            txtYearOfEstablishment.Text = "";
            txtWebsite.Text = "";
            txtLinkedIn.Text = "";
            txtTwitter.Text = "";
            txtFacebook.Text = "";
            txtYouTube.Text = "";
            txtSupportName.Text = "";
            txtSupportContact.Text = "";
            txtSupportEmail.Text = "";

            // Checkboxes - Nature of Business
            chkManufacturer.Checked = false;
            chkDistributor.Checked = false;
            chkImporter.Checked = false;
            chkServiceProvider.Checked = false;
            chkTechnologyProvider.Checked = false;
            chkRnDServices.Checked = false;
            chkConsultancy.Checked = false;
            chkIndustryAssociation.Checked = false;
            chkNatureOther.Checked = false;
            txtNatureOther.Text = "";

            // Company Category
            chkAutomotiveLubricants.Checked = false;
            chkIndustrialLubricants.Checked = false;
            chkBaseOils.Checked = false;
            chkAdditives.Checked = false;
            chkGreases.Checked = false;
            chkSpecialtyFluids.Checked = false;
            chkBioBasedLubricants.Checked = false;
            chkReRefinedOils.Checked = false;
            chkPackaging.Checked = false;
            chkLabEquipment.Checked = false;
            chkLubricationSystems.Checked = false;
            chkSoftwareAI.Checked = false;
            chkProductOther.Checked = false;
            txtProductOther.Text = "";

            // Markets
            chkAutomotive.Checked = false;
            chkHeavyCommercial.Checked = false;
            chkRailways.Checked = false;
            chkMarine.Checked = false;
            chkAerospace.Checked = false;
            chkManufacturing.Checked = false;
            chkPowerEnergy.Checked = false;
            chkConstruction.Checked = false;
            chkAgriculture.Checked = false;
            chkFMCG.Checked = false;
            chkMarketOther.Checked = false;
            txtMarketOther.Text = "";

            // Geographic Reach
            chkIndiaOnly.Checked = false;
            chkSouthAsia.Checked = false;
            chkAsiaPacific.Checked = false;
            chkMiddleEast.Checked = false;
            chkAfrica.Checked = false;
            chkEurope.Checked = false;
            chkGlobal.Checked = false;

            // Requirements
            chkPowerSupply.Checked = false;
            txtPowerSupplyKwh.Text = "";
            chkInternet.Checked = false;
            chkFurniture.Checked = false;
            chkAVEquipment.Checked = false;
            chkInterpreter.Checked = false;
            chkReqOther.Checked = false;
            txtReqOther.Text = "";

            // Objectives
            chkGenerateLeads.Checked = false;
            chkLaunchProducts.Checked = false;
            chkNetworking.Checked = false;
            chkFindPartners.Checked = false;
            chkMarketResearch.Checked = false;
            chkBrandVisibility.Checked = false;
            chkAttendConference.Checked = false;
            chkRecruitTalent.Checked = false;
            chkObjectiveOther.Checked = false;
            txtObjectiveOther.Text = "";

            txtAdditionalNotes.Text = "";

            lblProductPictureStatus.Visible = false;
            lblBrochureStatus.Visible = false;

            hdnExhibitorID.Value = "0";
            hdnExhibitorModalMode.Value = "add";
        }

        private void LoadPostApprovalProfile(int exhibitorId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetPostApprovalProfileByExhibitorID", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            StringBuilder profileHtml = new StringBuilder();

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-building'></i> Exhibitor Information</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Exhibitor Name:</div><div class='info-value'>{0}</div></div>", reader["ExhibitorName"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Company:</div><div class='info-value'>{0}</div></div>", reader["Company"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Email:</div><div class='info-value'>{0}</div></div>", reader["ExhibitorEmail"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-map-marker-alt'></i> Booth Information</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Booth No:</div><div class='info-value'>{0}</div></div>", reader["BoothNo"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Hall No:</div><div class='info-value'>{0}</div></div>", reader["HallNo"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-info-circle'></i> Company Profile</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Year of Establishment:</div><div class='info-value'>{0}</div></div>", reader["YearOfEstablishment"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Website:</div><div class='info-value'><a href='{0}' target='_blank'>{0}</a></div></div>", reader["Website"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-share-alt'></i> Social Media</div>");
                            if (reader["LinkedIn"] != DBNull.Value && !string.IsNullOrEmpty(reader["LinkedIn"].ToString()))
                                profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>LinkedIn:</div><div class='info-value'><a href='{0}' target='_blank'>{0}</a></div></div>", reader["LinkedIn"]);
                            if (reader["Twitter"] != DBNull.Value && !string.IsNullOrEmpty(reader["Twitter"].ToString()))
                                profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Twitter:</div><div class='info-value'><a href='{0}' target='_blank'>{0}</a></div></div>", reader["Twitter"]);
                            if (reader["Facebook"] != DBNull.Value && !string.IsNullOrEmpty(reader["Facebook"].ToString()))
                                profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Facebook:</div><div class='info-value'><a href='{0}' target='_blank'>{0}</a></div></div>", reader["Facebook"]);
                            if (reader["YouTube"] != DBNull.Value && !string.IsNullOrEmpty(reader["YouTube"].ToString()))
                                profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>YouTube:</div><div class='info-value'><a href='{0}' target='_blank'>{0}</a></div></div>", reader["YouTube"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-headset'></i> Customer Support</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Contact Person:</div><div class='info-value'>{0}</div></div>", reader["CustomerSupportName"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Contact Number:</div><div class='info-value'>{0}</div></div>", reader["CustomerSupportContact"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Email:</div><div class='info-value'>{0}</div></div>", reader["CustomerSupportEmail"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-briefcase'></i> Business Details</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Nature of Business:</div><div class='info-value'>{0}</div></div>", reader["NatureOfBusiness"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Company Category:</div><div class='info-value'>{0}</div></div>", reader["CompanyCategory"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Markets Catered:</div><div class='info-value'>{0}</div></div>", reader["MarketsCateredTo"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Geographic Reach:</div><div class='info-value'>{0}</div></div>", reader["GeographicReach"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-cogs'></i> Requirements</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Power Supply:</div><div class='info-value'>{0}</div></div>",
                                Convert.ToBoolean(reader["PowerSupplyRequired"]) ? $"Yes ({reader["PowerSupplyKwh"]} Kwh)" : "No");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Internet:</div><div class='info-value'>{0}</div></div>",
                                Convert.ToBoolean(reader["InternetRequired"]) ? "Yes" : "No");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Furniture Rental:</div><div class='info-value'>{0}</div></div>",
                                Convert.ToBoolean(reader["FurnitureRentalRequired"]) ? "Yes" : "No");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>AV Equipment:</div><div class='info-value'>{0}</div></div>",
                                Convert.ToBoolean(reader["AVEquipmentRequired"]) ? "Yes" : "No");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Interpreter Support:</div><div class='info-value'>{0}</div></div>",
                                Convert.ToBoolean(reader["InterpreterSupportRequired"]) ? "Yes" : "No");
                            if (reader["OtherRequirements"] != DBNull.Value && !string.IsNullOrEmpty(reader["OtherRequirements"].ToString()))
                                profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Other Requirements:</div><div class='info-value'>{0}</div></div>", reader["OtherRequirements"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-bullseye'></i> Participation Objectives</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Objectives:</div><div class='info-value'>{0}</div></div>", reader["ParticipationObjectives"]);
                            profileHtml.Append("</div>");

                            if (reader["AdditionalNotes"] != DBNull.Value && !string.IsNullOrEmpty(reader["AdditionalNotes"].ToString()))
                            {
                                // This section was named "Documents" in your original file, so I kept it
                                profileHtml.Append("<div class='profile-section'>");
                                profileHtml.Append("<div class='profile-section-title'><i class='fas fa-file'></i> Documents</div>");
                                if (reader["ProductPicturePath"] != DBNull.Value && !string.IsNullOrEmpty(reader["ProductPicturePath"].ToString()))
                                    profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Product Picture:</div><div class='info-value'><a href='{0}' target='_blank'>View Document</a></div></div>", Page.ResolveUrl(reader["ProductPicturePath"].ToString()));
                                if (reader["BrochurePath"] != DBNull.Value && !string.IsNullOrEmpty(reader["BrochurePath"].ToString()))
                                    profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Brochure:</div><div class='info-value'><a href='{0}' target='_blank'>View Document</a></div></div>", Page.ResolveUrl(reader["BrochurePath"].ToString()));
                                profileHtml.Append("</div>");
                            }


                            string script = "openProfileModal();";
                            ScriptManager.RegisterStartupScript(this, GetType(), "openProfileModal", script, true);
                        }
                        else
                        {
                            ShowMessage("Profile not found for this exhibitor.", "danger");
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading profile: " + ex.Message, "danger");
            }
        }

        protected void btnTriggerViewProfile_Click(object sender, EventArgs e)
        {
            try
            {
                int exhibitorId = Convert.ToInt32(hdnViewProfileExhibitorID.Value);
                LoadPostApprovalProfile(exhibitorId);
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading profile: " + ex.Message, "danger");
            }
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "success" ? "alert-success" : (type == "info" ? "alert-info" : "alert-danger");
            string icon = type == "success" ? "fa-check-circle" : (type == "info" ? "fa-info-circle" : "fa-exclamation-circle");

            litMessage.Text = $@"
                <div class='alert {cssClass}'>
                    <i class='fas {icon}'></i>
                    {message}
                </div>";
        }

        #endregion



        [System.Web.Services.WebMethod]
        public static string GetExhibitorData(int exhibitorId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetExhibitorById", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);

                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // Build JSON object
                        StringBuilder json = new StringBuilder();
                        json.Append("{");
                        json.AppendFormat("\"id\": {0},", exhibitorId);
                        json.AppendFormat("\"name\": \"{0}\",", reader["Name"] != DBNull.Value ? reader["Name"].ToString().Replace("\"", "\\\"") : "");
                        json.AppendFormat("\"designation\": \"{0}\",", reader["Designation"] != DBNull.Value ? reader["Designation"].ToString().Replace("\"", "\\\"") : "");
                        json.AppendFormat("\"email\": \"{0}\",", reader["Email"] != DBNull.Value ? reader["Email"].ToString().Replace("\"", "\\\"") : "");
                        json.AppendFormat("\"mobile\": \"{0}\",", reader["Mobile"] != DBNull.Value ? reader["Mobile"].ToString().Replace("\"", "\\\"") : "");
                        json.AppendFormat("\"company\": \"{0}\",", reader["Company"] != DBNull.Value ? reader["Company"].ToString().Replace("\"", "\\\"") : "");
                        json.AppendFormat("\"headOffice\": \"{0}\",", reader["HeadOfficeAddress"] != DBNull.Value ? reader["HeadOfficeAddress"].ToString().Replace("\"", "\\\"").Replace("\n", "\\n").Replace("\r", "") : "");
                        json.AppendFormat("\"city\": \"{0}\",", reader["City"] != DBNull.Value ? reader["City"].ToString().Replace("\"", "\\\"") : "");
                        json.AppendFormat("\"state\": \"{0}\",", reader["State"] != DBNull.Value ? reader["State"].ToString().Replace("\"", "\\\"") : "");
                        json.AppendFormat("\"country\": \"{0}\",", reader["Country"] != DBNull.Value ? reader["Country"].ToString().Replace("\"", "\\\"") : "");
                        json.AppendFormat("\"gst\": \"{0}\",", reader["GSTNumber"] != DBNull.Value ? reader["GSTNumber"].ToString().Replace("\"", "\\\"") : "");
                        json.AppendFormat("\"billing\": \"{0}\",", reader["BillingAddress"] != DBNull.Value ? reader["BillingAddress"].ToString().Replace("\"", "\\\"").Replace("\n", "\\n").Replace("\r", "") : "");
                        json.AppendFormat("\"boothType\": \"{0}\",", reader["BoothType"] != DBNull.Value ? reader["BoothType"].ToString().Replace("\"", "\\\"") : "");
                        json.AppendFormat("\"area\": \"{0}\",", reader["AreaInSqm"] != DBNull.Value ? reader["AreaInSqm"].ToString() : "");
                        json.AppendFormat("\"conference\": {0},", reader["InterestedInConference"] != DBNull.Value && Convert.ToBoolean(reader["InterestedInConference"]) ? "true" : "false");
                        json.AppendFormat("\"sponsorship\": {0},", reader["InterestedInSponsorship"] != DBNull.Value && Convert.ToBoolean(reader["InterestedInSponsorship"]) ? "true" : "false");
                        json.AppendFormat("\"advertising\": {0},", reader["InterestedInAdvertising"] != DBNull.Value && Convert.ToBoolean(reader["InterestedInAdvertising"]) ? "true" : "false");
                        json.AppendFormat("\"customPackage\": {0},", reader["InterestedInCustomPackage"] != DBNull.Value && Convert.ToBoolean(reader["InterestedInCustomPackage"]) ? "true" : "false");
                        json.AppendFormat("\"isActive\": \"{0}\",", reader["IS_ACTIVE"] != DBNull.Value && Convert.ToBoolean(reader["IS_ACTIVE"]) ? "1" : "0");
                        json.AppendFormat("\"regType\": \"{0}\"", reader["RegistrationType"] != DBNull.Value ? reader["RegistrationType"].ToString() : "Admin");

                        reader.Close();

                        // Get post-approval data
                        string postApprovalData = GetPostApprovalDataStatic(exhibitorId, con);
                        if (!string.IsNullOrEmpty(postApprovalData))
                        {
                            json.Append(",");
                            json.Append(postApprovalData);
                        }

                        json.Append("}");
                        return json.ToString();
                    }

                    reader.Close();
                    return "{}";
                }
            }
        }

        // Helper 1: Updates Status + Area
        private void UpdateApprovalStatusWithArea(int exhibitorId, string approvalStatus, string remarks, string password, int approvedBy, decimal? area)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(@"
                    UPDATE TBL.Exhibitor
                    SET 
                        ApprovalStatus = @ApprovalStatus,
                        Remarks = @Remarks,
                        Password = CASE WHEN @ApprovalStatus = 'Approved' THEN @Password ELSE Password END,
                        ApprovedBy = @ApprovedBy,
                        ApprovalDate = GETDATE(),
                        ModifiedDate = GETDATE(),
                        AreaInSqm = @Area  -- Update Area here
                    WHERE ExhibitorID = @ExhibitorID", con))
                {
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
                    cmd.Parameters.AddWithValue("@ApprovalStatus", approvalStatus);
                    cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks);
                    cmd.Parameters.AddWithValue("@Password", string.IsNullOrEmpty(password) ? (object)DBNull.Value : password);
                    cmd.Parameters.AddWithValue("@ApprovedBy", approvedBy);
                    cmd.Parameters.AddWithValue("@Area", area.HasValue ? (object)area.Value : DBNull.Value);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // Helper 2: Updates Hall/Booth (Creates profile if missing)
        private void UpdateExhibitorLogistics(int exhibitorId, string hallNo, string boothNo)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                con.Open();
                // Check if profile exists
                bool exists = false;
                using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(1) FROM TBL.PostApprovalExhibitor WHERE ExhibitorID = @ID", con))
                {
                    checkCmd.Parameters.AddWithValue("@ID", exhibitorId);
                    exists = (int)checkCmd.ExecuteScalar() > 0;
                }

                if (exists)
                {
                    // Update existing
                    using (SqlCommand cmd = new SqlCommand("UPDATE TBL.PostApprovalExhibitor SET HallNo = @Hall, BoothNo = @Booth, ModifiedDate = GETDATE() WHERE ExhibitorID = @ID", con))
                    {
                        cmd.Parameters.AddWithValue("@ID", exhibitorId);
                        cmd.Parameters.AddWithValue("@Hall", hallNo);
                        cmd.Parameters.AddWithValue("@Booth", boothNo);
                        cmd.ExecuteNonQuery();
                    }
                }
                else
                {
                    // Create new partial profile
                    // Note: We fill required fields with placeholders or defaults to avoid SQL errors if columns are NOT NULL
                    string query = @"
                        INSERT INTO TBL.PostApprovalExhibitor 
                        (ExhibitorID, HallNo, BoothNo, CreatedDate, IS_ACTIVE, 
                         CustomerSupportName, CustomerSupportContact, CustomerSupportEmail, 
                         NatureOfBusiness, CompanyCategory, MarketsCateredTo, GeographicReach, ParticipationObjectives)
                        VALUES 
                        (@ID, @Hall, @Booth, GETDATE(), 1, 
                         'Pending', 'Pending', 'Pending', 
                         '', '', '', '', '')";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@ID", exhibitorId);
                        cmd.Parameters.AddWithValue("@Hall", hallNo);
                        cmd.Parameters.AddWithValue("@Booth", boothNo);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }

        private static string GetPostApprovalDataStatic(int exhibitorId, SqlConnection con)
        {
            using (SqlCommand cmd = new SqlCommand("sp_GetPostApprovalProfileByExhibitorID", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    StringBuilder sb = new StringBuilder();

                    sb.AppendFormat("\"boothNo\": \"{0}\",", dr["BoothNo"] != DBNull.Value ? dr["BoothNo"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"hallNo\": \"{0}\",", dr["HallNo"] != DBNull.Value ? dr["HallNo"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"yearOfEstablishment\": \"{0}\",", dr["YearOfEstablishment"] != DBNull.Value ? dr["YearOfEstablishment"].ToString() : "");
                    sb.AppendFormat("\"website\": \"{0}\",", dr["Website"] != DBNull.Value ? dr["Website"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"linkedIn\": \"{0}\",", dr["LinkedIn"] != DBNull.Value ? dr["LinkedIn"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"twitter\": \"{0}\",", dr["Twitter"] != DBNull.Value ? dr["Twitter"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"facebook\": \"{0}\",", dr["Facebook"] != DBNull.Value ? dr["Facebook"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"youtube\": \"{0}\",", dr["YouTube"] != DBNull.Value ? dr["YouTube"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"supportName\": \"{0}\",", dr["CustomerSupportName"] != DBNull.Value ? dr["CustomerSupportName"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"supportContact\": \"{0}\",", dr["CustomerSupportContact"] != DBNull.Value ? dr["CustomerSupportContact"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"supportEmail\": \"{0}\",", dr["CustomerSupportEmail"] != DBNull.Value ? dr["CustomerSupportEmail"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"natureOfBusiness\": \"{0}\",", dr["NatureOfBusiness"] != DBNull.Value ? dr["NatureOfBusiness"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"companyCategory\": \"{0}\",", dr["CompanyCategory"] != DBNull.Value ? dr["CompanyCategory"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"marketsCatered\": \"{0}\",", dr["MarketsCateredTo"] != DBNull.Value ? dr["MarketsCateredTo"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"geographicReach\": \"{0}\",", dr["GeographicReach"] != DBNull.Value ? dr["GeographicReach"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"powerSupply\": \"{0}\",", dr["PowerSupplyRequired"] != DBNull.Value ? dr["PowerSupplyRequired"].ToString() : "False");
                    sb.AppendFormat("\"powerKwh\": \"{0}\",", dr["PowerSupplyKwh"] != DBNull.Value ? dr["PowerSupplyKwh"].ToString() : "");
                    sb.AppendFormat("\"internet\": \"{0}\",", dr["InternetRequired"] != DBNull.Value ? dr["InternetRequired"].ToString() : "False");
                    sb.AppendFormat("\"furniture\": \"{0}\",", dr["FurnitureRentalRequired"] != DBNull.Value ? dr["FurnitureRentalRequired"].ToString() : "False");
                    sb.AppendFormat("\"avEquipment\": \"{0}\",", dr["AVEquipmentRequired"] != DBNull.Value ? dr["AVEquipmentRequired"].ToString() : "False");
                    sb.AppendFormat("\"interpreter\": \"{0}\",", dr["InterpreterSupportRequired"] != DBNull.Value ? dr["InterpreterSupportRequired"].ToString() : "False");
                    sb.AppendFormat("\"otherReq\": \"{0}\",", dr["OtherRequirements"] != DBNull.Value ? dr["OtherRequirements"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"objectives\": \"{0}\",", dr["ParticipationObjectives"] != DBNull.Value ? dr["ParticipationObjectives"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"additionalNotes\": \"{0}\",", dr["AdditionalNotes"] != DBNull.Value ? dr["AdditionalNotes"].ToString().Replace("\"", "\\\"").Replace("\n", "\\n").Replace("\r", "") : "");
                    sb.AppendFormat("\"productPicture\": \"{0}\",", dr["ProductPicturePath"] != DBNull.Value ? dr["ProductPicturePath"].ToString().Replace("\"", "\\\"") : "");
                    sb.AppendFormat("\"brochure\": \"{0}\"", dr["BrochurePath"] != DBNull.Value ? dr["BrochurePath"].ToString().Replace("\"", "\\\"") : "");

                    dr.Close();
                    return sb.ToString();
                }

                dr.Close();
                return "";
            }
        }
    }
}