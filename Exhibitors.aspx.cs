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
                // We use the same Stored Procedure "sp_GetPublicExhibitors"
                // Assuming this SP returns ALL approved exhibitors
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
                                Country = rdr["Country"] != DBNull.Value ? rdr["Country"].ToString() : ""
                            });
                        }
                    }
                }
            }
            return list;
        }
    }
}