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
    public class SpeakerDTO
    {
        public int SpeakerID { get; set; }
        public string Name { get; set; }
        public string Designation { get; set; }
        public string Company { get; set; }
        public string PhotoPath { get; set; }
    }
    public class SpeakerDetailsDTO
    {
        public string Name { get; set; }
        public string Designation { get; set; }
        public string Company { get; set; }
        public int YearsOfExperience { get; set; }
        public string PhotoPath { get; set; }
        public string LogoPath { get; set; }
        public string ProfessionalBio { get; set; }
        public string AreasOfExpertise { get; set; }
        public string CurrentWorkProjects { get; set; }
    }
    public class ExhibitorDTO
    {
        public int ExhibitorID { get; set; }
        public string Company { get; set; }
        public string FullName { get; set; }
        public string Designation { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Country { get; set; }

        // Add new fields
        public string LinkedIn { get; set; }
        public string Website { get; set; }
        public string Twitter { get; set; }
        public string Facebook { get; set; }
        public string ProductPicturePath { get; set; }
        public string BrochurePath { get; set; }
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


        protected void btnSubmitContact_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

                    using (SqlConnection con = new SqlConnection(connStr))
                    {
                        using (SqlCommand cmd = new SqlCommand("spAddContactInquiry", con))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;

                            cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                            cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                            cmd.Parameters.AddWithValue("@Mobile", txtMobile.Text.Trim());
                            cmd.Parameters.AddWithValue("@Message", txtMessage.Text.Trim());

                            con.Open();
                            cmd.ExecuteNonQuery();

                            // Clear form
                            txtName.Text = "";
                            txtEmail.Text = "";
                            txtMobile.Text = "";
                            txtMessage.Text = "";

                            lblMessage.Text = "Thank you! Your message has been sent successfully.";
                            lblMessage.ForeColor = System.Drawing.Color.Green;
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "An error occurred. Please try again later.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
        }


        [WebMethod]
        public static List<SpeakerDTO> GetSpeakersList()
        {
            List<SpeakerDTO> list = new List<SpeakerDTO>();
            // Ensure this connection string name matches your Web.config
            string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("[eventExpo].[sp_GetApprovedSpeakers]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            // FIX: We use .Replace("~", "") so the browser gets a clean path like "/Uploads/..."
                            string rawPath = rdr["PhotoPath"] != DBNull.Value ? rdr["PhotoPath"].ToString() : "";

                            list.Add(new SpeakerDTO
                            {
                                SpeakerID = Convert.ToInt32(rdr["SpeakerID"]),
                                Name = rdr["Name"].ToString(),
                                Designation = rdr["Designation"].ToString(),
                                Company = rdr["Company"].ToString(),
                                // REMOVING TILDE HERE
                                PhotoPath = rawPath.Replace("~", "")
                            });
                        }
                    }
                }
            }
            return list;
        }

        [WebMethod]
        public static SpeakerDetailsDTO GetSpeakerDetails(int speakerId)
        {
            SpeakerDetailsDTO details = new SpeakerDetailsDTO();
            string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
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
                            details.YearsOfExperience = rdr["YearsOfExperience"] != DBNull.Value ? Convert.ToInt32(rdr["YearsOfExperience"]) : 0;

                            // FIX: Remove Tilde (~) from both Photo and Logo paths
                            string rawPhoto = rdr["PhotoPath"] != DBNull.Value ? rdr["PhotoPath"].ToString() : "";
                            string rawLogo = rdr["LogoPath"] != DBNull.Value ? rdr["LogoPath"].ToString() : "";

                            details.PhotoPath = rawPhoto.Replace("~", "");
                            details.LogoPath = rawLogo.Replace("~", "");

                            details.ProfessionalBio = rdr["ProfessionalBio"] != DBNull.Value ? rdr["ProfessionalBio"].ToString() : "No bio available.";
                            details.AreasOfExpertise = rdr["AreasOfExpertise"] != DBNull.Value ? rdr["AreasOfExpertise"].ToString() : "";
                            details.CurrentWorkProjects = rdr["CurrentWorkProjects"] != DBNull.Value ? rdr["CurrentWorkProjects"].ToString() : "";
                        }
                    }
                }
            }
            return details;
        }

        [WebMethod]
        public static List<ExhibitorDTO> GetExhibitorsList()
        {
            List<ExhibitorDTO> list = new List<ExhibitorDTO>();
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
                            list.Add(new ExhibitorDTO
                            {
                                ExhibitorID = Convert.ToInt32(rdr["ExhibitorID"]),
                                Company = rdr["Company"].ToString(),
                                FullName = rdr["FullName"] != DBNull.Value ? rdr["FullName"].ToString() : "",
                                Designation = rdr["Designation"] != DBNull.Value ? rdr["Designation"].ToString() : "",
                                City = rdr["City"] != DBNull.Value ? rdr["City"].ToString() : "",
                                State = rdr["State"] != DBNull.Value ? rdr["State"].ToString() : "",
                                Country = rdr["Country"] != DBNull.Value ? rdr["Country"].ToString() : "",

                                // Map new fields
                                LinkedIn = rdr["LinkedIn"] != DBNull.Value ? rdr["LinkedIn"].ToString() : "",
                                Website = rdr["Website"] != DBNull.Value ? rdr["Website"].ToString() : "",
                                Twitter = rdr["Twitter"] != DBNull.Value ? rdr["Twitter"].ToString() : "",
                                Facebook = rdr["Facebook"] != DBNull.Value ? rdr["Facebook"].ToString() : "",
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
