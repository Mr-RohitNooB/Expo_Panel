using System;
using System.Configuration;
using System.Data;
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
                // Check if already logged in
                if (Session["SpeakerEmail"] != null && Session["SpeakerID"] != null)
                {
                    Response.Redirect("PostSpeakerRegistration.aspx", false);
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

                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_ValidateSpeakerLogin", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            int speakerId = Convert.ToInt32(reader["SpeakerID"]);
                            string name = reader["Name"].ToString();
                            string approvalStatus = reader["ApprovalStatus"].ToString();
                            bool isActive = Convert.ToBoolean(reader["IS_ACTIVE"]);

                            if (approvalStatus != "Approved")
                            {
                                ShowMessage("Your account is not yet approved. Please wait for admin approval.", "danger");
                                return;
                            }

                            if (!isActive)
                            {
                                ShowMessage("Your account is inactive. Please contact the administrator.", "danger");
                                return;
                            }

                            // Login successful
                            Session["SpeakerID"] = speakerId;
                            Session["SpeakerEmail"] = email;
                            Session["SpeakerName"] = name;
                            Session["IsSpeakerAuthenticated"] = true;

                            Response.Redirect("PostSpeakerRegistration.aspx", false);
                            Context.ApplicationInstance.CompleteRequest();
                        }
                        else
                        {
                            ShowMessage("Invalid email or password.", "danger");
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "danger" ? "alert-danger" : "alert-success";
            string icon = type == "danger" ? "fa-exclamation-circle" : "fa-check-circle";

            litMessage.Text = $@"
                <div class='alert {cssClass}'>
                    <i class='fas {icon}'></i>
                    {message}
                </div>";
        }
    }
}