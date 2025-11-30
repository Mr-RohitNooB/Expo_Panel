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
            public string AgendaSynopsis { get; set; }
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
                            string synopsis = "";
                            if (rdr["Synopsis"] != DBNull.Value) // Assumes column name is 'Synopsis' based on your SQL
                                synopsis = rdr["Synopsis"].ToString();
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
                                AgendaBrief = brief,
                                AgendaSynopsis = synopsis
                            });
                        }
                    }
                }
            }
            return list;
        }

        // 1. DTO Class (You can put this inside the Conference class or outside)
        public class SessionSpeakerDTO
        {
            public int SpeakerID { get; set; } // <--- ADD THIS LINE
            public string Name { get; set; }
            public string Designation { get; set; }
            public string Company { get; set; }
            public string PhotoPath { get; set; }
        }

        // 2. WebMethod (Put this inside the Conference class)
        [WebMethod]
        public static List<SessionSpeakerDTO> GetSpeakersForSession(int agendaId)
        {
            List<SessionSpeakerDTO> list = new List<SessionSpeakerDTO>();
            string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("[dbo].[sp_GetSpeakersByAgendaID]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@AgendaID", agendaId);
                    con.Open();

                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            string rawPath = rdr["PhotoPath"] != DBNull.Value ? rdr["PhotoPath"].ToString() : "";

                            list.Add(new SessionSpeakerDTO
                            {
                                SpeakerID = Convert.ToInt32(rdr["SpeakerID"]),
                                Name = rdr["Name"].ToString(),
                                Designation = rdr["Designation"].ToString(),
                                Company = rdr["Company"].ToString(),
                                // Clean up path if it starts with ~
                                PhotoPath = rawPath.Replace("~", "")
                            });
                        }
                    }
                }
            }
            return list;
        }


        public class SpeakerDetailsDTO
        {
            public string Name { get; set; }
            public string Designation { get; set; }
            public string Company { get; set; }
            public string PhotoPath { get; set; }
            public string LogoPath { get; set; }
            public string LinkedInProfile { get; set; }
            public string ProfessionalBio { get; set; }
            // Note: We are ignoring SessionTitle here as requested
        }

        [WebMethod]
        public static SpeakerDetailsDTO GetSpeakerDetails(int speakerId)
        {
            SpeakerDetailsDTO details = new SpeakerDetailsDTO();
            string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // Re-using the same SP from Index page
                using (SqlCommand cmd = new SqlCommand("[eventExpo].[sp_GetPublicSpeakerDetails]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                    con.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            details.Name = rdr["Name"].ToString();
                            details.Designation = rdr["Designation"].ToString();
                            details.Company = rdr["Company"].ToString();

                            string rawPhoto = rdr["PhotoPath"] != DBNull.Value ? rdr["PhotoPath"].ToString() : "";
                            string rawLogo = rdr["LogoPath"] != DBNull.Value ? rdr["LogoPath"].ToString() : "";

                            details.PhotoPath = rawPhoto.Replace("~", "");
                            details.LogoPath = rawLogo.Replace("~", "");
                            details.LinkedInProfile = rdr["LinkedInProfile"] != DBNull.Value ? rdr["LinkedInProfile"].ToString() : "";
                            details.ProfessionalBio = rdr["ProfessionalBio"] != DBNull.Value ? rdr["ProfessionalBio"].ToString() : "";
                        }
                    }
                }
            }
            return details;
        }
    }
}