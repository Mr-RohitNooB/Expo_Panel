
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
// --- ADDED ---
// Required for the new AJAX (WebMethod) approach
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Expo_Panel.Admin
{
    public partial class ManageAdvisors : System.Web.UI.Page
    {
        // Re-used from your other files
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        private int CurrentAdminID
        {
            get
            {
                if (Session["AdminID"] != null)
                    return Convert.ToInt32(Session["AdminID"]);
                return 0; // Or handle as appropriate if admin ID is required
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Standard session check from your ManageAgenda.aspx.cs
            if (Session["IsAuthenticated"] == null || !(bool)Session["IsAuthenticated"])
            {
                Response.Redirect("Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                // Load username and session status (copied from your file)
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

                // New methods for loading advisor data
                LoadAdvisorStatusCounts();
                LoadAdvisors(txtSearch.Text.Trim(), "Pending"); // Default to pending
                SetActiveFilterButton("Pending");
            }

            // Flash message logic (copied from your file)
            if (Session["FlashMessage"] != null)
            {
                ShowMessage(Session["FlashMessage"].ToString(), "success");
                Session.Remove("FlashMessage");
            }
        }

        // Standard logout (copied from your file)
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        // Search logic (adapted for Advisors)
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchText = txtSearch.Text.Trim();
            string currentFilter = hdnCurrentFilter.Value;

            LoadAdvisors(searchText, currentFilter); // Calls LoadAdvisors

            if (!string.IsNullOrEmpty(searchText))
            {
                ShowMessage($"Search results for '{searchText}' in {currentFilter} records", "info");
            }
            
        }

        // Filter logic (adapted for Advisors)
        protected void btnStatusFilter_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string filterStatus = btn.CommandArgument;

            hdnCurrentFilter.Value = filterStatus;

            LoadAdvisors(txtSearch.Text.Trim(), filterStatus); // Calls LoadAdvisors
            LoadAdvisorStatusCounts(); // Recalculate counts
            SetActiveFilterButton(filterStatus);
            
        }

        // GridView logic (adapted for Advisors)
        protected void gvAdvisors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int advisorId = Convert.ToInt32(e.CommandArgument);

            // --- CHANGED ---
            // "EditAdvisor" and "ApprovalAction" are now handled by JavaScript/AJAX.
            // We only need to handle "QuickToggle" here.
            if (e.CommandName == "QuickToggle")
            {
                ToggleAdvisorStatus(advisorId); // Calls new toggle method
            }
        }

        // RowDataBound logic (copied from your file, no changes needed)
        protected void gvAdvisors_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                try
                {
                    DataRowView drv = (DataRowView)e.Row.DataItem;
                    bool isActive = Convert.ToBoolean(drv["IS_ACTIVE"]);

                    if (!isActive)
                    {
                        e.Row.CssClass += " inactive-row";
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error during row binding: " + ex.Message, "danger");
                }
            }
        }

        // Save (Add/Edit) logic (adapted for Advisors)
        protected void btnSaveAdvisor_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int advisorId = Convert.ToInt32(hdnAdvisorID.Value);
                string mode = hdnModalMode.Value;

                // Get values from the advisor modal
                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                string designation = txtDesignation.Text.Trim();
                string company = txtCompany.Text.Trim();
                bool isActive = ddlStatus.SelectedValue == "1";

                if (mode == "add")
                {
                    // Password is required for 'add'
                    string password = txtPassword.Text.Trim();
                    AddAdvisorWithLogin(name, email, mobile, designation, company, password,
                                        false, CurrentAdminID, "Approved", "", (isActive ? 1 : 0));
                    Session["FlashMessage"] = "Advisor added successfully!";
                }
                else if (mode == "edit")
                {
                    // Get the new password. It will be blank if user doesn't want to change.
                    // This is handled by the "UpdateAdvisor" stored procedure.
                    string newPassword = txtPassword.Text.Trim();

                    UpdateAdvisor(advisorId, name, email, mobile, designation, company, isActive, newPassword);
                    Session["FlashMessage"] = "Advisor updated successfully!";
                }

                ClearForm();
                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
                ClearForm();
            }
        }

        // Save Approval logic (adapted for Advisors)
        protected void btnSaveApproval_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int advisorId = Convert.ToInt32(hdnApprovalAdvisorID.Value);
                string approvalStatus = ddlApprovalStatus.SelectedValue;
                string remarks = txtApprovalRemarks.Text.Trim();

                if (approvalStatus == "Rejected" && string.IsNullOrEmpty(remarks))
                {
                    ShowMessage("Remarks are required when rejecting an advisor.", "danger");
                    // We must call the JS function to re-open the modal
                    ScriptManager.RegisterStartupScript(this, GetType(), "reOpenApprovalModal",
                        $"document.getElementById('approvalModal').classList.add('show');", true);
                    return;
                }

                UpdateAdvisorApprovalStatus(advisorId, approvalStatus, remarks); // Calls new approval SP

                Session["FlashMessage"] = $"Advisor {approvalStatus.ToLower()} successfully!";

                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating approval status: " + ex.Message, "danger");
            }
        }

        // Custom Validator logic (copied from your file, no changes needed)
        protected void cvRemarks_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string approvalStatus = ddlApprovalStatus.SelectedValue;
            string remarks = txtApprovalRemarks.Text.Trim();

            if (approvalStatus == "Rejected" && string.IsNullOrEmpty(remarks))
            {
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        // --- NEW [WebMethod] ---
        // This static method can be called directly from JavaScript (AJAX)
        // This replaces LoadAdvisorForEdit and LoadAdvisorForApproval
        [WebMethod]
        public static string GetAdvisorDetails(int advisorId)
        {
            // WebMethods are static, so we must manually get the connection string
            string constr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

            // We will build a dictionary of data to send back as JSON
            var advisorData = new Dictionary<string, object>();

            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    // We assume sp_GetAdvisorById has been updated to SELECT the Password
                    using (SqlCommand cmd = new SqlCommand("sp_GetAdvisorById", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AdvisorID", advisorId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            // Build the data object
                            advisorData["AdvisorID"] = reader["AdvisorID"];
                            advisorData["Name"] = reader["Name"].ToString();
                            advisorData["Email"] = reader["Email"].ToString();
                            advisorData["Mobile"] = reader["Mobile"].ToString();
                            advisorData["Designation"] = reader["Designation"].ToString();
                            advisorData["Company"] = reader["Company"].ToString();
                            advisorData["IS_ACTIVE"] = (bool)reader["IS_ACTIVE"] ? "1" : "0";
                            advisorData["RegistrationType"] = reader["RegistrationType"].ToString();
                            advisorData["ApprovalStatus"] = reader["ApprovalStatus"].ToString();
                            advisorData["Remarks"] = reader["Remarks"].ToString();
                            // --- THIS IS YOUR REQUESTED FEATURE ---
                            advisorData["Password"] = reader["Password"].ToString();
                        }
                        reader.Close();
                    }
                }

                // Serialize the dictionary to a JSON string
                var js = new JavaScriptSerializer();
                return js.Serialize(advisorData);
            }
            catch (Exception ex)
            {
                // Send back an error object if something fails
                var js = new JavaScriptSerializer();
                return js.Serialize(new { error = ex.Message });
            }
        }


        #region Private Methods

        // Adapted for Advisors
        private void LoadAdvisorStatusCounts()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    // Calls NEW Stored Procedure
                    using (SqlCommand cmd = new SqlCommand("sp_GetAdvisorStatusCounts", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            int pendingCount = Convert.ToInt32(reader["PendingCount"]);
                            int approvedCount = Convert.ToInt32(reader["ApprovedCount"]);
                            int rejectedCount = Convert.ToInt32(reader["RejectedCount"]);

                            btnPending.Text = $"Pending ({pendingCount})";
                            btnApproved.Text = $"Approved ({approvedCount})";
                            btnRejected.Text = $"Rejected ({rejectedCount})";
                        }
                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading counts: " + ex.Message, "danger");
            }
        }

        // Copied from your file, no changes needed
        private void SetActiveFilterButton(string activeFilter)
        {
            btnPending.CssClass = "btn-filter";
            btnApproved.CssClass = "btn-filter";
            btnRejected.CssClass = "btn-filter";

            switch (activeFilter)
            {
                case "Pending":
                    btnPending.CssClass = "btn-filter active";
                    break;
                case "Approved":
                    btnApproved.CssClass = "btn-filter active";
                    break;
                case "Rejected":
                    btnRejected.CssClass = "btn-filter active";
                    break;
            }
        }

        // Adapted for Advisors
        // ManageAdvisors.aspx.cs

        private void LoadAdvisors(string searchText, string approvalStatus)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAllAdvisors", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        // CHANGE THIS SECTION - Remove the "%" + searchText + "%" part
                        cmd.Parameters.AddWithValue("@SearchText",
                            string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText);

                        cmd.Parameters.AddWithValue("@ApprovalStatus",
                            string.IsNullOrEmpty(approvalStatus) ? (object)DBNull.Value : approvalStatus);

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        gvAdvisors.DataSource = dt;
                        gvAdvisors.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading advisors: " + ex.Message, "danger");
            }
        }

        // --- DELETED ---
        // The LoadAdvisorForEdit() and LoadAdvisorForApproval() methods
        // are no longer needed, as this logic is now in the [WebMethod]

        // This is the AddAdvisorWithLogin method copied directly from your Dashboard.aspx.cs
        // We call this from btnSaveAdvisor_Click in 'add' mode
        private void AddAdvisorWithLogin(string name, string email, string mobile, string designation,
             string company, string password, bool linkToAdmin, int adminID, string approvalStatus,
             string remarks, int isActive)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                // This SP already exists in your project from the Dashboard
                using (SqlCommand cmd = new SqlCommand("sp_AddAdvisorWithLogin", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                    cmd.Parameters.AddWithValue("@Designation", string.IsNullOrEmpty(designation) ? (object)DBNull.Value : designation);
                    cmd.Parameters.AddWithValue("@Company", string.IsNullOrEmpty(company) ? (object)DBNull.Value : company);
                    cmd.Parameters.AddWithValue("@Password", password); // Password is set here
                    cmd.Parameters.AddWithValue("@LinkedAdminID", linkToAdmin ? (object)adminID : DBNull.Value);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);
                    cmd.Parameters.AddWithValue("@ApprovalStatus", approvalStatus);
                    cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks);
                    cmd.Parameters.AddWithValue("@RegistrationType", "Admin"); // Hardcoded as per your Dashboard logic
                    cmd.Parameters.AddWithValue("@ApprovedBy", adminID);
                    cmd.Parameters.AddWithValue("@ApprovalDate", DateTime.Now);

                    SqlParameter advisorIDParam = new SqlParameter("@AdvisorID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(advisorIDParam);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // Adapted for Advisors
        private void UpdateAdvisor(int advisorId, string name, string email, string mobile, string designation, string company, bool isActive, string newPassword)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                // Calls NEW Stored Procedure
                using (SqlCommand cmd = new SqlCommand("sp_UpdateAdvisor", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@AdvisorID", advisorId);
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                    cmd.Parameters.AddWithValue("@Designation", string.IsNullOrEmpty(designation) ? (object)DBNull.Value : designation);
                    cmd.Parameters.AddWithValue("@Company", string.IsNullOrEmpty(company) ? (object)DBNull.Value : company);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);

                    // --- THIS IS THE NEW PARAMETER ---
                    // If newPassword is blank, pass DBNull. 
                    // The SP will know to ignore it.
                    if (string.IsNullOrEmpty(newPassword))
                    {
                        cmd.Parameters.AddWithValue("@NewPassword", DBNull.Value);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@NewPassword", newPassword);
                    }

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // Adapted for Advisors
        private void UpdateAdvisorApprovalStatus(int advisorId, string approvalStatus, string remarks)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                // Calls NEW Stored Procedure
                using (SqlCommand cmd = new SqlCommand("sp_UpdateAdvisorApprovalStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@AdvisorID", advisorId);
                    cmd.Parameters.AddWithValue("@ApprovalStatus", approvalStatus);
                    cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks);
                    cmd.Parameters.AddWithValue("@ApprovedBy", CurrentAdminID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // Adapted for Advisors
        private void ToggleAdvisorStatus(int advisorId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    // Calls NEW Stored Procedure
                    using (SqlCommand cmd = new SqlCommand("sp_ToggleAdvisorStatus", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AdvisorID", advisorId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowMessage("Advisor status updated successfully!", "success");
                string currentFilter = hdnCurrentFilter.Value;
                LoadAdvisors(txtSearch.Text.Trim(), currentFilter); // Refresh grid
                LoadAdvisorStatusCounts(); // Refresh counts
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating status: " + ex.Message, "danger");
            }
        }

        // Adapted for Advisors
        private void ClearForm()
        {
            txtName.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
            txtDesignation.Text = "";
            txtCompany.Text = "";
            txtPassword.Text = "";
            ddlStatus.SelectedIndex = 0;
            hdnAdvisorID.Value = "0";
            hdnModalMode.Value = "add";
        }

        // Copied from your file, no changes needed
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

        #endregion
    }
}
