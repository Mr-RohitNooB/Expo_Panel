using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace Expo_Panel
{
    public partial class Conference : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Page load logic if needed
        }

        // DTO Class for transferring data to JavaScript
        public class ConferenceAgendaItem
        {
            public int AgendaID { get; set; }
            public string Day { get; set; }
            public string Track { get; set; }
            public string Time { get; set; }
            public string AgendaTitle { get; set; }
            public string AgendaBrief { get; set; }
        }

        [WebMethod]
        public static List<ConferenceAgendaItem> GetConferenceAgenda()
        {
            List<ConferenceAgendaItem> list = new List<ConferenceAgendaItem>();
            string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // We use your EXISTING Stored Procedure for Agendas
                using (SqlCommand cmd = new SqlCommand("[dbo].[sp_GetPublicAgendaDetails]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            // Logic to handle potential DBNulls safely
                            string brief = "";
                            if (rdr["AgendaBrief"] != DBNull.Value)
                                brief = rdr["AgendaBrief"].ToString();

                            list.Add(new ConferenceAgendaItem
                            {
                                AgendaID = Convert.ToInt32(rdr["AgendaID"]),
                                Day = rdr["Day"].ToString(),
                                Track = rdr["Track"].ToString(),
                                Time = rdr["Time"].ToString(),
                                AgendaTitle = rdr["AgendaTitle"].ToString(),
                                AgendaBrief = brief
                            });
                        }
                    }
                }
            }
            return list;
        }
    }
}