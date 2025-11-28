using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace Expo_Panel.Admin
{
    public partial class ViewExhibitorDetails : System.Web.UI.Page
    {
        private string ConnectionString => ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["IsAuthenticated"] == null || !(bool)Session["IsAuthenticated"])
            {
                Response.Redirect("Default.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["ID"] != null)
                {
                    int exhibitorId;
                    if (int.TryParse(Request.QueryString["ID"], out exhibitorId))
                    {
                        LoadExhibitorDetails(exhibitorId);
                    }
                    else
                    {
                        Response.Redirect("ManageExhibitor.aspx");
                    }
                }
                else
                {
                    Response.Redirect("ManageExhibitor.aspx");
                }
            }
        }

        private void LoadExhibitorDetails(int exhibitorId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetFullExhibitorDetails", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            // --- 1. Basic Info (Always Present) ---
                            lblName.Text = reader["Name"].ToString();
                            lblDesignation.Text = reader["Designation"].ToString();
                            lblEmail.Text = reader["Email"].ToString();
                            lblMobile.Text = reader["Mobile"].ToString();
                            lblCompany.Text = reader["Company"].ToString();

                            string status = reader["ApprovalStatus"].ToString();
                            string badgeClass = status == "Approved" ? "badge-approved" : (status == "Rejected" ? "badge-rejected" : "badge-pending");
                            lblApprovalStatus.Text = $"<span class='badge {badgeClass}'>{status}</span>";

                            lblRegType.Text = reader["RegistrationType"].ToString();
                            lblRegDate.Text = Convert.ToDateTime(reader["RegistrationDate"]).ToString("dd MMM yyyy, hh:mm tt");

                            // Address
                            lblHeadOffice.Text = reader["HeadOfficeAddress"].ToString();
                            string loc = $"{reader["City"]}, {reader["State"]}, {reader["Country"]}";
                            lblLocation.Text = loc.Trim(',').Trim();
                            lblGST.Text = reader["GSTNumber"].ToString();
                            lblBillingAddress.Text = reader["BillingAddress"].ToString();

                            // Booth
                            lblBoothType.Text = reader["BoothType"].ToString();
                            lblArea.Text = reader["AreaInSqm"].ToString();

                            // Interests
                            StringBuilder interests = new StringBuilder();
                            if (Convert.ToBoolean(reader["InterestedInConference"])) interests.Append("Conference Speaker, ");
                            if (Convert.ToBoolean(reader["InterestedInSponsorship"])) interests.Append("Sponsorship, ");
                            if (Convert.ToBoolean(reader["InterestedInAdvertising"])) interests.Append("Advertising, ");
                            if (Convert.ToBoolean(reader["InterestedInCustomPackage"])) interests.Append("Custom Package, ");
                            lblInterests.Text = interests.Length > 0 ? interests.ToString().TrimEnd(',', ' ') : "None";


                            // --- 2. Check if Profile Exists ---
                            bool hasProfile = reader["HasProfile"] != DBNull.Value && Convert.ToBoolean(reader["HasProfile"]);

                            if (hasProfile)
                            {
                                pnlProfile.Visible = true;
                                pnlNoProfile.Visible = false;

                                // Profile Details
                                lblBoothNo.Text = reader["BoothNo"].ToString();
                                lblHallNo.Text = reader["HallNo"].ToString();
                                lblYearEst.Text = reader["YearOfEstablishment"].ToString();
                                lblProfileBio.Text = reader["ExhibitorProfile"].ToString();

                                // Web & Social
                                string website = reader["Website"].ToString();
                                hlWebsite.Text = website;
                                hlWebsite.NavigateUrl = website.StartsWith("http") ? website : "http://" + website;

                                SetSocialLink(hlLinkedIn, reader["LinkedIn"]);
                                SetSocialLink(hlTwitter, reader["Twitter"]);
                                SetSocialLink(hlFacebook, reader["Facebook"]);
                                SetSocialLink(hlYouTube, reader["YouTube"]);

                                // Business
                                lblNature.Text = reader["NatureOfBusiness"].ToString().Replace(",", ", ");
                                lblCategory.Text = reader["CompanyCategory"].ToString().Replace(",", ", ");
                                lblMarkets.Text = reader["MarketsCateredTo"].ToString().Replace(",", ", ");
                                lblGeoReach.Text = reader["GeographicReach"].ToString().Replace(",", ", ");

                                // Support
                                lblSupportName.Text = reader["CustomerSupportName"].ToString();
                                lblSupportContact.Text = reader["CustomerSupportContact"].ToString();
                                lblSupportEmail.Text = reader["CustomerSupportEmail"].ToString();

                                // Logistics
                                bool pwr = Convert.ToBoolean(reader["PowerSupplyRequired"]);
                                lblPower.Text = pwr ? $"<span class='badge-bool-yes'>Yes</span> ({reader["PowerSupplyKwh"]} kWh)" : "<span class='badge-bool-no'>No</span>";

                                lblInternet.Text = FormatBool(reader["InternetRequired"]);
                                lblFurniture.Text = FormatBool(reader["FurnitureRentalRequired"]);
                                lblAV.Text = FormatBool(reader["AVEquipmentRequired"]);
                                lblInterpreter.Text = FormatBool(reader["InterpreterSupportRequired"]);
                                lblOtherReq.Text = reader["OtherRequirements"].ToString();

                                // Objectives & Notes
                                lblObjectives.Text = reader["ParticipationObjectives"].ToString().Replace(",", ", ");
                                lblNotes.Text = reader["AdditionalNotes"].ToString();

                                // Documents
                                string picPath = reader["ProductPicturePath"].ToString();
                                if (!string.IsNullOrEmpty(picPath))
                                    litProductPic.Text = $"<a href='{ResolveUrl(picPath)}' target='_blank' class='btn btn-doc'><i class='fas fa-eye'></i> View Image</a>";
                                else
                                    litProductPic.Text = "<span style='color:#ccc'>Not Uploaded</span>";

                                string docPath = reader["BrochurePath"].ToString();
                                if (!string.IsNullOrEmpty(docPath))
                                    litBrochure.Text = $"<a href='{ResolveUrl(docPath)}' target='_blank' class='btn btn-doc'><i class='fas fa-file-pdf'></i> View Brochure</a>";
                                else
                                    litBrochure.Text = "<span style='color:#ccc'>Not Uploaded</span>";
                            }
                            else
                            {
                                pnlProfile.Visible = false;
                                pnlNoProfile.Visible = true;
                            }
                        }
                        else
                        {
                            // ID not found
                            Response.Redirect("ManageExhibitor.aspx");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Simple error handling
                Response.Write("<script>alert('Error loading data: " + ex.Message + "');</script>");
            }
        }

        private void SetSocialLink(System.Web.UI.WebControls.HyperLink link, object urlObj)
        {
            string url = urlObj.ToString();
            if (!string.IsNullOrEmpty(url))
            {
                link.Visible = true;
                link.NavigateUrl = url.StartsWith("http") ? url : "https://" + url;
            }
            else
            {
                link.Visible = false;
            }
        }

        private string FormatBool(object val)
        {
            if (val != DBNull.Value && Convert.ToBoolean(val))
                return "<span class='badge-bool-yes'>Yes</span>";
            return "<span class='badge-bool-no'>No</span>";
        }
    }
}