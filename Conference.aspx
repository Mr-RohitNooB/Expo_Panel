<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Conference.aspx.cs" Inherits="Expo_Panel.Conference" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Conference | Lubricant India Expo 2026</title>
    <link rel="icon" type="image/png" sizes="32x32" href="Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="Images/favicon_io_Lubricant_India_Expo/favicon-16x16.png">
    <link rel="apple-touch-icon" href="Images/favicon_io_Lubricant_India_Expo/apple-touch-icon.png">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        /* --- GLOBAL STYLES (Matches Index.aspx) --- */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f8fafc;
        }

        /* --- NAVBAR STYLES --- */
        .navbar {
            background: #ffffff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            transition: all 0.3s ease;
            border-bottom: 3px solid #D94A2B;
        }

            .navbar.scrolled {
                background: rgba(255, 255, 255, 0.98);
                backdrop-filter: blur(10px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 80px;
        }

        .logo {
            display: flex;
            align-items: center;
        }

            .logo img {
                height: 60px;
                width: auto;
            }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 10px;
        }

        .nav-item {
            position: relative;
        }

        .nav-link {
            color: #3D3935;
            text-decoration: none;
            padding: 10px 16px;
            display: flex;
            align-items: center;
            gap: 5px;
            border-radius: 6px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

            .nav-link:hover {
                background: rgba(217, 74, 43, 0.1);
                color: #D94A2B;
            }

        /* Dropdown */
        .dropdown {
            position: relative;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            background: #ffffff;
            min-width: 220px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #e5e7eb;
        }

        .dropdown:hover .dropdown-content {
            display: block;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dropdown-content a {
            color: #3D3935;
            padding: 12px 20px;
            text-decoration: none;
            display: block;
            transition: all 0.3s ease;
        }

            .dropdown-content a:hover {
                background: rgba(217, 74, 43, 0.1);
                color: #D94A2B;
                padding-left: 25px;
            }

        .mobile-menu-toggle {
            display: none;
            background: none;
            border: none;
            color: #3D3935;
            font-size: 24px;
            cursor: pointer;
        }

        /* --- PAGE HEADER (Mini Hero) --- */
        .page-header {
            background: linear-gradient(135deg, #3D3935 0%, #5C5550 50%, #3D3935 100%);
            padding: 120px 20px 60px;
            text-align: center;
            color: #fff;
            margin-bottom: 40px;
        }

            .page-header h1 {
                font-size: 42px;
                margin-bottom: 10px;
                background: linear-gradient(135deg, #D94A2B 0%, #FF6B4A 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .page-header p {
                font-size: 18px;
                opacity: 0.9;
                max-width: 700px;
                margin: 0 auto;
            }

        /* --- AGENDA STYLES --- */
        .section {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px 60px;
        }

        .agenda-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
        }

        .agenda-card {
            background: #fff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            border-left: 5px solid #D94A2B;
            position: relative;
        }

            .agenda-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 30px rgba(217, 74, 43, 0.15);
            }

        .agenda-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .agenda-day {
            font-size: 14px;
            font-weight: 700;
            color: #D94A2B;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .agenda-time {
            font-size: 15px;
            color: #64748b;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 5px;
        }

            .agenda-time i {
                color: #D94A2B;
            }

        .agenda-title {
            font-size: 22px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 12px;
            line-height: 1.4;
        }

        .agenda-brief {
            color: #64748b;
            font-size: 15px;
            line-height: 1.6;
            margin-bottom: 20px;
        }

        .agenda-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto;
        }

        .agenda-track {
            background: rgba(217, 74, 43, 0.1);
            color: #D94A2B;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        /* --- FOOTER STYLES --- */
        .footer {
            background: #3D3935;
            color: #fff;
            padding: 40px 20px;
            text-align: center;
            margin-top: 60px;
        }

        .footer-links {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

            .footer-links a {
                color: #fff;
                text-decoration: none;
                transition: color 0.3s ease;
            }

                .footer-links a:hover {
                    color: #D94A2B;
                }

        /* --- LOADING STATE --- */
        #loadingMsg {
            text-align: center;
            font-size: 18px;
            color: #666;
            padding: 40px;
        }

        /* --- MOBILE RESPONSIVE --- */
        @media (max-width: 768px) {
            .nav-menu {
                display: none;
                flex-direction: column;
                position: absolute;
                top: 80px;
                left: 0;
                right: 0;
                background: #ffffff;
                padding: 20px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.2);
                border-top: 2px solid #D94A2B;
                align-items: center;
                text-align: center;
            }

            .nav-link {
                justify-content: center;
            }

            .nav-menu.active {
                display: flex;
            }

            .mobile-menu-toggle {
                display: block;
            }

            .dropdown-content {
                position: static;
                box-shadow: none;
                margin-top: 10px;
                background: rgba(217, 74, 43, 0.05);
                border: 1px solid rgba(217, 74, 43, 0.2);
            }

            .logo img {
                height: 50px;
            }

            .page-header h1 {
                font-size: 32px;
            }

            .agenda-grid {
                grid-template-columns: 1fr;
            }
        }

        /* --- FILTER STYLES --- */
.filter-container {
    background: #fff;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    margin-bottom: 30px;
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.filter-group {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
}

.filter-label {
    font-weight: 600;
    color: #3D3935;
    margin-right: 10px;
    min-width: 100px;
}

.filter-btn {
    padding: 8px 20px;
    border: 1px solid #e2e8f0;
    background: #fff;
    color: #64748b;
    border-radius: 50px;
    cursor: pointer;
    font-size: 14px;
    font-weight: 500;
    transition: all 0.3s ease;
}

.filter-btn:hover {
    border-color: #D94A2B;
    color: #D94A2B;
}

.filter-btn.active {
    background: #D94A2B;
    color: white;
    border-color: #D94A2B;
    box-shadow: 0 4px 10px rgba(217, 74, 43, 0.3);
}

/* Mobile adjustment for filters */
@media (max-width: 768px) {
    .filter-group { flex-direction: column; align-items: flex-start; gap: 8px; }
    .filter-label { margin-bottom: 5px; }
    .filter-btn { width: 100%; text-align: center; }
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar" id="navbar">
            <div class="nav-container">
                <div class="logo">
                    <a href="/Index.aspx">
                        <img src="Images/Expo_logo.png" alt="Lubricant India Expo 2026">
                    </a>
                </div>
                <button type="button" class="mobile-menu-toggle" onclick="toggleMobileMenu()">
                    <i class="fas fa-bars"></i>
                </button>
                <ul class="nav-menu" id="navMenu">
                    <li class="nav-item"><a href="Index.aspx" class="nav-link">Home</a></li>
                    <li class="nav-item dropdown">
                        <a href="#" class="nav-link">Register <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="User/RegisterExhibitor.aspx">Register as Exhibitor</a>
                            <a href="User/RegisterSpeaker.aspx">Register as Speaker</a>

                        </div>
                    </li>
                    <li class="nav-item"><a href="Conference.aspx" class="nav-link" style="color: #D94A2B;">Conference</a></li>
                    <li class="nav-item"><a href="Index.aspx#speakers" class="nav-link">Speakers</a></li>
                                    <li class="nav-item"><a href="Exhibitors.aspx" class="nav-link">Exhibitors</a></li>
                    <li class="nav-item dropdown">
                        <a href="#" class="nav-link">Login <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="User/AdvisoryLogin.aspx">Advisory Committee</a>
                            <a href="User/ExhibitorLogin.aspx">Exhibitor Login</a>
                            <a href="User/SpeakerLogin.aspx">Speaker Login</a>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>

        <header class="page-header">
            <h1>Conference</h1>
            <p>Explore the schedule of keynotes, panel discussions, and technical sessions.</p>
        </header>

        <section class="section">
            <div class="filter-container">
                <div class="filter-group" id="dayFilters">
                    <span class="filter-label">Filter by Day:</span>
                    <button class="filter-btn active" onclick="filterAgenda('day', 'all')">All Days</button>
                </div>
                <div class="filter-group" id="trackFilters">
                    <span class="filter-label">Filter by Stream:</span>
                    <button class="filter-btn active" onclick="filterAgenda('track', 'all')">All Streams</button>
                </div>
            </div>

            <div id="loadingMsg"><i class="fas fa-spinner fa-spin"></i>Loading Schedule...</div>

            <div class="agenda-grid" id="agendaContainer">
            </div>
        </section>

        <footer class="footer">
            <div class="footer-content">
                <div class="footer-links">
                    <a href="Index.aspx">Home</a>
                    <a href="Conference.aspx">Conference</a>
                    <a href="Index.aspx#speakers">Speakers</a>
                       <a href="Exhibitors.aspx">Exhibitors</a>
                    <a href="Index.aspx#venue">Venue</a>
                    <a href="#">Terms & Conditions</a>
                    <a href="#">Privacy Policy</a>
                </div>
                <p style="margin-top: 20px; opacity: 0.8;">
                    © 2026 Lubricant India Expo. All rights reserved.
                </p>
            </div>
        </footer>
    </form>

    <script>
        // Mobile Menu Logic
        function toggleMobileMenu() {
            document.getElementById('navMenu').classList.toggle('active');
        }

        // Navbar Scroll Effect
        window.addEventListener('scroll', function () {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 50) navbar.classList.add('scrolled');
            else navbar.classList.remove('scrolled');
        });

        // Global variables to hold state
        let allAgendaData = [];
        let currentDayFilter = 'all';
        let currentTrackFilter = 'all';

        // Load Agenda Logic
        document.addEventListener("DOMContentLoaded", function () {
            loadAgenda();
        });

        async function loadAgenda() {
            try {
                const response = await fetch('Conference.aspx/GetConferenceAgenda', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' }
                });

                const data = await response.json();
                allAgendaData = data.d; // Store all data globally

                const loader = document.getElementById('loadingMsg');
                loader.style.display = 'none';

                if (!allAgendaData || allAgendaData.length === 0) {
                    document.getElementById('agendaContainer').innerHTML = '<p style="text-align:center; grid-column:1/-1; font-size:1.2rem;">No sessions scheduled yet.</p>';
                    return;
                }

                // 1. Generate Dynamic Filter Buttons based on data
                generateFilterButtons();

                // 2. Render all items initially
                renderAgenda(allAgendaData);

            } catch (err) {
                console.error("Error loading agenda:", err);
                document.getElementById('loadingMsg').innerText = "Failed to load schedule.";
            }
        }
        function generateFilterButtons() {
            // Extract unique Days and Sort them
            const uniqueDays = [...new Set(allAgendaData.map(item => item.Day))].sort();
            // Extract unique Tracks (Streams) and Sort them
            const uniqueTracks = [...new Set(allAgendaData.map(item => item.Track))].sort();

            const dayContainer = document.getElementById('dayFilters');
            const trackContainer = document.getElementById('trackFilters');

            // OPTIONAL: Clear existing buttons (except the first 'All' button) to prevent duplicates if function runs again
            // While the duplicate listener fix (Step A) solves the main issue, this makes your code robust.
            while (dayContainer.children.length > 2) {
                dayContainer.removeChild(dayContainer.lastChild);
            }
            while (trackContainer.children.length > 2) {
                trackContainer.removeChild(trackContainer.lastChild);
            }

            // Create Day Buttons
            uniqueDays.forEach(day => {
                if (day) {
                    const btn = document.createElement('button');
                    btn.className = 'filter-btn';
                    btn.innerText = day;

                    // --- FIX IS HERE ---
                    btn.type = "button"; // Prevents ASP.NET Postback/Reload
                    // -------------------

                    btn.onclick = () => filterAgenda('day', day, btn);
                    dayContainer.appendChild(btn);
                }
            });

            // Create Track Buttons
            uniqueTracks.forEach(track => {
                if (track) {
                    const btn = document.createElement('button');
                    btn.className = 'filter-btn';
                    btn.innerText = track;

                    // --- FIX IS HERE ---
                    btn.type = "button"; // Prevents ASP.NET Postback/Reload
                    // -------------------

                    btn.onclick = () => filterAgenda('track', track, btn);
                    trackContainer.appendChild(btn);
                }
            });
        }

        function filterAgenda(type, value, clickedBtn) {
            // 1. Update active state visual
            if (clickedBtn) {
                // Remove active class from siblings
                const parent = clickedBtn.parentElement;
                const siblings = parent.getElementsByClassName('filter-btn');
                for (let btn of siblings) {
                    btn.classList.remove('active');
                }
                // Add active class to clicked button
                clickedBtn.classList.add('active');
            } else if (value === 'all') {
                // Handle 'All' button click specifically if passed manually
                const containerId = type === 'day' ? 'dayFilters' : 'trackFilters';
                const container = document.getElementById(containerId);
                const allBtn = container.querySelector('.filter-btn'); // The first button is always 'All'

                // Reset visual active states
                const siblings = container.getElementsByClassName('filter-btn');
                for (let btn of siblings) btn.classList.remove('active');
                allBtn.classList.add('active');
            }

            // 2. Update Logic State
            if (type === 'day') currentDayFilter = value;
            if (type === 'track') currentTrackFilter = value;

            // 3. Filter Data
            const filteredData = allAgendaData.filter(item => {
                const matchDay = currentDayFilter === 'all' || item.Day === currentDayFilter;
                const matchTrack = currentTrackFilter === 'all' || item.Track === currentTrackFilter;
                return matchDay && matchTrack;
            });

            // 4. Re-render grid
            renderAgenda(filteredData);
        }

        function renderAgenda(data) {
            const container = document.getElementById('agendaContainer');

            if (data.length === 0) {
                container.innerHTML = '<p style="text-align:center; grid-column:1/-1; color:#666; padding:20px;">No sessions found for this selection.</p>';
                return;
            }

            let html = '';
            data.forEach(item => {
                html += `
                <div class="agenda-card">
                    <div class="agenda-meta">
                        <span class="agenda-day">${item.Day}</span>
                        <span class="agenda-time"><i class="far fa-clock"></i> ${item.Time}</span>
                    </div>
                    <h3 class="agenda-title">${item.AgendaTitle}</h3>
                    <p class="agenda-brief">${item.AgendaBrief || 'No description available.'}</p>
                    <div class="agenda-footer">
                        <span class="agenda-track">${item.Track}</span>
                    </div>
                </div>
            `;
            });

            container.innerHTML = html;
        }
    </script>
</body>
</html>
