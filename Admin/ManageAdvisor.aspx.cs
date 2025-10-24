using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Expo_Panel.Admin
{
    public partial class AdvisoryDashboard : System.Web.UI.Page
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

                // Load all advisors initially
                LoadAdvisors("");
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
            LoadAdvisors(searchText);

            if (!string.IsNullOrEmpty(searchText))
            {
                ShowMessage($"Search results for '{searchText}'", "info");
            }
        }

        protected void gvAdvisors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int advisorId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditAdvisor")
            {
                LoadAdvisorForEdit(advisorId);
            }
            else if (e.CommandName == "ToggleStatus")
            {
                ToggleAdvisorStatus(advisorId);
            }
            else if (e.CommandName == "QuickToggle")
            {
                ToggleAdvisorStatus(advisorId);
            }
        }

        protected void btnSaveAdvisor_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int advisorId = Convert.ToInt32(hdnAdvisorID.Value);
                string mode = hdnModalMode.Value;
                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                bool isActive = ddlStatus.SelectedValue == "1";

                if (mode == "add")
                {
                    AddAdvisor(name, email, mobile, isActive);
                    Session["FlashMessage"] = "Advisor added successfully!";
                }
                else if (mode == "edit")
                {
                    UpdateAdvisor(advisorId, name, email, mobile, isActive);
                    Session["FlashMessage"] = "Advisor updated successfully!";
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
                    ShowMessage("This email address is already registered in Advisors. Please use a different email.", "danger");
                }
                else
                {
                    ShowMessage("Database Error: " + errorMsg, "danger");
                }

                // Keep modal open on error
                string escapedName = txtName.Text.Replace("'", "\\'");
                string escapedEmail = txtEmail.Text.Replace("'", "\\'");
                string escapedMobile = txtMobile.Text.Replace("'", "\\'");

                ScriptManager.RegisterStartupScript(this, GetType(), "keepModalOpen",
                    $"setTimeout(function(){{ openModal('{hdnModalMode.Value}', " +
                    $"'{hdnAdvisorID.Value}', " +
                    $"'{escapedName}', " +
                    $"'{escapedEmail}', " +
                    $"'{escapedMobile}', " +
                    $"'{ddlStatus.SelectedValue}'); }}, 100);", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");

                string escapedName = txtName.Text.Replace("'", "\\'");
                string escapedEmail = txtEmail.Text.Replace("'", "\\'");
                string escapedMobile = txtMobile.Text.Replace("'", "\\'");

                ScriptManager.RegisterStartupScript(this, GetType(), "keepModalOpen",
                    $"setTimeout(function(){{ openModal('{hdnModalMode.Value}', " +
                    $"'{hdnAdvisorID.Value}', " +
                    $"'{escapedName}', " +
                    $"'{escapedEmail}', " +
                    $"'{escapedMobile}', " +
                    $"'{ddlStatus.SelectedValue}'); }}, 100);", true);
            }
        }


        private void LoadAdvisors(string searchText)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAllAdvisors", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SearchText", string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText);

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

        private void LoadAdvisorForEdit(int advisorId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAdvisorByID", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AdvisorID", advisorId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            hdnAdvisorID.Value = advisorId.ToString();
                            hdnModalMode.Value = "edit";

                            string name = reader["Name"].ToString();
                            string email = reader["Email"].ToString();
                            string mobile = reader["Mobile"].ToString();
                            bool isActive = Convert.ToBoolean(reader["IS_ACTIVE"]);

                            // Register script to open modal with data
                            string script = $"openModal('edit', {advisorId}, '{name}', '{email}', '{mobile}', '{(isActive ? "1" : "0")}');";
                            ScriptManager.RegisterStartupScript(this, GetType(), "openEditModal", script, true);
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading advisor: " + ex.Message, "danger");
            }
        }

        private void AddAdvisor(string name, string email, string mobile, bool isActive)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_AddAdvisor", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);

                    SqlParameter outParam = new SqlParameter("@AdvisorID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outParam);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            // Don't show message here - it will be shown after redirect
        }


        private void UpdateAdvisor(int advisorId, string name, string email, string mobile, bool isActive)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateAdvisor", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@AdvisorID", advisorId);
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            // Don't show message here - it will be shown after redirect
        }





        private void ToggleAdvisorStatus(int advisorId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_ToggleAdvisorStatus", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AdvisorID", advisorId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowMessage("Advisor status updated successfully!", "success");
                LoadAdvisors(txtSearch.Text.Trim());
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating status: " + ex.Message, "danger");
            }
        }
        protected void gvAdvisors_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                try
                {
                    // Get the data item bound to this row
                    // We use DataRowView because we are binding to a DataTable
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
                    // Handle any potential errors (e.g., column not found)
                    ShowMessage("Error during row binding: " + ex.Message, "danger");
                }
            }
        }
        private void ClearForm()
        {
            txtName.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
            ddlStatus.SelectedIndex = 0;
            hdnAdvisorID.Value = "0";
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