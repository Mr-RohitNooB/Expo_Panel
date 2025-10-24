using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Expo_Panel.Admin
{
    public partial class SpeakerDashboard : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["IsAuthenticated"] == null || !(bool)Session["IsAuthenticated"])
            {
                Response.Redirect("Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                // Display username
                if (Session["AdminUsername"] != null)
                {
                    lblUsername.Text = Session["AdminUsername"].ToString();
                    lblSessionStatus.Text = "Active";
                    lblSessionStatus.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    lblUsername.Text = "Unknown";
                    lblSessionStatus.Text = "Invalid";
                    lblSessionStatus.ForeColor = System.Drawing.Color.Red;
                }

                // Load all speakers initially
                LoadSpeakers("");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchText = txtSearch.Text.Trim();
            LoadSpeakers(searchText);
            if (!string.IsNullOrEmpty(searchText))
            {
                ShowMessage($"Search results for '{searchText}'", "info");
            }
        }

        protected void gvSpeakers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int speakerId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditSpeaker")
            {
                LoadSpeakerForEdit(speakerId);
            }
            else if (e.CommandName == "ToggleStatus")
            {
                ToggleSpeakerStatus(speakerId);
            }
            else if (e.CommandName == "QuickToggle")
            {
                ToggleSpeakerStatus(speakerId);
            }
        }

        protected void btnSaveSpeaker_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int speakerId = Convert.ToInt32(hdnSpeakerID.Value);
                string mode = hdnModalMode.Value;

                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                string designation = txtDesignation.Text.Trim();
                string company = txtCompany.Text.Trim();
                bool isActive = ddlStatus.SelectedValue == "1";

                if (mode == "add")
                {
                    AddSpeaker(name, email, mobile, designation, company, isActive);
                }
                else if (mode == "edit")
                {
                    UpdateSpeaker(speakerId, name, email, mobile, designation, company, isActive);
                }

                // Reload grid
                LoadSpeakers(txtSearch.Text.Trim());

                // Clear form
                ClearForm();

                // Close modal via client script
                ScriptManager.RegisterStartupScript(this, GetType(), "closeModal", "closeModal();", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        private void LoadSpeakers(string searchText)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAllSpeakers", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SearchText", string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText);

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        gvSpeakers.DataSource = dt;
                        gvSpeakers.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading speakers: " + ex.Message, "danger");
            }
        }

        private void LoadSpeakerForEdit(int speakerId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetSpeakerById", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            hdnSpeakerID.Value = speakerId.ToString();
                            hdnModalMode.Value = "edit";

                            string name = reader["Name"].ToString();
                            string email = reader["Email"].ToString();
                            string mobile = reader["Mobile"].ToString();
                            string designation = reader["Designation"].ToString();
                            string company = reader["Company"].ToString();
                            bool isActive = Convert.ToBoolean(reader["IS_ACTIVE"]);

                            // Escape single quotes for JavaScript
                            name = name.Replace("'", "\\'");
                            email = email.Replace("'", "\\'");
                            mobile = mobile.Replace("'", "\\'");
                            designation = designation.Replace("'", "\\'");
                            company = company.Replace("'", "\\'");

                            // Register script to open modal with data
                            string script = $"openModal('edit', {speakerId}, '{name}', '{email}', '{mobile}', '{designation}', '{company}', '{(isActive ? "1" : "0")}');";
                            ScriptManager.RegisterStartupScript(this, GetType(), "openEditModal", script, true);
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading speaker: " + ex.Message, "danger");
            }
        }

        private void AddSpeaker(string name, string email, string mobile, string designation, string company, bool isActive)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_AddSpeaker", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@Name", name);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                        cmd.Parameters.AddWithValue("@Designation", designation);
                        cmd.Parameters.AddWithValue("@Company", company);
                        cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);

                        // Add OUTPUT parameter
                        SqlParameter outParam = new SqlParameter("@SpeakerID", SqlDbType.Int);
                        outParam.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(outParam);

                        con.Open();
                        cmd.ExecuteNonQuery();

                        // Optional: Get the new ID
                        int newSpeakerId = Convert.ToInt32(cmd.Parameters["@SpeakerID"].Value);
                    }
                }

                ShowMessage("Speaker added successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error adding speaker: " + ex.Message, "danger");
                throw;
            }
        }

        private void UpdateSpeaker(int speakerId, string name, string email, string mobile, string designation, string company, bool isActive)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_UpdateSpeaker", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                        cmd.Parameters.AddWithValue("@Name", name);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                        cmd.Parameters.AddWithValue("@Designation", designation);
                        cmd.Parameters.AddWithValue("@Company", company);
                        cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowMessage("Speaker updated successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating speaker: " + ex.Message, "danger");
                throw;
            }
        }

        private void ToggleSpeakerStatus(int speakerId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_ToggleSpeakerStatus", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowMessage("Speaker status updated successfully!", "success");
                LoadSpeakers(txtSearch.Text.Trim());
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating status: " + ex.Message, "danger");
            }
        }

        protected void gvSpeakers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                try
                {
                    // Get the data item bound to this row
                    DataRowView drv = (DataRowView)e.Row.DataItem;

                    // Check the IS_ACTIVE status from the data
                    bool isActive = Convert.ToBoolean(drv["IS_ACTIVE"]);

                    if (!isActive)
                    {
                        // Add the CSS class to the entire row
                        e.Row.CssClass += " inactive-row";
                    }
                }
                catch (Exception ex)
                {
                    // Handle any potential errors
                    ShowMessage("Error during row binding: " + ex.Message, "danger");
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
            ddlStatus.SelectedIndex = 0;
            hdnSpeakerID.Value = "0";
            hdnModalMode.Value = "add";
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "success" ? "alert-success" : type == "info" ? "alert-info" : "alert-danger";
            string icon = type == "success" ? "fa-check-circle" : type == "info" ? "fa-info-circle" : "fa-exclamation-circle";

            litMessage.Text = $@"
                <div class='alert {cssClass} alert-dismissible fade show' role='alert'>
                    <i class='fas {icon}'></i> {message}
                    <button type='button' class='close' data-dismiss='alert' aria-label='Close'>
                        <span aria-hidden='true'>&times;</span>
                    </button>
                </div>";
        }
    }
}
