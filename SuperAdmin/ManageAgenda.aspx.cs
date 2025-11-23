using System.Web;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Expo_Panel.Admin
{
    public partial class AgendaDashboard : System.Web.UI.Page
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
                LoadAgendas(txtSearch.Text.Trim(), "Pending");
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

            LoadAgendas(searchText, currentFilter);

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

            LoadAgendas(txtSearch.Text.Trim(), filterStatus);
            LoadStatusCounts();
            SetActiveFilterButton(filterStatus);
        }

        protected void gvAgenda_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int agendaId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditAgenda")
            {
                LoadAgendaForEdit(agendaId);
            }
            else if (e.CommandName == "QuickToggle")
            {
                ToggleAgendaStatus(agendaId);
            }
            else if (e.CommandName == "ApprovalAction")
            {
                LoadAgendaForApproval(agendaId);
            }
        }

        protected void gvAgenda_RowDataBound(object sender, GridViewRowEventArgs e)
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

        protected void btnSaveAgenda_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int agendaId = Convert.ToInt32(hdnAgendaID.Value);
                string mode = hdnModalMode.Value;
                string day = ddlDay.SelectedValue;
                string track = ddlStream.SelectedValue;
                string time = txtTime.Text.Trim();
                string title = txtTitle.Text.Trim();
                string brief = txtBrief.Text.Trim();
                string synopsis = txtSynopsis.Text.Trim();
                bool isActive = ddlStatus.SelectedValue == "1";

                if (mode == "add")
                {
                    AddAgenda(day, track, time, title, brief, synopsis, isActive);
                    Session["FlashMessage"] = "Agenda item added successfully!";
                }
                else if (mode == "edit")
                {
                    UpdateAgenda(agendaId, day, track, time, title, brief, synopsis, isActive);
                    Session["FlashMessage"] = "Agenda item updated successfully!";
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

        protected void btnSaveApproval_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int agendaId = Convert.ToInt32(hdnApprovalAgendaID.Value);
                string approvalStatus = ddlApprovalStatus.SelectedValue;
                string remarks = txtApprovalRemarks.Text.Trim();

                if (approvalStatus == "Rejected" && string.IsNullOrEmpty(remarks))
                {
                    ShowMessage("Remarks are required when rejecting an agenda item.", "danger");
                    return;
                }

                UpdateApprovalStatus(agendaId, approvalStatus, remarks);

                Session["FlashMessage"] = $"Agenda item {approvalStatus.ToLower()} successfully!";

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

        #region Private Methods

        private void LoadStatusCounts()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAgendaStatusCounts", con))
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

        private void LoadAgendas(string searchText, string approvalStatus)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAllAgendas", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SearchText", string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText);
                        cmd.Parameters.AddWithValue("@ApprovalStatus", string.IsNullOrEmpty(approvalStatus) ? (object)DBNull.Value : approvalStatus);

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        gvAgenda.DataSource = dt;
                        gvAgenda.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading agenda items: " + ex.Message, "danger");
            }
        }

        private void LoadAgendaForEdit(int agendaId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAgendaById", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AgendaID", agendaId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            hdnAgendaID.Value = agendaId.ToString();
                            hdnModalMode.Value = "edit";

                            // 1. Get the raw string values without any replacing
                            string day = reader["Day"].ToString();
                            string track = reader["Track"].ToString();
                            string time = reader["Time"].ToString();
                            string title = reader["Title"].ToString();
                            string brief = reader["Brief"].ToString();
                            string synopsis = reader["Synopsis"].ToString();
                            bool isActive = Convert.ToBoolean(reader["IS_ACTIVE"]);

                            // 2. Build the script string using HttpUtility.JavaScriptStringEncode
                            string script = $"openModal('edit', {agendaId}, " +
                                            $"'{HttpUtility.JavaScriptStringEncode(day)}', " +
                                            $"'{HttpUtility.JavaScriptStringEncode(track)}', " +
                                            $"'{HttpUtility.JavaScriptStringEncode(time)}', " +
                                            $"'{HttpUtility.JavaScriptStringEncode(title)}', " +
                                            $"'{HttpUtility.JavaScriptStringEncode(brief)}', " +
                                            $"'{HttpUtility.JavaScriptStringEncode(synopsis)}', " +
                                            $"'{(isActive ? "1" : "0")}');";

                            ScriptManager.RegisterStartupScript(this, GetType(), "openEditModal", script, true);
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading agenda item: " + ex.Message, "danger");
            }
        }

        private void LoadAgendaForApproval(int agendaId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAgendaById", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AgendaID", agendaId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            hdnApprovalAgendaID.Value = agendaId.ToString();

                            // 1. Get the raw string values without any replacing
                            string day = reader["Day"].ToString();
                            string track = reader["Track"].ToString();
                            string time = reader["Time"].ToString();
                            string title = reader["Title"].ToString();
                            string brief = reader["Brief"].ToString();
                            string regType = reader["RegistrationType"].ToString();
                            string approvalStatus = reader["ApprovalStatus"].ToString();
                            string remarks = reader["Remarks"].ToString();

                            // 2. Build the script string using HttpUtility.JavaScriptStringEncode
                            string script = $"openApprovalModal({agendaId}, " +
                                            $"'{HttpUtility.JavaScriptStringEncode(day)}', " +
                                            $"'{HttpUtility.JavaScriptStringEncode(track)}', " +
                                            $"'{HttpUtility.JavaScriptStringEncode(time)}', " +
                                            $"'{HttpUtility.JavaScriptStringEncode(title)}', " +
                                            $"'{HttpUtility.JavaScriptStringEncode(brief)}', " +
                                            $"'{HttpUtility.JavaScriptStringEncode(regType)}', " +
                                            $"'{HttpUtility.JavaScriptStringEncode(approvalStatus)}', " +
                                            $"'{HttpUtility.JavaScriptStringEncode(remarks)}');";

                            ScriptManager.RegisterStartupScript(this, GetType(), "openApprovalModal", script, true);
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading agenda for approval: " + ex.Message, "danger");
            }
        }

        private void AddAgenda(string day, string track, string time, string title, string brief, string synopsis, bool isActive)
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

                    SqlParameter outParam = new SqlParameter("@AgendaID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outParam);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateAgenda(int agendaId, string day, string track, string time, string title, string brief, string synopsis, bool isActive)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateAgenda", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@AgendaID", agendaId);
                    cmd.Parameters.AddWithValue("@Day", day);
                    cmd.Parameters.AddWithValue("@Track", track);
                    cmd.Parameters.AddWithValue("@Time", time);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Brief", string.IsNullOrEmpty(brief) ? (object)DBNull.Value : brief);
                    cmd.Parameters.AddWithValue("@Synopsis", string.IsNullOrEmpty(synopsis) ? (object)DBNull.Value : synopsis);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateApprovalStatus(int agendaId, string approvalStatus, string remarks)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateAgendaApprovalStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@AgendaID", agendaId);
                    cmd.Parameters.AddWithValue("@ApprovalStatus", approvalStatus);
                    cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks);
                    cmd.Parameters.AddWithValue("@ApprovedBy", CurrentAdminID);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void ToggleAgendaStatus(int agendaId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_ToggleAgendaStatus", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AgendaID", agendaId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowMessage("Agenda status updated successfully!", "success");
                string currentFilter = hdnCurrentFilter.Value;
                LoadAgendas(txtSearch.Text.Trim(), currentFilter);
                LoadStatusCounts();
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating status: " + ex.Message, "danger");
            }
        }

        private void ClearForm()
        {
            ddlDay.ClearSelection();
            ddlStream.ClearSelection();
            txtTime.Text = "";
            txtTitle.Text = "";
            txtBrief.Text = "";
            txtSynopsis.Text = "";
            ddlStatus.SelectedIndex = 0;
            hdnAgendaID.Value = "0";
            hdnModalMode.Value = "add";
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

        #endregion
    }
}