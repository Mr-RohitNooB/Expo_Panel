<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Expo_Panel.Admin.AdminLogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Team Admin Login - Lubricant India Expo</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Team Login for Lubricant India Expo Admin Panel" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" media="(prefers-color-scheme: light)" />
    <link rel="icon" type="image/png" sizes="16x16" href="/Images/favicon_io_Lubricant_India_Expo/favicon-16x16.png" media="(prefers-color-scheme: light)" />
    <link rel="apple-touch-icon" href="/Images/favicon_io_Lubricant_India_Expo/apple-touch-icon.png" media="(prefers-color-scheme: light)" />
    <link rel="shortcut icon" href="/Images/favicon_io_Lubricant_India_Expo/favicon.ico" media="(prefers-color-scheme: light)" />

    <style>
        /* ============================================
           REUSED STYLES FROM DEFAULT.ASPX
           ============================================ */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { scroll-behavior: smooth; height: 100%; background: #667eea; }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            /* CHANGED GRADIENT TO ORANGE/AMBER TO DISTINGUISH TEAM LOGIN */
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
            background-attachment: fixed;
            background-repeat: no-repeat;
            background-size: 100% 100%;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 16px;
            position: relative;
            overflow-x: hidden;
        }

        .login-wrapper {
            position: relative;
            width: 100%;
            max-width: 1200px;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            border-radius: 25px;
        }

        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            width: 100%;
            max-width: 480px;
            animation: slideUp 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
            backdrop-filter: blur(10px);
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-header {
            /* MATCHING HEADER GRADIENT */
            background: linear-gradient(135deg, #ed8936 0%, #c05621 100%);
            padding: 50px 30px;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .login-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(20px); }
        }

        .header-brand h1 {
            font-size: 32px;
            font-weight: 700;
            letter-spacing: -0.5px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 15px;
        }

        .header-brand p {
            font-size: 15px;
            color: rgba(255, 255, 255, 0.95);
            font-weight: 500;
            margin: 8px 0;
        }

        .header-brand .tagline {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.8);
            font-style: italic;
            margin-top: 5px;
            margin-bottom: -30px;
        }

        .header-brand img {
    max-width: 301px;
    width: 104%;
    height: auto;
    display: block;
    margin: 15px auto;
    object-fit: contain;
    margin-top: -14px;
    margin-bottom: 0px;
}


        .login-body { padding: 45px 30px; }
        .form-group { margin-bottom: 24px; }
        
        .form-label {
            display: block;
            margin-bottom: 10px;
            color: #2d3748;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .label-icon { font-size: 16px; }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: #f7fafc;
            color: #2d3748;
        }

        .form-control:focus {
            outline: none;
            border-color: #ed8936; /* Orange focus */
            background: white;
            box-shadow: 0 0 0 4px rgba(237, 137, 54, 0.15);
            transform: translateY(-2px);
        }

        .password-container { position: relative; display: flex; align-items: center; }

        .toggle-password-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 18px;
            padding: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            border-radius: 6px;
        }

        .btn-login {
            width: 100%;
            padding: 14px;
            /* Orange Button */
            background: linear-gradient(135deg, #ed8936 0%, #c05621 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            margin-top: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(237, 137, 54, 0.3);
            position: relative;
            overflow: hidden;
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(237, 137, 54, 0.4);
        }

        .alert {
            padding: 16px;
            border-radius: 10px;
            margin-bottom: 24px;
            font-size: 14px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
            animation: slideDown 0.3s ease-out;
        }

        .alert-error {
            background: #fff5f5;
            color: #c53030;
            border-left: 4px solid #fc8181;
        }

        .login-footer {
            background: #f7fafc;
            padding: 25px 30px;
            text-align: center;
            border-top: 1px solid #e2e8f0;
        }

        .login-footer p {
            color: #718096;
            font-size: 12px;
            line-height: 1.6;
            margin: 4px 0;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .login-container { border-radius: 12px; }
            .login-header { padding: 20px 16px; }
            .header-brand h1 { font-size: 20px; }
            .login-body { padding: 20px 16px; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-wrapper">
            <div class="login-container">
                <div class="login-header">
                    <div class="header-brand">
                        <h1>Team Admin Login</h1>
                        <img src="/Images/Expo logo3.png" alt="Logo" />
                        
                    </div>
                </div>

                <div class="login-body">
                    <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-error" Visible="false">
                        <div class="alert-icon"><i class="fas fa-exclamation-triangle"></i></div>
                        <asp:Label ID="lblError" runat="server"></asp:Label>
                    </asp:Panel>

                    <div class="form-group">
                        <label for="txtUsername" class="form-label">
                            <span class="label-icon"><i class="fas fa-user"></i></span>
                            Username
                        </label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"
                            placeholder="Enter team username" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                            ControlToValidate="txtUsername"
                            ErrorMessage="Username is required"
                            CssClass="error-message"
                            Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="txtPassword" class="form-label">
                            <span class="label-icon"><i class="fas fa-lock"></i></span>
                            Password
                        </label>
                        <div class="password-container">
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                                CssClass="form-control" placeholder="Enter password"
                                MaxLength="255"></asp:TextBox>
                            <button type="button" class="toggle-password-btn" onclick="togglePasswordVisibility(event)">
                                <i class="fas fa-eye toggle-icon"></i>
                            </button>
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
                   <p>&copy; 2025 Lubricant India Expo and Summit. All rights reserved.</p>
                    <p class="footer-text">Restricted Team Access</p>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        function togglePasswordVisibility(event) {
            event.preventDefault();
            var passwordInput = document.getElementById('<%= txtPassword.ClientID %>');
            var toggleBtn = event.currentTarget;
            var toggleIcon = toggleBtn.querySelector('.toggle-icon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.className = 'fas fa-eye-slash toggle-icon';
            } else {
                passwordInput.type = 'password';
                toggleIcon.className = 'fas fa-eye toggle-icon';
            }
        }
        window.addEventListener('load', function () {
            document.getElementById('<%= txtUsername.ClientID %>').focus();
        });
    </script>
</body>
</html>