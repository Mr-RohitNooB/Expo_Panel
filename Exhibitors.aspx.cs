using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace Expo_Panel
{
    // We reuse the same DTO structure
    public class ExhibitorPageDTO
    {
        public string Company { get; set; }
        public string FullName { get; set; }
        public string Designation { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Country { get; set; }

        // --- NEW FIELDS FOR MODAL ---
        public string LinkedIn { get; set; }
        public string Website { get; set; }
        public string Twitter { get; set; }
        public string Facebook { get; set; }
        public string ProductPicturePath { get; set; }
        public string BrochurePath { get; set; }
    }

    public partial class Exhibitors : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Update the browser tab title
                Page.Title = "Exhibitor List | Lubricant India Expo 2026";
            }
        }

        [WebMethod]
        public static List<ExhibitorPageDTO> GetAllExhibitors()
        {
            List<ExhibitorPageDTO> list = new List<ExhibitorPageDTO>();
            string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetPublicExhibitors", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            list.Add(new ExhibitorPageDTO
                            {
                                Company = rdr["Company"].ToString(),
                                FullName = rdr["FullName"] != DBNull.Value ? rdr["FullName"].ToString() : "",
                                Designation = rdr["Designation"] != DBNull.Value ? rdr["Designation"].ToString() : "",
                                City = rdr["City"] != DBNull.Value ? rdr["City"].ToString() : "",
                                State = rdr["State"] != DBNull.Value ? rdr["State"].ToString() : "",
                                Country = rdr["Country"] != DBNull.Value ? rdr["Country"].ToString() : "",

                                // --- MAP NEW FIELDS ---
                                LinkedIn = rdr["LinkedIn"] != DBNull.Value ? rdr["LinkedIn"].ToString() : "",
                                Website = rdr["Website"] != DBNull.Value ? rdr["Website"].ToString() : "",
                                Twitter = rdr["Twitter"] != DBNull.Value ? rdr["Twitter"].ToString() : "",
                                Facebook = rdr["Facebook"] != DBNull.Value ? rdr["Facebook"].ToString() : "",
                                // Remove Tilde (~) from paths so they work in <img> tags
                                ProductPicturePath = (rdr["ProductPicturePath"] != DBNull.Value ? rdr["ProductPicturePath"].ToString() : "").Replace("~", ""),
                                BrochurePath = (rdr["BrochurePath"] != DBNull.Value ? rdr["BrochurePath"].ToString() : "").Replace("~", "")
                            });
                        }
                    }
                }
            }
            return list;
        }
    }
}