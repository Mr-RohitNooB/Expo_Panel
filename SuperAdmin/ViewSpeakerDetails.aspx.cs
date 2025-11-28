using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace Expo_Panel.Admin
{
    public partial class ViewSpeakerDetails : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["SpeakerID"] != null)
                {
                    int speakerId;
                    if (int.TryParse(Request.QueryString["SpeakerID"], out speakerId))
                    {
                        LoadSpeakerDetails(speakerId);
                    }
                    else
                    {
                        Response.Write("Invalid Speaker ID.");
                    }
                }
                else
                {
                    Response.Write("No Speaker ID provided.");
                }
            }
        }

        private void LoadSpeakerDetails(int speakerId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetSpeakerById_V2", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            // 1. Basic Info
                            lblName.Text = GetSafeString(reader, "Name");
                            lblDesignationCompany.Text = $"{GetSafeString(reader, "Designation")} at {GetSafeString(reader, "Company")}";
                            lblEmail.Text = GetSafeString(reader, "Email");
                            lblMobile.Text = GetSafeString(reader, "Mobile");

                            string photoPath = GetSafeString(reader, "PhotoPath");
                            if (!string.IsNullOrEmpty(photoPath)) imgProfile.ImageUrl = photoPath;

                            // 2. Status
                            bool isActive = false;
                            if (ColumnExists(reader, "IS_ACTIVE") && reader["IS_ACTIVE"] != DBNull.Value)
                            {
                                isActive = Convert.ToBoolean(reader["IS_ACTIVE"]);
                            }
                            lblStatus.Text = isActive ? "Active" : "Inactive";
                            lblStatus.CssClass = isActive ? "badge badge-active" : "badge badge-inactive";

                            // 3. Logo
                            string logoPath = GetSafeString(reader, "LogoPath");
                            pnlLogo.Visible = !string.IsNullOrEmpty(logoPath);
                            if (pnlLogo.Visible) imgLogo.ImageUrl = logoPath;

                            // 4. LinkedIn (With Protocol Fix)
                            string linkedIn = GetSafeString(reader, "LinkedInProfile");
                            if (!string.IsNullOrEmpty(linkedIn))
                            {
                                pnlLinkedIn.Visible = true;
                                // Fix URL if missing http/https
                                if (!linkedIn.StartsWith("http", StringComparison.OrdinalIgnoreCase))
                                {
                                    linkedIn = "https://" + linkedIn;
                                }
                                hlLinkedIn.NavigateUrl = linkedIn;
                            }
                            else
                            {
                                pnlLinkedIn.Visible = false;
                            }

                            // 5. Details
                            lblExperience.Text = GetSafeString(reader, "YearsOfExperience");

                            string bio = GetSafeString(reader, "ProfessionalBio");
                            lblBio.Text = string.IsNullOrEmpty(bio) ? "No bio provided." : bio;

                            lblExpertise.Text = GetSafeString(reader, "AreasOfExpertise");
                            lblProjects.Text = GetSafeString(reader, "CurrentWorkProjects");

                            string topics = GetSafeString(reader, "SuggestedTopics");
                            lblTopics.Text = string.IsNullOrEmpty(topics) ? "None provided" : topics;

                            lblPreviousEngagements.Text = GetSafeString(reader, "PreviousSpeakingEngagements");

                            // 6. Discussion Format - Visual Checkboxes
                            string format = GetSafeString(reader, "PreferredDiscussionFormat");
                            GenerateFormatCheckboxes(format);

                            // 7. Agendas
                            string agendaIds = GetSafeString(reader, "SelectedAgendas");

                            reader.Close();

                            if (!string.IsNullOrEmpty(agendaIds))
                            {
                                LoadAgendaNames(agendaIds, con);
                            }
                            else
                            {
                                lblSelectedAgendas.Text = "No specific topics selected.";
                                lblSelectedAgendas.Style.Add("color", "#94a3b8");
                                lblSelectedAgendas.Style.Add("font-style", "italic");
                            }
                        }
                        else
                        {
                            Response.Write("Speaker not found.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<div style='color:red; padding:20px;'>Error: " + ex.Message + "</div>");
            }
        }

        private void GenerateFormatCheckboxes(string selectedFormats)
        {
            if (string.IsNullOrEmpty(selectedFormats)) selectedFormats = "";

            bool isPanel = selectedFormats.Contains("Panel Discussion");
            bool isTechnical = selectedFormats.Contains("Technical Presentation");

            StringBuilder sb = new StringBuilder();
            sb.Append("<div class='checkbox-container'>");

            sb.Append("<div class='checkbox-item'>");
            sb.Append(isPanel ? "<i class='far fa-check-square fa-check-square'></i>" : "<i class='far fa-square fa-square'></i>");
            sb.Append(" Panel Discussion</div>");

            sb.Append("<div class='checkbox-item'>");
            sb.Append(isTechnical ? "<i class='far fa-check-square fa-check-square'></i>" : "<i class='far fa-square fa-square'></i>");
            sb.Append(" Technical Presentation</div>");

            sb.Append("</div>");

            litFormatCheckboxes.Text = sb.ToString();
        }

        private void LoadAgendaNames(string agendaIds, SqlConnection con)
        {
            try
            {
                string query = $"SELECT Title FROM TBL.Agenda WHERE AgendaID IN ({agendaIds})";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append("<ul style='padding-left: 15px; margin: 0;'>");
                        if (reader.HasRows)
                        {
                            while (reader.Read())
                            {
                                sb.Append($"<li style='margin-bottom:5px;'>{reader["Title"]}</li>");
                            }
                        }
                        else
                        {
                            sb.Append("<li>Selected topics not found.</li>");
                        }
                        sb.Append("</ul>");
                        lblSelectedAgendas.Text = sb.ToString();
                    }
                }
            }
            catch
            {
                lblSelectedAgendas.Text = agendaIds;
            }
        }

        private bool ColumnExists(SqlDataReader reader, string columnName)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (reader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
                {
                    return true;
                }
            }
            return false;
        }

        private string GetSafeString(SqlDataReader reader, string columnName)
        {
            if (ColumnExists(reader, columnName) && reader[columnName] != DBNull.Value)
            {
                return reader[columnName].ToString();
            }
            return "";
        }
    }
}