<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageExhibitor.aspx.cs" Inherits="Expo_Panel.Admin.ExhibitorDashboard" %>

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
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
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
                color: #ed8936;
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
            background: #ed8936;
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

        /* Toggle Switch Styles */
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

        .action-buttons {
            display: flex;
            gap: 8px;
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
            max-width: 700px;
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
                color: #4f46e5;
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

        .form-group {
            margin-bottom: 20px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #475569;
            font-weight: 500;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
        }

            .form-group input:focus,
            .form-group select:focus {
                outline: none;
                border-color: #667eea;
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

        .inactive-row .action-buttons .btn {
            font-style: normal;
            opacity: 0.6;
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
                background: #ed8936;
                color: white;
                border-color: #ed8936;
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

        .remarks-cell {
            display: block;
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: help;
        }

        #remarksRequired {
            display: none;
        }

        .alert-info {
            background: #dbeafe;
            color: #1e40af;
            border: 1px solid #bfdbfe;
        }

        table th, table td {
            padding-left: 8px; /* Was 15px */
            padding-right: 8px; /* Was 15px */
        }

        table th {
            white-space: nowrap;
        }

        table {
            font-size: 13px; /* Reduce from default 14px */
        }

            table th {
                font-size: 13px;
            }

                table th:nth-child(4), /* Mobile */
                table td:nth-child(4) {
                    max-width: 100px;
                }

                table th:nth-child(5), /* Designation */
                table td:nth-child(5) {
                    max-width: 90px;
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                }

                table th:nth-child(6), /* Company */
                table td:nth-child(6) {
                    max-width: 120px;
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                }

                table th:nth-child(8), /* Approval */
                table td:nth-child(8) {
                    max-width: 90px;
                }

        .action-buttons .btn {
            padding: 6px 10px;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="container">
            <div class="header">
                <h1><i class="fas fa-store"></i>Manage Exhibitors</h1>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <span>Welcome,
                <asp:Label ID="lblUsername" runat="server" Text=""></asp:Label>
                        | Session Status:
                <asp:Label ID="lblSessionStatus" runat="server" Text=""></asp:Label>
                    </span>
                    <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="~/Admin/Dashboard.aspx" CssClass="btn btn-info">
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
                        <a href="/RegisterExhibitor.aspx" class="btn btn-info" target="_blank">
                            <i class="fas fa-link"></i>Get Registration Link
                        </a>

                        <button type="button" class="btn btn-success" onclick="openModal('add')">
                            <i class="fas fa-plus"></i>Add Exhibitor
                        </button>
                    </div>
                </div>

                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="grid-container">
                            <asp:GridView ID="gvExhibitors" runat="server" AutoGenerateColumns="False"
                                OnRowCommand="gvExhibitors_RowCommand" DataKeyNames="ExhibitorID"
                                CssClass="exhibitors-grid" GridLines="None" OnRowDataBound="gvExhibitors_RowDataBound">
                                <Columns>
                                    <asp:BoundField DataField="ExhibitorID" HeaderText="ID" Visible="false" />

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
                                                CommandArgument='<%# Eval("ExhibitorID") %>'
                                                CssClass="toggle-button-hidden"
                                                ID="Button1" />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <div class="action-buttons">
                                                <asp:Button runat="server" Text="Edit" CommandName="EditExhibitor"
                                                    CommandArgument='<%# Eval("ExhibitorID") %>'
                                                    CssClass="btn btn-edit" />
                                                <asp:Button runat="server" Text="Approve/Reject" CommandName="ApprovalAction"
                                                    CommandArgument='<%# Eval("ExhibitorID") %>'
                                                    CssClass="btn btn-warning" />
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

        <!-- Add/Edit Modal -->
        <div id="exhibitorModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 id="modalTitle">Add Exhibitor</h2>
            <button type="button" class="close-btn" onclick="closeModal()">&times;</button>
        </div>

        <asp:HiddenField ID="hdnExhibitorID" runat="server" Value="0" />
        <asp:HiddenField ID="hdnModalMode" runat="server" Value="add" />

        <div class="form-row">
            <div class="form-group">
                <label for="<%=txtName.ClientID%>">Name <span style="color: red;">*</span></label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter exhibitor name"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                    ErrorMessage="Name is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ExhibitorValidation"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="<%=txtEmail.ClientID%>">Email <span style="color: red;">*</span></label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter email address"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ExhibitorValidation"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Invalid email format" ForeColor="Red" Display="Dynamic"
                    ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" ValidationGroup="ExhibitorValidation"></asp:RegularExpressionValidator>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="<%=txtMobile.ClientID%>">Mobile</label>
                <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" placeholder="Enter mobile number"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="<%=txtDesignation.ClientID%>">Designation <span style="color: red;">*</span></label>
                <asp:TextBox ID="txtDesignation" runat="server" CssClass="form-control" placeholder="Enter designation"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvDesignation" runat="server" ControlToValidate="txtDesignation"
                    ErrorMessage="Designation is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ExhibitorValidation"></asp:RequiredFieldValidator>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="<%=txtCompany.ClientID%>">Company <span style="color: red;">*</span></label>
                <asp:TextBox ID="txtCompany" runat="server" CssClass="form-control" placeholder="Enter company name"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCompany" runat="server" ControlToValidate="txtCompany"
                    ErrorMessage="Company is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ExhibitorValidation"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="<%=ddlStatus.ClientID%>">Status</label>
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Active" Value="1" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="modal-footer">
            <button type="button" class="btn btn-cancel" onclick="closeModal()">Cancel</button>
            <asp:Button ID="btnSaveExhibitor" runat="server" Text="Save" CssClass="btn btn-primary"
                OnClick="btnSaveExhibitor_Click" ValidationGroup="ExhibitorValidation" />
        </div>
    </div>
</div>
        <!-- Approval/Rejection Modal -->
        <div id="approvalModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="approvalModalTitle">Approve/Reject Exhibitor</h2>
                    <button type="button" class="close-btn" onclick="closeApprovalModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnApprovalExhibitorID" runat="server" Value="0" />

                <div class="form-group">
                    <label>Name</label>
                    <asp:TextBox ID="txtApprovalName" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Email</label>
                        <asp:TextBox ID="txtApprovalEmail" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Registration Type</label>
                        <asp:TextBox ID="txtApprovalRegType" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
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

            function openModal(mode, id, name, email, mobile, designation, company, isActive) {
                var modal = document.getElementById('exhibitorModal');
                var modalTitle = document.getElementById('modalTitle');
                var hdnMode = document.getElementById('<%=hdnModalMode.ClientID%>');
                var hdnID = document.getElementById('<%=hdnExhibitorID.ClientID%>');

                if (mode === 'add') {
                    modalTitle.innerText = 'Add Exhibitor';
                    hdnMode.value = 'add';
                    hdnID.value = '0';
                    document.getElementById('<%=txtName.ClientID%>').value = '';
                    document.getElementById('<%=txtEmail.ClientID%>').value = '';
                    document.getElementById('<%=txtMobile.ClientID%>').value = '';
                    document.getElementById('<%=txtDesignation.ClientID%>').value = '';
                    document.getElementById('<%=txtCompany.ClientID%>').value = '';
                    document.getElementById('<%=ddlStatus.ClientID%>').selectedIndex = 0;
                } else if (mode === 'edit') {
                    modalTitle.innerText = 'Edit Exhibitor';
                    hdnMode.value = 'edit';
                    hdnID.value = id;
                    document.getElementById('<%=txtName.ClientID%>').value = name;
                    document.getElementById('<%=txtEmail.ClientID%>').value = email;
                    document.getElementById('<%=txtMobile.ClientID%>').value = mobile;
                    document.getElementById('<%=txtDesignation.ClientID%>').value = designation;
                    document.getElementById('<%=txtCompany.ClientID%>').value = company;
                    document.getElementById('<%=ddlStatus.ClientID%>').value = isActive;
                }

                modal.classList.add('show');
            }

            function closeModal() {
                var modal = document.getElementById('exhibitorModal');
                modal.classList.remove('show');
            }

            window.onclick = function (event) {
                var modal = document.getElementById('exhibitorModal');
                if (event.target == modal) {
                    closeModal();
                }
            }
            function openApprovalModal(id, name, email, regType, designation, company, approvalStatus, remarks) {
                document.getElementById('<%=hdnApprovalExhibitorID.ClientID%>').value = id;
                document.getElementById('<%=txtApprovalName.ClientID%>').value = name;
                document.getElementById('<%=txtApprovalEmail.ClientID%>').value = email;
                document.getElementById('<%=txtApprovalRegType.ClientID%>').value = regType;
                document.getElementById('<%=txtApprovalDesignation.ClientID%>').value = designation;
                document.getElementById('<%=txtApprovalCompany.ClientID%>').value = company;
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

            // Update window.onclick to handle both modals
            window.onclick = function (event) {
                var exhibitorModal = document.getElementById('exhibitorModal');
                var approvalModal = document.getElementById('approvalModal');

                if (event.target == exhibitorModal) {
                    closeModal();
                }
                if (event.target == approvalModal) {
                    closeApprovalModal();
                }
            }

            // Add onchange event to approval status dropdown
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
