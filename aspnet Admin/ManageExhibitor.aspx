<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageExhibitor.aspx.cs" Inherits="Expo_Panel.Admin.ManageExhibitor" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Exhibitors - Expo Panel</title>
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
            background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
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
            max-width: 1200px;
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="container">
            <div class="header">
                <h1><i class="fas fa-users"></i> Manage Exhibitors</h1>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <span>Welcome, <asp:Label ID="lblUsername" runat="server" Text=""></asp:Label></span>
                    <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="~/Admin/Dashboard.aspx" CssClass="btn btn-info">
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
                            <i class="fas fa-link"></i> Get Registration Link
                        </a>
                        <button type="button" class="btn btn-success" onclick="openExhibitorModal('add')">
                            <i class="fas fa-plus"></i> Add Exhibitor
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
                                            <div class="action-buttons">
                                                <button type="button" class="btn btn-edit" 
                                                    onclick="handleEditClick(<%# Eval("ExhibitorID") %>)">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <button type="button" class="btn btn-warning" 
                                                    onclick="handleApprovalClick(<%# Eval("ExhibitorID") %>)">
                                                    <i class="fas fa-check-circle"></i> Approve/Reject
                                                </button>
                                                <asp:LinkButton runat="server" CommandName="ViewProfile"
                                                    CommandArgument='<%# Eval("ExhibitorID") %>'
                                                    CssClass="btn btn-view"
                                                    Visible='<%# Convert.ToBoolean(Eval("HasProfile")) %>'>
                                                    <i class="fas fa-eye"></i> View Profile
                                                </asp:LinkButton>
                                            </div>
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
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="exhibitorModalTitle">Add Exhibitor</h2>
                    <button type="button" class="close-btn" onclick="closeExhibitorModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnExhibitorID" runat="server" Value="0" />
                <asp:HiddenField ID="hdnExhibitorModalMode" runat="server" Value="add" />

                <div class="section-divider">
                    <i class="fas fa-user"></i> Basic Information
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
                    <i class="fas fa-building"></i> Company Information
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
                    <i class="fas fa-warehouse"></i> Booth Requirements
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
                    <i class="fas fa-star"></i> Additional Interests
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

                <div class="section-divider">
                    <i class="fas fa-cog"></i> System Settings
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

        <!-- Approval/Rejection Modal -->
        <div id="approvalModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Approve/Reject Exhibitor</h2>
                    <button type="button" class="close-btn" onclick="closeApprovalModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnApprovalExhibitorID" runat="server" Value="0" />

                <div class="form-row">
                    <div class="form-group">
                        <label>Name</label>
                        <asp:TextBox ID="txtApprovalName" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <asp:TextBox ID="txtApprovalEmail" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Company</label>
                        <asp:TextBox ID="txtApprovalCompany" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Registration Type</label>
                        <asp:TextBox ID="txtApprovalRegType" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label for="<%=ddlApprovalStatus.ClientID%>">Approval Status <span class="required">*</span></label>
                    <asp:DropDownList ID="ddlApprovalStatus" runat="server">
                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                        <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                        <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label for="<%=txtPassword.ClientID%>">Password <span id="passwordRequired" style="color: red;">*</span></label>
                    <div class="password-field">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter password for login (required for approval)"></asp:TextBox>
                        <i class="fas fa-eye password-toggle" onclick="togglePassword('<%=txtPassword.ClientID%>')"></i>
                    </div>
                    <small style="color: #6b7280; font-size: 12px;">Password is required when approving an exhibitor. Leave blank if rejecting.</small>
                    <asp:CustomValidator ID="cvPassword" runat="server"
                        ControlToValidate="txtPassword"
                        ClientValidationFunction="validatePassword"
                        OnServerValidate="cvPassword_ServerValidate"
                        ErrorMessage="Password is required when approving"
                        ForeColor="Red" Display="Dynamic"
                        ValidationGroup="ApprovalValidation"></asp:CustomValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtApprovalRemarks.ClientID%>">Remarks <span style="color: red;" id="remarksRequired">*</span></label>
                    <asp:TextBox ID="txtApprovalRemarks" runat="server" TextMode="MultiLine" Rows="3" placeholder="Enter remarks (required for rejection)"></asp:TextBox>
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

        <!-- View Profile Modal -->
        <div id="profileModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Post-Approval Profile</h2>
                    <button type="button" class="close-btn" onclick="closeProfileModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnProfileExhibitorID" runat="server" Value="0" />
                <asp:Panel ID="pnlProfileDetails" runat="server">
                    <!-- Profile details will be loaded dynamically -->
                </asp:Panel>

                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeProfileModal()">Close</button>
                </div>
            </div>
        </div>

        <!-- Hidden buttons for server-side actions -->
        <asp:HiddenField ID="hdnEditExhibitorID" runat="server" Value="0" />
        <asp:Button ID="btnTriggerEdit" runat="server" OnClick="btnTriggerEdit_Click" style="display:none;" />
        
        <asp:HiddenField ID="hdnApproveExhibitorID" runat="server" Value="0" />
        <asp:Button ID="btnTriggerApproval" runat="server" OnClick="btnTriggerApproval_Click" style="display:none;" />

        <script type="text/javascript">
            function handleEditClick(exhibitorId) {
                document.getElementById('<%=hdnEditExhibitorID.ClientID%>').value = exhibitorId;
                document.getElementById('<%=btnTriggerEdit.ClientID%>').click();
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

            function openExhibitorModal(mode, data) {
                var modal = document.getElementById('exhibitorModal');
                var modalTitle = document.getElementById('exhibitorModalTitle');
                var hdnMode = document.getElementById('<%=hdnExhibitorModalMode.ClientID%>');
                var hdnID = document.getElementById('<%=hdnExhibitorID.ClientID%>');

                if (mode === 'add') {
                    modalTitle.innerText = 'Add Exhibitor';
                    hdnMode.value = 'add';
                    hdnID.value = '0';
                    clearExhibitorForm();
                } else if (mode === 'edit' && data) {
                    modalTitle.innerText = 'Edit Exhibitor';
                    hdnMode.value = 'edit';
                    hdnID.value = data.id;
                    populateExhibitorForm(data);
                }

                modal.classList.add('show');
            }

            function closeExhibitorModal() {
                var modal = document.getElementById('exhibitorModal');
                modal.classList.remove('show');
            }

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
                document.getElementById('<%=chkConference.ClientID%>').checked = data.conference === 'True';
                document.getElementById('<%=chkSponsorship.ClientID%>').checked = data.sponsorship === 'True';
                document.getElementById('<%=chkAdvertising.ClientID%>').checked = data.advertising === 'True';
                document.getElementById('<%=chkCustomPackage.ClientID%>').checked = data.customPackage === 'True';
                document.getElementById('<%=ddlStatus.ClientID%>').value = data.isActive;
                document.getElementById('<%=ddlRegistrationType.ClientID%>').value = data.regType || 'Admin';
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

            function openProfileModal() {
                var modal = document.getElementById('profileModal');
                modal.classList.add('show');
            }

            function closeProfileModal() {
                var modal = document.getElementById('profileModal');
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
                var profileModal = document.getElementById('profileModal');

                if (event.target == exhibitorModal) {
                    closeExhibitorModal();
                }
                if (event.target == approvalModal) {
                    closeApprovalModal();
                }
                if (event.target == profileModal) {
                    closeProfileModal();
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                var ddlApproval = document.getElementById('<%=ddlApprovalStatus.ClientID%>');
                if (ddlApproval) {
                    ddlApproval.addEventListener('change', toggleRemarksAndPasswordRequired);
                }
            });
        </script>
    </form>
</body>
</html>