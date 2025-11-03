<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdvisoryRatingDashboard.aspx.cs" Inherits="Expo_Panel.SuperAdmin.AdvisoryRatingDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Advisory Rating Dashboard - Expo Panel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
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
                color: #fbbf24;
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
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-danger" OnClick="btnLogout_Click" />
                </div>
            </div>

            <div class="dashboard-card">
                <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>

                <div class="status-filters">
                    <asp:Button ID="btnNotRated" runat="server" Text="Not Rated (0)" CssClass="btn-filter active"
                        OnClick="btnStatusFilter_Click" CommandArgument="NotRated" />
                    <asp:Button ID="btnRated" runat="server" Text="Rated (0)" CssClass="btn-filter"
                        OnClick="btnStatusFilter_Click" CommandArgument="Rated" />
                    <asp:HiddenField ID="hdnCurrentFilter" runat="server" Value="NotRated" />
                </div>


                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="toolbar">
                            <div class="search-box">
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                                    placeholder="Search by speaker name, company, email..."></asp:TextBox>
                                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary"
                                    OnClick="btnSearch_Click" />
                            </div>
                        </div>
                        <div class="grid-container">
                            <asp:GridView ID="gvSpeakers" runat="server" AutoGenerateColumns="False"
                                OnRowCommand="gvSpeakers_RowCommand" DataKeyNames="SpeakerID"
                                CssClass="speakers-grid" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="SpeakerID" HeaderText="ID" Visible="false" />

                                    <asp:TemplateField HeaderText="Sr. No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:BoundField DataField="SpeakerName" HeaderText="Name" />
                                    <asp:BoundField DataField="Email" HeaderText="Email" />
                                    <asp:BoundField DataField="Designation" HeaderText="Designation" />
                                    <asp:BoundField DataField="Company" HeaderText="Company" />
                                    <asp:BoundField DataField="YearsOfExperience" HeaderText="Experience (Yrs)" />

                                    <asp:TemplateField HeaderText="Rating Status">
                                        <ItemTemplate>
                                            <%# Convert.ToBoolean(Eval("HasRated")) 
                                ? "<span class='badge badge-rated'><i class='fas fa-check'></i> Rated (" + Eval("MyRatingCount") + ")</span>" 
                                : "<span class='badge badge-pending'><i class='fas fa-clock'></i> Not Rated</span>" %>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:Button runat="server"
                                                Text='<%# Convert.ToBoolean(Eval("HasRated")) ? "View/Edit Rating" : "Rate Now" %>'
                                                CommandName="RateSpeaker"
                                                CommandArgument='<%# Eval("SpeakerID") %>'
                                                CssClass='<%# Convert.ToBoolean(Eval("HasRated")) ? "btn btn-warning" : "btn btn-success" %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="no-records">
                                        <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 15px; display: block;"></i>
                                        No speakers found for rating.
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnNotRated" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="btnRated" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>

        <!-- Rating Modal -->
        <div id="ratingModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2><i class="fas fa-star"></i>Rate Speaker</h2>
                    <button type="button" class="close-btn" onclick="closeRatingModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnSpeakerID" runat="server" Value="0" />

                <!-- Speaker Information -->
                <div class="speaker-info">
                    <h3><i class="fas fa-user"></i>Speaker Information</h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Name</span>
                            <span class="info-value" id="spanSpeakerName"></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Email</span>
                            <span class="info-value" id="spanSpeakerEmail"></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Designation</span>
                            <span class="info-value" id="spanDesignation"></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Company</span>
                            <span class="info-value" id="spanCompany"></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Experience</span>
                            <span class="info-value" id="spanExperience"></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Expertise</span>
                            <span class="info-value" id="spanExpertise"></span>
                        </div>
                    </div>
                </div>

                <!-- Agendas Section -->
                <div class="agenda-section">
                    <h3 style="margin-bottom: 15px;"><i class="fas fa-calendar"></i>Selected Agendas & Ratings</h3>
                    <asp:Literal ID="litAgendaCards" runat="server"></asp:Literal>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            function openRatingModal(speakerId, name, email, designation, company, experience, expertise) {
                document.getElementById('<%=hdnSpeakerID.ClientID%>').value = speakerId;
                document.getElementById('spanSpeakerName').innerText = name;
                document.getElementById('spanSpeakerEmail').innerText = email;
                document.getElementById('spanDesignation').innerText = designation;
                document.getElementById('spanCompany').innerText = company;
                document.getElementById('spanExperience').innerText = experience + ' years';
                document.getElementById('spanExpertise').innerText = expertise || 'Not specified';

                document.getElementById('ratingModal').classList.add('show');
            }

            function closeRatingModal() {
                document.getElementById('ratingModal').classList.remove('show');
            }

            function setRating(agendaId, rating) {
                // Update star display
                var stars = document.querySelectorAll('.star-group-' + agendaId + ' .star');
                stars.forEach(function (star, index) {
                    if (index < rating) {
                        star.classList.add('active');
                    } else {
                        star.classList.remove('active');
                    }
                });

                // Set hidden field value
                document.getElementById('hdnRating_' + agendaId).value = rating;
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
