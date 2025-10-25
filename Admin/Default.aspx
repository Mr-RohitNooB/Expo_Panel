<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Expo_Panel.Admin.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Login - Expo Panel</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ffffff 0%, #c7c7c7 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            width: 600px;
            /*max-width: 420px;*/
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-header {
            background: linear-gradient(135deg, #4a5568 0%, #2d3748 100%);
            padding: 40px 30px;
            text-align: center;
            color: white;
        }

        .login-header h1 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        .login-header p {
            font-size: 14px;
            color: #cbd5e0;
            font-weight: 400;
        }

        .login-body {
            padding: 40px 30px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #4a5568;
            font-size: 14px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f7fafc;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .alert-error {
            background: #fff5f5;
            color: #c53030;
            border-left: 4px solid #fc8181;
        }

        .login-footer {
            text-align: center;
            padding: 20px 30px 30px;
            color: #a0aec0;
            font-size: 13px;
        }

        .error-message {
            color: #c53030;
            font-size: 14px;
            margin-top: 8px;
            font-weight: 500;
        }

        .password-container {
            position: relative;
        }

        .toggle-password {
            position: absolute;
            top: 50%;
            right: 16px;
            transform: translateY(-50%);
            cursor: pointer;
            color: #a0aec0;
            font-size: 14px;
            font-weight: 500;
        }

        @media (max-width: 480px) {
            .login-container {
                border-radius: 0;
            }

            .login-header {
                padding: 30px 20px;
            }

            .login-body {
                padding: 30px 20px;
            }

            .login-header h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="login-header">
                <h1>Admin Panel</h1>
                <p>Expo Panel Management System</p>
            </div>

            <div class="login-body">
                <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-error" Visible="false">
                    <asp:Label ID="lblError" runat="server"></asp:Label>
                </asp:Panel>

                <div class="form-group">
                    <label for="txtUsername">Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" 
                                 placeholder="Enter your username" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                                                ControlToValidate="txtUsername" 
                                                ErrorMessage="Username is required" 
                                                CssClass="error-message"
                                                Display="Dynamic"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="txtPassword">Password</label>
                    <div class="password-container">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" 
                                     CssClass="form-control" placeholder="Enter your password" 
                                     MaxLength="255"></asp:TextBox>
                        <span class="toggle-password" onclick="togglePasswordVisibility()">Show</span>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                                                ControlToValidate="txtPassword" 
                                                ErrorMessage="Password is required" 
                                                CssClass="error-message"
                                                Display="Dynamic"></asp:RequiredFieldValidator>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Sign In" 
                            CssClass="btn-login" OnClick="btnLogin_Click" />
            </div>

            <div class="login-footer">
                © 2025 Expo Panel. All rights reserved.
            </div>
        </div>
    </form>

    <script>
        function togglePasswordVisibility() {
            var passwordInput = document.getElementById('<%= txtPassword.ClientID %>');
            var togglePassword = document.querySelector('.toggle-password');

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                togglePassword.textContent = 'Hide';
            } else {
                passwordInput.type = 'password';
                togglePassword.textContent = 'Show';
            }
        }
    </script>
</body>
</html>