<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageAdvisors.aspx.cs" Inherits="Expo_Panel.Admin.ManageAdvisorsTeam" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Advisors - Expo Panel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        /* ========================================
        == FULL TERRACOTTA & AMBER THEME ==
        ========================================
        This is the complete, modified style block.
        */

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        /* 1. Body Background Gradient */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #D97706 0%, #D97300 100%);
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

            /* 2. Header & Modal Title Color */
            .header h1 {
                color: #D97706; /* Amber */
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

            /* 3. Form Focus Color */
            .form-control:focus {
                outline: none;
                border-color: #F97316; /* Bright Orange */
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

        /* 4. Primary Button (Search, Save) */
        .btn-primary {
            background: #F97316; /* Bright Orange */
            color: white;
        }

            .btn-primary:hover {
                background: #EA580C; /* Darker Orange */
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(249, 115, 22, 0.4);
            }

        /* 5. Success Button (Add Advisor) - Standard Green */
        .btn-success {
            background: #16A34A; /* Green */
            color: white;
        }

            .btn-success:hover {
                background: #15803D; /* Darker Green */
            }

        /* 6. Edit Button */
        .btn-edit {
            background: #F97316; /* Bright Orange */
            color: white;
            padding: 6px 12px;
            font-size: 13px;
        }

            .btn-edit:hover {
                background: #EA580C; /* Darker Orange */
            }

        /* 7. Danger Button (Logout) - Standard Red */
        .btn-danger {
            background: #DC2626; /* Red */
            color: white;
        }

            .btn-danger:hover {
                background: #B91C1C; /* Darker Red */
            }

        /* 8. Info Button (Back, Get Link) */
        .btn-info {
            background: #F97316; /* Light Orange/Peach */
            color: white;
        }

            .btn-info:hover {
                background: #F97316; /* Bright Orange */
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(251, 146, 60, 0.4);
            }

        /* 9. Warning Button (Approve/Reject) - Amber */
        .btn-warning {
            background: #D97706; /* Amber */
            color: white;
            padding: 6px 12px;
            font-size: 13px;
        }

            .btn-warning:hover {
                background: #B45309; /* Dark Amber */
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

                /* 10. Table Sr. No. Color */
                table td:first-child {
                    text-align: center;
                    font-weight: 600;
                    color: #D97706; /* Amber */
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

        /* 11. Toggle Switch Colors (Off = Red, On = Green) */
        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #DC2626; /* Red */
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
            background-color: #16A34A; /* Green */
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

        /* 12. Alert Box Colors (Themed) */
        .alert-success {
            background: #D1FAE5;
            color: #065F46;
            border: 1px solid #A7F3D0;
        }

        .alert-danger {
            background: #FEE2E2;
            color: #991B1B;
            border: 1px solid #FECACA;
        }

        .alert-info {
            background: #FFFBEB; /* Light Yellow/Amber */
            color: #B45309; /* Dark Amber */
            border: 1px solid #FEF3C7;
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

            /* 13. Modal Header Color */
            .modal-header h2 {
                color: #D97706; /* Amber */
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
                color: #DC2626; /* Red */
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

            .form-group input, .form-group select, .form-group textarea {
                width: 100%;
                padding: 10px 15px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                font-family: 'Poppins', sans-serif;
            }

                /* 14. Form Focus Color (Repeated for specificity) */
                .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
                    outline: none;
                    border-color: #F97316; /* Bright Orange */
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

            /* 15. Active Filter Button */
            .btn-filter.active {
                background: #F97316; /* Bright Orange */
                color: white;
                border-color: #F97316;
            }

        .badge-status {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        /* 16. Badge Colors (Themed) */
        .badge-pending {
            background: #FFFBEB; /* Light Yellow */
            color: #B45309; /* Dark Amber */
        }

        .badge-approved {
            background: #D1FAE5; /* Light Green */
            color: #065F46; /* Dark Green */
        }

        .badge-rejected {
            background: #FEE2E2; /* Light Red */
            color: #991B1B; /* Dark Red */
        }

        .badge-admin {
            background: #FFF7ED; /* Light Orange */
            color: #92400E; /* Dark Brown */
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .badge-online {
            background: #FFFBEB; /* Light Yellow */
            color: #B45309; /* Dark Amber */
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

        #remarksRequired {
            display: none;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }

        /* ADD THESE NEW STYLES */
        .password-wrapper {
            position: relative;
        }

        .password-toggle-icon {
            position: absolute;
            right: 15px; /* Adjust spacing from the right edge */
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6b7280; /* A neutral gray color */
            z-index: 2;
        }

            .password-toggle-icon:hover {
                color: #D97706; /* Use your theme's Amber color on hover */
            }

        /* This targets the password textbox specifically to add padding */
        /* so the text doesn't type *under* the icon */
        #passwordField .form-control {
            padding-right: 40px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <%-- --- CHANGED ---
             Added EnablePageMethods="true" to allow JavaScript to call C# code --%>
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

        <div class="container">
            <div class="header">
                <h1><i class="fas fa-users-cog"></i>Manage Advisors</h1>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <span>Welcome,
                        <asp:Label ID="lblUsername" runat="server" Text=""></asp:Label>
                        |
                        Session Status:
                        <asp:Label ID="lblSessionStatus" runat="server" Text=""></asp:Label>
                    </span>
                    <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="~/Admin/Dashboard.aspx" CssClass="btn btn-info">
                        <i class="fas fa-arrow-left"></i> Back
                    </asp:HyperLink>
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-danger" OnClick="btnLogout_Click" />
                </div>
            </div>

            <div class="dashboard-card">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>

                        <div class="status-filters">
                            <asp:Button ID="btnPending" runat="server" Text="Pending (0)" CssClass="btn-filter active" OnClick="btnStatusFilter_Click" CommandArgument="Pending" />
                            <asp:Button ID="btnApproved" runat="server" Text="Approved (0)" CssClass="btn-filter" OnClick="btnStatusFilter_Click" CommandArgument="Approved" />
                            <asp:Button ID="btnRejected" runat="server" Text="Rejected (0)" CssClass="btn-filter" OnClick="btnStatusFilter_Click" CommandArgument="Rejected" />
                            <asp:HiddenField ID="hdnCurrentFilter" runat="server" Value="Pending" />
                        </div>

                        <div class="toolbar">
                            <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
                                <div class="search-box">
                                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by name, email, company..."></asp:TextBox>
                                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                                </div>
                            </asp:Panel>
                            <button type="button" class="btn btn-success" onclick="openAdvisorModal('add')">
                                <i class="fas fa-plus"></i>Add Advisor
                            </button>
                        </div>

                        <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>
                        <div class="grid-container">
                            <asp:GridView ID="gvAdvisors" runat="server" AutoGenerateColumns="False"
                                OnRowCommand="gvAdvisors_RowCommand" DataKeyNames="AdvisorID"
                                CssClass="agenda-grid" GridLines="None" OnRowDataBound="gvAdvisors_RowDataBound">
                                <Columns>
                                    <asp:BoundField DataField="AdvisorID" HeaderText="ID" Visible="false" />

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

                                    <asp:TemplateField HeaderText="Designation">
                                        <ItemTemplate>
                                            <span class="truncate-cell" title='<%# Eval("Designation") %>'>
                                                <%# Eval("Designation") %>
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

                                    <asp:TemplateField HeaderText="Status" Visible="false">
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
                                                CommandArgument='<%# Eval("AdvisorID") %>'
                                                CssClass="toggle-button-hidden"
                                                ID="btnToggle" />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <div class="action-buttons">
                                                <button type="button" class="btn btn-edit"
                                                    onclick="loadAdvisorForEdit(<%# Eval("AdvisorID") %>)">
                                                    <i class="fas fa-pencil-alt"></i>Edit
                                                </button>
                                                <button type="button" class="btn btn-warning" style="display:none"
                                                    onclick="loadAdvisorForApproval(<%# Eval("AdvisorID") %>)">
                                                    <i class="fas fa-check-double"></i>Approve/Reject
                                                </button>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="no-records">
                                        <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 15px; display: block;"></i>
                                        No advisors found. Click "Add Advisor" to create one.
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="gvAdvisors" EventName="RowCommand" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>

        <%-- This is the Add/Edit Modal --%>
        <div id="advisorModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitle">Add Advisor</h2>
                    <button type="button" class="close-btn" onclick="closeAdvisorModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnAdvisorID" runat="server" Value="0" />
                <asp:HiddenField ID="hdnModalMode" runat="server" Value="add" />

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=txtName.ClientID%>">Full Name <span style="color: red;">*</span></label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="e.g., John Doe"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                            ErrorMessage="Name is required" ForeColor="Red" Display="Dynamic" ValidationGroup="AdvisorValidation"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="<%=txtEmail.ClientID%>">Email <span style="color: red;">*</span></label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="e.g., john.doe@example.com" TextMode="Email"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic" ValidationGroup="AdvisorValidation"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Invalid email format" ForeColor="Red" Display="Dynamic" ValidationGroup="AdvisorValidation"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=txtMobile.ClientID%>">Mobile</label>
                        <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" placeholder="e.g., +919876543210"></asp:TextBox>
                    </div>

                    <div class="form-group" id="passwordField">
                        <%-- The label for the password field. JS will change this. --%>
                        <label for="<%=txtPassword.ClientID%>">Password <span style="color: red;">*</span></label>

                        <div class="password-wrapper">
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            <i class="fas fa-eye password-toggle-icon"
                                onclick="togglePasswordVisibility(this, '<%=txtPassword.ClientID%>')"></i>
                        </div>

                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                            ErrorMessage="Password is required" ForeColor="Red" Display="Dynamic" ValidationGroup="AdvisorValidation"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=txtDesignation.ClientID%>">Designation</label>
                        <asp:TextBox ID="txtDesignation" runat="server" CssClass="form-control" placeholder="e.g., CEO"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="<%=txtCompany.ClientID%>">Company</label>
                        <asp:TextBox ID="txtCompany" runat="server" CssClass="form-control" placeholder="e.g., Example Inc."></asp:TextBox>
                    </div>
                </div>

                <div class="form-group" style="display:none">
                    <label for="<%=ddlStatus.ClientID%>">Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Active" Value="1" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeAdvisorModal()">Cancel</button>
                    <asp:Button ID="btnSaveAdvisor" runat="server" Text="Save" CssClass="btn btn-primary"
                        OnClick="btnSaveAdvisor_Click" ValidationGroup="AdvisorValidation" />
                </div>
            </div>
        </div>

        <%-- This is the Approval Modal --%>
        <div id="approvalModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Approve/Reject Advisor</h2>
                    <button type="button" class="close-btn" onclick="closeAdvisorApprovalModal()">&times;</button>
                </div>

                <asp:HiddenField ID="hdnApprovalAdvisorID" runat="server" Value="0" />

                <div class="form-row">
                    <div class="form-group">
                        <label>Name</label>
                        <asp:TextBox ID="txtApprovalName" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <asp:TextBox ID="txtApprovalEmail" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Company</label>
                        <asp:TextBox ID="txtApprovalCompany" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Registration Type</label>
                        <asp:TextBox ID="txtApprovalRegType" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label>Designation</label>
                    <asp:TextBox ID="txtApprovalDesignation" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
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
                    <button type="button" class="btn btn-cancel" onclick="closeAdvisorApprovalModal()">Cancel</button>
                    <asp:Button ID="btnSaveApproval" runat="server" Text="Save" CssClass="btn btn-primary"
                        OnClick="btnSaveApproval_Click" ValidationGroup="ApprovalValidation" />
                </div>
            </div>
        </div>

        <script type="text/javascript">
            // This JS is almost identical to ManageAgenda.aspx.js
            // Just renamed functions to be specific to "Advisor"

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
                    // Note: I removed the alert() from here as you requested
                }
            }

            // --- NEW FUNCTION ---
            // This is called by the new "Edit" button.
            // It calls the C# WebMethod.
            function loadAdvisorForEdit(id) {
                // You could show a spinner/loading icon here
                PageMethods.GetAdvisorDetails(id, onEditSuccess, onModalError);
            }

            // --- NEW FUNCTION ---
            // This is called by the new "Approve/Reject" button.
            function loadAdvisorForApproval(id) {
                PageMethods.GetAdvisorDetails(id, onApprovalSuccess, onModalError);
            }

            // --- NEW FUNCTION ---
            // This is the "success" callback for the Edit button's AJAX call.
            // 'result' is the JSON string from the C# WebMethod.
            function onEditSuccess(result) {
                var data = JSON.parse(result);
                if (data.error) {
                    onModalError(data.error);
                    return;
                }

                // Call your existing modal function with the data
                openAdvisorModal('edit',
                    data.AdvisorID,
                    data.Name,
                    data.Email,
                    data.Mobile,
                    data.Designation,
                    data.Company,
                    data.IS_ACTIVE,
                    data.Password // <-- We now pass the password
                );
            }

            // --- NEW FUNCTION ---
            // This is the "success" callback for the Approval button's AJAX call.
            function onApprovalSuccess(result) {
                var data = JSON.parse(result);
                if (data.error) {
                    onModalError(data.error);
                    return;
                }

                // Call your existing approval modal function
                openAdvisorApprovalModal(
                    data.AdvisorID,
                    data.Name,
                    data.Email,
                    data.Company,
                    data.RegistrationType,
                    data.Designation,
                    data.ApprovalStatus,
                    data.Remarks
                );
            }

            // --- NEW FUNCTION ---
            // This is the "error" callback for both AJAX calls.
            function onModalError(error) {
                console.error("Error loading advisor details:", error);
                // You can show your custom 'ShowMessage' alert here if you want
            }


            // --- MODIFIED FUNCTION ---
            // Now accepts 'password' as the last argument
            function openAdvisorModal(mode, id, name, email, mobile, designation, company, isActive, password) {
                var modal = document.getElementById('advisorModal');
                var modalTitle = document.getElementById('modalTitle');
                var hdnMode = document.getElementById('<%=hdnModalMode.ClientID%>');
                var hdnID = document.getElementById('<%=hdnAdvisorID.ClientID%>');

                var passField = document.getElementById('passwordField');
                var passInput = document.getElementById('<%=txtPassword.ClientID%>');
                var passReq = document.getElementById('<%=rfvPassword.ClientID%>');
                var passLabel = document.querySelector('label[for="<%=txtPassword.ClientID%>"]');

                // Clear any previous validation errors
                if (typeof (Page_ClientValidate) == 'function') {
                    for (var i = 0; i < Page_Validators.length; i++) {
                        if (Page_Validators[i].validationGroup == "AdvisorValidation") {
                            Page_Validators[i].isvalid = true;
                            ValidatorUpdateDisplay(Page_Validators[i]);
                        }
                    }
                }

                if (mode === 'add') {
                    modalTitle.innerText = 'Add Advisor';
                    hdnMode.value = 'add';
                    hdnID.value = '0';
                    document.getElementById('<%=txtName.ClientID%>').value = '';
                    document.getElementById('<%=txtEmail.ClientID%>').value = '';
                    document.getElementById('<%=txtMobile.ClientID%>').value = '';
                    passInput.value = ''; // Clear password field
                    document.getElementById('<%=txtDesignation.ClientID%>').value = '';
                    document.getElementById('<%=txtCompany.ClientID%>').value = '';
                    document.getElementById('<%=ddlStatus.ClientID%>').selectedIndex = 0;

                    // Show and enable password validation for 'add' mode
                    passField.style.display = 'block';
                    if (passLabel) passLabel.innerHTML = 'Password <span style="color: red;">*</span>';
                    if (passReq) ValidatorEnable(passReq, true);

                    // Reset password field to 'password' type
                    passInput.type = 'password';
                    var icon = passField.querySelector('.password-toggle-icon');
                    if (icon) {
                        icon.classList.remove('fa-eye-slash');
                        icon.classList.add('fa-eye');
                    }

                } else if (mode === 'edit') {
                    modalTitle.innerText = 'Edit Advisor';
                    hdnMode.value = 'edit';
                    hdnID.value = id;
                    document.getElementById('<%=txtName.ClientID%>').value = name || '';
                    document.getElementById('<%=txtEmail.ClientID%>').value = email || '';
                    document.getElementById('<%=txtMobile.ClientID%>').value = mobile || '';
                    document.getElementById('<%=txtDesignation.ClientID%>').value = designation || '';
                    document.getElementById('<%=txtCompany.ClientID%>').value = company || '';
                    document.getElementById('<%=ddlStatus.ClientID%>').value = isActive;

                    // --- THIS IS THE NEW LOGIC FOR YOUR PASSWORD REQUEST ---

                    // 1. Show the password field (was 'none' before)
                    passField.style.display = 'block';

                    // 2. Set the password value from the database
                    passInput.value = password || '';

                    // 3. Change the label text
                    if (passLabel) passLabel.innerHTML = 'Password (Leave blank to keep current)';

                    // 4. Disable the "Required" validator (it's optional on edit)
                    if (passReq) ValidatorEnable(passReq, false);

                    // Reset password field to 'password' type
                    passInput.type = 'password';
                    var icon = passField.querySelector('.password-toggle-icon');
                    if (icon) {
                        icon.classList.remove('fa-eye-slash');
                        icon.classList.add('fa-eye');
                    }
                }

                modal.classList.add('show');
            }

            function closeAdvisorModal() {
                var modal = document.getElementById('advisorModal');
                modal.classList.remove('show');
            }

            function openAdvisorApprovalModal(id, name, email, company, regType, designation, approvalStatus, remarks) {
                document.getElementById('<%=hdnApprovalAdvisorID.ClientID%>').value = id;
                document.getElementById('<%=txtApprovalName.ClientID%>').value = name || '';
                document.getElementById('<%=txtApprovalEmail.ClientID%>').value = email || '';
                document.getElementById('<%=txtApprovalCompany.ClientID%>').value = company || '';
                document.getElementById('<%=txtApprovalRegType.ClientID%>').value = regType || '';
                document.getElementById('<%=txtApprovalDesignation.ClientID%>').value = designation || '';
                document.getElementById('<%=ddlApprovalStatus.ClientID%>').value = approvalStatus;
                document.getElementById('<%=txtApprovalRemarks.ClientID%>').value = remarks || '';

                var modal = document.getElementById('approvalModal');
                modal.classList.add('show');

                toggleRemarksRequired();
            }

            function closeAdvisorApprovalModal() {
                var modal = document.getElementById('approvalModal');
                modal.classList.remove('show');
            }

            // This function is identical, so it's fine to re-use
            function toggleRemarksRequired() {
                var status = document.getElementById('<%=ddlApprovalStatus.ClientID%>').value;
                var remarksReq = document.getElementById('remarksRequired');
                if (status === 'Rejected') {
                    remarksReq.style.display = 'inline';
                } else {
                    remarksReq.style.display = 'none';
                }
            }

            // This function is identical, so it's fine to re-use
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
                var advisorModal = document.getElementById('advisorModal');
                var approvalModal = document.getElementById('approvalModal');

                if (event.target == advisorModal) {
                    closeAdvisorModal();
                }
                if (event.target == approvalModal) {
                    closeAdvisorApprovalModal();
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                var ddlApproval = document.getElementById('<%=ddlApprovalStatus.ClientID%>');
                if (ddlApproval) {
                    ddlApproval.addEventListener('change', toggleRemarksRequired);
                }
            });

            // This function is for your password 'eye' icon
            function togglePasswordVisibility(icon, inputId) {
                var input = document.getElementById(inputId);
                if (input.type === 'password') {
                    input.type = 'text';
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                } else {
                    input.type = 'password';
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                }
            }
        </script>
    </form>
</body>
</html>