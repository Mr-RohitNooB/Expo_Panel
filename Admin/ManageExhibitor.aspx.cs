using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Expo_Panel.Admin
{
    public partial class ManageExhibitor : System.Web.UI.Page
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
                }
                else
                {
                    lblUsername.Text = "Unknown";
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
            else if (e.CommandName == "QuickToggle")
            {
                ToggleExhibitorStatus(exhibitorId);
            }
            else if (e.CommandName == "ApprovalAction")
            {
                LoadExhibitorForApproval(exhibitorId);
            }
            else if (e.CommandName == "ViewProfile")
            {
                LoadPostApprovalProfile(exhibitorId);
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

        protected void btnSaveExhibitor_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int exhibitorId = Convert.ToInt32(hdnExhibitorID.Value);
                string mode = hdnExhibitorModalMode.Value;

                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                string designation = txtDesignation.Text.Trim();
                string company = txtCompany.Text.Trim();
                string headOffice = txtHeadOffice.Text.Trim();
                string city = txtCity.Text.Trim();
                string state = txtState.Text.Trim();
                string country = txtCountry.Text.Trim();
                string gstNumber = txtGSTNumber.Text.Trim();
                string billingAddress = txtBillingAddress.Text.Trim();

                string boothType = string.Empty;
                if (rbShellScheme.Checked) boothType = "Shell Scheme";
                else if (rbRawSpace.Checked) boothType = "Raw Space";

                decimal? areaInSqm = null;
                if (!string.IsNullOrEmpty(txtAreaInSqm.Text.Trim()))
                {
                    areaInSqm = Convert.ToDecimal(txtAreaInSqm.Text.Trim());
                }

                bool conference = chkConference.Checked;
                bool sponsorship = chkSponsorship.Checked;
                bool advertising = chkAdvertising.Checked;
                bool customPackage = chkCustomPackage.Checked;
                bool isActive = ddlStatus.SelectedValue == "1";
                string registrationType = ddlRegistrationType.SelectedValue;

                if (mode == "add")
                {
                    AddExhibitor(name, email, mobile, designation, company, headOffice, city, state, country,
                        gstNumber, billingAddress, boothType, areaInSqm, conference, sponsorship, advertising,
                        customPackage, isActive, registrationType);
                    Session["FlashMessage"] = "Exhibitor added successfully!";
                }
                else if (mode == "edit")
                {
                    UpdateExhibitor(exhibitorId, name, email, mobile, designation, company, headOffice, city, state,
                        country, gstNumber, billingAddress, boothType, areaInSqm, conference, sponsorship,
                        advertising, customPackage, isActive);
                    Session["FlashMessage"] = "Exhibitor updated successfully!";
                }

                ClearExhibitorForm();
                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Message.Contains("Email already exists"))
                {
                    ShowMessage("This email address is already registered.", "danger");
                }
                else
                {
                    ShowMessage("Database Error: " + sqlEx.Message, "danger");
                }
                ClearExhibitorForm();
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "danger");
                ClearExhibitorForm();
            }
        }

        protected void btnTriggerEdit_Click(object sender, EventArgs e)
        {
            try
            {
                int exhibitorId = Convert.ToInt32(hdnEditExhibitorID.Value);
                LoadExhibitorForEdit(exhibitorId);
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading exhibitor for edit: " + ex.Message, "danger");
            }
        }

        protected void btnTriggerApproval_Click(object sender, EventArgs e)
        {
            try
            {
                int exhibitorId = Convert.ToInt32(hdnApproveExhibitorID.Value);
                LoadExhibitorForApproval(exhibitorId);
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading exhibitor for approval: " + ex.Message, "danger");
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
                string password = txtPassword.Text.Trim();

                if (approvalStatus == "Rejected" && string.IsNullOrEmpty(remarks))
                {
                    ShowMessage("Remarks are required when rejecting an exhibitor.", "danger");
                    return;
                }

                if (approvalStatus == "Approved" && string.IsNullOrEmpty(password))
                {
                    ShowMessage("Password is required when approving an exhibitor.", "danger");
                    return;
                }

                UpdateApprovalStatus(exhibitorId, approvalStatus, remarks, password, CurrentAdminID);

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

        protected void cvPassword_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string approvalStatus = ddlApprovalStatus.SelectedValue;
            string password = txtPassword.Text.Trim();

            if (approvalStatus == "Approved" && string.IsNullOrEmpty(password))
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
                    using (SqlCommand cmd = new SqlCommand(@"
                        SELECT 
                            e.ExhibitorID,
                            e.Name,
                            e.Email,
                            e.Mobile,
                            e.Designation,
                            e.Company,
                            e.RegistrationType,
                            e.ApprovalStatus,
                            e.Remarks,
                            e.IS_ACTIVE,
                            e.CreatedDate,
                            e.ModifiedDate,
                            e.ApprovedBy,
                            e.ApprovalDate,
                            CASE WHEN EXISTS (
                                SELECT 1 FROM TBL.PostApprovalExhibitor pa 
                                WHERE pa.ExhibitorID = e.ExhibitorID AND pa.IS_ACTIVE = 1
                            ) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS HasProfile
                        FROM TBL.Exhibitor e
                        WHERE 
                            (@SearchText IS NULL OR @SearchText = '' OR
                             e.Name LIKE '%' + @SearchText + '%' OR
                             e.Email LIKE '%' + @SearchText + '%' OR
                             e.Mobile LIKE '%' + @SearchText + '%' OR
                             e.Designation LIKE '%' + @SearchText + '%' OR
                             e.Company LIKE '%' + @SearchText + '%')
                            AND (@ApprovalStatus IS NULL OR e.ApprovalStatus = @ApprovalStatus)
                        ORDER BY 
                            CASE e.ApprovalStatus
                                WHEN 'Pending' THEN 1
                                WHEN 'Approved' THEN 2
                                WHEN 'Rejected' THEN 3
                            END,
                            e.CreatedDate DESC", con))
                    {
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
                            hdnExhibitorModalMode.Value = "edit";

                            string name = reader["Name"] != DBNull.Value ? reader["Name"].ToString().Replace("'", "\\'") : "";
                            string designation = reader["Designation"] != DBNull.Value ? reader["Designation"].ToString().Replace("'", "\\'") : "";
                            string email = reader["Email"] != DBNull.Value ? reader["Email"].ToString().Replace("'", "\\'") : "";
                            string mobile = reader["Mobile"] != DBNull.Value ? reader["Mobile"].ToString().Replace("'", "\\'") : "";
                            string company = reader["Company"] != DBNull.Value ? reader["Company"].ToString().Replace("'", "\\'") : "";
                            string headOffice = reader["HeadOfficeAddress"] != DBNull.Value ? reader["HeadOfficeAddress"].ToString().Replace("'", "\\'").Replace("\n", "\\n").Replace("\r", "") : "";
                            string city = reader["City"] != DBNull.Value ? reader["City"].ToString().Replace("'", "\\'") : "";
                            string state = reader["State"] != DBNull.Value ? reader["State"].ToString().Replace("'", "\\'") : "";
                            string country = reader["Country"] != DBNull.Value ? reader["Country"].ToString().Replace("'", "\\'") : "";
                            string gst = reader["GSTNumber"] != DBNull.Value ? reader["GSTNumber"].ToString().Replace("'", "\\'") : "";
                            string billing = reader["BillingAddress"] != DBNull.Value ? reader["BillingAddress"].ToString().Replace("'", "\\'").Replace("\n", "\\n").Replace("\r", "") : "";
                            string boothType = reader["BoothType"] != DBNull.Value ? reader["BoothType"].ToString().Replace("'", "\\'") : "";
                            string area = reader["AreaInSqm"] != DBNull.Value ? reader["AreaInSqm"].ToString() : "";
                            bool conference = reader["InterestedInConference"] != DBNull.Value ? Convert.ToBoolean(reader["InterestedInConference"]) : false;
                            bool sponsorship = reader["InterestedInSponsorship"] != DBNull.Value ? Convert.ToBoolean(reader["InterestedInSponsorship"]) : false;
                            bool advertising = reader["InterestedInAdvertising"] != DBNull.Value ? Convert.ToBoolean(reader["InterestedInAdvertising"]) : false;
                            bool customPackage = reader["InterestedInCustomPackage"] != DBNull.Value ? Convert.ToBoolean(reader["InterestedInCustomPackage"]) : false;
                            bool isActive = reader["IS_ACTIVE"] != DBNull.Value ? Convert.ToBoolean(reader["IS_ACTIVE"]) : true;
                            string regType = reader["RegistrationType"] != DBNull.Value ? reader["RegistrationType"].ToString() : "Admin";

                            StringBuilder sb = new StringBuilder();
                            sb.Append("openExhibitorModal('edit', {");
                            sb.AppendFormat("id: {0},", exhibitorId);
                            sb.AppendFormat("name: '{0}',", name);
                            sb.AppendFormat("designation: '{0}',", designation);
                            sb.AppendFormat("email: '{0}',", email);
                            sb.AppendFormat("mobile: '{0}',", mobile);
                            sb.AppendFormat("company: '{0}',", company);
                            sb.AppendFormat("headOffice: '{0}',", headOffice);
                            sb.AppendFormat("city: '{0}',", city);
                            sb.AppendFormat("state: '{0}',", state);
                            sb.AppendFormat("country: '{0}',", country);
                            sb.AppendFormat("gst: '{0}',", gst);
                            sb.AppendFormat("billing: '{0}',", billing);
                            sb.AppendFormat("boothType: '{0}',", boothType);
                            sb.AppendFormat("area: '{0}',", area);
                            sb.AppendFormat("conference: '{0}',", conference);
                            sb.AppendFormat("sponsorship: '{0}',", sponsorship);
                            sb.AppendFormat("advertising: '{0}',", advertising);
                            sb.AppendFormat("customPackage: '{0}',", customPackage);
                            sb.AppendFormat("isActive: '{0}',", isActive ? "1" : "0");
                            sb.AppendFormat("regType: '{0}'", regType);
                            sb.Append("});");

                            ScriptManager.RegisterStartupScript(this, GetType(), "openEditModal", sb.ToString(), true);
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

                            string name = reader["Name"] != DBNull.Value ? reader["Name"].ToString().Replace("'", "\\'") : "";
                            string email = reader["Email"] != DBNull.Value ? reader["Email"].ToString().Replace("'", "\\'") : "";
                            string company = reader["Company"] != DBNull.Value ? reader["Company"].ToString().Replace("'", "\\'") : "";
                            string regType = reader["RegistrationType"] != DBNull.Value ? reader["RegistrationType"].ToString().Replace("'", "\\'") : "Admin";
                            string approvalStatus = reader["ApprovalStatus"] != DBNull.Value ? reader["ApprovalStatus"].ToString() : "Pending";
                            string remarks = reader["Remarks"] != DBNull.Value ? reader["Remarks"].ToString().Replace("'", "\\'") : "";
                            string password = reader["Password"] != DBNull.Value ? reader["Password"].ToString().Replace("'", "\\'") : "";

                            string script = $"openApprovalModal({exhibitorId}, '{name}', '{email}', '{company}', '{regType}', '{approvalStatus}', '{remarks}', '{password}');";
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

        private void LoadPostApprovalProfile(int exhibitorId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetPostApprovalProfileByExhibitorID", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            StringBuilder profileHtml = new StringBuilder();

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-building'></i> Exhibitor Information</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Exhibitor Name:</div><div class='info-value'>{0}</div></div>", reader["ExhibitorName"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Company:</div><div class='info-value'>{0}</div></div>", reader["Company"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Email:</div><div class='info-value'>{0}</div></div>", reader["ExhibitorEmail"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-map-marker-alt'></i> Booth Information</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Booth No:</div><div class='info-value'>{0}</div></div>", reader["BoothNo"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Hall No:</div><div class='info-value'>{0}</div></div>", reader["HallNo"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-info-circle'></i> Company Profile</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Year of Establishment:</div><div class='info-value'>{0}</div></div>", reader["YearOfEstablishment"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Website:</div><div class='info-value'><a href='{0}' target='_blank'>{0}</a></div></div>", reader["Website"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-share-alt'></i> Social Media</div>");
                            if (reader["LinkedIn"] != DBNull.Value && !string.IsNullOrEmpty(reader["LinkedIn"].ToString()))
                                profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>LinkedIn:</div><div class='info-value'><a href='{0}' target='_blank'>{0}</a></div></div>", reader["LinkedIn"]);
                            if (reader["Twitter"] != DBNull.Value && !string.IsNullOrEmpty(reader["Twitter"].ToString()))
                                profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Twitter:</div><div class='info-value'><a href='{0}' target='_blank'>{0}</a></div></div>", reader["Twitter"]);
                            if (reader["Facebook"] != DBNull.Value && !string.IsNullOrEmpty(reader["Facebook"].ToString()))
                                profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Facebook:</div><div class='info-value'><a href='{0}' target='_blank'>{0}</a></div></div>", reader["Facebook"]);
                            if (reader["YouTube"] != DBNull.Value && !string.IsNullOrEmpty(reader["YouTube"].ToString()))
                                profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>YouTube:</div><div class='info-value'><a href='{0}' target='_blank'>{0}</a></div></div>", reader["YouTube"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-headset'></i> Customer Support</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Contact Person:</div><div class='info-value'>{0}</div></div>", reader["CustomerSupportName"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Contact Number:</div><div class='info-value'>{0}</div></div>", reader["CustomerSupportContact"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Email:</div><div class='info-value'>{0}</div></div>", reader["CustomerSupportEmail"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-briefcase'></i> Business Details</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Nature of Business:</div><div class='info-value'>{0}</div></div>", reader["NatureOfBusiness"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Company Category:</div><div class='info-value'>{0}</div></div>", reader["CompanyCategory"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Markets Catered:</div><div class='info-value'>{0}</div></div>", reader["MarketsCateredTo"]);
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Geographic Reach:</div><div class='info-value'>{0}</div></div>", reader["GeographicReach"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-cogs'></i> Requirements</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Power Supply:</div><div class='info-value'>{0}</div></div>",
                                Convert.ToBoolean(reader["PowerSupplyRequired"]) ? $"Yes ({reader["PowerSupplyKwh"]} Kwh)" : "No");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Internet:</div><div class='info-value'>{0}</div></div>",
                                Convert.ToBoolean(reader["InternetRequired"]) ? "Yes" : "No");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Furniture Rental:</div><div class='info-value'>{0}</div></div>",
                                Convert.ToBoolean(reader["FurnitureRentalRequired"]) ? "Yes" : "No");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>AV Equipment:</div><div class='info-value'>{0}</div></div>",
                                Convert.ToBoolean(reader["AVEquipmentRequired"]) ? "Yes" : "No");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Interpreter Support:</div><div class='info-value'>{0}</div></div>",
                                Convert.ToBoolean(reader["InterpreterSupportRequired"]) ? "Yes" : "No");
                            if (reader["OtherRequirements"] != DBNull.Value && !string.IsNullOrEmpty(reader["OtherRequirements"].ToString()))
                                profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Other Requirements:</div><div class='info-value'>{0}</div></div>", reader["OtherRequirements"]);
                            profileHtml.Append("</div>");

                            profileHtml.Append("<div class='profile-section'>");
                            profileHtml.Append("<div class='profile-section-title'><i class='fas fa-bullseye'></i> Participation Objectives</div>");
                            profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Objectives:</div><div class='info-value'>{0}</div></div>", reader["ParticipationObjectives"]);
                            profileHtml.Append("</div>");

                            if (reader["AdditionalNotes"] != DBNull.Value && !string.IsNullOrEmpty(reader["AdditionalNotes"].ToString()))
                            {
                                profileHtml.Append("<div class='profile-section'>");
                                profileHtml.Append("<div class='profile-section-title'><i class='fas fa-file'></i> Documents</div>");
                                if (reader["ProductPicturePath"] != DBNull.Value && !string.IsNullOrEmpty(reader["ProductPicturePath"].ToString()))
                                    profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Product Picture:</div><div class='info-value'><a href='{0}' target='_blank'>View Document</a></div></div>", reader["ProductPicturePath"]);
                                if (reader["BrochurePath"] != DBNull.Value && !string.IsNullOrEmpty(reader["BrochurePath"].ToString()))
                                    profileHtml.AppendFormat("<div class='info-row'><div class='info-label'>Brochure:</div><div class='info-value'><a href='{0}' target='_blank'>View Document</a></div></div>", reader["BrochurePath"]);
                                profileHtml.Append("</div>");
                            }

                            pnlProfileDetails.Controls.Clear();
                            pnlProfileDetails.Controls.Add(new Literal { Text = profileHtml.ToString() });

                            string script = "openProfileModal();";
                            ScriptManager.RegisterStartupScript(this, GetType(), "openProfileModal", script, true);
                        }
                        else
                        {
                            ShowMessage("Profile not found for this exhibitor.", "danger");
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading profile: " + ex.Message, "danger");
            }
        }

        private void AddExhibitor(string name, string email, string mobile, string designation, string company,
            string headOffice, string city, string state, string country, string gstNumber, string billingAddress,
            string boothType, decimal? areaInSqm, bool conference, bool sponsorship, bool advertising,
            bool customPackage, bool isActive, string registrationType)
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
                    cmd.Parameters.AddWithValue("@HeadOfficeAddress", string.IsNullOrEmpty(headOffice) ? (object)DBNull.Value : headOffice);
                    cmd.Parameters.AddWithValue("@City", string.IsNullOrEmpty(city) ? (object)DBNull.Value : city);
                    cmd.Parameters.AddWithValue("@State", string.IsNullOrEmpty(state) ? (object)DBNull.Value : state);
                    cmd.Parameters.AddWithValue("@Country", string.IsNullOrEmpty(country) ? (object)DBNull.Value : country);
                    cmd.Parameters.AddWithValue("@GSTNumber", string.IsNullOrEmpty(gstNumber) ? (object)DBNull.Value : gstNumber);
                    cmd.Parameters.AddWithValue("@BillingAddress", string.IsNullOrEmpty(billingAddress) ? (object)DBNull.Value : billingAddress);
                    cmd.Parameters.AddWithValue("@BoothType", string.IsNullOrEmpty(boothType) ? (object)DBNull.Value : boothType);
                    cmd.Parameters.AddWithValue("@AreaInSqm", areaInSqm.HasValue ? (object)areaInSqm.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@InterestedInConference", conference);
                    cmd.Parameters.AddWithValue("@InterestedInSponsorship", sponsorship);
                    cmd.Parameters.AddWithValue("@InterestedInAdvertising", advertising);
                    cmd.Parameters.AddWithValue("@InterestedInCustomPackage", customPackage);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);
                    cmd.Parameters.AddWithValue("@RegistrationType", registrationType);

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

        private void UpdateExhibitor(int exhibitorId, string name, string email, string mobile, string designation,
            string company, string headOffice, string city, string state, string country, string gstNumber,
            string billingAddress, string boothType, decimal? areaInSqm, bool conference, bool sponsorship,
            bool advertising, bool customPackage, bool isActive)
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
                    cmd.Parameters.AddWithValue("@HeadOfficeAddress", string.IsNullOrEmpty(headOffice) ? (object)DBNull.Value : headOffice);
                    cmd.Parameters.AddWithValue("@City", string.IsNullOrEmpty(city) ? (object)DBNull.Value : city);
                    cmd.Parameters.AddWithValue("@State", string.IsNullOrEmpty(state) ? (object)DBNull.Value : state);
                    cmd.Parameters.AddWithValue("@Country", string.IsNullOrEmpty(country) ? (object)DBNull.Value : country);
                    cmd.Parameters.AddWithValue("@GSTNumber", string.IsNullOrEmpty(gstNumber) ? (object)DBNull.Value : gstNumber);
                    cmd.Parameters.AddWithValue("@BillingAddress", string.IsNullOrEmpty(billingAddress) ? (object)DBNull.Value : billingAddress);
                    cmd.Parameters.AddWithValue("@BoothType", string.IsNullOrEmpty(boothType) ? (object)DBNull.Value : boothType);
                    cmd.Parameters.AddWithValue("@AreaInSqm", areaInSqm.HasValue ? (object)areaInSqm.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@InterestedInConference", conference);
                    cmd.Parameters.AddWithValue("@InterestedInSponsorship", sponsorship);
                    cmd.Parameters.AddWithValue("@InterestedInAdvertising", advertising);
                    cmd.Parameters.AddWithValue("@InterestedInCustomPackage", customPackage);
                    cmd.Parameters.AddWithValue("@IS_ACTIVE", isActive);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateApprovalStatus(int exhibitorId, string approvalStatus, string remarks, string password, int approvedBy)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(@"
                    UPDATE TBL.Exhibitor
                    SET 
                        ApprovalStatus = @ApprovalStatus,
                        Remarks = @Remarks,
                        Password = CASE WHEN @ApprovalStatus = 'Approved' THEN @Password ELSE Password END,
                        ApprovedBy = @ApprovedBy,
                        ApprovalDate = GETDATE(),
                        ModifiedDate = GETDATE()
                    WHERE ExhibitorID = @ExhibitorID", con))
                {
                    cmd.Parameters.AddWithValue("@ExhibitorID", exhibitorId);
                    cmd.Parameters.AddWithValue("@ApprovalStatus", approvalStatus);
                    cmd.Parameters.AddWithValue("@Remarks", string.IsNullOrEmpty(remarks) ? (object)DBNull.Value : remarks);
                    cmd.Parameters.AddWithValue("@Password", string.IsNullOrEmpty(password) ? (object)DBNull.Value : password);
                    cmd.Parameters.AddWithValue("@ApprovedBy", approvedBy);

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

        private void ClearExhibitorForm()
        {
            txtName.Text = "";
            txtDesignation.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
            txtCompany.Text = "";
            txtHeadOffice.Text = "";
            txtCity.Text = "";
            txtState.Text = "";
            txtCountry.Text = "";
            txtGSTNumber.Text = "";
            txtBillingAddress.Text = "";
            rbShellScheme.Checked = false;
            rbRawSpace.Checked = false;
            txtAreaInSqm.Text = "";
            chkConference.Checked = false;
            chkSponsorship.Checked = false;
            chkAdvertising.Checked = false;
            chkCustomPackage.Checked = false;
            ddlStatus.SelectedIndex = 0;
            ddlRegistrationType.SelectedIndex = 0;
            hdnExhibitorID.Value = "0";
            hdnExhibitorModalMode.Value = "add";
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