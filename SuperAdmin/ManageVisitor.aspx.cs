using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;
using System.Diagnostics; // For Debug

namespace Expo_Panel.SuperAdmin
{
    public partial class ManageVisitor : System.Web.UI.Page
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
            // 1. Session & Auth Check (From Dashboard.aspx.cs)
            if (!IsAdminLoggedIn())
            {
                // Assuming Default.aspx is in the same folder or root login
                Response.Redirect("Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            string role = Session["Role"] != null ? Session["Role"].ToString() : "Admin";

            if (role != "SuperAdmin")
            {
                // Send them to the TEAM Dashboard instead if they try to access this page
                Response.Redirect("~/Admin/Dashboard.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                // 2. Set User Info in Header
                SetUserLabelsFromSession();

                // 3. Load Data
                LoadStatusCounts();
                LoadVisitors("Pending"); // Default filter
            }

            // Handle Flash Messages (Toast)
            if (Session["FlashMessage"] != null)
            {
                litMessage.Text = Session["FlashMessage"].ToString();
                Session.Remove("FlashMessage");
            }
        }

        #region Session / UI helpers

        private bool IsAdminLoggedIn()
        {
            if (Session == null) return false;
            var s = Session["IsAdminLoggedIn"];
            if (s == null) return false;
            if (s is bool b) return b;
            bool parsed;
            return bool.TryParse(s.ToString(), out parsed) && parsed;
        }

        private void SetUserLabelsFromSession()
        {
            string username = Session["AdminUsername"]?.ToString() ?? "Administrator";
            try
            {
                // Update labels if they exist in the Master Page or current page
                if (lblUsername != null) lblUsername.Text = username;
                if (lblUserInitial != null) lblUserInitial.Text = !string.IsNullOrEmpty(username) ? username.Substring(0, 1).ToUpper() : "A";
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"SetUserLabelsFromSession Exception: {ex.Message}");
            }
        }

        #endregion

        #region Loading Data
        private void LoadStatusCounts()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetVisitorStatusCounts", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        con.Open();
                        SqlDataReader r = cmd.ExecuteReader();
                        if (r.Read())
                        {
                            btnPending.Text = $"Pending ({r["PendingCount"]})";
                            btnApproved.Text = $"Approved ({r["ApprovedCount"]})";
                            btnRejected.Text = $"Rejected ({r["RejectedCount"]})";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowToast("Error loading counts: " + ex.Message, "danger");
            }
        }

        private void LoadVisitors(string status)
        {
            try
            {
                string search = txtSearch.Text.Trim();
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAllVisitors", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        if (!string.IsNullOrEmpty(search)) cmd.Parameters.AddWithValue("@SearchText", search);
                        if (!string.IsNullOrEmpty(status)) cmd.Parameters.AddWithValue("@ApprovalStatus", status);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvVisitors.DataSource = dt;
                        gvVisitors.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowToast("Error loading visitors: " + ex.Message, "danger");
            }
        }
        #endregion

        #region Filters & Search
        protected void btnStatusFilter_Click(object sender, EventArgs e)
        {
            Button clicked = (Button)sender;
            hdnCurrentFilter.Value = clicked.CommandArgument;

            btnPending.CssClass = "btn-filter";
            btnApproved.CssClass = "btn-filter";
            btnRejected.CssClass = "btn-filter";
            clicked.CssClass = "btn-filter active";

            LoadVisitors(clicked.CommandArgument);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadVisitors(hdnCurrentFilter.Value);
        }
        #endregion

        #region Grid Commands
        protected void gvVisitors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int visitorId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditVisitor")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "edit", $"triggerEdit({visitorId});", true);
            }
            else if (e.CommandName == "ApproveVisitor")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "approve", $"triggerApprove({visitorId});", true);
            }
        }

        protected void btnToggleTrigger_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(hdnToggleID.Value);
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_ToggleVisitorStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VisitorID", id);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            ShowToast("Status updated.", "success");
            LoadVisitors(hdnCurrentFilter.Value);
        }
        #endregion

        #region Edit Logic
        protected void btnLoadEdit_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(hdnEditID.Value);
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetVisitorById", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VisitorID", id);
                    con.Open();
                    SqlDataReader r = cmd.ExecuteReader();
                    if (r.Read())
                    {
                        ddlEditTicket.SelectedValue = r["TicketType"].ToString();
                        txtEditName.Text = r["FullName"].ToString();
                        txtEditJob.Text = r["JobTitle"].ToString();
                        txtEditCompany.Text = r["CompanyName"].ToString();
                        txtEditEmail.Text = r["Email"].ToString();
                        txtEditMobile.Text = r["Mobile"].ToString();
                        txtEditAddress.Text = r["Address"].ToString();
                        txtEditCity.Text = r["City"].ToString();
                        txtEditState.Text = r["State"].ToString();
                        txtEditCountry.Text = r["Country"].ToString();
                        txtEditPin.Text = r["PinCode"].ToString();

                        string nature = r["NatureOfBusiness"].ToString();
                        if (ddlEditNature.Items.FindByValue(nature) != null)
                            ddlEditNature.SelectedValue = nature;

                        PopulateCheckBoxes(chkEditPurpose, r["PurposeOfVisit"].ToString());
                        PopulateCheckBoxes(chkEditProducts, r["ProductInterest"].ToString());

                        ScriptManager.RegisterStartupScript(this, GetType(), "showEdit", "showModal('editModal');", true);
                    }
                }
            }
        }

        private void PopulateCheckBoxes(CheckBoxList cbl, string dbValue)
        {
            cbl.ClearSelection();
            if (string.IsNullOrEmpty(dbValue)) return;
            string[] items = dbValue.Split(',');
            foreach (string item in items)
            {
                ListItem li = cbl.Items.FindByValue(item.Trim());
                if (li != null) li.Selected = true;
            }
        }

        protected void btnSaveEdit_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(hdnEditID.Value);
            string purpose = string.Join(",", chkEditPurpose.Items.Cast<ListItem>().Where(i => i.Selected).Select(i => i.Value));
            string products = string.Join(",", chkEditProducts.Items.Cast<ListItem>().Where(i => i.Selected).Select(i => i.Value));

            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateVisitor", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VisitorID", id);
                    cmd.Parameters.AddWithValue("@TicketType", ddlEditTicket.SelectedValue);
                    cmd.Parameters.AddWithValue("@FullName", txtEditName.Text);
                    cmd.Parameters.AddWithValue("@JobTitle", txtEditJob.Text);
                    cmd.Parameters.AddWithValue("@CompanyName", txtEditCompany.Text);
                    cmd.Parameters.AddWithValue("@Email", txtEditEmail.Text);
                    cmd.Parameters.AddWithValue("@Mobile", txtEditMobile.Text);
                    cmd.Parameters.AddWithValue("@City", txtEditCity.Text);
                    cmd.Parameters.AddWithValue("@State", txtEditState.Text);
                    cmd.Parameters.AddWithValue("@Country", txtEditCountry.Text);
                    cmd.Parameters.AddWithValue("@PinCode", txtEditPin.Text);
                    cmd.Parameters.AddWithValue("@NatureOfBusiness", ddlEditNature.SelectedValue);
                    cmd.Parameters.AddWithValue("@PurposeOfVisit", purpose);
                    cmd.Parameters.AddWithValue("@ProductInterest", products);
                    cmd.Parameters.AddWithValue("@IsActive", 1);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            ShowToast("Visitor details updated.", "success");
            LoadVisitors(hdnCurrentFilter.Value);
        }
        #endregion

        #region Approval Logic (With Auto Password Generation)
        protected void btnLoadApprove_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(hdnApproveID.Value);
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetVisitorById", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VisitorID", id);
                    con.Open();
                    SqlDataReader r = cmd.ExecuteReader();
                    if (r.Read())
                    {
                        txtApproveName.Text = r["FullName"].ToString();
                        txtApproveCompany.Text = r["CompanyName"].ToString();

                        string status = r["ApprovalStatus"].ToString();
                        if (string.IsNullOrEmpty(status)) status = "Pending";
                        ddlApproveStatus.SelectedValue = status;

                        txtApproveRemarks.Text = r["Remarks"].ToString();

                        ScriptManager.RegisterStartupScript(this, GetType(), "showApprove", "showModal('approveModal');", true);
                    }
                }
            }
        }

        protected void btnSaveApproval_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(hdnApproveID.Value);
            string status = ddlApproveStatus.SelectedValue;
            string remarks = txtApproveRemarks.Text.Trim();

            if (status == "Rejected" && string.IsNullOrEmpty(remarks))
            {
                ShowToast("Remarks are required for rejection.", "danger");
                ScriptManager.RegisterStartupScript(this, GetType(), "reopenApprove", "showModal('approveModal');", true);
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string password = null;
                    string email = "";

                    // LOGIC: If Approved, check if password exists or generate new one
                    if (status == "Approved")
                    {
                        string checkQuery = "SELECT Password, Email FROM TBL.Visitor WHERE VisitorID = @VisitorID";
                        using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                        {
                            checkCmd.Parameters.AddWithValue("@VisitorID", id);
                            con.Open();
                            SqlDataReader r = checkCmd.ExecuteReader();
                            if (r.Read())
                            {
                                object dbPass = r["Password"];
                                email = r["Email"].ToString();

                                if (dbPass == null || dbPass == DBNull.Value || string.IsNullOrEmpty(dbPass.ToString()))
                                {
                                    password = GeneratePassword(8); // Generate
                                }
                                else
                                {
                                    password = dbPass.ToString(); // Keep existing
                                }
                            }
                            r.Close();
                        }
                    }

                    // Update
                    using (SqlCommand cmd = new SqlCommand("sp_UpdateVisitorApprovalStatus", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@VisitorID", id);
                        cmd.Parameters.AddWithValue("@ApprovalStatus", status);
                        cmd.Parameters.AddWithValue("@Remarks", remarks);
                        cmd.Parameters.AddWithValue("@ApprovedBy", CurrentAdminID);
                        cmd.Parameters.AddWithValue("@Password", string.IsNullOrEmpty(password) ? (object)DBNull.Value : password);

                        if (con.State != ConnectionState.Open) con.Open();
                        cmd.ExecuteNonQuery();
                    }

                    // Success Message
                    if (status == "Approved")
                    {
                        // Show password in toast for Admin to copy/send
                        Session["FlashMessage"] = $@"
                        <div style='background: #d1fae5; border-left: 4px solid #10b981; padding: 12px 16px; margin: 15px 0; border-radius: 4px;'>
                            <strong style='color: #065f46;'>Visitor Approved!</strong><br>
                            <span style='color: #374151;'>Login: <strong>{email}</strong></span><br>
                            <span style='color: #374151;'>Password: <strong style='background: #fef3c7; color: #92400e; padding: 2px 6px; border-radius: 3px;'>{password}</strong></span>
                        </div>";
                    }
                    else
                    {
                        Session["FlashMessage"] = $"<div style='padding:10px; margin-bottom:10px; background:#d1fae5; border-radius:5px;'>Visitor {status} successfully.</div>";
                    }
                }

                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowToast("Error: " + ex.Message, "danger");
            }
        }

        private string GeneratePassword(int length = 8)
        {
            const string validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@#$";
            Random random = new Random();
            char[] chars = new char[length];
            for (int i = 0; i < length; i++) chars[i] = validChars[random.Next(validChars.Length)];
            return new string(chars);
        }
        #endregion

        private void ShowToast(string msg, string type)
        {
            string color = type == "success" ? "#d1fae5" : "#fee2e2";
            litMessage.Text = $"<div style='padding:10px; margin-bottom:10px; background:{color}; border-radius:5px;'>{msg}</div>";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx");
        }
    }
}