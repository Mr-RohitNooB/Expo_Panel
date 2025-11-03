using System;
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

                            agendaHtml.Append("<div class='agenda-card' style='border: 1px solid #ddd; padding: 15px; margin: 15px 0; border-radius: 5px;'>");

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

                            for (int i = 1; i <= 5; i++)
                            {
                                string activeClass = i <= currentRating ? "style='color: #ffc107;'" : "style='color: #ddd;'";
                                agendaHtml.Append($"<span class='star' data-rating='{i}' data-agenda='{agendaId}' {activeClass} onclick='setRating(this, {agendaId}, {i})' style='cursor: pointer; transition: color 0.2s;'>★</span>");
                            }

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

                            // Submit Button
                            agendaHtml.Append("<div class='rating-actions'>");
                            agendaHtml.Append($"<button class='btn btn-primary' type='button' onclick='submitRating({speakerId}, {agendaId})' style='padding: 8px 16px;'>");
                            agendaHtml.Append(currentRating > 0 ? "Update Rating" : "Submit Rating");
                            agendaHtml.Append("</button>");
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
                    string script = @"
                function setRating(element, agendaId, rating) {
                    // Update hidden field
                    document.getElementById('hdnRating_' + agendaId).value = rating;
                    
                    // Update all stars for this agenda
                    var starsContainer = document.getElementById('stars_' + agendaId);
                    var stars = starsContainer.querySelectorAll('.star');
                    
                    stars.forEach(function(star, index) {
                        if (index < rating) {
                            star.style.color = '#ffc107';
                        } else {
                            star.style.color = '#ddd';
                        }
                    });
                }

                function submitRating(speakerId, agendaId) {
                    var rating = document.getElementById('hdnRating_' + agendaId).value;
                    var comments = document.getElementById('txtComments_' + agendaId).value;
                    
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
                        if(data.includes('Success')) {
                            alert('Rating submitted successfully!');
                            closeRatingModal();
                            window.location.reload();
                        } else {
                            alert('Error: ' + data);
                        }
                    })
                    .catch(error => {
                        alert('Error submitting rating: ' + error);
                    });
                }
            ";

                    ScriptManager.RegisterStartupScript(this, GetType(), "ratingFunctions_" + speakerId, script, true);

                    // Open the modal
                    string modalScript = $@"
                document.getElementById('modalSpeakerName').textContent = '{name}';
                document.getElementById('modalEmail').textContent = '{email}';
                document.getElementById('modalDesignation').textContent = '{designation}';
                document.getElementById('modalCompany').textContent = '{company}';
                document.getElementById('modalExperience').textContent = '{experience}';
                document.getElementById('modalExpertise').textContent = '{expertise}';
                document.getElementById('ratingModal').style.display = 'block';
            ";
                    ScriptManager.RegisterStartupScript(this, GetType(), "openModal_" + speakerId, modalScript, true);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading speaker for rating: " + ex.Message, "danger");
                System.Diagnostics.Debug.WriteLine("LoadSpeakerForRating Error: " + ex.ToString());
            }
        }



        // Handle AJAX rating submission
        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Request.Form["action"] == "submitRating")
            {
                try
                {
                    int speakerId = Convert.ToInt32(Request.Form["speakerId"]);
                    int agendaId = Convert.ToInt32(Request.Form["agendaId"]);
                    int rating = Convert.ToInt32(Request.Form["rating"]);
                    string comments = Request.Form["comments"];

                    SubmitRating(speakerId, agendaId, rating, comments);

                    Response.Clear();
                    Response.Write("Success");
                    Response.End();
                }
                catch (Exception ex)
                {
                    Response.Clear();
                    Response.Write("Error: " + ex.Message);
                    Response.End();
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
    }
}