using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Expo_Panel.Admin
{
    public partial class ExhibitorDashboard : System.Web.UI.Page
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

                // Load all exhibitors initially
                LoadExhibitors("");
            }

            // Handle flash messages
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
            Response.Redirect("Default.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchText = txtSearch.Text.Trim();
            LoadExhibitors(searchText);

            if (!string.IsNullOrEmpty(searchText))
            {
                ShowMessage($"Search results for '{searchText}'", "info");
            }
        }

        protected void gvExhibitors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int exhibitorId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditExhibitor")
            {
                LoadExhibitorForEdit(exhibitorId);
            }
            else if (e.CommandName == "ToggleStatus")
            {
                ToggleExhibitorStatus(exhibitorId);
            }
            else if (e.CommandName == "QuickToggle")
            {
                ToggleExhibitorStatus(exhibitorId);
            }
        }

        protected void btnSaveExhibitor_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int exhibitorId = Convert.ToInt32(hdnExhibitorID.Value);
                string mode = hdnModalMode.Value;
                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                string designation = txtDesignation.Text.Trim();
                string company = txtCompany.Text.Trim();
                bool isActive = ddlStatus.SelectedValue == "1";

                if (mode == "add")
                {
                    AddExhibitor(name, email, mobile, designation, company, isActive);
                    Session["FlashMessage"] = "Exhibitor added successfully!";
                }
                else if (mode == "edit")
                {
                    UpdateExhibitor(exhibitorId, name, email, mobile, designation, company, isActive);
                    Session["FlashMessage"] = "Exhibitor updated successfully!";
                }

                // Clear form
                ClearForm();

                // Redirect to prevent form resubmission
                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (SqlException sqlEx)
            {
                string errorMsg = sqlEx.Message;
                if (errorMsg.Contains("Email already exists"))
                {
                    ShowMessage("This email address is already registered in Exhibitors. Please use a different email.", "danger");
                }
                else
                {
                    ShowMessage("Database Error: " + errorMsg, "danger");
                }

                // Keep modal open on error
                string escapedName = txtName.Text.Replace("'", "\\'");
                string escapedEmail = txtEmail.Text.Replace("'", "\\'");
                string escapedMobile = txtMobile.Text.Replace("'", "\\'");
                string escapedDesignation = txtDesignation.Text.Replace("'", "\\'");
                string escapedCompany = txtCompany.Text.Replace("'", "\\'");

                ScriptManager.RegisterStartupScript(this, GetType(), "keepModalOpen",
                    $"setTimeout(function(){{ openModal('{hdnModalMode.Value}', " +
                    $"'{hdnExhibitorID.Value}', " +
                    $"'{escapedName}', " +
                    $"'{escapedEmail}', " +
                    $"'{escapedMobile}', " +
                    $"'{escapedDesignation}', " +
                    $"'{escapedCompany}', " +
                    $"'{ddlStatus.SelectedValue}'); }}, 100);", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");

                string escapedName = txtName.Text.Replace("'", "\\'");
                string escapedEmail = txtEmail.Text.Replace("'", "\\'");
                string escapedMobile = txtMobile.Text.Replace("'", "\\'");
                string escapedDesignation = txtDesignation.Text.Replace("'", "\\'");
                string escapedCompany = txtCompany.Text.Replace("'", "\\'");

                ScriptManager.RegisterStartupScript(this, GetType(), "keepModalOpen",
                    $"setTimeout(function(){{ openModal('{hdnModalMode.Value}', " +
                    $"'{hdnExhibitorID.Value}', " +
                    $"'{escapedName}', " +
                    $"'{escapedEmail}', " +
                    $"'{escapedMobile}', " +
                    $"'{escapedDesignation}', " +
                    $"'{escapedCompany}', " +
                    $"'{ddlStatus.SelectedValue}'); }}, 100);", true);
            }
        }

        private void LoadExhibitors(string searchText)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAllExhibitors", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SearchText", string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText);

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        gvExhibitors.DataSource = dt;
                        gvExhibitors.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading exhibitors: " + ex.Message, "danger");
            }
        }

        private void LoadExhibitorForEdit(int exhibitorId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetExhibitorById", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            hdnExhibitorID.Value = exhibitorId.ToString();
                            hdnModalMode.Value = "edit";

                            string name = reader["Name"].ToString();
                            string email = reader["Email"].ToString();
                            string mobile = reader["Mobile"].ToString();
                            string designation = reader["Designation"].ToString();
                            string company = reader["Company"].ToString();
                            bool isActive = Convert.ToBoolean(reader["IS_ACTIVE"]);

                            // Register script to open modal with data
                            string script = $"openModal('edit', {exhibitorId}, '{name}', '{email}', '{mobile}', '{designation}', '{company}', '{(isActive ? "1" : "0")}');";
                            ScriptManager.RegisterStartupScript(this, GetType(), "openEditModal", script, true);
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading exhibitor: " + ex.Message, "danger");
            }
        }

        private void AddExhibitor(string name, string email, string mobile, string designation, string company, bool isActive)
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

                    SqlParameter outParam = new SqlParameter("@ExhibitorID", SqlDbType.Int);
                    outParam.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outParam);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateExhibitor(int exhibitorId, string name, string email, string mobile, string designation, string company, bool isActive)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateExhibitor", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
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
        }

        private void ToggleExhibitorStatus(int exhibitorId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_ToggleExhibitorStatus", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowMessage("Exhibitor status updated successfully!", "success");
                LoadExhibitors(txtSearch.Text.Trim());
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating status: " + ex.Message, "danger");
            }
        }

        protected void gvExhibitors_RowDataBound(object sender, GridViewRowEventArgs e)
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
            hdnExhibitorID.Value = "0";
            hdnModalMode.Value = "add";
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