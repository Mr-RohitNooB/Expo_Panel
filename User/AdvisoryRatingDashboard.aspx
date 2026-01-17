<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdvisoryRatingDashboard.aspx.cs" Inherits="Expo_Panel.SuperAdmin.AdvisoryRatingDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <%-- ... HEAD content (styles, fonts, etc.) is UNCHANGED ... --%>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Advisory Member Dashboard - Expo Panel</title>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <!-- Favicons -->
    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" media="(prefers-color-scheme: light)" />
    <link rel="icon" type="image/png" sizes="16x16" href="/Images/favicon_io_Lubricant_India_Expo/favicon-16x16.png" media="(prefers-color-scheme: light)" />
    <link rel="apple-touch-icon" href="/Images/favicon_io_Lubricant_India_Expo/apple-touch-icon.png" media="(prefers-color-scheme: light)" />
    <link rel="shortcut icon" href="/Images/favicon_io_Lubricant_India_Expo/favicon.ico" media="(prefers-color-scheme: light)" />
    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" media="(prefers-color-scheme: dark)" />
    <link rel="icon" type="image/png" sizes="16x16" href="/Images/favicon_io_Lubricant_India_Expo/favicon-16x16.png" media="(prefers-color-scheme: dark)" />
    <link rel="apple-touch-icon" href="/Images/favicon_io_Lubricant_India_Expo/apple-touch-icon.png" media="(prefers-color-scheme: dark)" />
    <link rel="shortcut icon" href="/Images/favicon_io_Lubricant_India_Expo/favicon.ico" media="(prefers-color-scheme: dark)" />
    <link rel="icon" type="image/png" sizes="192x192" href="/Images/favicon_io_Lubricant_India_Expo/android-chrome-192x192.png" />
    <link rel="icon" type="image/png" sizes="512x512" href="/Images/favicon_io_Lubricant_India_Expo/android-chrome-512x512.png" />
    <link rel="manifest" href="/Images/favicon_io_Lubricant_India_Expo/site.webmanifest" />
    <meta name="theme-color" content="#ffffff" media="(prefers-color-scheme: light)" />
    <meta name="theme-color" content="#000000" media="(prefers-color-scheme: dark)" />
    <meta name="msapplication-TileColor" content="#ffffff" />

    <style>
        /* ... ALL your CSS styles are UNCHANGED ... */
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

        .agenda-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .agenda-item {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s;
        }

            .agenda-item:hover {
                border-color: #cbd5e1;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                transform: translateX(2px);
            }

        .agenda-header-row {
            display: grid;
            grid-template-columns: 60px 2.5fr 100px 140px 120px 110px 140px 130px 100px;
            gap: 12px;
            padding: 18px 20px;
            align-items: center;
            background: #f8fafc;
            font-weight: 600;
            color: #475569;
            border-radius: 10px;
            font-size: 13px;
            text-align: left;
        }

        .agenda-data-row {
            display: grid;
            grid-template-columns: 60px 2.5fr 100px 140px 120px 110px 140px 130px 100px;
            gap: 12px;
            padding: 18px 20px;
            align-items: center;
            cursor: pointer;
            transition: background 0.2s;
            width: 100%;
            text-decoration: none;
            color: inherit;
            font-size: 13px;
            text-align: left;
        }

            .agenda-data-row:hover {
                background: #f8fafc;
            }

            .agenda-data-row.expanded {
                background: #f0f9ff;
                border-bottom: 2px solid #0ea5e9;
            }

        .agenda-title {
            font-weight: 600;
            color: #1e293b;
        }

        .progress-bar-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .progress-bar {
            flex: 1;
            background: #e2e8f0;
            height: 8px;
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-fill {
            background: #10b981;
            height: 100%;
            transition: width 0.3s;
        }

        .progress-text {
            font-size: 12px;
            color: #64748b;
            font-weight: 500;
            white-space: nowrap;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            white-space: nowrap;
        }

        .badge-rated {
            background: #d1fae5;
            color: #065f46;
        }

        .badge-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .badge-progress {
            background: #dbeafe;
            color: #1e40af;
        }

        .expand-icon {
            transition: transform 0.3s;
            color: #64748b;
        }

            .expand-icon.rotated {
                transform: rotate(180deg);
            }

        /* Speakers Section (Expandable) */
        .speakers-section {
            display: none; /* UNCHANGED */
            padding: 25px;
            background: #f8fafc;
            border-top: 2px solid #e2e8f0;
            animation: slideDown 0.3s ease-out;
        }

            .speakers-section.show {
                display: block; /* UNCHANGED */
            }

        @keyframes slideDown {
            from {
                opacity: 0;
                max-height: 0;
            }

            to {
                opacity: 1;
                max-height: 2000px;
            }
        }

        .agenda-info-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
        }

            .agenda-info-banner h3 {
                margin-bottom: 10px;
                font-size: 18px;
            }

        .agenda-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            font-size: 12px;
            opacity: 0.9;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 14px;
            font-weight: 500;
        }

        .speakers-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(450px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .speaker-card {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            padding: 20px;
            transition: all 0.3s;
        }

            .speaker-card:hover {
                border-color: #667eea;
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.1);
            }

        .speaker-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 15px;
        }

        .speaker-name {
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 8px;
        }

        .speaker-meta {
            display: flex;
            flex-direction: column;
            gap: 5px;
            font-size: 13px;
            color: #64748b;
        }

            .speaker-meta span {
                display: flex;
                align-items: center;
                gap: 8px;
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
            color: #92400e;
        }

            .current-rating i {
                color: #fbbf24;
            }

        .rating-section {
            border-top: 1px solid #e2e8f0;
            padding-top: 15px;
            margin-top: 15px;
        }

        .star-rating {
            display: flex;
            gap: 5px;
            margin: 10px 0;
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
                transform: scale(1.1);
            }

        .form-group {
            margin-top: 15px;
        }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #475569;
                font-weight: 500;
                font-size: 14px;
            }

            .form-group textarea {
                width: 100%;
                padding: 10px 15px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                font-family: 'Poppins', sans-serif;
                resize: vertical;
                min-height: 80px;
            }

                .form-group textarea:focus {
                    outline: none;
                    border-color: #667eea;
                }

        .save-ratings-section {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 20px;
            border-top: 2px solid #e2e8f0;
            margin-top: 20px;
            /* NEW: Make this flex-wrap for the validation message */
            flex-wrap: wrap;
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

        .no-records {
            text-align: center;
            padding: 60px 20px;
            color: #94a3b8;
        }

            .no-records i {
                font-size: 48px;
                margin-bottom: 15px;
                display: block;
            }

        .loading-spinner {
            display: none;
            text-align: center;
            padding: 40px;
            color: #667eea;
        }

            .loading-spinner.show {
                display: block;
            }

            .loading-spinner i {
                font-size: 48px;
                animation: spin 1s linear infinite;
            }

        @keyframes spin {
            from {
                transform: rotate(0deg);
            }

            to {
                transform: rotate(360deg);
            }
        }

        /* ... ALL @media queries are UNCHANGED ... */
        @media (max-width: 1200px) {
            .agenda-header-row,
            .agenda-data-row {
                grid-template-columns: 50px 1fr 80px 120px 100px 100px 120px 140px;
                font-size: 13px;
            }

            .speakers-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .agenda-header-row {
                display: none;
            }

            .agenda-data-row {
                grid-template-columns: 1fr;
                gap: 10px;
            }

                .agenda-data-row > span {
                    display: flex;
                    justify-content: space-between;
                }

                    .agenda-data-row > span::before {
                        content: attr(data-label);
                        font-weight: 600;
                        color: #64748b;
                    }
        }


        /* === INFINITE COLOR LOOP (Repeats every 8 items) === */

        /* Color 1 (Blue) - Applies to Agenda 1, 9, 17, 25... */
        /* Formula 8n+2: Start at row 2 (header is row 1), repeat every 8 */
        .agenda-item:nth-child(8n+2) {
            border-left: 4px solid #3b82f6;
        }

        /* Color 2 (Green) - Applies to Agenda 2, 10, 18, 26... */
        .agenda-item:nth-child(8n+3) {
            border-left: 4px solid #10b981;
        }

        /* Color 3 (Orange) */
        .agenda-item:nth-child(8n+4) {
            border-left: 4px solid #f59e0b;
        }

        /* Color 4 (Purple) */
        .agenda-item:nth-child(8n+5) {
            border-left: 4px solid #8b5cf6;
        }

        /* Color 5 (Pink) */
        .agenda-item:nth-child(8n+6) {
            border-left: 4px solid #ec4899;
        }

        /* Color 6 (Teal) */
        .agenda-item:nth-child(8n+7) {
            border-left: 4px solid #14b8a6;
        }

        /* Color 7 (Dark Orange) */
        .agenda-item:nth-child(8n+8) {
            border-left: 4px solid #f97316;
        }

        /* Color 8 (Indigo) - Applies to Agenda 8, 16, 24... */
        .agenda-item:nth-child(8n+9) {
            border-left: 4px solid #6366f1;
        }

        /* ... Your existing CSS ... */
        .btn-info:hover {
            background: #0284c7;
        }

        /* NEW: Styles for the Profile Modal */
        .profile-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            z-index: 1040;
            display: none; /* Hidden by default */
            opacity: 0;
            transition: opacity 0.3s ease;
            backdrop-filter: blur(5px);
        }

            .profile-overlay.show {
                display: block;
                opacity: 1;
            }

        .profile-modal {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            width: 90%;
            max-width: 800px;
            max-height: 90vh;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            transform: translate(-50%, -60%); /* Start slightly higher for animation */
            transition: all 0.3s ease-out;
        }

        .profile-overlay.show .profile-modal {
            transform: translate(-50%, -50%); /* Animate to center */
        }

        .profile-modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 25px;
            border-bottom: 1px solid #e2e8f0;
        }

            .profile-modal-header h3 {
                color: #4f46e5;
                font-weight: 600;
                margin: 0;
            }

        .profile-modal-close {
            background: transparent;
            border: none;
            font-size: 28px;
            font-weight: 300;
            color: #94a3b8;
            cursor: pointer;
            padding: 0;
            line-height: 1;
        }

            .profile-modal-close:hover {
                color: #1e293b;
            }

        .profile-modal-body {
            padding: 25px;
            display: flex;
            gap: 25px;
        }

        .profile-modal-left {
            flex-basis: 200px;
            flex-shrink: 0;
        }

            .profile-modal-left img {
                width: 100%;
                height: 200px; /* Fixed height */
                object-fit: cover;
                border-radius: 10px;
                border: 2px solid #e2e8f0;
            }

        .profile-modal-right {
            flex-grow: 1;
            font-size: 14px;
            color: #475569;
        }

            .profile-modal-right .profile-meta-item {
                margin-bottom: 10px;
            }

            .profile-modal-right strong {
                color: #1e293b;
                display: block;
                margin-bottom: 4px;
            }

            .profile-modal-right hr {
                border: none;
                border-top: 1px solid #e2e8f0;
                margin: 15px 0;
            }

            .profile-modal-right p {
                line-height: 1.6;
                white-space: pre-wrap; /* Respects newlines in the bio */
            }

        .speaker-actions {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-shrink: 0; /* Prevents shrinking */
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        @media (max-width: 992px) {
            /* Stack the Title and the Action Buttons vertically */
            .header {
                flex-direction: column;
                align-items: stretch !important; /* Forces full width */
                gap: 15px;
                text-align: center;
                padding: 20px; /* Reduce padding slightly */
            }

            /* Allow buttons to wrap to new lines if needed */
            .header-actions {
                justify-content: center;
                flex-wrap: wrap;
                width: 100%;
            }

                /* Make buttons bigger and touch-friendly on mobile */
                .header-actions .btn {
                    flex: 1 1 auto; /* Grow to fill space */
                    min-width: 200px; /* Don't get too small */
                    justify-content: center;
                    margin-bottom: 5px;
                }

                /* Center the welcome text */
                .header-actions span {
                    width: 100%;
                    display: block;
                    margin: 5px 0;
                }
        }

        /* --- Mobile Fix for Status Filters --- */
        @media (max-width: 768px) {
            .status-filters {
                /* Change from row to column layout so buttons stack */
                flex-direction: column;
                gap: 10px;
            }

                /* Make the buttons fill the width of the screen */
                .status-filters .btn-filter {
                    width: 100%;
                    display: block; /* Ensures they behave like block elements */
                    text-align: center; /* Centers the text inside the button */
                    padding: 12px; /* Slightly larger touch target */
                }

            .agenda-data-row > span[data-label="Title"] {
                flex-direction: column; /* Stack the label on top of the text */
                align-items: flex-start; /* Align everything to the left side */
                text-align: left; /* Ensure the text is left-aligned */
                gap: 5px; /* Add a small gap between "Title" and the text */
                margin-bottom: 5px; /* Add a little breathing room below the title */
            }

            /* Optional: Make the actual title text slightly larger/bolder */
            .agenda-data-row > span[data-label="Title"] {
                font-weight: 600;
                line-height: 1.4;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="container">
            <!-- ... Header is UNCHANGED ... -->
            <div class="header">
                <h1><i class="fas fa-star"></i>Advisory Member Dashboard</h1>

                <div class="header-actions">

                    <a href="RegisterExhibitor.aspx" class="btn btn-info" style="text-decoration: none;">
                        <i class="fas fa-store"></i>Register as Exhibitor
                    </a>

                    <a href="RegisterSpeaker.aspx" class="btn btn-success" style="text-decoration: none;">
                        <i class="fas fa-microphone"></i>Register as Speaker
                    </a>

                    <span>Welcome,
                        <asp:Label ID="lblAdvisorName" runat="server" Text=""></asp:Label></span>

                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-danger" OnClick="btnLogout_Click" />
                </div>
            </div>

            <div class="dashboard-card">
                <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>

                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <!-- ... Status Filters and Toolbar are UNCHANGED ... -->
                        <div class="status-filters">
                            <asp:Button ID="btnAll" runat="server" Text="All Agendas (0)" CssClass="btn-filter active"
                                OnClick="btnStatusFilter_Click" CommandArgument="All" />
                            <asp:Button ID="btnNotStarted" runat="server" Text="Not Started (0)" CssClass="btn-filter"
                                OnClick="btnStatusFilter_Click" CommandArgument="NotStarted" />
                            <asp:Button ID="btnFullyRated" runat="server" Text="Completed (0)" CssClass="btn-filter"
                                OnClick="btnStatusFilter_Click" CommandArgument="FullyRated" />
                            <asp:HiddenField ID="hdnCurrentFilter" runat="server" Value="All" />
                            <asp:HiddenField ID="hdnExpandedAgendaID" runat="server" Value="0" />
                        </div>

                        <div class="toolbar">
                            <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
                                <div class="search-box">
                                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by day, track, title..."></asp:TextBox>
                                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                                </div>
                            </asp:Panel>
                        </div>

                        <div class="agenda-list">
                            <!-- Header Row is UNCHANGED -->
                            <div class="agenda-header-row">
                                <div>Sr. No.</div>
                                <div>Agenda Title</div>
                                <div>Day</div>
                                <div>Track</div>
                                <div>Time</div>
                                <div>Speakers</div>
                                <div>Progress</div>
                                <div>Status</div>
                            </div>

                            <!-- REMOVED: The old <asp:Literal ID="litAgendaItems" ... /> is GONE. -->

                            <!-- NEW: It is replaced with this asp:Repeater. -->
                            <!-- The Repeater is a "smart" control that will create one <ItemTemplate> for each row in our data. -->
                            <!-- We add OnItemCommand to listen for clicks and OnItemDataBound to load the speakers for the expanded row. -->
                            <asp:Repeater ID="rptAgendas" runat="server"
                                OnItemCommand="rptAgendas_ItemCommand"
                                OnItemDataBound="rptAgendas_ItemDataBound">
                                <ItemTemplate>
                                    <div id="agenda_<%# Eval("AgendaID") %>" class="agenda-item">

                                        <asp:LinkButton ID="lnkAgendaRow" runat="server"
                                            CommandName="Toggle"
                                            CommandArgument='<%# Eval("AgendaID") %>'
                                            CssClass='<%# String.Format("agenda-data-row {0}", (Eval("AgendaID").ToString() == hdnExpandedAgendaID.Value) ? "expanded" : "") %>'>

<span data-label="Sr. No."><%# Container.ItemIndex + 1 %></span>
<span data-label="Title" class="agenda-title"><%# Eval("Title") %></span>
<span data-label="Day"><%# Eval("Day") %></span>
<span data-label="Track"><%# Eval("Track") %></span>
<span data-label="Time"><%# Eval("Time") %></span>
<span data-label="Speakers" style="font-weight: 600; color: #4f46e5;">

        <%# Eval("TotalSpeakers") %> Speakers
    </span>
    <span data-label="Progress">
        <%# GetProgressHtml(Eval("ProgressPercentage"), Eval("RatedSpeakers"), Eval("TotalSpeakers")) %>
    </span>
    <span data-label="Status">
        <%# GetStatusBadge(Eval("IsFullyRated"), Eval("RatedSpeakers")) %>
    </span>
    <span data-label="Actions">
        <i id="icon_<%# Eval("AgendaID") %>"
            class='<%# String.Format("fas fa-chevron-down expand-icon {0}", (Eval("AgendaID").ToString() == hdnExpandedAgendaID.Value) ? "rotated" : "") %>'></i>
    </span>
                                        </asp:LinkButton>


                                        <asp:Panel ID="pnlSpeakers" runat="server"
                                            CssClass='<%# String.Format("speakers-section {0}", (Eval("AgendaID").ToString() == hdnExpandedAgendaID.Value) ? "show" : "") %>'
                                            Visible='<%# (Eval("AgendaID").ToString() == hdnExpandedAgendaID.Value) %>'>
                                        </asp:Panel>

                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

                        <!-- ... pnlNoRecords and loadingSpinner are UNCHANGED ... -->
                        <asp:Panel ID="pnlNoRecords" runat="server" CssClass="no-records" Visible="false">
                            <i class="fas fa-inbox"></i>
                            <p>No agendas found.</p>
                        </asp:Panel>

                        <div id="loadingSpinner" class="loading-spinner">
                            <i class="fas fa-spinner"></i>
                            <p>Loading speakers...</p>
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
        <div id="profileOverlay" class="profile-overlay">
            <div id="profileModal" class="profile-modal">
                <div class="profile-modal-header">
                    <h3 id="modalSpeakerName">Speaker Name</h3>
                    <button type="button" class="profile-modal-close" onclick="hideSpeakerProfile()">
                        &times;
                    </button>
                </div>
                <div class="profile-modal-body">
                    <div class="profile-modal-left">
                        <img id="modalSpeakerImage" src="/Images/DefaultUser.png" alt="Speaker Profile" />
                        <div class="profile-meta-item">
                            <strong><i class="fas fa-envelope"></i>Email:</strong>
                            <span id="modalSpeakerEmail"></span>
                        </div>
                        <div class="profile-meta-item">
                            <strong><i class="fas fa-phone"></i>Mobile:</strong>
                            <span id="modalSpeakerMobile"></span>
                        </div>
                        <div class="profile-meta-item">
                            <strong><i class="fab fa-linkedin"></i>LinkedIn:</strong>
                            <a id="modalSpeakerLinkedIn" href="#" target="_blank" rel="noopener noreferrer">N/A</a>
                        </div>
                    </div>
                    <div class="profile-modal-right">
                        <div class="profile-meta-item">
                            <strong>Designation:</strong>
                            <span id="modalSpeakerDesignation"></span>
                        </div>
                        <div class="profile-meta-item">
                            <strong>Company:</strong>
                            <span id="modalSpeakerCompany"></span>
                        </div>
                        <div class="profile-meta-item">
                            <strong>Years of Experience:</strong>
                            <span id="modalSpeakerExperience"></span>
                        </div>
                        <hr />
                        <div class="profile-meta-item">
                            <strong>Bio:</strong>
                            <p id="modalSpeakerBio"></p>
                        </div>
                        <hr />
                        <div class="profile-meta-item">
                            <strong>Areas of Expertise:</strong>
                            <p id="modalSpeakerExpertise"></p>
                        </div>
                        <hr />
                        <div class="profile-meta-item">
                            <strong>Current Projects:</strong>
                            <p id="modalSpeakerProjects"></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            // REMOVED: The old toggleAgenda(agendaId) function is no longer needed.
            // The LinkButton click now triggers a server postback automatically.

            // UNCHANGED: These JavaScript functions are still needed for the star rating
            // inside the speaker cards.
            function setRating(speakerId, rating) {
                var hiddenField = document.getElementById('hdnRating_' + speakerId);
                if (hiddenField) {
                    hiddenField.value = rating;
                }

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

            // UPDATED: saveAgendaRatings
            function saveAgendaRatings(agendaId) {
                // NEW: Find the validation message div and hide it
                var msgDiv = document.getElementById('validationMsg_' + agendaId);
                if (msgDiv) {
                    msgDiv.style.display = 'none';
                }

                var speakerCards = document.querySelectorAll('#speakers_' + agendaId + ' .speaker-card[data-speaker-id]');
                var ratingsData = [];
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
                    // REMOVED: alert('...');
                    // NEW: Show the validation message div instead of an alert
                    // This respects your request to avoid pop-ups.
                    if (msgDiv) {
                        msgDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i> Please provide a rating (1-5 stars) for all speakers before submitting.';
                        msgDiv.style.display = 'block';
                    }
                    if (firstInvalidCard) {
                        firstInvalidCard.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                    return false;
                }

                // ... Show loading and __doPostBack are UNCHANGED ...
                var spinner = document.getElementById('loadingSpinner');
                if (spinner) spinner.classList.add('show');

                __doPostBack('SaveRatings', JSON.stringify({ agendaId: agendaId, ratings: ratingsData }));
                return false;
            }

            // UPDATED: collapseAgenda
            function collapseAgenda(agendaId) {
                // 1. Set the hidden field to 0 to tell the server we want to close it.
                document.getElementById('<%=hdnExpandedAgendaID.ClientID%>').value = '0';

                // 2. Trigger a postback to refresh the UpdatePanel.
                // This will cause the C# code to re-bind the Repeater, and no
                // panels will be set to visible.
                __doPostBack('<%=UpdatePanel1.UniqueID%>', '');
            }

            function showSpeakerProfile(name, designation, company, bio, imageUrl, email, mobile, linkedIn, experience, expertise, projects) {

                // 1. Populate the modal fields
                document.getElementById('modalSpeakerName').innerText = name || 'Speaker Profile';

                // Left Column (Contact)
                document.getElementById('modalSpeakerEmail').innerText = email || 'N/A';
                document.getElementById('modalSpeakerMobile').innerText = mobile || 'N/A';

                var img = document.getElementById('modalSpeakerImage');
                if (imageUrl) {
                    img.src = imageUrl;
                } else {
                    img.src = '/Images/DefaultUser.png'; // Your default placeholder
                }

                var linkedInLink = document.getElementById('modalSpeakerLinkedIn');
                if (linkedIn) {
                    linkedInLink.href = linkedIn;
                    linkedInLink.innerText = 'View Profile';
                } else {
                    linkedInLink.href = '#';
                    linkedInLink.innerText = 'N/A';
                }

                // Right Column (Professional)
                document.getElementById('modalSpeakerDesignation').innerText = designation || 'N/A';
                document.getElementById('modalSpeakerCompany').innerText = company || 'N/A';
                document.getElementById('modalSpeakerExperience').innerText = experience || 'N/A';
                document.getElementById('modalSpeakerBio').innerText = bio || 'No bio available.';
                document.getElementById('modalSpeakerExpertise').innerText = expertise || 'N/A';
                document.getElementById('modalSpeakerProjects').innerText = projects || 'N/A';


                // 2. Show the overlay
                document.getElementById('profileOverlay').classList.add('show');
            }

            // NEW: Hides the speaker profile modal
            function hideSpeakerProfile() {
                document.getElementById('profileOverlay').classList.remove('show');
            }


        </script>
    </form>
</body>
</html>
