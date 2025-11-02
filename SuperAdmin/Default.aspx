<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Expo_Panel.Admin.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Super Admin Login - Lubricant India Expo</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Login to Lubricant India Expo and Smart Lubricants Summit 2026 Admin Panel" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        /* ============================================
   Lubricant India Expo - Admin Login Stylesheet
   ============================================ */

        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
    scroll-behavior: smooth;
    height: 100%;
    background: #667eea; /* Fallback solid color */
}

        /* Add to the body styles (around line 26) */
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
        'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
        sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    background-attachment: fixed;
    background-repeat: no-repeat; /* Add this */
    background-size: 100% 100%; /* Add this - stretches to full page */
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 16px;
    position: relative;
    overflow-x: hidden;
}

/* Update the login-wrapper to prevent overflow (around line 40) */
.login-wrapper {
    position: relative;
    width: 100%;
    max-width: 1200px;
    display: flex;
    justify-content: center;
    align-items: center;
    overflow: hidden; /* Add this to clip decorative elements */
}

        /* Login Container */
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

        /* Header Styles */
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
            margin-bottom: 8px;
            letter-spacing: -0.5px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .header-brand p {
            font-size: 15px;
            color: rgba(255, 255, 255, 0.95);
            font-weight: 500;
            margin: 4px 0;
        }

        .header-brand .tagline {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.8);
            font-style: italic;
            margin-top: 8px;
        }

        /* Body Styles */
        .login-body {
            padding: 45px 30px;
        }

        /* Form Group */
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

        /* Form Controls */
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

        /* Password Container */
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

        /* Login Button */
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
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
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

        /* Alert Styles */
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

        /* Error Message */
        .error-message {
            color: #c53030;
            font-size: 13px;
            margin-top: 6px;
            font-weight: 500;
            display: block;
        }

        /* Footer Styles */
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

        /* Decorative Elements */
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
                max-width: 95%;
            }

            .login-header {
                padding: 40px 24px;
            }

            .header-brand h1 {
                font-size: 28px;
            }

            .header-brand p {
                font-size: 14px;
            }

            .login-body {
                padding: 35px 24px;
            }

            .login-footer {
                padding: 20px 24px;
            }
        }

        /* Mobile Phones (480px and below) */
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
                padding: 35px 20px;
            }

            .header-brand h1 {
                font-size: 24px;
                margin-bottom: 6px;
            }

            .header-brand p {
                font-size: 13px;
                margin: 2px 0;
            }

            .header-brand .tagline {
                font-size: 11px;
                margin-top: 6px;
            }

            .login-body {
                padding: 25px 20px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                font-size: 13px;
            }

            .form-control {
                padding: 12px 14px;
                font-size: 14px;
            }

            .btn-login {
                padding: 12px;
                font-size: 15px;
            }

            .login-footer {
                padding: 18px 20px;
            }

                .login-footer p {
                    font-size: 11px;
                }

            .decoration {
                display: none;
            }
        }

        /* Small Phones (360px and below) */
        @media (max-width: 360px) {
            .login-header {
                padding: 30px 16px;
            }

            .header-brand h1 {
                font-size: 22px;
            }

            .login-body {
                padding: 20px 16px;
            }

            .login-footer {
                padding: 16px;
            }

            .form-control {
                padding: 11px 12px;
                font-size: 14px;
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
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div class="login-wrapper">
            <div class="login-container">
                <!-- Header Section -->
                <div class="login-header">
                    <div class="header-brand">
                        <h1>Super Admin Panel</h1>
                        <p>Lubricant India Expo</p>
                        <p class="tagline">Smart Lubricants Summit 2026</p>
                    </div>
                </div>

                <!-- Body Section -->
                <div class="login-body">
                    <!-- Error Alert -->
                    <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-error" Visible="false">
                        <div class="alert-icon">⚠</div>
                        <asp:Label ID="lblError" runat="server"></asp:Label>
                    </asp:Panel>

                    <!-- Username Field -->
                    <div class="form-group">
                        <label for="txtUsername" class="form-label">
                            <span class="label-icon"><i class="fas fa-user"></i></span>
                            Username
                        </label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"
                            placeholder="Enter your username" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                            ControlToValidate="txtUsername"
                            ErrorMessage="Username is required"
                            CssClass="error-message"
                            Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <!-- Password Field -->
<div class="form-group">
    <label for="txtPassword" class="form-label">
        <span class="label-icon"><i class="fas fa-lock"></i></span>
        Password
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
                                Display="Dynamic"></asp:RequiredFieldValidator>
</div>

                    <!-- Login Button -->
                    <asp:Button ID="btnLogin" runat="server" Text="Sign In"
                        CssClass="btn-login" OnClick="btnLogin_Click" />
                </div>

                <!-- Footer Section -->
                <div class="login-footer">
                    <p>&copy; 2025 Lubricant India Expo and Smart Lubricants Summit 2026. All rights reserved.</p>
                    <p class="footer-text">Secure Admin Access Only</p>
                </div>
            </div>

            <!-- Decorative Elements -->
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
                toggleIcon.className = 'fas fa-eye-slash toggle-icon'; // Changed icon
                toggleBtn.setAttribute('title', 'Hide password');
            } else {
                passwordInput.type = 'password';
                toggleIcon.className = 'fas fa-eye toggle-icon'; // Changed icon
                toggleBtn.setAttribute('title', 'Show password');
            }
        }

        // Focus on username field on page load
        window.addEventListener('load', function () {
            document.getElementById('<%= txtUsername.ClientID %>').focus();
        });
    </script>
</body>
</html>
