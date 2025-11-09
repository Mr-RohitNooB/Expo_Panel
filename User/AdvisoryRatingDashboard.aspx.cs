using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace Expo_Panel.SuperAdmin
{
    public partial class AdvisoryRatingDashboard : System.Web.UI.Page
    {
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
                // --- NEW LOGIC ---
                // Check the database for the link status
                bool isLinked = CheckIfAdvisorIsLinked(CurrentAdvisorID);

                // Set button visibility based on link status
                // If they ARE linked, the button is hidden.
                // If they are NOT linked, the button is visible.
                btnLogout.Visible = !isLinked;
                // --- END NEW LOGIC ---


                // Set username (this existing code is fine)
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
                    lblAdvisorName.Text = "admin";
                }

                hdnCurrentFilter.Value = "All";
                LoadStatusCounts();
                LoadAgendas(string.Empty, "All");
            }
        }

        private bool IsAdvisorLoggedIn()
        {
            return CurrentAdvisorID > 0;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // This button is NO LONGER VISIBLE for linked accounts.
            // Therefore, we only need the "regular advisor" logout logic.
            // All the 'wasAdmin' checks are no longer needed.

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
                    // --- THIS IS THE FIX ---
                    // Using the correct table TBL.Advisory as you confirmed.
                    using (SqlCommand cmd = new SqlCommand("SELECT LinkedAdminID FROM TBL.Advisory WHERE AdvisorID = @AdvisorID", con))
                    {
                        cmd.Parameters.AddWithValue("@AdvisorID", advisorId);
                        con.Open();
                        object result = cmd.ExecuteScalar();

                        // If LinkedAdminID is not NULL and > 0, they are linked.
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
                // On error, default to 'false' to be safe (which shows the logout button).
            }

            // Default to false (not linked)
            return false;
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                string searchText = txtSearch.Text.Trim();
                string currentFilter = hdnCurrentFilter.Value;
                LoadAgendas(searchText, currentFilter);
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

            // Remove 'active' class from all filter buttons
            btnAll.CssClass = "btn-filter";
            btnNotStarted.CssClass = "btn-filter";
            btnFullyRated.CssClass = "btn-filter";

            // Add 'active' class to clicked button
            btn.CssClass = "btn-filter active";

            // Store current filter
            hdnCurrentFilter.Value = filterStatus;

            // Clear search box
            txtSearch.Text = string.Empty;

            // Load agendas with filter
            LoadAgendas(string.Empty, filterStatus);
            LoadStatusCounts();
        }


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
                            int partiallyRated = reader["PartiallyRatedAgendas"] != DBNull.Value ? Convert.ToInt32(reader["PartiallyRatedAgendas"]) : 0;
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

        private void LoadAgendas(string searchText, string ratingFilter)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine($"LoadAgendas - Filter: {ratingFilter}, Search: '{searchText}', AdvisorID: {CurrentAdvisorID}");

                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAgendasForAdvisoryRating", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AdvisorID", CurrentAdvisorID);
                        cmd.Parameters.AddWithValue("@SearchText", string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText);
                        cmd.Parameters.AddWithValue("@RatingFilter", string.IsNullOrEmpty(ratingFilter) || ratingFilter == "All" ? (object)DBNull.Value : ratingFilter);

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            con.Open();
                            da.Fill(dt);
                        }

                        System.Diagnostics.Debug.WriteLine($"Rows returned: {dt.Rows.Count}");

                        gvAgendas.DataSource = dt;
                        gvAgendas.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadAgendas Error: " + ex.ToString());
                gvAgendas.DataSource = null;
                gvAgendas.DataBind();
            }
        }

        protected void gvAgendas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "RateAgenda")
            {
                try
                {
                    int agendaId = Convert.ToInt32(e.CommandArgument);
                    LoadAgendaSpeakersForRating(agendaId);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("RowCommand Error: " + ex.ToString());
                }
            }
        }

        private void LoadAgendaSpeakersForRating(int agendaId)
        {
            try
            {
                DataTable agendaDt = null;
                DataTable speakersDt = null;

                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    con.Open();

                    // Get agenda details
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT AgendaID, Title, Day, Track, Time, Brief FROM TBL.Agenda WHERE AgendaID = @AgendaID", con))
                    {
                        cmd.Parameters.AddWithValue("@AgendaID", agendaId);
                        agendaDt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(agendaDt);
                        }
                    }

                    // Get speakers for this agenda with ratings
                    using (SqlCommand cmd = new SqlCommand("sp_GetSpeakersForAgendaRating", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AdvisorID", CurrentAdvisorID);
                        cmd.Parameters.AddWithValue("@AgendaID", agendaId);

                        speakersDt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(speakersDt);
                        }
                    }
                }

                if (agendaDt != null && agendaDt.Rows.Count > 0 && speakersDt != null && speakersDt.Rows.Count > 0)
                {
                    DataRow agenda = agendaDt.Rows[0];
                    string title = agenda["Title"].ToString();
                    string day = agenda["Day"] != DBNull.Value ? agenda["Day"].ToString() : "TBD";
                    string track = agenda["Track"] != DBNull.Value ? agenda["Track"].ToString() : "TBD";
                    string time = agenda["Time"] != DBNull.Value ? agenda["Time"].ToString() : "TBD";
                    string brief = agenda["Brief"] != DBNull.Value ? agenda["Brief"].ToString() : "";

                    // Count rated speakers
                    int ratedCount = 0;
                    foreach (DataRow row in speakersDt.Rows)
                    {
                        if (row["MyRating"] != DBNull.Value && Convert.ToInt32(row["MyRating"]) > 0)
                            ratedCount++;
                    }
                    int totalCount = speakersDt.Rows.Count;

                    // Build speaker cards HTML
                    StringBuilder speakerHtml = new StringBuilder();

                    foreach (DataRow speaker in speakersDt.Rows)
                    {
                        int speakerId = Convert.ToInt32(speaker["SpeakerID"]);
                        string name = Server.HtmlEncode(speaker["Name"].ToString());
                        string email = speaker["Email"].ToString();
                        string designation = speaker["Designation"] != DBNull.Value ? Server.HtmlEncode(speaker["Designation"].ToString()) : "N/A";
                        string company = speaker["Company"] != DBNull.Value ? Server.HtmlEncode(speaker["Company"].ToString()) : "N/A";

                        int currentRating = speaker["MyRating"] != DBNull.Value ? Convert.ToInt32(speaker["MyRating"]) : 0;
                        string currentComments = speaker["MyComments"] != DBNull.Value ? speaker["MyComments"].ToString() : "";

                        // Escape for HTML
                        currentComments = Server.HtmlEncode(currentComments);

                        speakerHtml.Append($@"
            <div class='agenda-card' data-speaker-id='{speakerId}'>
                <div class='agenda-header'>
                    <div>
                        <div class='agenda-title'>{name}</div>
                        <div class='agenda-meta'>
                            <span><i class='fas fa-briefcase'></i> {designation}</span>
                            <span><i class='fas fa-building'></i> {company}</span>
                            <span><i class='fas fa-envelope'></i> {email}</span>
                        </div>
                    </div>
                    {(currentRating > 0 ? $"<span class='current-rating'><i class='fas fa-star'></i> {currentRating}/5</span>" : "")}
                </div>
                <div class='rating-section'>
                    <label>Rate this speaker (1-5 stars):</label>
                    <div class='star-rating' id='stars_{speakerId}'>
                        {BuildStarRatingHtml(speakerId, currentRating)}
                    </div>
                    <input type='hidden' id='hdnRating_{speakerId}' value='{currentRating}' />
                    <div class='form-group'>
                        <label>Comments:</label>
                        <textarea id='txtComments_{speakerId}' rows='3' placeholder='Add your comments here...'>{currentComments}</textarea>
                    </div>
                </div>
            </div>
        ");
                    }

                    hdnAgendaID.Value = agendaId.ToString();
                    litSpeakerCards.Text = speakerHtml.ToString();

                    System.Diagnostics.Debug.WriteLine($"Generated HTML length: {speakerHtml.Length}");
                    System.Diagnostics.Debug.WriteLine($"Speakers count: {speakersDt.Rows.Count}");

                    // Force UpdatePanel to update
                    upModalSpeakers.Update();

                    // Escape strings for JavaScript
                    string escapedTitle = title.Replace("'", "\\'").Replace("\r", "").Replace("\n", " ");
                    string escapedBrief = brief.Replace("'", "\\'").Replace("\r", "").Replace("\n", " ");

                    // Call JavaScript to show modal with delay
                    string modalScript = $@"
        console.log('About to open modal for agenda {agendaId}');
        setTimeout(function() {{
            console.log('Opening modal now...');
            openRatingModal({agendaId}, 
                '{escapedTitle}', 
                '{day}', 
                '{track}', 
                '{time}', 
                '{escapedBrief}', 
                {ratedCount}, 
                {totalCount});
        }}, 250);
    ";

                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowModal_" + agendaId, modalScript, true);
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine($"No data found - Agenda rows: {agendaDt?.Rows.Count ?? 0}, Speaker rows: {speakersDt?.Rows.Count ?? 0}");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadAgendaSpeakersForRating Error: " + ex.ToString());
                litMessage.Text = $"<div class='alert alert-danger'><i class='fas fa-exclamation-circle'></i> Error loading speakers: {ex.Message}</div>";
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


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object SaveRatings(int speakerId, List<AgendaRating> ratings)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["ExpoPanelDB"].ConnectionString;

                int advisorId = 0;
                if (System.Web.HttpContext.Current.Session["AdvisorID"] != null)
                    advisorId = Convert.ToInt32(System.Web.HttpContext.Current.Session["AdvisorID"]);
                else if (System.Web.HttpContext.Current.Session["AdminAdvisorID"] != null)
                    advisorId = Convert.ToInt32(System.Web.HttpContext.Current.Session["AdminAdvisorID"]);

                if (advisorId == 0)
                    return new { success = false, message = "Advisor ID not found" };

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    foreach (var rating in ratings)
                    {
                        if (rating.Rating > 0) // Only save if rating is provided
                        {
                            using (SqlCommand cmd = new SqlCommand("sp_SaveAdvisorySpeakerRating", con))
                            {
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.AddWithValue("@AdvisorID", advisorId);
                                cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                                cmd.Parameters.AddWithValue("@AgendaID", rating.AgendaID);
                                cmd.Parameters.AddWithValue("@Rating", rating.Rating);
                                cmd.Parameters.AddWithValue("@Comments", string.IsNullOrEmpty(rating.Comments) ? (object)DBNull.Value : rating.Comments);

                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }

                return new { success = true, message = "Ratings saved successfully!" };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("SaveRatings Error: " + ex.ToString());
                return new { success = false, message = "Error: " + ex.Message };
            }
        }

        public class AgendaRating
        {
            public int AgendaID { get; set; }
            public int Rating { get; set; }
            public string Comments { get; set; }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            // Handle rating submission
            if (IsPostBack && Request.Form["__EVENTTARGET"] == "SubmitRatings")
            {
                try
                {
                    string jsonData = Request.Form["__EVENTARGUMENT"];

                    // Parse JSON manually
                    var serializer = new JavaScriptSerializer();
                    var data = serializer.Deserialize<Dictionary<string, object>>(jsonData);

                    int agendaId = Convert.ToInt32(data["agendaId"]);
                    var ratingsArray = (ArrayList)data["ratings"];

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
                    LoadAgendas(string.Empty, hdnCurrentFilter.Value);
                    LoadStatusCounts();
                }
                catch (Exception ex)
                {
                    litMessage.Text = $"<div class='alert alert-danger'><i class='fas fa-exclamation-circle'></i> Error: {ex.Message}</div>";
                    System.Diagnostics.Debug.WriteLine("Rating Submission Error: " + ex.ToString());
                }
            }
        }
    }
}
