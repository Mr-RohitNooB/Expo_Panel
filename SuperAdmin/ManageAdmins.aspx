<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageAdmins.aspx.cs" Inherits="Expo_Panel.Admin.ManageAdmins" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Admins - Lubricant India Expo</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <!-- Bootstrap 5 & FontAwesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" />

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            color: #2d3748;
        }

        .header {
            background: linear-gradient(135deg, #c05621 0%, #ed8936 100%);
            color: white;
            padding: 15px 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .header h1 {
            font-size: 22px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header-actions {
            display: flex;
            gap: 10px;
        }

        .btn-header {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.1);
            padding: 8px 16px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s ease;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-header:hover { 
            background: rgba(255,255,255,0.3); 
            color: white; 
            transform: translateY(-1px);
        }
        
        .btn-logout-header {
            background: rgba(0,0,0,0.2); 
        }
        .btn-logout-header:hover {
            background: rgba(0,0,0,0.3);
        }

        .card-custom {
            border: none;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            background: white;
            overflow: hidden;
            margin-bottom: 25px;
        }

        .card-header-custom {
            background: #fff;
            padding: 20px 25px;
            border-bottom: 1px solid #edf2f7;
        }
        .card-header-custom h5 {
            margin: 0;
            color: #2d3748;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .form-label { font-weight: 600; font-size: 0.9rem; color: #4a5568; margin-bottom: 0.5rem; }
        
        /* --- UNIFIED INPUT GROUP STYLING --- */
        .input-group-custom {
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            background-color: #f8fafc;
            transition: all 0.2s;
            overflow: hidden;
            display: flex;
            align-items: center;
        }

        .input-group-custom:focus-within {
            border-color: #ed8936;
            background-color: #fff;
            box-shadow: 0 0 0 4px rgba(237, 137, 54, 0.15);
        }
        
        .input-group-custom:focus-within i {
            color: #ed8936 !important;
            transition: color 0.2s;
        }

        .input-group-custom .input-group-text {
            background-color: transparent;
            border: none;
            color: #718096;
            padding-left: 15px;
            padding-right: 10px;
        }
        
        .input-group-custom .form-control {
            border: none;
            background-color: transparent;
            box-shadow: none !important;
            padding: 12px 5px;
        }
        
        .input-group-custom .btn-toggle-password {
            background: transparent;
            border: none;
            color: #718096;
            padding: 0 15px;
            z-index: 10;
        }
        .input-group-custom .btn-toggle-password:hover {
            color: #ed8936;
        }

        .form-select {
            border-radius: 10px;
            padding: 12px 15px;
            border: 1px solid #e2e8f0;
            font-size: 0.95rem;
            background-color: #f8fafc;
            transition: all 0.2s;
        }
        .form-select:focus {
            border-color: #ed8936;
            background-color: #fff;
            box-shadow: 0 0 0 4px rgba(237, 137, 54, 0.15);
            outline: none;
        }
        
        /* Autofill Fix */
        input:-webkit-autofill,
        input:-webkit-autofill:hover, 
        input:-webkit-autofill:focus, 
        input:-webkit-autofill:active {
            -webkit-box-shadow: 0 0 0 30px #f8fafc inset !important;
            -webkit-text-fill-color: #2d3748 !important;
            transition: background-color 5000s ease-in-out 0s;
        }
        
        .input-group-custom:focus-within input:-webkit-autofill {
            -webkit-box-shadow: 0 0 0 30px #ffffff inset !important;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
            border: none;
            color: white;
            padding: 12px;
            width: 100%;
            border-radius: 10px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s;
        }
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(237, 137, 54, 0.3);
            color: white;
        }
        
        .btn-cancel {
            background: #e2e8f0;
            color: #4a5568;
            border: none;
            padding: 12px;
            width: 100%;
            border-radius: 10px;
            font-weight: 600;
            margin-top: 10px;
            transition: all 0.3s;
        }
        .btn-cancel:hover {
            background: #cbd5e0;
            color: #2d3748;
        }

        .table-custom { margin-bottom: 0; }
        .table-custom thead th {
            background-color: #f8fafc;
            color: #718096;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            padding: 15px 20px;
            border-bottom: 2px solid #edf2f7;
        }
        .table-custom tbody td {
            padding: 15px 20px;
            vertical-align: middle;
            border-bottom: 1px solid #edf2f7;
            color: #4a5568;
            font-size: 0.95rem;
        }
        
        .badge-role {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.3px;
        }
        .role-super { background-color: #ebf8ff; color: #3182ce; }
        .role-admin { background-color: #fffaf0; color: #dd6b20; }
        
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-weight: 600;
            font-size: 0.85rem;
        }
        .status-active { color: #38a169; }
        .status-inactive { color: #e53e3e; }
        
        .btn-action {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #718096;
            background: #f7fafc;
            transition: all 0.2s;
            text-decoration: none;
            cursor: pointer;
            border: none;
        }
        .btn-action:hover {
            background: #edf2f7;
            color: #4a5568;
            transform: scale(1.1);
        }
        /* Delete Button Hover */
        .btn-action.delete:hover {
            background: #fff5f5;
            color: #e53e3e !important;
        }
        .btn-action.delete i {
            color: #fc8181;
        }
        .btn-action.delete:hover i {
            color: #e53e3e;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" autocomplete="off">
        <asp:HiddenField ID="hfAdminID" runat="server" Value="0" />

        <div class="header">
            <h1><i class="fas fa-user-shield"></i> Manage Administrators</h1>
            <div class="header-actions">
                <a href="Dashboard.aspx" class="btn-header"><i class="fas fa-arrow-left"></i> Back</a>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-header btn-logout-header" OnClick="btnLogout_Click" CausesValidation="false" />
            </div>
        </div>

        <div class="container mt-4">
            <div class="row">
                
                <!-- LEFT: FORM -->
                <div class="col-lg-4">
                    <div class="card card-custom sticky-top" style="top: 20px; z-index: 1;">
                        <div class="card-header-custom">
                            <h5 id="formHeader" runat="server"><i class="fas fa-user-plus text-warning me-2"></i>Add New Admin</h5>
                        </div>
                        <div class="card-body p-4">
                            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert mb-4">
                                <asp:Label ID="lblMessage" runat="server"></asp:Label>
                            </asp:Panel>

                            <div class="mb-3">
                                <label class="form-label">Username</label>
                                <div class="input-group-custom">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="e.g. john_admin" autocomplete="new-password"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvUser" runat="server" ControlToValidate="txtUsername" 
                                    ErrorMessage="Username is required" CssClass="text-danger small mt-1" Display="Dynamic" ValidationGroup="SaveAdmin" />
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <div class="input-group-custom">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="******" autocomplete="new-password"></asp:TextBox>
                                    <button class="btn-toggle-password" type="button" id="btnTogglePass" onclick="togglePassword()">
                                        <i class="fas fa-eye" id="iconEye"></i>
                                    </button>
                                </div>
                                <asp:Label ID="lblPasswordHint" runat="server" CssClass="text-muted small mt-1 d-block" Visible="false">
                                    <i class="fas fa-info-circle me-1"></i>Leave blank to keep current password.
                                </asp:Label>
                                <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPassword" 
                                    ErrorMessage="Password is required" CssClass="text-danger small mt-1" Display="Dynamic" ValidationGroup="SaveAdmin" />
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Role</label>
                                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="Admin" Selected="True">Admin (Default)</asp:ListItem>
                                    <asp:ListItem Value="SuperAdmin">Super Admin</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="mb-4">
                                <div class="form-check form-switch p-0">
                                    <div class="d-flex align-items-center gap-2">
                                        <input type="checkbox" class="form-check-input m-0" id="chkIsActive" runat="server" checked="checked" style="width: 2.5em; height: 1.25em; cursor:pointer;" />
                                        <label class="form-check-label cursor-pointer" for="chkIsActive">Account Active</label>
                                    </div>
                                </div>
                            </div>

                            <asp:Button ID="btnSave" runat="server" Text="Create Account" 
                                CssClass="btn btn-primary-custom" OnClick="btnSave_Click" ValidationGroup="SaveAdmin" />
                            
                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                                CssClass="btn btn-cancel" OnClick="btnCancel_Click" Visible="false" CausesValidation="false" />
                        </div>
                    </div>
                </div>

                <!-- RIGHT: LIST -->
                <div class="col-lg-8">
                    <div class="card card-custom">
                        <div class="card-header-custom d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-users text-muted me-2"></i>Existing Administrators</h5>
                            <span class="badge bg-light text-dark border">
                                Total: <asp:Label ID="lblTotalAdmins" runat="server" Text="0"></asp:Label>
                            </span>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <asp:GridView ID="gvAdmins" runat="server" CssClass="table table-custom table-hover mb-0" 
                                    AutoGenerateColumns="False" GridLines="None" EmptyDataText="No admins found."
                                    OnRowCommand="gvAdmins_RowCommand" DataKeyNames="AdminID">
                                    <Columns>
                                        <asp:BoundField DataField="Username" HeaderText="Username" HeaderStyle-Width="25%">
                                            <ItemStyle CssClass="fw-semibold" />
                                        </asp:BoundField>
                                        
                                        <asp:TemplateField HeaderText="Role">
                                            <ItemTemplate>
                                                <span class='badge-role <%# Eval("Role").ToString() == "SuperAdmin" ? "role-super" : "role-admin" %>'>
                                                    <%# Eval("Role") %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Status">
                                            <ItemTemplate>
                                                <span class='status-badge <%# Convert.ToBoolean(Eval("IsActive")) ? "status-active" : "status-inactive" %>'>
                                                    <i class='fas <%# Convert.ToBoolean(Eval("IsActive")) ? "fa-circle" : "fa-circle" %> fa-xs'></i>
                                                    <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:BoundField DataField="CreatedDate" HeaderText="Created On" DataFormatString="{0:dd MMM yyyy}" />

                                        <asp:TemplateField HeaderText="Action" ItemStyle-Width="100px">
                                            <ItemTemplate>
                                                <asp:HiddenField ID="hfRowID" runat="server" Value='<%# Eval("AdminID") %>' />
                                                <asp:HiddenField ID="hfRowUser" runat="server" Value='<%# Eval("Username") %>' />
                                                <asp:HiddenField ID="hfRowRole" runat="server" Value='<%# Eval("Role") %>' />
                                                <asp:HiddenField ID="hfRowActive" runat="server" Value='<%# Eval("IsActive") %>' />

                                                <div class="d-flex gap-2">
                                                    <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn-action edit" 
                                                        CommandName="EditAdmin" CommandArgument="<%# Container.DataItemIndex %>"
                                                        ToolTip="Edit User">
                                                        <i class="fas fa-pencil-alt"></i>
                                                    </asp:LinkButton>

                                                    <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn-action delete" 
                                                        CommandName="DeleteAdmin" CommandArgument='<%# Eval("AdminID") %>'
                                                        OnClientClick="return confirm('Are you sure you want to permanently delete this admin?');"
                                                        ToolTip="Delete User">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </asp:LinkButton>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
        function togglePassword() {
            var input = document.getElementById('<%= txtPassword.ClientID %>');
            var icon = document.getElementById('iconEye');

            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                input.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }
    </script>
</body>
</html>