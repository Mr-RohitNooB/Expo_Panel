using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
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

        protected int ExpandedAgendaID
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
                Response.Redirect("~/User/AdminLogin.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                if (Session["AdminUsername"] != null)
                    lblAdminName.Text = Session["AdminUsername"].ToString();
                else
                    lblAdminName.Text = "Admin";

                hdnCurrentFilter.Value = "All";
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
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/User/AdminLogin.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
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

                            btnAll.Text = $"All Agendas ({totalAgendas})";
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
                System.Diagnostics.Debug.WriteLine("LoadStatusCounts Error: " + ex.ToString());
                btnAll.Text = "All Agendas (0)";
                btnNeedsReview.Text = "Needs Review (0)";
                btnFinalized.Text = "Finalized (0)";
                btnPending.Text = "Pending Ratings (0)";
            }
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
                System.Diagnostics.Debug.WriteLine("BindAgendas Error: " + ex.ToString());
                pnlNoRecords.Visible = true;
                rptAgendas.DataSource = null;
                rptAgendas.DataBind();
            }
        }

        protected void rptAgendas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // Not used - handled in OnInit
        }

        protected void rptAgendas_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                int agendaId = Convert.ToInt32(drv["AgendaID"]);
                int expandedAgendaId = 0;
                Int32.TryParse(hdnExpandedAgendaID.Value, out expandedAgendaId);

                if (agendaId == expandedAgendaId)
                {
                    Panel pnlSpeakers = (Panel)e.Item.FindControl("pnlSpeakers");
                    if (pnlSpeakers != null)
                    {
                        LoadAgendaSpeakers(agendaId, pnlSpeakers);
                    }
                }
            }
        }

        private void LoadAgendaSpeakers(int agendaId, Panel pnlSpeakers)
        {
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
                    pnlSpeakers.Controls.Add(new Literal { Text = "<div class='no-records'><i class='fas fa-user-slash'></i><p>No speakers found for this agenda</p></div>" });
                    return;
                }

                StringBuilder sb = new StringBuilder();

                foreach (DataRow r in dt.Rows)
                {
                    int speakerId = Convert.ToInt32(r["SpeakerID"]);
                    string name = HttpUtility.HtmlEncode(r["Name"].ToString());
                    string designation = r["Designation"] != DBNull.Value ? HttpUtility.HtmlEncode(r["Designation"].ToString()) : "N/A";
                    string company = r["Company"] != DBNull.Value ? HttpUtility.HtmlEncode(r["Company"].ToString()) : "N/A";
                    string bio = r["ProfessionalBio"] != DBNull.Value ? HttpUtility.HtmlEncode(r["ProfessionalBio"].ToString()) : "No bio available.";
                    string email = r["Email"] != DBNull.Value ? HttpUtility.HtmlEncode(r["Email"].ToString()) : "N/A";
                    string mobile = r["Mobile"] != DBNull.Value ? HttpUtility.HtmlEncode(r["Mobile"].ToString()) : "N/A";
                    string linkedIn = r["LinkedInProfile"] != DBNull.Value ? HttpUtility.HtmlEncode(r["LinkedInProfile"].ToString()) : "";
                    string experience = r["YearsOfExperience"] != DBNull.Value ? r["YearsOfExperience"].ToString() : "N/A";
                    string expertise = r["AreasOfExpertise"] != DBNull.Value ? HttpUtility.HtmlEncode(r["AreasOfExpertise"].ToString()) : "N/A";
                    string projects = r["CurrentWorkProjects"] != DBNull.Value ? HttpUtility.HtmlEncode(r["CurrentWorkProjects"].ToString()) : "N/A";

                    string imageUrl = ResolveUrl("~/Images/DefaultUser.png");
                    if (r["PhotoPath"] != DBNull.Value)
                    {
                        string pathFromDB = r["PhotoPath"].ToString();
                        if (!string.IsNullOrEmpty(pathFromDB))
                        {
                            imageUrl = ResolveUrl(pathFromDB);
                        }
                    }

                    double avgRating = r["AvgRating"] != DBNull.Value ? Convert.ToDouble(r["AvgRating"]) : 0;
                    int totalRatings = r["TotalRatings"] != DBNull.Value ? Convert.ToInt32(r["TotalRatings"]) : 0;
                    int rating5 = r["Rating5Count"] != DBNull.Value ? Convert.ToInt32(r["Rating5Count"]) : 0;
                    int rating4 = r["Rating4Count"] != DBNull.Value ? Convert.ToInt32(r["Rating4Count"]) : 0;
                    int rating3 = r["Rating3Count"] != DBNull.Value ? Convert.ToInt32(r["Rating3Count"]) : 0;
                    int rating2 = r["Rating2Count"] != DBNull.Value ? Convert.ToInt32(r["Rating2Count"]) : 0;
                    int rating1 = r["Rating1Count"] != DBNull.Value ? Convert.ToInt32(r["Rating1Count"]) : 0;

                    bool? isApproved = r["IsApprovedBySuperAdmin"] != DBNull.Value ? (bool?)Convert.ToBoolean(r["IsApprovedBySuperAdmin"]) : null;

                    // Build profile HTML for modal
                    string profileHtml = BuildProfileHtml(name, designation, company, bio, email, mobile, linkedIn, experience, expertise, projects, imageUrl);

                    sb.AppendFormat("<div class='speaker-card' data-speaker-id='{0}'>", speakerId);

                    // Speaker Header
                    sb.Append("<div class='speaker-header'>");
                    sb.AppendFormat("<img src='{0}' class='speaker-photo' alt='Speaker Photo' onerror=\"this.src='{1}'\" />",
                        imageUrl, ResolveUrl("~/Images/DefaultUser.png"));
                    sb.Append("<div class='speaker-info'>");
                    sb.AppendFormat("<h4>{0}</h4>", name);
                    sb.AppendFormat("<div class='speaker-meta'><i class='fas fa-briefcase'></i> {0} at {1}</div>", designation, company);
                    sb.AppendFormat("<div class='speaker-meta'><i class='fas fa-chart-line'></i> {0} years experience</div>", experience);
                    sb.Append("</div>");
                    sb.AppendFormat("<button type='button' class='btn-view-profile' onclick=\"showProfile(`{0}`)\"><i class='fas fa-user'></i> View Profile</button>", JSSafeString(profileHtml));
                    sb.Append("</div>");

                    // Rating Display
                    sb.Append("<div class='rating-display'>");
                    sb.AppendFormat("<div class='avg-rating'>{0:F1}<br/><span style='font-size: 14px; color: #f59e0b;'>★★★★★</span></div>", avgRating);
                    sb.Append("<div class='rating-breakdown'>");
                    sb.AppendFormat("<div style='margin-bottom: 8px;'><strong>{0} Advisor{1} Rated</strong></div>",
                        totalRatings, totalRatings == 1 ? "" : "s");
                    sb.Append(BuildRatingBar("5★", rating5, totalRatings));
                    sb.Append(BuildRatingBar("4★", rating4, totalRatings));
                    sb.Append(BuildRatingBar("3★", rating3, totalRatings));
                    sb.Append(BuildRatingBar("2★", rating2, totalRatings));
                    sb.Append(BuildRatingBar("1★", rating1, totalRatings));
                    sb.Append("</div>");
                    if (totalRatings > 0)
                    {
                        sb.AppendFormat("<button type='button' class='btn-view-comments' onclick='showComments({0}, {1})'><i class='fas fa-comments'></i> View Comments ({2})</button>",
                            speakerId, agendaId, totalRatings);
                    }
                    sb.Append("</div>");

                    // Decision Section
                    sb.Append("<div class='decision-section'>");
                    sb.Append("<strong style='display: block; margin-bottom: 10px;'><i class='fas fa-gavel'></i> Final Decision:</strong>");
                    sb.Append("<div class='decision-options'>");

                    // Approve Option
                    sb.Append("<div class='decision-option'>");
                    sb.AppendFormat("<input type='radio' name='decision_{0}' id='approve_{0}' value='1' {1} />",
                        speakerId, isApproved == true ? "checked" : "");
                    sb.AppendFormat("<label for='approve_{0}'><i class='fas fa-check-circle'></i> Approve</label>", speakerId);
                    sb.Append("</div>");

                    // Reject Option
                    sb.Append("<div class='decision-option reject'>");
                    sb.AppendFormat("<input type='radio' name='decision_{0}' id='reject_{0}' value='0' {1} />",
                        speakerId, isApproved == false ? "checked" : "");
                    sb.AppendFormat("<label for='reject_{0}'><i class='fas fa-times-circle'></i> Reject</label>", speakerId);
                    sb.Append("</div>");

                    // Hold Option
                    sb.Append("<div class='decision-option hold'>");
                    sb.AppendFormat("<input type='radio' name='decision_{0}' id='hold_{0}' value='-1' {1} />",
                        speakerId, isApproved == null ? "checked" : "");
                    sb.AppendFormat("<label for='hold_{0}'><i class='fas fa-pause-circle'></i> Hold</label>", speakerId);
                    sb.Append("</div>");

                    sb.Append("</div>"); // close decision-options
                    sb.Append("</div>"); // close decision-section

                    sb.Append("</div>"); // close speaker-card
                }

                // Action Buttons
                sb.Append("<div class='action-buttons'>");
                sb.AppendFormat("<button type='button' class='btn-cancel' onclick='collapseAgenda({0})'><i class='fas fa-times'></i> Cancel</button>", agendaId);
                sb.AppendFormat("<button type='button' class='btn-save-all' onclick='return saveAllDecisions({0})'><i class='fas fa-save'></i> Save All Decisions</button>", agendaId);
                sb.Append("</div>");

                pnlSpeakers.Controls.Add(new Literal { Text = sb.ToString() });
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadAgendaSpeakers ERROR: " + ex.ToString());
                pnlSpeakers.Controls.Add(new Literal { Text = "<div class='no-records'><i class='fas fa-exclamation-triangle'></i><p>Error loading speakers: " + HttpUtility.HtmlEncode(ex.Message) + "</p></div>" });
            }
        }

        private string BuildRatingBar(string label, int count, int total)
        {
            double percentage = total > 0 ? (count * 100.0 / total) : 0;
            return $@"
                <div class='rating-bar'>
                    <span style='width: 30px;'>{label}</span>
                    <div class='rating-bar-fill'>
                        <div class='rating-bar-fill-inner' style='width: {percentage}%'></div>
                    </div>
                    <span style='width: 60px; text-align: right;'>{count} ({percentage:F0}%)</span>
                </div>";
        }

        private string BuildProfileHtml(string name, string designation, string company, string bio,
            string email, string mobile, string linkedIn, string experience, string expertise, string projects, string imageUrl)
        {
            StringBuilder profile = new StringBuilder();
            profile.Append("<div style='padding: 20px;'>");
            profile.Append("<div style='text-align: center; margin-bottom: 20px;'>");
            profile.AppendFormat("<img src='{0}' style='width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 4px solid #e2e8f0;' />", imageUrl);
            profile.AppendFormat("<h3 style='margin: 15px 0 5px 0;'>{0}</h3>", name);
            profile.AppendFormat("<p style='color: #718096;'>{0} at {1}</p>", designation, company);
            profile.Append("</div>");

            profile.Append("<div style='background: #f7fafc; padding: 15px; border-radius: 8px; margin-bottom: 15px;'>");
            profile.Append("<h4 style='margin: 0 0 10px 0;'><i class='fas fa-info-circle'></i> Professional Bio</h4>");
            profile.AppendFormat("<p style='color: #4a5568; line-height: 1.6;'>{0}</p>", bio);
            profile.Append("</div>");

            profile.Append("<div style='display: grid; grid-template-columns: 1fr 1fr; gap: 15px;'>");
            profile.AppendFormat("<div><strong><i class='fas fa-envelope'></i> Email:</strong><br/>{0}</div>", email);
            profile.AppendFormat("<div><strong><i class='fas fa-phone'></i> Mobile:</strong><br/>{0}</div>", mobile);
            profile.AppendFormat("<div><strong><i class='fas fa-briefcase'></i> Experience:</strong><br/>{0}</div>", experience);
            if (!string.IsNullOrEmpty(linkedIn))
                profile.AppendFormat("<div><strong><i class='fab fa-linkedin'></i> LinkedIn:</strong><br/><a href='{0}' target='_blank'>View Profile</a></div>", linkedIn);
            profile.Append("</div>");

            profile.Append("<div style='margin-top: 15px;'>");
            profile.Append("<h4><i class='fas fa-lightbulb'></i> Areas of Expertise</h4>");
            profile.AppendFormat("<p style='color: #4a5568;'>{0}</p>", expertise);
            profile.Append("</div>");

            profile.Append("<div style='margin-top: 15px;'>");
            profile.Append("<h4><i class='fas fa-project-diagram'></i> Current Projects</h4>");
            profile.AppendFormat("<p style='color: #4a5568;'>{0}</p>", projects);
            profile.Append("</div>");

            profile.Append("</div>");
            return profile.ToString();
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            if (IsPostBack && Request.Form["__EVENTTARGET"] == "SaveDecisions")
            {
                try
                {
                    string jsonData = Request.Form["__EVENTARGUMENT"];
                    var serializer = new JavaScriptSerializer();
                    var data = serializer.Deserialize<Dictionary<string, object>>(jsonData);

                    int agendaId = Convert.ToInt32(data["agendaId"]);
                    var decisionsArray = (System.Collections.ArrayList)data["decisions"];

                    using (SqlConnection con = new SqlConnection(ConnectionString))
                    {
                        con.Open();
                        foreach (Dictionary<string, object> decision in decisionsArray)
                        {
                            int speakerId = Convert.ToInt32(decision["SpeakerID"]);
                            int decisionValue = Convert.ToInt32(decision["Decision"]);

                            bool? isApproved = decisionValue == 1 ? true : (decisionValue == 0 ? false : (bool?)null);

                            using (SqlCommand cmd = new SqlCommand("sp_UpdateSpeakerFinalApproval", con))
                            {
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                                cmd.Parameters.AddWithValue("@IsApprovedBySuperAdmin", isApproved.HasValue ? (object)isApproved.Value : DBNull.Value);
                                cmd.Parameters.AddWithValue("@AdminID", CurrentAdminID);
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }

                    litMessage.Text = "<div class='alert alert-success'><i class='fas fa-check-circle'></i> All decisions saved successfully!</div>";
                    ScriptManager.RegisterStartupScript(this, GetType(), "HideMessage", "setTimeout(function(){ var msg = document.querySelector('.alert'); if(msg) msg.style.display='none'; }, 3000);", true);

                    hdnExpandedAgendaID.Value = agendaId.ToString();
                    BindAgendas(txtSearch.Text.Trim(), hdnCurrentFilter.Value);
                    LoadStatusCounts();
                }
                catch (Exception ex)
                {
                    litMessage.Text = $"<div class='alert alert-danger'><i class='fas fa-exclamation-circle'></i> Error: {HttpUtility.HtmlEncode(ex.Message)}</div>";
                    System.Diagnostics.Debug.WriteLine("Decision Save Error: " + ex.ToString());
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "HideSpinner", "document.getElementById('loadingSpinner').classList.remove('show');", true);
            }
            else if (IsPostBack && Request.Form["__EVENTTARGET"] == "Toggle")
            {
                string agendaIdStr = Request.Form["__EVENTARGUMENT"];
                int clicked = 0;
                Int32.TryParse(agendaIdStr, out clicked);

                int current = 0;
                Int32.TryParse(hdnExpandedAgendaID.Value, out current);

                if (current == clicked)
                    hdnExpandedAgendaID.Value = "0";
                else
                    hdnExpandedAgendaID.Value = clicked.ToString();

                BindAgendas(txtSearch.Text.Trim(), hdnCurrentFilter.Value);
            }
        }

        [WebMethod]
        public static object GetSpeakerComments(int speakerId, int agendaId)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;
                StringBuilder html = new StringBuilder();

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAdvisoryCommentsForSpeaker", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                        cmd.Parameters.AddWithValue("@AgendaID", agendaId);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (!reader.HasRows)
                        {
                            html.Append("<p style='text-align: center; color: #a0aec0;'>No comments available</p>");
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

                                html.Append("<div class='comment-item'>");
                                html.Append("<div class='comment-header'>");
                                html.AppendFormat("<div class='comment-author'>{0}</div>", HttpUtility.HtmlEncode(advisorName));
                                html.AppendFormat("<div class='comment-rating'>{0} {1}/5</div>", stars, rating);
                                html.Append("</div>");
                                if (!string.IsNullOrEmpty(advisorDesignation) || !string.IsNullOrEmpty(advisorCompany))
                                    html.AppendFormat("<div class='comment-meta'>{0}{1}</div>",
                                        HttpUtility.HtmlEncode(advisorDesignation),
                                        !string.IsNullOrEmpty(advisorCompany) ? " at " + HttpUtility.HtmlEncode(advisorCompany) : "");
                                html.AppendFormat("<div class='comment-text'>{0}</div>", HttpUtility.HtmlEncode(comments));
                                html.AppendFormat("<div class='comment-meta'>{0}</div>", ratingDate.ToString("MMM dd, yyyy"));
                                html.Append("</div>");
                            }
                        }
                        reader.Close();
                    }
                }

                return new { success = true, html = html.ToString() };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetSpeakerComments Error: " + ex.ToString());
                return new { success = false, error = ex.Message };
            }
        }

        protected string GetStatusBadge(object statusCategoryObj)
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
                    return "<span class='status-badge badge-pending'>Unknown</span>";
            }
        }

        private string JSSafeString(string s)
        {
            if (string.IsNullOrEmpty(s))
                return "";
            return s.Replace("\\", "\\\\")
                    .Replace("`", "\\`")
                    .Replace("$", "\\$")
                    .Replace("\r", "")
                    .Replace("\n", " ");
        }
    }
}
