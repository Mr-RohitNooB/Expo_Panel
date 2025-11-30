using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;

namespace Expo_Panel
{
    public class ExhibitorCardDTO
    {
        public int ExhibitorID { get; set; }
        public string Company { get; set; }
        public string LogoPath { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public string HallNo { get; set; }
        public string BoothNo { get; set; }
    }

    public partial class Exhibitors : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static List<ExhibitorCardDTO> GetExhibitorsList()
        {
            List<ExhibitorCardDTO> list = new List<ExhibitorCardDTO>();
            string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // Updated Stored Procedure Name
                using (SqlCommand cmd = new SqlCommand("sp_GetPublicExhibitorsList", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            list.Add(new ExhibitorCardDTO
                            {
                                ExhibitorID = Convert.ToInt32(rdr["ExhibitorID"]),
                                Company = rdr["Company"].ToString(),
                                LogoPath = rdr["LogoPath"] != DBNull.Value ? rdr["LogoPath"].ToString() : "",
                                City = rdr["City"] != DBNull.Value ? rdr["City"].ToString() : "",
                                Country = rdr["Country"] != DBNull.Value ? rdr["Country"].ToString() : "",
                                HallNo = rdr["HallNo"] != DBNull.Value ? rdr["HallNo"].ToString() : "",
                                BoothNo = rdr["BoothNo"] != DBNull.Value ? rdr["BoothNo"].ToString() : ""
                            });
                        }
                    }
                }
            }
            return list;
        }
    }
}