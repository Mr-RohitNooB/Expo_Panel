using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Expo_Panel.Admin
{
    public partial class ManageAdmins : System.Web.UI.Page
    {
        // Get Connection String from Web.config
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Security Check: Ensure user is logged in
            if (Session["IsTeamAdminLoggedIn"] == null && Session["IsAdminLoggedIn"] == null)
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
                // Simple query to fetch all admins for the list
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

        protected void btnAddAdmin_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string username = txtUsername.Text.Trim();
                string password = txtPassword.Text.Trim();
                string role = ddlRole.SelectedValue;
                bool isActive = chkIsActive.Checked;

                try
                {
                    using (SqlConnection con = new SqlConnection(ConnectionString))
                    {
                        // Call the Stored Procedure we created
                        using (SqlCommand cmd = new SqlCommand("TBL.sp_AddAdmin", con))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;

                            cmd.Parameters.AddWithValue("@Username", username);
                            cmd.Parameters.AddWithValue("@Password", password); // Note: hashing recommended in production
                            cmd.Parameters.AddWithValue("@Role", role);
                            cmd.Parameters.AddWithValue("@IsActive", isActive);

                            con.Open();
                            // We expect a ResultCode back (1 for success, -1 for duplicate)
                            object result = cmd.ExecuteScalar();
                            int resultCode = Convert.ToInt32(result);

                            if (resultCode == 1)
                            {
                                ShowMessage("Admin account created successfully!", "success");
                                ClearForm();
                                BindAdminGrid(); // Refresh the list
                            }
                            else if (resultCode == -1)
                            {
                                ShowMessage("Username already exists. Please choose another.", "danger");
                            }
                            else
                            {
                                ShowMessage("Unknown error occurred.", "warning");
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error: " + ex.Message, "danger");
                }
            }
        }

        private void ClearForm()
        {
            txtUsername.Text = string.Empty;
            txtPassword.Text = string.Empty;
            ddlRole.SelectedValue = "Admin";
            chkIsActive.Checked = true;
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            // Bootstrap alert classes: alert-success, alert-danger
            pnlMessage.CssClass = $"alert alert-{type}";
            pnlMessage.Visible = true;
        }
    }
}