using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Expo_Panel.SuperAdmin
{
    public partial class AdvisoryRatingDashboard : System.Web.UI.Page
    {
        // ... ConnectionString and CurrentAdvisorID properties are UNCHANGED ...
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString; }
        }

        private int CurrentAdvisorID
        {
            get
            {
                if (Session["AdvisorID"] != null)
                    return Convert.ToInt32(Session["AdvisorID"]);
                if (Session["AdminAdvisorID"] != null)
                    return Convert.ToInt32(Session["AdminAdvisorID"]);
                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsAdvisorLoggedIn())
            {
                Response.Redirect("~/User/AdvisoryLogin.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                bool isLinked = CheckIfAdvisorIsLinked(CurrentAdvisorID);
                btnLogout.Visible = !isLinked;

                if (Session["AdvisorUsername"] != null)
                {
                    lblAdvisorName.Text = Session["AdvisorUsername"].ToString();
                }
                else if (Session["AdminUsername"] != null)
                {
                    lblAdvisorName.Text = Session["AdminUsername"].ToString();
                }
                else
                {
                    lblAdvisorName.Text = "Admin";
                }

                hdnCurrentFilter.Value = "All";
                LoadStatusCounts();
                BindAgendas(string.Empty, "All");
            }
            else
            {
                // ✅ NEW: Handle postback after rating save
                if (Session["ReloadAfterRating"] != null && (bool)Session["ReloadAfterRating"])
                {
                    // Restore the expanded agenda ID
                    if (Session["ExpandedAgendaAfterRating"] != null)
                    {
                        hdnExpandedAgendaID.Value = Session["ExpandedAgendaAfterRating"].ToString();
                    }

                    // Reload fresh data from database
                    LoadStatusCounts();
                    BindAgendas(txtSearch.Text.Trim(), hdnCurrentFilter.Value);

                    // Clear the session flags so it doesn't reload again
                    Session.Remove("ReloadAfterRating");
                    Session.Remove("ExpandedAgendaAfterRating");
                }
            }
        }


        // ... IsAdvisorLoggedIn, btnLogout_Click, CheckIfAdvisorIsLinked are UNCHANGED ...
        private bool IsAdvisorLoggedIn()
        {
            return CurrentAdvisorID > 0;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/User/AdvisoryLogin.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private bool CheckIfAdvisorIsLinked(int advisorId)
        {
            if (advisorId == 0) return false;

            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("SELECT LinkedAdminID FROM TBL.Advisory WHERE AdvisorID = @AdvisorID", con))
                    {
                        cmd.Parameters.AddWithValue("@AdvisorID", advisorId);
                        con.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            return (Convert.ToInt32(result) > 0);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("CheckIfAdvisorIsLinked Error: " + ex.ToString());
            }

            return false;
        }


        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                string searchText = txtSearch.Text.Trim();
                string currentFilter = hdnCurrentFilter.Value;

                // NEW: Reset expanded agenda on search
                hdnExpandedAgendaID.Value = "0";

                // RENAMED: from LoadAgendas
                BindAgendas(searchText, currentFilter);
                LoadStatusCounts(); // No change here
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

            // ... logic to set active class is UNCHANGED ...
            btnAll.CssClass = "btn-filter";
            btnNotStarted.CssClass = "btn-filter";
            btnFullyRated.CssClass = "btn-filter";
            btn.CssClass = "btn-filter active";

            // Store current filter
            hdnCurrentFilter.Value = filterStatus;

            // Clear search box
            txtSearch.Text = string.Empty;

            // NEW: Reset expanded agenda on filter click
            hdnExpandedAgendaID.Value = "0";

            // RENAMED: from LoadAgendas
            BindAgendas(string.Empty, filterStatus);
            LoadStatusCounts();
        }

        // ... LoadStatusCounts is UNCHANGED ...
        private void LoadStatusCounts()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAdvisoryAgendaRatingStatusCounts", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AdvisorID", CurrentAdvisorID);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            int totalAgendas = reader["TotalAgendas"] != DBNull.Value ? Convert.ToInt32(reader["TotalAgendas"]) : 0;
                            int fullyRated = reader["FullyRatedAgendas"] != DBNull.Value ? Convert.ToInt32(reader["FullyRatedAgendas"]) : 0;
                            int notStarted = reader["NotStartedAgendas"] != DBNull.Value ? Convert.ToInt32(reader["NotStartedAgendas"]) : 0;

                            btnAll.Text = $"All Agendas ({totalAgendas})";
                            btnFullyRated.Text = $"Completed ({fullyRated})";
                            btnNotStarted.Text = $"Not Started ({notStarted})";
                        }
                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadStatusCounts Error: " + ex.ToString());
                btnAll.Text = "All Agendas (0)";
                btnFullyRated.Text = "Completed (0)";
                btnNotStarted.Text = "Not Started (0)";
            }
        }

        // UPDATED: This function is RENAMED from LoadAgendas and completely changed.
        private void BindAgendas(string searchText, string ratingFilter)
        {
            try
            {
                DataTable dt = new DataTable();

                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    // This stored procedure call is UNCHANGED
                    using (SqlCommand cmd = new SqlCommand("sp_GetAgendasForAdvisoryRating", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AdvisorID", CurrentAdvisorID);
                        cmd.Parameters.AddWithValue("@SearchText", string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText);
                        cmd.Parameters.AddWithValue("@RatingFilter", string.IsNullOrEmpty(ratingFilter) || ratingFilter == "All" ? (object)DBNull.Value : ratingFilter);

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

                    // NEW: Bind the data to the Repeater.
                    // This tells the Repeater to create a new row for each item in the DataTable.
                    rptAgendas.DataSource = dt;
                    rptAgendas.DataBind();
                }
                else
                {
                    pnlNoRecords.Visible = true;
                    // NEW: Clear the repeater if there are no records
                    rptAgendas.DataSource = null;
                    rptAgendas.DataBind();
                }

                // REMOVED: All the old StringBuilder logic, litAgendaItems.Text, 
                // and the ScriptManager.RegisterStartupScript for re-expansion
                // are GONE. The Repeater handles this automatically.
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadAgendas Error: " + ex.ToString());
                pnlNoRecords.Visible = true;
                rptAgendas.DataSource = null;
                rptAgendas.DataBind();
            }
        }

        protected void rptAgendas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Toggle")
            {
                int clicked = Convert.ToInt32(e.CommandArgument);
                int current = 0;
                Int32.TryParse(hdnExpandedAgendaID.Value, out current);

                // Toggle expand/collapse
                if (current == clicked)
                    hdnExpandedAgendaID.Value = "0";
                else
                    hdnExpandedAgendaID.Value = clicked.ToString();

                // ✅ Correct BindAgendas call
                // Use *current search text* and *current filter*
                BindAgendas(txtSearch.Text.Trim(), hdnCurrentFilter.Value);
            }
        }


        protected void rptAgendas_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // We only care about the data rows (not header, footer, etc.)
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Get the data for the *current* row being bound

                DataRowView drv = (DataRowView)e.Item.DataItem;
                int agendaId = Convert.ToInt32(drv["AgendaID"]);

                int expandedAgendaId = 0;
                Int32.TryParse(hdnExpandedAgendaID.Value, out expandedAgendaId);
                System.Diagnostics.Debug.WriteLine($"ItemDataBound → AgendaRow: {agendaId}, ExpandedAgendaID: {expandedAgendaId}");

                // This is the magic: Is this row the one we just clicked?
                if (agendaId == expandedAgendaId)
                {
                    // If YES:
                    // 1. Find the <asp:Panel> we put in the template
                    Panel pnlSpeakers = (Panel)e.Item.FindControl("pnlSpeakers");
                    if (pnlSpeakers != null)
                    {
                        // 2. The panel is already visible (due to Visible='<%# ... %>')
                        //    so we just need to load the speakers into it.
                        LoadAgendaSpeakers(agendaId, pnlSpeakers);
                    }
                }
                // If NO, this method does nothing, and the panel remains hidden.
            }
        }

        private void LoadAgendaSpeakers(int agendaId, Panel pnlSpeakers)
        {
            try
            {
                pnlSpeakers.Controls.Clear();
                DataTable dt = new DataTable();

                using (SqlConnection con = new SqlConnection(ConnectionString))
                using (SqlCommand cmd = new SqlCommand("sp_GetSpeakersForAgendaRating", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@AdvisorID", CurrentAdvisorID);
                    cmd.Parameters.AddWithValue("@AgendaID", agendaId);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        con.Open();
                        da.Fill(dt);
                    }
                }

                System.Diagnostics.Debug.WriteLine($"LoadAgendaSpeakers called for AgendaID={agendaId}. Rows={dt.Rows.Count}");

                if (dt.Rows.Count == 0)
                {
                    pnlSpeakers.Controls.Add(new Literal
                    {
                        Text = $"<div id='speakers_{agendaId}'><div class='no-speakers'>No speakers for this agenda.</div></div>"
                    });
                    return;
                }

                StringBuilder sb = new StringBuilder();
                sb.AppendFormat("<div id='speakers_{0}'>", agendaId); // NEW: Add wrapper with ID
                //sb.Append("<div class='speakers-list'>");
                sb.Append("<div class='speakers-grid'>");

                foreach (DataRow r in dt.Rows)
                {
                    int speakerId = Convert.ToInt32(r["SpeakerID"]);
                    string name = HttpUtility.HtmlEncode(r["Name"].ToString());
                    string designation = HttpUtility.HtmlEncode(r["Designation"].ToString());
                    string company = HttpUtility.HtmlEncode(r["Company"].ToString());

                    // Get all the new fields and handle DBNull
                    string bio = r["ProfessionalBio"] != DBNull.Value ? r["ProfessionalBio"].ToString() : "No bio available.";
                    string email = r["Email"] != DBNull.Value ? r["Email"].ToString() : "N/A";
                    string mobile = r["Mobile"] != DBNull.Value ? r["Mobile"].ToString() : "N/A";
                    string linkedIn = r["LinkedInProfile"] != DBNull.Value ? r["LinkedInProfile"].ToString() : "";
                    string experience = r["YearsOfExperience"] != DBNull.Value ? r["YearsOfExperience"].ToString() + " years" : "N/A";
                    string expertise = r["AreasOfExpertise"] != DBNull.Value ? r["AreasOfExpertise"].ToString() : "N/A";
                    string projects = r["CurrentWorkProjects"] != DBNull.Value ? r["CurrentWorkProjects"].ToString() : "N/A";
                    string imageUrl = "/Images/DefaultUser.png";
                    if (r["PhotoPath"] != DBNull.Value)
                    {
                        string pathFromDB = r["PhotoPath"].ToString();
                        if (!string.IsNullOrEmpty(pathFromDB))
                        {
                            // This handles ASP.NET virtual paths like '~/Uploads/image.png'
                            // and converts them to '/Uploads/image.png' for the browser.
                            if (pathFromDB.StartsWith("~"))
                            {
                                imageUrl = VirtualPathUtility.ToAbsolute(pathFromDB);
                            }
                            else
                            {
                                imageUrl = pathFromDB; // Assumes it's already a correct path
                            }
                        }
                    }

                    int currentRating = r["MyRating"] != DBNull.Value ? Convert.ToInt32(r["MyRating"]) : 0;
                    string currentComments = r["MyComments"] != DBNull.Value ? r["MyComments"].ToString() : "";

                    sb.AppendFormat("<div class='speaker-card' data-speaker-id='{0}'>", speakerId);
                    sb.Append("  <div class='speaker-header'>");
                    sb.Append("    <div class='speaker-info'>");
                    sb.AppendFormat("      <div class='speaker-name'>{0}</div>", name);
                    sb.Append("      <div class='speaker-meta'>");
                    sb.AppendFormat("        <span><i class='fas fa-briefcase'></i> {0}</span>", designation);
                    sb.AppendFormat("        <span><i class='fas fa-building'></i> {0}</span>", company);
                    sb.Append("      </div>");
                    sb.Append("    </div>");
                    sb.Append("    <div class='speaker-actions'>");
                    if (currentRating > 0)
                    {
                        sb.AppendFormat("    <div class='current-rating'><i class='fas fa-star'></i> You rated: {0} stars</div>", currentRating);
                    }
                    sb.AppendFormat("<button type='button' class='btn btn-info' " +
                                 "onclick='showSpeakerProfile(\"{0}\", \"{1}\", \"{2}\", \"{3}\", \"{4}\", \"{5}\", \"{6}\", \"{7}\", \"{8}\", \"{9}\", \"{10}\")'>" +
                                 "<i class='fas fa-user'></i> View Profile</button>",
                                 JS_SafeString(name),
                                 JS_SafeString(designation),
                                 JS_SafeString(company),
                                 JS_SafeString(bio),
                                 JS_SafeString(imageUrl),
                                 JS_SafeString(email),
                                 JS_SafeString(mobile),
                                 JS_SafeString(linkedIn),
                                 JS_SafeString(experience),
                                 JS_SafeString(expertise),
                                 JS_SafeString(projects)
                                 );

                    sb.Append("    </div>");
                    sb.Append("  </div>");
                    sb.Append("  <div class='rating-section'>");
                    sb.Append("    <div class='form-group'>");
                    sb.Append("      <label>Your Rating</label>");
                    sb.AppendFormat("      <div class='star-rating' id='stars_{0}'>", speakerId);
                    sb.Append(BuildStarRatingHtml(speakerId, currentRating));
                    sb.Append("      </div>");
                    sb.AppendFormat("      <input type='hidden' id='hdnRating_{0}' value='{1}' />", speakerId, currentRating);
                    sb.Append("    </div>");
                    sb.Append("    <div class='form-group'>");
                    sb.AppendFormat("      <label for='txtComments_{0}'>Comments (Optional)</label>", speakerId);
                    sb.AppendFormat("      <textarea id='txtComments_{0}' class='form-control' rows='3' placeholder='Add your comments...'>{1}</textarea>",
                                      speakerId, HttpUtility.HtmlEncode(currentComments));
                    sb.Append("    </div>");
                    sb.Append("  </div>");
                    sb.Append("</div>");
                }

                sb.Append("</div>"); // close speakers-list
                sb.Append("</div>"); // NEW: close speakers wrapper

                sb.Append("<div class='save-ratings-section'>");
                sb.AppendFormat("<div id='validationMsg_{0}' class='alert alert-danger' style='display:none; width: 100%;'></div>", agendaId);
                sb.AppendFormat("<button type='button' class='btn btn-secondary' onclick='collapseAgenda({0})'><i class='fas fa-times'></i> Cancel</button>", agendaId);
                sb.AppendFormat("<button type='button' class='btn btn-success' onclick='return saveAgendaRatings({0});'><i class='fas fa-save'></i> Save All Ratings</button>", agendaId);
                sb.Append("</div>");

                pnlSpeakers.Controls.Add(new Literal { Text = sb.ToString() });
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadAgendaSpeakers ERROR: " + ex.ToString());
                pnlSpeakers.Controls.Add(new Literal { Text = "<div class='error'>Error loading speakers. Check debug output.</div>" });
            }
        }
        private string BuildStarRatingHtml(int speakerId, int currentRating)
        {
            StringBuilder stars = new StringBuilder();
            for (int i = 1; i <= 5; i++)
            {
                string activeClass = i <= currentRating ? " active" : "";
                stars.Append($"<i class='fas fa-star star{activeClass}' onclick='setRating({speakerId}, {i})' onmouseover='hoverStars({speakerId}, {i})' onmouseout='resetStars({speakerId})'></i>");
            }
            return stars.ToString();
        }

        // ... OnInit (for saving ratings) is UNCHANGED ...
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            if (IsPostBack && Request.Form["__EVENTTARGET"] == "SaveRatings")
            {
                try
                {
                    string jsonData = Request.Form["__EVENTARGUMENT"];
                    var serializer = new JavaScriptSerializer();
                    var data = serializer.Deserialize<Dictionary<string, object>>(jsonData);

                    int agendaId = Convert.ToInt32(data["agendaId"]);
                    var ratingsArray = (System.Collections.ArrayList)data["ratings"];

                    using (SqlConnection con = new SqlConnection(ConnectionString))
                    {
                        con.Open();

                        foreach (Dictionary<string, object> rating in ratingsArray)
                        {
                            int speakerId = Convert.ToInt32(rating["SpeakerID"]);
                            int ratingValue = Convert.ToInt32(rating["Rating"]);
                            string comments = rating.ContainsKey("Comments") ? rating["Comments"]?.ToString() ?? "" : "";

                            if (ratingValue > 0)
                            {
                                using (SqlCommand cmd = new SqlCommand("sp_SaveAdvisorySpeakerRating", con))
                                {
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.Parameters.AddWithValue("@AdvisorID", CurrentAdvisorID);
                                    cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                                    cmd.Parameters.AddWithValue("@AgendaID", agendaId);
                                    cmd.Parameters.AddWithValue("@Rating", ratingValue);
                                    cmd.Parameters.AddWithValue("@Comments", string.IsNullOrEmpty(comments) ? (object)DBNull.Value : comments);

                                    cmd.ExecuteNonQuery();
                                }
                            }
                        }
                    }

                    litMessage.Text = "<div class='alert alert-success'><i class='fas fa-check-circle'></i> All ratings saved successfully!</div>";

                    // ✅ Set session flags - Page_Load will handle the reload
                    Session["ReloadAfterRating"] = true;
                    Session["ExpandedAgendaAfterRating"] = agendaId;

                    // ❌ REMOVE these two lines - they're duplicates now
                    // LoadStatusCounts();
                    // BindAgendas(txtSearch.Text.Trim(), hdnCurrentFilter.Value);

                    ScriptManager.RegisterStartupScript(this, GetType(), "HideSpinner",
                        "document.getElementById('loadingSpinner').classList.remove('show');", true);
                }
                catch (Exception ex)
                {
                    litMessage.Text = $"<div class='alert alert-danger'><i class='fas fa-exclamation-circle'></i> Error: {ex.Message}</div>";
                    System.Diagnostics.Debug.WriteLine("Rating Submission Error: " + ex.ToString());

                    ScriptManager.RegisterStartupScript(this, GetType(), "HideSpinnerError",
                        "document.getElementById('loadingSpinner').classList.remove('show');", true);
                }
            }
        }


        // NEW: These are helper functions for the Repeater's <%# ... %> databinding syntax.
        // This keeps our ASPX file clean.

        protected string GetStatusBadge(object isFullyRatedObj, object ratedSpeakersObj)
        {
            bool isFullyRated = Convert.ToBoolean(isFullyRatedObj);
            int ratedSpeakers = Convert.ToInt32(ratedSpeakersObj);

            if (isFullyRated)
            {
                return "<span class='badge badge-rated'><i class='fas fa-check-circle'></i> Completed</span>";
            }
            else if (ratedSpeakers > 0)
            {
                return "<span class='badge badge-progress'><i class='fas fa-spinner'></i> In Progress</span>";
            }
            else
            {
                return "<span class='badge badge-pending'><i class='fas fa-clock'></i> Not Started</span>";
            }
        }
        private string JS_SafeString(string s)
        {
            if (string.IsNullOrEmpty(s))
                return "";

            return s.Replace("\\", "\\\\")
                    .Replace("'", "\\'")
                    .Replace("\"", "\\\"")
                    .Replace("\r", "\\r")
                    .Replace("\n", "\\n");
        }
        protected string GetProgressHtml(object progressPercentageObj, object ratedSpeakersObj, object totalSpeakersObj)
        {
            int progressPercentage = Convert.ToInt32(progressPercentageObj);
            int ratedSpeakers = Convert.ToInt32(ratedSpeakersObj);
            int totalSpeakers = Convert.ToInt32(totalSpeakersObj);

            return $@"
            <div class='progress-bar-container'>
                <div class='progress-bar'>
                    <div class='progress-fill' style='width: {progressPercentage}%'></div>
                </div>
                <span class='progress-text'>{ratedSpeakers}/{totalSpeakers}</span>
            </div>";
        }
    }
}