using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Expo_Panel
{
    public partial class RegisterExhibitor : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                string designation = txtDesignation.Text.Trim();
                string company = txtCompany.Text.Trim();
                string registrationType = "Online"; // Always set to Online for public registration
                bool isActive = true; // Set to true by default

                // Add exhibitor to database
                int exhibitorId = AddExhibitor(name, email, mobile, designation, company, isActive, registrationType);

                if (exhibitorId > 0)
                {
                    ShowMessage("Your registration has been submitted successfully!", "success");
                    ClearForm();
                }
                else
                {
                    ShowMessage("Registration failed. Please try again.", "danger");
                }
            }
            catch (SqlException sqlEx)
            {
                string errorMsg = sqlEx.Message;
                if (errorMsg.Contains("Email already exists"))
                {
                    ShowMessage("This email address is already registered.", "danger");
                }
                else
                {
                    ShowMessage("Database Error: " + errorMsg, "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        private int AddExhibitor(string name, string email, string mobile, string designation, string company, bool isActive, string registrationType)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_AddExhibitor", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                    cmd.Parameters.AddWithValue("@Designation", designation);
                    cmd.Parameters.AddWithValue("@Company", company);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);
                    // Note: sp_AddExhibitor doesn't have RegistrationType parameter, but it will default to "Admin" in the database
                    // We'll need to update it after insertion

                    SqlParameter outParam = new SqlParameter("@ExhibitorID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outParam);

                    con.Open();
                    cmd.ExecuteNonQuery();

                    // Update the registration type to "Online" since the stored procedure doesn't support it
                    int exhibitorId = Convert.ToInt32(outParam.Value);
                    UpdateRegistrationType(exhibitorId, registrationType);

                    return exhibitorId;
                }
            }
        }

        private void UpdateRegistrationType(int exhibitorId, string registrationType)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("UPDATE TBL.Exhibitor SET RegistrationType = @RegistrationType WHERE ExhibitorID = @ExhibitorID", con))
                {
                    cmd.Parameters.AddWithValue("@RegistrationType", registrationType);
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void ClearForm()
        {
            txtName.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
            txtDesignation.Text = "";
            txtCompany.Text = "";
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "success" ? "alert-success" : "alert-danger";
            string icon = type == "success" ? "fa-check-circle" : "fa-exclamation-circle";

            litMessage.Text = $@"
                <div class='alert {cssClass}'>
                    <i class='fas {icon}'></i>
                    {message}
                </div>";
        }
    }
}