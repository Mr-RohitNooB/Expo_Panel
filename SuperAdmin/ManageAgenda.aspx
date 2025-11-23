﻿﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageAgenda.aspx.cs" Inherits="Expo_Panel.Admin.AgendaDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Agenda - Expo Panel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
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
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1600px;
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
                color: #3b82f6;
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
                border-color: #3b82f6;
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
            background: #3b82f6;
            color: white;
        }

            .btn-primary:hover {
                background: #2563eb;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
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
                    color: #3b82f6;
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
            max-width: 800px;
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
        }

            .modal-header h2 {
                color: #3b82f6;
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

        .form-group {
            margin-bottom: 20px;
        }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #475569;
                font-weight: 500;
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
                    border-color: #3b82f6;
                }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 25px;
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
            position: relative;
        }

            .btn-filter:hover {
                background: #f8fafc;
                border-color: #cbd5e1;
            }

            .btn-filter.active {
                background: #3b82f6;
                color: white;
                border-color: #3b82f6;
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

        .truncate-cell {
            max-width: 150px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: help;
        }


        .wrap-cell {
            max-width: 250px; /* You can adjust this width */
            white-space: normal;
            word-wrap: break-word; /* For older browsers */
            overflow-wrap: break-word; /* For newer browsers */
        }

        #remarksRequired {
            display: none;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="container">
            <div class="header">
                <h1><i class="fas fa-calendar-alt"></i>Manage Agenda</h1>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <span>Welcome,
                        <asp:Label ID="lblUsername" runat="server" Text=""></asp:Label>
                        | Session Status:
                        <asp:Label ID="lblSessionStatus" runat="server" Text=""></asp:Label>
                    </span>
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
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by day, track, title..."></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                    </div>
                    <div style="display: flex; gap: 10px;">
                        <a href="/RegisterAgenda.aspx" class="btn btn-info" target="_blank">
                            <i class="fas fa-link"></i>Get Registration Link
                        </a>

                        <button type="button" class="btn btn-success" onclick="openModal('add')">
                            <i class="fas fa-plus"></i>Add Agenda
                        </button>
                    </div>
                </div>

                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="grid-container">
                            <asp:GridView ID="gvAgenda" runat="server" AutoGenerateColumns="False"
                                OnRowCommand="gvAgenda_RowCommand" DataKeyNames="AgendaID"
                                CssClass="agenda-grid" GridLines="None" OnRowDataBound="gvAgenda_RowDataBound">
                                <Columns>
                                    <asp:BoundField DataField="AgendaID" HeaderText="ID" Visible="false" />

                                    <asp:TemplateField HeaderText="Sr.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Day">
                                        <ItemTemplate>
                                            <span class="truncate-cell" title='<%# Eval("Day") %>'>
                                                <%# Eval("Day") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Track">
                                        <ItemTemplate>
                                            <span class="truncate-cell" title='<%# Eval("Track") %>'>
                                                <%# Eval("Track") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:BoundField DataField="Time" HeaderText="Time" />

                                    <asp:TemplateField HeaderText="Title">
                                        <ItemTemplate>
                                            <span class="wrap-cell" title='<%# Eval("Title") %>'>
                                                <%# Eval("Title") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Brief">
                                        <ItemTemplate>
                                            <span class="wrap-cell" title='<%# Eval("Brief") %>'>
                                                <%# Eval("Brief") %>
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
                                                CommandArgument='<%# Eval("AgendaID") %>'
                                                CssClass="toggle-button-hidden"
                                                ID="btnToggle" />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <div class="action-buttons">
                                                <asp:Button runat="server" Text="Edit" CommandName="EditAgenda"
                                                    CommandArgument='<%# Eval("AgendaID") %>'
                                                    CssClass="btn btn-edit" />
                                                <asp:Button runat="server" Text="Approve/Reject" CommandName="ApprovalAction"
                                                    CommandArgument='<%# Eval("AgendaID") %>'
                                                    CssClass="btn btn-warning" />
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="no-records">
                                        <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 15px; display: block;"></i>
                                        No agenda items found. Click "Add Agenda" to create one.
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>

        <!-- Add/Edit Modal -->
        <div id="agendaModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitle">Add Agenda Item</h2>
                    <button type="button" class="close-btn" onclick="closeModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnAgendaID" runat="server" Value="0" />
                <asp:HiddenField ID="hdnModalMode" runat="server" Value="add" />

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=ddlDay.ClientID%>">Day <span style="color: red;">*</span></label>
                        <asp:DropDownList ID="ddlDay" runat="server" CssClass="form-control">
                            <asp:ListItem Text="-- Select Day --" Value=""></asp:ListItem>
                            <asp:ListItem Text="Day 1" Value="Day 1"></asp:ListItem>
                            <asp:ListItem Text="Day 2" Value="Day 2"></asp:ListItem>
                            <asp:ListItem Text="Day 3" Value="Day 3"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvDay" runat="server" ControlToValidate="ddlDay"
                            ErrorMessage="Day is required" ForeColor="Red" Display="Dynamic"
                            ValidationGroup="AgendaValidation" InitialValue=""></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="<%=ddlStream.ClientID%>">Stream <span style="color: red;">*</span></label>
                        <asp:DropDownList ID="ddlStream" runat="server" CssClass="form-control">
                            <asp:ListItem Text="-- Select Stream --" Value=""></asp:ListItem>
                            <asp:ListItem Text="Stream A" Value="Stream A"></asp:ListItem>
                            <asp:ListItem Text="Stream B" Value="Stream B"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvStream" runat="server" ControlToValidate="ddlStream"
                            ErrorMessage="Stream is required" ForeColor="Red" Display="Dynamic"
                            ValidationGroup="AgendaValidation" InitialValue=""></asp:RequiredFieldValidator>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=txtTime.ClientID%>">Time <span style="color: red;">*</span></label>
                        <asp:TextBox ID="txtTime" runat="server" CssClass="form-control" placeholder="e.g., 09:00 AM - 10:00 AM"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvTime" runat="server" ControlToValidate="txtTime"
                            ErrorMessage="Time is required" ForeColor="Red" Display="Dynamic" ValidationGroup="AgendaValidation"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="<%=ddlStatus.ClientID%>">Status</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Active" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="form-group">
                    <label for="<%=txtTitle.ClientID%>">Title <span style="color: red;">*</span></label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Session title"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle"
                        ErrorMessage="Title is required" ForeColor="Red" Display="Dynamic" ValidationGroup="AgendaValidation"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtBrief.ClientID%>">Brief</label>
                    <asp:TextBox ID="txtBrief" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" placeholder="Short description"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="<%=txtSynopsis.ClientID%>">Synopsis</label>
                    <asp:TextBox ID="txtSynopsis" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Detailed description"></asp:TextBox>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeModal()">Cancel</button>
                    <asp:Button ID="btnSaveAgenda" runat="server" Text="Save" CssClass="btn btn-primary"
                        OnClick="btnSaveAgenda_Click" ValidationGroup="AgendaValidation" />
                </div>
            </div>
        </div>

        <!-- Approval/Rejection Modal -->
        <div id="approvalModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Approve/Reject Agenda Item</h2>
                    <button type="button" class="close-btn" onclick="closeApprovalModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnApprovalAgendaID" runat="server" Value="0" />

                <div class="form-row">
                    <div class="form-group">
                        <label>Day</label>
                        <asp:TextBox ID="txtApprovalDay" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Track</label>
                        <asp:TextBox ID="txtApprovalTrack" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Time</label>
                        <asp:TextBox ID="txtApprovalTime" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Registration Type</label>
                        <asp:TextBox ID="txtApprovalRegType" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label>Title</label>
                    <asp:TextBox ID="txtApprovalTitle" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Brief</label>
                    <asp:TextBox ID="txtApprovalBrief" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="<%=ddlApprovalStatus.ClientID%>">Approval Status <span style="color: red;">*</span></label>
                    <asp:DropDownList ID="ddlApprovalStatus" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                        <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                        <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem>
                    </asp:DropDownList>
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

        <script type="text/javascript">
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

            function openModal(mode, id, day, track, time, title, brief, synopsis, isActive) {
                var modal = document.getElementById('agendaModal');
                var modalTitle = document.getElementById('modalTitle');
                var hdnMode = document.getElementById('<%=hdnModalMode.ClientID%>');
                var hdnID = document.getElementById('<%=hdnAgendaID.ClientID%>');

                // Get new dropdown elements
                var ddlDay = document.getElementById('<%=ddlDay.ClientID%>');
                var ddlStream = document.getElementById('<%=ddlStream.ClientID%>');

                if (mode === 'add') {
                    modalTitle.innerText = 'Add Agenda Item';
                    hdnMode.value = 'add';
                    hdnID.value = '0';

                    // Reset dropdowns to the first item ("-- Select --")
                    ddlDay.selectedIndex = 0;
                    ddlStream.selectedIndex = 0;

                    document.getElementById('<%=txtTime.ClientID%>').value = '';
                    document.getElementById('<%=txtTitle.ClientID%>').value = '';
                    document.getElementById('<%=txtBrief.ClientID%>').value = '';
                    document.getElementById('<%=txtSynopsis.ClientID%>').value = '';
                    document.getElementById('<%=ddlStatus.ClientID%>').selectedIndex = 0;
                } else if (mode === 'edit') {
                    modalTitle.innerText = 'Edit Agenda Item';
                    hdnMode.value = 'edit';
                    hdnID.value = id;

                    // *** THIS IS THE FIX ***
                    // We set the .value of the dropdowns. 
                    // 'track' is the variable name from C# holding the value (e.g., "Stream A")
                    ddlDay.value = day || '';
                    ddlStream.value = track || '';

                    document.getElementById('<%=txtTime.ClientID%>').value = time || '';
                    document.getElementById('<%=txtTitle.ClientID%>').value = title || '';
                    document.getElementById('<%=txtBrief.ClientID%>').value = brief || '';
                    document.getElementById('<%=txtSynopsis.ClientID%>').value = synopsis || '';
                    document.getElementById('<%=ddlStatus.ClientID%>').value = isActive;
                }

                modal.classList.add('show');
            }

            function closeModal() {
                var modal = document.getElementById('agendaModal');
                modal.classList.remove('show');

                // Also reset dropdowns on close, just to be clean
                document.getElementById('<%=ddlDay.ClientID%>').selectedIndex = 0;
                document.getElementById('<%=ddlStream.ClientID%>').selectedIndex = 0;
            }

            function openApprovalModal(id, day, track, time, title, brief, regType, approvalStatus, remarks) {
                document.getElementById('<%=hdnApprovalAgendaID.ClientID%>').value = id;
                document.getElementById('<%=txtApprovalDay.ClientID%>').value = day;
                document.getElementById('<%=txtApprovalTrack.ClientID%>').value = track;
                document.getElementById('<%=txtApprovalTime.ClientID%>').value = time;
                document.getElementById('<%=txtApprovalTitle.ClientID%>').value = title;
                document.getElementById('<%=txtApprovalBrief.ClientID%>').value = brief;
                document.getElementById('<%=txtApprovalRegType.ClientID%>').value = regType;
                document.getElementById('<%=ddlApprovalStatus.ClientID%>').value = approvalStatus;
                document.getElementById('<%=txtApprovalRemarks.ClientID%>').value = remarks || '';

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
                if (status === 'Rejected') {
                    remarksReq.style.display = 'inline';
                } else {
                    remarksReq.style.display = 'none';
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

            window.onclick = function (event) {
                var agendaModal = document.getElementById('agendaModal');
                var approvalModal = document.getElementById('approvalModal');

                if (event.target == agendaModal) {
                    closeModal();
                }
                if (event.target == approvalModal) {
                    closeApprovalModal();
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                var ddlApproval = document.getElementById('<%=ddlApprovalStatus.ClientID%>');
                if (ddlApproval) {
                    ddlApproval.addEventListener('change', toggleRemarksRequired);
                }
            });
        </script>
    </form>
</body>
</html>
