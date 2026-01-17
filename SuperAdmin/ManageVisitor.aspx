<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageVisitor.aspx.cs" Inherits="Expo_Panel.SuperAdmin.ManageVisitor" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Visitors - Expo Panel</title>

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

    <style>
        /* GOLDEN THEME */
        :root {
            --primary-gold: #d97706;
            --gradient-start: #f59e0b;
            --gradient-end: #b45309;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        /* HEADER */
        .header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 20px 30px;
            margin-bottom: 25px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

            .header h1 {
                color: var(--primary-gold);
                font-size: 26px;
                font-weight: 600;
                margin: 0;
            }

        /* User Info Section in Header */
        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
            background: #fff7ed;
            padding: 8px 16px;
            border-radius: 30px;
            border: 1px solid #fed7aa;
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            background: var(--primary-gold);
            color: white;
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
            line-height: 1.2;
        }

        .user-name {
            font-size: 13px;
            font-weight: 600;
            color: #7c2d12;
        }

        .user-role {
            font-size: 11px;
            color: #9a3412;
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
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: var(--primary-gold);
            color: white;
        }

            .btn-primary:hover {
                background: #b45309;
            }

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .btn-info {
            background: #0ea5e9;
            color: white;
        }

        .btn-cancel {
            background: #e2e8f0;
            color: #475569;
        }

        .btn-edit {
            background: #3b82f6;
            color: white;
            padding: 6px 12px;
            font-size: 13px;
        }

        .btn-warning {
            background: #f59e0b;
            color: white;
            padding: 6px 12px;
            font-size: 13px;
        }

        /* Dashboard Card */
        .dashboard-card {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        /* Filters */
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
            cursor: pointer;
            font-weight: 500;
        }

            .btn-filter.active {
                background: var(--primary-gold);
                color: white;
                border-color: var(--primary-gold);
            }

        /* Search */
        .toolbar {
            display: flex;
            justify-content: space-between;
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
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
        }

            .form-control:focus {
                outline: none;
                border-color: var(--primary-gold);
            }

        /* Grid */
        .grid-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

            table th {
                padding: 15px;
                text-align: left;
                font-weight: 600;
                color: #9a3412;
                border-bottom: 2px solid #fed7aa;
                font-size: 13px;
            }

            table td {
                padding: 15px;
                border-bottom: 1px solid #e2e8f0;
                color: #334155;
                font-size: 13px;
            }

        .badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
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

        /* Modals */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.6);
            backdrop-filter: blur(4px);
            align-items: center;
            justify-content: center;
        }

            .modal.show {
                display: flex;
            }

        .modal-content {
            background: white;
            border-radius: 15px;
            width: 90%;
            padding: 30px;
            max-height: 90vh;
            overflow-y: auto;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }

            .modal-header h2 {
                color: var(--primary-gold);
                margin: 0;
                font-size: 22px;
            }

        .close-btn {
            background: none;
            border: none;
            font-size: 28px;
            cursor: pointer;
            color: #64748b;
        }

        /* Form Layouts */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
            font-size: 13px;
        }

        .checkbox-group {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 10px;
            background: #f8fafc;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
        }

        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
        }

        .modal-footer {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        /* Toggle Switch */
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 26px;
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
            border-radius: 34px;
        }

            .toggle-slider:before {
                position: absolute;
                content: "";
                height: 20px;
                width: 20px;
                left: 3px;
                bottom: 3px;
                background-color: white;
                transition: .4s;
                border-radius: 50%;
            }

        input:checked + .toggle-slider {
            background-color: #10b981;
        }

            input:checked + .toggle-slider:before {
                transform: translateX(24px);
            }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }

            .header {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="container">
            <div class="header">
                <div style="display: flex; align-items: center; gap: 15px;">
                    <h1><i class="fas fa-users"></i>Manage Visitors</h1>
                </div>

                <div style="display: flex; align-items: center; gap: 15px; flex-wrap: wrap;">
                    <!-- User Info Section (Added for Session Logic) -->
                    <div class="user-info">
                        <div class="user-avatar">
                            <asp:Label ID="lblUserInitial" runat="server" Text="A"></asp:Label>
                        </div>
                        <div class="user-details">
                            <span class="user-name">
                                <asp:Label ID="lblUsername" runat="server" Text="Admin"></asp:Label></span>
                            <span class="user-role">Super Admin</span>
                        </div>
                    </div>

                    <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="~/SuperAdmin/Dashboard.aspx" CssClass="btn btn-info">
                        <i class="fas fa-arrow-left"></i> Dashboard
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
                    <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch" CssClass="search-box">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search visitors..."></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                    </asp:Panel>
                </div>

                <asp:UpdatePanel ID="upGrid" runat="server">
                    <ContentTemplate>
                        <div class="grid-container">
                            <asp:GridView ID="gvVisitors" runat="server" AutoGenerateColumns="False"
                                DataKeyNames="VisitorID" CssClass="grid" GridLines="None"
                                OnRowCommand="gvVisitors_RowCommand">
                                <Columns>
                                    <asp:TemplateField HeaderText="Sr.">
                                        <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="FullName" HeaderText="Name" />
                                    <asp:BoundField DataField="Email" HeaderText="Email" />
                                    <asp:BoundField DataField="CompanyName" HeaderText="Company" />
                                    <asp:TemplateField HeaderText="Ticket">
                                        <ItemTemplate><span class="badge" style="background: #e0f2fe; color: #0369a1;"><%# Eval("TicketType") %></span></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Approval">
                                        <ItemTemplate>
                                            <span class='badge badge-<%# Eval("ApprovalStatus") != null ? Eval("ApprovalStatus").ToString().ToLower() : "pending" %>'>
                                                <%# Eval("ApprovalStatus") ?? "Pending" %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <label class="toggle-switch">
                                                <input type="checkbox" <%# Convert.ToBoolean(Eval("IsActive")) ? "checked" : "" %> onchange="triggerToggle(<%# Eval("VisitorID") %>)" />
                                                <span class="toggle-slider"></span>
                                            </label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <div style="display: flex; gap: 5px;">
                                                <asp:Button ID="btnEdit" runat="server" Text="Edit" CommandName="EditVisitor" CommandArgument='<%# Eval("VisitorID") %>' CssClass="btn btn-edit" />
                                                <asp:Button ID="btnApprove" runat="server" Text="Decision" CommandName="ApproveVisitor" CommandArgument='<%# Eval("VisitorID") %>' CssClass="btn btn-warning" />
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div style="padding: 20px; text-align: center; color: #64748b;">No records found.</div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>

        <!-- 1. EDIT MODAL -->
        <div id="editModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Edit Visitor</h2>
                    <button type="button" class="close-btn" onclick="closeModal('editModal')">&times;</button>
                </div>
                <asp:HiddenField ID="hdnEditID" runat="server" />
                <asp:Button ID="btnLoadEdit" runat="server" OnClick="btnLoadEdit_Click" Style="display: none;" />

                <asp:UpdatePanel ID="upEdit" runat="server">
                    <ContentTemplate>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Ticket Type</label><asp:DropDownList ID="ddlEditTicket" runat="server" CssClass="form-control">
                                    <asp:ListItem>Free</asp:ListItem>
                                    <asp:ListItem>Paid</asp:ListItem>
                                    <asp:ListItem>Student</asp:ListItem>
                                </asp:DropDownList></div>
                            <div class="form-group">
                                <label>Full Name</label><asp:TextBox ID="txtEditName" runat="server" CssClass="form-control"></asp:TextBox></div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Email</label><asp:TextBox ID="txtEditEmail" runat="server" CssClass="form-control"></asp:TextBox></div>
                            <div class="form-group">
                                <label>Mobile</label><asp:TextBox ID="txtEditMobile" runat="server" CssClass="form-control"></asp:TextBox></div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Job Title</label><asp:TextBox ID="txtEditJob" runat="server" CssClass="form-control"></asp:TextBox></div>
                            <div class="form-group">
                                <label>Company</label><asp:TextBox ID="txtEditCompany" runat="server" CssClass="form-control"></asp:TextBox></div>
                        </div>
                        <div class="form-group">
                            <label>Nature of Business</label><asp:DropDownList ID="ddlEditNature" runat="server" CssClass="form-control">
                                <asp:ListItem>Automotive</asp:ListItem>
                                <asp:ListItem>Fleet Owners</asp:ListItem>
                                <asp:ListItem>Industrial Manufacturing</asp:ListItem>
                                <asp:ListItem>Oil & Gas</asp:ListItem>
                                <asp:ListItem>Others</asp:ListItem>
                            </asp:DropDownList></div>

                        <div class="form-group">
                            <label>Purpose</label>
                            <div class="checkbox-group">
                                <asp:CheckBoxList ID="chkEditPurpose" runat="server" RepeatLayout="Flow" CssClass="checkbox-item">
                                    <asp:ListItem>Explore New Products</asp:ListItem>
                                    <asp:ListItem>Meet Suppliers</asp:ListItem>
                                    <asp:ListItem>Networking</asp:ListItem>
                                    <asp:ListItem>Attend Sessions</asp:ListItem>
                                </asp:CheckBoxList>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Products</label>
                            <div class="checkbox-group">
                                <asp:CheckBoxList ID="chkEditProducts" runat="server" RepeatLayout="Flow" CssClass="checkbox-item">
                                    <asp:ListItem>Automotive Lubes</asp:ListItem>
                                    <asp:ListItem>Base Oils & Additives</asp:ListItem>
                                    <asp:ListItem>Greases</asp:ListItem>
                                    <asp:ListItem>Tribology & Testing</asp:ListItem>
                                    <asp:ListItem>Digital Solutions</asp:ListItem>
                                </asp:CheckBoxList>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Address</label><asp:TextBox ID="txtEditAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox></div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>City</label><asp:TextBox ID="txtEditCity" runat="server" CssClass="form-control"></asp:TextBox></div>
                            <div class="form-group">
                                <label>State</label><asp:TextBox ID="txtEditState" runat="server" CssClass="form-control"></asp:TextBox></div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Country</label><asp:TextBox ID="txtEditCountry" runat="server" CssClass="form-control"></asp:TextBox></div>
                            <div class="form-group">
                                <label>Pin</label><asp:TextBox ID="txtEditPin" runat="server" CssClass="form-control"></asp:TextBox></div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeModal('editModal')">Cancel</button>
                    <asp:Button ID="btnSaveEdit" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSaveEdit_Click" />
                </div>
            </div>
        </div>

        <!-- 2. APPROVAL MODAL -->
        <div id="approveModal" class="modal">
            <div class="modal-content" style="max-width: 500px;">
                <div class="modal-header">
                    <h2>Approval Decision</h2>
                    <button type="button" class="close-btn" onclick="closeModal('approveModal')">&times;</button>
                </div>
                <asp:HiddenField ID="hdnApproveID" runat="server" />
                <asp:Button ID="btnLoadApprove" runat="server" OnClick="btnLoadApprove_Click" Style="display: none;" />

                <asp:UpdatePanel ID="upApprove" runat="server">
                    <ContentTemplate>
                        <div class="form-group">
                            <label>Name</label><asp:TextBox ID="txtApproveName" runat="server" CssClass="form-control" ReadOnly="true" BackColor="#f8fafc"></asp:TextBox></div>
                        <div class="form-group">
                            <label>Company</label><asp:TextBox ID="txtApproveCompany" runat="server" CssClass="form-control" ReadOnly="true" BackColor="#f8fafc"></asp:TextBox></div>
                        <div class="form-group">
                            <label>Status</label><asp:DropDownList ID="ddlApproveStatus" runat="server" CssClass="form-control">
                                <asp:ListItem>Pending</asp:ListItem>
                                <asp:ListItem>Approved</asp:ListItem>
                                <asp:ListItem>Rejected</asp:ListItem>
                            </asp:DropDownList></div>
                        <div class="form-group">
                            <label>Remarks</label><asp:TextBox ID="txtApproveRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox></div>
                        <!-- NO PASSWORD FIELD VISIBLE HERE -->
                    </ContentTemplate>
                </asp:UpdatePanel>
                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeModal('approveModal')">Cancel</button>
                    <asp:Button ID="btnSaveApproval" runat="server" Text="Update" CssClass="btn btn-primary" OnClick="btnSaveApproval_Click" />
                </div>
            </div>
        </div>

        <asp:Button ID="btnToggleTrigger" runat="server" OnClick="btnToggleTrigger_Click" Style="display: none;" />
        <asp:HiddenField ID="hdnToggleID" runat="server" />

        <script>
            function closeModal(id) { document.getElementById(id).classList.remove('show'); }
            function showModal(id) { document.getElementById(id).classList.add('show'); }
            function triggerEdit(id) { document.getElementById('<%= hdnEditID.ClientID %>').value = id; document.getElementById('<%= btnLoadEdit.ClientID %>').click(); }
            function triggerApprove(id) { document.getElementById('<%= hdnApproveID.ClientID %>').value = id; document.getElementById('<%= btnLoadApprove.ClientID %>').click(); }
            function triggerToggle(id) { document.getElementById('<%= hdnToggleID.ClientID %>').value = id; document.getElementById('<%= btnToggleTrigger.ClientID %>').click(); }
        </script>
    </form>
</body>
</html>
