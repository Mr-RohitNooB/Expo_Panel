using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Expo_Panel
{
    public partial class ExhibitorLogin : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // If they are already logged in, send them to the profile page
                if (Session["ExhibitorID"] != null)
                {
                    Response.Redirect("PostApprovalExhibitor.aspx");
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            try
            {
                ValidateExhibitorLogin(email, password);
            }
            catch (Exception ex)
            {
                ShowMessage(ex.Message, "danger");
            }
        }

        private void ValidateExhibitorLogin(string email, string password)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_ValidateExhibitorLogin", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);

                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Login successful, check status
                            string approvalStatus = reader["ApprovalStatus"].ToString();
                            int exhibitorId = Convert.ToInt32(reader["ExhibitorID"]);

                            if (approvalStatus == "Approved")
                            {
                                // Success! Create session and redirect.
                                Session["ExhibitorID"] = exhibitorId;
                                Response.Redirect("PostApprovalExhibitor.aspx");
                            }
                            else if (approvalStatus == "Pending")
                            {
                                throw new Exception("Your registration is still pending approval.");
                            }
                            else if (approvalStatus == "Rejected")
                            {
                                throw new Exception("Your registration has been rejected. Please contact support.");
                            }
                        }
                        else
                        {
                            // No user found
                            throw new Exception("Invalid email or password.");
                        }
                    }
                }
            }
        }

        private void ShowMessage(string message, string type)
        {
            litMessage.Text = $@"
                <div class='alert alert-{type}'>
                    {message}
                </div>";
        }
    }
}