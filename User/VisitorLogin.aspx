<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VisitorLogin.aspx.cs" Inherits="Expo_Panel.VisitorLogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Visitor Login - Lubricant India Expo</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

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
            --bg-gold-light: #fffbeb;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 16px;
        }

        .login-wrapper {
            width: 100%;
            max-width: 480px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            animation: slideUp 0.6s ease-out;
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
            background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
            padding: 40px 30px;
            text-align: center;
            color: white;
            position: relative;
        }

        .header-brand h1 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 5px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .header-brand p {
            font-size: 14px;
            opacity: 0.9;
        }

        .login-body {
            padding: 40px 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #4b5563;
            font-size: 14px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }

            .form-control:focus {
                outline: none;
                border-color: var(--primary-gold);
                box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.15);
            }

        .btn-login {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: transform 0.2s;
            margin-top: 10px;
        }

            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(217, 119, 6, 0.3);
            }

        .alert {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 13px;
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .alert-success {
            background: #ecfccb;
            color: #365314;
            border: 1px solid #bef264;
        }

        .alert-info {
            background: #eff6ff;
            color: #1e40af;
            border: 1px solid #bfdbfe;
        }

        .password-container {
            position: relative;
        }

        .toggle-password-btn {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            color: #6b7280;
        }

        .login-footer {
            background: #f9fafb;
            padding: 20px;
            text-align: center;
            border-top: 1px solid #e5e7eb;
        }

            .login-footer p {
                font-size: 12px;
                color: #6b7280;
            }

            .login-footer a {
                color: var(--primary-gold);
                font-weight: 600;
                text-decoration: none;
            }

                .login-footer a:hover {
                    text-decoration: underline;
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-wrapper">
            <div class="login-header">
                <div class="header-brand">
                    <h1>Visitor Login</h1>

                    <img src="../Images/Expo_logo_white.png" alt="Lubricant India Expo Logo" />

                    <p>Access your Lubricant India Expo dashboard</p>
                </div>

            </div>

            <div class="login-body">
                <asp:Literal ID="litMessage" runat="server" />

                <!-- 1. LOGIN PANEL -->
                <asp:Panel ID="pnlLogin" runat="server">
                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-envelope"></i> Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter your email"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic" ValidationGroup="LoginVal"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label"><i class="fas fa-lock"></i> Password</label>
                        <div class="password-container">
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter your password"></asp:TextBox>
                            <button type="button" class="toggle-password-btn" onclick="togglePassword(this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required" ForeColor="Red" Display="Dynamic" ValidationGroup="LoginVal"></asp:RequiredFieldValidator>
                    </div>

                    <div style="text-align: right; margin-bottom: 15px;">
                        <asp:LinkButton ID="lnkForgot" runat="server" OnClick="lnkForgot_Click" Style="color: #d97706; font-size: 13px; text-decoration: none;">Forgot Password?</asp:LinkButton>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" OnClick="btnLogin_Click" ValidationGroup="LoginVal" />
                </asp:Panel>

                <!-- 2. VERIFY EMAIL PANEL -->
                <asp:Panel ID="pnlVerify" runat="server" Visible="false">
                    <div class="alert alert-info"><i class="fas fa-info-circle"></i>Enter your registered email to receive an OTP.</div>
                    <div class="form-group">
                        <label class="form-label">Registered Email</label>
                        <asp:TextBox ID="txtResetEmail" runat="server" CssClass="form-control" placeholder="Enter email"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvResetEmail" runat="server" ControlToValidate="txtResetEmail" ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic" ValidationGroup="VerifyVal"></asp:RequiredFieldValidator>
                    </div>
                    <asp:Button ID="btnVerify" runat="server" Text="Send OTP" CssClass="btn-login" OnClick="btnVerify_Click" ValidationGroup="VerifyVal" />
                    <div style="text-align: center; margin-top: 15px;">
                        <asp:LinkButton ID="lnkBack" runat="server" OnClick="lnkBackToLogin_Click" Style="color: #6b7280; font-size: 13px; text-decoration: none;">Back to Login</asp:LinkButton>
                    </div>
                </asp:Panel>

                <!-- 3. OTP PANEL -->
                <asp:Panel ID="pnlOTP" runat="server" Visible="false">
                    <div class="alert alert-info"><i class="fas fa-envelope"></i>OTP sent to your email.</div>
                    <div class="form-group">
                        <label class="form-label">Enter OTP</label>
                        <asp:TextBox ID="txtOTP" runat="server" CssClass="form-control" placeholder="6-digit code"></asp:TextBox>
                    </div>
                    <asp:Button ID="btnSubmitOTP" runat="server" Text="Verify OTP" CssClass="btn-login" OnClick="btnSubmitOTP_Click" />
                </asp:Panel>

                <!-- 4. RESET PASSWORD PANEL -->
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
            ErrorMessage="New Password is required" CssClass="error-message" Display="Dynamic" ValidationGroup="ResetGroup"></asp:RequiredFieldValidator>
    </div>

    <div class="form-group">
        <label class="form-label">Confirm Password</label>
        
        <div class="password-container">
            <asp:TextBox ID="txtConfirmPass" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm new password"></asp:TextBox>
            <button type="button" class="toggle-password-btn" onclick="togglePasswordVisibility(event)">
                <i class="fas fa-eye toggle-icon"></i>
            </button>
        </div>

        <asp:RequiredFieldValidator ID="rfvConfirm" runat="server" ControlToValidate="txtConfirmPass"
            ErrorMessage="Confirm Password is required" CssClass="error-message" Display="Dynamic" ValidationGroup="ResetGroup"></asp:RequiredFieldValidator>
        
        <asp:CompareValidator ID="cvPass" runat="server" ControlToValidate="txtConfirmPass"
            ControlToCompare="txtNewPass" Operator="Equal" Type="String"
            ErrorMessage="Passwords do not match" CssClass="error-message" Display="Dynamic" ValidationGroup="ResetGroup"></asp:CompareValidator>
    </div>

    <asp:Button ID="btnUpdatePass" runat="server" Text="Update Password" CssClass="btn-login" OnClick="btnUpdatePass_Click" ValidationGroup="ResetGroup" />
</asp:Panel>
            </div>

            <div class="login-footer">
                <p>Don't have an account? <a href="RegisterVisitor.aspx">Register as Visitor</a></p>
            </div>
        </div>
    </form>

    <script>
        function togglePasswordVisibility(event) {
            event.preventDefault(); // Stop button from submitting form

            // 1. Get the button that was clicked
            var toggleBtn = event.currentTarget;

            // 2. Find the input field relative to the button
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
    </script>
</body>
</html>
