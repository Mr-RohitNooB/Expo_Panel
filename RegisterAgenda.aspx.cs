using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Expo_Panel
{
    public partial class RegisterAgenda : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Page initialization
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                string day = txtDay.Text.Trim();
                string track = txtTrack.Text.Trim();
                string time = txtTime.Text.Trim();
                string title = txtTitle.Text.Trim();
                string brief = txtBrief.Text.Trim();
                string synopsis = txtSynopsis.Text.Trim();
                string registrationType = "Online"; // Always set to Online for public registration
                bool isActive = true; // Set to true by default

                // Add agenda to database
                int agendaId = AddAgenda(day, track, time, title, brief, synopsis, isActive, registrationType);

                if (agendaId > 0)
                {
                    ShowMessage("Your agenda item has been submitted successfully! It will be reviewed by our team.", "success");
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
                ShowMessage("Database Error: " + errorMsg, "danger");
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        private int AddAgenda(string day, string track, string time, string title, string brief, string synopsis, bool isActive, string registrationType)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_AddAgenda", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Day", day);
                    cmd.Parameters.AddWithValue("@Track", track);
                    cmd.Parameters.AddWithValue("@Time", time);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Brief", string.IsNullOrEmpty(brief) ? (object)DBNull.Value : brief);
                    cmd.Parameters.AddWithValue("@Synopsis", string.IsNullOrEmpty(synopsis) ? (object)DBNull.Value : synopsis);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);
                    cmd.Parameters.AddWithValue("@RegistrationType", registrationType);
                    // ApprovalStatus will default to "Pending" as per database design

                    SqlParameter outParam = new SqlParameter("@AgendaID", SqlDbType.Int)
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
            txtDay.Text = "";
            txtTrack.Text = "";
            txtTime.Text = "";
            txtTitle.Text = "";
            txtBrief.Text = "";
            txtSynopsis.Text = "";
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "success" ? "alert-success" : (type == "info" ? "alert-info" : "alert-danger");
            string icon = type == "success" ? "fa-check-circle" : (type == "info" ? "fa-info-circle" : "fa-exclamation-circle");

            litMessage.Text = $@"
                <div class='alert {cssClass}'>
                    <i class='fas {icon}'></i>
                    {message}
                </div>";
        }
    }
}