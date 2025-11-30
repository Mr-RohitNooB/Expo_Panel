<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExhibitorLogin.aspx.cs" Inherits="Expo_Panel.ExhibitorLogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Exhibitor Login - Expo Panel</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Login to the Expo Panel as an Exhibitor" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <!-- Favicons from Blueprint -->
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
        /* ============================================
           Blueprint Stylesheet (Themed for Exhibitor Login - ORANGE)
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
            /* THEME: Fallback solid color */
            background: #dd6b20;
        }

        body {
            /* Using Poppins font from original Exhibitor page */
            font-family: 'Poppins', sans-serif;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            /* THEME: Orange Gradient */
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
            /* THEME: Orange Gradient */
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
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

        /* Update header-brand p - CHANGE margin */
        .header-brand p {
            font-size: 15px;
            color: rgba(255, 255, 255, 0.95);
            font-weight: 500;
            margin: 8px 0; /* Changed from 4px 0 */
        }

        /* Update tagline - CHANGE margin */
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
            margin-top: -50px;
            margin-bottom: -25px;
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
                /* THEME: Orange border and shadow */
                border-color: #ed8936;
                background: white;
                box-shadow: 0 0 0 4px rgba(237, 137, 54, 0.15);
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
            /* THEME: Orange hover */
            .toggle-password-btn:hover {
                background: rgba(237, 137, 54, 0.1);
            }

            .toggle-password-btn:active {
                transform: translateY(-50%) scale(0.95);
            }

        /* Login Button */
        .btn-login {
            width: 100%;
            padding: 14px;
            /* THEME: Orange Gradient */
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
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
            /* THEME: Orange shadow */
            box-shadow: 0 4px 15px rgba(221, 107, 32, 0.3);
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
                /* THEME: Orange shadow */
                box-shadow: 0 8px 25px rgba(221, 107, 32, 0.4);
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

        /* Added for compatibility with old litMessage */
        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
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
            color: #dd6b20;
            font-weight: 600;
            text-decoration: none;
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
                        <h1>Exhibitor Login Panel</h1>
                        <%--400x254--%>
                        <img src="../Images/Expo_logo_white.png" />
                        <p class="tagline">Access your post-approval profile</p>
                    </div>
                </div>

                <!-- Body Section -->
                <div class="login-body">

                    <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>

                    <asp:Panel ID="pnlLogin" runat="server">
                        <div class="form-group">
                            <label for="txtEmail" class="form-label">
                                <span class="label-icon"><i class="fas fa-envelope"></i></span>
                                Email (Username)
                            </label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter your registered email" MaxLength="100"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="error-message" Display="Dynamic" ValidationGroup="LoginGroup"></asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label for="txtPassword" class="form-label">
                                <span class="label-icon"><i class="fas fa-lock"></i></span>
                                Password
                            </label>
                            <div class="password-container">
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your password" MaxLength="255"></asp:TextBox>
                                <button type="button" class="toggle-password-btn" onclick="togglePasswordVisibility(event)">
                                    <i class="fas fa-eye toggle-icon"></i>
                                </button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required" CssClass="error-message" Display="Dynamic" ValidationGroup="LoginGroup"></asp:RequiredFieldValidator>
                        </div>

                        <div style="text-align: right; margin-bottom: 15px;">
                        <%--    <asp:LinkButton ID="lnkForgot" runat="server" OnClick="lnkForgot_Click" CausesValidation="false" Style="color: #dd6b20; font-size: 13px; font-weight: 600; text-decoration: none;">
                Forgot Password?
                            </asp:LinkButton>--%>
                        </div>

                        <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" OnClick="btnLogin_Click" ValidationGroup="LoginGroup" />
                    </asp:Panel>

                    <asp:Panel ID="pnlVerify" runat="server" Visible="false">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i>Enter your registered email to reset your password.
                        </div>
                        <div class="form-group">
                            <label class="form-label">Registered Email</label>
                            <asp:TextBox ID="txtResetEmail" runat="server" CssClass="form-control" placeholder="e.g. exhibitor@company.com"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvResetEmail" runat="server" ControlToValidate="txtResetEmail" ErrorMessage="Email is required" CssClass="error-message" Display="Dynamic" ValidationGroup="VerifyGroup"></asp:RequiredFieldValidator>
                        </div>
                        <asp:Button ID="btnVerify" runat="server" Text="Verify Email" CssClass="btn-login" OnClick="btnVerify_Click" ValidationGroup="VerifyGroup" />

                        <div style="text-align: center; margin-top: 15px;">
                            <asp:LinkButton ID="lnkBackToLogin" runat="server" OnClick="lnkBackToLogin_Click" CausesValidation="false" Style="color: #718096; font-size: 13px; text-decoration: none;">
                <i class="fas fa-arrow-left"></i> Back to Login
                            </asp:LinkButton>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlReset" runat="server" Visible="false">
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i>Account verified! Set your new password below.
    </div>

    <div class="form-group">
        <label class="form-label">New Password</label>
        
        <div class="password-container">
            <asp:TextBox ID="txtNewPass" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter new password"></asp:TextBox>
            
            <button type="button" class="toggle-password-btn" onclick="togglePasswordVisibility(event)">
                <i class="fas fa-eye toggle-icon"></i>
            </button>
        </div>

        <asp:RequiredFieldValidator ID="rfvNewPass" runat="server"
            ControlToValidate="txtNewPass"
            ErrorMessage="New Password is required"
            CssClass="error-message"
            Display="Dynamic"
            ValidationGroup="ResetGroup">
        </asp:RequiredFieldValidator>

        <asp:RegularExpressionValidator ID="revMinLen" runat="server"
            ControlToValidate="txtNewPass"
            ValidationExpression="^.{6,}$"
            ErrorMessage="Password must be at least 6 characters"
            CssClass="error-message"
            Display="Dynamic"
            ValidationGroup="ResetGroup">
        </asp:RegularExpressionValidator>
    </div>

    <div class="form-group">
        <label class="form-label">Confirm Password</label>
        
        <div class="password-container">
            <asp:TextBox ID="txtConfirmPass" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm new password"></asp:TextBox>
            
            <button type="button" class="toggle-password-btn" onclick="togglePasswordVisibility(event)">
                <i class="fas fa-eye toggle-icon"></i>
            </button>
        </div>

        <asp:RequiredFieldValidator ID="rfvConfirm" runat="server"
            ControlToValidate="txtConfirmPass"
            ErrorMessage="Confirm Password is required"
            CssClass="error-message"
            Display="Dynamic"
            ValidationGroup="ResetGroup">
        </asp:RequiredFieldValidator>

        <asp:CompareValidator ID="cvPass" runat="server"
            ControlToValidate="txtConfirmPass"
            ControlToCompare="txtNewPass"
            Operator="Equal"
            Type="String"
            ErrorMessage="Passwords do not match"
            CssClass="error-message"
            Display="Dynamic"
            ValidationGroup="ResetGroup">
        </asp:CompareValidator>
    </div>

    <asp:Button ID="btnUpdatePass" runat="server" Text="Update Password" CssClass="btn-login" OnClick="btnUpdatePass_Click" ValidationGroup="ResetGroup" />
</asp:Panel>

                </div>

                <!-- Footer Section (Customized) -->
                <div class="login-footer">
                    <p>Don't have an account? <a href="RegisterExhibitor.aspx">Register as Exhibitor</a></p>
                    <p>&copy; 2025 Lubricant India Expo. All rights reserved.</p>
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

            // 1. Get the button that was clicked
            var toggleBtn = event.currentTarget;

            // 2. Find the input field relative to the button (they are siblings in the container)
            var container = toggleBtn.parentElement;
            var passwordInput = container.querySelector('input');
            var toggleIcon = toggleBtn.querySelector('.toggle-icon');

            // 3. Toggle Logic
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

        // Focus on email field on page load
        window.addEventListener('load', function () {
            var emailInput = document.getElementById('<%= txtEmail.ClientID %>');
            if (emailInput) {
                emailInput.focus();
            }
        });

        // Focus on email field on page load
        window.addEventListener('load', function () {
            // Updated to focus txtEmail
            var emailInput = document.getElementById('<%= txtEmail.ClientID %>');
            if (emailInput) {
                emailInput.focus();
            }
        });
        // Focus on email field on page load
        window.addEventListener('load', function () {
            var emailInput = document.getElementById('<%= txtEmail.ClientID %>');
            if (emailInput) {
                emailInput.focus();
            }
        });
    </script>
</body>
</html>
