using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
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

            System.Diagnostics.Debug.WriteLine("=== SESSION DEBUG ===");
            System.Diagnostics.Debug.WriteLine($"Session.SessionID: {Session?.SessionID}");
            System.Diagnostics.Debug.WriteLine($"Session['AdminID']: {Session?["AdminID"]}");
            System.Diagnostics.Debug.WriteLine($"Session['IsAdminLoggedIn']: {Session?["IsAdminLoggedIn"]}");
            System.Diagnostics.Debug.WriteLine($"CurrentAdminID Property: {CurrentAdminID}");
            // Handle AJAX rating submission FIRST, before anything else
            if (Request.Form["action"] == "submitRating")
            {
                HandleAjaxRatingSubmission();
                return; // Stop further processing
            }

            // FIXED: More robust authentication check with detailed logging
            if (!IsAdminLoggedIn())
            {
                System.Diagnostics.Debug.WriteLine("Authentication failed - redirecting to login");
                System.Diagnostics.Debug.WriteLine($"Session IsAdminLoggedIn: {Session["IsAdminLoggedIn"]}");
                System.Diagnostics.Debug.WriteLine($"Session AdminID: {Session["AdminID"]}");
                Response.Redirect("~/Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                System.Diagnostics.Debug.WriteLine("=== Page_Load - Initial Load ===");

                // Set admin name
                if (Session["AdminUsername"] != null)
                {
                    lblAdvisorName.Text = Session["AdminUsername"].ToString();
                }
                else
                {
                    lblAdvisorName.Text = "Unknown";
                }

                // Initialize filter
                hdnCurrentFilter.Value = "NotRated";

                // Load initial data
                LoadStatusCounts();
                LoadSpeakers(string.Empty, "NotRated");
                SetActiveFilterButton("NotRated");

                System.Diagnostics.Debug.WriteLine($"Initial load complete - Filter: {hdnCurrentFilter.Value}");
            }
            else
            {
                System.Diagnostics.Debug.WriteLine("=== Page_Load - PostBack ===");

                // IMPORTANT: On postback, maintain the current filter
                string currentFilter = hdnCurrentFilter.Value;
                if (string.IsNullOrEmpty(currentFilter))
                {
                    currentFilter = "NotRated";
                    hdnCurrentFilter.Value = currentFilter;
                }

                System.Diagnostics.Debug.WriteLine($"PostBack - Current Filter: {currentFilter}");

                // CRITICAL FIX: Reload data on postback with current filter
                // This ensures grid shows data after any postback
                LoadStatusCounts();
                LoadSpeakers(string.Empty, currentFilter);
                SetActiveFilterButton(currentFilter);
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
            Response.Redirect("~/Default.aspx", false);  // Change to your actual login page
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // IMPORTANT: Don't check authentication here again - it's already checked in Page_Load
            string searchText = txtSearch.Text.Trim();
            string currentFilter = hdnCurrentFilter.Value;

            LoadSpeakers(searchText, currentFilter);
            LoadStatusCounts();

            if (!string.IsNullOrEmpty(searchText))
            {
                ShowMessage($"Search results for '{searchText}' in {currentFilter} speakers", "info");
            }

            // Update the UpdatePanel
            UpdatePanel1.Update();
        }

        protected void btnStatusFilter_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string filterStatus = btn.CommandArgument;

            // Update hidden field
            hdnCurrentFilter.Value = filterStatus;

            // Clear search when changing filter
            txtSearch.Text = string.Empty;

            // Load data with new filter
            LoadSpeakers(string.Empty, filterStatus);
            LoadStatusCounts();
            SetActiveFilterButton(filterStatus);

            // Update the UpdatePanel
            UpdatePanel1.Update();
        }

        protected void gvSpeakers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "RateSpeaker")
            {
                int speakerId = Convert.ToInt32(e.CommandArgument);
                LoadSpeakerForRating(speakerId);
            }
        }

        private void LoadStatusCounts()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetAdvisoryRatingStatusCounts", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AdvisorID", CurrentAdminID);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            int totalSpeakers = Convert.ToInt32(reader["TotalSpeakers"]);
                            int ratedSpeakers = Convert.ToInt32(reader["RatedSpeakers"]);
                            int notRatedSpeakers = Convert.ToInt32(reader["NotRatedSpeakers"]);

                            btnNotRated.Text = $"Not Rated ({notRatedSpeakers})";
                            btnRated.Text = $"Rated ({ratedSpeakers})";
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading counts: " + ex.Message, "danger");
                System.Diagnostics.Debug.WriteLine("LoadStatusCounts Error: " + ex.ToString());
            }
        }

        private void SetActiveFilterButton(string activeFilter)
        {
            btnNotRated.CssClass = "btn-filter";
            btnRated.CssClass = "btn-filter";

            switch (activeFilter)
            {
                case "NotRated":
                    btnNotRated.CssClass = "btn-filter active";
                    break;
                case "Rated":
                    btnRated.CssClass = "btn-filter active";
                    break;
            }
        }

        private void LoadSpeakers(string searchText, string ratingFilter)
        {
            try
            {
                int currentAdminId = CurrentAdminID;

                System.Diagnostics.Debug.WriteLine($"=== LoadSpeakers Debug ===");
                System.Diagnostics.Debug.WriteLine($"CurrentAdminID: {currentAdminId}");
                System.Diagnostics.Debug.WriteLine($"SearchText: '{searchText}'");
                System.Diagnostics.Debug.WriteLine($"RatingFilter: '{ratingFilter}'");

                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetApplicationsForAdvisoryRating", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AdvisorID", currentAdminId);
                        cmd.Parameters.AddWithValue("@SearchText", string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : searchText);
                        cmd.Parameters.AddWithValue("@AgendaFilter", DBNull.Value);
                        cmd.Parameters.AddWithValue("@RatingFilter", string.IsNullOrEmpty(ratingFilter) ? (object)DBNull.Value : ratingFilter);

                        DataTable dt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            con.Open();
                            da.Fill(dt);
                        }

                        System.Diagnostics.Debug.WriteLine($"Rows returned: {dt.Rows.Count}");

                        // Debug: Print ALL column names
                        if (dt.Columns.Count > 0)
                        {
                            System.Diagnostics.Debug.WriteLine("=== Columns ===");
                            foreach (DataColumn col in dt.Columns)
                            {
                                System.Diagnostics.Debug.WriteLine($"  {col.ColumnName}");
                            }
                        }

                        // Debug: Print first 3 rows if they exist
                        if (dt.Rows.Count > 0)
                        {
                            System.Diagnostics.Debug.WriteLine("=== Data Sample ===");
                            for (int i = 0; i < Math.Min(3, dt.Rows.Count); i++)
                            {
                                DataRow row = dt.Rows[i];
                                System.Diagnostics.Debug.WriteLine($"Row {i + 1}:");
                                System.Diagnostics.Debug.WriteLine($"  SpeakerID: {row["SpeakerID"]}");
                                System.Diagnostics.Debug.WriteLine($"  SpeakerName: {row["SpeakerName"]}");
                                System.Diagnostics.Debug.WriteLine($"  SelectedAgendas: {row["SelectedAgendas"]}");
                                System.Diagnostics.Debug.WriteLine($"  HasRated: {row["HasRated"]}");
                                System.Diagnostics.Debug.WriteLine($"  AgendaCount: {row["AgendaCount"]}");
                            }
                        }

                        gvSpeakers.DataSource = dt;
                        gvSpeakers.DataBind();

                        System.Diagnostics.Debug.WriteLine($"GridView RowCount after bind: {gvSpeakers.Rows.Count}");

                        // Show message if no data
                        if (dt.Rows.Count == 0)
                        {
                            string filterText = ratingFilter == "NotRated" ? "not rated" : "rated";
                            ShowMessage($"No {filterText} speakers found.", "info");
                        }
                        else
                        {
                            litMessage.Text = string.Empty;
                        }

                        UpdatePanel1.Update();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading speakers: " + ex.Message, "danger");
                System.Diagnostics.Debug.WriteLine("LoadSpeakers Error: " + ex.ToString());

                gvSpeakers.DataSource = new DataTable();
                gvSpeakers.DataBind();
                UpdatePanel1.Update();
            }
        }
        private void LoadSpeakerForRating(int speakerId)
        {
            try
            {
                DataTable speakerDt = null;
                DataTable agendasDt = null;

                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    // Get speaker details
                    using (SqlCommand cmd = new SqlCommand("sp_GetSpeakerById", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                        speakerDt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(speakerDt);
                        }
                    }

                    // Get speaker's agendas with ratings
                    using (SqlCommand cmd = new SqlCommand("sp_GetSpeakerAgendasWithRatings", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AdvisorID", CurrentAdminID);
                        cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                        agendasDt = new DataTable();
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(agendasDt);
                        }
                    }
                }

                if (speakerDt.Rows.Count > 0)
                {
                    DataRow speaker = speakerDt.Rows[0];
                    string name = speaker["Name"].ToString();
                    string email = speaker["Email"].ToString();
                    string designation = speaker["Designation"].ToString();
                    string company = speaker["Company"].ToString();
                    string experience = speaker["YearsOfExperience"] != DBNull.Value ? speaker["YearsOfExperience"].ToString() : "N/A";
                    string expertise = speaker["AreasOfExpertise"] != DBNull.Value ? speaker["AreasOfExpertise"].ToString() : "Not specified";

                    // Escape for JavaScript - proper escaping
                    name = System.Web.HttpUtility.JavaScriptStringEncode(name);
                    email = System.Web.HttpUtility.JavaScriptStringEncode(email);
                    designation = System.Web.HttpUtility.JavaScriptStringEncode(designation);
                    company = System.Web.HttpUtility.JavaScriptStringEncode(company);
                    expertise = System.Web.HttpUtility.JavaScriptStringEncode(expertise);

                    // Build agenda cards HTML
                    StringBuilder agendaHtml = new StringBuilder();

                    if (agendasDt.Rows.Count > 0)
                    {
                        foreach (DataRow agenda in agendasDt.Rows)
                        {
                            int agendaId = Convert.ToInt32(agenda["AgendaID"]);
                            string title = Server.HtmlEncode(agenda["Title"].ToString());
                            string day = Server.HtmlEncode(agenda["Day"].ToString());
                            string track = Server.HtmlEncode(agenda["Track"].ToString());
                            string time = Server.HtmlEncode(agenda["Time"].ToString());
                            string brief = agenda["Brief"] != DBNull.Value ? Server.HtmlEncode(agenda["Brief"].ToString()) : "";
                            int currentRating = agenda["MyRating"] != DBNull.Value ? Convert.ToInt32(agenda["MyRating"]) : 0;
                            string currentComments = agenda["MyComments"] != DBNull.Value ? Server.HtmlEncode(agenda["MyComments"].ToString()) : "";

                            // Start agenda card
                            agendaHtml.Append("<div class='agenda-card'>");

                            // Agenda Header
                            agendaHtml.Append("<div class='agenda-header'>");
                            agendaHtml.Append("<div>");
                            agendaHtml.Append($"<div class='agenda-title'>{title}</div>");
                            agendaHtml.Append("<div class='agenda-meta'>");
                            agendaHtml.Append($"<span><i class='fas fa-calendar-day'></i> {day}</span>");
                            agendaHtml.Append($"<span><i class='fas fa-layer-group'></i> {track}</span>");
                            agendaHtml.Append($"<span><i class='fas fa-clock'></i> {time}</span>");
                            agendaHtml.Append("</div>");
                            agendaHtml.Append("</div>");

                            // Current rating badge
                            if (currentRating > 0)
                            {
                                agendaHtml.Append("<div class='current-rating'>");
                                agendaHtml.Append($"<i class='fas fa-star'></i> {currentRating}/5");
                                agendaHtml.Append("</div>");
                            }
                            else
                            {
                                agendaHtml.Append("<div class='current-rating'>");
                                agendaHtml.Append("<i class='fas fa-star'></i> 0/5");
                                agendaHtml.Append("</div>");
                            }

                            agendaHtml.Append("</div>"); // end agenda-header

                            // Agenda Brief
                            if (!string.IsNullOrEmpty(brief))
                            {
                                agendaHtml.Append($"<p style='color: #64748b; font-size: 14px; margin: 10px 0;'>{brief}</p>");
                            }

                            // Rating Section
                            agendaHtml.Append("<div class='rating-section'>");
                            agendaHtml.Append("<label style='display: block; margin-bottom: 8px; color: #475569; font-weight: 500;'>Rate this session:</label>");

                            // Star Rating - IMPORTANT: Use star-group-{agendaId} class
                            agendaHtml.Append($"<div class='star-rating star-group-{agendaId}'>");

                            for (int i = 1; i <= 5; i++)
                            {
                                string activeClass = i <= currentRating ? "active" : "";
                                // We remove the 'onclick' and add 'data-' attributes for the JavaScript to read
                                agendaHtml.Append($"<span class='star {activeClass}' data-rating='{i}' data-agenda-id='{agendaId}'>★</span>");
                            }

                            agendaHtml.Append("</div>"); // end star-rating
                            agendaHtml.Append($"<input type='hidden' id='hdnRating_{agendaId}' value='{currentRating}' />");

                            // Comments
                            agendaHtml.Append("<div class='form-group' style='margin-top: 15px;'>");
                            agendaHtml.Append("<label>Comments (Optional):</label>");
                            agendaHtml.Append($"<textarea id='txtComments_{agendaId}' rows='3' placeholder='Share your feedback about this session...'>{currentComments}</textarea>");
                            agendaHtml.Append("</div>");

                            // Submit Button
                            string buttonText = currentRating > 0 ? "Update Rating" : "Submit Rating";
                            string buttonIcon = currentRating > 0 ? "fa-edit" : "fa-paper-plane";
                            string buttonClass = currentRating > 0 ? "btn btn-warning" : "btn btn-primary";

                            agendaHtml.Append($"<button type='button' class='{buttonClass}' onclick='submitRating({speakerId}, {agendaId})' style='margin-top: 10px;'>");
                            agendaHtml.Append($"<i class='fas {buttonIcon}'></i> {buttonText}");
                            agendaHtml.Append("</button>");

                            agendaHtml.Append("</div>"); // end rating-section
                            agendaHtml.Append("</div>"); // end agenda-card
                        }
                    }
                    else
                    {
                        agendaHtml.Append("<div class='alert alert-info'>");
                        agendaHtml.Append("<i class='fas fa-info-circle'></i> ");
                        agendaHtml.Append("This speaker has not selected any agendas yet.");
                        agendaHtml.Append("</div>");
                    }

                    litAgendaCards.Text = agendaHtml.ToString();

                    // Register JavaScript for rating submission
                    string script = @"
                function submitRating(speakerId, agendaId) {
                    var rating = document.getElementById('hdnRating_' + agendaId).value;
                    var comments = document.getElementById('txtComments_' + agendaId).value;
                    
                    console.log('Submitting rating:', {speakerId, agendaId, rating, comments});
                    
                    if (!rating || rating == '0') {
                        alert('Please select a rating (1-5 stars)');
                        return;
                    }
                    
                    var formData = new FormData();
                    formData.append('action', 'submitRating');
                    formData.append('speakerId', speakerId);
                    formData.append('agendaId', agendaId);
                    formData.append('rating', rating);
                    formData.append('comments', comments);
                    
                    fetch(window.location.href, {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.text())
                    .then(data => {
                        console.log('Response:', data);
                        if(data.includes('Success')) {
                            alert('Rating submitted successfully!');
                            closeRatingModal();
                            window.location.reload();
                        } else {
                            alert('Error submitting rating. Please try again.');
                            console.error(data);
                        }
                    })
                    .catch(error => {
                        alert('Error submitting rating: ' + error);
                        console.error(error);
                    });
                }
            ";

                    ScriptManager.RegisterStartupScript(this, GetType(), "ratingFunctions", script, true);

                    // Open the modal - Call the function from ASPX
                    string modalScript = $@"
                openRatingModal(
                    {speakerId}, 
                    '{name}', 
                    '{email}', 
                    '{designation}', 
                    '{company}', 
                    '{experience}', 
                    '{expertise}'
                );
            ";
                    ScriptManager.RegisterStartupScript(this, GetType(), "openModal", modalScript, true);
                }
                else
                {
                    ShowMessage("Speaker not found.", "danger");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading speaker for rating: " + ex.Message, "danger");
                System.Diagnostics.Debug.WriteLine("LoadSpeakerForRating Error: " + ex.ToString());
            }
        }

        // Handle AJAX rating submission - NEW METHOD
        private void HandleAjaxRatingSubmission()
        {
            try
            {
                int speakerId = Convert.ToInt32(Request.Form["speakerId"]);
                int agendaId = Convert.ToInt32(Request.Form["agendaId"]);
                int rating = Convert.ToInt32(Request.Form["rating"]);
                string comments = Request.Form["comments"] ?? string.Empty;

                System.Diagnostics.Debug.WriteLine($"AJAX Rating: Speaker={speakerId}, Agenda={agendaId}, Rating={rating}");

                SubmitRating(speakerId, agendaId, rating, comments);

                Response.Clear();
                Response.ContentType = "text/plain";
                Response.Write("Success");
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("AJAX Error: " + ex.ToString());
                Response.Clear();
                Response.ContentType = "text/plain";
                Response.Write("Error: " + ex.Message);
                Response.Flush();
                Response.End();
            }
        }

        private void SubmitRating(int speakerId, int agendaId, int rating, string comments)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_SubmitAdvisorySpeakerRating", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@AdvisorID", CurrentAdminID);
                    cmd.Parameters.AddWithValue("@SpeakerID", speakerId);
                    cmd.Parameters.AddWithValue("@AgendaID", agendaId);
                    cmd.Parameters.AddWithValue("@Rating", rating);
                    cmd.Parameters.AddWithValue("@Comments", string.IsNullOrEmpty(comments) ? (object)DBNull.Value : comments);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void ShowMessage(string message, string type)
        {
            string cssClass = type == "success" ? "alert-success" :
                             type == "info" ? "alert-info" : "alert-danger";
            string icon = type == "success" ? "fa-check-circle" :
                         type == "info" ? "fa-info-circle" : "fa-exclamation-circle";

            litMessage.Text = $@"
                <div class='alert {cssClass}'>
                    <i class='fas {icon}'></i>
                    {message}
                </div>";
        }

        // IMPROVED: More detailed authentication check
        private bool IsAdminLoggedIn()
        {
            bool isLoggedIn = Session != null &&
                   Session["IsAdminLoggedIn"] != null &&
                   Session["IsAdminLoggedIn"].ToString() == "True" &&
                   Session["AdminID"] != null;

            System.Diagnostics.Debug.WriteLine($"IsAdminLoggedIn check: {isLoggedIn}");

            if (!isLoggedIn && Session != null)
            {
                System.Diagnostics.Debug.WriteLine("Session exists but authentication failed");
                System.Diagnostics.Debug.WriteLine($"  IsAdminLoggedIn: {Session["IsAdminLoggedIn"]}");
                System.Diagnostics.Debug.WriteLine($"  AdminID: {Session["AdminID"]}");
                System.Diagnostics.Debug.WriteLine($"  AdminUsername: {Session["AdminUsername"]}");
            }

            return isLoggedIn;
        }
    }
}