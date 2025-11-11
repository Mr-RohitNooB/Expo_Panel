<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExhibitorLogin.aspx.cs" Inherits="Expo_Panel.ExhibitorLogin" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Exhibitor Login - Expo Panel</title>
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
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-container {
            width: 450px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        .header { text-align: center; margin-bottom: 30px; }
        .header h1 { color: #dd6b20; font-size: 28px; font-weight: 600; margin-bottom: 10px; }
        .header p { color: #6b7280; font-size: 16px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: #374151; font-weight: 500; }
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
        }
        .form-control:focus { outline: none; border-color: #ed8936; }
        .btn {
            width: 100%;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            font-size: 16px;
        }
        .btn-primary { background: #dd6b20; color: white; }
        .btn-primary:hover { background: #ed8936; }
        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-danger { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="header">
                <h1><i class="fas fa-sign-in-alt"></i> Exhibitor Login</h1>
                <p>Access your post-approval profile</p>
            </div>

            <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>

            <div class="form-group">
                <label for="<%=txtEmail.ClientID%>"><i class="fas fa-envelope"></i> Email (Username)</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter your registered email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required." ForeColor="Red" Display="Dynamic" ValidationGroup="LoginValidation"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="<%=txtPassword.ClientID%>"><i class="fas fa-lock"></i> Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter your password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Password is required." ForeColor="Red" Display="Dynamic" ValidationGroup="LoginValidation"></asp:RequiredFieldValidator>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary"
                OnClick="btnLogin_Click" ValidationGroup="LoginValidation" />
        </div>
    </form>
</body>
</html>