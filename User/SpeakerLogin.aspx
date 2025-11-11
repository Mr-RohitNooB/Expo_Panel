<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SpeakerLogin.aspx.cs" Inherits="Expo_Panel.SpeakerLogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Speaker Login - Expo Panel</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    body {
        font-family: 'Poppins', sans-serif;
        background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
        min-height: 100vh;
        padding: 40px 20px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .login-container {
        width: 500px;
        margin: 0 auto;
        background: rgba(255, 255, 255, 0.95);
        border-radius: 15px;
        padding: 40px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    }

    .logo-section {
        text-align: center;
        margin-bottom: 30px;
    }

    .logo-section i {
        font-size: 60px;
        color: #38a169;
        margin-bottom: 15px;
    }

    .logo-section h2 {
        color: #38a169;
        font-weight: 600;
        margin-bottom: 8px;
        font-size: 32px;
    }

    .logo-section p {
        color: #64748b;
        font-size: 16px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        margin-bottom: 8px;
        color: #475569;
        font-weight: 500;
        font-size: 14px;
    }

    .form-group label .required {
        color: #ef4444;
    }

    .input-wrapper {
        position: relative;
    }

    .input-wrapper i {
        position: absolute;
        left: 15px;
        top: 50%;
        transform: translateY(-50%);
        color: #94a3b8;
        font-size: 16px;
        z-index: 1;
    }

    .form-control {
        width: 100%;
        padding: 12px 15px 12px 45px;
        border: 2px solid #e2e8f0;
        border-radius: 8px;
        font-size: 14px;
        font-family: 'Poppins', sans-serif;
        transition: all 0.3s ease;
    }

    .form-control:focus {
        outline: none;
        border-color: #48bb78;
        box-shadow: 0 0 0 3px rgba(72, 187, 120, 0.1);
    }

    .text-danger {
        color: #ef4444;
        font-size: 13px;
        margin-top: 5px;
        display: block;
    }

    .btn-login {
        width: 100%;
        padding: 14px;
        background: #38a169;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        margin-top: 10px;
        font-family: 'Poppins', sans-serif;
    }

    .btn-login:hover {
        background: #2f855a;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(56, 161, 105, 0.4);
    }

    .btn-login:active {
        transform: translateY(0);
    }

    .divider {
        text-align: center;
        margin: 25px 0;
        position: relative;
    }

    .divider::before {
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        width: 100%;
        height: 1px;
        background: #e2e8f0;
    }

    .divider span {
        background: white;
        padding: 0 15px;
        color: #94a3b8;
        position: relative;
        font-size: 14px;
        font-weight: 500;
    }

    .register-link {
        text-align: center;
        margin-top: 20px;
        color: #64748b;
        font-size: 14px;
    }

    .register-link p {
        margin: 0;
    }

    .register-link a {
        color: #38a169;
        text-decoration: none;
        font-weight: 600;
        transition: color 0.3s;
    }

    .register-link a:hover {
        color: #2f855a;
        text-decoration: underline;
    }

    .alert {
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .alert i {
        font-size: 18px;
    }

    .alert-danger {
        background: #fee2e2;
        color: #991b1b;
        border: 1px solid #fecaca;
    }

    .alert-success {
        background: #d1fae5;
        color: #065f46;
        border: 1px solid #a7f3d0;
    }

    .alert-info {
        background: #dbeafe;
        color: #1e40af;
        border: 1px solid #93c5fd;
    }

    @media (max-width: 768px) {
        body {
            padding: 20px;
        }

        .login-container {
            padding: 30px 25px;
        }

        .logo-section h2 {
            font-size: 28px;
        }

        .logo-section i {
            font-size: 50px;
        }

        .logo-section p {
            font-size: 14px;
        }
    }

    @media (max-width: 480px) {
        .login-container {
            padding: 25px 20px;
        }

        .logo-section h2 {
            font-size: 24px;
        }

        .logo-section i {
            font-size: 45px;
        }
    }
</style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <!-- Logo Section -->
            <div class="logo-section">
                <i class="fas fa-user-tie"></i>
                <h2>Speaker Login</h2>
                <p>Access your speaker profile</p>
            </div>

            <!-- Alert Message -->
            <asp:Literal ID="litMessage" runat="server" />

            <!-- Email Field -->
            <div class="form-group">
                <label for="txtEmail">Email Address <span class="required">*</span></label>
                <div class="input-wrapper">
                    <i class="fas fa-envelope"></i>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                        placeholder="Enter your registered email" TextMode="Email" />
                </div>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ErrorMessage="Email is required"
                    Display="Dynamic"
                    CssClass="text-danger"
                    Style="font-size: 13px; margin-top: 5px; display: block;" />
            </div>

            <!-- Password Field -->
            <div class="form-group">
                <label for="txtPassword">Password <span class="required">*</span></label>
                <div class="input-wrapper">
                    <i class="fas fa-lock"></i>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                        placeholder="Enter your password" TextMode="Password" />
                </div>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                    ControlToValidate="txtPassword"
                    ErrorMessage="Password is required"
                    Display="Dynamic"
                    CssClass="text-danger"
                    Style="font-size: 13px; margin-top: 5px; display: block;" />
            </div>

            <!-- Login Button -->
            <asp:Button ID="btnLogin" runat="server" Text="Login to Dashboard"
                CssClass="btn-login" OnClick="btnLogin_Click" />

            <!-- Divider -->
            <div class="divider">
                <span>OR</span>
            </div>

            <!-- Register Link -->
            <div class="register-link">
                <p>Don't have an account? <a href="RegisterSpeaker.aspx">Register as Speaker</a></p>
            </div>
        </div>
    </form>
</body>
</html>
