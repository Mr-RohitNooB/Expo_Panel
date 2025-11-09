<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdvisoryRatingDashboard.aspx.cs" Inherits="Expo_Panel.SuperAdmin.AdvisoryRatingDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Advisory Rating Dashboard - Expo Panel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <!-- Light Mode Favicons -->
    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" media="(prefers-color-scheme: light)" />
    <link rel="icon" type="image/png" sizes="16x16" href="/Images/favicon_io_Lubricant_India_Expo/favicon-16x16.png" media="(prefers-color-scheme: light)" />
    <link rel="apple-touch-icon" href="/Images/favicon_io_Lubricant_India_Expo/apple-touch-icon.png" media="(prefers-color-scheme: light)" />
    <link rel="shortcut icon" href="/Images/favicon_io_Lubricant_India_Expo/favicon.ico" media="(prefers-color-scheme: light)" />

    <!-- Dark Mode Favicons -->
    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" media="(prefers-color-scheme: dark)" />
    <link rel="icon" type="image/png" sizes="16x16" href="/Images/favicon_io_Lubricant_India_Expo/favicon-16x16.png" media="(prefers-color-scheme: dark)" />
    <link rel="apple-touch-icon" href="/Images/favicon_io_Lubricant_India_Expo/apple-touch-icon.png" media="(prefers-color-scheme: dark)" />
    <link rel="shortcut icon" href="/Images/favicon_io_Lubricant_India_Expo/favicon.ico" media="(prefers-color-scheme: dark)" />

    <!-- Android / PWA -->
    <link rel="icon" type="image/png" sizes="192x192" href="/Images/favicon_io_Lubricant_India_Expo/android-chrome-192x192.png" />
    <link rel="icon" type="image/png" sizes="512x512" href="/Images/favicon_io_Lubricant_India_Expo/android-chrome-512x512.png" />
    <link rel="manifest" href="/Images/favicon_io_Lubricant_India_Expo/site.webmanifest" />

    <!-- Theme Colors -->
    <meta name="theme-color" content="#ffffff" media="(prefers-color-scheme: light)" />
    <meta name="theme-color" content="#000000" media="(prefers-color-scheme: dark)" />

    <!-- Windows Tile Support -->
    <meta name="msapplication-TileColor" content="#ffffff" />

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px 30px;
            margin-bottom: 25px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

            .header h1 {
                color: #4f46e5;
                font-size: 28px;
                font-weight: 600;
            }

        .dashboard-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .search-box {
            display: flex;
            gap: 10px;
            flex: 1;
            max-width: 500px;
        }

        .form-control {
            padding: 10px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
            flex: 1;
        }

            .form-control:focus {
                outline: none;
                border-color: #667eea;
            }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: #4f46e5;
            color: white;
        }

            .btn-primary:hover {
                background: #4338ca;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(79, 70, 229, 0.4);
            }

        .btn-success {
            background: #10b981;
            color: white;
        }

            .btn-success:hover {
                background: #059669;
            }

        .btn-warning {
            background: #f59e0b;
            color: white;
        }

            .btn-warning:hover {
                background: #d97706;
            }

        .btn-danger {
            background: #ef4444;
            color: white;
        }

            .btn-danger:hover {
                background: #dc2626;
            }

        .btn-info {
            background: #0ea5e9;
            color: white;
        }

            .btn-info:hover {
                background: #0284c7;
            }

        .status-filters {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .btn-filter {
            padding: 10px 20px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            background: white;
            color: #475569;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }

            .btn-filter:hover {
                background: #f8fafc;
                border-color: #cbd5e1;
            }

            .btn-filter.active {
                background: #4f46e5;
                color: white;
                border-color: #4f46e5;
            }

        .grid-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

            table thead {
                background: #f8fafc;
            }

            table th {
                padding: 15px;
                text-align: left;
                font-weight: 600;
                color: #475569;
                border-bottom: 2px solid #e2e8f0;
            }

            table td {
                padding: 15px;
                border-bottom: 1px solid #e2e8f0;
                color: #334155;
            }

            table tbody tr:hover {
                background: #f8fafc;
            }

        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .alert-info {
            background: #dbeafe;
            color: #1e40af;
            border: 1px solid #bfdbfe;
        }

        .badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            white-space: nowrap; /* This prevents "Not Started" from wrapping */
        }


        .badge-rated {
            background: #d1fae5;
            color: #065f46;
        }

        .badge-pending {
            background: #fef3c7;
            color: #92400e;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(4px);
        }

            .modal.show {
                display: flex;
                justify-content: center;
                align-items: center;
            }

        .modal-content {
            background: white;
            border-radius: 15px;
            width: 90%;
            max-width: 900px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: modalSlideIn 0.3s ease-out;
            max-height: 90vh;
            overflow-y: auto;
        }

        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 15px;
        }

            .modal-header h2 {
                color: #4f46e5;
                font-size: 22px;
            }

        .close-btn {
            background: none;
            border: none;
            font-size: 28px;
            color: #6b7280;
            cursor: pointer;
        }

            .close-btn:hover {
                color: #ef4444;
            }

        .speaker-info {
            background: #f8fafc;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

            .speaker-info h3 {
                color: #1e293b;
                margin-bottom: 15px;
            }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            font-size: 12px;
            color: #64748b;
            font-weight: 500;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 14px;
            color: #1e293b;
            font-weight: 500;
        }

        .agenda-section {
            margin-top: 20px;
        }

        .agenda-card {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
        }

        .agenda-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 15px;
        }

        .agenda-title {
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
        }

        .agenda-meta {
            display: flex;
            gap: 15px;
            margin-top: 5px;
            font-size: 13px;
            color: #64748b;
        }

        .rating-section {
            border-top: 1px solid #e2e8f0;
            padding-top: 15px;
            margin-top: 15px;
        }

        .star-rating {
            display: flex;
            gap: 5px;
            margin-bottom: 10px;
        }

        .star {
            font-size: 32px;
            color: #cbd5e1;
            cursor: pointer;
            transition: all 0.2s;
        }

            .star:hover,
            .star.active {
                color: #fbbf24 !important;
            }

        .form-group {
            margin-bottom: 15px;
        }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #475569;
                font-weight: 500;
            }

            .form-group textarea {
                width: 100%;
                padding: 10px 15px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                font-family: 'Poppins', sans-serif;
                resize: vertical;
            }

                .form-group textarea:focus {
                    outline: none;
                    border-color: #667eea;
                }

        .no-records {
            text-align: center;
            padding: 40px;
            color: #94a3b8;
            font-size: 16px;
        }

        .current-rating {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: #fef3c7;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
        }

            .current-rating i {
                color: #fbbf24;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="container">
            <div class="header">
                <h1><i class="fas fa-star"></i>Advisory Rating Dashboard</h1>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <span>Welcome,
                        <asp:Label ID="lblAdvisorName" runat="server" Text=""></asp:Label></span>
                    <%--  <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="~/SuperAdmin/Dashboard.aspx" CssClass="btn btn-info">
        <i class="fas fa-arrow-left"></i> Back
                    </asp:HyperLink>--%>
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-danger" OnClick="btnLogout_Click" />
                </div>
            </div>

            <div class="dashboard-card">
                <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>




                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="status-filters">
                            <asp:Button ID="btnAll" runat="server" Text="All Agendas (0)" CssClass="btn-filter active"
                                OnClick="btnStatusFilter_Click" CommandArgument="All" />
                            <asp:Button ID="btnNotStarted" runat="server" Text="Not Started (0)" CssClass="btn-filter"
                                OnClick="btnStatusFilter_Click" CommandArgument="NotStarted" />
                            <asp:Button ID="btnFullyRated" runat="server" Text="Completed (0)" CssClass="btn-filter"
                                OnClick="btnStatusFilter_Click" CommandArgument="FullyRated" />
                            <asp:HiddenField ID="hdnCurrentFilter" runat="server" Value="All" />
                        </div>
                        <div class="toolbar">
                            <div class="search-box">
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                                    placeholder="Search by agenda title, track, day..."></asp:TextBox>
                                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary"
                                    OnClick="btnSearch_Click" />
                            </div>
                        </div>
                        <div class="grid-container">
                            <asp:GridView ID="gvAgendas" runat="server" AutoGenerateColumns="False"
                                OnRowCommand="gvAgendas_RowCommand" DataKeyNames="AgendaID"
                                CssClass="speakers-grid" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="AgendaID" HeaderText="ID" Visible="false" />

                                    <asp:TemplateField HeaderText="Sr. No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:BoundField DataField="Title" HeaderText="Agenda Title" />
                                    <asp:BoundField DataField="Day" HeaderText="Day" />
                                    <asp:BoundField DataField="Track" HeaderText="Track" />
                                    <asp:BoundField DataField="Time" HeaderText="Time" />

                                    <asp:TemplateField HeaderText="Speakers">
                                        <ItemTemplate>
                                            <span style="font-weight: 600; color: #4f46e5; white-space: nowrap;">
                                                <%# Convert.ToInt32(Eval("TotalSpeakers")) == 1 
                ? "1 Speaker" 
                : Eval("TotalSpeakers") + " Speakers" %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>



                                    <asp:TemplateField HeaderText="Progress">
                                        <ItemTemplate>
                                            <div style="display: flex; align-items: center; gap: 10px;">
                                                <div style="flex: 1; background: #e2e8f0; height: 8px; border-radius: 4px; overflow: hidden;">
                                                    <div style='width: <%# Eval("ProgressPercentage") %>%; background: #10b981; height: 100%;'></div>
                                                </div>
                                                <span style="font-size: 12px; color: #64748b; font-weight: 500;">
                                                    <%# Eval("RatedSpeakers") %>/<%# Eval("TotalSpeakers") %>
                                                </span>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <%# Convert.ToBoolean(Eval("IsFullyRated")) 
            ? "<span class='badge badge-rated'><i class='fas fa-check-circle'></i> Completed</span>" 
            : (Convert.ToInt32(Eval("RatedSpeakers")) > 0 
                ? "<span class='badge' style='background: #dbeafe; color: #1e40af;'><i class='fas fa-spinner'></i> In Progress</span>"
                : "<span class='badge badge-pending'><i class='fas fa-clock'></i> Not Started</span>") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>


                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:Button runat="server"
                                                Text='<%# Convert.ToBoolean(Eval("IsFullyRated")) ? "View Ratings" : "Rate Speakers" %>'
                                                CommandName="RateAgenda"
                                                CommandArgument='<%# Eval("AgendaID") %>'
                                                CssClass='<%# Convert.ToBoolean(Eval("IsFullyRated")) ? "btn btn-info" : "btn btn-success" %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="no-records">
                                        <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 15px; display: block;"></i>
                                        No agendas found.
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnAll" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="btnNotStarted" EventName="Click" />

                        <asp:AsyncPostBackTrigger ControlID="btnFullyRated" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>

        <!-- Rating Modal -->
        <!-- Rating Modal -->
        <div id="ratingModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2><i class="fas fa-calendar-alt"></i>Rate Speakers for Agenda</h2>
                    <button type="button" class="close-btn" onclick="closeRatingModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnAgendaID" runat="server" Value="0" />

                <!-- Agenda Information -->
                <div class="speaker-info">
                    <h3><i class="fas fa-info-circle"></i>Agenda Details</h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Title</span>
                            <span class="info-value" id="spanAgendaTitle"></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Day</span>
                            <span class="info-value" id="spanAgendaDay"></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Track</span>
                            <span class="info-value" id="spanAgendaTrack"></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Time</span>
                            <span class="info-value" id="spanAgendaTime"></span>
                        </div>
                        <div class="info-item" style="grid-column: 1 / -1;">
                            <span class="info-label">Brief</span>
                            <span class="info-value" id="spanAgendaBrief"></span>
                        </div>
                    </div>
                    <div style="margin-top: 15px; padding: 10px; background: #f0f9ff; border-radius: 8px; border-left: 4px solid #0ea5e9;">
                        <strong style="color: #0369a1;">Progress:</strong>
                        <span id="spanProgress" style="color: #0c4a6e; font-weight: 500;"></span>
                    </div>
                </div>

                <!-- Speakers Section -->
                <asp:UpdatePanel ID="upModalSpeakers" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="agenda-section">
                            <h3 style="margin-bottom: 15px;">
                                <i class="fas fa-users"></i>Speakers to Rate
                            </h3>
                            <asp:Literal ID="litSpeakerCards" runat="server"></asp:Literal>
                        </div>
                        <div class="modal-footer" style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; padding-top: 20px; border-top: 1px solid #e2e8f0;">
                            <button type="button" class="btn" onclick="closeRatingModal()" style="background: #e2e8f0; color: #475569;">Cancel</button>
                            <button type="button" class="btn btn-primary" onclick="submitAllRatings()">
                                <i class="fas fa-save"></i>Submit All Ratings
                            </button>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>

        <script type="text/javascript">
            function openRatingModal(agendaId, title, day, track, time, brief, ratedCount, totalCount) {
                console.log('Opening modal for agenda:', agendaId);

                document.getElementById('<%=hdnAgendaID.ClientID%>').value = agendaId;
                document.getElementById('spanAgendaTitle').innerText = title;
                document.getElementById('spanAgendaDay').innerText = day;
                document.getElementById('spanAgendaTrack').innerText = track;
                document.getElementById('spanAgendaTime').innerText = time;
                document.getElementById('spanAgendaBrief').innerText = brief || 'No description available';
                document.getElementById('spanProgress').innerText = ratedCount + ' of ' + totalCount + ' speakers rated';

                // Debug: Check if speaker cards are loaded
                var speakerCards = document.querySelectorAll('.agenda-card[data-speaker-id]');
                console.log('Speaker cards found:', speakerCards.length);

                if (speakerCards.length === 0) {
                    console.error('No speaker cards found in DOM!');
                }

                document.getElementById('ratingModal').classList.add('show');
            }

            function closeRatingModal() {
                document.getElementById('ratingModal').classList.remove('show');
            }

            function setRating(speakerId, rating) {
                // Set the hidden field value
                var hiddenField = document.getElementById('hdnRating_' + speakerId);
                if (hiddenField) {
                    hiddenField.value = rating;
                }

                // Update star display
                var starsContainer = document.getElementById('stars_' + speakerId);
                if (starsContainer) {
                    var stars = starsContainer.querySelectorAll('i');
                    stars.forEach(function (star, index) {
                        if (index < rating) {
                            star.classList.add('active');
                        } else {
                            star.classList.remove('active');
                        }
                    });
                }
            }

            function hoverStars(speakerId, rating) {
                var starsContainer = document.getElementById('stars_' + speakerId);
                if (starsContainer) {
                    var stars = starsContainer.querySelectorAll('i');
                    stars.forEach(function (star, index) {
                        if (index < rating) {
                            star.style.color = '#fbbf24';
                        } else {
                            star.style.color = '#cbd5e1';
                        }
                    });
                }
            }

            function resetStars(speakerId) {
                var hiddenField = document.getElementById('hdnRating_' + speakerId);
                var currentRating = hiddenField ? parseInt(hiddenField.value) || 0 : 0;

                var starsContainer = document.getElementById('stars_' + speakerId);
                if (starsContainer) {
                    var stars = starsContainer.querySelectorAll('i');
                    stars.forEach(function (star, index) {
                        if (index < currentRating) {
                            star.classList.add('active');
                            star.style.color = '#fbbf24';
                        } else {
                            star.classList.remove('active');
                            star.style.color = '#cbd5e1';
                        }
                    });
                }
            }

            function submitAllRatings() {
                var agendaId = document.getElementById('<%=hdnAgendaID.ClientID%>').value;
                var ratingsData = [];

                var speakerCards = document.querySelectorAll('.agenda-card[data-speaker-id]');
                var allValid = true;
                var firstInvalidCard = null;

                speakerCards.forEach(function (card) {
                    var speakerId = card.getAttribute('data-speaker-id');
                    var ratingField = document.getElementById('hdnRating_' + speakerId);
                    var commentsField = document.getElementById('txtComments_' + speakerId);

                    var rating = ratingField ? ratingField.value : '0';
                    var comments = commentsField ? commentsField.value : '';

                    if (!rating || rating == '0') {
                        allValid = false;
                        if (firstInvalidCard == null) {
                            firstInvalidCard = card;
                        }
                    }

                    ratingsData.push({
                        SpeakerID: speakerId,
                        Rating: rating,
                        Comments: comments
                    });
                });

                if (!allValid) {
                    alert('Please provide a rating (1-5 stars) for all speakers before submitting.');
                    if (firstInvalidCard) {
                        firstInvalidCard.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                    return;
                }

                // Use __doPostBack to submit via ASP.NET
                __doPostBack('SubmitRatings', JSON.stringify({ agendaId: agendaId, ratings: ratingsData }));
            }

            window.onclick = function (event) {
                var modal = document.getElementById('ratingModal');
                if (event.target == modal) {
                    closeRatingModal();
                }
            }
        </script>
    </form>
</body>
</html>
