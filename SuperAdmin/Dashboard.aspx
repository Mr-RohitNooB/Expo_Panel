<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Expo_Panel.Admin.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Super Admin Dashboard - Lubricant India Expo Panel</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
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

        /* Modern Modal Styling */
        .modal {
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            animation: fadeIn 0.2s ease;
            padding: 20px; /* Add padding for mobile */
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
        }

        .modal-content {
            background-color: #ffffff;
            margin: auto; /* Changed from 0 to auto */
            padding: 0;
            border: none;
            width: 90%;
            max-width: 600px;
            max-height: 85vh;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: slideUp 0.3s ease;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            position: relative; /* Add this */
        }

        @keyframes slideUp {
            from {
                transform: translateY(30px);
                opacity: 0;
            }

            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 24px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-bottom: none;
            margin-bottom: 0;
        }

            .modal-header h2 {
                margin: 0;
                color: #ffffff;
                font-size: 22px;
                font-weight: 600;
            }

        .close-btn {
            font-size: 28px;
            font-weight: 300;
            color: rgba(255, 255, 255, 0.9);
            cursor: pointer;
            transition: all 0.2s ease;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
        }

            .close-btn:hover {
                color: #ffffff;
                background: rgba(255, 255, 255, 0.1);
                transform: rotate(90deg);
            }

        .modal-body {
            padding: 30px;
            margin: 0;
            overflow-y: auto;
            flex: 1;
        }

            /* Custom Scrollbar */
            .modal-body::-webkit-scrollbar {
                width: 8px;
            }

            .modal-body::-webkit-scrollbar-track {
                background: #f1f1f1;
            }

            .modal-body::-webkit-scrollbar-thumb {
                background: #cbd5e0;
                border-radius: 4px;
            }

                .modal-body::-webkit-scrollbar-thumb:hover {
                    background: #a0aec0;
                }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding: 20px 30px;
            background: #f7fafc;
            border-top: 1px solid #e2e8f0;
            margin: 0;
        }

        .form-group {
            margin-bottom: 20px;
        }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #2d3748;
                font-size: 14px;
            }

            .form-group small {
                display: block;
                margin-top: 6px;
                color: #718096;
                font-size: 12px;
            }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            color: #2d3748;
            transition: all 0.2s ease;
            background: #ffffff;
        }

            .form-control:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            .form-control:hover {
                border-color: #cbd5e0;
            }

        textarea.form-control {
            resize: vertical;
            min-height: 80px;
            font-family: inherit;
        }

        select.form-control {
            cursor: pointer;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%232d3748' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 40px;
            appearance: none;
        }

        /* Checkbox Styling */
        .form-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            margin-right: 8px;
            cursor: pointer;
            accent-color: #667eea;
        }

        .form-group label:has(input[type="checkbox"]) {
            display: flex;
            align-items: center;
            font-weight: 500;
            cursor: pointer;
        }

        /* Button Styling */
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
        }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            }

            .btn-primary:active {
                transform: translateY(0);
            }

        .btn-secondary {
            background-color: #ffffff;
            color: #4a5568;
            border: 2px solid #e2e8f0;
        }

            .btn-secondary:hover {
                background-color: #f7fafc;
                border-color: #cbd5e0;
            }



        /* Mobile Responsive */
        @media (max-width: 768px) {
            .modal-content {
                width: 95%;
                max-height: 90vh;
                border-radius: 12px;
            }

            .modal-header {
                padding: 20px;
            }

                .modal-header h2 {
                    font-size: 18px;
                }

            .modal-body {
                padding: 20px;
            }

            .modal-footer {
                padding: 16px 20px;
                flex-direction: column-reverse;
            }

            .btn {
                width: 100%;
            }
        }

        /* Red asterisk for required fields */


        .form-group label > span,
        .form-group label::after {
            color: #f56565;
        }

        table td {
            padding: 15px;
            border-bottom: 1px solid #e2e8f0;
            color: #334155;
            white-space: nowrap;
        }

            table td:nth-child(2) {
                white-space: normal;
                max-width: 250px;
                min-width: 200px;
            }


        .grid-container {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch; /* Smooth scrolling on mobile */
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px; /* Ensure table doesn't shrink too much */
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="header">
            <div class="header-left">
                <img src="../Images/Lubricant_India_Expo_Cropped.png" style="height: 60px;" />
                <h1>Lubricant India Expo Super Admin Panel</h1>
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
                    <h2>Welcome back,
                        <asp:Label ID="lblWelcomeUser" runat="server"></asp:Label>!</h2>
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

                <asp:HyperLink ID="lnkAdvisorRating" runat="server" NavigateUrl="~/User/AdvisoryRatingDashboard.aspx" CssClass="card advisor-card" Target="_blank">
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

            <!-- Replace your Quick Actions section with this fixed version -->

            <div class="quick-actions">
                <h3><i class="fas fa-bolt"></i>Quick Actions</h3>
                <div class="action-buttons">
                    <button type="button" class="btn-action" onclick="openAddAdvisorModal();" id="btnAddAdvisor">
                        <i class="fas fa-user-plus"></i>Add New Advisor
                    </button>
                    <button type="button" class="btn-action" onclick="window.location='ManageAdvisors.aspx'">
                        <i class="fas fa-calendar-plus"></i>Manage Advisors
                    </button>
                    <button type="button" class="btn-action" onclick="window.location='FinalSpeakerSelection.aspx'">
                        <i class="fas fa-user-tie"></i>Final Speaker Selection
                    </button>
                    <button type="button" class="btn-action" onclick="window.location='ManageExhibitor.aspx'">
                        <i class="fas fa-building"></i>Add New Exhibitor
                    </button>
                    <button type="button" class="btn-action" onclick="window.location='ManageInnovation.aspx'">
                        <i class="fas fa-rocket"></i>Add Innovation Entry
                    </button>
                </div>
            </div>
        </div>

        <div id="addAdvisorModal" class="modal" style="display: none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Add New Advisor</h2>
                    <span class="close-btn" onclick="closeAddAdvisorModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="addAdvisorForm">
                        <div class="form-group">
                            <label for="txtName">Full Name *</label>
                            <input type="text" id="txtName" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="txtEmail">Email Address *</label>
                            <input type="email" id="txtEmail" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="txtMobile">Mobile Number</label>
                            <input type="tel" id="txtMobile" class="form-control">
                        </div>

                        <div class="form-group">
                            <label for="txtDesignation">Designation</label>
                            <input type="text" id="txtDesignation" class="form-control">
                        </div>

                        <div class="form-group">
                            <label for="txtCompany">Company</label>
                            <input type="text" id="txtCompany" class="form-control">
                        </div>

                        <!-- NEW: PASSWORD FIELD -->
                        <div class="form-group">
                            <label for="txtPassword">Password *</label>
                            <input type="password" id="txtPassword" class="form-control" required>
                            <small style="color: #666;">This will be used for advisor login</small>
                        </div>

                        <!-- NEW: LINK TO ADMIN CHECKBOX -->
                        <div class="form-group">
                            <label>
                                <input type="checkbox" id="chkLinkToAdmin">
                                Link this advisor to my admin account
                            </label>
                            <small style="display: block; color: #666; margin-top: 5px;">If checked, you can login to Advisor Panel using your admin credentials
                            </small>
                        </div>

                        <div class="form-group">
                            <label for="ddlStatus">Approval Status *</label>
                            <select id="ddlStatus" class="form-control" required>
                                <option value="">-- Select Status --</option>
                                <option value="Pending">Pending</option>
                                <option value="Approved" selected>Approved</option>
                                <option value="Rejected">Rejected</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="txtRemarks">Remarks</label>
                            <textarea id="txtRemarks" class="form-control" rows="3"></textarea>
                        </div>

                        <div class="form-group">
                            <label>
                                <input type="checkbox" id="chkActive" checked>
                                Active
                            </label>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeAddAdvisorModal()">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="submitAddAdvisor()">Add Advisor</button>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        function openAddAdvisorModal() {
            try {
                document.getElementById('addAdvisorForm').reset();
                // Set default approval status to Approved
                document.getElementById('ddlStatus').value = 'Approved';
                document.getElementById('addAdvisorModal').style.display = 'block';
                return false;
            } catch (e) {
                console.error('Error opening modal:', e);
                return false;
            }
        }

        function closeAddAdvisorModal() {
            document.getElementById('addAdvisorModal').style.display = 'none';
        }

        function submitAddAdvisor() {
            const name = document.getElementById('txtName').value.trim();
            const email = document.getElementById('txtEmail').value.trim();
            const mobile = document.getElementById('txtMobile').value.trim();
            const designation = document.getElementById('txtDesignation').value.trim();
            const company = document.getElementById('txtCompany').value.trim();
            const password = document.getElementById('txtPassword').value.trim();
            const linkToAdmin = document.getElementById('chkLinkToAdmin').checked;
            const status = document.getElementById('ddlStatus').value;
            const remarks = document.getElementById('txtRemarks').value.trim();
            const isActive = document.getElementById('chkActive').checked ? 1 : 0;

            // Validation
            if (!name) {
                alert('Please enter Full Name');
                return false;
            }

            if (!email) {
                alert('Please enter Email Address');
                return false;
            }

            if (!password) {
                alert('Please enter Password');
                return false;
            }

            if (password.length < 6) {
                alert('Password must be at least 6 characters long');
                return false;
            }

            if (!status) {
                alert('Please select Approval Status');
                return false;
            }

            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert('Please enter a valid email address');
                return false;
            }

            // Send data to server
            const formData = new FormData();
            formData.append('action', 'addAdvisor');
            formData.append('name', name);
            formData.append('email', email);
            formData.append('mobile', mobile);
            formData.append('designation', designation);
            formData.append('company', company);
            formData.append('password', password);
            formData.append('linkToAdmin', linkToAdmin ? '1' : '0');
            formData.append('status', status);
            formData.append('remarks', remarks);
            formData.append('isActive', isActive);

            fetch(window.location.href, {
                method: 'POST',
                body: formData
            })
                .then(response => response.text())
                .then(data => {
                    if (data.includes('Success')) {
                        alert('Advisor added successfully!\n\nLogin Credentials:\nEmail: ' + email + '\nPassword: ' + password);
                        closeAddAdvisorModal();
                        window.location.reload();
                    } else {
                        alert('Error: ' + data);
                    }
                })
                .catch(error => {
                    alert('Error: ' + error);
                });

            return false;
        }

        // Close modal when clicking outside
        window.onclick = function (event) {
            const modal = document.getElementById('addAdvisorModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }

        function openAddAdvisorModal() {
            document.getElementById("addAdvisorModal").style.display = "block";
        }

        function closeAddAdvisorModal() {
            document.getElementById("addAdvisorModal").style.display = "none";
        }

    </script>

</body>
</html>
