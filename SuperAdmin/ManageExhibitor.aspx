<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageExhibitor.aspx.cs" Inherits="Expo_Panel.Admin.ManageExhibitor" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Exhibitors - Expo Panel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.7.0.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>

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
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1800px;
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
                color: #8b5cf6;
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
                border-color: #8b5cf6;
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
            background: #8b5cf6;
            color: white;
        }

            .btn-primary:hover {
                background: #7c3aed;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(139, 92, 246, 0.4);
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

        .grid-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
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

                table th:first-child {
                    width: 60px;
                    text-align: center;
                }

            table td {
                padding: 15px 8px;
                border-bottom: 1px solid #e2e8f0;
                color: #334155;
            }

                table td:first-child {
                    text-align: center;
                    font-weight: 600;
                    color: #8b5cf6;
                }

            table tbody tr:hover {
                background: #f8fafc;
            }

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

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

            .action-buttons .btn {
                padding: 6px 10px;
                font-size: 12px;
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
            overflow: auto; /* Allow scrolling if content is tall */
        }

            .modal.show {
                display: flex !important;
                justify-content: center;
                align-items: flex-start; /* Changed from center to flex-start */
                padding: 20px 0; /* Add vertical padding */
                overflow-y: auto; /* Enable vertical scrolling */
            }

        .modal-content {
            background: white;
            border-radius: 15px;
            width: 90%;
            max-width: 1200px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: modalSlideIn 0.3s ease-out;
            max-height: 90vh;
            overflow-y: auto;
            margin: auto; /* Center horizontally and vertically */
            position: relative; /* Ensure proper positioning */
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
            padding-bottom: 15px;
            border-bottom: 2px solid #e2e8f0;
        }

            .modal-header h2 {
                color: #8b5cf6;
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

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-row-3 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

            .form-group.full-width {
                grid-column: span 2;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #475569;
                font-weight: 500;
                font-size: 14px;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 10px 15px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                font-family: 'Poppins', sans-serif;
            }

                .form-group input:focus,
                .form-group select:focus,
                .form-group textarea:focus {
                    outline: none;
                    border-color: #8b5cf6;
                }

            .form-group textarea {
                resize: vertical;
                min-height: 80px;
            }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 2px solid #e2e8f0;
        }

        .btn-cancel {
            background: #e2e8f0;
            color: #475569;
        }

            .btn-cancel:hover {
                background: #cbd5e1;
            }

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

        .toggle-button-hidden {
            display: none;
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
                background: #8b5cf6;
                color: white;
                border-color: #8b5cf6;
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

        .badge-admin {
            background: #dbeafe;
            color: #1e40af;
        }

        .badge-online {
            background: #fef3c7;
            color: #92400e;
        }

        .truncate-cell {
            max-width: 150px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: help;
        }

        .section-divider {
            margin: 30px 0 20px 0;
            padding: 10px 0;
            border-bottom: 2px solid #e2e8f0;
            color: #8b5cf6;
            font-size: 16px;
            font-weight: 600;
        }

        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
        }

            .checkbox-item input[type="checkbox"] {
                width: 18px;
                height: 18px;
                cursor: pointer;
            }

            .checkbox-item label {
                margin: 0;
                cursor: pointer;
                font-weight: 400;
            }

        .required {
            color: #ef4444;
        }

        .info-row {
            display: grid;
            grid-template-columns: 200px 1fr;
            padding: 10px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .info-label {
            font-weight: 600;
            color: #475569;
        }

        .info-value {
            color: #1e293b;
        }

        .profile-section {
            margin-bottom: 30px;
        }

        .profile-section-title {
            color: #8b5cf6;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #ede9fe;
        }

        .booth-option {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 12px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }

            .booth-option:hover {
                border-color: #c4b5fd;
                background: #faf5ff;
            }

            .booth-option input[type="radio"] {
                margin-top: 3px;
                width: 18px;
                height: 18px;
                cursor: pointer;
            }

        .password-field {
            position: relative;
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6b7280;
        }

            .password-toggle:hover {
                color: #8b5cf6;
            }

        #remarksRequired {
            display: none;
        }

        @media (max-width: 768px) {
            .form-row, .form-row-3 {
                grid-template-columns: 1fr;
            }

            .form-group.full-width {
                grid-column: span 1;
            }
        }

        .file-status {
            display: block;
            margin-top: 8px;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 13px;
        }

            .file-status.exists {
                background: #d1fae5;
                color: #065f46;
                border: 1px solid #a7f3d0;
            }

        .additional-req-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
        }

            .additional-req-group input[type="checkbox"] {
                width: 18px;
                height: 18px;
            }

            .additional-req-group input[type="number"],
            .additional-req-group input[type="text"] {
                flex: 1;
                padding: 8px 12px;
                border: 2px solid #e2e8f0;
                border-radius: 6px;
            }

        .checkbox-group {
            display: grid;
            gap: 12px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

        <div class="container">
            <div class="header">
                <h1><i class="fas fa-users"></i>Manage Exhibitors</h1>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <span>Welcome,
                        <asp:Label ID="lblUsername" runat="server" Text=""></asp:Label></span>
                    <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="~/SuperAdmin/Dashboard.aspx" CssClass="btn btn-info">
                        <i class="fas fa-arrow-left"></i> Back
                    </asp:HyperLink>
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-danger" OnClick="btnLogout_Click" />
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
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by name, email, company..."></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                    </div>
                    <div style="display: flex; gap: 10px;">
                        <a href="/RegisterExhibitor.aspx" class="btn btn-info" target="_blank">
                            <i class="fas fa-link"></i>Get Registration Link
                        </a>
                        <button type="button" class="btn btn-success" onclick="openExhibitorModal('add')">
                            <i class="fas fa-plus"></i>Add Exhibitor
                        </button>
                    </div>
                </div>

                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="grid-container">
                            <asp:GridView ID="gvExhibitors" runat="server" AutoGenerateColumns="False"
                                OnRowCommand="gvExhibitors_RowCommand" DataKeyNames="ExhibitorID"
                                CssClass="exhibitor-grid" GridLines="None" OnRowDataBound="gvExhibitors_RowDataBound">
                                <Columns>
                                    <asp:TemplateField HeaderText="Sr.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Name">
                                        <ItemTemplate>
                                            <span class="truncate-cell" title='<%# Eval("Name") %>'>
                                                <%# Eval("Name") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Email">
                                        <ItemTemplate>
                                            <span class="truncate-cell" title='<%# Eval("Email") %>'>
                                                <%# Eval("Email") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:BoundField DataField="Mobile" HeaderText="Mobile" />

                                    <asp:TemplateField HeaderText="Company">
                                        <ItemTemplate>
                                            <span class="truncate-cell" title='<%# Eval("Company") %>'>
                                                <%# Eval("Company") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

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

                                    <asp:TemplateField HeaderText="Profile">
                                        <ItemTemplate>
                                            <%# Convert.ToBoolean(Eval("HasProfile")) ? 
                                                "<span class='badge-approved'>✓ Complete</span>" : 
                                                "<span class='badge-pending'>Pending</span>" %>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <label class="toggle-switch">
                                                <input type="checkbox"
                                                    <%# (bool)Eval("IS_ACTIVE") ? "checked" : "" %>
                                                    onchange="toggleStatusSimple(this)">
                                                <span class="toggle-slider">
                                                    <i class="fas fa-check toggle-icon"></i>
                                                    <i class="fas fa-times toggle-icon"></i>
                                                </span>
                                            </label>
                                            <asp:Button runat="server"
                                                CommandName="QuickToggle"
                                                CommandArgument='<%# Eval("ExhibitorID") %>'
                                                CssClass="toggle-button-hidden"
                                                ID="btnToggle" />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:Button ID="btnEdit" runat="server"
                                                Text="Edit"
                                                CssClass="btn btn-sm btn-primary"
                                                CommandName="EditExhibitor"
                                                CommandArgument='<%# Eval("ExhibitorID") %>'
                                                OnClientClick="return true;" />

                                            <asp:Button ID="btnApprove" runat="server"
                                                Text="Approve/Reject"
                                                CssClass="btn btn-sm btn-success"
                                                CommandName="ApprovalAction"
                                                CommandArgument='<%# Eval("ExhibitorID") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="no-records">
                                        <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 15px; display: block;"></i>
                                        No exhibitors found. Click "Add Exhibitor" to create one.
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>

        <!-- Add/Edit Exhibitor Modal -->
        <div id="exhibitorModal" class="modal">
            <div class="modal-content" style="max-width: 1400px;">
                <div class="modal-header">
                    <h2 id="exhibitorModalTitle">Add Exhibitor</h2>
                    <button type="button" class="close-btn" onclick="closeExhibitorModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnExhibitorID" runat="server" Value="0" />
                <asp:HiddenField ID="hdnExhibitorModalMode" runat="server" Value="add" />

                <!-- ========== PRE-APPROVAL SECTION ========== -->
                <div class="section-divider">
                    <i class="fas fa-user"></i>Basic Information
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=txtName.ClientID%>">Full Name <span class="required">*</span></label>
                        <asp:TextBox ID="txtName" runat="server" placeholder="Enter full name"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                            ErrorMessage="Name is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ExhibitorValidation"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="<%=txtDesignation.ClientID%>">Designation <span class="required">*</span></label>
                        <asp:TextBox ID="txtDesignation" runat="server" placeholder="Enter designation"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvDesignation" runat="server" ControlToValidate="txtDesignation"
                            ErrorMessage="Designation is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ExhibitorValidation"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=txtEmail.ClientID%>">Email <span class="required">*</span></label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter email"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ExhibitorValidation"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="<%=txtMobile.ClientID%>">Mobile</label>
                        <asp:TextBox ID="txtMobile" runat="server" placeholder="Enter mobile number"></asp:TextBox>
                    </div>
                </div>

                <div class="section-divider">
                    <i class="fas fa-building"></i>Company Information
                </div>

                <div class="form-group">
                    <label for="<%=txtCompany.ClientID%>">Company Name <span class="required">*</span></label>
                    <asp:TextBox ID="txtCompany" runat="server" placeholder="Enter company name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCompany" runat="server" ControlToValidate="txtCompany"
                        ErrorMessage="Company is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ExhibitorValidation"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtHeadOffice.ClientID%>">Head Office Address</label>
                    <asp:TextBox ID="txtHeadOffice" runat="server" TextMode="MultiLine" placeholder="Enter head office address"></asp:TextBox>
                </div>

                <div class="form-row-3">
                    <div class="form-group">
                        <label for="<%=txtCity.ClientID%>">City</label>
                        <asp:TextBox ID="txtCity" runat="server" placeholder="Enter city"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="<%=txtState.ClientID%>">State</label>
                        <asp:TextBox ID="txtState" runat="server" placeholder="Enter state"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="<%=txtCountry.ClientID%>">Country</label>
                        <asp:TextBox ID="txtCountry" runat="server" placeholder="Enter country"></asp:TextBox>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=txtGSTNumber.ClientID%>">GST Number</label>
                        <asp:TextBox ID="txtGSTNumber" runat="server" placeholder="Enter GST number"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="<%=txtBillingAddress.ClientID%>">Billing Address</label>
                        <asp:TextBox ID="txtBillingAddress" runat="server" placeholder="Enter billing address"></asp:TextBox>
                    </div>
                </div>

                <div class="section-divider">
                    <i class="fas fa-warehouse"></i>Booth Requirements
                </div>

                <div class="form-group">
                    <label>Booth Type</label>
                    <div class="booth-option" onclick="document.getElementById('<%=rbShellScheme.ClientID%>').click();">
                        <asp:RadioButton ID="rbShellScheme" runat="server" GroupName="BoothType" />
                        <div>
                            <div style="font-weight: 500;">Shell Scheme</div>
                            <div style="font-size: 12px; color: #6b7280;">With basic furniture, fascia, etc.</div>
                        </div>
                    </div>
                    <div class="booth-option" onclick="document.getElementById('<%=rbRawSpace.ClientID%>').click();">
                        <asp:RadioButton ID="rbRawSpace" runat="server" GroupName="BoothType" />
                        <div>
                            <div style="font-weight: 500;">Raw Space</div>
                            <div style="font-size: 12px; color: #6b7280;">For custom-built booth</div>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="<%=txtAreaInSqm.ClientID%>">Area in Sqm</label>
                    <asp:TextBox ID="txtAreaInSqm" runat="server" TextMode="Number" placeholder="Enter area in square meters"></asp:TextBox>
                </div>

                <div class="section-divider">
                    <i class="fas fa-star"></i>Additional Interests
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkConference" runat="server" />
                            <label for="<%=chkConference.ClientID%>">Conference Speaking Slot</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkSponsorship" runat="server" />
                            <label for="<%=chkSponsorship.ClientID%>">Sponsor Opportunities</label>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkAdvertising" runat="server" />
                            <label for="<%=chkAdvertising.ClientID%>">Advertising in Show Directory</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkCustomPackage" runat="server" />
                            <label for="<%=chkCustomPackage.ClientID%>">Custom Packages</label>
                        </div>
                    </div>
                </div>

                <!-- ========== POST-APPROVAL SECTION ========== -->
                <div class="section-divider" style="background: #fef3c7; padding: 10px; border-radius: 8px; margin-top: 30px;">
                    <i class="fas fa-star"></i>Post-Approval Profile Details
            <div style="font-size: 12px; font-weight: 400; color: #92400e; margin-top: 5px;">
                These fields are for approved exhibitors. You can fill them now or after approval.
            </div>
                </div>

                <!-- Booth Assignment -->
                <div class="section-divider">
                    <i class="fas fa-map-marker-alt"></i>Booth Assignment
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=txtBoothNo.ClientID%>">Booth No <span class="required">*</span></label>
                        <asp:TextBox ID="txtBoothNo" runat="server" placeholder="Enter booth number"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="<%=txtHallNo.ClientID%>">Hall No <span class="required">*</span></label>
                        <asp:TextBox ID="txtHallNo" runat="server" placeholder="Enter hall number"></asp:TextBox>
                    </div>
                </div>

                <!-- Company Profile -->
                <div class="section-divider">
                    <i class="fas fa-info-circle"></i>Company Profile
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=txtYearOfEstablishment.ClientID%>">Year of Establishment <span class="required">*</span></label>
                        <asp:TextBox ID="txtYearOfEstablishment" runat="server" TextMode="Number" placeholder="e.g., 2000"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="<%=txtWebsite.ClientID%>">Website <span class="required">*</span></label>
                        <asp:TextBox ID="txtWebsite" runat="server" placeholder="https://www.example.com"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label>Social Media Handles</label>
                    <div class="form-row">
                        <div class="form-group">
                            <asp:TextBox ID="txtLinkedIn" runat="server" placeholder="LinkedIn URL"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtTwitter" runat="server" placeholder="Twitter URL"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <asp:TextBox ID="txtFacebook" runat="server" placeholder="Facebook URL"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtYouTube" runat="server" placeholder="YouTube URL"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <!-- Customer Support -->
                <div class="section-divider">
                    <i class="fas fa-headset"></i>Customer Support Contact
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=txtSupportName.ClientID%>">Contact Person Name <span class="required">*</span></label>
                        <asp:TextBox ID="txtSupportName" runat="server" placeholder="Enter contact person name"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="<%=txtSupportContact.ClientID%>">Contact Number <span class="required">*</span></label>
                        <asp:TextBox ID="txtSupportContact" runat="server" placeholder="Enter contact number"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label for="<%=txtSupportEmail.ClientID%>">Email <span class="required">*</span></label>
                    <asp:TextBox ID="txtSupportEmail" runat="server" TextMode="Email" placeholder="Enter support email"></asp:TextBox>
                </div>

                <!-- Nature of Business -->
                <div class="section-divider">
                    <i class="fas fa-briefcase"></i>Nature of Business
                </div>

                <div class="form-group">
                    <label>Select all that apply <span class="required">*</span></label>
                    <div class="checkbox-group" style="grid-template-columns: 1fr 1fr;">
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkManufacturer" runat="server" />
                            <label for="<%=chkManufacturer.ClientID%>">Manufacturer</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkDistributor" runat="server" />
                            <label for="<%=chkDistributor.ClientID%>">Distributor / Dealer</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkImporter" runat="server" />
                            <label for="<%=chkImporter.ClientID%>">Importer / Exporter</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkServiceProvider" runat="server" />
                            <label for="<%=chkServiceProvider.ClientID%>">Service Provider</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkTechnologyProvider" runat="server" />
                            <label for="<%=chkTechnologyProvider.ClientID%>">Technology Provider</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkRnDServices" runat="server" />
                            <label for="<%=chkRnDServices.ClientID%>">R&D / Testing Services</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkConsultancy" runat="server" />
                            <label for="<%=chkConsultancy.ClientID%>">Consultancy</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkIndustryAssociation" runat="server" />
                            <label for="<%=chkIndustryAssociation.ClientID%>">Industry Association</label>
                        </div>
                    </div>
                    <div class="checkbox-item" style="margin-top: 12px;">
                        <asp:CheckBox ID="chkNatureOther" runat="server" />
                        <label for="<%=chkNatureOther.ClientID%>">Other:</label>
                        <asp:TextBox ID="txtNatureOther" runat="server" placeholder="Please specify"></asp:TextBox>
                    </div>
                </div>

                <!-- Company Category -->
                <div class="section-divider">
                    <i class="fas fa-tags"></i>Company Category / Primary Products
                </div>

                <div class="form-group">
                    <label>Select all that apply <span class="required">*</span></label>
                    <div class="checkbox-group" style="grid-template-columns: 1fr 1fr;">
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkAutomotiveLubricants" runat="server" />
                            <label for="<%=chkAutomotiveLubricants.ClientID%>">Automotive Lubricants</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkIndustrialLubricants" runat="server" />
                            <label for="<%=chkIndustrialLubricants.ClientID%>">Industrial Lubricants</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkBaseOils" runat="server" />
                            <label for="<%=chkBaseOils.ClientID%>">Base Oils</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkAdditives" runat="server" />
                            <label for="<%=chkAdditives.ClientID%>">Additives</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkGreases" runat="server" />
                            <label for="<%=chkGreases.ClientID%>">Greases</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkSpecialtyFluids" runat="server" />
                            <label for="<%=chkSpecialtyFluids.ClientID%>">Specialty Fluids</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkBioBasedLubricants" runat="server" />
                            <label for="<%=chkBioBasedLubricants.ClientID%>">Bio-based / Sustainable</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkReRefinedOils" runat="server" />
                            <label for="<%=chkReRefinedOils.ClientID%>">Re-refined Oils</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkPackaging" runat="server" />
                            <label for="<%=chkPackaging.ClientID%>">Packaging Equipment</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkLabEquipment" runat="server" />
                            <label for="<%=chkLabEquipment.ClientID%>">Lab / Testing Equipment</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkLubricationSystems" runat="server" />
                            <label for="<%=chkLubricationSystems.ClientID%>">Lubrication Systems</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkSoftwareAI" runat="server" />
                            <label for="<%=chkSoftwareAI.ClientID%>">Software / AI Solutions</label>
                        </div>
                    </div>
                    <div class="checkbox-item" style="margin-top: 12px;">
                        <asp:CheckBox ID="chkProductOther" runat="server" />
                        <label for="<%=chkProductOther.ClientID%>">Others:</label>
                        <asp:TextBox ID="txtProductOther" runat="server" placeholder="Please specify"></asp:TextBox>
                    </div>
                </div>

                <!-- Markets Catered To -->
                <div class="section-divider">
                    <i class="fas fa-globe"></i>Markets You Cater To
                </div>

                <div class="form-group">
                    <label>Select all that apply <span class="required">*</span></label>
                    <div class="checkbox-group" style="grid-template-columns: 1fr 1fr;">
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkAutomotive" runat="server" />
                            <label for="<%=chkAutomotive.ClientID%>">Automotive</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkHeavyCommercial" runat="server" />
                            <label for="<%=chkHeavyCommercial.ClientID%>">Heavy Commercial Vehicles</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkRailways" runat="server" />
                            <label for="<%=chkRailways.ClientID%>">Railways</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkMarine" runat="server" />
                            <label for="<%=chkMarine.ClientID%>">Marine</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkAerospace" runat="server" />
                            <label for="<%=chkAerospace.ClientID%>">Aerospace</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkManufacturing" runat="server" />
                            <label for="<%=chkManufacturing.ClientID%>">Manufacturing & Processing</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkPowerEnergy" runat="server" />
                            <label for="<%=chkPowerEnergy.ClientID%>">Power & Energy</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkConstruction" runat="server" />
                            <label for="<%=chkConstruction.ClientID%>">Construction & Mining</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkAgriculture" runat="server" />
                            <label for="<%=chkAgriculture.ClientID%>">Agriculture</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkFMCG" runat="server" />
                            <label for="<%=chkFMCG.ClientID%>">FMCG / Food Processing</label>
                        </div>
                    </div>
                    <div class="checkbox-item" style="margin-top: 12px;">
                        <asp:CheckBox ID="chkMarketOther" runat="server" />
                        <label for="<%=chkMarketOther.ClientID%>">Other:</label>
                        <asp:TextBox ID="txtMarketOther" runat="server" placeholder="Please specify"></asp:TextBox>
                    </div>
                </div>

                <!-- Geographic Reach -->
                <div class="section-divider">
                    <i class="fas fa-map"></i>Geographic Reach
                </div>

                <div class="form-group">
                    <label>Select all that apply <span class="required">*</span></label>
                    <div class="checkbox-group" style="grid-template-columns: 1fr 1fr 1fr;">
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkIndiaOnly" runat="server" />
                            <label for="<%=chkIndiaOnly.ClientID%>">India Only</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkSouthAsia" runat="server" />
                            <label for="<%=chkSouthAsia.ClientID%>">South Asia</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkAsiaPacific" runat="server" />
                            <label for="<%=chkAsiaPacific.ClientID%>">Asia-Pacific</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkMiddleEast" runat="server" />
                            <label for="<%=chkMiddleEast.ClientID%>">Middle East</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkAfrica" runat="server" />
                            <label for="<%=chkAfrica.ClientID%>">Africa</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkEurope" runat="server" />
                            <label for="<%=chkEurope.ClientID%>">Europe</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkGlobal" runat="server" />
                            <label for="<%=chkGlobal.ClientID%>">Global</label>
                        </div>
                    </div>
                </div>

                <!-- Additional Requirements -->
                <div class="section-divider">
                    <i class="fas fa-cogs"></i>Additional Requirements
                </div>

                <div class="form-group">
                    <div class="additional-req-group">
                        <asp:CheckBox ID="chkPowerSupply" runat="server" />
                        <label for="<%=chkPowerSupply.ClientID%>">Power Supply</label>
                        <asp:TextBox ID="txtPowerSupplyKwh" runat="server" TextMode="Number" placeholder="Kwh" step="0.01"></asp:TextBox>
                    </div>

                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkInternet" runat="server" />
                        <label for="<%=chkInternet.ClientID%>">Internet</label>
                    </div>

                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkFurniture" runat="server" />
                        <label for="<%=chkFurniture.ClientID%>">Furniture Rental</label>
                    </div>

                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkAVEquipment" runat="server" />
                        <label for="<%=chkAVEquipment.ClientID%>">AV Equipment</label>
                    </div>

                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkInterpreter" runat="server" />
                        <label for="<%=chkInterpreter.ClientID%>">Interpreter Support</label>
                    </div>

                    <div class="checkbox-item" style="margin-top: 12px;">
                        <asp:CheckBox ID="chkReqOther" runat="server" />
                        <label for="<%=chkReqOther.ClientID%>">Others:</label>
                        <asp:TextBox ID="txtReqOther" runat="server" placeholder="Please specify"></asp:TextBox>
                    </div>
                </div>

                <!-- Participation Objectives -->
                <div class="section-divider">
                    <i class="fas fa-bullseye"></i>Participation Objectives
                </div>

                <div class="form-group">
                    <label>You may select multiple <span class="required">*</span></label>
                    <div class="checkbox-group" style="grid-template-columns: 1fr 1fr;">
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkGenerateLeads" runat="server" />
                            <label for="<%=chkGenerateLeads.ClientID%>">Generate Business Leads</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkLaunchProducts" runat="server" />
                            <label for="<%=chkLaunchProducts.ClientID%>">Launch New Products</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkNetworking" runat="server" />
                            <label for="<%=chkNetworking.ClientID%>">Network with Industry</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkFindPartners" runat="server" />
                            <label for="<%=chkFindPartners.ClientID%>">Find Distribution Partners</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkMarketResearch" runat="server" />
                            <label for="<%=chkMarketResearch.ClientID%>">Market Research</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkBrandVisibility" runat="server" />
                            <label for="<%=chkBrandVisibility.ClientID%>">Brand Visibility</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkAttendConference" runat="server" />
                            <label for="<%=chkAttendConference.ClientID%>">Attend Conference Sessions</label>
                        </div>
                        <div class="checkbox-item">
                            <asp:CheckBox ID="chkRecruitTalent" runat="server" />
                            <label for="<%=chkRecruitTalent.ClientID%>">Recruit Talent</label>
                        </div>
                    </div>
                    <div class="checkbox-item" style="margin-top: 12px;">
                        <asp:CheckBox ID="chkObjectiveOther" runat="server" />
                        <label for="<%=chkObjectiveOther.ClientID%>">Other:</label>
                        <asp:TextBox ID="txtObjectiveOther" runat="server" placeholder="Please specify"></asp:TextBox>
                    </div>
                </div>

                <!-- Additional Notes -->
                <div class="section-divider">
                    <i class="fas fa-comment-alt"></i>Additional Notes / Comments
                </div>

                <div class="form-group">
                    <label for="<%=txtAdditionalNotes.ClientID%>">Any special requirements or comments</label>
                    <asp:TextBox ID="txtAdditionalNotes" runat="server" TextMode="MultiLine"
                        placeholder="Enter any additional information, special requirements, or comments here..."
                        Rows="4"></asp:TextBox>
                </div>

                <!-- File Uploads -->
                <div class="section-divider">
                    <i class="fas fa-upload"></i>Upload Documents
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=fuProductPicture.ClientID%>">Product Picture</label>
                        <div class="file-upload">
                            <asp:FileUpload ID="fuProductPicture" runat="server" />
                        </div>
                        <small style="color: #6b7280; font-size: 12px;">Accepted: All image formats (optional on edit)</small>
                        <asp:Label ID="lblProductPictureStatus" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                    </div>

                    <div class="form-group">
                        <label for="<%=fuBrochure.ClientID%>">Company Brochure</label>
                        <div class="file-upload">
                            <asp:FileUpload ID="fuBrochure" runat="server" />
                        </div>
                        <small style="color: #6b7280; font-size: 12px;">Accepted: All document formats (optional on edit)</small>
                        <asp:Label ID="lblBrochureStatus" runat="server" CssClass="file-status" Visible="false"></asp:Label>
                    </div>
                </div>

                <!-- System Settings -->
                <div class="section-divider">
                    <i class="fas fa-cog"></i>System Settings
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=ddlStatus.ClientID%>">Status</label>
                        <asp:DropDownList ID="ddlStatus" runat="server">
                            <asp:ListItem Text="Active" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label for="<%=ddlRegistrationType.ClientID%>">Registration Type</label>
                        <asp:DropDownList ID="ddlRegistrationType" runat="server">
                            <asp:ListItem Text="Admin" Value="Admin" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Online" Value="Online"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeExhibitorModal()">Cancel</button>
                    <asp:Button ID="btnSaveExhibitor" runat="server" Text="Save" CssClass="btn btn-primary"
                        OnClick="btnSaveExhibitor_Click" ValidationGroup="ExhibitorValidation" />
                </div>
            </div>
        </div>

        <!-- Hidden buttons for server-side actions -->
        <asp:HiddenField ID="hdnEditExhibitorID" runat="server" Value="0" />
        <asp:Button ID="btnTriggerEdit" runat="server" OnClick="btnTriggerEdit_Click" Style="display: none;" />

        <asp:HiddenField ID="hdnApproveExhibitorID" runat="server" Value="0" />
        <asp:Button ID="btnTriggerApproval" runat="server" OnClick="btnTriggerApproval_Click" Style="display: none;" />

        <!-- test button -->
        <asp:HiddenField ID="hdnViewProfileExhibitorID" runat="server" Value="0" />
        <asp:Button ID="btnTriggerViewProfile" runat="server" OnClick="btnTriggerViewProfile_Click" Style="display: none;" />

        <script type="text/javascript">
            function handleEditClick(exhibitorId) {
                // Optional: Show loading message
                var loadingMsg = '<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> Loading exhibitor data...</div>';
                document.getElementById('<%=litMessage.ClientID%>').innerHTML = loadingMsg;

                // Set the hidden field with the exhibitor ID
                document.getElementById('<%=hdnEditExhibitorID.ClientID%>').value = exhibitorId;

                // Trigger the postback via hidden button
                document.getElementById('<%=btnTriggerEdit.ClientID%>').click();
            }

            function onGetExhibitorSuccess(result) {
                // Clear loading message
                document.getElementById('<%=litMessage.ClientID%>').innerHTML = '';

                // Parse the JSON result
                var data = JSON.parse(result);

                // Open the modal with the data
                openExhibitorModal('edit', data);
            }

            function onGetExhibitorError(error) {
                document.getElementById('<%=litMessage.ClientID%>').innerHTML =
                    '<div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> Error loading exhibitor: ' + error.get_message() + '</div>';
            }

            function handleApprovalClick(exhibitorId) {
                document.getElementById('<%=hdnApproveExhibitorID.ClientID%>').value = exhibitorId;
                document.getElementById('<%=btnTriggerApproval.ClientID%>').click();
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

            (function () {
                function $id(id) { return document.getElementById(id); }
                function safeSet(id, value) {
                    var el = $id(id);
                    if (!el) return;
                    try { if ('value' in el) el.value = value; else el.textContent = value; } catch (e) { }
                }

                window.openExhibitorModal = function (mode, data) {
                    try {
                        data = data || {};

                        // Basic info
                        safeSet('<%= txtName.ClientID %>', data.name || '');
                        safeSet('<%= txtDesignation.ClientID %>', data.designation || '');
                        safeSet('<%= txtEmail.ClientID %>', data.email || '');
                        safeSet('<%= txtMobile.ClientID %>', data.mobile || '');

                        // ... rest of your field population code ...

                        // Hidden fields
                        safeSet('<%= hdnExhibitorID.ClientID %>', data.id || 0);
                        safeSet('<%= hdnExhibitorModalMode.ClientID %>', mode || 'edit');

                        // ✅ FIX: Use Bootstrap's modal method instead of direct display manipulation
                        var modal = $('#exhibitorModal');
                        if (modal.length) {
                            modal.modal('show');
                        } else {
                            // Fallback if jQuery/Bootstrap not available
                            var modalEl = document.getElementById('exhibitorModal');
                            if (modalEl) {
                                modalEl.style.display = 'block';
                                modalEl.classList.add('show');
                            }
                        }

                        // Title update
                        var title = document.getElementById('exhibitorModalTitle');
                        if (title) title.textContent = (mode === 'edit') ? 'Edit Exhibitor' : 'Add Exhibitor';
                    } catch (err) {
                        console.error('openExhibitorModal error:', err);
                    }
                };

                window.closeExhibitorModal = function () {
                    // ✅ FIX: Use Bootstrap's modal method to properly close
                    var modal = $('#exhibitorModal');
                    if (modal.length) {
                        modal.modal('hide');
                    } else {
                        // Fallback
                        var modalEl = document.getElementById('exhibitorModal');
                        if (modalEl) {
                            modalEl.style.display = 'none';
                            modalEl.classList.remove('show');
                        }
                    }
                };

            })();

            function clearExhibitorForm() {
                document.getElementById('<%=txtName.ClientID%>').value = '';
                document.getElementById('<%=txtDesignation.ClientID%>').value = '';
                document.getElementById('<%=txtEmail.ClientID%>').value = '';
                document.getElementById('<%=txtMobile.ClientID%>').value = '';
                document.getElementById('<%=txtCompany.ClientID%>').value = '';
                document.getElementById('<%=txtHeadOffice.ClientID%>').value = '';
                document.getElementById('<%=txtCity.ClientID%>').value = '';
                document.getElementById('<%=txtState.ClientID%>').value = '';
                document.getElementById('<%=txtCountry.ClientID%>').value = '';
                document.getElementById('<%=txtGSTNumber.ClientID%>').value = '';
                document.getElementById('<%=txtBillingAddress.ClientID%>').value = '';
                document.getElementById('<%=rbShellScheme.ClientID%>').checked = false;
                document.getElementById('<%=rbRawSpace.ClientID%>').checked = false;
                document.getElementById('<%=txtAreaInSqm.ClientID%>').value = '';
                document.getElementById('<%=chkConference.ClientID%>').checked = false;
                document.getElementById('<%=chkSponsorship.ClientID%>').checked = false;
                document.getElementById('<%=chkAdvertising.ClientID%>').checked = false;
                document.getElementById('<%=chkCustomPackage.ClientID%>').checked = false;
                document.getElementById('<%=ddlStatus.ClientID%>').selectedIndex = 0;
                document.getElementById('<%=ddlRegistrationType.ClientID%>').selectedIndex = 0;
            }

            function populateExhibitorForm(data) {
                // Pre-Approval Fields
                document.getElementById('<%=txtName.ClientID%>').value = data.name || '';
                document.getElementById('<%=txtDesignation.ClientID%>').value = data.designation || '';
                document.getElementById('<%=txtEmail.ClientID%>').value = data.email || '';
                document.getElementById('<%=txtMobile.ClientID%>').value = data.mobile || '';
                document.getElementById('<%=txtCompany.ClientID%>').value = data.company || '';
                document.getElementById('<%=txtHeadOffice.ClientID%>').value = data.headOffice || '';
                document.getElementById('<%=txtCity.ClientID%>').value = data.city || '';
                document.getElementById('<%=txtState.ClientID%>').value = data.state || '';
                document.getElementById('<%=txtCountry.ClientID%>').value = data.country || '';
                document.getElementById('<%=txtGSTNumber.ClientID%>').value = data.gst || '';
                document.getElementById('<%=txtBillingAddress.ClientID%>').value = data.billing || '';

                if (data.boothType === 'Shell Scheme') {
                    document.getElementById('<%=rbShellScheme.ClientID%>').checked = true;
                } else if (data.boothType === 'Raw Space') {
                    document.getElementById('<%=rbRawSpace.ClientID%>').checked = true;
                }

                document.getElementById('<%=txtAreaInSqm.ClientID%>').value = data.area || '';
                document.getElementById('<%=chkConference.ClientID%>').checked = data.conference === true || data.conference === 'True';
                document.getElementById('<%=chkSponsorship.ClientID%>').checked = data.sponsorship === true || data.sponsorship === 'True';
                document.getElementById('<%=chkAdvertising.ClientID%>').checked = data.advertising === true || data.advertising === 'True';
                document.getElementById('<%=chkCustomPackage.ClientID%>').checked = data.customPackage === true || data.customPackage === 'True';
                document.getElementById('<%=chkSponsorship.ClientID%>').checked = data.sponsorship === 'True';
                document.getElementById('<%=chkAdvertising.ClientID%>').checked = data.advertising === 'True';
                document.getElementById('<%=chkCustomPackage.ClientID%>').checked = data.customPackage === 'True';
                document.getElementById('<%=ddlStatus.ClientID%>').value = data.isActive;
                document.getElementById('<%=ddlRegistrationType.ClientID%>').value = data.regType || 'Admin';

                // Post-Approval Fields (if they exist)
                if (data.boothNo !== undefined) {
                    document.getElementById('<%=txtBoothNo.ClientID%>').value = data.boothNo || '';
                    document.getElementById('<%=txtHallNo.ClientID%>').value = data.hallNo || '';
                    document.getElementById('<%=txtYearOfEstablishment.ClientID%>').value = data.yearOfEstablishment || '';
                    document.getElementById('<%=txtWebsite.ClientID%>').value = data.website || '';
                    document.getElementById('<%=txtLinkedIn.ClientID%>').value = data.linkedIn || '';
                    document.getElementById('<%=txtTwitter.ClientID%>').value = data.twitter || '';
                    document.getElementById('<%=txtFacebook.ClientID%>').value = data.facebook || '';
                    document.getElementById('<%=txtYouTube.ClientID%>').value = data.youtube || '';
                    document.getElementById('<%=txtSupportName.ClientID%>').value = data.supportName || '';
                    document.getElementById('<%=txtSupportContact.ClientID%>').value = data.supportContact || '';
                    document.getElementById('<%=txtSupportEmail.ClientID%>').value = data.supportEmail || '';

                    // Nature of Business
                    var nature = data.natureOfBusiness || '';
                    document.getElementById('<%=chkManufacturer.ClientID%>').checked = nature.includes('Manufacturer');
                    document.getElementById('<%=chkDistributor.ClientID%>').checked = nature.includes('Distributor');
                    document.getElementById('<%=chkImporter.ClientID%>').checked = nature.includes('Importer');
                    document.getElementById('<%=chkServiceProvider.ClientID%>').checked = nature.includes('Service Provider');
                    document.getElementById('<%=chkTechnologyProvider.ClientID%>').checked = nature.includes('Technology Provider');
                    document.getElementById('<%=chkRnDServices.ClientID%>').checked = nature.includes('R&D');
                    document.getElementById('<%=chkConsultancy.ClientID%>').checked = nature.includes('Consultancy');
                    document.getElementById('<%=chkIndustryAssociation.ClientID%>').checked = nature.includes('Industry Association');
                    if (nature.includes('Other:')) {
                        document.getElementById('<%=chkNatureOther.ClientID%>').checked = true;
                        var otherText = nature.substring(nature.indexOf('Other:') + 6).split(',')[0].trim();
                        document.getElementById('<%=txtNatureOther.ClientID%>').value = otherText;
                    }

                    // Company Category
                    var category = data.companyCategory || '';
                    document.getElementById('<%=chkAutomotiveLubricants.ClientID%>').checked = category.includes('Automotive Lubricants');
                    document.getElementById('<%=chkIndustrialLubricants.ClientID%>').checked = category.includes('Industrial Lubricants');
                    document.getElementById('<%=chkBaseOils.ClientID%>').checked = category.includes('Base Oils');
                    document.getElementById('<%=chkAdditives.ClientID%>').checked = category.includes('Additives');
                    document.getElementById('<%=chkGreases.ClientID%>').checked = category.includes('Greases');
                    document.getElementById('<%=chkSpecialtyFluids.ClientID%>').checked = category.includes('Specialty Fluids');
                    document.getElementById('<%=chkBioBasedLubricants.ClientID%>').checked = category.includes('Bio-based');
                    document.getElementById('<%=chkReRefinedOils.ClientID%>').checked = category.includes('Re-refined');
                    document.getElementById('<%=chkPackaging.ClientID%>').checked = category.includes('Packaging');
                    document.getElementById('<%=chkLabEquipment.ClientID%>').checked = category.includes('Lab');
                    document.getElementById('<%=chkLubricationSystems.ClientID%>').checked = category.includes('Lubrication Systems');
                    document.getElementById('<%=chkSoftwareAI.ClientID%>').checked = category.includes('Software');
                    if (category.includes('Others:')) {
                        document.getElementById('<%=chkProductOther.ClientID%>').checked = true;
                        var otherText = category.substring(category.indexOf('Others:') + 7).split(',')[0].trim();
                        document.getElementById('<%=txtProductOther.ClientID%>').value = otherText;
                    }

                    // Markets
                    var markets = data.marketsCatered || '';
                    document.getElementById('<%=chkAutomotive.ClientID%>').checked = markets.includes('Automotive');
                    document.getElementById('<%=chkHeavyCommercial.ClientID%>').checked = markets.includes('Heavy Commercial');
                    document.getElementById('<%=chkRailways.ClientID%>').checked = markets.includes('Railways');
                    document.getElementById('<%=chkMarine.ClientID%>').checked = markets.includes('Marine');
                    document.getElementById('<%=chkAerospace.ClientID%>').checked = markets.includes('Aerospace');
                    document.getElementById('<%=chkManufacturing.ClientID%>').checked = markets.includes('Manufacturing');
                    document.getElementById('<%=chkPowerEnergy.ClientID%>').checked = markets.includes('Power');
                    document.getElementById('<%=chkConstruction.ClientID%>').checked = markets.includes('Construction');
                    document.getElementById('<%=chkAgriculture.ClientID%>').checked = markets.includes('Agriculture');
                    document.getElementById('<%=chkFMCG.ClientID%>').checked = markets.includes('FMCG');
                    if (markets.includes('Other:')) {
                        document.getElementById('<%=chkMarketOther.ClientID%>').checked = true;
                        var otherText = markets.substring(markets.indexOf('Other:') + 6).split(',')[0].trim();
                        document.getElementById('<%=txtMarketOther.ClientID%>').value = otherText;
                    }

                    // Geographic Reach
                    var geo = data.geographicReach || '';
                    document.getElementById('<%=chkIndiaOnly.ClientID%>').checked = geo.includes('India Only');
                    document.getElementById('<%=chkSouthAsia.ClientID%>').checked = geo.includes('South Asia');
                    document.getElementById('<%=chkAsiaPacific.ClientID%>').checked = geo.includes('Asia-Pacific');
                    document.getElementById('<%=chkMiddleEast.ClientID%>').checked = geo.includes('Middle East');
                    document.getElementById('<%=chkAfrica.ClientID%>').checked = geo.includes('Africa');
                    document.getElementById('<%=chkEurope.ClientID%>').checked = geo.includes('Europe');
                    document.getElementById('<%=chkGlobal.ClientID%>').checked = geo.includes('Global');

                    // Requirements
                    document.getElementById('<%=chkPowerSupply.ClientID%>').checked = data.powerSupply === 'True';
                    document.getElementById('<%=txtPowerSupplyKwh.ClientID%>').value = data.powerKwh || '';
                    document.getElementById('<%=chkInternet.ClientID%>').checked = data.internet === 'True';
                    document.getElementById('<%=chkFurniture.ClientID%>').checked = data.furniture === 'True';
                    document.getElementById('<%=chkAVEquipment.ClientID%>').checked = data.avEquipment === 'True';
                    document.getElementById('<%=chkInterpreter.ClientID%>').checked = data.interpreter === 'True';
                    if (data.otherReq) {
                        document.getElementById('<%=chkReqOther.ClientID%>').checked = true;
                        document.getElementById('<%=txtReqOther.ClientID%>').value = data.otherReq;
                    }

                    // Objectives
                    var objectives = data.objectives || '';
                    document.getElementById('<%=chkGenerateLeads.ClientID%>').checked = objectives.includes('Generate Business Leads');
                    document.getElementById('<%=chkLaunchProducts.ClientID%>').checked = objectives.includes('Launch New Products');
                    document.getElementById('<%=chkNetworking.ClientID%>').checked = objectives.includes('Network');
                    document.getElementById('<%=chkFindPartners.ClientID%>').checked = objectives.includes('Find Distribution');
                    document.getElementById('<%=chkMarketResearch.ClientID%>').checked = objectives.includes('Market Research');
                    document.getElementById('<%=chkBrandVisibility.ClientID%>').checked = objectives.includes('Brand Visibility');
                    document.getElementById('<%=chkAttendConference.ClientID%>').checked = objectives.includes('Attend Conference');
                    document.getElementById('<%=chkRecruitTalent.ClientID%>').checked = objectives.includes('Recruit Talent');
                    if (objectives.includes('Other:')) {
                        document.getElementById('<%=chkObjectiveOther.ClientID%>').checked = true;
                        var otherText = objectives.substring(objectives.indexOf('Other:') + 6).split(',')[0].trim();
                        document.getElementById('<%=txtObjectiveOther.ClientID%>').value = otherText;
                    }

                    document.getElementById('<%=txtAdditionalNotes.ClientID%>').value = data.additionalNotes || '';

                    // Show file status if files exist
                    if (data.productPicture) {
                        var lblProduct = document.getElementById('<%=lblProductPictureStatus.ClientID%>');
                        lblProduct.innerHTML = '<i class="fas fa-check-circle"></i> File uploaded: ' + data.productPicture.split('/').pop();
                        lblProduct.className = 'file-status exists';
                        lblProduct.style.display = 'block';
                    }

                    if (data.brochure) {
                        var lblBrochure = document.getElementById('<%=lblBrochureStatus.ClientID%>');
                        lblBrochure.innerHTML = '<i class="fas fa-check-circle"></i> File uploaded: ' + data.brochure.split('/').pop();
                        lblBrochure.className = 'file-status exists';
                        lblBrochure.style.display = 'block';
                    }
                }
            }

            function openApprovalModal(id, name, email, company, regType, approvalStatus, remarks, password) {
                document.getElementById('<%=hdnApprovalExhibitorID.ClientID%>').value = id;
                document.getElementById('<%=txtApprovalName.ClientID%>').value = name;
                document.getElementById('<%=txtApprovalEmail.ClientID%>').value = email;
                document.getElementById('<%=txtApprovalCompany.ClientID%>').value = company;
                document.getElementById('<%=txtApprovalRegType.ClientID%>').value = regType;
                document.getElementById('<%=ddlApprovalStatus.ClientID%>').value = approvalStatus;
                document.getElementById('<%=txtApprovalRemarks.ClientID%>').value = remarks || '';
                document.getElementById('<%=txtPassword.ClientID%>').value = password || '';

                var modal = document.getElementById('approvalModal');
                modal.classList.add('show');

                toggleRemarksAndPasswordRequired();
            }

            function closeApprovalModal() {
                var modal = document.getElementById('approvalModal');
                modal.classList.remove('show');
            }




            function toggleRemarksAndPasswordRequired() {
                var status = document.getElementById('<%=ddlApprovalStatus.ClientID%>').value;
                var remarksReq = document.getElementById('remarksRequired');
                var passwordReq = document.getElementById('passwordRequired');

                if (status === 'Rejected') {
                    remarksReq.style.display = 'inline';
                    passwordReq.style.display = 'none';
                } else if (status === 'Approved') {
                    remarksReq.style.display = 'none';
                    passwordReq.style.display = 'inline';
                } else {
                    remarksReq.style.display = 'none';
                    passwordReq.style.display = 'none';
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

            function validatePassword(sender, args) {
                var status = document.getElementById('<%=ddlApprovalStatus.ClientID%>').value;
                var password = document.getElementById('<%=txtPassword.ClientID%>').value.trim();

                if (status === 'Approved' && password === '') {
                    args.IsValid = false;
                } else {
                    args.IsValid = true;
                }
            }

            function togglePassword(fieldId) {
                var field = document.getElementById(fieldId);
                var icon = event.target;

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

            window.onclick = function (event) {
                var exhibitorModal = document.getElementById('exhibitorModal');
                var approvalModal = document.getElementById('approvalModal');

                if (event.target == exhibitorModal) {
                    closeExhibitorModal();
                }
                if (event.target == approvalModal) {
                    closeApprovalModal();
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                var ddlApproval = document.getElementById('<%=ddlApprovalStatus.ClientID%>');
                if (ddlApproval) {
                    ddlApproval.addEventListener('change', toggleRemarksAndPasswordRequired);
                }
            });

            function testPageMethod() {
                console.log('Test button clicked');
                alert('Testing PageMethod...');

                // Test if PageMethods exists
                if (typeof PageMethods === 'undefined') {
                    alert('ERROR: PageMethods is undefined! EnablePageMethods may not be set to true.');
                    console.error('PageMethods is undefined');
                    return;
                }

                console.log('PageMethods exists:', PageMethods);

                // Test if GetExhibitorData exists
                if (typeof PageMethods.GetExhibitorData === 'undefined') {
                    alert('ERROR: PageMethods.GetExhibitorData is undefined! The WebMethod may not be properly configured.');
                    console.error('PageMethods.GetExhibitorData is undefined');
                    return;
                }

                console.log('PageMethods.GetExhibitorData exists');

                // Try to call with exhibitor ID 1 (change this to a real ID from your database)
                var testId = 1; // CHANGE THIS TO A REAL EXHIBITOR ID

                PageMethods.GetExhibitorData(testId,
                    function (result) {
                        console.log('Success! Result:', result);
                        alert('SUCCESS! Check console for data. Result length: ' + result.length);

                        try {
                            var data = JSON.parse(result);
                            console.log('Parsed data:', data);
                            alert('Parsed successfully! Exhibitor: ' + data.name);
                        } catch (e) {
                            console.error('JSON parse error:', e);
                            alert('ERROR parsing JSON: ' + e.message);
                        }
                    },
                    function (error) {
                        console.error('Error:', error);
                        alert('ERROR: ' + error.get_message());
                    }
                );
            }
            function $id(id) { return document.getElementById(id); }

            // Ensure modal backdrop is properly cleaned up
            $('#exhibitorModal').on('hidden.bs.modal', function () {
                $('.modal-backdrop').remove();
                $('body').removeClass('modal-open');
            });

        </script>


        <!-- Approval Modal -->
        <div id="approvalModal" class="modal">
            <div class="modal-content" style="max-width: 600px;">
                <div class="modal-header">
                    <h2>Approve/Reject Exhibitor</h2>
                    <button type="button" class="close-btn" onclick="closeApprovalModal()">&times;</button>
                </div>

                <div class="modal-body" style="padding: 20px;">
                    <asp:HiddenField ID="hdnApprovalExhibitorID" runat="server" Value="0" />

                    <div class="form-row">
                        <div class="form-group">
                            <label for="txtApprovalName">Name</label>
                            <asp:TextBox ID="txtApprovalName" runat="server" Enabled="false"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtApprovalEmail">Email</label>
                            <asp:TextBox ID="txtApprovalEmail" runat="server" Enabled="false"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="txtApprovalCompany">Company</label>
                            <asp:TextBox ID="txtApprovalCompany" runat="server" Enabled="false"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtApprovalRegType">Registration Type</label>
                            <asp:TextBox ID="txtApprovalRegType" runat="server" Enabled="false"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="ddlApprovalStatus">Status</label>
                        <asp:DropDownList ID="ddlApprovalStatus" runat="server"
                            onchange="toggleRemarksAndPasswordRequired()">
                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                            <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                            <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group" id="remarksRequired" style="display: none;">
                        <label for="txtApprovalRemarks">Remarks (Required for Rejection)</label>
                        <asp:TextBox ID="txtApprovalRemarks" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    </div>

                    <div class="form-group" id="passwordRequired" style="display: none;">
                        <label for="txtPassword">Password (Required for Approval)</label>
                        <div class="password-field">
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
                            <span class="password-toggle" onclick="togglePassword('txtPassword')">
                                <i class="fas fa-eye"></i>
                            </span>
                        </div>
                    </div>
                </div>
                <!-- CORRECT -->
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />


                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeApprovalModal()">Cancel</button>
                    <asp:Button ID="btnSaveApproval" runat="server" Text="Save"
                        CssClass="btn btn-primary" OnClick="btnSaveApproval_Click" />
                </div>
            </div>
        </div>

    </form>
</body>
</html>
