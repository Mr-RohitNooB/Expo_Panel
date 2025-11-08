using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace Expo_Panel
{
    public partial class SpeakerLogin : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if speaker is already logged in
                if (Session["IsSpeakerLoggedIn"] != null && (bool)Session["IsSpeakerLoggedIn"])
                {
                    Response.Redirect("RegisterSpeaker.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text.Trim();

                // Authenticate speaker
                int speakerId = AuthenticateSpeaker(email, password);

                if (speakerId > 0)
                {
                    // Get speaker details
                    var speakerDetails = GetSpeakerDetails(speakerId);

                    if (speakerDetails != null)
                    {
                        // Set session variables
                        Session["IsSpeakerLoggedIn"] = true;
                        Session["SpeakerID"] = speakerId;
                        Session["SpeakerName"] = speakerDetails.Name;
                        Session["SpeakerEmail"] = speakerDetails.Email;
                        Session["SpeakerApprovalStatus"] = speakerDetails.ApprovalStatus;

                        // Redirect to RegisterSpeaker page (edit mode)
                        Response.Redirect("RegisterSpeaker.aspx", false);
                        Context.ApplicationInstance.CompleteRequest();
                    }
                    else
                    {
                        ShowMessage("Unable to retrieve speaker details. Please try again.", "danger");
                    }
                }
                else
                {
                    ShowMessage("Invalid email or password. Please check your credentials.", "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Login error: " + ex.Message, "danger");
            }
        }

        private int AuthenticateSpeaker(string email, string password)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string query = @"
                        SELECT SpeakerID, ApprovalStatus 
                        FROM TBL.Speaker 
                        WHERE Email = @Email 
                        AND Password = @Password 
                        AND IS_ACTIVE = 1";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            int speakerId = Convert.ToInt32(reader["SpeakerID"]);
                            string approvalStatus = reader["ApprovalStatus"].ToString();

                            // Check if speaker is approved
                            if (approvalStatus != "Approved")
                            {
                                ShowMessage("Your account is not yet approved. Please wait for admin approval.", "info");
                                return 0;
                            }

                            return speakerId;
                        }

                        return 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Authentication failed: " + ex.Message);
            }
        }

        private SpeakerInfo GetSpeakerDetails(int speakerId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string query = @"
                        SELECT SpeakerID, Name, Email, ApprovalStatus 
                        FROM TBL.Speaker 
                        WHERE SpeakerID = @SpeakerID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            return new SpeakerInfo
                            {
                                SpeakerID = Convert.ToInt32(reader["SpeakerID"]),
                                Name = reader["Name"].ToString(),
                                Email = reader["Email"].ToString(),
                                ApprovalStatus = reader["ApprovalStatus"].ToString()
                            };
                        }

                        return null;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Failed to get speaker details: " + ex.Message);
            }
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "success" ? "alert-success" :
                              type == "info" ? "alert-info" : "alert-danger";
            string icon = type == "success" ? "fa-check-circle" :
                          type == "info" ? "fa-info-circle" : "fa-exclamation-circle";

            litMessage.Text = $@"
                <div class='alert {cssClass}'>
                    <i class='fas {icon}'></i>
                    <span>{message}</span>
                </div>";
        }

        // Helper class for speaker info
        private class SpeakerInfo
        {
            public int SpeakerID { get; set; }
            public string Name { get; set; }
            public string Email { get; set; }
            public string ApprovalStatus { get; set; }
        }
    }
}
