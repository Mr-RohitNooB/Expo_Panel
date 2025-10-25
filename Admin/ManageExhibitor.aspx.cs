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

        private int CurrentAdminID
        {
            get
            {
                if (Session["AdminID"] != null)
                    return Convert.ToInt32(Session["AdminID"]);
                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["IsAuthenticated"] == null || !(bool)Session["IsAuthenticated"])
            {
                Response.Redirect("Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
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

                LoadStatusCounts();
                LoadExhibitors(txtSearch.Text.Trim(), "Pending");
                SetActiveFilterButton("Pending");
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
            Response.Redirect("Default.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchText = txtSearch.Text.Trim();
            string currentFilter = hdnCurrentFilter.Value;

            LoadExhibitors(searchText, currentFilter);

            if (!string.IsNullOrEmpty(searchText))
            {
                ShowMessage($"Search results for '{searchText}' in {currentFilter} records", "info");
            }
        }

        protected void btnStatusFilter_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string filterStatus = btn.CommandArgument;

            hdnCurrentFilter.Value = filterStatus;

            LoadExhibitors(txtSearch.Text.Trim(), filterStatus);
            LoadStatusCounts();
            SetActiveFilterButton(filterStatus);
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
            else if (e.CommandName == "ApprovalAction")
            {
                LoadExhibitorForApproval(exhibitorId);
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

                ClearForm();
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
                ClearForm();
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
                ClearForm();
            }
        }

        protected void btnSaveApproval_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int exhibitorId = Convert.ToInt32(hdnApprovalExhibitorID.Value);
                string approvalStatus = ddlApprovalStatus.SelectedValue;
                string remarks = txtApprovalRemarks.Text.Trim();

                if (approvalStatus == "Rejected" && string.IsNullOrEmpty(remarks))
                {
                    ShowMessage("Remarks are required when rejecting an exhibitor.", "danger");
                    return;
                }

                UpdateApprovalStatus(exhibitorId, approvalStatus, remarks);

                Session["FlashMessage"] = $"Exhibitor {approvalStatus.ToLower()} successfully!";

                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating approval status: " + ex.Message, "danger");
            }
        }

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

        protected void gvExhibitors_RowDataBound(object sender, GridViewRowEventArgs e)
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

        private void LoadStatusCounts()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetExhibitorStatusCounts", con))
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

        private void LoadExhibitors(string searchText, string approvalStatus)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAllExhibitors", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SearchText", string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText);
                        cmd.Parameters.AddWithValue("@ApprovalStatus", string.IsNullOrEmpty(approvalStatus) ? (object)DBNull.Value : approvalStatus);

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

                            name = name.Replace("'", "\\'");
                            email = email.Replace("'", "\\'");
                            mobile = mobile.Replace("'", "\\'");
                            designation = designation.Replace("'", "\\'");
                            company = company.Replace("'", "\\'");

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

        private void LoadExhibitorForApproval(int exhibitorId)
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
                            hdnApprovalExhibitorID.Value = exhibitorId.ToString();

                            string name = reader["Name"].ToString();
                            string email = reader["Email"].ToString();
                            string regType = reader["RegistrationType"].ToString();
                            string designation = reader["Designation"].ToString();
                            string company = reader["Company"].ToString();
                            string approvalStatus = reader["ApprovalStatus"].ToString();
                            string remarks = reader["Remarks"].ToString();

                            name = name.Replace("'", "\\'");
                            email = email.Replace("'", "\\'");
                            regType = regType.Replace("'", "\\'");
                            designation = designation.Replace("'", "\\'");
                            company = company.Replace("'", "\\'");
                            remarks = remarks.Replace("'", "\\'");

                            string script = $"openApprovalModal({exhibitorId}, '{name}', '{email}', '{regType}', '{designation}', '{company}', '{approvalStatus}', '{remarks}');";
                            ScriptManager.RegisterStartupScript(this, GetType(), "openApprovalModal", script, true);
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading exhibitor for approval: " + ex.Message, "danger");
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

                    SqlParameter outParam = new SqlParameter("@ExhibitorID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
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
                string currentFilter = hdnCurrentFilter.Value;
                LoadExhibitors(txtSearch.Text.Trim(), currentFilter);
                LoadStatusCounts();
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating status: " + ex.Message, "danger");
            }
        }

        private void UpdateApprovalStatus(int exhibitorId, string approvalStatus, string remarks)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateExhibitorApprovalStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
                    cmd.Parameters.AddWithValue("@ApprovalStatus", approvalStatus);
                    cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks);
                    cmd.Parameters.AddWithValue("@ApprovedBy", CurrentAdminID);

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
            ddlStatus.SelectedIndex = 0;
            hdnExhibitorID.Value = "0";
            hdnModalMode.Value = "add";
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "success" ? "alert-success" : type == "info" ? "alert-info" : "alert-danger";
            string icon = type == "success" ? "fa-check-circle" : type == "info" ? "fa-info-circle" : "fa-exclamation-circle";

            litMessage.Text = $@"
        <div class='alert {cssClass}'>
            <i class='fas {icon}'></i>
            {message}
        </div>";
        }
    }
}