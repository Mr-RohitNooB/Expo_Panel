<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Expo_Panel.Admin.TeamDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Team Dashboard - Lubricant India Expo</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" />
    <link rel="shortcut icon" href="/Images/favicon_io_Lubricant_India_Expo/favicon.ico" />

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            color: #2d3748;
        }

        /* TEAM THEME: ORANGE GRADIENT */
        .header {
            background: linear-gradient(135deg, #c05621 0%, #ed8936 100%);
            color: white;
            padding: 20px 40px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-left { display: flex; align-items: center; gap: 15px; }
        .header-left h1 { font-size: 24px; font-weight: 600; }
        .header-right { display: flex; align-items: center; gap: 25px; }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 8px;
        }

        .user-avatar {
            width: 36px;
            height: 36px;
            background: white;
            color: #c05621;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 16px;
        }

        .user-details { display: flex; flex-direction: column; }
        .user-name { font-size: 14px; font-weight: 600; }
        .user-role { font-size: 12px; color: #fed7d7; }

        .btn-logout {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-logout:hover { background: rgba(255, 255, 255, 0.2); }

        .container { max-width: 1400px; margin: 0 auto; padding: 40px 20px; }

        .welcome-section {
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            margin-bottom: 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 5px solid #ed8936;
        }

        .welcome-content h2 { font-size: 32px; margin-bottom: 10px; color: #2d3748; }
        .welcome-content p { color: #718096; font-size: 16px; }

        .welcome-stats { display: flex; gap: 40px; }
        .stat-item { text-align: center; }
        .stat-number { font-size: 32px; font-weight: 700; color: #ed8936; display: block; }
        .stat-label { font-size: 13px; color: #718096; margin-top: 5px; font-weight: 600; text-transform: uppercase; }

        .section-title { font-size: 20px; font-weight: 600; color: #2d3748; margin-bottom: 20px; padding-left: 5px; }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 40px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            border-left: 4px solid transparent;
            position: relative;
            overflow: hidden;
        }

        .card:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }

        /* Card Themes */
        .card.advisor-card { border-left-color: #667eea; }
        .card.advisor-card .card-icon { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        
        .card.speaker-card { border-left-color: #48bb78; }
        .card.speaker-card .card-icon { background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); }

        .card.agenda-card { border-left-color: #3b82f6; }
        .card.agenda-card .card-icon { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); }

        .card-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        
        .card-icon {
            width: 56px; height: 56px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .card-icon i { font-size: 26px; color: white; }

        .card-body h3 { font-size: 20px; margin-bottom: 10px; color: #2d3748; font-weight: 700; }
        .card-body p { color: #718096; font-size: 14px; line-height: 1.6; }

        @media (max-width: 768px) {
            .header { flex-direction: column; align-items: flex-start; gap: 15px; }
            .header-right { width: 100%; justify-content: space-between; }
            .welcome-section { flex-direction: column; align-items: flex-start; gap: 20px; }
            .cards-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div class="header-left">
             <img src="/Images/Lubricant_India_Expo_Cropped.png" style="height: 50px;/* background:white; *//* padding:5px; */border-radius: -10px;margin-right:15px;"/>
                <h1>Lubricant India Admin Team Panel</h1>
            </div>
            <div class="header-right">
                <div class="user-info">
                    <div class="user-avatar">
                        <asp:Label ID="lblUserInitial" runat="server"></asp:Label>
                    </div>
                    <div class="user-details">
                        <span class="user-name"><asp:Label ID="lblUsername" runat="server"></asp:Label></span>
                        <span class="user-role">Team Member</span>
                    </div>
                </div>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
            </div>
        </div>

        <div class="container">
            <div class="welcome-section">
                <div class="welcome-content">
                    <h2>Hello, <asp:Label ID="lblWelcomeUser" runat="server"></asp:Label>!</h2>
                    <p>You have access to manage Advisors, Speakers, and Agenda.</p>
                </div>
            </div>

            <h2 class="section-title">Your Workspace</h2>
            <div class="cards-grid">
                
       <%--         <a href="ManageAdvisors.aspx" class="card advisor-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-user-tie"></i>
                        </div>
                        <i class="fas fa-arrow-right" style="color:#cbd5e0;"></i>
                    </div>
                    <div class="card-body">
                        <h3>Manage Advisors</h3>
                        <p>Add new advisors, view profiles, and edit details.</p>
                    </div>
                </a>--%>

                <a href="ManageSpeaker.aspx" class="card speaker-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-microphone"></i>
                        </div>
                        <i class="fas fa-arrow-right" style="color:#cbd5e0;"></i>
                    </div>
                    <div class="card-body">
                        <h3>Manage Speakers</h3>
                        <p>Register speakers and update their information.</p>
                    </div>
                </a>

                <a href="ManageAgenda.aspx" class="card agenda-card">
                    <div class="card-header">
                        <div class="card-icon">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <i class="fas fa-arrow-right" style="color:#cbd5e0;"></i>
                    </div>
                    <div class="card-body">
                        <h3>Manage Agenda</h3>
                        <p>View and update the event schedule and timeline.</p>
                    </div>
                </a>

            </div>
        </div>
    </form>
</body>
</html>