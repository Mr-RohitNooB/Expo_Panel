<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdvisoryLogin.aspx.cs" Inherits="Expo_Panel.Admin.AdvisoryLogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Advisory Panel Login - Lubricant India Expo</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Login to Lubricant India Expo and Smart Lubricants Summit 2026 Advisory Panel" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" />
    <link rel="icon" type="image/png" sizes="16x16" href="/Images/favicon_io_Lubricant_India_Expo/favicon-16x16.png" />

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
            height: 100%;
            background: #667eea;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            from {
                opacity: 0;
                transform: translateY(40px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            0%, 100% {
                transform: translateY(0px);
            }

            50% {
                transform: translateY(20px);
            }
        }

        .header-brand h1 {
            font-size: 32px;
            font-weight: 700;
            letter-spacing: -0.5px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 15px; /* Changed from -50px */
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


        .header-brand p {
            font-size: 15px;
            color: rgba(255, 255, 255, 0.95);
            font-weight: 500;
            margin: 8px 0; /* Changed from 4px 0 */
        }

        .header-brand .tagline {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.8);
            font-style: italic;
            margin-top: 5px;
            margin-bottom: -30px;
        }

        .login-body {
            padding: 45px 30px;
        }

        .form-group {
            margin-bottom: 24px;
        }

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

        .label-icon {
            font-size: 16px;
        }

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
                border-color: #667eea;
                background: white;
                box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.15);
                transform: translateY(-2px);
            }

            .form-control::placeholder {
                color: #a0aec0;
            }

        .password-container {
            position: relative;
            display: flex;
            align-items: center;
        }

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

            .toggle-password-btn:hover {
                background: rgba(102, 126, 234, 0.1);
            }

            .toggle-password-btn:active {
                transform: translateY(-50%) scale(0.95);
            }

        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            position: relative;
            overflow: hidden;
        }

            .btn-login::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: rgba(255, 255, 255, 0.2);
                transition: left 0.3s ease;
            }

            .btn-login:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            }

                .btn-login:hover::before {
                    left: 100%;
                }

            .btn-login:active {
                transform: translateY(-1px);
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

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-error {
            background: #fff5f5;
            color: #c53030;
            border-left: 4px solid #fc8181;
        }

        .alert-icon {
            font-size: 20px;
            flex-shrink: 0;
            margin-top: 2px;
        }

        .error-message {
            color: #c53030;
            font-size: 13px;
            margin-top: 6px;
            font-weight: 500;
            display: block;
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

        .footer-text {
            color: #a0aec0;
            font-style: italic;
            font-size: 11px;
        }

        .decoration {
            position: absolute;
            border-radius: 50%;
            opacity: 0.1;
            pointer-events: none;
        }

        .decoration-top {
            width: 300px;
            height: 300px;
            background: white;
            top: -100px;
            left: -80px;
            animation: float 8s ease-in-out infinite;
        }

        .decoration-bottom {
            width: 250px;
            height: 250px;
            background: white;
            bottom: -80px;
            right: -60px;
            animation: float 6s ease-in-out infinite reverse;
        }

        /* ============================================
   Responsive Design
   ============================================ */

        /* Tablets (768px and below) */
        @media (max-width: 768px) {
            body {
                padding: 12px;
            }

            .login-container {
                border-radius: 16px;
                max-width: 100%;
            }

            .login-header {
                padding: 30px 20px;
            }

            .header-brand h1 {
                font-size: 24px;
                margin-bottom: 10px;
            }

            .header-brand p {
                font-size: 13px;
                margin: 6px 0;
            }

            .header-brand .tagline {
                font-size: 11px;
                margin-top: 6px;
            }

            .login-body {
                padding: 30px 20px;
            }

            .login-footer {
                padding: 20px;
            }
        }

        /* Mobile (480px and below) */
        @media (max-width: 480px) {
            body {
                padding: 8px;
            }

            .login-container {
                border-radius: 12px;
                max-width: 100%;
                box-shadow: 0 15px 50px rgba(0, 0, 0, 0.2);
            }

            .login-header {
                padding: 20px 16px;
            }

            .header-brand h1 {
                font-size: 20px;
                margin-bottom: 8px;
            }

            .header-brand img {
                max-width: 250px;
                width: 100%;
                height: auto;
                display: block;
                margin: 15px auto;
                object-fit: contain;
            }

            .header-brand p {
                font-size: 12px;
                margin: 4px 0;
            }

            .header-brand .tagline {
                font-size: 10px;
                margin-top: 5px;
            }

            .login-body {
                padding: 20px 16px;
            }

            .form-group {
                margin-bottom: 18px;
            }

            .form-label {
                font-size: 12px;
            }

            .form-control {
                padding: 11px 12px;
                font-size: 14px;
            }

            .btn-login {
                padding: 11px;
                font-size: 14px;
            }

            .login-footer {
                padding: 16px;
            }

                .login-footer p {
                    font-size: 10px;
                }

            .decoration {
                display: none;
            }

            .alert {
                padding: 12px;
                font-size: 12px;
            }
        }

        /* Small Mobile (360px and below) */
        @media (max-width: 360px) {
            .login-header {
                padding: 18px 12px;
            }

            .header-brand h1 {
                font-size: 18px;
                margin-bottom: 6px;
            }

            .header-brand img {
                max-width: 60%;
                max-height: 40px;
                margin: 6px auto;
            }

            .header-brand p {
                font-size: 11px;
                margin: 3px 0;
            }

            .header-brand .tagline {
                font-size: 9px;
                margin-top: 4px;
            }

            .login-body {
                padding: 18px 12px;
            }

            .login-footer {
                padding: 14px 12px;
            }

            .form-control {
                padding: 10px 12px;
                font-size: 13px;
            }

            .form-label {
                font-size: 11px;
            }

            .btn-login {
                padding: 10px;
                font-size: 13px;
            }
        }

        /* Print Styles */
        @media print {
            body {
                background: white;
            }

            .login-wrapper,
            .login-container {
                box-shadow: none;
            }
        }

        .login-footer p a {
            color: #764ba2;
            font-weight: 600;
            text-decoration: none;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div class="login-wrapper">
            <div class="login-container">
                <div class="login-header">
                    <div class="header-brand">
                        <h1>Advisory Login Panel</h1>
                        <img src="../Images/Expo_logo_white.png" />
                        
                    </div>
                </div>

                <div class="login-body">
                    <asp:Literal ID="litMessage" runat="server" />

                    <asp:Panel ID="pnlLogin" runat="server">
                        <div class="form-group">
                            <label for="txtUsername" class="form-label">
                                <span class="label-icon"><i class="fas fa-user"></i></span>Email
                            </label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"
                                placeholder="Enter your email" MaxLength="100" TextMode="Email"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                                ControlToValidate="txtUsername"
                                ErrorMessage="Email is required"
                                CssClass="error-message"
                                Display="Dynamic"
                                ValidationGroup="LoginGroup"></asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label for="txtPassword" class="form-label">
                                <span class="label-icon"><i class="fas fa-lock"></i></span>Password
                            </label>
                            <div class="password-container">
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                                    CssClass="form-control" placeholder="Enter your password"
                                    MaxLength="255"></asp:TextBox>
                                <button type="button" class="toggle-password-btn" onclick="togglePasswordVisibility(event)">
                                    <i class="fas fa-eye toggle-icon"></i>
                                </button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                ControlToValidate="txtPassword"
                                ErrorMessage="Password is required"
                                CssClass="error-message"
                                Display="Dynamic"
                                ValidationGroup="LoginGroup"></asp:RequiredFieldValidator>
                        </div>

                        <div style="text-align: right; margin-bottom: 15px;">
                            <asp:LinkButton ID="lnkForgot" runat="server" OnClick="lnkForgot_Click" CausesValidation="false"
                                Style="color: #667eea; font-size: 13px; font-weight: 600; text-decoration: none;">
                Forgot Password?
                            </asp:LinkButton>
                        </div>

                        <asp:Button ID="btnLogin" runat="server" Text="Sign In"
                            CssClass="btn-login" OnClick="btnLogin_Click" ValidationGroup="LoginGroup" />
                    </asp:Panel>

                    <asp:Panel ID="pnlVerify" runat="server" Visible="false">
                        <div class="form-group">
                            <label class="form-label">Registered Email</label>
                            <asp:TextBox ID="txtResetEmail" runat="server" CssClass="form-control" placeholder="advisor@example.com"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvResetEmail" runat="server" ControlToValidate="txtResetEmail"
                                ErrorMessage="Email is required" CssClass="error-message" Display="Dynamic" ValidationGroup="VerifyGroup"></asp:RequiredFieldValidator>
                        </div>
                        <asp:Button ID="btnVerify" runat="server" Text="Verify Email" CssClass="btn-login" OnClick="btnVerify_Click" ValidationGroup="VerifyGroup" />
                        <div style="text-align: center; margin-top: 15px;">
                            <asp:LinkButton ID="lnkBackToLogin" runat="server" OnClick="lnkBackToLogin_Click" CausesValidation="false"
                                Style="color: #718096; font-size: 13px; text-decoration: none;">
                <i class="fas fa-arrow-left"></i> Back to Login
                            </asp:LinkButton>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlOTP" runat="server" Visible="false">
                        <div class="form-group">
                            <label class="form-label">Enter OTP Code</label>
                            <asp:TextBox ID="txtOTP" runat="server" CssClass="form-control" placeholder="123456" MaxLength="6"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvOTP" runat="server" ControlToValidate="txtOTP"
                                ErrorMessage="OTP is required" CssClass="error-message" Display="Dynamic" ValidationGroup="OTPGroup">
                            </asp:RequiredFieldValidator>
                        </div>
                        <asp:Button ID="btnSubmitOTP" runat="server" Text="Verify OTP" CssClass="btn-login"
                            OnClick="btnSubmitOTP_Click" ValidationGroup="OTPGroup" />
                    </asp:Panel>

                    <asp:Panel ID="pnlReset" runat="server" Visible="false">
                        <div class="form-group">
                            <label class="form-label">New Password</label>
                            <div class="password-container">
                                <asp:TextBox ID="txtNewPass" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter new password"></asp:TextBox>
                                <button type="button" class="toggle-password-btn" onclick="togglePasswordVisibility(event)">
                                    <i class="fas fa-eye toggle-icon"></i>
                                </button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvNewPass" runat="server" ControlToValidate="txtNewPass"
                                ErrorMessage="Required" CssClass="error-message" Display="Dynamic" ValidationGroup="ResetGroup"></asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Confirm Password</label>
                            <div class="password-container">
                                <asp:TextBox ID="txtConfirmPass" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm password"></asp:TextBox>
                                <button type="button" class="toggle-password-btn" onclick="togglePasswordVisibility(event)">
                                    <i class="fas fa-eye toggle-icon"></i>
                                </button>
                            </div>
                            <asp:CompareValidator ID="cvPass" runat="server" ControlToValidate="txtConfirmPass"
                                ControlToCompare="txtNewPass" Operator="Equal" Type="String"
                                ErrorMessage="Passwords do not match" CssClass="error-message" Display="Dynamic" ValidationGroup="ResetGroup">
                            </asp:CompareValidator>
                        </div>
                        <asp:Button ID="btnUpdatePass" runat="server" Text="Update Password" CssClass="btn-login" OnClick="btnUpdatePass_Click" ValidationGroup="ResetGroup" />
                    </asp:Panel>
                </div>

                <div class="login-footer">
                    <p class="footer-text">Secure Advisory Access Only</p>
                   <p>&copy; 2025 Lubricant India Expo and Summit. All rights reserved.</p>
                </div>
            </div>

            <div class="decoration decoration-top"></div>
            <div class="decoration decoration-bottom"></div>
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
                toggleBtn.setAttribute('title', 'Hide password');
            } else {
                passwordInput.type = 'password';
                toggleIcon.className = 'fas fa-eye toggle-icon';
                toggleBtn.setAttribute('title', 'Show password');
            }
        }
        window.addEventListener('load', function () {
            document.getElementById('<%= txtUsername.ClientID %>').focus();
        });
    </script>
</body>
</html>
