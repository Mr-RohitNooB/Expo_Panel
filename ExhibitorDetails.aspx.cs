using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Expo_Panel
{
    public partial class ExhibitorDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    LoadDetails(id);
                }
            }
        }

        private void LoadDetails(string id)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetExhibitorDetailsByID", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ExhibitorID", id);
                    con.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            // Basic Info
                            lblCompanyName.Text = rdr["Company"].ToString();
                            lblLocation.Text = $"{rdr["City"]}, {rdr["Country"]}";
                            lblBooth.Text = rdr["BoothNo"].ToString();
                            lblFullAddress.Text = rdr["HeadOfficeAddress"].ToString();

                            // Images
                            string logo = rdr["LogoPath"].ToString();
                            if (!string.IsNullOrEmpty(logo)) imgLogo.ImageUrl = logo.Replace("~", "");

                            string productImg = rdr["ProductPicturePath"].ToString();
                            if (!string.IsNullOrEmpty(productImg))
                            {
                                imgProduct1.ImageUrl = productImg.Replace("~", "");
                                imgProduct1.Visible = true;
                            }

                            // Attributes
                            lblYearEst.Text = rdr["YearOfEstablishment"].ToString();
                            lblNature.Text = rdr["NatureOfBusiness"].ToString();
                            lblCategories.Text = rdr["CompanyCategory"].ToString(); // Consider replacing commas with line breaks if needed
                            lblMarkets.Text = rdr["MarketsCateredTo"].ToString();
                            lblProfile.Text = rdr["ExhibitorProfile"].ToString();

                            // Socials
                            string websiteUrl = rdr["Website"].ToString();
                            SetLink(lnkWebsite, websiteUrl);
                            if (!string.IsNullOrEmpty(websiteUrl))
                            {
                                // This sets the visible text to the URL itself (e.g., www.google.com)
                                lnkWebsite.Text = websiteUrl;
                            }
                            SetLink(lnkFb, rdr["Facebook"].ToString());
                            SetLink(lnkTwitter, rdr["Twitter"].ToString());
                            SetLink(lnkIn, rdr["LinkedIn"].ToString());
                            SetLink(lnkYt, rdr["YouTube"].ToString());

                            // Brochure
                            string broPath = rdr["BrochurePath"].ToString();
                            if (!string.IsNullOrEmpty(broPath))
                            {
                                btnBrochure.NavigateUrl = broPath.Replace("~", "");
                                btnBrochure.Attributes["download"] = "";
                                btnBrochure.Visible = true;
                            }
                        }
                    }
                }
            }
        }

        private void SetLink(System.Web.UI.WebControls.HyperLink link, string url)
        {
            if (!string.IsNullOrEmpty(url))
            {
                link.NavigateUrl = url.StartsWith("http") ? url : "https://" + url;
                link.Visible = true;
            }
            else
            {
                link.Visible = false;
            }
        }
    }
}