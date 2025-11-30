<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SpeakerDashboard.aspx.cs" Inherits="Expo_Panel.SpeakerDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Speaker Dashboard - Expo Panel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
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
            background: #f8fafc;
            min-height: 100vh;
        }

        /* Header Styles */
        .dashboard-header {
            background: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-logo img {
            height: 80px;
            width: auto;
            margin-bottom: -19px;
            margin-top: -10px;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 16px;
            background: #f0fdf4;
            border-radius: 8px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #38a169;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 16px;
        }

        .user-details h4 {
            font-size: 14px;
            font-weight: 600;
            color: #1e293b;
            margin: 0;
        }

        .user-details p {
            font-size: 12px;
            color: #64748b;
            margin: 0;
        }

        .btn-logout {
            padding: 10px 20px;
            background: #ef4444;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

            .btn-logout:hover {
                background: #dc2626;
                transform: translateY(-1px);
            }

        /* Main Container */
        .dashboard-container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 30px;
        }

        .welcome-section {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(56, 161, 105, 0.2);
        }

            .welcome-section h1 {
                font-size: 32px;
                margin-bottom: 10px;
            }

            .welcome-section p {
                font-size: 16px;
                opacity: 0.95;
            }

        /* Tab Navigation */
        .tab-navigation {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            border-bottom: 2px solid #e2e8f0;
        }

        .tab-btn {
            padding: 12px 24px;
            background: none;
            border: none;
            border-bottom: 3px solid transparent;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            color: #64748b;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

            .tab-btn:hover {
                color: #38a169;
            }

            .tab-btn.active {
                color: #38a169;
                border-bottom-color: #38a169;
            }

        .tab-content {
            display: none;
        }

            .tab-content.active {
                display: block;
            }

        /* Profile Section */
        .profile-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }

        .profile-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

            .profile-header h2 {
                font-size: 24px;
                color: #1e293b;
                display: flex;
                align-items: center;
                gap: 10px;
            }

        .btn-edit {
            padding: 10px 20px;
            background: #38a169;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

            .btn-edit:hover {
                background: #2f855a;
                transform: translateY(-1px);
            }

        .profile-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .info-item {
            padding: 15px;
            background: #f8fafc;
            border-radius: 8px;
        }

        .info-label {
            font-size: 12px;
            color: #64748b;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 15px;
            color: #1e293b;
            font-weight: 500;
        }

        /* Agenda Section */
        .agenda-filters {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 8px 16px;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            color: #64748b;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 6px;
        }

            .filter-btn:hover {
                border-color: #38a169;
                color: #38a169;
            }

            .filter-btn.active {
                background: #38a169;
                border-color: #38a169;
                color: white;
            }

            .filter-btn .badge {
                background: rgba(0, 0, 0, 0.1);
                padding: 2px 8px;
                border-radius: 12px;
                font-size: 12px;
            }

            .filter-btn.active .badge {
                background: rgba(255, 255, 255, 0.2);
            }

        .agenda-grid {
            display: grid;
            gap: 20px;
        }

        .agenda-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            border-left: 4px solid #38a169;
            transition: all 0.3s;
        }

            .agenda-card:hover {
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                transform: translateY(-2px);
            }

            .agenda-card.rejected {
                border-left-color: #ef4444;
                opacity: 0.7;
            }

        .agenda-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 15px;
        }

        .agenda-title {
            font-size: 18px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 8px;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

            .status-badge.approved {
                background: #d1fae5;
                color: #065f46;
            }

            .status-badge.rejected {
                background: #fee2e2;
                color: #991b1b;
            }

        .agenda-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 15px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
            color: #64748b;
        }

            .meta-item i {
                color: #38a169;
            }

        .agenda-brief {
            font-size: 14px;
            color: #475569;
            line-height: 1.6;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e2e8f0;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #94a3b8;
        }

            .empty-state i {
                font-size: 64px;
                margin-bottom: 20px;
                display: block;
                opacity: 0.5;
            }

            .empty-state h3 {
                font-size: 20px;
                margin-bottom: 10px;
            }

            .empty-state p {
                font-size: 14px;
            }

        /* Alert Messages */
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
            border: 1px solid #93c5fd;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .dashboard-header {
                padding: 15px;
                flex-direction: column;
                gap: 15px;
            }

            .dashboard-container {
                padding: 0 15px;
            }

            .profile-info {
                grid-template-columns: 1fr;
            }

            .tab-navigation {
                overflow-x: auto;
            }

            .tab-btn {
                white-space: nowrap;
            }

            .welcome-section h1 {
                font-size: 24px;
            }

            .agenda-filters {
                flex-direction: column;
            }

            .filter-btn {
                width: 100%;
                justify-content: center;
            }
        }

        /* Add these to your existing CSS */

        .status-badge.applied {
            background: #dbeafe;
            color: #1e40af; /* Blue */
        }

        .agenda-card.applied {
            border-left-color: #3b82f6; /* Blue border */
        }

        /* Change Password Button */
        .btn-password {
            padding: 10px 20px;
            background: #4a5568; /* Slate Gray */
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

            .btn-password:hover {
                background: #2d3748;
                transform: translateY(-1px);
            }

        /* Password Modal */
        .pwd-modal {
            display: none; /* Hidden by default */
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.6);
            z-index: 2000;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(2px);
        }

        .pwd-content {
            background: white;
            padding: 30px;
            border-radius: 12px;
            width: 90%;
            max-width: 400px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            animation: fadeIn 0.3s ease;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #4a5568;
            font-size: 13px;
        }

        .form-input {
            width: 100%;
            padding: 10px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            outline: none;
        }

            .form-input:focus {
                border-color: #38a169;
            }

        .pwd-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        .btn-cancel {
            background: #edf2f7;
            color: #4a5568;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
        }

        .btn-save {
            background: #38a169;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
        }

        /* Wrapper to hold Input + Eye Icon */
        .password-wrapper {
            position: relative;
            width: 100%;
        }

            /* Adjust input padding so text doesn't hit the icon */
            .password-wrapper .form-input {
                padding-right: 40px;
            }

        /* The Eye Icon Style */
        .toggle-eye {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #718096;
            cursor: pointer;
            z-index: 5;
            font-size: 14px;
        }

            .toggle-eye:hover {
                color: #2d3748;
            }

        /* Validation Hint Text */
        .pass-hint {
            font-size: 12px;
            margin-top: 5px;
            display: block;
            color: #64748b; /* Gray by default */
            transition: all 0.3s ease;
        }

            .pass-hint.invalid {
                color: #e53e3e;
            }
            /* Red */
            .pass-hint.valid {
                color: #38a169;
                font-weight: 600;
            }
        /* Green */
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <div class="dashboard-header">
            <div class="header-logo">
                <img src="/Images/Lubricant_India_Expo_Logo.jpg" alt="Expo Logo" />
            </div>
            <div class="header-right">
                <div class="user-info">
                    <div class="user-avatar">
                        <asp:Literal ID="litUserInitials" runat="server"></asp:Literal>
                    </div>
                    <div class="user-details">
                        <h4>
                            <asp:Literal ID="litUserName" runat="server"></asp:Literal></h4>
                        <p>
                            <asp:Literal ID="litUserEmail" runat="server"></asp:Literal>
                        </p>
                    </div>
                </div>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout"
                    OnClick="btnLogout_Click" CausesValidation="false" />
            </div>
        </div>

        <!-- Main Container -->
        <div class="dashboard-container">
            <!-- Welcome Section -->
            <div class="welcome-section">
                <h1>Welcome,
                    <asp:Literal ID="litWelcomeName" runat="server"></asp:Literal>! 👋</h1>
                <p>Manage your speaker profile and view your sessions assignments</p>
            </div>

            <!-- Alert Messages -->
            <asp:Literal ID="litMessage" runat="server"></asp:Literal>

            <!-- Tab Navigation -->
            <div class="tab-navigation">
                <button type="button" class="tab-btn active" onclick="openTab(event, 'profile')">
                    <i class="fas fa-user"></i>Profile
                </button>
                <button type="button" class="tab-btn" onclick="openTab(event, 'agendas')">
                    <i class="fas fa-calendar-check"></i>My Sessions
                </button>
            </div>

            <!-- Profile Tab -->
            <div id="profile" class="tab-content active">
                <div class="profile-card">
                    <div class="profile-header">
                        <h2><i class="fas fa-id-card"></i>Profile Information</h2>
                        <div style="display: flex; gap: 10px;">
                            <button type="button" class="btn-password" onclick="openPwdModal()">
                                <i class="fas fa-key"></i>Change Password
                            </button>
                            <a href="RegisterSpeaker.aspx" class="btn-edit">
                                <i class="fas fa-edit"></i>Update Profile
                            </a>
                        </div>
                    </div>

                    <div class="profile-info">
                        <div class="info-item">
                            <div class="info-label">Full Name</div>
                            <div class="info-value">
                                <asp:Literal ID="litName" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Email</div>
                            <div class="info-value">
                                <asp:Literal ID="litEmail" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Mobile</div>
                            <div class="info-value">
                                <asp:Literal ID="litMobile" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Designation</div>
                            <div class="info-value">
                                <asp:Literal ID="litDesignation" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Company</div>
                            <div class="info-value">
                                <asp:Literal ID="litCompany" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Years of Experience</div>
                            <div class="info-value">
                                <asp:Literal ID="litExperience" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div class="info-item" style="grid-column: 1 / -1;">
                            <div class="info-label">LinkedIn Profile</div>
                            <div class="info-value">
                                <asp:Literal ID="litLinkedIn" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div class="info-item" style="grid-column: 1 / -1;">
                            <div class="info-label">Professional Bio</div>
                            <div class="info-value">
                                <asp:Literal ID="litBio" runat="server"></asp:Literal>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Agendas Tab -->
            <div id="agendas" class="tab-content">
                <div class="profile-card">
                    <div class="profile-header">
                        <h2><i class="fas fa-calendar-check"></i>My Sessions</h2>
                    </div>

                    <!-- Filters -->
                    <div class="agenda-filters">
                        <button type="button" class="filter-btn active" onclick="filterAgendas('all')">
                            <i class="fas fa-list"></i>All 
                            <span class="badge">
                                <asp:Literal ID="litAllCount" runat="server"></asp:Literal></span>
                        </button>
                        <button type="button" class="filter-btn" onclick="filterAgendas('applied')">
                            <i class="fas fa-clock"></i>Applied 
       
                            <span class="badge">
                                <asp:Literal ID="litAppliedCount" runat="server"></asp:Literal></span>
                        </button>
                        <button type="button" class="filter-btn" onclick="filterAgendas('approved')">
                            <i class="fas fa-check-circle"></i>Approved 
                            <span class="badge">
                                <asp:Literal ID="litApprovedCount" runat="server"></asp:Literal></span>
                        </button>
                        <button type="button" class="filter-btn" onclick="filterAgendas('rejected')">
                            <i class="fas fa-times-circle"></i>Rejected 
                            <span class="badge">
                                <asp:Literal ID="litRejectedCount" runat="server"></asp:Literal></span>
                        </button>
                    </div>

                    <!-- Agenda Grid -->
                    <div class="agenda-grid">
                        <asp:Literal ID="litAgendaCards" runat="server"></asp:Literal>
                    </div>
                </div>
            </div>
        </div>

        <div id="pwdModal" class="pwd-modal">
            <div class="pwd-content">
                <h3 style="margin-bottom: 20px; color: #1e293b;">Change Password</h3>

                <div class="form-group">
                    <label class="form-label">Current Password</label>
                    <div class="password-wrapper">
                        <asp:TextBox ID="txtOldPass" runat="server" CssClass="form-input" TextMode="Password"></asp:TextBox>
                        <i class="fas fa-eye toggle-eye" onclick="togglePassword(this)"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">New Password</label>
                    <div class="password-wrapper">
                        <asp:TextBox ID="txtNewPass" runat="server" CssClass="form-input" TextMode="Password" onkeyup="validateLength(this); validateMatch();"></asp:TextBox>
                        <i class="fas fa-eye toggle-eye" onclick="togglePassword(this)"></i>
                    </div>
                    <span id="lenHint" class="pass-hint">Must be at least 6 characters</span>
                </div>

                <div class="form-group">
                    <label class="form-label">Confirm New Password</label>
                    <div class="password-wrapper">
                        <asp:TextBox ID="txtConfPass" runat="server" CssClass="form-input" TextMode="Password" onkeyup="validateMatch()"></asp:TextBox>
                        <i class="fas fa-eye toggle-eye" onclick="togglePassword(this)"></i>
                    </div>
                    <span id="matchHint" class="pass-hint"></span>
                </div>

                <div class="pwd-actions">
                    <button type="button" class="btn-cancel" onclick="closePwdModal()">Cancel</button>
                    <asp:Button ID="btnSavePassword" runat="server" Text="Update Password"
                        CssClass="btn-save" OnClick="btnSavePassword_Click" />
                </div>
            </div>
        </div>

        <script>
            function openPwdModal() {
                document.getElementById('pwdModal').style.display = 'flex';
            }
            function closePwdModal() {
                document.getElementById('pwdModal').style.display = 'none';
                // Optional: Clear fields
                document.getElementById('<%= txtOldPass.ClientID %>').value = '';
                document.getElementById('<%= txtNewPass.ClientID %>').value = '';
                document.getElementById('<%= txtConfPass.ClientID %>').value = '';
            }

            function openTab(evt, tabName) {
                var i, tabcontent, tablinks;

                tabcontent = document.getElementsByClassName("tab-content");
                for (i = 0; i < tabcontent.length; i++) {
                    tabcontent[i].classList.remove("active");
                }

                tablinks = document.getElementsByClassName("tab-btn");
                for (i = 0; i < tablinks.length; i++) {
                    tablinks[i].classList.remove("active");
                }

                document.getElementById(tabName).classList.add("active");
                evt.currentTarget.classList.add("active");
            }

            function filterAgendas(status) {
                var cards = document.querySelectorAll('.agenda-card');
                var filterBtns = document.querySelectorAll('.filter-btn');

                // Update active button
                filterBtns.forEach(function (btn) {
                    btn.classList.remove('active');
                });
                event.currentTarget.classList.add('active');

                // Show/Hide logic
                cards.forEach(function (card) {
                    if (status === 'all') {
                        card.style.display = 'block';
                    } else if (status === 'approved' && card.classList.contains('approved')) {
                        card.style.display = 'block';
                    } else if (status === 'rejected' && card.classList.contains('rejected')) {
                        card.style.display = 'block';
                    } else if (status === 'applied' && card.classList.contains('applied')) {
                        // New Logic for Applied
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            }
            function togglePassword(icon) {
                // Find the input field inside the same wrapper
                const wrapper = icon.parentElement;
                const input = wrapper.querySelector('input');

                if (input.type === "password") {
                    input.type = "text";
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash'); // Change icon to 'crossed eye'
                } else {
                    input.type = "password";
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye'); // Reset icon
                }
            }

            // 2. Real-time Length Validation
            function validateLength(input) {
                const hint = document.getElementById('lenHint');
                const val = input.value;

                if (val.length === 0) {
                    // Reset if empty
                    hint.className = "pass-hint";
                    hint.innerText = "Must be at least 6 characters";
                }
                else if (val.length < 6) {
                    // Invalid (Red)
                    hint.className = "pass-hint invalid";
                    hint.innerText = "Too short (at least 6 characters required)";
                }
                else {
                    // Valid (Green)
                    hint.className = "pass-hint valid";
                    hint.innerHTML = '<i class="fas fa-check"></i> Password length is good';
                }
            }
            // 3. Real-time Match Validation
            function validateMatch() {
                // Get the actual DOM elements using ClientID
                const pass1 = document.getElementById('<%= txtNewPass.ClientID %>').value;
                const pass2 = document.getElementById('<%= txtConfPass.ClientID %>').value;
                const hint = document.getElementById('matchHint');

                // If confirm box is empty, clear the message
                if (pass2.length === 0) {
                    hint.innerHTML = "";
                    hint.className = "pass-hint";
                    return;
                }

                // Compare values
                if (pass1 === pass2) {
                    // Match (Green)
                    hint.innerHTML = '<i class="fas fa-check"></i> Passwords match';
                    hint.className = "pass-hint valid";
                } else {
                    // No Match (Red)
                    hint.innerHTML = '<i class="fas fa-times"></i> Passwords do not match';
                    hint.className = "pass-hint invalid";
                }
            }
        </script>
    </form>
</body>
</html>
