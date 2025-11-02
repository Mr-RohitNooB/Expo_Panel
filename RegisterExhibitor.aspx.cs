using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

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
            if (!Page.IsValid) return;

            // Validate declaration checkbox
            if (!chkDeclaration.Checked)
            {
                ShowMessage("Please accept the declaration to proceed.", "danger");
                return;
            }

            try
            {
                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                string designation = txtDesignation.Text.Trim();
                string company = txtCompany.Text.Trim();
                string headOffice = txtHeadOffice.Text.Trim();
                string city = txtCity.Text.Trim();
                string state = txtState.Text.Trim();
                string country = txtCountry.Text.Trim();
                string gstNumber = txtGSTNumber.Text.Trim();
                string billingAddress = txtBillingAddress.Text.Trim();

                // Get booth type
                string boothType = string.Empty;
                if (rbShellScheme.Checked) boothType = "Shell Scheme";
                else if (rbRawSpace.Checked) boothType = "Raw Space";

                decimal areaInSqm = 0;
                if (!string.IsNullOrEmpty(txtAreaInSqm.Text.Trim()))
                {
                    decimal.TryParse(txtAreaInSqm.Text.Trim(), out areaInSqm);
                }

                bool interestedInConference = chkConference.Checked;
                bool interestedInSponsorship = chkSponsorship.Checked;
                bool interestedInAdvertising = chkAdvertising.Checked;
                bool interestedInCustomPackage = chkCustomPackage.Checked;
                bool acceptedDeclaration = chkDeclaration.Checked;

                string registrationType = "Online";
                bool isActive = true;

                int exhibitorId = AddExhibitor(
                    name, email, mobile, designation, company,
                    headOffice, city, state, country, gstNumber, billingAddress,
                    boothType, areaInSqm,
                    interestedInConference, interestedInSponsorship,
                    interestedInAdvertising, interestedInCustomPackage,
                    acceptedDeclaration, isActive, registrationType
                );

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

        private int AddExhibitor(string name, string email, string mobile, string designation,
            string company, string headOffice, string city, string state, string country,
            string gstNumber, string billingAddress, string boothType, decimal areaInSqm,
            bool interestedInConference, bool interestedInSponsorship,
            bool interestedInAdvertising, bool interestedInCustomPackage,
            bool acceptedDeclaration, bool isActive, string registrationType)
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
                    cmd.Parameters.AddWithValue("@HeadOfficeAddress", string.IsNullOrEmpty(headOffice) ? (object)DBNull.Value : headOffice);
                    cmd.Parameters.AddWithValue("@City", string.IsNullOrEmpty(city) ? (object)DBNull.Value : city);
                    cmd.Parameters.AddWithValue("@State", string.IsNullOrEmpty(state) ? (object)DBNull.Value : state);
                    cmd.Parameters.AddWithValue("@Country", string.IsNullOrEmpty(country) ? (object)DBNull.Value : country);
                    cmd.Parameters.AddWithValue("@GSTNumber", string.IsNullOrEmpty(gstNumber) ? (object)DBNull.Value : gstNumber);
                    cmd.Parameters.AddWithValue("@BillingAddress", string.IsNullOrEmpty(billingAddress) ? (object)DBNull.Value : billingAddress);
                    cmd.Parameters.AddWithValue("@BoothType", string.IsNullOrEmpty(boothType) ? (object)DBNull.Value : boothType);
                    cmd.Parameters.AddWithValue("@AreaInSqm", areaInSqm > 0 ? (object)areaInSqm : DBNull.Value);
                    cmd.Parameters.AddWithValue("@InterestedInConference", interestedInConference);
                    cmd.Parameters.AddWithValue("@InterestedInSponsorship", interestedInSponsorship);
                    cmd.Parameters.AddWithValue("@InterestedInAdvertising", interestedInAdvertising);
                    cmd.Parameters.AddWithValue("@InterestedInCustomPackage", interestedInCustomPackage);
                    cmd.Parameters.AddWithValue("@AcceptedDeclaration", acceptedDeclaration);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);
                    cmd.Parameters.AddWithValue("@RegistrationType", registrationType);

                    SqlParameter outParam = new SqlParameter("@ExhibitorID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outParam);

                    con.Open();
                    cmd.ExecuteNonQuery();

                    return Convert.ToInt32(outParam.Value);
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
            txtHeadOffice.Text = "";
            txtCity.Text = "";
            txtState.Text = "";
            txtCountry.Text = "";
            txtGSTNumber.Text = "";
            txtBillingAddress.Text = "";
            rbShellScheme.Checked = false;
            rbRawSpace.Checked = false;
            txtAreaInSqm.Text = "";
            chkConference.Checked = false;
            chkSponsorship.Checked = false;
            chkAdvertising.Checked = false;
            chkCustomPackage.Checked = false;
            chkDeclaration.Checked = false;
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "success" ? "alert-success" : "alert-danger";
            string icon = type == "success" ? "fa-check-circle" : "fa-exclamation-circle";

            litMessage.Text = $@"
        <div class='alert {cssClass}' role='alert'>
            <i class='fas {icon}'></i> {message}
            <button type='button' class='close-btn' onclick='this.parentElement.style.display=""none""'>
                &times;
            </button>
        </div>";
        }


    }
}
