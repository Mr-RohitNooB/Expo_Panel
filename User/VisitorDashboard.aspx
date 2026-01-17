<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VisitorDashboard.aspx.cs" Inherits="Expo_Panel.VisitorDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Visitor Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
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
        /* GOLDEN DASHBOARD THEME */
        :root {
            --primary-gold: #d97706;
            --bg-light: #fffbeb;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: #f8fafc;
            margin: 0;
        }

        /* HEADER */
        .dash-header {
            background: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-bottom: 3px solid var(--primary-gold);
        }

        .user-badge {
            background: var(--bg-light);
            color: var(--primary-gold);
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn-logout {
            background: #ef4444;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 6px;
            cursor: pointer;
        }

        /* CONTAINER */
        .container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }

        /* WELCOME CARD */
        .welcome-card {
            background: linear-gradient(135deg, #f59e0b 0%, #b45309 100%);
            color: white;
            padding: 40px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 10px 25px rgba(217, 119, 6, 0.3);
            text-align: center; /* CENTERED TEXT */
        }

        .welcome-card h1 {
            margin: 0 0 10px 0;
            font-size: 28px;
        }

        /* PROFILE CARD */
        .card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }

        .card-header h2 {
            color: #334155;
            font-size: 20px;
            margin: 0;
        }

        .btn-action {
            background: var(--primary-gold);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .info-item label {
            display: block;
            font-size: 12px;
            color: #64748b;
            text-transform: uppercase;
            font-weight: 600;
        }

        .info-item span {
            font-size: 15px;
            color: #1e293b;
            font-weight: 500;
        }

        /* --- DASHBOARD ALIGNMENT FIXES --- */
        .dash-tabs {
            display: flex;
            gap: 20px;
            border-bottom: 2px solid #eee;
            margin-bottom: 20px;
            justify-content: center; /* CENTER TABS */
        }

        .dash-tab-btn {
            background: none;
            border: none;
            padding: 10px 0;
            font-size: 16px;
            font-weight: 600;
            color: #777;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            transition: 0.3s;
        }

        .dash-tab-btn.active {
            color: #D4A017;
            border-bottom-color: #D4A017;
        }

        .dash-tab-btn i {
            margin-right: 6px;
        }

        .dash-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 20px;
            justify-content: center; /* CENTER GRID ITEMS */
        }

        /* Card Styling */
        .d-card {
            background: #fff;
            border: 1px solid #eee;
            border-radius: 10px;
            overflow: hidden;
            position: relative;
            transition: transform 0.2s, box-shadow 0.2s;
            max-width: 300px; /* Prevent cards from stretching too wide */
            margin: 0 auto;   /* Center in grid cell */
            width: 100%;
        }

        .d-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.08);
        }

        .d-card-bar {
            height: 4px;
            background: linear-gradient(90deg, #D4A017, #f7c95f);
        }

        .d-bookmark-icon {
            position: absolute;
            top: 12px;
            right: 12px;
            font-size: 22px;
            cursor: pointer;
            color: #ccc;
            z-index: 5;
            background: rgba(255,255,255,0.9);
            border-radius: 50%;
            padding: 4px;
        }

        .d-bookmark-icon.active {
            color: #D4A017;
        }

        .d-card-body {
            padding: 15px;
            text-align: center;
        }

        .d-logo {
            height: 60px;
            object-fit: contain;
            margin-bottom: 10px;
            max-width: 100%;
        }

        .d-co-name {
            font-weight: 700;
            font-size: 15px;
            color: #333;
            margin-bottom: 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .d-loc {
            font-size: 13px;
            color: #777;
        }

        .d-booth {
            margin-top: 10px;
            font-size: 12px;
            background: #f4f4f4;
            display: inline-block;
            padding: 3px 8px;
            border-radius: 4px;
            color: #555;
            font-weight: 500;
        }

        /* MODAL */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.6);
            z-index: 100;
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 12px;
            width: 90%;
            max-width: 400px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="dash-header">
            <div class="user-badge">
                <i class="fas fa-user-circle" style="font-size: 20px;"></i>
                <asp:Literal ID="litUserName" runat="server"></asp:Literal>
            </div>
            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
        </div>

        <div class="container">
            <asp:Literal ID="litMessage" runat="server"></asp:Literal>

            <div class="welcome-card">
                <h1>Welcome back!</h1>
                <p>Manage your visit to the Lubricant India Expo.</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <h2><i class="fas fa-id-badge"></i>My Profile</h2>
                    <button type="button" class="btn-action" onclick="openModal()">
                        <i class="fas fa-key"></i>Change Password
                    </button>
                </div>
                <div class="info-grid">
                    <div class="info-item">
                        <label>Name</label><span><asp:Literal ID="litName" runat="server" /></span>
                    </div>
                    <div class="info-item">
                        <label>Ticket</label><span><asp:Literal ID="litTicket" runat="server" /></span>
                    </div>
                    <div class="info-item">
                        <label>Company</label><span><asp:Literal ID="litCompany" runat="server" /></span>
                    </div>
                    <div class="info-item">
                        <label>Job Title</label><span><asp:Literal ID="litJob" runat="server" /></span>
                    </div>
                    <div class="info-item">
                        <label>Email</label><span><asp:Literal ID="litEmail" runat="server" /></span>
                    </div>
                    <div class="info-item">
                        <label>Mobile</label><span><asp:Literal ID="litMobile" runat="server" /></span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Password Modal -->
        <div id="pwdModal" class="modal">
            <div class="modal-content">
                <h3 style="margin-top: 0;">Change Password</h3>
                <div class="form-group">
                    <label>Current Password</label><asp:TextBox ID="txtOld" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>New Password</label><asp:TextBox ID="txtNew" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                </div>
                <div class="modal-actions">
                    <button type="button" onclick="closeModal()" style="background: #eee; border: none; padding: 8px 16px; border-radius: 6px;">Cancel</button>
                    <asp:Button ID="btnChangePass" runat="server" Text="Update" CssClass="btn-action" OnClick="btnChangePass_Click" />
                </div>
            </div>
        </div>

        <div class="dashboard-section" style="margin-top: 40px;">

            <div class="dash-tabs">
                <button type="button" class="dash-tab-btn active" onclick="switchTab('all', this)">
                    <i class="fas fa-list"></i>All Exhibitors
       
                </button>
                <button type="button" class="dash-tab-btn" onclick="switchTab('saved', this)">
                    <i class="fas fa-heart"></i>Bookmarked Exhibitors
       
                </button>
            </div>

            <div id="view-all" class="dash-view">
                <div id="allExhibitorsGrid" class="dash-grid">
                    <div style="grid-column: 1/-1; text-align: center; padding: 30px; color: #666;">
                        <i class="fas fa-spinner fa-spin fa-2x"></i>
                        <br>
                        Loading Exhibitors...
           
                    </div>
                </div>
            </div>

            <div id="view-saved" class="dash-view" style="display: none;">
                <div id="savedExhibitorsGrid" class="dash-grid">
                </div>
                <div id="noBookmarksMsg" style="display: none; text-align: center; padding: 40px; background: #f9f9f9; border-radius: 8px; color: #666;">
                    <i class="far fa-heart" style="font-size: 40px; color: #ddd; margin-bottom: 10px;"></i>
                    <p>You haven't bookmarked any exhibitors yet.</p>
                    <button type="button" onclick="switchTab('all', document.querySelector('.dash-tab-btn'))"
                        style="background: none; border: none; color: #D4A017; font-weight: 600; cursor: pointer;">
                        Browse All Exhibitors
           
                    </button>
                </div>
            </div>

        </div>
    </form>

    <script>
        function openModal() { document.getElementById('pwdModal').style.display = 'flex'; }
        function closeModal() { document.getElementById('pwdModal').style.display = 'none'; }

        let globalExhibitorData = [];

        // Load Data on Page Ready
        document.addEventListener("DOMContentLoaded", function () {
            loadDashboardData();
        });

        function loadDashboardData() {
            fetch('VisitorDashboard.aspx/GetAllExhibitorsForDashboard', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.d) {
                        globalExhibitorData = data.d;
                        renderGrids();
                    } else {
                        console.error("No data returned or session expired");
                    }
                })
                .catch(err => console.error('Error:', err));
        }

        // Render both "All" and "Saved" grids
        function renderGrids() {
            const allGrid = document.getElementById('allExhibitorsGrid');
            const savedGrid = document.getElementById('savedExhibitorsGrid');
            const noSavedMsg = document.getElementById('noBookmarksMsg');

            // 1. Render All Grid
            allGrid.innerHTML = globalExhibitorData.map(ex => createCardHTML(ex)).join('');

            // 2. Filter & Render Saved Grid
            const savedItems = globalExhibitorData.filter(ex => ex.IsBookmarked);

            if (savedItems.length > 0) {
                savedGrid.innerHTML = savedItems.map(ex => createCardHTML(ex)).join('');
                noSavedMsg.style.display = 'none';
            } else {
                savedGrid.innerHTML = '';
                noSavedMsg.style.display = 'block';
            }
        }

        function createCardHTML(ex) {
            // Handle logo path, default if empty
            const logo = ex.LogoPath ? ex.LogoPath : '/Images/default_logo.png';
            const starClass = ex.IsBookmarked ? 'fas fa-heart active' : 'far fa-heart';

            return `
        <div class="d-card">
            <div class="d-card-bar"></div>
            <i class="${starClass} d-bookmark-icon" onclick="toggleDashboardBookmark(${ex.ExhibitorID})"></i>
            
            <a href="../ExhibitorDetails.aspx?id=${ex.ExhibitorID}" target="_blank" style="text-decoration:none;">
                <div class="d-card-body">
                    <img src="${logo}" class="d-logo" alt="${ex.Company}">
                    <div class="d-co-name" title="${ex.Company}">${ex.Company}</div>
                    <div class="d-loc"><i class="fas fa-map-marker-alt"></i> ${ex.City}</div>
                    <div class="d-booth">Booth: ${ex.BoothNo}</div>
                </div>
            </a>
        </div>`;
        }

        function toggleDashboardBookmark(id) {
            // Visual Feedback Immediate (Optional, but smoother)
            // Note: Real update happens after fetch returns

            fetch('VisitorDashboard.aspx/ToggleBookmark', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ exhibitorId: id })
            })
                .then(res => res.json())
                .then(data => {
                    if (data.d.status === 'SUCCESS') {
                        // Update local data
                        const index = globalExhibitorData.findIndex(x => x.ExhibitorID === id);
                        if (index !== -1) {
                            globalExhibitorData[index].IsBookmarked = data.d.isBookmarked;
                            // Re-render to update both tabs immediately
                            renderGrids();
                        }
                    } else if (data.d.status === 'SESSION_EXPIRED') {
                        window.location.href = 'VisitorLogin.aspx';
                    }
                });
        }

        // Tab Switcher
        window.switchTab = function (view, btn) {
            // Toggle Buttons
            document.querySelectorAll('.dash-tab-btn').forEach(b => b.classList.remove('active'));
            if (btn) btn.classList.add('active');

            // Toggle Divs
            document.getElementById('view-all').style.display = 'none';
            document.getElementById('view-saved').style.display = 'none';
            document.getElementById('view-' + view).style.display = 'block';
        }
    </script>
</body>
</html>
