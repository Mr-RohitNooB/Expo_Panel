<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegisterAgenda.aspx.cs" Inherits="Expo_Panel.RegisterAgenda" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register Agenda - Expo Panel</title>
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
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            min-height: 100vh;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .registration-container {
            width: 900px;
            /* width: 100%;*/
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
                color: #3b82f6;
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
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.3s;
                font-family: 'Poppins', sans-serif;
            }

                .form-group input:focus,
                .form-group select:focus,
                .form-group textarea:focus {
                    outline: none;
                    border-color: #3b82f6;
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
            background: #3b82f6;
            color: white;
        }

            .btn-primary:hover {
                background: #2563eb;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
            }

        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
        }

        .back-link {
            color: #3b82f6;
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
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="registration-container">
            <div class="header">
                <h1><i class="fas fa-calendar-alt"></i>Register Agenda Item</h1>
                <p>Submit your session proposal for the expo</p>
            </div>

            <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>

            <div class="form-row">
                <div class="form-group">
                    <label for="<%=ddlDay.ClientID%>">Day <span class="required">*</span></label>
                    <asp:DropDownList ID="ddlDay" runat="server" CssClass="form-control">
                        <asp:ListItem Text="-- Select Day --" Value=""></asp:ListItem>
                        <asp:ListItem Text="Day 1" Value="Day 1"></asp:ListItem>
                        <asp:ListItem Text="Day 2" Value="Day 2"></asp:ListItem>
                        <asp:ListItem Text="Day 3" Value="Day 3"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvDay" runat="server" ControlToValidate="ddlDay"
                        ErrorMessage="Day is required" ForeColor="Red" Display="Dynamic" InitialValue="" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%=ddlStream.ClientID%>">Stream <span class="required">*</span></label>
                    <asp:DropDownList ID="ddlStream" runat="server" CssClass="form-control">
                        <asp:ListItem Text="-- Select Stream --" Value=""></asp:ListItem>
                        <asp:ListItem Text="Stream A" Value="Stream A"></asp:ListItem>
                        <asp:ListItem Text="Stream B" Value="Stream B"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvTrack" runat="server" ControlToValidate="ddlStream"
                        ErrorMessage="Stream is required" ForeColor="Red" Display="Dynamic" InitialValue="" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="<%=txtTime.ClientID%>">Time <span class="required">*</span></label>
                    <asp:TextBox ID="txtTime" runat="server" CssClass="form-control" placeholder="e.g., 09:00 AM - 10:00 AM"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTime" runat="server" ControlToValidate="txtTime"
                        ErrorMessage="Time is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtTitle.ClientID%>">Session Title <span class="required">*</span></label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Enter session title"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle"
                        ErrorMessage="Title is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-group">
                <label for="<%=txtBrief.ClientID%>">Brief Description</label>
                <asp:TextBox ID="txtBrief" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" placeholder="Short description of the session"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="<%=txtSynopsis.ClientID%>">Detailed Synopsis</label>
                <asp:TextBox ID="txtSynopsis" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Detailed description of the session content and objectives"></asp:TextBox>
            </div>

            <div class="form-footer">
               
                <asp:Button ID="btnRegister" runat="server" Text="Submit Agenda" CssClass="btn btn-primary"
                    OnClick="btnRegister_Click" ValidationGroup="RegistrationValidation" />
            </div>
        </div>
    </form>
</body>
</html>
