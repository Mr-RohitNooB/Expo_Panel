<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegisterAdvisor.aspx.cs" Inherits="Expo_Panel.RegisterAdvisor" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register as Advisor - Expo Panel</title>
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
        /* Same styles as RegisterAdvisor.aspx */
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
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .registration-container {
            width: 900px;
/*            width: 100%;*/
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

            .header h1 {
                color: #4f46e5;
                font-size: 28px;
                font-weight: 600;
                margin-bottom: 10px;
            }

            .header p {
                color: #64748b;
                font-size: 16px;
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
            .form-group select {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.3s;
            }

                .form-group input:focus,
                .form-group select:focus {
                    outline: none;
                    border-color: #667eea;
                }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 16px;
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

        .btn-secondary {
            background: #e2e8f0;
            color: #475569;
        }

            .btn-secondary:hover {
                background: #cbd5e1;
            }

        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
        }

        .back-link {
            color: #4f46e5;
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 5px;
        }

            .back-link:hover {
                text-decoration: underline;
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

        .role-selector {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 30px;
        }

        .role-option {
            padding: 15px 25px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            background: white;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
        }

            .role-option:hover {
                border-color: #cbd5e1;
            }

            .role-option.active {
                border-color: #4f46e5;
                background: #f0f4ff;
            }

            .role-option i {
                font-size: 24px;
                color: #4f46e5;
                margin-bottom: 8px;
                display: block;
            }

        .required {
            color: #ef4444;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }

            .form-footer {
                flex-direction: column;
                gap: 15px;
            }

            .role-selector {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="registration-container">
            <div class="header">
                <h1><i class="fas fa-user-tie"></i>Register as Advisor</h1>
                <p>Join our panel of expert advisors for the expo</p>
            </div>

            <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>

            <div class="form-row">
                <div class="form-group">
                    <label for="<%=txtName.ClientID%>">Full Name <span class="required">*</span></label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter your full name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                        ErrorMessage="Name is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtEmail.ClientID%>">Email Address <span class="required">*</span></label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter your email"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Invalid email format" ForeColor="Red" Display="Dynamic"
                        ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" ValidationGroup="RegistrationValidation"></asp:RegularExpressionValidator>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="<%=txtMobile.ClientID%>">Mobile Number</label>
                    <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" placeholder="Enter your mobile number"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="<%=txtDesignation.ClientID%>">Designation <span class="required">*</span></label>
                    <asp:TextBox ID="txtDesignation" runat="server" CssClass="form-control" placeholder="Enter your designation"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDesignation" runat="server" ControlToValidate="txtDesignation"
                        ErrorMessage="Designation is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-row">

                <div class="form-group">
                    <label for="<%=txtCompany.ClientID%>">Company/Organization <span class="required">*</span></label>
                    <asp:TextBox ID="txtCompany" runat="server" CssClass="form-control" placeholder="Enter your company name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCompany" runat="server" ControlToValidate="txtCompany"
                        ErrorMessage="Company is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>

            </div>

            <div class="form-footer">
                <a href="Default.aspx" class="back-link">
                    <i class="fas fa-arrow-left"></i>Back to Home
                </a>
                <asp:Button ID="btnRegister" runat="server" Text="Register as Advisor" CssClass="btn btn-primary"
                    OnClick="btnRegister_Click" ValidationGroup="RegistrationValidation" />
            </div>
        </div>
    </form>
</body>
</html>
