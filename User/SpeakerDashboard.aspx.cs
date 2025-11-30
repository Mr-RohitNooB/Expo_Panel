using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace Expo_Panel
{
    public partial class SpeakerDashboard : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if speaker is logged in
            if (Session["IsSpeakerLoggedIn"] == null || !(bool)Session["IsSpeakerLoggedIn"])
            {
                Response.Redirect("SpeakerLogin.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                int speakerId = Convert.ToInt32(Session["SpeakerID"]);
                LoadSpeakerProfile(speakerId);
                LoadSpeakerAgendas(speakerId);
                SetHeaderInfo();
            }
        }

        private void SetHeaderInfo()
        {
            string name = Session["SpeakerName"]?.ToString() ?? "Speaker";
            string email = Session["SpeakerEmail"]?.ToString() ?? "";

            // Set user initials
            string[] nameParts = name.Split(' ');
            string initials = "";
            if (nameParts.Length >= 2)
            {
                initials = nameParts[0].Substring(0, 1).ToUpper() + nameParts[1].Substring(0, 1).ToUpper();
            }
            else
            {
                initials = name.Substring(0, Math.Min(2, name.Length)).ToUpper();
            }

            litUserInitials.Text = initials;
            litUserName.Text = name;
            litUserEmail.Text = email;
            litWelcomeName.Text = name.Split(' ')[0]; // First name only
        }

        private void LoadSpeakerProfile(int speakerId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string query = @"
                        SELECT 
                            Name, Email, Mobile, Designation, Company,
                            YearsOfExperience, LinkedInProfile, ProfessionalBio
                        FROM TBL.Speaker
                        WHERE SpeakerID = @SpeakerID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            litName.Text = reader["Name"].ToString();
                            litEmail.Text = reader["Email"].ToString();
                            litMobile.Text = !string.IsNullOrEmpty(reader["Mobile"].ToString())
                                ? reader["Mobile"].ToString()
                                : "Not Provided";
                            litDesignation.Text = reader["Designation"].ToString();
                            litCompany.Text = reader["Company"].ToString();
                            litExperience.Text = reader["YearsOfExperience"] != DBNull.Value
                                ? reader["YearsOfExperience"].ToString() + " years"
                                : "Not Specified";

                            string linkedIn = reader["LinkedInProfile"].ToString();
                            if (!string.IsNullOrEmpty(linkedIn))
                            {
                                litLinkedIn.Text = $"<a href='{linkedIn}' target='_blank' style='color: #38a169; text-decoration: none;'>{linkedIn} <i class='fas fa-external-link-alt'></i></a>";
                            }
                            else
                            {
                                litLinkedIn.Text = "Not Provided";
                            }

                            litBio.Text = !string.IsNullOrEmpty(reader["ProfessionalBio"].ToString())
                                ? reader["ProfessionalBio"].ToString()
                                : "No bio provided yet.";
                        }
                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading profile: " + ex.Message, "danger");
            }
        }

        private void LoadSpeakerAgendas(int speakerId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("eventExpo.sp_GetSpeakerAgendas", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        // 1. Variables for counting
                        int totalCount = dt.Rows.Count;
                        int approvedCount = 0;
                        int rejectedCount = 0;
                        int appliedCount = 0; // New Variable

                        // 2. Count Loop
                        foreach (DataRow row in dt.Rows)
                        {
                            string status = row["AgendaStatus"].ToString();
                            if (status == "Approved") approvedCount++;
                            else if (status == "Rejected") rejectedCount++;
                            else if (status == "Applied") appliedCount++; // Count Applied
                        }

                        // 3. Bind Counts to Literals
                        litAllCount.Text = totalCount.ToString();
                        litApprovedCount.Text = approvedCount.ToString();
                        litRejectedCount.Text = rejectedCount.ToString();
                        litAppliedCount.Text = appliedCount.ToString(); // Bind New Literal

                        // 4. Render Cards
                        if (totalCount > 0)
                        {
                            StringBuilder html = new StringBuilder();

                            foreach (DataRow row in dt.Rows)
                            {
                                string status = row["AgendaStatus"].ToString();

                                // Determine CSS classes based on status
                                string statusClass = "";
                                string statusBadgeClass = "";
                                string icon = "";

                                if (status == "Approved")
                                {
                                    statusClass = "approved";
                                    statusBadgeClass = "status-badge approved";
                                    icon = "<i class='fas fa-check-circle'></i>";
                                }
                                else if (status == "Rejected")
                                {
                                    statusClass = "rejected";
                                    statusBadgeClass = "status-badge rejected";
                                    icon = "<i class='fas fa-times-circle'></i>";
                                }
                                else
                                {
                                    // Default to Applied
                                    statusClass = "applied";
                                    statusBadgeClass = "status-badge applied";
                                    icon = "<i class='fas fa-clock'></i>";
                                }

                                string day = row["Day"].ToString();
                                string track = row["Track"].ToString();
                                string time = row["Time"].ToString();
                                string title = row["Title"].ToString();
                                string brief = row["Brief"] != DBNull.Value ? row["Brief"].ToString() : "";

                                html.Append($"<div class='agenda-card {statusClass}'>");
                                html.Append("<div class='agenda-header'>");
                                html.Append("<div>");
                                html.Append($"<div class='agenda-title'>{title}</div>");
                                html.Append("<div class='agenda-meta'>");
                                html.Append($"<div class='meta-item'><i class='fas fa-calendar'></i> {day}</div>");
                                html.Append($"<div class='meta-item'><i class='fas fa-map-marker-alt'></i> {track}</div>");
                                html.Append($"<div class='meta-item'><i class='fas fa-clock'></i> {time}</div>");
                                html.Append("</div>");
                                html.Append("</div>");
                                html.Append($"<span class='{statusBadgeClass}'>{icon} {status}</span>");
                                html.Append("</div>");

                                if (!string.IsNullOrEmpty(brief))
                                {
                                    html.Append($"<div class='agenda-brief'>{brief}</div>");
                                }

                                html.Append("</div>");
                            }

                            litAgendaCards.Text = html.ToString();
                        }
                        else
                        {
                            litAgendaCards.Text = @"
                        <div class='empty-state'>
                            <i class='fas fa-calendar-times'></i>
                            <h3>No Agendas Found</h3>
                            <p>You haven't applied for or been assigned to any agendas yet.</p>
                        </div>";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading agendas: " + ex.Message, "danger");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear all session variables
            Session.Clear();
            Session.Abandon();

            // Redirect to login page
            Response.Redirect("SpeakerLogin.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = "";
            string icon = "";

            switch (type.ToLower())
            {
                case "success":
                    cssClass = "alert-success";
                    icon = "fa-check-circle";
                    break;
                case "danger":
                    cssClass = "alert-danger";
                    icon = "fa-exclamation-circle";
                    break;
                case "info":
                    cssClass = "alert-info";
                    icon = "fa-info-circle";
                    break;
                default:
                    cssClass = "alert-danger";
                    icon = "fa-exclamation-circle";
                    break;
            }

            litMessage.Text = $@"
                <div class='alert {cssClass}'>
                    <i class='fas {icon}'></i>
                    {message}
                </div>";
        }

        protected void btnSavePassword_Click(object sender, EventArgs e)
        {
            string oldPass = txtOldPass.Text.Trim();
            string newPass = txtNewPass.Text.Trim();
            string confPass = txtConfPass.Text.Trim();
            int speakerId = Convert.ToInt32(Session["SpeakerID"]);

            // 1. Basic Validation
            if (string.IsNullOrEmpty(oldPass) || string.IsNullOrEmpty(newPass))
            {
                ShowMessage("Please fill in all password fields.", "danger");
                return;
            }

            if (newPass != confPass)
            {
                ShowMessage("New password and confirm password do not match.", "danger");
                return;
            }

            if (newPass.Length < 6)
            {
                ShowMessage("New password must be at least 6 characters long.", "danger");
                return;
            }

            // 2. Database Update
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_ChangeSpeakerPassword", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                        cmd.Parameters.AddWithValue("@OldPassword", oldPass);
                        cmd.Parameters.AddWithValue("@NewPassword", newPass);

                        con.Open();
                        int result = Convert.ToInt32(cmd.ExecuteScalar());

                        if (result == 1)
                        {
                            ShowMessage("Password changed successfully!", "success");
                            // Clear fields after success
                            txtOldPass.Text = "";
                            txtNewPass.Text = "";
                            txtConfPass.Text = "";
                        }
                        else
                        {
                            ShowMessage("Incorrect current password.", "danger");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error changing password: " + ex.Message, "danger");
            }
        }
    }
}