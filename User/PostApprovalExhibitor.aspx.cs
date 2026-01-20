using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web.UI;

namespace Expo_Panel
{
    public partial class PostApprovalExhibitor : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        private int ExhibitorID
        {
            get
            {
                if (Session["ExhibitorID"] != null)
                    return Convert.ToInt32(Session["ExhibitorID"]);
                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // --- THIS IS THE NEW SECURITY CHECK ---
            if (Session["ExhibitorID"] == null)
            {
                // If no session, they must log in.
                Response.Redirect("ExhibitorLogin.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            // --- END NEW CHECK ---

            // The rest of your original logic is perfect.
            // The ExhibitorID property will be set because the session exists.

            if (!IsPostBack)
            {
                // Check if profile already exists
                if (ProfileExists(ExhibitorID))
                {
                    ShowMessage("You can update your profile below.", "success");
                    LoadExistingProfile(ExhibitorID);
                    btnSubmit.Text = "Update Profile";

                    // Make file uploads OPTIONAL for updates
                    rfvProductPicture.Enabled = false;
                    rfvBrochure.Enabled = false;
                    rfvLogo.Enabled = false;
                }
                else
                {
                    // Pre-fill customer support from exhibitor data
                    PreFillCustomerSupport(ExhibitorID);
                    btnSubmit.Text = "Submit Profile";
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                // Validate at least one checkbox selected in each required group
                if (!ValidateCheckboxGroups())
                {
                    ShowMessage("Please select at least one option from each required section.", "danger");
                    return;
                }

                // Check if this is UPDATE or INSERT
                bool isUpdate = ProfileExists(ExhibitorID);

                // File upload handling
                string productPicturePath = "";
                string brochurePath = "";
                string logoPath = "";

                if (fuProductPicture.HasFile || fuBrochure.HasFile || fuLogo.HasFile)
                {
                    string uploadFolder = Server.MapPath($"~/Uploads/Exhibitor_{ExhibitorID}/");

                    // --- FIX: Create Directory FIRST, before saving any files ---
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    // Now it is safe to save the Logo
                    if (fuLogo.HasFile)
                    {
                        string logoFileName = "Logo_" + DateTime.Now.Ticks + Path.GetExtension(fuLogo.FileName);
                        string logoFullPath = Path.Combine(uploadFolder, logoFileName);
                        fuLogo.SaveAs(logoFullPath);
                        logoPath = $"~/Uploads/Exhibitor_{ExhibitorID}/{logoFileName}";
                    }

                    // Save Product Picture
                    if (fuProductPicture.HasFile)
                    {
                        string productFileName = "ProductPicture_" + DateTime.Now.Ticks + Path.GetExtension(fuProductPicture.FileName);
                        string productFullPath = Path.Combine(uploadFolder, productFileName);
                        fuProductPicture.SaveAs(productFullPath);
                        productPicturePath = $"~/Uploads/Exhibitor_{ExhibitorID}/{productFileName}";
                    }

                    // Save Brochure
                    if (fuBrochure.HasFile)
                    {
                        string brochureFileName = "Brochure_" + DateTime.Now.Ticks + Path.GetExtension(fuBrochure.FileName);
                        string brochureFullPath = Path.Combine(uploadFolder, brochureFileName);
                        fuBrochure.SaveAs(brochureFullPath);
                        brochurePath = $"~/Uploads/Exhibitor_{ExhibitorID}/{brochureFileName}";
                    }
                }

                // Collect all data
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

                // Collect checkbox groups
                string natureOfBusiness = GetNatureOfBusiness();
                string companyCategory = GetCompanyCategory();
                string marketsCatered = GetMarketsCatered();
                string geographicReach = GetGeographicReach();
                string participationObjectives = GetParticipationObjectives();

                // Additional requirements
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

                if (isUpdate)
                {
                    // UPDATE existing profile
                    int profileId = GetExistingProfileID(ExhibitorID);
                    UpdatePostApprovalProfile(
                        profileId, boothNo, hallNo, exhibitorProfile, yearOfEstablishment,
                        website, linkedIn, twitter, facebook, youtube,
                        supportName, supportContact, supportEmail,
                        natureOfBusiness, companyCategory, marketsCatered, geographicReach,
                        powerSupplyRequired, powerSupplyKwh, internetRequired, furnitureRequired,
                        avEquipmentRequired, interpreterRequired, otherRequirements,
                        participationObjectives, additionalNotes,
                        productPicturePath, brochurePath, logoPath
                    );
                    ShowMessage("Your profile has been updated successfully!", "success");
                }
                else
                {
                    // INSERT new profile
                    int profileId = AddPostApprovalProfile(
                        ExhibitorID, boothNo, hallNo, exhibitorProfile, yearOfEstablishment,
                        website, linkedIn, twitter, facebook, youtube,
                        supportName, supportContact, supportEmail,
                        natureOfBusiness, companyCategory, marketsCatered, geographicReach,
                        powerSupplyRequired, powerSupplyKwh, internetRequired, furnitureRequired,
                        avEquipmentRequired, interpreterRequired, otherRequirements,
                        participationObjectives, additionalNotes,
                        productPicturePath, brochurePath, logoPath
                    );

                    if (profileId > 0)
                    {
                        ShowMessage("Your profile has been submitted successfully! You can edit it anytime.", "success");
                        btnSubmit.Text = "Update Profile";

                        // Make file uploads OPTIONAL after first submission
                        rfvProductPicture.Enabled = false;
                        rfvBrochure.Enabled = false;
                        rfvLogo.Enabled = false;
                    }
                    else
                    {
                        ShowMessage("Profile submission failed. Please try again.", "danger");
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Message.Contains("Profile already exists"))
                {
                    ShowMessage("You have already submitted a profile. Please refresh the page to edit it.", "danger");
                }
                else if (sqlEx.Message.Contains("must be approved"))
                {
                    ShowMessage("Your registration must be approved before creating a profile.", "danger");
                }
                else
                {
                    ShowMessage("Database Error: " + sqlEx.Message, "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        private bool IsExhibitorApproved(int exhibitorId)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = "SELECT ApprovalStatus FROM TBL.Exhibitor WHERE ExhibitorID = @ExhibitorID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    return result != null && result.ToString() == "Approved";
                }
            }
        }

        private bool ProfileExists(int exhibitorId)
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

        private int GetExistingProfileID(int exhibitorId)
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

        private void PreFillCustomerSupport(int exhibitorId)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = "SELECT Name, Mobile, Email FROM TBL.Exhibitor WHERE ExhibitorID = @ExhibitorID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            txtSupportName.Text = dr["Name"].ToString();
                            txtSupportContact.Text = dr["Mobile"].ToString();
                            txtSupportEmail.Text = dr["Email"].ToString();
                        }
                    }
                }
            }
        }

        private void LoadExistingProfile(int exhibitorId)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetPostApprovalProfileByExhibitorID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            // Booth Information
                            txtBoothNo.Text = dr["BoothNo"].ToString();
                            txtHallNo.Text = dr["HallNo"].ToString();
                            txtExhibitorProfile.Text = dr["ExhibitorProfile"].ToString();

                            // Exhibitor Profile
                            txtYearOfEstablishment.Text = dr["YearOfEstablishment"].ToString();
                            txtWebsite.Text = dr["Website"].ToString();

                            // Social Media
                            txtLinkedIn.Text = dr["LinkedIn"].ToString();
                            txtTwitter.Text = dr["Twitter"].ToString();
                            txtFacebook.Text = dr["Facebook"].ToString();
                            txtYouTube.Text = dr["YouTube"].ToString();

                            // Customer Support
                            txtSupportName.Text = dr["CustomerSupportName"].ToString();
                            txtSupportContact.Text = dr["CustomerSupportContact"].ToString();
                            txtSupportEmail.Text = dr["CustomerSupportEmail"].ToString();

                            // Additional Notes
                            txtAdditionalNotes.Text = dr["AdditionalNotes"].ToString();

                            // Load checkboxes
                            LoadCheckboxes(dr);
                        }
                    }
                }
            }
        }

        private void LoadCheckboxes(SqlDataReader dr)
        {
            // Nature of Business
            string nature = dr["NatureOfBusiness"].ToString();
            chkManufacturer.Checked = nature.Contains("Manufacturer");
            chkDistributor.Checked = nature.Contains("Distributor");
            chkImporter.Checked = nature.Contains("Importer");
            chkServiceProvider.Checked = nature.Contains("Service Provider");
            chkTechnologyProvider.Checked = nature.Contains("Technology Provider");
            chkRnDServices.Checked = nature.Contains("R&D");
            chkConsultancy.Checked = nature.Contains("Consultancy");
            chkIndustryAssociation.Checked = nature.Contains("Industry Association");
            if (nature.Contains("Other:"))
            {
                chkNatureOther.Checked = true;
                int startIndex = nature.IndexOf("Other:") + 6;
                int endIndex = nature.IndexOf(",", startIndex);
                txtNatureOther.Text = endIndex > startIndex ? nature.Substring(startIndex, endIndex - startIndex).Trim() : nature.Substring(startIndex).Trim();
            }

            // Company Category
            string category = dr["CompanyCategory"].ToString();
            chkAutomotiveLubricants.Checked = category.Contains("Automotive Lubricants");
            chkIndustrialLubricants.Checked = category.Contains("Industrial Lubricants");
            chkBaseOils.Checked = category.Contains("Base Oils");
            chkAdditives.Checked = category.Contains("Additives");
            chkGreases.Checked = category.Contains("Greases");
            chkSpecialtyFluids.Checked = category.Contains("Specialty Fluids");
            chkBioBasedLubricants.Checked = category.Contains("Bio-based");
            chkReRefinedOils.Checked = category.Contains("Re-refined");
            chkPackaging.Checked = category.Contains("Packaging");
            chkLabEquipment.Checked = category.Contains("Lab");
            chkLubricationSystems.Checked = category.Contains("Lubrication Systems");
            chkSoftwareAI.Checked = category.Contains("Software");
            if (category.Contains("Others:"))
            {
                chkProductOther.Checked = true;
                int startIndex = category.IndexOf("Others:") + 7;
                int endIndex = category.IndexOf(",", startIndex);
                txtProductOther.Text = endIndex > startIndex ? category.Substring(startIndex, endIndex - startIndex).Trim() : category.Substring(startIndex).Trim();
            }

            // Markets
            string markets = dr["MarketsCateredTo"].ToString();
            chkAutomotive.Checked = markets.Contains("Automotive");
            chkHeavyCommercial.Checked = markets.Contains("Heavy Commercial");
            chkRailways.Checked = markets.Contains("Railways");
            chkMarine.Checked = markets.Contains("Marine");
            chkAerospace.Checked = markets.Contains("Aerospace");
            chkManufacturing.Checked = markets.Contains("Manufacturing");
            chkPowerEnergy.Checked = markets.Contains("Power");
            chkConstruction.Checked = markets.Contains("Construction");
            chkAgriculture.Checked = markets.Contains("Agriculture");
            chkFMCG.Checked = markets.Contains("FMCG");
            if (markets.Contains("Other:"))
            {
                chkMarketOther.Checked = true;
                int startIndex = markets.IndexOf("Other:") + 6;
                int endIndex = markets.IndexOf(",", startIndex);
                txtMarketOther.Text = endIndex > startIndex ? markets.Substring(startIndex, endIndex - startIndex).Trim() : markets.Substring(startIndex).Trim();
            }

            // Geographic Reach
            string geo = dr["GeographicReach"].ToString();
            chkIndiaOnly.Checked = geo.Contains("India Only");
            chkSouthAsia.Checked = geo.Contains("South Asia");
            chkAsiaPacific.Checked = geo.Contains("Asia-Pacific");
            chkMiddleEast.Checked = geo.Contains("Middle East");
            chkAfrica.Checked = geo.Contains("Africa");
            chkEurope.Checked = geo.Contains("Europe");
            chkGlobal.Checked = geo.Contains("Global");

            // Additional Requirements
            chkPowerSupply.Checked = Convert.ToBoolean(dr["PowerSupplyRequired"]);
            if (dr["PowerSupplyKwh"] != DBNull.Value)
                txtPowerSupplyKwh.Text = dr["PowerSupplyKwh"].ToString();
            chkInternet.Checked = Convert.ToBoolean(dr["InternetRequired"]);
            chkFurniture.Checked = Convert.ToBoolean(dr["FurnitureRentalRequired"]);
            chkAVEquipment.Checked = Convert.ToBoolean(dr["AVEquipmentRequired"]);
            chkInterpreter.Checked = Convert.ToBoolean(dr["InterpreterSupportRequired"]);
            if (dr["OtherRequirements"] != DBNull.Value && !string.IsNullOrEmpty(dr["OtherRequirements"].ToString()))
            {
                chkReqOther.Checked = true;
                txtReqOther.Text = dr["OtherRequirements"].ToString();
            }

            // Participation Objectives
            string objectives = dr["ParticipationObjectives"].ToString();
            chkGenerateLeads.Checked = objectives.Contains("Generate Business Leads");
            chkLaunchProducts.Checked = objectives.Contains("Launch New Products");
            chkNetworking.Checked = objectives.Contains("Network");
            chkFindPartners.Checked = objectives.Contains("Find Distribution");
            chkMarketResearch.Checked = objectives.Contains("Market Research");
            chkBrandVisibility.Checked = objectives.Contains("Brand Visibility");
            chkAttendConference.Checked = objectives.Contains("Attend Conference");
            chkRecruitTalent.Checked = objectives.Contains("Recruit Talent");
            if (objectives.Contains("Other:"))
            {
                chkObjectiveOther.Checked = true;
                int startIndex = objectives.IndexOf("Other:") + 6;
                int endIndex = objectives.IndexOf(",", startIndex);
                txtObjectiveOther.Text = endIndex > startIndex ? objectives.Substring(startIndex, endIndex - startIndex).Trim() : objectives.Substring(startIndex).Trim();
            }
        }

        private bool ValidateCheckboxGroups()
        {
            // Validate Nature of Business
            if (!chkManufacturer.Checked && !chkDistributor.Checked && !chkImporter.Checked &&
                !chkServiceProvider.Checked && !chkTechnologyProvider.Checked && !chkRnDServices.Checked &&
                !chkConsultancy.Checked && !chkIndustryAssociation.Checked && !chkNatureOther.Checked)
            {
                return false;
            }

            // Validate Company Category
            if (!chkAutomotiveLubricants.Checked && !chkIndustrialLubricants.Checked && !chkBaseOils.Checked &&
                !chkAdditives.Checked && !chkGreases.Checked && !chkSpecialtyFluids.Checked &&
                !chkBioBasedLubricants.Checked && !chkReRefinedOils.Checked && !chkPackaging.Checked &&
                !chkLabEquipment.Checked && !chkLubricationSystems.Checked && !chkSoftwareAI.Checked &&
                !chkProductOther.Checked)
            {
                return false;
            }

            // Validate Markets
            if (!chkAutomotive.Checked && !chkHeavyCommercial.Checked && !chkRailways.Checked &&
                !chkMarine.Checked && !chkAerospace.Checked && !chkManufacturing.Checked &&
                !chkPowerEnergy.Checked && !chkConstruction.Checked && !chkAgriculture.Checked &&
                !chkFMCG.Checked && !chkMarketOther.Checked)
            {
                return false;
            }

            // Validate Geographic Reach
            if (!chkIndiaOnly.Checked && !chkSouthAsia.Checked && !chkAsiaPacific.Checked &&
                !chkMiddleEast.Checked && !chkAfrica.Checked && !chkEurope.Checked && !chkGlobal.Checked)
            {
                return false;
            }

            // Validate Participation Objectives
            if (!chkGenerateLeads.Checked && !chkLaunchProducts.Checked && !chkNetworking.Checked &&
                !chkFindPartners.Checked && !chkMarketResearch.Checked && !chkBrandVisibility.Checked &&
                !chkAttendConference.Checked && !chkRecruitTalent.Checked && !chkObjectiveOther.Checked)
            {
                return false;
            }

            return true;
        }

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

        private int AddPostApprovalProfile(
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

                    return Convert.ToInt32(outParam.Value);
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
