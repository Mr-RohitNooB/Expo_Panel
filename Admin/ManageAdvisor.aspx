<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageAdvisor.aspx.cs" Inherits="Expo_Panel.Admin.AdvisoryDashboard" %>

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
            max-width: 1200px;
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
            padding: 6px 12px;
            font-size: 13px;
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
            max-width: 500px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: modalSlideIn 0.3s ease-out;
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
            color: #94a3b8; /* Muted grey text */
            font-style: italic;
        }

        /* Override to keep action buttons looking normal */
        .inactive-row .action-buttons .btn {
            font-style: normal;
            opacity: 0.6;
        }

        /* Hide default ASP.NET button for toggle */
        .toggle-button-hidden {
            display: none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-users"></i> Manage Advisors</h1>
                <div>
                    Welcome, <asp:Label ID="lblUsername" runat="server" Text=""></asp:Label>
                    | Session Status: <asp:Label ID="lblSessionStatus" runat="server" Text=""></asp:Label>
                </div>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-danger" OnClick="btnLogout_Click" />
            </div>

            <div class="dashboard-card">
                <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>

                <div class="toolbar">
                    <div class="search-box">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by name, email, or mobile..."></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                    </div>
                    <button type="button" class="btn btn-success" onclick="openModal('add')">
                        <i class="fas fa-plus"></i> Add Advisor
                    </button>
                </div>

                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="grid-container">
                            <asp:GridView ID="gvAdvisors" runat="server" AutoGenerateColumns="False" 
                                OnRowCommand="gvAdvisors_RowCommand" DataKeyNames="AdvisorID"
                                CssClass="advisors-grid" GridLines="None" OnRowDataBound="gvAdvisors_RowDataBound">
                                <Columns>
                                    <asp:BoundField DataField="AdvisorID" HeaderText="ID" Visible="false" />
                                    <asp:BoundField DataField="Name" HeaderText="Name" />
                                    <asp:BoundField DataField="Email" HeaderText="Email" />
                                    <asp:BoundField DataField="Mobile" HeaderText="Mobile" />
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
                                            CommandArgument='<%# Eval("AdvisorID") %>' 
                                            CssClass="toggle-button-hidden" 
                                            ID="Button1" />
                                    </ItemTemplate>
                                </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <div class="action-buttons">
                                                <asp:Button runat="server" Text="Edit" CommandName="EditAdvisor" 
                                                    CommandArgument='<%# Eval("AdvisorID") %>' 
                                                    CssClass="btn btn-edit" />
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
                </asp:UpdatePanel>
            </div>
        </div>

        <!-- Add/Edit Modal -->
        <div id="advisorModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitle">Add Advisor</h2>
                    <button type="button" class="close-btn" onclick="closeModal()">&times;</button>
                </div>
                
                <asp:HiddenField ID="hdnAdvisorID" runat="server" Value="0" />
                <asp:HiddenField ID="hdnModalMode" runat="server" Value="add" />

                <div class="form-group">
                    <label for="<%=txtName.ClientID%>">Name <span style="color: red;">*</span></label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter advisor name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" 
                        ErrorMessage="Name is required" ForeColor="Red" Display="Dynamic" ValidationGroup="AdvisorValidation"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtEmail.ClientID%>">Email <span style="color: red;">*</span></label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter email address"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                        ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic" ValidationGroup="AdvisorValidation"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" 
                        ErrorMessage="Invalid email format" ForeColor="Red" Display="Dynamic" 
                        ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" ValidationGroup="AdvisorValidation"></asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtMobile.ClientID%>">Mobile</label>
                    <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" placeholder="Enter mobile number"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="<%=ddlStatus.ClientID%>">Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Active" Value="1" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeModal()">Cancel</button>
                    <asp:Button ID="btnSaveAdvisor" runat="server" Text="Save" CssClass="btn btn-primary" 
                        OnClick="btnSaveAdvisor_Click" ValidationGroup="AdvisorValidation" />
                </div>
            </div>
        </div>

        <script type="text/javascript">
            function toggleStatusSimple(checkbox) {
                // Find the closest table row
                var row = checkbox.closest('tr');

                if (!row) {
                    console.error('Row not found');
                    checkbox.checked = !checkbox.checked;
                    return;
                }

                // Find the hidden button within this row
                var btn = row.querySelector('.toggle-button-hidden');

                if (btn) {
                    // Trigger server-side button click
                    btn.click();
                } else {
                    console.error('Toggle button not found in row');
                    // Revert checkbox state if button not found
                    checkbox.checked = !checkbox.checked;
                    alert('Error: Could not find toggle button');
                }
            }


            function openModal(mode, id, name, email, mobile, isActive) {
                var modal = document.getElementById('advisorModal');
                var modalTitle = document.getElementById('modalTitle');
                var hdnMode = document.getElementById('<%=hdnModalMode.ClientID%>');
                var hdnID = document.getElementById('<%=hdnAdvisorID.ClientID%>');

                if (mode === 'add') {
                    modalTitle.innerText = 'Add Advisor';
                    hdnMode.value = 'add';
                    hdnID.value = '0';
                    document.getElementById('<%=txtName.ClientID%>').value = '';
                    document.getElementById('<%=txtEmail.ClientID%>').value = '';
                    document.getElementById('<%=txtMobile.ClientID%>').value = '';
                    document.getElementById('<%=ddlStatus.ClientID%>').selectedIndex = 0;
                } else if (mode === 'edit') {
                    modalTitle.innerText = 'Edit Advisor';
                    hdnMode.value = 'edit';
                    hdnID.value = id;
                    document.getElementById('<%=txtName.ClientID%>').value = name;
                    document.getElementById('<%=txtEmail.ClientID%>').value = email;
                    document.getElementById('<%=txtMobile.ClientID%>').value = mobile;
                    document.getElementById('<%=ddlStatus.ClientID%>').value = isActive;
                }

                modal.classList.add('show');
            }

            function closeModal() {
                var modal = document.getElementById('advisorModal');
                modal.classList.remove('show');
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                var modal = document.getElementById('advisorModal');
                if (event.target == modal) {
                    closeModal();
                }
            }
        </script>
    </form>
</body>
</html>