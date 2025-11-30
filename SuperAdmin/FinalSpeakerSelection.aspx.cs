using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Expo_Panel.SuperAdmin
{
    public partial class FinalSpeakerSelection : System.Web.UI.Page
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

        public int ExpandedAgendaID
        {
            get
            {
                int id = 0;
                Int32.TryParse(hdnExpandedAgendaID.Value, out id);
                return id;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsAdminLoggedIn())
            {
                Response.Redirect("~/Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            string role = Session["Role"] != null ? Session["Role"].ToString() : "Admin";

            if (role != "SuperAdmin")
            {
                // STOP! They are not allowed.
                // Redirect them back to the dashboard immediately.
                Response.Redirect("~/SuperAdmin/Dashboard.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return; // Stop processing this page
            }

            if (IsPostBack && Request.Form["hdnExpandedAgendaID"] != null)
            {
                hdnExpandedAgendaID.Value = Request.Form["hdnExpandedAgendaID"];
            }


            // 1. HANDLE TOGGLE LOGIC (Must happen before Scrolling logic)
            if (IsPostBack && Request.Form["__EVENTTARGET"] == "Toggle")
            {
                string agendaIdStr = Request.Form["__EVENTARGUMENT"];
                int clicked = 0;
                Int32.TryParse(agendaIdStr, out clicked);

                int current = 0;
                Int32.TryParse(hdnExpandedAgendaID.Value, out current);

                // Logic: If clicking the same one, collapse (set to 0). Otherwise, set to clicked ID.
                if (current == clicked)
                    hdnExpandedAgendaID.Value = "0";
                else
                    hdnExpandedAgendaID.Value = clicked.ToString();

                // Re-bind immediately to update the UI
                BindAgendas(txtSearch.Text.Trim(), hdnCurrentFilter.Value);
            }

            // 2. HANDLE SCROLLING (Updated for robustness)
            // We check if ExpandedAgendaID > 0 (meaning we just expanded something)
            if (IsPostBack && ExpandedAgendaID > 0)
            {
                string script = $@"
        $(function() {{
            console.log('Scrolling to agenda ID: {ExpandedAgendaID}');
            setTimeout(function() {{
                var $target = $('#agenda_{ExpandedAgendaID}');
                if ($target.length) {{
                    // Calculate position: Element Top - Header Height (160px buffer)
                    var targetTop = $target.offset().top - 160;
                    console.log('Target found at: ' + targetTop);
                    $('html, body').animate({{ scrollTop: targetTop }}, 600); 
                }} else {{
                    console.log('Target element not found in DOM');
                }}
            }}, 300); 
        }});";

                ScriptManager.RegisterStartupScript(this, GetType(), "ScrollToAgenda", script, true);
            }

            if (!IsPostBack)
            {
                if (Session["AdminUsername"] != null)
                    lblAdminName.Text = Session["AdminUsername"].ToString();
                else
                    lblAdminName.Text = "Admin";

                hdnCurrentFilter.Value = "All";
                LoadDashboardStatistics();
                LoadStatusCounts();
                BindAgendas(string.Empty, "All");
            }
        }
        private bool IsAdminLoggedIn()
        {
            return CurrentAdminID > 0;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // 1. Clear the session (Log out)
            Session.Clear();
            Session.Abandon();

            // 2. Redirect to the Dashboard as requested
            // Note: If Dashboard is protected, it might kick the user back to Login automatically.
            Response.Redirect("~/SuperAdmin/Dashboard.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private void LoadDashboardStatistics()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetDashboardStatistics", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            lblTotalAgendas.Text = reader["TotalAgendas"]?.ToString() ?? "0";
                            lblTotalSpeakers.Text = reader["TotalSpeakers"]?.ToString() ?? "0";
                            lblApprovedSpeakers.Text = reader["ApprovedSpeakers"]?.ToString() ?? "0";
                            lblTotalAdvisors.Text = reader["TotalAdvisors"]?.ToString() ?? "0";
                            lblPendingReview.Text = reader["NeedsReview"]?.ToString() ?? "0";
                            lblFinalizedAgendas.Text = reader["FinalizedAgendas"]?.ToString() ?? "0";
                        }
                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadDashboardStatistics Error: " + ex.ToString());
                lblTotalAgendas.Text = "0";
                lblTotalSpeakers.Text = "0";
                lblApprovedSpeakers.Text = "0";
                lblTotalAdvisors.Text = "0";
                lblPendingReview.Text = "0";
                lblFinalizedAgendas.Text = "0";
            }
        }

        private void LoadStatusCounts()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetFinalSelectionStatusCounts", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            int totalAgendas = reader["TotalAgendas"] != DBNull.Value ? Convert.ToInt32(reader["TotalAgendas"]) : 0;
                            int needsReview = reader["NeedsReview"] != DBNull.Value ? Convert.ToInt32(reader["NeedsReview"]) : 0;
                            int finalized = reader["Finalized"] != DBNull.Value ? Convert.ToInt32(reader["Finalized"]) : 0;
                            int pending = reader["Pending"] != DBNull.Value ? Convert.ToInt32(reader["Pending"]) : 0;

                            btnAll.Text = $"All Sessions ({totalAgendas})";
                            btnNeedsReview.Text = $"Needs Review ({needsReview})";
                            btnFinalized.Text = $"Finalized ({finalized})";
                            btnPending.Text = $"Pending Ratings ({pending})";
                        }
                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                litMessage.Text = "<div class='alert alert-danger'>Error loading stats: " + ex.Message + "</div>";
                System.Diagnostics.Debug.WriteLine("LoadStatusCounts Error: " + ex.ToString());
                btnAll.Text = "All Agendas (0)";
                btnNeedsReview.Text = "Needs Review (0)";
                btnFinalized.Text = "Finalized (0)";
                btnPending.Text = "Pending Ratings (0)";
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                string searchText = txtSearch.Text.Trim();
                string currentFilter = hdnCurrentFilter.Value;
                hdnExpandedAgendaID.Value = "0";
                BindAgendas(searchText, currentFilter);
                LoadStatusCounts();
            }
            catch (Exception ex)
            {
                litMessage.Text = "<div class='alert alert-danger'>Search Error: " + ex.Message + "</div>";
                System.Diagnostics.Debug.WriteLine("Search Error: " + ex.ToString());
            }
        }

        protected void btnStatusFilter_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string filterStatus = btn.CommandArgument;

            btnAll.CssClass = "btn-filter";
            btnNeedsReview.CssClass = "btn-filter";
            btnFinalized.CssClass = "btn-filter";
            btnPending.CssClass = "btn-filter";
            btn.CssClass = "btn-filter active";

            hdnCurrentFilter.Value = filterStatus;
            txtSearch.Text = string.Empty;
            hdnExpandedAgendaID.Value = "0";

            BindAgendas(string.Empty, filterStatus);
            LoadStatusCounts();
        }

        private void BindAgendas(string searchText, string statusFilter)
        {
            try
            {
                DataTable dt = new DataTable();
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAgendasForFinalSelection", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SearchText", string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText);
                        cmd.Parameters.AddWithValue("@StatusFilter", statusFilter);

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            con.Open();
                            da.Fill(dt);
                        }
                    }
                }

                if (dt.Rows.Count > 0)
                {
                    pnlNoRecords.Visible = false;
                    rptAgendas.DataSource = dt;
                    rptAgendas.DataBind();
                }
                else
                {
                    pnlNoRecords.Visible = true;
                    rptAgendas.DataSource = null;
                    rptAgendas.DataBind();
                }
            }
            catch (Exception ex)
            {
                litMessage.Text = "<div class='alert alert-danger'>BindAgendas Error: " + ex.Message + "</div>";
                System.Diagnostics.Debug.WriteLine("BindAgendas Error: " + ex.ToString());
                pnlNoRecords.Visible = true;
                rptAgendas.DataSource = null;
                rptAgendas.DataBind();
            }
        }

        protected void rptAgendas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // Handled in OnInit
        }

        protected void rptAgendas_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                int agendaId = Convert.ToInt32(drv["AgendaID"]);
                int expandedAgendaId = 0;
                Int32.TryParse(hdnExpandedAgendaID.Value, out expandedAgendaId);

                Panel pnlSpeakers = (Panel)e.Item.FindControl("pnlSpeakers");

                if (pnlSpeakers != null)
                {
                    if (agendaId == expandedAgendaId && expandedAgendaId > 0)
                    {
                        pnlSpeakers.Visible = true;
                        LoadAgendaSpeakers(agendaId, pnlSpeakers);
                    }
                    else
                    {
                        pnlSpeakers.Visible = false;
                    }
                }
            }
        }

        private void LoadAgendaSpeakers(int agendaId, Panel pnlSpeakers)
        {
            _colorIndex = 0;
            try
            {
                pnlSpeakers.Controls.Clear();
                DataTable dt = new DataTable();

                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetSpeakersForFinalSelection", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AgendaID", agendaId);

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            con.Open();
                            da.Fill(dt);
                        }
                    }
                }

                if (dt.Rows.Count == 0)
                {
                    pnlSpeakers.Controls.Add(new Literal { Text = "<div class='no-records' style='padding: 20px;'><i class='fas fa-user-slash'></i><h4>No speakers found for this agenda</h4></div>" });
                    return;
                }

                StringBuilder html = new StringBuilder();
                html.Append("<div class='speakers-list'>");

                foreach (DataRow row in dt.Rows)
                {
                    string colorClass = GetNextSpeakerColor();
                    int speakerId = Convert.ToInt32(row["SpeakerID"]);
                    string name = row["Name"]?.ToString() ?? "";
                    string designation = row["Designation"]?.ToString() ?? "";
                    string company = row["Company"]?.ToString() ?? "";
                    string photoPath = row["PhotoPath"]?.ToString() ?? "";
                    double avgRating = row["AvgRating"] != DBNull.Value ? Convert.ToDouble(row["AvgRating"]) : 0;
                    int totalRatings = row["TotalRatings"] != DBNull.Value ? Convert.ToInt32(row["TotalRatings"]) : 0;

                    int r5 = row["Rating5Count"] != DBNull.Value ? Convert.ToInt32(row["Rating5Count"]) : 0;
                    int r4 = row["Rating4Count"] != DBNull.Value ? Convert.ToInt32(row["Rating4Count"]) : 0;
                    int r3 = row["Rating3Count"] != DBNull.Value ? Convert.ToInt32(row["Rating3Count"]) : 0;
                    int r2 = row["Rating2Count"] != DBNull.Value ? Convert.ToInt32(row["Rating2Count"]) : 0;
                    int r1 = row["Rating1Count"] != DBNull.Value ? Convert.ToInt32(row["Rating1Count"]) : 0;

                    object currentDecisionObj = row["CurrentDecision"];
                    string currentDecision = currentDecisionObj == DBNull.Value ? "hold" :
                                             (Convert.ToBoolean(currentDecisionObj) ? "approved" : "rejected");

                    string approvedAgendasJSON = row["ApprovedAgendasJSON"]?.ToString() ?? "";
                    string approvedAgendasDisplay = "";
                    if (!string.IsNullOrEmpty(approvedAgendasJSON))
                    {
                        try
                        {
                            var approvedAgendas = Newtonsoft.Json.JsonConvert.DeserializeObject<List<ApprovedAgendaInfo>>(approvedAgendasJSON);
                            if (approvedAgendas != null && approvedAgendas.Count > 0)
                            {
                                List<string> titles = new List<string>();
                                foreach (var agenda in approvedAgendas)
                                {
                                    titles.Add(agenda.AgendaTitle);
                                }
                                approvedAgendasDisplay = $"<div class='approved-agendas'>✅ <strong>Previously approved for:</strong> {string.Join(", ", titles)}</div>";
                            }
                        }
                        catch { }
                    }

                    string photoHtml;
                    if (string.IsNullOrEmpty(photoPath))
                    {
                        photoHtml = "<div class='speaker-photo-placeholder'><i class='fas fa-user'></i></div>";
                    }
                    else
                    {
                        string resolvedPhotoPath;
                        if (photoPath.StartsWith("http") || photoPath.StartsWith("/"))
                        {
                            resolvedPhotoPath = photoPath;
                        }
                        else if (photoPath.StartsWith("~/"))
                        {
                            resolvedPhotoPath = VirtualPathUtility.ToAbsolute(photoPath);
                        }
                        else
                        {
                            resolvedPhotoPath = VirtualPathUtility.ToAbsolute("~/" + photoPath);
                        }
                        photoHtml = $"<img src='{resolvedPhotoPath}' alt='{HttpUtility.HtmlEncode(name)}' class='speaker-photo' onerror='this.style.display=\"none\"; this.nextElementSibling.style.display=\"flex\";' /><div class='speaker-photo-placeholder' style='display:none;'><i class='fas fa-user'></i></div>";
                    }

                    html.Append($@"<div class='speaker-card {colorClass}' data-speaker-id='{speakerId}'>
                        <div class='speaker-header'>
                            {photoHtml}
                            <div class='speaker-info'>
                                <h4>{HttpUtility.HtmlEncode(name)}</h4>
                                <p class='speaker-meta'><i class='fas fa-briefcase'></i> {HttpUtility.HtmlEncode(designation)} at {HttpUtility.HtmlEncode(company)}</p>
                                <p class='speaker-meta'><i class='fas fa-star'></i> {totalRatings} rating{(totalRatings != 1 ? "s" : "")} received</p>
                            </div>
                        </div>
                        <div class='rating-display'>
                            <div class='avg-rating'>{avgRating:F1} ★</div>
                            <div class='rating-breakdown'>
                                {BuildRatingBar("5★", r5, totalRatings)}
                                {BuildRatingBar("4★", r4, totalRatings)}
                                {BuildRatingBar("3★", r3, totalRatings)}
                                {BuildRatingBar("2★", r2, totalRatings)}
                                {BuildRatingBar("1★", r1, totalRatings)}
                            </div>
                        </div>
                        {approvedAgendasDisplay}
                        <div class='decision-section'>
                            <label class='decision-label'><i class='fas fa-clipboard-check'></i> Final Decision:</label>
                            <div class='decision-options'>
                                <div class='decision-option'>
                                    <input type='radio' name='decision_{speakerId}' id='dec_app_{speakerId}' value='approved' {(currentDecision == "approved" ? "checked" : "")} />
                                    <label for='dec_app_{speakerId}'><i class='fas fa-check-circle'></i> Approve</label>
                                </div>
                                <div class='decision-option reject'>
                                    <input type='radio' name='decision_{speakerId}' id='dec_rej_{speakerId}' value='rejected' {(currentDecision == "rejected" ? "checked" : "")} />
                                    <label for='dec_rej_{speakerId}'><i class='fas fa-times-circle'></i> Reject</label>
                                </div>
                                <div class='decision-option hold'>
                                    <input type='radio' name='decision_{speakerId}' id='dec_hold_{speakerId}' value='hold' {(currentDecision == "hold" ? "checked" : "")} />
                                    <label for='dec_hold_{speakerId}'><i class='fas fa-pause-circle'></i> On Hold</label>
                                </div>
                            </div>
                        </div>
                        <div class='action-buttons'>
                            <button type='button' class='btn-view-profile' onclick='viewSpeakerProfile({speakerId}, {agendaId})'>
                                <i class='fas fa-user-circle'></i> View Full Profile & Comments
                            </button>
                        </div>
                    </div>");
                }

                html.Append("</div>");
                html.Append($@"<div class='action-buttons' style='margin-top: 20px; padding: 20px 0; border-top: 2px solid #e2e8f0;'>
                    <button type='button' class='btn-save-all' onclick='saveAllDecisions({agendaId})'>
                        <i class='fas fa-save'></i> Save All Decisions
                    </button>
                </div>");

                pnlSpeakers.Controls.Add(new Literal { Text = html.ToString() });
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadAgendaSpeakers Error: " + ex.ToString());
                pnlSpeakers.Controls.Add(new Literal { Text = "<div class='alert alert-danger'>Error loading speakers: " + HttpUtility.HtmlEncode(ex.Message) + "</div>" });
            }
        }

        private string BuildRatingBar(string label, int count, int total)
        {
            double percentage = total > 0 ? (count * 100.0 / total) : 0;
            return $@"<div class='rating-bar'>
                <span style='width: 35px; font-weight: 600;'>{label}</span>
                <div class='rating-bar-fill'>
                    <div class='rating-bar-fill-inner' style='width: {percentage}%'></div>
                </div>
                <span style='width: 80px; text-align: right; font-weight: 600; color: #4a5568;'>{count} ({percentage:F0}%)</span>
            </div>";
        }

        

        public string GetStatusBadge(object statusCategoryObj)
        {
            string status = statusCategoryObj?.ToString() ?? "Pending";
            switch (status)
            {
                case "NeedsReview":
                    return "<span class='status-badge badge-needs-review'><i class='fas fa-exclamation-triangle'></i> Needs Review</span>";
                case "Finalized":
                    return "<span class='status-badge badge-finalized'><i class='fas fa-check-circle'></i> Finalized</span>";
                case "Pending":
                    return "<span class='status-badge badge-pending'><i class='fas fa-clock'></i> Pending Ratings</span>";
                case "NoSpeakers":
                    return "<span class='status-badge badge-no-speakers'><i class='fas fa-user-slash'></i> No Speakers</span>";
                default:
                    return "<span class='status-badge badge-pending'><i class='fas fa-question-circle'></i> Unknown</span>";
            }
        }

        [WebMethod]
        public static object SaveSpeakerDecisions(int agendaId, List<SpeakerDecision> decisions)
        {
            try
            {
                // Log incoming request
                System.Diagnostics.Debug.WriteLine("=== SaveSpeakerDecisions Called ===");
                System.Diagnostics.Debug.WriteLine("AgendaID: " + agendaId);
                System.Diagnostics.Debug.WriteLine("Decisions Count: " + (decisions != null ? decisions.Count : 0));

                // Check session
                int adminId = 0;
                if (HttpContext.Current.Session["AdminID"] != null)
                {
                    adminId = Convert.ToInt32(HttpContext.Current.Session["AdminID"]);
                    System.Diagnostics.Debug.WriteLine("AdminID from session: " + adminId);
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine("ERROR: AdminID not in session");
                    return new { success = false, message = "Admin session expired. Please login again." };
                }

                if (adminId == 0)
                {
                    System.Diagnostics.Debug.WriteLine("ERROR: AdminID is 0");
                    return new { success = false, message = "Invalid admin session. Please login again." };
                }

                if (decisions == null || decisions.Count == 0)
                {
                    System.Diagnostics.Debug.WriteLine("ERROR: No decisions provided");
                    return new { success = false, message = "No decisions provided." };
                }

                string connectionString = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

                // Log each decision
                foreach (var d in decisions)
                {
                    System.Diagnostics.Debug.WriteLine($"Decision: SpeakerID={d.SpeakerID}, IsApproved={d.IsApproved}");
                }

                string decisionsJSON = Newtonsoft.Json.JsonConvert.SerializeObject(decisions);
                System.Diagnostics.Debug.WriteLine("JSON to send: " + decisionsJSON);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_SaveMultipleSpeakerApprovals", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandTimeout = 60;

                        cmd.Parameters.AddWithValue("@AgendaID", agendaId);
                        cmd.Parameters.AddWithValue("@ApprovedByAdminID", adminId);
                        cmd.Parameters.AddWithValue("@DecisionsJSON", decisionsJSON);

                        con.Open();
                        System.Diagnostics.Debug.WriteLine("Database connection opened");

                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            bool success = reader["Success"] != DBNull.Value && Convert.ToBoolean(reader["Success"]);
                            string message = reader["Message"]?.ToString() ?? "";

                            System.Diagnostics.Debug.WriteLine("SP Response - Success: " + success + ", Message: " + message);

                            reader.Close();
                            return new { success = success, message = message };
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine("ERROR: No response from stored procedure");
                            reader.Close();
                            return new { success = false, message = "No response from database" };
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("=== EXCEPTION in SaveSpeakerDecisions ===");
                System.Diagnostics.Debug.WriteLine("Message: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Stack Trace: " + ex.StackTrace);
                if (ex.InnerException != null)
                {
                    System.Diagnostics.Debug.WriteLine("Inner Exception: " + ex.InnerException.Message);
                }
                return new { success = false, message = "Error: " + ex.Message };
            }
        }

        [WebMethod]
        public static object GetSpeakerProfileAndComments(int speakerId, int agendaId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;
            StringBuilder combinedHtml = new StringBuilder();

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("sp_GetSpeakerById", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        string name = reader["Name"]?.ToString() ?? "";
                        string designation = reader["Designation"]?.ToString() ?? "";
                        string company = reader["Company"]?.ToString() ?? "";
                        string bio = reader["ProfessionalBio"]?.ToString() ?? "No bio provided.";
                        string email = reader["Email"]?.ToString() ?? "";
                        string mobile = reader["Mobile"]?.ToString() ?? "N/A";
                        string linkedIn = reader["LinkedInProfile"]?.ToString() ?? "";
                        string experience = reader["YearsOfExperience"]?.ToString() + " years";
                        string expertise = reader["AreasOfExpertise"]?.ToString() ?? "N/A";
                        string projects = reader["CurrentWorkProjects"]?.ToString() ?? "N/A";
                        string imageUrl = reader["PhotoPath"]?.ToString() ?? "";

                        if (string.IsNullOrEmpty(imageUrl))
                        {
                            imageUrl = "https://placehold.co/120x120/e2e8f0/a0aec0?text=N/A";
                        }
                        else if (imageUrl.StartsWith("http") || imageUrl.StartsWith("/"))
                        {
                            // Use as-is
                        }
                        else if (imageUrl.StartsWith("~/"))
                        {
                            imageUrl = VirtualPathUtility.ToAbsolute(imageUrl);
                        }
                        else
                        {
                            imageUrl = VirtualPathUtility.ToAbsolute("~/" + imageUrl);
                        }

                        combinedHtml.Append(BuildStaticProfileHtml(name, designation, company, bio, email, mobile, linkedIn, experience, expertise, projects, imageUrl));
                    }
                    reader.Close();
                }

                combinedHtml.Append("<hr style='margin: 30px 0; border: none; border-top: 2px solid #e2e8f0;'>");
                combinedHtml.Append("<h3 style='color: #2d3748; margin-bottom: 20px;'><i class='fas fa-comments'></i> Advisory Comments</h3>");

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("sp_GetAdvisoryCommentsForSpeaker", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                    cmd.Parameters.AddWithValue("@AgendaID", agendaId);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (!reader.HasRows)
                    {
                        combinedHtml.Append("<p style='text-align: center; color: #a0aec0; padding: 40px; background: #f7fafc; border-radius: 12px;'><i class='fas fa-inbox' style='font-size: 48px; display: block; margin-bottom: 15px;'></i>No comments available for this speaker on this agenda.</p>");
                    }
                    else
                    {
                        while (reader.Read())
                        {
                            int rating = Convert.ToInt32(reader["Rating"]);
                            string comments = reader["Comments"]?.ToString() ?? "No comment provided";
                            string advisorName = reader["AdvisorName"]?.ToString() ?? "Anonymous";
                            string advisorDesignation = reader["AdvisorDesignation"]?.ToString() ?? "";
                            string advisorCompany = reader["AdvisorCompany"]?.ToString() ?? "";
                            DateTime ratingDate = reader["RatingDate"] != DBNull.Value ? Convert.ToDateTime(reader["RatingDate"]) : DateTime.Now;
                            string stars = new string('★', rating) + new string('☆', 5 - rating);

                            combinedHtml.Append("<div class='comment-item'>");
                            combinedHtml.Append("<div class='comment-header'>");
                            combinedHtml.AppendFormat("<div class='comment-author'><i class='fas fa-user-circle'></i> {0}</div>", HttpUtility.HtmlEncode(advisorName));
                            combinedHtml.AppendFormat("<div class='comment-rating'>{0} {1}/5</div>", stars, rating);
                            combinedHtml.Append("</div>");
                            if (!string.IsNullOrEmpty(advisorDesignation) || !string.IsNullOrEmpty(advisorCompany))
                                combinedHtml.AppendFormat("<div class='comment-meta'><i class='fas fa-briefcase'></i> {0}{1}</div>",
                                    HttpUtility.HtmlEncode(advisorDesignation),
                                    !string.IsNullOrEmpty(advisorCompany) ? " at " + HttpUtility.HtmlEncode(advisorCompany) : "");
                            combinedHtml.AppendFormat("<div class='comment-text'>{0}</div>", HttpUtility.HtmlEncode(comments));
                            combinedHtml.AppendFormat("<div class='comment-meta'><i class='fas fa-calendar'></i> {0}</div>", ratingDate.ToString("MMM dd, yyyy"));
                            combinedHtml.Append("</div>");
                        }
                    }
                    reader.Close();
                }

                return new { success = true, html = combinedHtml.ToString() };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetSpeakerProfileAndComments Error: " + ex.ToString());
                return new { success = false, error = ex.Message };
            }
        }

        private static string BuildStaticProfileHtml(string name, string designation, string company, string bio,
            string email, string mobile, string linkedIn, string experience, string expertise, string projects, string imageUrl)
        {
            StringBuilder profile = new StringBuilder();
            profile.Append("<div style='padding-top: 0;'>");
            profile.Append("<div style='text-align: center; margin-bottom: 25px;'>");
            profile.AppendFormat("<img src='{0}' style='width: 130px; height: 130px; border-radius: 50%; object-fit: cover; border: 5px solid #e2e8f0; box-shadow: 0 6px 20px rgba(0,0,0,0.1);' onerror=\"this.src='https://placehold.co/130x130/e2e8f0/a0aec0?text=N/A';\" />", imageUrl);
            profile.AppendFormat("<h3 style='margin: 20px 0 8px 0; color: #2d3748; font-size: 24px; font-weight: 700;'>{0}</h3>", HttpUtility.HtmlEncode(name));
            profile.AppendFormat("<p style='color: #718096; font-size: 16px;'><i class='fas fa-briefcase'></i> {0} at {1}</p>", HttpUtility.HtmlEncode(designation), HttpUtility.HtmlEncode(company));
            profile.Append("</div>");

            profile.Append("<div style='background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%); padding: 20px; border-radius: 12px; margin-bottom: 20px; border-left: 4px solid #667eea;'>");
            profile.Append("<h4 style='margin: 0 0 12px 0; color: #2d3748; font-weight: 700;'><i class='fas fa-info-circle'></i> Professional Bio</h4>");
            profile.AppendFormat("<p style='color: #4a5568; line-height: 1.7; margin: 0;'>{0}</p>", HttpUtility.HtmlEncode(bio));
            profile.Append("</div>");

            profile.Append("<div style='display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 20px;'>");
            profile.AppendFormat("<div style='background: #f7fafc; padding: 15px; border-radius: 10px;'><strong style='color: #667eea;'><i class='fas fa-envelope'></i> Email:</strong><br/><span style='color: #4a5568;'>{0}</span></div>", HttpUtility.HtmlEncode(email));
            profile.AppendFormat("<div style='background: #f7fafc; padding: 15px; border-radius: 10px;'><strong style='color: #667eea;'><i class='fas fa-phone'></i> Mobile:</strong><br/><span style='color: #4a5568;'>{0}</span></div>", HttpUtility.HtmlEncode(mobile));
            profile.AppendFormat("<div style='background: #f7fafc; padding: 15px; border-radius: 10px;'><strong style='color: #667eea;'><i class='fas fa-briefcase'></i> Experience:</strong><br/><span style='color: #4a5568;'>{0}</span></div>", HttpUtility.HtmlEncode(experience));
            if (!string.IsNullOrEmpty(linkedIn))
                profile.AppendFormat("<div style='background: #f7fafc; padding: 15px; border-radius: 10px;'><strong style='color: #667eea;'><i class='fab fa-linkedin'></i> LinkedIn:</strong><br/><a href='{0}' target='_blank' rel='noopener noreferrer' style='color: #667eea; font-weight: 600;'>View Profile</a></div>", HttpUtility.HtmlEncode(linkedIn));
            profile.Append("</div>");

            profile.Append("<div style='background: #f7fafc; padding: 20px; border-radius: 12px; margin-bottom: 20px;'>");
            profile.Append("<h4 style='margin: 0 0 12px 0; color: #2d3748; font-weight: 700;'><i class='fas fa-lightbulb'></i> Areas of Expertise</h4>");
            profile.AppendFormat("<p style='color: #4a5568; line-height: 1.6; margin: 0;'>{0}</p>", HttpUtility.HtmlEncode(expertise));
            profile.Append("</div>");

            profile.Append("<div style='background: #f7fafc; padding: 20px; border-radius: 12px;'>");
            profile.Append("<h4 style='margin: 0 0 12px 0; color: #2d3748; font-weight: 700;'><i class='fas fa-project-diagram'></i> Current Projects</h4>");
            profile.AppendFormat("<p style='color: #4a5568; line-height: 1.6; margin: 0;'>{0}</p>", HttpUtility.HtmlEncode(projects));
            profile.Append("</div>");

            profile.Append("</div>");
            return profile.ToString();
        }

        private static readonly string[] SpeakerColorPool = {
    "teal", // #38b2ac (Your new primary color)
    "indigo", // #667eea (Previous primary color)
    "orange", // #ed8936 
    "red",    // #f56565
    "purple", // #9f7aea
    "pink"    // #ed64a6
};
        // Counter to track which color to use next
        private static int _colorIndex = 0;

        // Method to get the next color in the cycle
        private string GetNextSpeakerColor()
        {
            string color = SpeakerColorPool[_colorIndex % SpeakerColorPool.Length];
            _colorIndex++;
            return color;
        }
        public class SpeakerDecision
        {
            public int SpeakerID { get; set; }
            public bool? IsApproved { get; set; }
            public string Comments { get; set; }
        }

        public class ApprovedAgendaInfo
        {
            public int AgendaID { get; set; }
            public string AgendaTitle { get; set; }
            public string Day { get; set; }
            public string Track { get; set; }
            public string Time { get; set; }
            public DateTime? ApprovalDate { get; set; }
            public int? ApprovedByAdminID { get; set; }
        }
    }
}