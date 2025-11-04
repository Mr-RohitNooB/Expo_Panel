using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
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
            // FIXED: More robust authentication check with detailed logging
            if (!IsAdminLoggedIn())
            {
                System.Diagnostics.Debug.WriteLine("Authentication failed - redirecting to login");
                System.Diagnostics.Debug.WriteLine($"Session IsAdminLoggedIn: {Session["IsAdminLoggedIn"]}");
                System.Diagnostics.Debug.WriteLine($"Session AdminID: {Session["AdminID"]}");

                // Use the correct login page path - update this to your actual login page
                Response.Redirect("~/Default.aspx", false);  // Change this to your actual login page
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
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
            }
            else
            {
                // IMPORTANT: On postback, maintain the current filter
                string currentFilter = hdnCurrentFilter.Value;
                if (string.IsNullOrEmpty(currentFilter))
                {
                    hdnCurrentFilter.Value = "NotRated";
                }
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
                System.Diagnostics.Debug.WriteLine($"LoadSpeakers called - SearchText: '{searchText}', Filter: '{ratingFilter}', AdminID: {CurrentAdminID}");

                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetApplicationsForAdvisoryRating", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@AdvisorID", CurrentAdminID);
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

                        // Debug: Log columns and first few rows
                        if (dt.Columns.Count > 0)
                        {
                            System.Diagnostics.Debug.WriteLine("Columns: " + string.Join(", ",
                                Array.ConvertAll(dt.Columns.Cast<DataColumn>().ToArray(), c => c.ColumnName)));
                        }

                        if (dt.Rows.Count > 0)
                        {
                            System.Diagnostics.Debug.WriteLine($"Sample data - First speaker: {dt.Rows[0]["SpeakerName"]}");
                        }

                        gvSpeakers.DataSource = dt;
                        gvSpeakers.DataBind();

                        // Show message if no data
                        if (dt.Rows.Count == 0)
                        {
                            string filterText = ratingFilter == "NotRated" ? "not rated" : "rated";
                            ShowMessage($"No {filterText} speakers found.", "info");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading speakers: " + ex.Message, "danger");
                System.Diagnostics.Debug.WriteLine("LoadSpeakers Error: " + ex.ToString());

                // Bind empty data to show empty template
                gvSpeakers.DataSource = new DataTable();
                gvSpeakers.DataBind();
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

                    // Escape for JavaScript
                    name = name.Replace("'", "\\'").Replace("\"", "\\\"");
                    email = email.Replace("'", "\\'").Replace("\"", "\\\"");
                    designation = designation.Replace("'", "\\'").Replace("\"", "\\\"");
                    company = company.Replace("'", "\\'").Replace("\"", "\\\"");
                    expertise = expertise.Replace("'", "\\'").Replace("\"", "\\\"");

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

                            agendaHtml.Append($"<div class='agenda-card' data-agenda-id='{agendaId}' style='border: 1px solid #ddd; padding: 15px; margin: 15px 0; border-radius: 5px;'>");

                            // Agenda Header
                            agendaHtml.Append("<div class='agenda-header' style='margin-bottom: 10px;'>");
                            agendaHtml.Append($"<h5 style='margin: 0;'>{title}</h5>");
                            agendaHtml.Append($"<small style='color: #666;'><strong>Day:</strong> {day} | <strong>Track:</strong> {track} | <strong>Time:</strong> {time}</small>");
                            agendaHtml.Append("</div>");

                            // Agenda Details
                            if (!string.IsNullOrEmpty(brief))
                            {
                                agendaHtml.Append("<div class='agenda-details' style='margin-bottom: 15px;'>");
                                agendaHtml.Append($"<p><strong>Brief:</strong> {brief}</p>");
                                agendaHtml.Append("</div>");
                            }

                            // Rating Section with Stars
                            agendaHtml.Append("<div class='rating-section' style='background: #f9f9f9; padding: 10px; border-radius: 5px; margin-bottom: 10px;'>");
                            agendaHtml.Append("<label style='display: block; margin-bottom: 8px;'><strong>Your Rating:</strong></label>");
                            agendaHtml.Append($"<div class='star-rating' id='stars_{agendaId}' style='font-size: 28px; display: flex; gap: 5px;'>");

                            // ...
                            for (int i = 1; i <= 5; i++)
                            {
                                // 1. Use 'active' class, not an inline style
                                string activeClass = i <= currentRating ? "active" : "";

                                // 2. Build the span with new JS events and no inline style
                                agendaHtml.Append($"<span class='star {activeClass}'");
                                agendaHtml.Append($" data-rating='{i}' data-agenda='{agendaId}'");
                                agendaHtml.Append($" onclick='setRating({agendaId}, {i})'"); // 3. Simplified onclick
                                agendaHtml.Append($" onmouseover='hoverStars({agendaId}, {i})'"); // 4. Added mouseover
                                agendaHtml.Append($" onmouseout='resetStars({agendaId})'"); // 5. Added mouseout
                                agendaHtml.Append(">★</span>");
                            }
                            // ...

                            agendaHtml.Append("</div>");
                            agendaHtml.Append($"<input type='hidden' id='hdnRating_{agendaId}' value='{currentRating}' />");

                            if (currentRating > 0)
                            {
                                agendaHtml.Append($"<p style='color: #28a745; font-weight: bold; margin: 8px 0;'>Current Rating: {currentRating}/5</p>");
                            }
                            agendaHtml.Append("</div>");

                            // Comments Section
                            agendaHtml.Append("<div class='comments-section' style='margin-bottom: 15px;'>");
                            agendaHtml.Append($"<label for='txtComments_{agendaId}' style='display: block; margin-bottom: 5px;'><strong>Comments (Optional):</strong></label>");
                            agendaHtml.Append($"<textarea id='txtComments_{agendaId}' class='form-control' rows='2' placeholder='Add your comments here...' style='width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;'>{currentComments}</textarea>");
                            agendaHtml.Append("</div>");



                            agendaHtml.Append("</div>"); // end agenda-card
                        }
                    }
                    else
                    {
                        agendaHtml.Append("<div class='alert alert-info' style='padding: 10px; background: #d1ecf1; border: 1px solid #bee5eb; border-radius: 4px; color: #0c5460;'>");
                        agendaHtml.Append("This speaker has not selected any agendas yet.");
                        agendaHtml.Append("</div>");
                    }

                    litAgendaCards.Text = agendaHtml.ToString();

                    // Register JavaScript functions
                    // Register JavaScript functions
                    // Register JavaScript functions
                    string script = $@"
    // (These three functions are for the stars UI)
    function setRating(agendaId, rating) {{
        document.getElementById('hdnRating_' + agendaId).value = rating;
        var stars = document.getElementById('stars_' + agendaId).querySelectorAll('.star');

        stars.forEach(function(star, index) {{
            if (index < rating) {{
                star.classList.add('active');
            }} else {{
                star.classList.remove('active');
            }}
        }});
    }}

    function hoverStars(agendaId, rating) {{
        var stars = document.getElementById('stars_' + agendaId).querySelectorAll('.star');

        stars.forEach(function(star, index) {{
            if (index < rating) {{
                star.classList.add('active');
            }} else {{
                star.classList.remove('active');
            }}
        }});
    }}

    function resetStars(agendaId) {{
        var rating = parseInt(document.getElementById('hdnRating_' + agendaId).value) || 0;
        var stars = document.getElementById('stars_' + agendaId).querySelectorAll('.star');

        stars.forEach(function(star, index) {{
            if (index < rating) {{
                star.classList.add('active');
            }} else {{
                star.classList.remove('active');
            }}
        }});
    }}

    // ▼▼▼ THIS IS THE NEW SUBMIT FUNCTION ▼▼▼
    function submitAllRatings() {{
        // Get the SpeakerID from the hidden field we set when opening the modal
        var speakerId = document.getElementById('{hdnSpeakerID.ClientID}').value;
        var ratingsData = [];

        var agendaCards = document.querySelectorAll('#upModalAgendas .agenda-card');
        var allValid = true;
        var firstInvalidCard = null;

        // Loop through each agenda card in the modal
        agendaCards.forEach(function(card) {{
            var agendaId = card.getAttribute('data-agenda-id');
            var rating = document.getElementById('hdnRating_' + agendaId).value;
            var comments = document.getElementById('txtComments_' + agendaId).value;

            // Validate: Check if a rating was given
            if (!rating || rating == '0') {{
                allValid = false;
                if(firstInvalidCard == null) {{
                    firstInvalidCard = card;
                }}
            }}

            // Add this agenda's data to our array
            ratingsData.push({{
                AgendaID: agendaId,
                Rating: rating,
                Comments: comments
            }});
        }});

        // If any agenda is not rated, show an error and stop
        if (!allValid) {{
            alert('Please provide a rating (1-5 stars) for all agendas before submitting.');
            if(firstInvalidCard) {{
                // Scroll the modal to the first agenda that needs a rating
                firstInvalidCard.scrollIntoView({{ behavior: 'smooth', block: 'center' }});
            }}
            return;
        }}

        // All good, prepare the data for sending
        var formData = new FormData();
        formData.append('action', 'submitAllRatings'); // New action name
        formData.append('speakerId', speakerId);
        formData.append('ratingsData', JSON.stringify(ratingsData)); // Send all ratings as a JSON string

        fetch(window.location.href, {{
            method: 'POST',
            body: formData
        }})
        .then(response => response.text())
        .then(data => {{
            if(data.includes('Success')) {{
                alert('All ratings submitted successfully!');
                closeRatingModal();
                // __doPostBack('UpdatePanel1', ''); // This will trigger the UpdatePanel to refresh
                window.location.reload(); // Easiest way to ensure grid is fresh
            }} else {{
                alert('Error: ' + data);
            }}
        }})
        .catch(error => {{
            alert('Error submitting ratings: ' + error);
        }});
    }}
";

                    ScriptManager.RegisterStartupScript(this, GetType(), "ratingFunctions_" + speakerId, script, true);
                    string modalScript = $@"
            openRatingModal({speakerId}, '{name}', '{email}', '{designation}', '{company}', '{experience}', '{expertise}');
        ";
                    ScriptManager.RegisterStartupScript(this, GetType(), "openModal_" + speakerId, modalScript, true);
                    upModalAgendas.Update();

                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading speaker for rating: " + ex.Message, "danger");
                System.Diagnostics.Debug.WriteLine("LoadSpeakerForRating Error: " + ex.ToString());
            }
        }



        // Handle AJAX rating submission
        // Handle AJAX rating submission
        protected void Page_PreRender(object sender, EventArgs e)
        {
            // Check for the new 'submitAllRatings' action
            if (Request.Form["action"] == "submitAllRatings")
            {
                try
                {
                    int speakerId = Convert.ToInt32(Request.Form["speakerId"]);
                    string ratingsDataJson = Request.Form["ratingsData"];

                    // Deserialize the JSON array from the client
                    var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                    var ratings = serializer.Deserialize<List<AgendaRatingData>>(ratingsDataJson);

                    // Loop through each rating submitted
                    foreach (var rating in ratings)
                    {
                        // Only submit if a rating was actually given
                        if (rating.Rating > 0)
                        {
                            // Call our existing DB method for each rating
                            SubmitRating(speakerId, rating.AgendaID, rating.Rating, rating.Comments);
                        }
                    }

                    Response.Clear();
                    Response.Write("Success"); // Send one success message after all are done
                    Context.ApplicationInstance.CompleteRequest();
                }
                catch (Exception ex)
                {
                    Response.Clear();
                    Response.Write("Error: " + ex.Message);
                    Context.ApplicationInstance.CompleteRequest();
                }
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

        // Helper class for deserializing JSON
        public class AgendaRatingData
        {
            public int AgendaID { get; set; }
            public int Rating { get; set; }
            public string Comments { get; set; }
        }
    }
}