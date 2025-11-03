<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Expo_Panel.Admin.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard - Expo Panel</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            color: #2d3748;
        }

        .header {
            background: linear-gradient(135deg, #4a5568 0%, #2d3748 100%);
            color: white;
            padding: 20px 40px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header-left h1 {
            font-size: 24px;
            font-weight: 600;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
        }

        .user-avatar {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 14px;
        }

        .user-details {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            font-size: 14px;
            font-weight: 600;
        }

        .user-role {
            font-size: 12px;
            color: #cbd5e0;
        }

        .btn-logout {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-logout:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-1px);
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .welcome-section {
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .welcome-content h2 {
            font-size: 32px;
            margin-bottom: 10px;
            color: #2d3748;
        }

        .welcome-content p {
            color: #718096;
            font-size: 16px;
        }

        .welcome-stats {
            display: flex;
            gap: 30px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 28px;
            font-weight: 700;
            color: #667eea;
            display: block;
        }

        .stat-label {
            font-size: 13px;
            color: #718096;
            margin-top: 5px;
        }

        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 20px;
            padding-left: 5px;
        }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(222px, 1fr));
            gap: 24px;
            margin-bottom: 40px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            border-left: 4px solid transparent;
            cursor: pointer;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .card.advisor-card {
            border-left-color: #667eea;
        }

        .card.advisor-card .card-icon {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .card.speaker-card {
            border-left-color: #48bb78;
        }

        .card.speaker-card .card-icon {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
        }

        .card.exhibitor-card {
            border-left-color: #ed8936;
        }

        .card.exhibitor-card .card-icon {
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
        }

        .card.innovation-card {
            border-left-color: #f56565;
        }

        .card.innovation-card .card-icon {
            background: linear-gradient(135deg, #f56565 0%, #e53e3e 100%);
        }

        .card.agenda-card {
            border-left-color: #3b82f6;
        }

        .card.agenda-card .card-icon {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .card-icon {
            width: 56px;
            height: 56px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .card-icon i {
            font-size: 26px;
            color: white;
        }

        .card-arrow {
            color: #cbd5e0;
            font-size: 20px;
            transition: all 0.3s ease;
        }

        .card:hover .card-arrow {
            color: #4a5568;
            transform: translateX(5px);
        }

        .card-body h3 {
            font-size: 22px;
            margin-bottom: 10px;
            color: #2d3748;
            font-weight: 600;
        }

        .card-body p {
            color: #718096;
            font-size: 14px;
            line-height: 1.6;
        }

        .quick-actions {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .quick-actions h3 {
            font-size: 18px;
            margin-bottom: 20px;
            color: #2d3748;
        }

        .action-buttons {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-action {
            padding: 12px 24px;
            background: #f7fafc;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            color: #4a5568;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-action:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .header-right {
                width: 100%;
                justify-content: space-between;
            }

            .welcome-section {
                flex-direction: column;
                align-items: flex-start;
                gap: 20px;
            }

            .welcome-content h2 {
                font-size: 24px;
            }

            .cards-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn-action {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div class="header-left">
                <h1><i class="fas fa-tachometer-alt"></i> Expo Panel Admin</h1>
            </div>
            <div class="header-right">
                <div class="user-info">
                    <div class="user-avatar">
                        <asp:Label ID="lblUserInitial" runat="server"></asp:Label>
                    </div>
                    <div class="user-details">
                        <span class="user-name">
                            <asp:Label ID="lblUsername" runat="server"></asp:Label>
                        </span>
                        <span class="user-role">Administrator</span>
                    </div>
                </div>
                <asp:Button ID="btnLogout" runat="server" CssClass="btn-logout" 
                    Text="Logout" OnClick="btnLogout_Click" />
            </div>
        </div>

        <div class="container">
            <div class="welcome-section">
                <div class="welcome-content">
                    <h2>Welcome back, <asp:Label ID="lblWelcomeUser" runat="server"></asp:Label>!</h2>
                    <p>Manage your expo panel system efficiently from here.</p>
                </div>
                <div class="welcome-stats">
                    <div class="stat-item">
                        <span class="stat-number">
                            <asp:Label ID="lblAgendaCount" runat="server" Text="0"></asp:Label>
                        </span>
                        <span class="stat-label">Agenda Items</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">
                            <asp:Label ID="lblAdvisorCount" runat="server" Text="0"></asp:Label>
                        </span>
                        <span class="stat-label">Advisors</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">
                            <asp:Label ID="lblSpeakerCount" runat="server" Text="0"></asp:Label>
                        </span>
                        <span class="stat-label">Speakers</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">
                            <asp:Label ID="lblExhibitorCount" runat="server" Text="0"></asp:Label>
                        </span>
                        <span class="stat-label">Exhibitors</span>
                    </div>
                </div>
            </div>

            <h2 class="section-title">Management Modules</h2>
            <div class="cards-grid">
                <asp:HyperLink ID="lnkAgenda" runat="server" NavigateUrl="~/SuperAdmin/ManageAgenda.aspx" CssClass="card agenda-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <i class="fas fa-arrow-right card-arrow"></i>
                    </div>
                    <div class="card-body">
                        <h3>Manage Agenda</h3>
                        <p>Create and manage event schedules, session tracks, timing, and detailed agendas for the expo.</p>
                    </div>
                </asp:HyperLink>

                <asp:HyperLink ID="lnkAdvisorRating" runat="server" NavigateUrl="~/SuperAdmin/AdvisoryRatingDashboard.aspx" CssClass="card advisor-card">
    <div class="card-header">
        <div class="card-icon">
            <i class="fas fa-star"></i>
        </div>
        <i class="fas fa-arrow-right card-arrow"></i>
    </div>
    <div class="card-body">
        <h3>Advisory Rating Dashboard</h3>
        <p>Review speaker profiles and submit your ratings for the selected agendas.</p>
    </div>
</asp:HyperLink>

                <asp:HyperLink ID="lnkSpeaker" runat="server" NavigateUrl="~/SuperAdmin/ManageSpeaker.aspx" CssClass="card speaker-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-microphone"></i>
                        </div>
                        <i class="fas fa-arrow-right card-arrow"></i>
                    </div>
                    <div class="card-body">
                        <h3>Manage Speakers</h3>
                        <p>View, approve, or reject speaker registrations. Manage speaker details and presentation schedules.</p>
                    </div>
                </asp:HyperLink>

                <asp:HyperLink ID="lnkExhibitor" runat="server" NavigateUrl="~/SuperAdmin/ManageExhibitor.aspx" CssClass="card exhibitor-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-store"></i>
                        </div>
                        <i class="fas fa-arrow-right card-arrow"></i>
                    </div>
                    <div class="card-body">
                        <h3>Manage Exhibitors</h3>
                        <p>Handle exhibitor applications, booth assignments, and company profile management.</p>
                    </div>
                </asp:HyperLink>

                <asp:HyperLink ID="lnkInnovation" runat="server" NavigateUrl="~/SuperAdmin/ManageInnovation.aspx" CssClass="card innovation-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-lightbulb"></i>
                        </div>
                        <i class="fas fa-arrow-right card-arrow"></i>
                    </div>
                    <div class="card-body">
                        <h3>Manage Innovations</h3>
                        <p>Review submitted innovations and ideas, update statuses, and promote outstanding projects.</p>
                    </div>
                </asp:HyperLink>
            </div>

            <div class="quick-actions">
                <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
                <div class="action-buttons">
                    <button type="button" class="btn-action" onclick="window.location='ManageAgenda.aspx'">
                        <i class="fas fa-calendar-plus"></i> Add Agenda Item
                    </button>
                    <button type="button" class="btn-action" onclick="window.location='ManageAdvisor.aspx'">
                        <i class="fas fa-user-plus"></i> Add New Advisor
                    </button>
                    <button type="button" class="btn-action" onclick="window.location='ManageSpeaker.aspx'">
                        <i class="fas fa-user-tie"></i> Add New Speaker
                    </button>
                    <button type="button" class="btn-action" onclick="window.location='ManageExhibitor.aspx'">
                        <i class="fas fa-building"></i> Add New Exhibitor
                    </button>
                    <button type="button" class="btn-action" onclick="window.location='ManageInnovation.aspx'">
                        <i class="fas fa-rocket"></i> Add Innovation Entry
                    </button>
                </div>
            </div>
        </div>
    </form>
</body>
</html>