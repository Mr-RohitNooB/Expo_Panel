using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Expo_Panel
{
    public partial class PostSpeakerRegistration : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        private string SpeakerEmail
        {
            get { return Session["SpeakerEmail"] != null ? Session["SpeakerEmail"].ToString() : ""; }
        }

        private int SpeakerID
        {
            get { return Session["SpeakerID"] != null ? Convert.ToInt32(Session["SpeakerID"]) : 0; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if speaker is logged in
            if (string.IsNullOrEmpty(SpeakerEmail) || SpeakerID == 0)
            {
                Response.Redirect("SpeakerLogin.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                LoadSpeakerInfo();
                LoadAvailableAgendas();
                CheckExistingProfile();
            }

            if (Session["FlashMessage"] != null)
            {
                ShowMessage(Session["FlashMessage"].ToString(), "success");
                Session.Remove("FlashMessage");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("SpeakerLogin.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                // Validate file upload
                if (!fuPhoto.HasFile)
                {
                    ShowMessage("Please upload your photo.", "danger");
                    return;
                }

                // Validate file type and size
                string fileExtension = Path.GetExtension(fuPhoto.FileName).ToLower();
                if (fileExtension != ".jpg" && fileExtension != ".jpeg" && fileExtension != ".png")
                {
                    ShowMessage("Only JPG and PNG files are allowed.", "danger");
                    return;
                }

                if (fuPhoto.PostedFile.ContentLength > 2 * 1024 * 1024) // 2MB
                {
                    ShowMessage("File size must be less than 2MB.", "danger");
                    return;
                }

                // Upload photo
                string photoPath = UploadPhoto();
                if (string.IsNullOrEmpty(photoPath))
                {
                    ShowMessage("Error uploading photo. Please try again.", "danger");
                    return;
                }

                // Get form data
                string linkedIn = txtLinkedIn.Text.Trim();
                string bio = txtBio.Text.Trim();
                string selectedAgendas = hdnSelectedAgendas.Value;

                // Validate agenda selection
                if (string.IsNullOrEmpty(selectedAgendas))
                {
                    ShowMessage("Please select at least 1 topic.", "danger");
                    return;
                }

                string[] agendaIds = selectedAgendas.Split(',');
                if (agendaIds.Length > 3)
                {
                    ShowMessage("You can only select up to 3 topics.", "danger");
                    return;
                }

                // Save to database
                SaveProfile(photoPath, linkedIn, bio, selectedAgendas);

                Session["FlashMessage"] = "Your profile has been submitted successfully!";
                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        protected void cvAgendaSelection_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string selectedAgendas = hdnSelectedAgendas.Value;
            if (string.IsNullOrEmpty(selectedAgendas))
            {
                args.IsValid = false;
                return;
            }

            string[] agendaIds = selectedAgendas.Split(',');
            args.IsValid = (agendaIds.Length >= 1 && agendaIds.Length <= 3);
        }

        #region Private Methods

        private void LoadSpeakerInfo()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string query = "SELECT Name FROM TBL.Speaker WHERE SpeakerID = @SpeakerID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@SpeakerID", SpeakerID);
                        con.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            lblSpeakerName.Text = result.ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading speaker info: " + ex.Message, "danger");
            }
        }

        private void LoadAvailableAgendas()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAvailableAgendasForSelection", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        if (dt.Rows.Count > 0)
                        {
                            StringBuilder html = new StringBuilder();
                            html.Append("<div class='agenda-grid'>");

                            foreach (DataRow row in dt.Rows)
                            {
                                int agendaId = Convert.ToInt32(row["AgendaID"]);
                                string day = row["Day"].ToString();
                                string track = row["Track"].ToString();
                                string time = row["Time"].ToString();
                                string title = row["Title"].ToString();
                                string brief = row["Brief"] != DBNull.Value ? row["Brief"].ToString() : "";

                                html.Append("<div class='agenda-card' onclick=\"var cb = this.querySelector('input[type=checkbox]'); cb.checked = !cb.checked; toggleAgendaSelection(cb, " + agendaId + ");\">");
                                html.Append($"<input type='checkbox' class='agenda-checkbox' value='{agendaId}' onclick='event.stopPropagation(); toggleAgendaSelection(this, {agendaId});' />");
                                html.Append($"<div class='agenda-day'>{day}</div>");
                                html.Append($"<div class='agenda-title'>{title}</div>");
                                html.Append("<div class='agenda-meta'>");
                                html.Append($"<span><i class='fas fa-map-marker-alt'></i> {track}</span>");
                                html.Append($"<span><i class='fas fa-clock'></i> {time}</span>");
                                if (!string.IsNullOrEmpty(brief))
                                {
                                    html.Append($"<span style='margin-top: 5px; color: #64748b;'>{brief}</span>");
                                }
                                html.Append("</div>");
                                html.Append("</div>");
                            }

                            html.Append("</div>");
                            pnlAgendaGrid.Controls.Add(new Literal { Text = html.ToString() });
                        }
                        else
                        {
                            pnlAgendaGrid.Controls.Add(new Literal
                            {
                                Text = "<div style='text-align: center; padding: 40px; color: #94a3b8;'>" +
                                       "<i class='fas fa-inbox' style='font-size: 48px; margin-bottom: 15px; display: block;'></i>" +
                                       "No approved agenda topics available at the moment.</div>"
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading agendas: " + ex.Message, "danger");
            }
        }

        private void CheckExistingProfile()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetPostApprovalSpeakerProfile", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SpeakerID", SpeakerID);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            // Profile already exists - show info message
                            ShowMessage("You have already submitted your profile. You can update it if needed.", "info");

                            // Pre-fill form with existing data
                            txtLinkedIn.Text = reader["LinkedInProfile"] != DBNull.Value ? reader["LinkedInProfile"].ToString() : "";
                            txtBio.Text = reader["BioDescription"] != DBNull.Value ? reader["BioDescription"].ToString() : "";

                            string selectedAgendas = reader["SelectedAgendas"] != DBNull.Value ? reader["SelectedAgendas"].ToString() : "";
                            hdnSelectedAgendas.Value = selectedAgendas;

                            // Pre-select checkboxes (this will be handled by JavaScript on load)
                            if (!string.IsNullOrEmpty(selectedAgendas))
                            {
                                string script = $@"
                                    window.onload = function() {{
                                        var selectedIds = '{selectedAgendas}'.split(',');
                                        selectedIds.forEach(function(id) {{
                                            var checkbox = document.querySelector('.agenda-card input[value=""' + id + '""]');
                                            if (checkbox) {{
                                                checkbox.checked = true;
                                                checkbox.closest('.agenda-card').classList.add('selected');
                                            }}
                                        }});
                                        updateSelectedCount();
                                    }};
                                ";
                                ClientScript.RegisterStartupScript(this.GetType(), "preselectAgendas", script, true);
                            }
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error checking profile: " + ex.Message, "danger");
            }
        }

        private string UploadPhoto()
        {
            try
            {
                // Create upload directory if it doesn't exist
                string uploadFolder = Server.MapPath("~/Uploads/Speakers/Photos/");
                if (!Directory.Exists(uploadFolder))
                {
                    Directory.CreateDirectory(uploadFolder);
                }

                // Generate unique filename
                string fileExtension = Path.GetExtension(fuPhoto.FileName);
                string fileName = $"Speaker_{SpeakerID}_{DateTime.Now.Ticks}{fileExtension}";
                string filePath = Path.Combine(uploadFolder, fileName);

                // Save file
                fuPhoto.SaveAs(filePath);

                // Return relative path for database
                return $"~/Uploads/Speakers/Photos/{fileName}";
            }
            catch (Exception ex)
            {
                throw new Exception("Error uploading photo: " + ex.Message);
            }
        }

        private void SaveProfile(string photoPath, string linkedIn, string bio, string selectedAgendas)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpsertPostApprovalSpeaker", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@SpeakerID", SpeakerID);
                    cmd.Parameters.AddWithValue("@PhotoPath", photoPath);
                    cmd.Parameters.AddWithValue("@LinkedInProfile", linkedIn);
                    cmd.Parameters.AddWithValue("@BioDescription", string.IsNullOrEmpty(bio) ? (object)DBNull.Value : bio);
                    cmd.Parameters.AddWithValue("@SelectedAgendas", selectedAgendas);

                    SqlParameter outParam = new SqlParameter("@ProfileID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outParam);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "success" ? "alert-success" :
                            (type == "info" ? "alert-info" : "alert-danger");
            string icon = type == "success" ? "fa-check-circle" :
                         (type == "info" ? "fa-info-circle" : "fa-exclamation-circle");

            litMessage.Text = $@"
                <div class='alert {cssClass}'>
                    <i class='fas {icon}'></i>
                    {message}
                </div>";
        }

        #endregion
    }
}