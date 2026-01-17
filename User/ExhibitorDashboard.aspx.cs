using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Expo_Panel
{
    public partial class ExhibitorDashboard : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Security Check
            if (Session["ExhibitorID"] == null)
            {
                Response.Redirect("ExhibitorLogin.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                int exhibitorId = Convert.ToInt32(Session["ExhibitorID"]);
                LoadExhibitorData(exhibitorId);
            }
        }

        private void LoadExhibitorData(int exhibitorId)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                // Join basic info with post-approval profile
                string query = @"
                    SELECT 
                        e.Name, e.Company, e.Email, e.Designation, e.BoothType, e.AreaInSqm,
                        p.BoothNo, p.HallNo, p.ExhibitorProfile, p.YearOfEstablishment, p.Website,
                        p.PowerSupplyRequired, p.PowerSupplyKwh, 
                        p.InternetRequired, p.FurnitureRentalRequired, p.AVEquipmentRequired,
                        p.OtherRequirements
                    FROM TBL.Exhibitor e
                    LEFT JOIN TBL.PostApprovalExhibitor p ON e.ExhibitorID = p.ExhibitorID AND p.IS_ACTIVE = 1
                    WHERE e.ExhibitorID = @ExhibitorID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
                    con.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            // 1. Header Info
                            string name = rdr["Name"].ToString();
                            string company = rdr["Company"].ToString();

                            litUserName.Text = name;
                            litUserEmail.Text = rdr["Email"].ToString();
                            litWelcomeName.Text = company; // First name
                            litUserInitials.Text = GetInitials(name);

                            // 2. Profile Tab
                            litCompany.Text = company;
                            litRepName.Text = name;
                            litDesignation.Text = rdr["Designation"].ToString();
                            litEmail.Text = rdr["Email"].ToString();
                            litWebsite.Text = rdr["Website"] != DBNull.Value ? rdr["Website"].ToString() : "Not Provided";
                            litYear.Text = rdr["YearOfEstablishment"] != DBNull.Value ? rdr["YearOfEstablishment"].ToString() : "-";

                            // 3. Booth Tab
                            litBoothType.Text = rdr["BoothType"].ToString();
                            litHallNo.Text = rdr["HallNo"] != DBNull.Value ? rdr["HallNo"].ToString() : "Pending";
                            litBoothNo.Text = rdr["BoothNo"] != DBNull.Value ? rdr["BoothNo"].ToString() : "Pending";
                            litArea.Text = rdr["AreaInSqm"].ToString();
                            litProfileDesc.Text = rdr["ExhibitorProfile"] != DBNull.Value ? rdr["ExhibitorProfile"].ToString() : "No description provided.";

                            // 4. Supplies Tab
                            bool hasPower = rdr["PowerSupplyRequired"] != DBNull.Value && Convert.ToBoolean(rdr["PowerSupplyRequired"]);
                            string kwh = rdr["PowerSupplyKwh"] != DBNull.Value ? rdr["PowerSupplyKwh"].ToString() + " Kwh" : "-";
                            litPowerKwh.Text = kwh;
                            litPowerStatus.Text = GetStatusBadge(hasPower);

                            bool hasNet = rdr["InternetRequired"] != DBNull.Value && Convert.ToBoolean(rdr["InternetRequired"]);
                            litInternetStatus.Text = GetStatusBadge(hasNet);

                            bool hasFurn = rdr["FurnitureRentalRequired"] != DBNull.Value && Convert.ToBoolean(rdr["FurnitureRentalRequired"]);
                            litFurnitureStatus.Text = GetStatusBadge(hasFurn);

                            bool hasAV = rdr["AVEquipmentRequired"] != DBNull.Value && Convert.ToBoolean(rdr["AVEquipmentRequired"]);
                            litAVStatus.Text = GetStatusBadge(hasAV);

                            litOtherReq.Text = rdr["OtherRequirements"] != DBNull.Value ? rdr["OtherRequirements"].ToString() : "None";
                        }
                    }
                }
            }
        }

        private string GetStatusBadge(bool isRequested)
        {
            if (isRequested)
                return "<span class='supply-status status-yes'><i class='fas fa-check'></i> Requested</span>";
            else
                return "<span class='supply-status status-no'><i class='fas fa-times'></i> Not Req.</span>";
        }

        private string GetInitials(string name)
        {
            if (string.IsNullOrEmpty(name)) return "EX";
            var parts = name.Split(' ');
            if (parts.Length >= 2) return (parts[0][0].ToString() + parts[1][0].ToString()).ToUpper();
            return name.Substring(0, Math.Min(2, name.Length)).ToUpper();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("ExhibitorLogin.aspx");
        }

        protected void btnSavePassword_Click(object sender, EventArgs e)
        {
            string oldPass = txtOldPass.Text.Trim();
            string newPass = txtNewPass.Text.Trim();
            string confPass = txtConfPass.Text.Trim();
            int exhibitorId = Convert.ToInt32(Session["ExhibitorID"]);

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
                    using (SqlCommand cmd = new SqlCommand("sp_ChangeExhibitorPassword", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
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
    }
}