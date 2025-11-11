<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FinalSpeakerSelection.aspx.cs" 
    Inherits="Expo_Panel.SuperAdmin.FinalSpeakerSelection" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Final Speaker Selection Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #f4f7fc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; }
        .admin-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; color: white; 
            display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .admin-header h2 { margin: 0; font-weight: 600; }
        .admin-header .admin-info { display: flex; align-items: center; gap: 15px; }
        .btn-logout { background: rgba(255,255,255,0.2); border: 1px solid white; color: white; padding: 8px 20px; 
            border-radius: 5px; cursor: pointer; transition: all 0.3s; }
        .btn-logout:hover { background: white; color: #667eea; }
        .dashboard-container { max-width: 1400px; margin: 30px auto; padding: 0 20px; }
        .filter-section { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .filter-buttons { display: flex; gap: 15px; margin-bottom: 20px; flex-wrap: wrap; }
        .btn-filter { padding: 12px 24px; border: 2px solid #e0e6ed; background: white; border-radius: 8px; cursor: pointer; 
            font-weight: 500; transition: all 0.3s; display: flex; align-items: center; gap: 8px; }
        .btn-filter:hover { border-color: #667eea; color: #667eea; transform: translateY(-2px); }
        .btn-filter.active { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-color: #667eea; }
        .search-box { display: flex; gap: 10px; }
        .search-box input { flex: 1; padding: 12px; border: 2px solid #e0e6ed; border-radius: 8px; font-size: 14px; }
        .search-box button { padding: 12px 24px; background: #667eea; color: white; border: none; border-radius: 8px; 
            cursor: pointer; font-weight: 500; }
        .search-box button:hover { background: #5568d3; }
        .agenda-card { background: white; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); 
            margin-bottom: 20px; overflow: hidden; transition: all 0.3s; }
        .agenda-card:hover { box-shadow: 0 4px 20px rgba(0,0,0,0.12); }
        .agenda-header { padding: 20px; cursor: pointer; display: flex; justify-content: space-between; align-items: center; }
        .agenda-header:hover { background: #f8f9fc; }
        .agenda-info h3 { margin: 0 0 8px 0; color: #2d3748; font-size: 20px; font-weight: 600; }
        .agenda-meta { display: flex; gap: 20px; color: #718096; font-size: 14px; margin-bottom: 12px; flex-wrap: wrap; }
        .agenda-meta span { display: flex; align-items: center; gap: 6px; }
        .stats-row { display: flex; gap: 25px; flex-wrap: wrap; }
        .stat-item { display: flex; align-items: center; gap: 8px; }
        .stat-value { font-weight: 600; font-size: 18px; color: #2d3748; }
        .stat-label { color: #718096; font-size: 13px; }
        .status-badge { padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 600; margin-bottom: 10px; display: inline-block; }
        .badge-needs-review { background: #fff3cd; color: #856404; }
        .badge-finalized { background: #d4edda; color: #155724; }
        .badge-pending { background: #f8d7da; color: #721c24; }
        .badge-no-speakers { background: #e2e8f0; color: #4a5568; }
        .progress-container { margin-top: 15px; }
        .progress { height: 8px; border-radius: 10px; background: #e2e8f0; overflow: hidden; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, #48bb78, #38a169); transition: width 0.5s; }
        .toggle-icon { font-size: 20px; color: #a0aec0; transition: transform 0.3s; }
        .agenda-card.expanded .toggle-icon { transform: rotate(180deg); }
        .speakers-section { padding: 20px; background: #f7fafc; border-top: 2px solid #e2e8f0; }
        .speaker-card { background: white; border-radius: 10px; padding: 20px; margin-bottom: 15px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .speaker-header { display: flex; gap: 20px; margin-bottom: 20px; align-items: flex-start; }
        .speaker-photo { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid #e2e8f0; flex-shrink: 0; }
        .speaker-info { flex: 1; }
        .speaker-info h4 { margin: 0 0 5px 0; color: #2d3748; font-size: 18px; }
        .speaker-meta { color: #718096; font-size: 14px; margin-bottom: 5px; }
        .rating-display { display: flex; align-items: center; gap: 15px; margin-bottom: 15px; flex-wrap: wrap; }
        .avg-rating { font-size: 32px; font-weight: 700; color: #667eea; }
        .rating-breakdown { flex: 1; min-width: 200px; }
        .rating-bar { display: flex; align-items: center; gap: 8px; margin-bottom: 4px; font-size: 12px; }
        .rating-bar-fill { flex: 1; height: 6px; background: #e2e8f0; border-radius: 3px; overflow: hidden; }
        .rating-bar-fill-inner { height: 100%; background: linear-gradient(90deg, #fbbf24, #f59e0b); }
        .decision-section { background: #f7fafc; padding: 15px; border-radius: 8px; margin-top: 15px; }
        .decision-options { display: flex; gap: 15px; margin-bottom: 10px; flex-wrap: wrap; }
        .decision-option { flex: 1; min-width: 150px; }
        .decision-option input[type="radio"] { display: none; }
        .decision-option label { display: block; padding: 12px; border: 2px solid #e2e8f0; border-radius: 8px; 
            text-align: center; cursor: pointer; font-weight: 500; transition: all 0.3s; }
        .decision-option label:hover { border-color: #667eea; }
        .decision-option input[type="radio"]:checked + label { background: #48bb78; color: white; border-color: #48bb78; }
        .decision-option.reject input[type="radio"]:checked + label { background: #f56565; border-color: #f56565; }
        .decision-option.hold input[type="radio"]:checked + label { background: #ed8936; border-color: #ed8936; }
        .action-buttons { display: flex; justify-content: flex-end; gap: 10px; padding: 20px; background: #f7fafc; 
            border-top: 2px solid #e2e8f0; }
        .btn-view-comments { background: #4299e1; color: white; border: none; padding: 8px 16px; border-radius: 6px; 
            cursor: pointer; font-size: 13px; }
        .btn-view-comments:hover { background: #3182ce; }
        .btn-view-profile { background: #805ad5; color: white; border: none; padding: 8px 16px; border-radius: 6px; 
            cursor: pointer; font-size: 13px; }
        .btn-view-profile:hover { background: #6b46c1; }
        .btn-save-all { background: #48bb78; color: white; border: none; padding: 12px 32px; border-radius: 8px; 
            cursor: pointer; font-weight: 600; font-size: 15px; }
        .btn-save-all:hover { background: #38a169; }
        .btn-cancel { background: #a0aec0; color: white; border: none; padding: 12px 32px; border-radius: 8px; 
            cursor: pointer; font-weight: 600; font-size: 15px; }
        .btn-cancel:hover { background: #718096; }
        .no-records { text-align: center; padding: 60px 20px; color: #a0aec0; }
        .no-records i { font-size: 48px; margin-bottom: 15px; display: block; }
        .loading-spinner { display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); 
            z-index: 9999; background: rgba(255,255,255,0.9); padding: 30px; border-radius: 10px; }
        .loading-spinner.show { display: block; }
        .spinner { border: 4px solid #f3f3f3; border-top: 4px solid #667eea; border-radius: 50%; 
            width: 50px; height: 50px; animation: spin 1s linear infinite; margin: 0 auto; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        
        /* Modal Styles */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
            background: rgba(0,0,0,0.6); z-index: 1000; }
        .modal-overlay.show { display: block; }
        .modal-content { position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); 
            background: white; border-radius: 12px; max-width: 800px; width: 90%; max-height: 80vh; overflow-y: auto; 
            box-shadow: 0 10px 40px rgba(0,0,0,0.3); z-index: 1001; }
        .modal-header { padding: 20px; border-bottom: 2px solid #e2e8f0; display: flex; 
            justify-content: space-between; align-items: center; background: #f7fafc; }
        .modal-header h3 { margin: 0; color: #2d3748; }
        .modal-close { background: none; border: none; font-size: 24px; cursor: pointer; color: #a0aec0; }
        .modal-close:hover { color: #2d3748; }
        .modal-body { padding: 20px; }
        .comment-item { background: #f7fafc; padding: 15px; border-radius: 8px; margin-bottom: 15px; 
            border-left: 4px solid #667eea; }
        .comment-header { display: flex; justify-content: space-between; margin-bottom: 8px; flex-wrap: wrap; }
        .comment-author { font-weight: 600; color: #2d3748; }
        .comment-rating { color: #f59e0b; font-weight: 600; }
        .comment-text { color: #4a5568; line-height: 1.6; margin-top: 8px; }
        .comment-meta { color: #a0aec0; font-size: 12px; margin-top: 8px; }
        .alert { position: fixed; top: 20px; right: 20px; z-index: 9999; padding: 15px 20px; border-radius: 8px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.15); animation: slideIn 0.3s ease-out; min-width: 300px; }
        .alert-success { background: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .alert-danger { background: #f8d7da; color: #721c24; border-left: 4px solid #dc3545; }
        @keyframes slideIn { from { transform: translateX(400px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
        <div class="admin-header">
            <h2><i class="fas fa-clipboard-check"></i> Final Speaker Selection Dashboard</h2>
            <div class="admin-info">
                <span><i class="fas fa-user-shield"></i> <asp:Label ID="lblAdminName" runat="server" /></span>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
            </div>
        </div>

        <div class="dashboard-container">
            <div class="filter-section">
                <div class="filter-buttons">
                    <asp:Button ID="btnAll" runat="server" Text="All Agendas (0)" CssClass="btn-filter active" 
                        CommandArgument="All" OnClick="btnStatusFilter_Click" />
                    <asp:Button ID="btnNeedsReview" runat="server" Text="Needs Review (0)" CssClass="btn-filter" 
                        CommandArgument="NeedsReview" OnClick="btnStatusFilter_Click" />
                    <asp:Button ID="btnFinalized" runat="server" Text="Finalized (0)" CssClass="btn-filter" 
                        CommandArgument="Finalized" OnClick="btnStatusFilter_Click" />
                    <asp:Button ID="btnPending" runat="server" Text="Pending Ratings (0)" CssClass="btn-filter" 
                        CommandArgument="Pending" OnClick="btnStatusFilter_Click" />
                </div>
                <div class="search-box">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search agendas by title, day, or track..." />
                    <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
                </div>
            </div>

            <asp:Panel ID="pnlNoRecords" runat="server" Visible="false" CssClass="no-records">
                <i class="fas fa-inbox"></i>
                <h3>No agendas found</h3>
                <p>Try adjusting your filters or search criteria</p>
            </asp:Panel>

            <asp:Repeater ID="rptAgendas" runat="server" OnItemCommand="rptAgendas_ItemCommand" 
                OnItemDataBound="rptAgendas_ItemDataBound">
                <ItemTemplate>
                    <div class="agenda-card <%# Convert.ToInt32(Eval("AgendaID")) == ExpandedAgendaID ? "expanded" : "" %>">
                        <div class="agenda-header" onclick="__doPostBack('Toggle', '<%# Eval("AgendaID") %>');">
                            <div class="agenda-info">
                                <h3><%# Eval("Title") %></h3>
                                <div class="agenda-meta">
                                    <span><i class="fas fa-calendar"></i> <%# Eval("Day") %></span>
                                    <span><i class="fas fa-layer-group"></i> <%# Eval("Track") %></span>
                                    <span><i class="fas fa-clock"></i> <%# Eval("Time") %></span>
                                </div>
                                <div class="stats-row">
                                    <div class="stat-item">
                                        <span class="stat-value"><%# Eval("TotalSpeakers") %></span>
                                        <span class="stat-label">Speakers Applied</span>
                                    </div>
                                    <div class="stat-item">
                                        <span class="stat-value"><%# Eval("TotalAdvisorsRated") %></span>
                                        <span class="stat-label">Advisors Rated</span>
                                    </div>
                                    <div class="stat-item">
                                        <span class="stat-value"><%# String.Format("{0:F1} ★", Eval("AvgRating")) %></span>
                                        <span class="stat-label">Avg Rating</span>
                                    </div>
                                    <div class="stat-item">
                                        <span class="stat-value"><%# Eval("ApprovedSpeakers") %></span>
                                        <span class="stat-label">Approved</span>
                                    </div>
                                </div>
                                <div class="progress-container">
                                    <div class="progress">
                                        <div class="progress-fill" style="width: <%# Eval("CompletionPercentage") %>%"></div>
                                    </div>
                                    <small style="color: #718096; margin-top: 5px; display: block;">
                                        <%# String.Format("{0:F0}% Finalized", Eval("CompletionPercentage")) %>
                                    </small>
                                </div>
                            </div>
                            <div style="text-align: right;">
                                <%# GetStatusBadge(Eval("StatusCategory")) %>
                                <div><i class="fas fa-chevron-down toggle-icon"></i></div>
                            </div>
                        </div>
                        <asp:Panel ID="pnlSpeakers" runat="server" CssClass="speakers-section" 
                            Visible='<%# Convert.ToInt32(Eval("AgendaID")) == ExpandedAgendaID %>' />
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="loading-spinner" id="loadingSpinner">
            <div class="spinner"></div>
        </div>

        <!-- Comments Modal -->
        <div class="modal-overlay" id="commentsModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><i class="fas fa-comments"></i> Advisory Comments</h3>
                    <button type="button" class="modal-close" onclick="closeCommentsModal()">×</button>
                </div>
                <div class="modal-body" id="commentsModalBody">
                    <p style="text-align: center; color: #a0aec0;">Loading comments...</p>
                </div>
            </div>
        </div>

        <!-- Speaker Profile Modal -->
        <div class="modal-overlay" id="profileModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><i class="fas fa-user"></i> Speaker Profile</h3>
                    <button type="button" class="modal-close" onclick="closeProfileModal()">×</button>
                </div>
                <div class="modal-body" id="profileModalBody">
                    <p style="text-align: center; color: #a0aec0;">Loading profile...</p>
                </div>
            </div>
        </div>

        <asp:HiddenField ID="hdnExpandedAgendaID" runat="server" Value="0" />
        <asp:HiddenField ID="hdnCurrentFilter" runat="server" Value="All" />
        <asp:Literal ID="litMessage" runat="server" />
    </form>

    <script>
        function showComments(speakerId, agendaId) {
            document.getElementById('loadingSpinner').classList.add('show');
            document.getElementById('commentsModal').classList.add('show');
            document.getElementById('commentsModalBody').innerHTML = '<p style="text-align: center; color: #a0aec0;">Loading comments...</p>';

            fetch('FinalSpeakerSelection.aspx/GetSpeakerComments', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ speakerId: speakerId, agendaId: agendaId })
            })
            .then(response => response.json())
            .then(data => {
                document.getElementById('loadingSpinner').classList.remove('show');
                if (data.d && data.d.success) {
                    document.getElementById('commentsModalBody').innerHTML = data.d.html;
                } else {
                    document.getElementById('commentsModalBody').innerHTML = '<p style="color: #f56565; text-align: center;">Error loading comments</p>';
                }
            })
            .catch(error => {
                document.getElementById('loadingSpinner').classList.remove('show');
                document.getElementById('commentsModalBody').innerHTML = '<p style="color: #f56565; text-align: center;">Error: ' + error + '</p>';
            });
        }

        function closeCommentsModal() {
            document.getElementById('commentsModal').classList.remove('show');
        }

        function showProfile(speakerData) {
            document.getElementById('profileModal').classList.add('show');
            document.getElementById('profileModalBody').innerHTML = speakerData;
        }

        function closeProfileModal() {
            document.getElementById('profileModal').classList.remove('show');
        }

        function collapseAgenda(agendaId) {
            __doPostBack('Toggle', '0');
        }

        function saveAllDecisions(agendaId) {
            document.getElementById('loadingSpinner').classList.add('show');
            
            var decisions = [];
            var speakerCards = document.querySelectorAll('.speaker-card');
            
            speakerCards.forEach(function(card) {
                var speakerId = card.dataset.speakerId;
                var selectedRadio = card.querySelector('input[name="decision_' + speakerId + '"]:checked');
                
                if (selectedRadio) {
                    decisions.push({
                        SpeakerID: parseInt(speakerId),
                        Decision: parseInt(selectedRadio.value)
                    });
                }
            });

            if (decisions.length === 0) {
                alert('Please make at least one decision before saving.');
                document.getElementById('loadingSpinner').classList.remove('show');
                return false;
            }

            var data = JSON.stringify({
                agendaId: agendaId,
                decisions: decisions
            });

            __doPostBack('SaveDecisions', data);
            return false;
        }

        // Close modals when clicking outside
        window.onclick = function(event) {
            if (event.target.classList.contains('modal-overlay')) {
                event.target.classList.remove('show');
            }
        }
    </script>
</body>
</html>
