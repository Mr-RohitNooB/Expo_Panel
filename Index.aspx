<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Expo_Panel.Index" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lubricant India Expo 2026</title>
    <link rel="icon" type="image/png" sizes="32x32" href="Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="Images/favicon_io_Lubricant_India_Expo/favicon-16x16.png">
    <link rel="apple-touch-icon" href="Images/favicon_io_Lubricant_India_Expo/apple-touch-icon.png">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
        }

        /* Navbar Styles */
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

        .event-details {
            display: flex;
            justify-content: center;
            gap: 40px;
            margin-top: 40px;
            flex-wrap: wrap;
        }

        .event-detail-item {
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(255,255,255,0.1);
            padding: 15px 25px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }

            .event-detail-item i {
                font-size: 24px;
                color: #D94A2B;
            }

        .cta-button {
            display: inline-block;
            background: linear-gradient(135deg, #D94A2B 0%, #FF6B4A 100%);
            color: #fff;
            padding: 15px 40px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            margin-top: 20px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(217, 74, 43, 0.4);
        }

            .cta-button:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 20px rgba(217, 74, 43, 0.6);
            }

        /* Sections */
        .section {
            padding: 80px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .section-title {
            font-size: 36px;
            text-align: center;
            margin-bottom: 50px;
            color: #1e293b;
            position: relative;
            padding-bottom: 15px;
        }

            .section-title::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 4px;
                background: linear-gradient(135deg, #D94A2B 0%, #FF6B4A 100%);
                border-radius: 2px;
            }

        /* Agenda Preview */
        .agenda-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
        }

        .agenda-card {
            background: #fff;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }

            .agenda-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(217, 74, 43, 0.3);
            }

        .agenda-day {
            font-size: 14px;
            color: #D94A2B;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .agenda-time {
            font-size: 16px;
            color: #64748b;
            margin-bottom: 10px;
        }

        .agenda-title {
            font-size: 20px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 10px;
        }

        .agenda-track {
            display: inline-block;
            background: rgba(217, 74, 43, 0.1);
            color: #D94A2B;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        /* Speakers Section */
        .speakers-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
        }

        .speaker-card {
            background: #fff;
            border-radius: 12px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }

            .speaker-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(217, 74, 43, 0.3);
            }

        .speaker-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #D94A2B 0%, #FF6B4A 100%);
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: #fff;
            font-weight: 600;
        }

        .speaker-name {
            font-size: 20px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 5px;
        }

        .speaker-title {
            font-size: 14px;
            color: #64748b;
            margin-bottom: 10px;
        }

        .speaker-company {
            font-size: 14px;
            color: #D94A2B;
            font-weight: 600;
        }

        /* Venue Section */
        .venue-content {
            background: #fff;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .venue-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }

        .venue-info-item {
            display: flex;
            align-items: flex-start;
            gap: 15px;
        }

            .venue-info-item i {
                font-size: 24px;
                color: #D94A2B;
                margin-top: 5px;
            }

        .venue-info-text h3 {
            font-size: 18px;
            color: #1e293b;
            margin-bottom: 5px;
        }

        .venue-info-text p {
            color: #64748b;
            font-size: 14px;
        }

        /* Footer */
        .footer {
            background: #3D3935;
            color: #fff;
            padding: 40px 20px;
            text-align: center;
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
                transition: color 0.3s ease;
            }

                .footer-links a:hover {
                    color: #D94A2B;
                }

        /* Mobile Responsive */
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
                align-items: center; /* <-- Add this line */
                text-align: center; /* <-- And this line */
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

            .hero h1 {
                font-size: 32px;
            }

            .hero p {
                font-size: 16px;
            }

            .event-details {
                gap: 20px;
            }

            .section-title {
                font-size: 28px;
            }

            .venue-info {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navbar -->
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
                    <li class="nav-item"><a href="#home" class="nav-link">Home</a></li>
                    <li class="nav-item dropdown">
                        <a href="#" class="nav-link">Register <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="User/RegisterExhibitor.aspx">Register as Exhibitor</a>
                            <a href="User/RegisterSpeaker.aspx">Register as Speaker</a>
                            <%--<a href="RegisterAdvisor.aspx">Register as Advisor</a>--%>
                            <%--  <a href="RegisterAgenda.aspx">Register for Agenda</a>--%>
                        </div>
                    </li>
                    <li class="nav-item"><a href="#agenda" class="nav-link">Agenda</a></li>
                    <li class="nav-item"><a href="#speakers" class="nav-link">Speakers</a></li>
                    <li class="nav-item"><a href="#venue" class="nav-link">Venue</a></li>
                    <li class="nav-item"><a href="#contact" class="nav-link">Contact</a></li>
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

        <!-- Hero Section -->
        <section class="hero" id="home">
            <div class="hero-content">
                <h1>Lubricant India Expo 2026</h1>
                <p>Join India's premier lubricant industry event showcasing innovation, sustainability, and the future of lubricant technology</p>
                <div class="event-details">
                    <div class="event-detail-item">
                        <i class="fas fa-calendar-alt"></i>
                        <div>
                            <div><strong>24-26 September 2026</strong></div>
                            <small>3 Days of Innovation</small>
                        </div>
                    </div>
                    <div class="event-detail-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <div>
                            <div><strong>Yashoobhumi</strong></div>
                            <small>New Delhi, India</small>
                        </div>
                    </div>
                    <div class="event-detail-item">
                        <i class="fas fa-users"></i>
                        <div>
                            <div><strong>100+ Speakers</strong></div>
                            <small>Industry Experts</small>
                        </div>
                    </div>
                </div>
                <a href="RegisterExhibitor.aspx" class="cta-button">Register Now</a>
            </div>
        </section>

        <!-- Agenda Section -->
        <section class="section" id="agenda">
            <h2 class="section-title">Event Agenda Highlights</h2>
            <div class="agenda-grid">
                <div class="agenda-card">
                    <%--  <div class="agenda-day">Day 1 - September 24</div>
                    <div class="agenda-time">09:30 - 10:30</div>
                    <div class="agenda-title">Leadership Panel – Global Markets</div>
                    <p style="color: #64748b; font-size: 14px; margin: 15px 0;">The lubricants industry has always been closely impacted by complex political dynamics and macroeconomic fluctuations.</p>--%>
                    <span class="agenda-track">Track 1</span>
                </div>
                <div class="agenda-card">
                    <div class="agenda-day">Day 1 - September 24</div>
                    <%-- <div class="agenda-time">10:45 - 11:45</div>
                    <div class="agenda-title">Driving Innovation in the Lubricants Sector</div>
                    <p style="color: #64748b; font-size: 14px; margin: 15px 0;">As industries demand higher performance, sustainability, and efficiency, lubricant developers are pushing boundaries.</p>--%>
                    <span class="agenda-track">Track 1</span>
                </div>
                <div class="agenda-card">
                    <%--  <div class="agenda-day">Day 1 - September 24</div>
                    <div class="agenda-time">12:00 - 13:00</div>
                    <div class="agenda-title">Evolving Landscape of Rerefined Base Oils</div>
                    <p style="color: #64748b; font-size: 14px; margin: 15px 0;">Sustainability and circular economy goals move to the forefront of the lubricants industry.</p>
                    <span class="agenda-track">Track 1</span>--%>
                </div>
                <div class="agenda-card">
                    <%-- <div class="agenda-day">Day 2 - September 25</div>
                    <div class="agenda-time">09:30 - 10:45</div>
                    <div class="agenda-title">Building a Sustainable Lubricants Sector</div>
                    <p style="color: #64748b; font-size: 14px; margin: 15px 0;">From packaging to product passports, preparing for transformative regulations.</p>
                    <span class="agenda-track">Track 1</span>--%>
                </div>
                <div class="agenda-card">
                    <%--         <div class="agenda-day">Day 2 - September 25</div>
                    <div class="agenda-time">11:15 - 12:30</div>
                    <div class="agenda-title">Avoided Emissions: Product Carbon Handprint</div>
                    <p style="color: #64748b; font-size: 14px; margin: 15px 0;">Focusing on avoided emissions during the use phase of lubricants.</p>
                    <span class="agenda-track">Track 1</span>--%>
                </div>
                <div class="agenda-card">
                    <%--  <div class="agenda-day">Day 3 - September 26</div>
                    <div class="agenda-time">09:30 - 10:30</div>
                    <div class="agenda-title">Phasing out Hazardous Chemicals</div>
                    <p style="color: #64748b; font-size: 14px; margin: 15px 0;">Addressing challenges from regulatory lists of chemicals of concern.</p>
                    <span class="agenda-track">Track 1</span>--%>
                </div>
            </div>
        </section>

        <!-- Speakers Section -->
        <section class="section" id="speakers" style="background: #f8fafc;">
            <h2 class="section-title">Featured Speakers</h2>
            <div class="speakers-grid">
                <div class="speaker-card">
                    <%--  <div class="speaker-avatar">JD</div>
                    <div class="speaker-name">Dr. John Doe</div>
                    <div class="speaker-title">Chief Technology Officer</div>
                    <div class="speaker-company">Lorem Ipsum Corporation</div>--%>
                </div>
                <div class="speaker-card">
                    <%--<div class="speaker-avatar">SM</div>
                    <div class="speaker-name">Sarah Mitchell</div>
                    <div class="speaker-title">VP of Innovation</div>
                    <div class="speaker-company">Dolor Sit Industries</div>--%>
                </div>
                <div class="speaker-card">
                    <%--<div class="speaker-avatar">RJ</div>
                    <div class="speaker-name">Dr. Robert Johnson</div>
                    <div class="speaker-title">Global Director</div>
                    <div class="speaker-company">Amet Solutions</div>--%>
                </div>
                <div class="speaker-card">
                    <%--<div class="speaker-avatar">EC</div>
                    <div class="speaker-name">Emily Chen</div>
                    <div class="speaker-title">Head of Research</div>
                    <div class="speaker-company">Consectetur Labs</div>--%>
                </div>
                <div class="speaker-card">
                    <%--<div class="speaker-avatar">MB</div>
                    <div class="speaker-name">Dr. Michael Brown</div>
                    <div class="speaker-title">President</div>
                    <div class="speaker-company">Adipiscing Technologies</div>--%>
                </div>
                <div class="speaker-card">
                    <%--     <div class="speaker-avatar">LW</div>
                    <div class="speaker-name">Laura Williams</div>
                    <div class="speaker-title">Senior Advisor</div>
                    <div class="speaker-company">Elit Consulting</div>--%>
                </div>
            </div>
        </section>

        <!-- Venue Section -->
        <section class="section" id="venue">
            <h2 class="section-title">Venue Information</h2>
            <div class="venue-content">
                <div class="venue-info">
                    <div class="venue-info-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <div class="venue-info-text">
                            <h3>Location</h3>
                            <p>
                                Yashoobhumi Convention Centre<br>
                                Dwarka, New Delhi<br>
                                India
                            </p>
                        </div>
                    </div>
                    <div class="venue-info-item">
                        <i class="fas fa-clock"></i>
                        <div class="venue-info-text">
                            <h3>Opening Times</h3>
                            <%-- <p><strong>Wednesday, Sept 24:</strong> 9:00 - 17:30<br>
                            <strong>Thursday, Sept 25:</strong> 9:00 - 17:30<br>
                            <strong>Friday, Sept 26:</strong> 9:00 - 15:00</p>--%>
                        </div>
                    </div>
                    <div class="venue-info-item">
                        <i class="fas fa-info-circle"></i>
                        <div class="venue-info-text">
                            <h3>Event Details</h3>
                            <p>3 days of exhibitions, conferences, and networking opportunities with industry leaders from across India and around the globe.</p>
                        </div>
                    </div>
                    <div class="venue-info-item">
                        <i class="fas fa-envelope"></i>
                        <div class="venue-info-text">
                            <h3>Contact</h3>
                            <p>
                                For inquiries and information:<br>
                                <a href="mailto:test@test.com" style="color: #D94A2B;">test@test.com.com</a>
                            </p>
                        </div>
                    </div>
                </div>
                <a href="https://maps.app.goo.gl/pDFdFGjQq9trFb43A" target="_blank" class="cta-button" style="margin-top: 20px;">View on Google Maps</a>
            </div>
        </section>

        <!-- Contact Section -->
        <section class="section" id="contact" style="background: #f8fafc;">
            <h2 class="section-title">Get in Touch</h2>
            <div style="text-align: center; max-width: 600px; margin: 0 auto;">
                <p style="font-size: 18px; color: #64748b; margin-bottom: 30px;">
                    Have questions? Want to become a sponsor? We'd love to hear from you!
                </p>
                <div style="display: flex; justify-content: center; gap: 20px; flex-wrap: wrap;">
                    <a href="mailto:test@.com.com" class="cta-button">Email Us</a>
                    <a href="User/RegisterExhibitor.aspx" class="cta-button" style="background: linear-gradient(135deg, #FF6B4A 0%, #D94A2B 100%);">Become an Exhibitor</a>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer">
            <div class="footer-content">
                <div class="footer-links">
                    <a href="#home">Home</a>
                    <a href="#agenda">Agenda</a>
                    <a href="#speakers">Speakers</a>
                    <a href="#venue">Venue</a>
                    <a href="#">Terms & Conditions</a>
                    <a href="#">Privacy Policy</a>
                </div>
                <p style="margin-top: 20px; opacity: 0.8;">
                    &copy; 2026 Lubricant India Expo. All rights reserved.
                </p>
            </div>
        </footer>
    </form>

    <script>
        // Navbar scroll effect
        window.addEventListener('scroll', function () {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });

        // Mobile menu toggle
        function toggleMobileMenu() {
            const navMenu = document.getElementById('navMenu');
            navMenu.classList.toggle('active');
        }

        // Smooth scrolling
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                const href = this.getAttribute('href');
                if (href !== '#') {
                    e.preventDefault();
                    const target = document.querySelector(href);
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                        // Close mobile menu if open
                        document.getElementById('navMenu').classList.remove('active');
                    }
                }
            });
        });

        document.querySelectorAll('.nav-item.dropdown > .nav-link').forEach(dropdownLink => {
            dropdownLink.addEventListener('click', function (e) {

                // Check if we are in mobile view by seeing if the hamburger button is visible
                const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
                const isMobileView = window.getComputedStyle(mobileMenuToggle).display === 'block';

                if (isMobileView) {
                    // This is a mobile click! Stop the link from trying to navigate.
                    e.preventDefault();

                    // Get the dropdown menu itself (it's the next element after the link)
                    const dropdownContent = this.nextElementSibling;

                    // Manually toggle its display
                    if (dropdownContent.style.display === 'block') {
                        dropdownContent.style.display = 'none';
                    } else {
                        dropdownContent.style.display = 'block';
                    }
                }
                // If we're not in mobile view, this code does nothing, 
                // and the desktop CSS :hover continues to work as normal.
            });
        });

        document.addEventListener("DOMContentLoaded", function () {
            loadDynamicData();
        });

        async function loadDynamicData() {
            try {
                // 1. Call our C# WebMethod
                const response = await fetch('Index.aspx/GetPublicAgendaDetails', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=utf-8'
                    },
                    body: JSON.stringify({}) // Send an empty body
                });

                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }

                const data = await response.json();
                const agendaAndSpeakerData = data.d; // ASP.NET wraps the result in '.d'

                // 2. Get the containers where we will put our new HTML
                const agendaGrid = document.querySelector('.agenda-grid');
                const speakersGrid = document.querySelector('.speakers-grid');

                // 3. Create empty strings to build our HTML
                let agendaHtml = '';
                let speakersHtml = '';

                // A helper set to avoid duplicate speakers
                const speakerIds = new Set();

                // 4. Loop through every item returned from the database
                agendaAndSpeakerData.forEach(item => {

                    // --- Build the Agenda Card HTML ---
                    agendaHtml += `
                        <div class="agenda-card">
                            <div class="agenda-day">${item.Day}</div>
                            <div class="agenda-time">${item.Time}</div>
                            <div class="agenda-title">${item.AgendaTitle}</div>
                            <p style="color: #64748b; font-size: 14px; margin: 15px 0;">
                                ${item.AgendaBrief}
                            </p>
                            <span class="agenda-track">${item.Track}</span>
                        </div>
                    `;

                    // --- Build the Speaker Card HTML (if there is a speaker) ---
                    // Check if SpeakerID is not null and we haven't added this speaker yet
                    if (item.SpeakerID > 0 && !speakerIds.has(item.SpeakerID)) {

                        speakersHtml += `
                            <div class="speaker-card">
                                <div class="speaker-avatar">
                                    ${item.SpeakerPhoto ?
                                `<img src="${item.SpeakerPhoto}" alt="${item.SpeakerName}" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">` :
                                getInitials(item.SpeakerName)
                            }
                                </div>
                                <div class="speaker-name">${item.SpeakerName}</div>
                                <div class="speaker-title">${item.SpeakerDesignation}</div>
                                <div class="speaker-company">${item.SpeakerCompany}</div>
                            </div>
                        `;

                        // Add this speaker's ID to the set so we don't add them again
                        speakerIds.add(item.SpeakerID);
                    }
                });

                // 5. Inject the new HTML into the page
                agendaGrid.innerHTML = agendaHtml;
                speakersGrid.innerHTML = speakersHtml;

                // If no agenda/speakers were found, show a message
                if (agendaHtml === '') {
                    agendaGrid.innerHTML = '<p>Agenda details will be available soon.</p>';
                }
                if (speakersHtml === '') {
                    speakersGrid.innerHTML = '<p>Speaker details will be available soon.</p>';
                }

            } catch (error) {
                console.error('Error loading dynamic data:', error);
                // Show a friendly error on the page
                document.querySelector('.agenda-grid').innerHTML = '<p>Could not load agenda. Please try again later.</p>';
                document.querySelector('.speakers-grid').innerHTML = '<p>Could not load speakers. Please try again later.</p>';
            }
        }

        // Helper function to get initials from a name
        function getInitials(name) {
            if (!name) return '';
            const parts = name.split(' ');
            let initials = parts[0] ? parts[0][0] : '';
            if (parts.length > 1) {
                initials += parts[parts.length - 1][0];
            }
            return initials.toUpperCase();
        }
    </script>
</body>
</html>
