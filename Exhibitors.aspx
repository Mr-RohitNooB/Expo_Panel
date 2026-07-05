<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Exhibitors.aspx.cs" Inherits="Expo_Panel.Exhibitors" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exhibitors | Lubricant India Expo 2026</title>

    <!-- Favicons -->
    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" />
    <link rel="icon" type="image/png" sizes="16x16" href="/Images/favicon_io_Lubricant_India_Expo/favicon-16x16.png" />
    <link rel="apple-touch-icon" href="/Images/favicon_io_Lubricant_India_Expo/apple-touch-icon.png" />
    <link rel="shortcut icon" href="/Images/favicon_io_Lubricant_India_Expo/favicon.ico" />

    <!-- Bootstrap & FontAwesome -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-iso@5.3.0/dist/css/bootstrap-iso.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* --- GLOBAL RESET --- */
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

        /* Navbar Styles */
        .navbar {
            background: #ffffff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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
            margin-top: 0px;
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

        /* Hero Section */
        .hero {
            background: linear-gradient(135deg, #3D3935 0%, #5C5550 50%, #3D3935 100%);
            padding: 140px 20px 80px;
            text-align: center;
            color: #fff;
            position: relative;
            overflow: hidden;
        }

            .hero::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><defs><pattern id="grid" width="100" height="100" patternUnits="userSpaceOnUse"><path d="M 100 0 L 0 0 0 100" fill="none" stroke="rgba(217,74,43,0.1)" stroke-width="1"/></pattern></defs><rect width="100%" height="100%" fill="url(%23grid)"/></svg>');
                opacity: 0.5;
            }

        .hero-content {
            position: relative;
            z-index: 1;
            max-width: 900px;
            margin: 0 auto;
        }

        .hero h1 {
            font-size: 48px;
            margin-bottom: 20px;
            background: linear-gradient(135deg, #D94A2B 0%, #FF6B4A 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero p {
            font-size: 20px;
            margin-bottom: 30px;
            opacity: 0.9;
        }

        /* --- ALPHABET FILTER --- */
        .filter-dock {
            background: #fff;
            padding: 15px 25px;
            border-radius: 50px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 5px;
            max-width: 900px;
            margin: 0 auto 50px auto;
            position: relative;
            z-index: 10;
        }

        .alpha-btn {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: transparent;
            color: #64748b;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 13px;
        }

            .alpha-btn:hover {
                background: #f1f5f9;
                color: #D94A2B;
                transform: scale(1.1);
            }

            .alpha-btn.active {
                background: #D94A2B;
                color: #fff;
                box-shadow: 0 4px 10px rgba(217, 74, 43, 0.4);
            }

        /* --- CARDS --- */
        .ex-card {
            background: #fff;
            border: none;
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.165, 0.84, 0.44, 1);
            position: relative;
            height: 100%;
            display: flex;
            flex-direction: column;
            text-decoration: none;
            box-shadow: 0 2px 5px rgba(0,0,0,0.02);
            border: 1px solid #f0f0f0;
            /* --- NEW LINES ADDED --- */
            max-width: 300px; /* Limits the card width like the reference */
            width: 100%; /* Fills space up to 300px */
            margin: 0 auto; /* Centers the card if the grid column is wider */
        }

            .ex-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 15px 30px rgba(0,0,0,0.1);
                border-color: rgba(217, 74, 43, 0.2);
            }

        .card-bar {
            height: 6px;
            background: #e2e8f0;
            width: 100%;
            transition: background 0.3s;
        }

        .ex-card:hover .card-bar {
            background: #D94A2B;
        }

        .card-body-custom {
            padding: 25px;
            flex-grow: 1;
            text-align: center;
        }

        .logo-box {
            height: 90px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }

            .logo-box img {
                max-height: 80px;
                max-width: 140px;
                object-fit: contain;
                filter: grayscale(100%);
                transition: filter 0.3s;
                opacity: 0.8;
            }

        .ex-card:hover .logo-box img {
            filter: grayscale(0%);
            opacity: 1;
        }

        .co-name {
            font-size: 17px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 5px;
            line-height: 1.3;
        }

        .co-loc {
            font-size: 13px;
            color: #94a3b8;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 15px;
        }

        .card-actions {
            margin-top: auto;
            border-top: 1px dashed #e2e8f0;
            padding: 15px 20px;
            background: #fafafa;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .booth-badge {
            background: #fff;
            border: 1px solid #e2e8f0;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 700;
            color: #555;
            display: flex;
            gap: 5px;
            align-items: center;
        }

            .booth-badge i {
                color: #D94A2B;
                font-size: 10px;
            }

        .btn-meet-req {
            background: transparent;
            border: 1px solid #D94A2B;
            color: #D94A2B;
            font-size: 11px;
            font-weight: 700;
            padding: 5px 12px;
            border-radius: 50px;
            text-transform: uppercase;
            transition: all 0.2s;
        }

        .ex-card:hover .btn-meet-req {
            background: #D94A2B;
            color: #fff;
        }

        .bookmark-icon {
            position: absolute;
            top: 15px;
            right: 15px;
            color: #cbd5e1;
            font-size: 16px;
            cursor: pointer;
            transition: color 0.2s;
        }

            .bookmark-icon:hover {
                color: #D94A2B;
            }

        /* --- FOOTER (Exact match from Index.aspx) --- */
        .footer {
            background: #3D3935;
            color: #fff;
            padding: 40px 20px 40px;
            text-align: center;
            margin-top: 60px;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
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
                opacity: 0.8;
                transition: opacity 0.3s;
                font-size: 14px;
            }

                .footer-links a:hover {
                    opacity: 1;
                    color: #D94A2B;
                }

        .footer p {
            opacity: 0.5;
            font-size: 13px;
        }

        /* Loader */
        .spinner-container {
            grid-column: 1/-1;
            text-align: center;
            padding: 50px;
            color: #64748b;
        }
        /* --- PAGE HEADER (Matches Conference.aspx) --- */
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

            .hero h1, .page-header h1 {
                font-size: 32px;
            }

            .hero p, .page-header p {
                font-size: 16px;
            }

            .event-details {
                gap: 20px;
            }

            .section-title {
                font-size: 28px;
            }

            .filter-dock {
                padding: 10px 15px;
                gap: 3px;
            }

            .alpha-btn {
                width: 28px;
                height: 28px;
                font-size: 12px;
            }

            .row {
                gap: 1rem !important;
            }

            .ex-card {
                margin-bottom: 15px;
            }

            .co-name {
                font-size: 15px;
            }

            .card-actions {
                flex-direction: column;
                gap: 8px;
                align-items: stretch;
            }

            .booth-badge {
                justify-content: center;
            }
        }

        /* Add this to your <style> block */
        .custom-exhibitor-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 30px;
            width: 100%;
            padding-bottom: 50px;
            /* --- ADDED THESE LINES TO FIX ALIGNMENT --- */
            max-width: 1200px; /* Matches your Navbar width */
            margin: 0 auto; /* Centers the grid container on the screen */
            padding: 0 20px; /* Adds the left/right spacing you wanted */
        }


        /* Ensure the spinner centers correctly in the grid */
        .spinner-wrapper {
            grid-column: 1 / -1; /* Span all columns */
            display: flex;
            justify-content: center;
            padding: 40px;
            width: 100%;
        }

        .bookmark-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 10000;
            display: flex;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(2px);
        }

        .bookmark-modal {
            background: #fff;
            width: 90%;
            max-width: 400px;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
            animation: fadeIn 0.3s ease-out;
        }

        .bookmark-icon-box {
            width: 70px;
            height: 70px;
            background: rgba(217, 74, 43, 0.1);
            color: #D94A2B;
            font-size: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px auto;
        }

        .bookmark-modal h3 {
            color: #1e293b;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .bookmark-modal p {
            color: #64748b;
            font-size: 15px;
            line-height: 1.5;
            margin-bottom: 25px;
        }

        .bookmark-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        .btn-cancel {
            background: #f1f5f9;
            color: #64748b;
            border: none;
            padding: 10px 20px;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
        }

        .btn-login-theme {
            background: linear-gradient(135deg, #D94A2B 0%, #FF6B4A 100%);
            color: white;
            text-decoration: none;
            border: none;
            padding: 10px 25px;
            border-radius: 50px;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(217, 74, 43, 0.3);
        }

            .btn-login-theme:hover {
                color: #fff;
                transform: translateY(-2px);
            }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- NAVBAR -->
        <nav class="navbar" id="navbar">
            <div class="nav-container">
                <div class="logo">
                    <a href="Index.aspx">
                        <img src="Images/Expo_logo.png" alt="Lubricant India Expo 2026">
                    </a>
                </div>
                <button type="button" class="mobile-menu-toggle" onclick="toggleMobileMenu()">
                    <i class="fas fa-bars"></i>
                </button>
                <ul class="nav-menu" id="navMenu">
                    <li class="nav-item"><a href="Index.aspx#home" class="nav-link">Home</a></li>
                    <li class="nav-item dropdown">
                        <a href="#" class="nav-link">Register <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="User/RegisterExhibitor.aspx">Register as Exhibitor</a>
                            <a href="User/RegisterSpeaker.aspx">Register as Speaker</a>
                        </div>
                    </li>
                    <li class="nav-item"><a href="Conference.aspx" class="nav-link">Conference</a></li>
                    <li class="nav-item"><a href="Index.aspx#speakers" class="nav-link">Speakers</a></li>
                    <!-- Active Link -->
                    <li class="nav-item"><a href="Exhibitors.aspx" class="nav-link" style="color: #D94A2B; background: rgba(217,74,43,0.1);">Exhibitors</a></li>
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

        <!-- HEADER (Using Index.aspx Hero Style) -->
        <header class="page-header">
            <h1>Our Exhibitors</h1>
            <p>Discover the industry leaders showcasing at Lubricant India Expo 2026</p>
        </header>
        <div class="bootstrap-iso">

            <div class="container" style="min-height: 60vh;">

                <!-- ALPHABET FILTER -->
                <div class="filter-dock" id="alphaContainer">
                    <a class="alpha-btn active" onclick="filterByAlpha('ALL', this)">All</a>
                </div>

                <!-- EXHIBITOR GRID -->
                <div class="custom-exhibitor-grid" id="exhibitorGrid">
                    <div class="spinner-wrapper">
                        <div style="border: 4px solid #f3f3f3; border-top: 4px solid #D94A2B; border-radius: 50%; width: 40px; height: 40px; animation: spin 1s linear infinite;"></div>
                        <div style="margin-left: 15px; align-self: center; color: #666;">Loading Directory...</div>
                    </div>
                </div>

            </div>
        </div>

        <!-- FOOTER -->
        <footer class="footer">
            <div class="footer-content">
                <div class="footer-links">
                    <a href="Index.aspx">Home</a>
                    <a href="Conference.aspx">Conference</a>
                    <a href="Index.aspx#speakers">Speakers</a>
                    <a href="Exhibitors.aspx">Exhibitors</a>
                    <a href="TermsConditions.aspx">Terms & Conditions</a>
                    <a href="PrivacyPolicy.aspx">Privacy Policy</a>
                    <a href="RefundPolicy.aspx">Refund Policy</a>
                </div>
                <p>© 2025 Lubricant India Expo. All rights reserved.</p>
            </div>
        </footer>

    </form>

    <div id="bookmarkPopup" class="bookmark-overlay" style="display: none;">
        <div class="bookmark-modal">
            <div class="bookmark-icon-box">
                <i class="fas fa-bookmark"></i>
            </div>
            <h3>Bookmark Exhibitors</h3>
            <p>Please login to your <b>Visitor Dashboard</b> to bookmark exhibitors .</p>
            <div class="bookmark-actions">
                <button type="button" class="btn-cancel" onclick="closeBookmarkPopup()">Cancel</button>
                <a href="User/VisitorLogin.aspx" class="btn-login-theme">Login to Dashboard</a>
            </div>
        </div>
    </div>

    <!-- SCRIPTS -->
    <script>
        // Replace the JavaScript section in Exhibitors.aspx with this enhanced version

        // Navbar Scroll Effect
        window.addEventListener('scroll', function () {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 50) navbar.classList.add('scrolled');
            else navbar.classList.remove('scrolled');
        });

        // Mobile Menu Toggle
        function toggleMobileMenu() {
            const navMenu = document.getElementById('navMenu');
            navMenu.classList.toggle('active');
        }

        // Mobile Dropdown Handler
        document.querySelectorAll('.nav-item.dropdown > .nav-link').forEach(dropdownLink => {
            dropdownLink.addEventListener('click', function (e) {
                const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
                const isMobileView = window.getComputedStyle(mobileMenuToggle).display === 'block';

                if (isMobileView) {
                    e.preventDefault();
                    const dropdownContent = this.nextElementSibling;
                    dropdownContent.style.display = (dropdownContent.style.display === 'block') ? 'none' : 'block';
                }
            });
        });

        // Close mobile menu when clicking outside
        document.addEventListener('click', function (e) {
            const navMenu = document.getElementById('navMenu');
            const mobileToggle = document.querySelector('.mobile-menu-toggle');
            const navbar = document.getElementById('navbar');

            if (!navbar.contains(e.target) && navMenu.classList.contains('active')) {
                navMenu.classList.remove('active');
            }
        });

        // Alphabet Generation
        const alphaBox = document.getElementById('alphaContainer');
        for (let i = 65; i <= 90; i++) {
            let letter = String.fromCharCode(i);
            let btn = document.createElement('a');
            btn.className = 'alpha-btn';
            btn.innerText = letter;
            btn.onclick = function () { filterByAlpha(letter, this); };
            alphaBox.appendChild(btn);
        }

        let allData = [];

        // Load Data
        document.addEventListener("DOMContentLoaded", function () {
            fetch('Exhibitors.aspx/GetExhibitorsList', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' }
            })
                .then(res => res.json())
                .then(data => {
                    allData = data.d;
                    renderGrid(allData);
                })
                .catch(err => {
                    document.getElementById('exhibitorGrid').innerHTML = '<p class="text-center w-100 text-danger">Failed to load exhibitors.</p>';
                    console.error(err);
                });
        });

        // Render Grid
        function renderGrid(list) {
            const grid = document.getElementById('exhibitorGrid');
            grid.innerHTML = '';

            if (!list || list.length === 0) {
                grid.innerHTML = '<div class="spinner-container">No exhibitors found matching criteria.</div>';
                return;
            }

            list.forEach(ex => {
                let logo = ex.LogoPath ? ex.LogoPath.replace('~', '') : 'Images/no-logo.png';
                let location = [ex.City, ex.Country].filter(Boolean).join(', ');
                if (!location) location = "India";
                let booth = ex.BoothNo ? ex.BoothNo : 'TBA';

                // CHANGE: Removed <div class="col"> wrapper
                // The <a> tag now sits directly in the grid
                let html = `
    <a href="ExhibitorDetails.aspx?id=${ex.ExhibitorID}" class="ex-card">
        <div class="card-bar"></div>
        
        <i class="far fa-bookmark bookmark-icon" 
           title="Bookmark this exhibitor"
           onclick="event.preventDefault(); event.stopPropagation(); showBookmarkPopup();">
        </i>
        
        <div class="card-body-custom">
            <div class="logo-box">
                <img src="${logo}" alt="${ex.Company}">
            </div>
            <div class="co-name">${ex.Company}</div>
            <div class="co-loc"><i class="fas fa-map-marker-alt me-1"></i>${location}</div>
        </div>

        <div class="card-actions">
            <div class="booth-badge" title="Location">
                <i class="fas fa-store"></i> BOOTH NO: ${booth}
            </div>
            <div class="btn-meet-req">Contact</div>
        </div>
    </a>`;

                grid.innerHTML += html;
            });
        }

        // Filter Logic
        function filterByAlpha(char, btn) {
            document.querySelectorAll('.alpha-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            if (char === 'ALL') {
                renderGrid(allData);
            } else {
                const filtered = allData.filter(ex => ex.Company.toUpperCase().startsWith(char));
                renderGrid(filtered);
            }
        }

        function showBookmarkPopup() {
            document.getElementById('bookmarkPopup').style.display = 'flex';
        }
        function closeBookmarkPopup() {
            document.getElementById('bookmarkPopup').style.display = 'none';
        }
        // Close on outside click
        window.onclick = function (e) {
            if (e.target == document.getElementById('bookmarkPopup')) {
                closeBookmarkPopup();
            }
        }
    </script>
</body>
</html>
