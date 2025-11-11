using System;
using System.Collections.Generic; // For List<>
using System.Configuration;      // For ConfigurationManager
using System.Data;
using System.Data.SqlClient;     // For SqlConnection, SqlCommand, etc.
using System.Web.Services;       // For [WebMethod]
using System.Web.UI;
namespace Expo_Panel
{


    public class PublicAgendaItem
    {
        // Agenda fields
        public int AgendaID { get; set; }
        public string Day { get; set; }
        public string Track { get; set; }
        public string Time { get; set; }
        public string AgendaTitle { get; set; }
        public string AgendaBrief { get; set; }

        // Speaker fields (can be null)
        public int? SpeakerID { get; set; } // Use 'int?' for nullable ID
        public string SpeakerName { get; set; }
        public string SpeakerDesignation { get; set; }
        public string SpeakerCompany { get; set; }
        public string SpeakerPhoto { get; set; }
        public string SpeakerLogo { get; set; }
    }
    public partial class Index : System.Web.UI.Page
    {


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Page.Title = "Lubricant India Expo | 24-26 September 2026 | Yashoobhumi, New Delhi";
            }
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        [WebMethod]
        public static List<PublicAgendaItem> GetPublicAgendaDetails()
        {
            List<PublicAgendaItem> agendaList = new List<PublicAgendaItem>();
            string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; // <-- IMPORTANT: Update this name

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetPublicAgendaDetails", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            PublicAgendaItem item = new PublicAgendaItem();

                            // --- Get Agenda Data ---
                            item.AgendaID = Convert.ToInt32(reader["AgendaID"]);
                            item.Day = reader["Day"].ToString();
                            item.Track = reader["Track"].ToString();
                            item.Time = reader["Time"].ToString();
                            item.AgendaTitle = reader["AgendaTitle"].ToString();

                            // --- THE FIX IS HERE ---
                            // We check if AgendaBrief is NULL before reading it
                            if (reader["AgendaBrief"] != DBNull.Value)
                            {
                                item.AgendaBrief = reader["AgendaBrief"].ToString();
                            }
                            else
                            {
                                item.AgendaBrief = ""; // Or "No brief available"
                            }

                            // --- Get Speaker Data (Handle potential NULLs) ---
                            if (reader["SpeakerID"] != DBNull.Value)
                            {
                                item.SpeakerID = Convert.ToInt32(reader["SpeakerID"]);
                                item.SpeakerName = reader["SpeakerName"].ToString();
                                item.SpeakerDesignation = reader["SpeakerDesignation"].ToString();
                                item.SpeakerCompany = reader["SpeakerCompany"].ToString();
                                item.SpeakerPhoto = reader["SpeakerPhoto"].ToString();
                                item.SpeakerLogo = reader["SpeakerLogo"].ToString();
                            }

                            agendaList.Add(item);
                        }
                    }
                }
            }
            return agendaList; // ASP.NET automatically turns this list into JSON
        }
        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
        }
    }
}
