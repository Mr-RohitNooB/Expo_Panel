<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageSpeaker.aspx.cs" Inherits="Expo_Panel.Admin.SpeakerDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Speakers - Expo Panel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

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
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        /* Header Styles */
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
                color: #38a169;
                font-size: 28px;
                font-weight: 600;
            }

        /* Dashboard Card */
        .dashboard-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        /* Toolbar */
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

        /* Form Controls */
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
                border-color: #48bb78;
            }

        /* Buttons */
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
            background: #38a169;
            color: white;
        }

            .btn-primary:hover {
                background: #2f855a;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(56, 161, 105, 0.4);
            }

        .btn-success {
            background: #10b981;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }

            .btn-success:hover {
                background: #059669;
            }

        .btn-edit {
            background: #3b82f6;
            color: white;
            padding: 6px 12px;
            font-size: 13px;
        }

            .btn-edit:hover {
                background: #2563eb;
            }

        .btn-danger {
            background: #ef4444;
            color: white;
            padding: 12.5px 12px;
            font-size: 14px;
        }

            .btn-danger:hover {
                background: #dc2626;
            }

        .btn-inactive {
            background: #6b7280;
            color: white;
            padding: 6px 12px;
            font-size: 13px;
        }

            .btn-inactive:hover {
                background: #4b5563;
            }

        .btn-info {
            background: #0ea5e9;
            color: white;
        }

            .btn-info:hover {
                background: #0284c7;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(14, 165, 233, 0.4);
            }

        .btn-warning {
            background: #f59e0b;
            color: white;
            padding: 6px 12px;
            font-size: 13px;
        }

            .btn-warning:hover {
                background: #d97706;
            }

        .btn-view {
            background: #06b6d4;
            color: white;
            padding: 6px 12px;
            font-size: 13px;
        }

            .btn-view:hover {
                background: #0891b2;
            }

        .btn-cancel {
            background: #e2e8f0;
            color: #475569;
        }

            .btn-cancel:hover {
                background: #cbd5e1;
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
                background: #38a169;
                color: white;
                border-color: #38a169;
            }

        /* Table Styles */
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
                padding: 15px 8px;
                text-align: left;
                font-weight: 600;
                color: #475569;
                border-bottom: 2px solid #e2e8f0;
                white-space: nowrap;
                font-size: 13px;
            }

            table td {
                padding: 15px 8px;
                border-bottom: 1px solid #e2e8f0;
                color: #334155;
                font-size: 13px;
            }

            table tbody tr:hover {
                background: #f8fafc;
            }

            table th:nth-child(4),
            table td:nth-child(4) {
                max-width: 100px;
            }

            table th:nth-child(5),
            table td:nth-child(5) {
                max-width: 90px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            table th:nth-child(6),
            table td:nth-child(6) {
                max-width: 120px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            table th:nth-child(8),
            table td:nth-child(8) {
                max-width: 90px;
            }

        /* Toggle Switch */
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 30px;
        }

            .toggle-switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ef4444;
            transition: .4s;
            border-radius: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 8px;
        }

            .toggle-slider:before {
                position: absolute;
                content: "";
                height: 22px;
                width: 22px;
                left: 4px;
                bottom: 4px;
                background-color: white;
                transition: .4s;
                border-radius: 50%;
                box-shadow: 0 2px 4px rgba(0,0,0,0.2);
            }

        .toggle-switch input:checked + .toggle-slider {
            background-color: #10b981;
        }

            .toggle-switch input:checked + .toggle-slider:before {
                transform: translateX(30px);
            }

        .toggle-icon {
            font-size: 12px;
            color: white;
            z-index: 1;
        }

        .toggle-icon-check {
            margin-right: auto;
        }

        .toggle-icon-x {
            margin-left: auto;
        }

        .toggle-button-hidden {
            display: none;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 8px;
        }

            .action-buttons .btn {
                padding: 6px 10px;
                font-size: 12px;
            }

        /* Alert Styles */
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
            box-sizing: border-box;
        }

            .modal-content *,
            .modal-content *::before,
            .modal-content *::after {
                box-sizing: border-box;
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
        }

            .modal-header h2 {
                color: #38a169;
                font-size: 22px;
            }

        .close-btn {
            background: none;
            border: none;
            font-size: 28px;
            color: #6b7280;
            cursor: pointer;
            padding: 0;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

            .close-btn:hover {
                color: #ef4444;
            }

        /* Form Styles */
        .form-group {
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
        }

            .form-group label {
                display: flex;
                align-items: center;
                flex-wrap: wrap;
                margin-bottom: 8px;
                color: #475569;
                font-weight: 500;
                font-size: 13px;
                line-height: 1.4;
            }

                .form-group label span {
                    display: inline;
                    white-space: nowrap;
                }

            .form-group input[type="text"],
            .form-group input[type="email"],
            .form-group input[type="number"],
            .form-group input[type="password"],
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 10px 15px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                font-family: 'Poppins', sans-serif;
                box-sizing: border-box;
            }

                .form-group input:focus,
                .form-group select:focus,
                .form-group textarea:focus {
                    outline: none;
                    border-color: #48bb78;
                }

            .form-group textarea {
                resize: vertical;
                min-height: 100px;
            }

        textarea.form-control {
            resize: vertical;
            min-height: 100px;
            font-family: 'Poppins', sans-serif;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 0;
        }

        .form-row-three {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 0;
        }

        .form-section {
            margin-bottom: 30px;
            padding-bottom: 25px;
            border-bottom: 2px solid #e2e8f0;
        }

            .form-section:last-child {
                border-bottom: none;
                margin-bottom: 0;
            }

            .form-section h3 {
                color: #38a169;
                font-size: 18px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

        /* Modal Footer */
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 12px;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 2px solid #e2e8f0;
        }

            .modal-footer .btn {
                padding: 12px 24px;
                font-size: 14px;
                min-width: 100px;
            }

        /* Checkbox Styles */
        .checkbox-group {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 12px;
            margin-top: 10px;
        }

        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

            .checkbox-item input[type="checkbox"] {
                width: 18px;
                height: 18px;
                cursor: pointer;
                flex-shrink: 0;
            }

            .checkbox-item label {
                margin: 0;
                cursor: pointer;
                font-weight: 400;
                font-size: 14px;
            }

        /* Character Counter */
        .char-counter {
            font-size: 12px;
            color: #64748b;
            text-align: right;
            margin-top: 5px;
        }

        /* Status Filters */
        .status-filters {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        /* Badges */
        .badge-admin {
            background: #dbeafe;
            color: #1e40af;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .badge-online {
            background: #fef3c7;
            color: #92400e;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .badge-status {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .badge-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .badge-approved {
            background: #d1fae5;
            color: #065f46;
        }

        .badge-rejected {
            background: #fee2e2;
            color: #991b1b;
        }

        /* Cell Styles */
        .remarks-cell {
            display: block;
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: help;
        }

        .truncate-cell {
            max-width: 150px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: help;
        }

        /* Password Field */
        .password-field {
            position: relative;
            width: 100%;
        }

            .password-field input {
                width: 100%;
                padding-right: 45px;
            }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6b7280;
            transition: color 0.3s;
        }

            .password-toggle:hover {
                color: #38a169;
            }

        #passwordField {
            display: none;
        }

        #remarksRequired {
            display: none;
        }

        /* Other Styles */
        .no-records {
            text-align: center;
            padding: 40px;
            color: #94a3b8;
            font-size: 16px;
        }

        .inactive-row td {
            color: #94a3b8;
            font-style: italic;
        }

        .inactive-row .action-buttons .btn {
            font-style: normal;
            opacity: 0.6;
        }

        .file-upload-section {
            display: none;
        }

        .rating-display {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .star {
            color: #fbbf24;
        }

        .section-divider {
            margin: 30px 0 20px 0;
            padding: 10px 0;
            border-bottom: 2px solid #e2e8f0;
            color: #38a169;
            font-size: 16px;
            font-weight: 600;
        }

        /* Validation Messages */
        span[style*="color:Red"],
        span[style*="color: Red"],
        span[style*="color: red"] {
            display: block;
            margin-top: 5px;
            font-size: 12px;
            color: #ef4444 !important;
        }

        span[style*="color: red"] {
            color: #ef4444;
            margin-left: 3px;
        }

        /* Dropdown Styling */
        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23475569' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 35px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .form-row,
            .form-row-three {
                grid-template-columns: 1fr;
            }

            .checkbox-group {
                grid-template-columns: 1fr;
            }

            .modal-content {
                width: 95%;
                padding: 20px;
            }

            .modal-footer {
                flex-direction: column-reverse;
            }

                .modal-footer .btn {
                    width: 100%;
                }
        }
        /* Completely transparent file inputs */
        input[type="file"],
        .form-control-file {
            background: transparent !important;
            border: none !important;
            box-shadow: none !important;
            padding: 0 !important;
        }

            /* Transparent button with no background */
            input[type="file"]::file-selector-button,
            input[type="file"]::-webkit-file-upload-button {
                background: transparent;
                border: 1px solid #ced4da;
                padding: 6px 12px;
                border-radius: 4px;
                cursor: pointer;
                color: #495057;
                transition: all 0.2s ease;
            }

                input[type="file"]::file-selector-button:hover,
                input[type="file"]::-webkit-file-upload-button:hover {
                    border-color: #80bdff;
                    color: #0056b3;
                }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="container">
            <div class="header">
                <h1><i class="fas fa-microphone"></i>Manage Speakers</h1>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <span>Welcome,
                            <asp:Label ID="lblUsername" runat="server" Text=""></asp:Label>
                        | Session Status:
                            <asp:Label ID="lblSessionStatus" runat="server" Text=""></asp:Label>
                    </span>
                    <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="~/SuperAdmin/Dashboard.aspx" CssClass="btn btn-info">
                            <i class="fas fa-arrow-left"></i> Back
                    </asp:HyperLink>
                    <asp:Button ID="Button1" runat="server" Text="Logout" CssClass="btn btn-danger" OnClick="btnLogout_Click" />
                </div>
            </div>

            <div class="dashboard-card">
                <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>

                <div class="status-filters">
                    <asp:Button ID="btnPending" runat="server" Text="Pending (0)" CssClass="btn-filter active" OnClick="btnStatusFilter_Click" CommandArgument="Pending" />
                    <asp:Button ID="btnApproved" runat="server" Text="Approved (0)" CssClass="btn-filter" OnClick="btnStatusFilter_Click" CommandArgument="Approved" />
                    <asp:Button ID="btnRejected" runat="server" Text="Rejected (0)" CssClass="btn-filter" OnClick="btnStatusFilter_Click" CommandArgument="Rejected" />
                    <asp:HiddenField ID="hdnCurrentFilter" runat="server" Value="Pending" />
                </div>

                <div class="toolbar">
                    <div class="search-box">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by name, email, mobile, designation, or company..."></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                    </div>
                    <div style="display: flex; gap: 10px;">
                        <a href="/User/RegisterSpeaker.aspx" class="btn btn-info" target="_blank">
                            <i class="fas fa-link"></i>Get Registration Link
                        </a>
                        <a style="background-color:darkorange" href="/User/SpeakerLogin.aspx" class="btn btn-info" target="_blank">
                            <i class="fas fa-link"></i>Get Login Link
                        </a>
                        <button type="button" class="btn btn-success" onclick="openModal('add')">
                            <i class="fas fa-plus"></i>Add Speaker
                        </button>
                    </div>
                </div>

                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="grid-container">
                            <asp:GridView ID="gvSpeakers" runat="server" AutoGenerateColumns="False"
                                OnRowCommand="gvSpeakers_RowCommand" DataKeyNames="SpeakerID"
                                CssClass="speakers-grid" GridLines="None" OnRowDataBound="gvSpeakers_RowDataBound">
                                <Columns>
                                    <asp:BoundField DataField="SpeakerID" HeaderText="ID" Visible="false" />

                                    <asp:TemplateField HeaderText="Sr. No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:BoundField DataField="Name" HeaderText="Name" />
                                    <asp:BoundField DataField="Email" HeaderText="Email" />
                                    <asp:BoundField DataField="Mobile" HeaderText="Mobile" />
                                    <asp:BoundField DataField="Designation" HeaderText="Designation" />
                                    <asp:BoundField DataField="Company" HeaderText="Company" />

                                    <asp:TemplateField HeaderText="Reg. Type">
                                        <ItemTemplate>
                                            <span class='<%# "badge-" + Eval("RegistrationType").ToString().ToLower() %>'>
                                                <%# Eval("RegistrationType") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Approval">
                                        <ItemTemplate>
                                            <span class='<%# "badge-status badge-" + Eval("ApprovalStatus").ToString().ToLower() %>'>
                                                <%# Eval("ApprovalStatus") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Remarks">
                                        <ItemTemplate>
                                            <span class="remarks-cell" title='<%# Eval("Remarks") %>'>
                                                <%# Eval("Remarks") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <label class="toggle-switch">
                                                <input type="checkbox"
                                                    <%# (bool)Eval("IS_ACTIVE") ? "checked" : "" %>
                                                    onchange="toggleStatusSimple(this)">
                                                <span class="toggle-slider">
                                                    <i class="fas fa-check toggle-icon toggle-icon-check"></i>
                                                    <i class="fas fa-times toggle-icon toggle-icon-x"></i>
                                                </span>
                                            </label>
                                            <asp:Button runat="server"
                                                CommandName="QuickToggle"
                                                CommandArgument='<%# Eval("SpeakerID") %>'
                                                CssClass="toggle-button-hidden"
                                                ID="btnToggleHidden" />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <div class="action-buttons">
                                                <button type="button" class="btn btn-edit"
                                                    onclick="handleEditClick(<%# Eval("SpeakerID") %>)">
                                                    <i class="fas fa-edit"></i>Edit
                                                </button>

                                                <button type="button" class="btn btn-warning"
                                                    onclick="handleApprovalClick(<%# Eval("SpeakerID") %>)">
                                                    <i class="fas fa-check-circle"></i>Approve/Reject
                                                </button>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="no-records">
                                        <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 15px; display: block;"></i>
                                        No speakers found. Click "Add Speaker" to create one.
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>

        <!-- Add/Edit Modal -->
        <div id="speakerModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitle">Add Speaker</h2>
                    <button type="button" class="close-btn" onclick="closeModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnSpeakerID" runat="server" Value="0" />
                <asp:HiddenField ID="hdnModalMode" runat="server" Value="add" />
                <asp:HiddenField ID="hdnApproveSpeakerID" runat="server" Value="0" />
                <asp:Button ID="btnTriggerApproval" runat="server" OnClick="btnTriggerApproval_Click" Style="display: none;" />
                <asp:HiddenField ID="hdnEditSpeakerID" runat="server" Value="0" />
                <asp:Button ID="btnTriggerEdit" runat="server" OnClick="btnTriggerEdit_Click" Style="display: none;" />
                <!-- Section 1: Personal Information -->
                <div class="form-section">
                    <h3><i class="fas fa-user"></i>Personal Information</h3>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="<%=txtName.ClientID%>">Full Name <span style="color: red;">*</span></label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter full name"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                                ErrorMessage="Name is required" ForeColor="Red" Display="Dynamic" ValidationGroup="SpeakerValidation"></asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label for="<%=txtEmail.ClientID%>">Email Address <span style="color: red;">*</span></label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter email address"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                                ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic" ValidationGroup="SpeakerValidation"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                                ErrorMessage="Invalid email format" ForeColor="Red" Display="Dynamic"
                                ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" ValidationGroup="SpeakerValidation"></asp:RegularExpressionValidator>
                        </div>
                    </div>

                    <div class="form-row-three">
                        <div class="form-group">
                            <label for="<%=txtMobile.ClientID%>">Mobile Number</label>
                            <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" placeholder="Enter mobile number"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="<%=txtDesignation.ClientID%>">Designation <span style="color: red;">*</span></label>
                            <asp:TextBox ID="txtDesignation" runat="server" CssClass="form-control" placeholder="Enter designation"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvDesignation" runat="server" ControlToValidate="txtDesignation"
                                ErrorMessage="Designation is required" ForeColor="Red" Display="Dynamic" ValidationGroup="SpeakerValidation"></asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label for="<%=txtYearsOfExperience.ClientID%>">Years of Experience</label>
                            <asp:TextBox ID="txtYearsOfExperience" runat="server" CssClass="form-control" TextMode="Number" placeholder="Enter years" min="0"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="<%=txtCompany.ClientID%>">Company/Organization <span style="color: red;">*</span></label>
                            <asp:TextBox ID="txtCompany" runat="server" CssClass="form-control" placeholder="Enter company name"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvCompany" runat="server" ControlToValidate="txtCompany"
                                ErrorMessage="Company is required" ForeColor="Red" Display="Dynamic" ValidationGroup="SpeakerValidation"></asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label for="<%=txtLinkedInProfile.ClientID%>">LinkedIn Profile</label>
                            <asp:TextBox ID="txtLinkedInProfile" runat="server" CssClass="form-control" placeholder="Enter LinkedIn profile URL"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="<%=ddlStatus.ClientID%>">Status</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Active" Value="1" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>


                </div>

                <!-- Profile & Media Section -->
                <div class="form-group">
                    <h4>Profile & Media</h4>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Upload Your Photo</label>
                            <asp:FileUpload ID="fuPhoto" runat="server" CssClass="form-control-file" />
                            <small class="form-text text-muted">JPG, PNG</small>
                            <asp:Label ID="lblCurrentPhoto" runat="server" CssClass="text-info mt-2" Visible="false"></asp:Label>
                        </div>

                        <div class="form-group col-md-6">
                            <label for="fuLogo">Company Logo (High Resolution)</label>
                            <asp:FileUpload ID="fuLogo" runat="server" CssClass="form-control-file" accept="image/*" />
                            <small class="form-text text-muted">Upload company logo (JPG or PNG)</small>
                            <asp:Label ID="lblCurrentLogo" runat="server" CssClass="text-info mt-2" Visible="false"></asp:Label>
                        </div>
                    </div>
                </div>



                <!-- Section 2: Professional Profile -->
                <div class="form-section">
                    <h3><i class="fas fa-briefcase"></i>Professional Profile</h3>

                    <div class="form-group">
                        <label for="<%=txtProfessionalBio.ClientID%>">Professional Bio (150-250 words recommended)</label>
                        <asp:TextBox ID="txtProfessionalBio" runat="server" CssClass="form-control" TextMode="MultiLine"
                            Rows="5" placeholder="Enter professional bio for promotional and agenda material"
                            onkeyup="updateCharCount('<%=txtProfessionalBio.ClientID%>', 'bioCharCount')"></asp:TextBox>
                        <div id="bioCharCount" class="char-counter">0 characters</div>
                    </div>

                    <div class="form-group">
                        <label>Areas of Expertise</label>
                        <div class="checkbox-group">
                            <div class="checkbox-item">
                                <input type="checkbox" id="chkBaseOils" />
                                <label for="chkBaseOils">Base Oils</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="chkAdditives" />
                                <label for="chkAdditives">Lubricant Additives</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="chkIndustrial" />
                                <label for="chkIndustrial">Industrial Lubrication</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="chkAutomotive" />
                                <label for="chkAutomotive">Automotive & EV Fluids</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="chkSynthetic" />
                                <label for="chkSynthetic">Synthetic and Bio-Based Lubricants</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="chkSustainability" />
                                <label for="chkSustainability">Sustainability & Circularity</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="chkTribology" />
                                <label for="chkTribology">Tribology & Wear Performance</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="chkMonitoring" />
                                <label for="chkMonitoring">Condition Monitoring</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="chkRegulatory" />
                                <label for="chkRegulatory">Regulatory Compliance</label>
                            </div>
                        </div>
                        <asp:TextBox ID="txtOtherExpertise" runat="server" CssClass="form-control" placeholder="Other areas (please specify)" Style="margin-top: 10px;"></asp:TextBox>
                        <asp:HiddenField ID="hdnAreasOfExpertise" runat="server" />
                    </div>
                </div>

                <!-- Section 3: Current Work & Projects -->
                <div class="form-section">
                    <h3><i class="fas fa-project-diagram"></i>Current Work & Projects</h3>

                    <div class="form-group">
                        <label for="<%=txtCurrentWorkProjects.ClientID%>">Description of Current Projects/Research/Initiatives</label>
                        <asp:TextBox ID="txtCurrentWorkProjects" runat="server" CssClass="form-control" TextMode="MultiLine"
                            Rows="4" placeholder="Describe your current work, projects, research or industry initiatives"
                            onkeyup="updateCharCount('<%=txtCurrentWorkProjects.ClientID%>', 'workCharCount')"></asp:TextBox>
                        <div id="workCharCount" class="char-counter">0 characters</div>
                    </div>

                    <div class="form-group">
                        <label for="<%=txtSuggestedTopics.ClientID%>">Suggested Topics/Themes (2-3 topics recommended)</label>
                        <asp:TextBox ID="txtSuggestedTopics" runat="server" CssClass="form-control" TextMode="MultiLine"
                            Rows="3" placeholder="List 2-3 topics that reflect your current work or thought leadership areas"></asp:TextBox>
                    </div>
                </div>

                <!-- Section 4: Discussion Format & Speaking Experience -->
                <div class="form-section">
                    <h3><i class="fas fa-comments"></i>Discussion Format & Speaking Experience</h3>

                    <div class="form-group">
                        <label>Preferred Discussion Format (Select all that apply)</label>
                        <div class="checkbox-group">
                            <div class="checkbox-item">
                                <input type="checkbox" id="chkPanel" />
                                <label for="chkPanel">Panel Discussion</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="chkPresentation" />
                                <label for="chkPresentation">Technical Presentation</label>
                            </div>
                        </div>
                        <asp:HiddenField ID="hdnPreferredFormat" runat="server" />
                    </div>

                    <div class="form-group">
                        <label for="<%=txtPreviousSpeakingEngagements.ClientID%>">Previous Speaking Engagements</label>
                        <asp:TextBox ID="txtPreviousSpeakingEngagements" runat="server" CssClass="form-control" TextMode="MultiLine"
                            Rows="4" placeholder="List any conferences, webinars or forums where you've recently spoken. Include links to recordings or published content if available."
                            onkeyup="updateCharCount('<%=txtPreviousSpeakingEngagements.ClientID%>', 'engagementsCharCount')"></asp:TextBox>
                        <div id="engagementsCharCount" class="char-counter">0 characters</div>
                    </div>
                </div>

                <!-- Section 5: Consent & Availability -->
                <div class="form-section">
                    <h3><i class="fas fa-check-circle"></i>Consent & Availability</h3>

                    <div class="form-group">
                        <label for="<%=ddlIsAvailable.ClientID%>">Are you available to speak during the scheduled event dates? <span style="color: red;">*</span></label>
                        <asp:DropDownList ID="ddlIsAvailable" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Yes" Value="Yes" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="No" Value="No"></asp:ListItem>
                            <asp:ListItem Text="Tentative" Value="Tentative"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkMarketingConsent" runat="server" />
                            <label for="<%=chkMarketingConsent.ClientID%>">
                                I consent to the use of my photo, name and bio in event marketing materials
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Section 6: Topic Selection -->
                <div class="form-section">
                    <h3><i class="fas fa-list"></i>Topic Selection</h3>

                    <div class="form-group">
                        <label>Select Topics You'd Like to Speak On</label>
                        <p style="font-size: 12px; color: #64748b; margin-bottom: 10px;">
                            You can select up to 3 topics. Currently selected: <span id="topicCount">0</span>/3
                        </p>
                        <div style="max-height: 300px; overflow-y: auto; border: 1px solid #e2e8f0; border-radius: 8px;">
                            <asp:Repeater ID="rptAvailableAgendas" runat="server">
                                <HeaderTemplate>
                                    <table style="width: 100%; border-collapse: collapse;">
                                        <thead style="position: sticky; top: 0; background-color: #f8fafc; z-index: 1;">
                                            <tr>
                                                <th style="width: 50px; padding: 10px; text-align: center; border-bottom: 2px solid #e2e8f0;">Select</th>
                                                <th style="padding: 10px; border-bottom: 2px solid #e2e8f0;">Topic Title</th>
                                                <th style="padding: 10px; border-bottom: 2px solid #e2e8f0;">Day & Time</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td style="text-align: center; padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                            <input type="checkbox" class="agenda-checkbox" value='<%# Eval("AgendaID") %>' data-title='<%# Eval("Title") %>' />
                                        </td>
                                        <td style="padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                            <strong><%# Eval("Title") %></strong>
                                            <br />
                                            <small style="color: #64748b;"><%# Eval("Description") %></small>
                                        </td>
                                        <td style="padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                            <small><%# Eval("StartTime") %></small>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </tbody>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                        <asp:HiddenField ID="hdnSelectedAgendas" runat="server" />
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeModal()">Cancel</button>
                    <asp:Button ID="btnSaveSpeaker" runat="server" Text="Save" CssClass="btn btn-primary"
                        OnClick="btnSaveSpeaker_Click" ValidationGroup="SpeakerValidation"
                        OnClientClick="collectCheckboxData()" />
                </div>
            </div>
        </div>

        <!-- Approval/Rejection Modal -->
        <div id="approvalModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="approvalModalTitle">Approve/Reject Speaker</h2>
                    <button type="button" class="close-btn" onclick="closeApprovalModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnApprovalSpeakerID" runat="server" Value="0" />

                <div class="form-group">
                    <label>Name</label>
                    <asp:TextBox ID="txtApprovalName" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <asp:TextBox ID="txtApprovalEmail" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>
                <div class="form-group" style="display: none;">
                    <label>Registration Type</label>
                    <asp:TextBox ID="txtApprovalRegType" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Designation</label>
                        <asp:TextBox ID="txtApprovalDesignation" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Company</label>
                        <asp:TextBox ID="txtApprovalCompany" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label for="<%=ddlApprovalStatus.ClientID%>">Approval Status <span style="color: red;">*</span></label>
                    <asp:DropDownList ID="ddlApprovalStatus" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                        <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                        <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <!-- In the Approval Modal, after the Remarks field -->
                <div class="form-group" id="passwordField">
                    <label for="<%=txtPassword.ClientID%>">Password <span class="required" id="passwordRequired" style="display: none;">*</span></label>
                    <div class="password-field" style="position: relative;">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter password for approved speaker"></asp:TextBox>
                        <span class="password-toggle" onclick="togglePasswordField()" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #6b7280;">
                            <i class="fas fa-eye"></i>
                        </span>
                    </div>
                    <small style="color: #6b7280; font-size: 12px;">Password will be auto-generated if left empty on approval</small>
                </div>


                <div class="form-group">
                    <label for="<%=txtApprovalRemarks.ClientID%>">Remarks <span style="color: red;" id="remarksRequired">*</span></label>
                    <asp:TextBox ID="txtApprovalRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Enter remarks (required for rejection)"></asp:TextBox>
                    <asp:CustomValidator ID="cvRemarks" runat="server"
                        ControlToValidate="txtApprovalRemarks"
                        ClientValidationFunction="validateRemarks"
                        OnServerValidate="cvRemarks_ServerValidate"
                        ErrorMessage="Remarks are required for rejection"
                        ForeColor="Red" Display="Dynamic"
                        ValidationGroup="ApprovalValidation"></asp:CustomValidator>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeApprovalModal()">Cancel</button>
                    <asp:Button ID="btnSaveApproval" runat="server" Text="Save" CssClass="btn btn-primary"
                        OnClick="btnSaveApproval_Click" ValidationGroup="ApprovalValidation" />
                </div>
            </div>
        </div>
        <!-- Applications Modal -->
        <div id="applicationsModal" class="modal">
            <div class="modal-content" style="max-width: 1200px;">
                <div class="modal-header">
                    <h2>Speaker Applications</h2>
                    <button type="button" class="close-btn" onclick="closeApplicationsModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnViewSpeakerID" runat="server" Value="0" />

                <div style="margin-bottom: 20px; padding: 15px; background: #f0fdf4; border-radius: 8px;">
                    <strong>Speaker:</strong>
                    <asp:Label ID="lblApplicationsSpeakerName" runat="server"></asp:Label><br />
                    <strong>Email:</strong>
                    <asp:Label ID="lblApplicationsSpeakerEmail" runat="server"></asp:Label>
                </div>

                <asp:UpdatePanel ID="UpdatePanelApplications" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="gvSpeakerApplications" runat="server" AutoGenerateColumns="False"
                            OnRowCommand="gvSpeakerApplications_RowCommand"
                            CssClass="agenda-grid" GridLines="None">
                            <Columns>
                                <asp:TemplateField HeaderText="Sr.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:BoundField DataField="Day" HeaderText="Day" />
                                <asp:BoundField DataField="AgendaTitle" HeaderText="Topic" />
                                <asp:BoundField DataField="Track" HeaderText="Track" />
                                <asp:BoundField DataField="Time" HeaderText="Time" />

                                <asp:TemplateField HeaderText="Motivation">
                                    <ItemTemplate>
                                        <span class="truncate-cell" title='<%# Eval("MotivationStatement") %>'>
                                            <%# Eval("MotivationStatement") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Relevance">
                                    <ItemTemplate>
                                        <span class="truncate-cell" title='<%# Eval("RelevanceToExpertise") %>'>
                                            <%# Eval("RelevanceToExpertise") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Advisory Rating">
                                    <ItemTemplate>
                                        <%# Eval("AdvisoryRating") != DBNull.Value ? 
                                        string.Format("<div class='rating-display'>{0}/5 <i class='fas fa-star star'></i></div>", 
                                        Math.Round(Convert.ToDecimal(Eval("AdvisoryRating")), 1)) : 
                                        "<span style='color: #94a3b8;'>No Rating</span>" %>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='<%# "badge-status badge-" + Eval("Status").ToString().ToLower() %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:BoundField DataField="ApplicationDate" HeaderText="Applied On" DataFormatString="{0:dd MMM yyyy}" />

                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <div class="action-buttons">
                                            <asp:Button runat="server" Text="Review"
                                                CommandName="ReviewApplication"
                                                CommandArgument='<%# Eval("InterestID") %>'
                                                CssClass="btn btn-warning" />
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="no-records">
                                    <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 15px; display: block;"></i>
                                    This speaker has not applied for any topics yet.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>

                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeApplicationsModal()">Close</button>
                </div>
            </div>
        </div>

        <!-- Application Review Modal -->
        <div id="applicationReviewModal" class="modal">
            <div class="modal-content" style="max-width: 900px;">
                <div class="modal-header">
                    <h2>Review Application</h2>
                    <button type="button" class="close-btn" onclick="closeApplicationReviewModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnReviewInterestID" runat="server" Value="0" />

                <!-- Speaker Info -->
                <div class="section-divider">
                    <i class="fas fa-user"></i>Speaker Information
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Speaker Name</label>
                        <asp:TextBox ID="txtReviewSpeakerName" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Company</label>
                        <asp:TextBox ID="txtReviewCompany" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Designation</label>
                        <asp:TextBox ID="txtReviewDesignation" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Years of Experience</label>
                        <asp:TextBox ID="txtReviewExperience" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label>Areas of Expertise</label>
                    <asp:TextBox ID="txtReviewExpertise" runat="server" TextMode="MultiLine" Rows="2" ReadOnly="true"></asp:TextBox>
                </div>

                <!-- Agenda Info -->
                <div class="section-divider">
                    <i class="fas fa-calendar-alt"></i>Topic Information
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Day</label>
                        <asp:TextBox ID="txtReviewDay" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Track</label>
                        <asp:TextBox ID="txtReviewTrack" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label>Topic Title</label>
                    <asp:TextBox ID="txtReviewAgendaTitle" runat="server" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Topic Brief</label>
                    <asp:TextBox ID="txtReviewAgendaBrief" runat="server" TextMode="MultiLine" Rows="2" ReadOnly="true"></asp:TextBox>
                </div>

                <!-- Application Details -->
                <div class="section-divider">
                    <i class="fas fa-file-alt"></i>Application Details
                </div>

                <div class="form-group">
                    <label>Why do they want to speak on this topic?</label>
                    <asp:TextBox ID="txtReviewMotivation" runat="server" TextMode="MultiLine" Rows="4" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>How does this topic align with their expertise?</label>
                    <asp:TextBox ID="txtReviewRelevance" runat="server" TextMode="MultiLine" Rows="4" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Advisory Board Rating</label>
                    <asp:TextBox ID="txtReviewRating" runat="server" ReadOnly="true"></asp:TextBox>
                </div>

                <!-- Admin Decision -->
                <div class="section-divider">
                    <i class="fas fa-check-circle"></i>Admin Decision
                </div>

                <div class="form-group">
                    <label for="<%=ddlApplicationStatus.ClientID%>">Status <span class="required">*</span></label>
                    <asp:DropDownList ID="ddlApplicationStatus" runat="server">
                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                        <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                        <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label for="<%=txtApplicationRemarks.ClientID%>">Admin Remarks <span class="required" id="appRemarksRequired" style="display: none;">*</span></label>
                    <asp:TextBox ID="txtApplicationRemarks" runat="server" TextMode="MultiLine" Rows="3"
                        placeholder="Enter remarks (required for rejection)"></asp:TextBox>
                    <asp:CustomValidator ID="cvApplicationRemarks" runat="server"
                        ControlToValidate="txtApplicationRemarks"
                        ClientValidationFunction="validateApplicationRemarks"
                        OnServerValidate="cvApplicationRemarks_ServerValidate"
                        ErrorMessage="Remarks are required for rejection"
                        ForeColor="Red" Display="Dynamic"
                        ValidationGroup="ApplicationReviewValidation"></asp:CustomValidator>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeApplicationReviewModal()">Cancel</button>
                    <asp:Button ID="btnSaveApplicationReview" runat="server" Text="Save Decision"
                        CssClass="btn btn-primary" OnClick="btnSaveApplicationReview_Click"
                        ValidationGroup="ApplicationReviewValidation" />
                </div>
            </div>
        </div>

        <script type="text/javascript">
            function updateCharCount(textboxId, counterId) {
                var textbox = document.getElementById(textboxId);
                var counter = document.getElementById(counterId);
                if (textbox && counter) {
                    counter.textContent = textbox.value.length + ' characters';
                }
            }


            function collectCheckboxData() {
                console.log('collectCheckboxData called'); // Debug log

                // Collect Areas of Expertise
                var expertiseCheckboxes = ['chkBaseOils', 'chkAdditives', 'chkIndustrial', 'chkAutomotive',
                    'chkSynthetic', 'chkSustainability', 'chkTribology', 'chkMonitoring', 'chkRegulatory'];
                var selectedExpertise = [];

                expertiseCheckboxes.forEach(function (id) {
                    var checkbox = document.getElementById(id);
                    if (checkbox && checkbox.checked) {
                        selectedExpertise.push(checkbox.nextElementSibling.textContent);
                    }
                });

                var otherExpertise = document.getElementById('<%=txtOtherExpertise.ClientID%>').value.trim();
                if (otherExpertise) {
                    selectedExpertise.push('Other: ' + otherExpertise);
                }

                document.getElementById('<%=hdnAreasOfExpertise.ClientID%>').value = selectedExpertise.join(', ');
                console.log('Areas of Expertise:', selectedExpertise.join(', ')); // Debug log

                // Collect Preferred Format
                var formatCheckboxes = ['chkPanel', 'chkPresentation'];
                var selectedFormats = [];

                formatCheckboxes.forEach(function (id) {
                    var checkbox = document.getElementById(id);
                    if (checkbox && checkbox.checked) {
                        selectedFormats.push(checkbox.nextElementSibling.textContent);
                    }
                });

                document.getElementById('<%=hdnPreferredFormat.ClientID%>').value = selectedFormats.join(', ');
                console.log('Preferred Format:', selectedFormats.join(', ')); // Debug log

                // ✅ CRITICAL FIX: Collect Selected Agendas
                var selectedAgendaIds = [];
                var agendaCheckboxes = document.querySelectorAll('.agenda-checkbox:checked');

                agendaCheckboxes.forEach(function (checkbox) {
                    selectedAgendaIds.push(checkbox.value);
                });

                var selectedAgendasStr = selectedAgendaIds.join(',');
                document.getElementById('<%=hdnSelectedAgendas.ClientID%>').value = selectedAgendasStr;

                console.log('Selected Agenda IDs:', selectedAgendasStr); // Debug log
                console.log('Total selected agendas:', selectedAgendaIds.length); // Debug log

                return true; // Allow form submission to continue
            }



            function setCheckboxValues(expertiseStr, formatStr) {
                // Clear all checkboxes first
                document.getElementById('chkBaseOils').checked = false;
                document.getElementById('chkAdditives').checked = false;
                document.getElementById('chkIndustrial').checked = false;
                document.getElementById('chkAutomotive').checked = false;
                document.getElementById('chkSynthetic').checked = false;
                document.getElementById('chkSustainability').checked = false;
                document.getElementById('chkTribology').checked = false;
                document.getElementById('chkMonitoring').checked = false;
                document.getElementById('chkRegulatory').checked = false;
                document.getElementById('chkPanel').checked = false;
                document.getElementById('chkPresentation').checked = false;
                document.getElementById('<%=txtOtherExpertise.ClientID%>').value = '';

                // Set Areas of Expertise
                if (expertiseStr) {
                    var expertiseArr = expertiseStr.split(', ');
                    expertiseArr.forEach(function (item) {
                        if (item === 'Base Oils') document.getElementById('chkBaseOils').checked = true;
                        else if (item === 'Lubricant Additives') document.getElementById('chkAdditives').checked = true;
                        else if (item === 'Industrial Lubrication') document.getElementById('chkIndustrial').checked = true;
                        else if (item === 'Automotive & EV Fluids') document.getElementById('chkAutomotive').checked = true;
                        else if (item === 'Synthetic and Bio-Based Lubricants') document.getElementById('chkSynthetic').checked = true;
                        else if (item === 'Sustainability & Circularity') document.getElementById('chkSustainability').checked = true;
                        else if (item === 'Tribology & Wear Performance') document.getElementById('chkTribology').checked = true;
                        else if (item === 'Condition Monitoring') document.getElementById('chkMonitoring').checked = true;
                        else if (item === 'Regulatory Compliance') document.getElementById('chkRegulatory').checked = true;
                        else if (item.startsWith('Other: ')) {
                            document.getElementById('<%=txtOtherExpertise.ClientID%>').value = item.substring(7);
                        }
                    });
                }

                // Set Preferred Format
                if (formatStr) {
                    var formatArr = formatStr.split(', ');
                    formatArr.forEach(function (item) {
                        if (item === 'Panel Discussion') document.getElementById('chkPanel').checked = true;
                        else if (item === 'Technical Presentation') document.getElementById('chkPresentation').checked = true;
                    });
                }
            }

            function toggleStatusSimple(checkbox) {
                var row = checkbox.closest('tr');
                if (!row) {
                    console.error('Row not found');
                    checkbox.checked = !checkbox.checked;
                    return;
                }

                var btn = row.querySelector('.toggle-button-hidden');
                if (btn) {
                    btn.click();
                } else {
                    console.error('Toggle button not found in row');
                    checkbox.checked = !checkbox.checked;
                    alert('Error: Could not find toggle button');
                }
            }

            function openModal(mode, speakerData) {
                var modal = document.getElementById('speakerModal');
                var modalTitle = document.getElementById('modalTitle');

                if (mode === 'add') {
                    modalTitle.textContent = 'Add Speaker';
                    document.getElementById('<%=hdnSpeakerID.ClientID%>').value = '0';
                    document.getElementById('<%=hdnModalMode.ClientID%>').value = 'add';

                    // Clear all form fields
                    document.getElementById('<%=txtName.ClientID%>').value = '';
                    document.getElementById('<%=txtEmail.ClientID%>').value = '';
                    document.getElementById('<%=txtMobile.ClientID%>').value = '';
                    document.getElementById('<%=txtDesignation.ClientID%>').value = '';
                    document.getElementById('<%=txtCompany.ClientID%>').value = '';
                    document.getElementById('<%=txtLinkedInProfile.ClientID%>').value = '';
                    document.getElementById('<%=txtYearsOfExperience.ClientID%>').value = '';
                    document.getElementById('<%=txtProfessionalBio.ClientID%>').value = '';
                    document.getElementById('<%=txtCurrentWorkProjects.ClientID%>').value = '';
                    document.getElementById('<%=txtSuggestedTopics.ClientID%>').value = '';
                    document.getElementById('<%=txtPreviousSpeakingEngagements.ClientID%>').value = '';
                    document.getElementById('<%=ddlStatus.ClientID%>').value = '1';
                    document.getElementById('<%=ddlIsAvailable.ClientID%>').value = 'Yes';
                    document.getElementById('<%=chkMarketingConsent.ClientID%>').checked = false;

                    // Clear checkboxes
                    document.querySelectorAll('.agenda-checkbox').forEach(cb => cb.checked = false);
                    document.getElementById('topicCount').textContent = '0';

                }
                else if (mode === 'edit' && speakerData) {
                    modalTitle.textContent = 'Edit Speaker';
                    document.getElementById('<%=hdnSpeakerID.ClientID%>').value = speakerData.id;
                    document.getElementById('<%=hdnModalMode.ClientID%>').value = 'edit';

                    // Populate form fields
                    document.getElementById('<%=txtName.ClientID%>').value = speakerData.name || '';
                    document.getElementById('<%=txtEmail.ClientID%>').value = speakerData.email || '';
                    document.getElementById('<%=txtMobile.ClientID%>').value = speakerData.mobile || '';
                    document.getElementById('<%=txtDesignation.ClientID%>').value = speakerData.designation || '';
                    document.getElementById('<%=txtCompany.ClientID%>').value = speakerData.company || '';
                    document.getElementById('<%=txtYearsOfExperience.ClientID%>').value = speakerData.yearsOfExperience || '';
                    document.getElementById('<%=txtLinkedInProfile.ClientID%>').value = speakerData.linkedInProfile || '';
                    document.getElementById('<%=txtProfessionalBio.ClientID%>').value = speakerData.professionalBio || '';
                    document.getElementById('<%=txtCurrentWorkProjects.ClientID%>').value = speakerData.currentWorkProjects || '';
                    document.getElementById('<%=txtSuggestedTopics.ClientID%>').value = speakerData.suggestedTopics || '';
                    document.getElementById('<%=txtPreviousSpeakingEngagements.ClientID%>').value = speakerData.previousSpeakingEngagements || '';
                    document.getElementById('<%=ddlStatus.ClientID%>').value = speakerData.isActive || '1';
                    document.getElementById('<%=ddlIsAvailable.ClientID%>').value = speakerData.isAvailable || 'Yes';
                    document.getElementById('<%=chkMarketingConsent.ClientID%>').checked = speakerData.marketingConsent || false;

                    // ✅ FIX 1: POPULATE THE 'AREAS OF EXPERTISE' CHECKBOXES
                    setCheckboxValues(speakerData.areasOfExpertise, speakerData.preferredDiscussionFormat);

                    // ✅ FIX 2: RESET THE 'AGENDAS' LIST (so the C# script can re-check the correct ones)
                    resetTopicSelection();

                    // Update character counters
                    updateCharCount('<%=txtProfessionalBio.ClientID%>', 'bioCharCount');
                    updateCharCount('<%=txtCurrentWorkProjects.ClientID%>', 'workCharCount');
                    updateCharCount('<%=txtPreviousSpeakingEngagements.ClientID%>', 'engagementsCharCount');
                }

                // Show the modal
                modal.classList.add('show');
            }

            function closeModal() {
                var modal = document.getElementById('speakerModal');
                modal.classList.remove('show');
            }


            function openApprovalModal(id, name, email, designation, company, approvalStatus, remarks, password) {
                document.getElementById('<%=hdnApprovalSpeakerID.ClientID%>').value = id;
                document.getElementById('<%=txtApprovalName.ClientID%>').value = name;
                document.getElementById('<%=txtApprovalEmail.ClientID%>').value = email;
                // document.getElementById('<%=txtApprovalRegType.ClientID%>').value = regType; // <-- REMOVED
                document.getElementById('<%=txtApprovalDesignation.ClientID%>').value = designation;
                document.getElementById('<%=txtApprovalCompany.ClientID%>').value = company;
                document.getElementById('<%=ddlApprovalStatus.ClientID%>').value = approvalStatus;
                document.getElementById('<%=txtApprovalRemarks.ClientID%>').value = remarks || '';
                document.getElementById('<%=txtPassword.ClientID%>').value = password || '';

                var modal = document.getElementById('approvalModal');
                modal.classList.add('show');

                toggleRemarksRequired();
            }

            function closeApprovalModal() {
                var modal = document.getElementById('approvalModal');
                modal.classList.remove('show');
            }

            function toggleRemarksRequired() {
                var status = document.getElementById('<%=ddlApprovalStatus.ClientID%>').value;
                var remarksReq = document.getElementById('remarksRequired');
                var passwordReq = document.getElementById('passwordRequired');
                var passwordField = document.getElementById('passwordField');

                if (status === 'Rejected') {
                    if (remarksReq) remarksReq.style.display = 'inline';
                    if (passwordReq) passwordReq.style.display = 'none';
                    if (passwordField) passwordField.style.display = 'none';
                } else if (status === 'Approved') {
                    if (remarksReq) remarksReq.style.display = 'none';
                    if (passwordReq) passwordReq.style.display = 'inline';
                    if (passwordField) passwordField.style.display = 'block';
                } else {
                    if (remarksReq) remarksReq.style.display = 'none';
                    if (passwordReq) passwordReq.style.display = 'none';
                    if (passwordField) passwordField.style.display = 'none';
                }
            }

            function togglePasswordField() {
                var field = document.getElementById('<%=txtPassword.ClientID%>');
                var icon = event.target.closest('.password-toggle').querySelector('i');

                if (field.type === 'password') {
                    field.type = 'text';
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                } else {
                    field.type = 'password';
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                }
            }

            function validateRemarks(sender, args) {
                var status = document.getElementById('<%=ddlApprovalStatus.ClientID%>').value;
                var remarks = document.getElementById('<%=txtApprovalRemarks.ClientID%>').value.trim();

                if (status === 'Rejected' && remarks === '') {
                    args.IsValid = false;
                } else {
                    args.IsValid = true;
                }
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                var speakerModal = document.getElementById('speakerModal');
                var approvalModal = document.getElementById('approvalModal');
                var applicationsModal = document.getElementById('applicationsModal');
                var applicationReviewModal = document.getElementById('applicationReviewModal');

                if (event.target == speakerModal) {
                    closeModal();
                }
                if (event.target == approvalModal) {
                    closeApprovalModal();
                }
                if (event.target == applicationsModal) {
                    closeApplicationsModal();
                }
                if (event.target == applicationReviewModal) {
                    closeApplicationReviewModal();
                }
            }


            document.addEventListener('DOMContentLoaded', function () {
                // Use event delegation for agenda checkboxes
                document.addEventListener('change', function (e) {
                    if (e.target.classList.contains('agenda-checkbox')) {
                        var checkedCount = document.querySelectorAll('.agenda-checkbox:checked').length;
                        document.getElementById('topicCount').textContent = checkedCount;

                        // Disable unchecked boxes if 3 are selected
                        if (checkedCount >= 3) {
                            document.querySelectorAll('.agenda-checkbox:not(:checked)').forEach(function (cb) {
                                cb.disabled = true;
                            });
                        } else {
                            document.querySelectorAll('.agenda-checkbox').forEach(function (cb) {
                                cb.disabled = false;
                            });
                        }

                        // Update hidden field immediately
                        var selectedIds = [];
                        document.querySelectorAll('.agenda-checkbox:checked').forEach(function (cb) {
                            selectedIds.push(cb.value);
                        });
                        document.getElementById('<%=hdnSelectedAgendas.ClientID%>').value = selectedIds.join(',');

                        console.log('Agenda selection changed. Current selection:', selectedIds.join(',')); // Debug log
                    }
                });
            });

            function openApplicationsModal() {
                var modal = document.getElementById('applicationsModal');
                modal.classList.add('show');
            }

            function closeApplicationsModal() {
                var modal = document.getElementById('applicationsModal');
                modal.classList.remove('show');
            }

            function openApplicationReviewModal() {
                var modal = document.getElementById('applicationReviewModal');
                modal.classList.add('show');
                toggleApplicationRemarksRequired();
            }

            function closeApplicationReviewModal() {
                var modal = document.getElementById('applicationReviewModal');
                modal.classList.remove('show');
            }

            function toggleApplicationRemarksRequired() {
                var status = document.getElementById('<%=ddlApplicationStatus.ClientID%>').value;
                var remarksReq = document.getElementById('appRemarksRequired');
                if (status === 'Rejected') {
                    remarksReq.style.display = 'inline';
                } else {
                    remarksReq.style.display = 'none';
                }
            }

            function validateApplicationRemarks(sender, args) {
                var status = document.getElementById('<%=ddlApplicationStatus.ClientID%>').value;
                var remarks = document.getElementById('<%=txtApplicationRemarks.ClientID%>').value.trim();

                if (status === 'Rejected' && remarks === '') {
                    args.IsValid = false;
                } else {
                    args.IsValid = true;
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                var ddlApproval = document.getElementById('<%=ddlApprovalStatus.ClientID%>');
                if (ddlApproval) {
                    ddlApproval.addEventListener('change', toggleRemarksRequired);
                }

                var ddlAppStatus = document.getElementById('<%=ddlApplicationStatus.ClientID%>');
                if (ddlAppStatus) {
                    ddlAppStatus.addEventListener('change', toggleApplicationRemarksRequired);
                }

                // Initialize character counters
                updateCharCount('<%=txtProfessionalBio.ClientID%>', 'bioCharCount');
                updateCharCount('<%=txtCurrentWorkProjects.ClientID%>', 'workCharCount');
                updateCharCount('<%=txtPreviousSpeakingEngagements.ClientID%>', 'engagementsCharCount');
            });

            function openApprovalModalDirect() {
                var modal = document.getElementById('approvalModal');
                if (modal) {
                    modal.classList.add('show');
                    toggleRemarksRequired();
                } else {
                    console.error('Approval modal not found');
                }
            }

            function testModal() {
                alert('Testing modal');
                var modal = document.getElementById('approvalModal');
                if (modal) {
                    modal.classList.add('show');
                    alert('Modal should be visible now');
                } else {
                    alert('Modal element not found!');
                }
            }

            function handleApprovalClick(speakerId) {
                document.getElementById('<%=hdnApproveSpeakerID.ClientID%>').value = speakerId;
                document.getElementById('<%=btnTriggerApproval.ClientID%>').click();
            }

            // Topic Selection Handler
            $(document).on('change', '.agenda-checkbox', function () {
                var checkedCount = $('.agenda-checkbox:checked').length;
                $('#topicCount').text(checkedCount);

                if (checkedCount >= 3) {
                    $('.agenda-checkbox:not(:checked)').prop('disabled', true);
                } else {
                    $('.agenda-checkbox').prop('disabled', false);
                }

                // Update hidden field with selected agenda IDs
                var selectedIds = [];
                $('.agenda-checkbox:checked').each(function () {
                    selectedIds.push($(this).val());
                });
                $('#<%= hdnSelectedAgendas.ClientID %>').val(selectedIds.join(','));
            });

            // Reset topic selection when modal opens
            function resetTopicSelection() {
                $('.agenda-checkbox').prop('checked', false).prop('disabled', false);
                $('#topicCount').text('0');
                $('#<%= hdnSelectedAgendas.ClientID %>').val('');
            }

            // Call this in your showAddModal function
            function showAddModal() {
                $('#modalTitle').text('Add New Speaker');
                $('#<%= hdnSpeakerID.ClientID %>').val('0');
                $('#<%= txtName.ClientID %>').val('');
                $('#<%= txtEmail.ClientID %>').val('');
                $('#<%= txtMobile.ClientID %>').val('');
                $('#<%= txtProfessionalBio.ClientID %>').val('');
                $('#<%= ddlIsAvailable.ClientID %>').val('');
                $('#<%= chkMarketingConsent.ClientID %>').prop('checked', false);
                resetTopicSelection();
                $('#speakerModal').modal('show');
            }

            function handleEditClick(speakerId) {
                // Set the speaker ID in hidden field
                document.getElementById('<%=hdnApproveSpeakerID.ClientID%>').value = speakerId;

                // Trigger server-side button to load speaker data
                document.getElementById('<%=btnTriggerEdit.ClientID%>').click();
            }



        </script>
    </form>
</body>
</html>
