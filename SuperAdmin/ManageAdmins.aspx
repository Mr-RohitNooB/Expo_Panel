<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageAdmins.aspx.cs" Inherits="Expo_Panel.Admin.ManageAdmins" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Admins - Lubricant India Expo</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <!-- Bootstrap & Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" />

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            color: #2d3748;
        }

        /* Matches your Dashboard Header */
        .header {
            background: linear-gradient(135deg, #c05621 0%, #ed8936 100%);
            color: white;
            padding: 15px 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .header h1 {
            font-size: 20px;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn-back {
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            transition: 0.3s;
        }
        .btn-back:hover { background: rgba(255,255,255,0.3); color: white; }

        /* Card Styling */
        .card-custom {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            background: white;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .card-header-custom {
            background: #fff;
            padding: 20px;
            border-bottom: 1px solid #e2e8f0;
        }
        .card-header-custom h5 {
            margin: 0;
            color: #2d3748;
            font-weight: 700;
        }

        .form-label { font-weight: 600; font-size: 0.9rem; color: #4a5568; }
        .form-control, .form-select {
            border-radius: 8px;
            padding: 10px 15px;
            border: 1px solid #e2e8f0;
        }
        .form-control:focus, .form-select:focus {
            border-color: #ed8936;
            box-shadow: 0 0 0 3px rgba(237, 137, 54, 0.1);
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
            border: none;
            color: white;
            padding: 12px;
            width: 100%;
            border-radius: 8px;
            font-weight: 600;
            transition: 0.3s;
        }
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(237, 137, 54, 0.3);
            color: white;
        }

        /* GridView Styling */
        .table-custom th {
            background-color: #f7fafc;
            color: #4a5568;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            border-top: none;
        }
        .badge-role {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .role-super { background-color: #ebf8ff; color: #2b6cb0; }
        .role-admin { background-color: #fffaf0; color: #ed8936; }
        
        .status-active { color: #48bb78; font-weight: 600; }
        .status-inactive { color: #f56565; font-weight: 600; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <div class="header">
            <h1><i class="fas fa-users-cog"></i> Manage Administrators</h1>
            <a href="Dashboard.aspx" class="btn-back"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
        </div>

        <div class="container mt-4">
            <div class="row">
                <!-- ADD ADMIN FORM -->
                <div class="col-lg-4">
                    <div class="card card-custom">
                        <div class="card-header-custom">
                            <h5><i class="fas fa-user-plus text-warning me-2"></i>Add New Admin</h5>
                        </div>
                        <div class="card-body p-4">
                            <!-- Feedback Messages -->
                            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert mb-3">
                                <asp:Label ID="lblMessage" runat="server"></asp:Label>
                            </asp:Panel>

                            <div class="mb-3">
                                <label class="form-label">Username</label>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="e.g., john_admin"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvUser" runat="server" ControlToValidate="txtUsername" 
                                    ErrorMessage="Username is required" CssClass="text-danger small" Display="Dynamic" ValidationGroup="AddAdmin" />
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="******"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPassword" 
                                    ErrorMessage="Password is required" CssClass="text-danger small" Display="Dynamic" ValidationGroup="AddAdmin" />
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Role</label>
                                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="Admin" Selected="True">Admin (Default)</asp:ListItem>
                                    <asp:ListItem Value="SuperAdmin">Super Admin</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="mb-4 form-check">
                                <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" CssClass="form-check-input" />
                                <label class="form-check-label" for="chkIsActive">Account is Active</label>
                            </div>

                            <asp:Button ID="btnAddAdmin" runat="server" Text="Create Account" 
                                CssClass="btn btn-primary-custom" OnClick="btnAddAdmin_Click" ValidationGroup="AddAdmin" />
                        </div>
                    </div>
                </div>

                <!-- LIST EXISTING ADMINS -->
                <div class="col-lg-8">
                    <div class="card card-custom">
                        <div class="card-header-custom d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-list text-muted me-2"></i>Existing Administrators</h5>
                            <span class="badge bg-light text-dark border">
                                Total: <asp:Label ID="lblTotalAdmins" runat="server" Text="0"></asp:Label>
                            </span>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <asp:GridView ID="gvAdmins" runat="server" CssClass="table table-hover table-custom mb-0" 
                                    AutoGenerateColumns="False" GridLines="None" EmptyDataText="No admins found.">
                                    <Columns>
                                        <asp:BoundField DataField="AdminID" HeaderText="ID">
                                            <ItemStyle CssClass="ps-4 text-muted" Width="50px" />
                                            <HeaderStyle CssClass="ps-4" />
                                        </asp:BoundField>
                                        
                                        <asp:BoundField DataField="Username" HeaderText="Username" HeaderStyle-Width="30%" />
                                        
                                        <asp:TemplateField HeaderText="Role">
                                            <ItemTemplate>
                                                <span class='badge-role <%# Eval("Role").ToString() == "SuperAdmin" ? "role-super" : "role-admin" %>'>
                                                    <%# Eval("Role") %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Status">
                                            <ItemTemplate>
                                                <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "status-active" : "status-inactive" %>'>
                                                    <i class='fas <%# Convert.ToBoolean(Eval("IsActive")) ? "fa-check-circle" : "fa-times-circle" %> me-1'></i>
                                                    <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:BoundField DataField="CreatedDate" HeaderText="Created On" DataFormatString="{0:dd MMM yyyy}" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>