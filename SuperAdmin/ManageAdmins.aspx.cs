using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls; // Needed for HtmlInputCheckBox

namespace Expo_Panel.Admin
{
    public partial class ManageAdmins : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // STRICT SECURITY CHECK: Only allow SuperAdmin (IsAdminLoggedIn).
            // Team Admins (IsTeamAdminLoggedIn) will fail this check and be redirected.
            if (Session["IsAdminLoggedIn"] == null)
            {
                Response.Redirect("Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindAdminGrid();
            }
        }

        private void BindAdminGrid()
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                string query = "SELECT AdminID, Username, Role, IsActive, CreatedDate FROM TBL.Admin ORDER BY CreatedDate DESC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        gvAdmins.DataSource = dt;
                        gvAdmins.DataBind();
                        lblTotalAdmins.Text = dt.Rows.Count.ToString();
                    }
                }
            }
        }

        // 1. HANDLE EDIT AND DELETE CLICKS
        protected void gvAdmins_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditAdmin")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = gvAdmins.Rows[rowIndex];

                // Retrieve data
                HiddenField hfId = (HiddenField)row.FindControl("hfRowID");
                HiddenField hfUser = (HiddenField)row.FindControl("hfRowUser");
                HiddenField hfRole = (HiddenField)row.FindControl("hfRowRole");
                HiddenField hfActive = (HiddenField)row.FindControl("hfRowActive");

                // Populate Form
                int adminId = Convert.ToInt32(hfId.Value);
                hfAdminID.Value = hfId.Value;
                txtUsername.Text = hfUser.Value;
                ddlRole.SelectedValue = hfRole.Value;

                // IMPORTANT: Since we switched to HtmlInputCheckBox, we use Checked property same way
                chkIsActive.Checked = Convert.ToBoolean(hfActive.Value);

                // UI Changes
                // FETCH AND POPULATE PASSWORD
                string pwd = GetAdminPassword(adminId);
                txtPassword.Text = pwd;

                // Force the value attribute so it appears in the password field during Edit
                txtPassword.Attributes.Add("value", pwd);

                // Since we are populating the password, we keep validation enabled
                rfvPass.Enabled = true;
                lblPasswordHint.Visible = false; // Hide hint since field is filled

                btnSave.Text = "Update Admin";
                btnCancel.Visible = true;
                formHeader.InnerHtml = "<i class='fas fa-pencil-alt text-primary me-2'></i>Edit Admin";
                pnlMessage.Visible = false;
            }
            else if (e.CommandName == "DeleteAdmin")
            {
                int adminId = Convert.ToInt32(e.CommandArgument);
                DeleteAdmin(adminId);
                BindAdminGrid();

                // If we were editing this user, reset the form
                if (hfAdminID.Value == adminId.ToString())
                {
                    ResetForm();
                }
            }
        }

        // Helper to fetch password from DB
        private string GetAdminPassword(int adminId)
        {
            string pwd = "";
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string query = "SELECT Password FROM TBL.Admin WHERE AdminID = @AdminID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@AdminID", adminId);
                        con.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            pwd = result.ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error fetching password: " + ex.Message);
            }
            return pwd;
        }

        private void DeleteAdmin(int adminId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("TBL.sp_DeleteAdmin", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AdminID", adminId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                ShowMessage("Admin deleted successfully.", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting admin: " + ex.Message, "danger");
            }
        }

        // 2. HANDLE SAVE
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int adminId = Convert.ToInt32(hfAdminID.Value);
            bool isUpdate = adminId > 0;

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string role = ddlRole.SelectedValue;
            bool isActive = chkIsActive.Checked;

            if (!isUpdate && string.IsNullOrEmpty(password))
            {
                ShowMessage("Password is required for new accounts.", "danger");
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string spName = isUpdate ? "TBL.sp_UpdateAdmin" : "TBL.sp_AddAdmin";

                    using (SqlCommand cmd = new SqlCommand(spName, con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        if (isUpdate)
                        {
                            cmd.Parameters.AddWithValue("@AdminID", adminId);
                            cmd.Parameters.AddWithValue("@Username", username);
                            cmd.Parameters.AddWithValue("@Role", role);
                            cmd.Parameters.AddWithValue("@IsActive", isActive);

                            if (string.IsNullOrEmpty(password))
                                cmd.Parameters.AddWithValue("@Password", DBNull.Value);
                            else
                                cmd.Parameters.AddWithValue("@Password", password);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@Username", username);
                            cmd.Parameters.AddWithValue("@Password", password);
                            cmd.Parameters.AddWithValue("@Role", role);
                            cmd.Parameters.AddWithValue("@IsActive", isActive);
                        }

                        con.Open();
                        object result = cmd.ExecuteScalar();
                        int resultCode = Convert.ToInt32(result);

                        if (resultCode == 1)
                        {
                            // 1. Clear form FIRST (so we don't clear the message we are about to show)
                            ResetForm();

                            // 2. Refresh Grid
                            BindAdminGrid();

                            // 3. Show Message LAST
                            string msg = isUpdate
                                ? $"Admin '{username}' updated successfully."
                                : $"Admin '{username}' added successfully.";

                            ShowMessage(msg, "success");
                        }
                        else if (resultCode == -1)
                        {
                            ShowMessage("Username already exists. Please choose another.", "danger");
                        }
                        else
                        {
                            ShowMessage("An unknown error occurred.", "warning");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
            }
        }

        // 3. CANCEL EDIT
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx");
        }

        private void ResetForm()
        {
            hfAdminID.Value = "0";
            txtUsername.Text = string.Empty;

            // Clear text AND Remove the 'value' attribute
            txtPassword.Text = string.Empty;
            txtPassword.Attributes.Remove("value");

            ddlRole.SelectedValue = "Admin";
            chkIsActive.Checked = true;

            btnSave.Text = "Create Account";
            btnCancel.Visible = false;
            rfvPass.Enabled = true;
            lblPasswordHint.Visible = false;
            formHeader.InnerHtml = "<i class='fas fa-user-plus text-warning me-2'></i>Add New Admin";

            // This hides the message panel, which is why we must call ShowMessage AFTER ResetForm in btnSave_Click
            pnlMessage.Visible = false;
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            pnlMessage.CssClass = $"alert alert-{type} rounded-3 shadow-sm";
            pnlMessage.Visible = true;
        }
    }
}