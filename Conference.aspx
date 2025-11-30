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
            border-radius: 16px; /* Softer corners */
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.04); /* Softer, premium shadow */
            transition: all 0.3s ease;
            border-top: 5px solid #D94A2B; /* Top accent instead of left */
            /* FLEXBOX MAGIC FOR EQUAL HEIGHT */
            display: flex;
            flex-direction: column;
            height: 100%;
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }

            .agenda-card:hover {
                transform: translateY(-7px);
                box-shadow: 0 20px 40px rgba(217, 74, 43, 0.15);
            }

        .agenda-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            font-size: 0.85rem;
            color: #888;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        .agenda-day {
            color: #D94A2B;
            background: rgba(217, 74, 43, 0.08);
            padding: 4px 10px;
            border-radius: 20px;
        }

        .agenda-title {
            font-size: 1.35rem; /* Slightly larger */
            font-weight: 800;
            color: #2d3748;
            margin-bottom: 12px;
            line-height: 1.3;
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
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 25px;
            /* THIS IS KEY: Pushes footer to bottom */
            flex-grow: 1;
        }

        .agenda-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto;
        }

        .card-footer-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto; /* Ensures it stays at the bottom */
            padding-top: 20px;
            border-top: 1px solid #f1f5f9; /* Subtle separator */
        }

        .agenda-track {
            background: #f8fafc;
            color: #64748b;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
            border: 1px solid #e2e8f0;
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

        /* --- MOBILE ADJUSTMENTS --- */
        @media (max-width: 768px) {
            .filter-container {
                padding: 10px;
            }

            .filter-group {
                display: flex;
                flex-direction: row; /* Side-by-side layout */
                flex-wrap: nowrap; /* <--- THIS IS THE FIX: Forces single line */
                overflow-x: auto; /* Enables horizontal scrolling */
                gap: 10px; /* Space between buttons */
                padding-bottom: 5px;
                align-items: center;
                /* Smooth scrolling */
                -webkit-overflow-scrolling: touch;
                scrollbar-width: none;
            }

                /* Hide scrollbar */
                .filter-group::-webkit-scrollbar {
                    display: none;
                }

            /* Hide text labels on mobile */
            .filter-label {
                display: none;
            }

            .filter-btn {
                flex: 0 0 auto; /* Prevents buttons from squishing */
                width: auto;
                padding: 8px 16px;
                white-space: nowrap; /* Keeps text inside button on one line */
            }
        }

        /* Button in the card */
        .btn-view-details {
            /* Reset generic button styles */
            background: transparent;
            border: 2px solid #D94A2B;
            color: #D94A2B;
            padding: 8px 20px;
            border-radius: 50px; /* Pill shape */
            font-weight: 700;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

            .btn-view-details:hover {
                background: #D94A2B;
                color: #fff;
                box-shadow: 0 4px 12px rgba(217, 74, 43, 0.3);
            }

        /* --- PREMIUM MODAL STYLES --- */
        .modal-overlay {
            display: none; /* Hidden by default */
            position: fixed;
            z-index: 3000; /* High z-index to sit on top of navbar */
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.75); /* Darker background for focus */
            backdrop-filter: blur(4px); /* Modern blur effect */
            justify-content: center;
            align-items: center; /* Centers modal vertically & horizontally */
            padding: 20px; /* Prevents modal from touching screen edges */
            animation: fadeIn 0.2s ease-out;
        }

        .modal-content {
            background: #fff;
            border-radius: 16px;
            width: 100%;
            max-width: 600px; /* Desktop max-width */
            max-height: 85vh; /* Prevents it from being taller than screen */
            display: flex;
            flex-direction: column; /* Important for scrolling body */
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            position: relative;
            animation: slideUp 0.3s ease-out;
        }

        @keyframes slideUp {
            from {
                transform: translateY(20px);
                opacity: 0;
            }

            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        /* --- HEADER: Compact & Fixed --- */
        .modal-header {
            background: #fff;
            border-bottom: 1px solid #f1f5f9;
            padding: 20px 25px;
            display: flex;
            justify-content: space-between;
            align-items: start;
            border-radius: 16px 16px 0 0;
            flex-shrink: 0; /* Prevents header from shrinking */
        }

            .modal-header h2 {
                margin: 0;
                font-size: 1.25rem;
                color: #1a202c;
                font-weight: 700;
                line-height: 1.4;
                padding-right: 15px;
            }

        .close-modal {
            background: #f1f5f9;
            border: none;
            color: #64748b;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            font-size: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
            flex-shrink: 0;
        }

            .close-modal:hover {
                background: #e2e8f0;
                color: #D94A2B;
            }

        /* --- BODY: Scrollable --- */
        .modal-body {
            padding: 25px;
            overflow-y: auto; /* Enables scrolling inside modal */
            -webkit-overflow-scrolling: touch; /* Smooth scroll on iOS */
        }

        /* Meta Tags */
        .modal-meta-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
        }

        .meta-tag {
            background: #f1f5f9;
            color: #333;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: bold;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Pretty Badges in Modal */
        .meta-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            white-space: nowrap; /* Prevents text wrapping inside badge */
        }

        /* Badge Colors */
        .badge-day {
            background: #FFF5F5;
            color: #C53030;
            border: 1px solid #FEB2B2;
        }

        .badge-time {
            background: #EBF8FF;
            color: #2B6CB0;
            border: 1px solid #BEE3F8;
        }

        .badge-track {
            background: #F0FFF4;
            color: #2F855A;
            border: 1px solid #9AE6B4;
        }

        #modalSynopsis {
            font-size: 1rem;
            line-height: 1.7;
            color: #4a5568;
            margin: 0;
        }

        /* --- MOBILE OPTIMIZATIONS (The Critical Part) --- */
        @media (max-width: 600px) {
            .modal-overlay {
                padding: 10px; /* Smaller edge gap */
                align-items: flex-end; /* Bottom sheet style on mobile (optional, or keep center) */
            }

            .modal-content {
                max-height: 80vh; /* Leaves room at top */
                border-radius: 16px 16px 0 0; /* Rounded top only if bottom sheet style */
                /* If you prefer centered floating modal, remove align-items:flex-end above and keep radius 16px */
            }

            .modal-header {
                padding: 15px 20px; /* Compact header */
            }

                .modal-header h2 {
                    font-size: 1.1rem; /* Smaller title */
                }

            .modal-body {
                padding: 20px; /* Compact body padding */
            }

            .meta-badge {
                font-size: 0.75rem; /* Smaller badges */
                padding: 4px 10px;
                flex-grow: 1; /* Badges stretch to fill space on mobile */
                justify-content: center;
            }

            #modalSynopsis {
                font-size: 0.95rem; /* Readable but compact text */
            }
        }

        /* --- SEPARATE BRIEF & SYNOPSIS STYLES --- */
        .modal-section-label {
            display: block;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #D94A2B; /* Brand Color */
            font-weight: 800;
            margin-bottom: 8px;
            margin-top: 20px;
        }

        .brief-box {
            background: #fff5f5; /* Very light red/pink background */
            border-left: 4px solid #D94A2B;
            padding: 15px;
            border-radius: 0 8px 8px 0;
            margin-bottom: 10px;
        }

        .text-brief {
            font-size: 0.95rem;
            color: #2d3748;
            font-weight: 600; /* Slightly bolder to show importance */
            font-style: italic;
            margin: 0;
            line-height: 1.6;
        }

        .text-synopsis {
            font-size: 1rem;
            color: #4a5568;
            line-height: 1.8;
            margin-top: 5px;
            white-space: pre-line; /* Preserves paragraphs */
        }

        /* Remove top margin for the first label */
        .modal-section-label:first-of-type {
            margin-top: 0;
        }

        /* --- BUTTON GROUP STYLES --- */
        .action-group {
            display: flex;
            gap: 10px; /* Space between the two buttons */
            align-items: center;
        }

        /* 1. Register Button (Primary - Filled) */
        .btn-register {
            background: #D94A2B;
            color: #fff;
            border: 2px solid #D94A2B;
            padding: 8px 16px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.85rem;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            box-shadow: 0 4px 6px rgba(217, 74, 43, 0.2);
        }

            .btn-register:hover {
                background: #b93c22;
                border-color: #b93c22;
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(217, 74, 43, 0.3);
                color: #fff;
            }

        /* 2. View Details Button (Secondary - Outlined/Subtle) */
        .btn-view-details {
            background: transparent;
            /* Changed to Gray to make it look 'Secondary' */
            border: 2px solid #cbd5e1;
            color: #64748b;
            padding: 8px 16px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

            .btn-view-details:hover {
                border-color: #D94A2B;
                color: #D94A2B;
                background: rgba(217, 74, 43, 0.05);
            }

        /* Mobile Adjustment: Stack buttons if screen is too small */
        @media (max-width: 480px) {
            .card-footer-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .action-group {
                width: 100%;
                justify-content: space-between;
            }
        }

        /* --- SPEAKER LIST MODAL STYLES --- */
        .session-speakers-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
            padding-top: 10px;
        }

        .modal-speaker-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background: #fff;
            transition: all 0.2s ease;
        }

            .modal-speaker-item:hover {
                background: #f8fafc;
                border-color: #cbd5e1;
                transform: translateX(5px); /* Subtle movement effect */
            }

        .modal-speaker-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #D94A2B; /* Brand Color Border */
            flex-shrink: 0;
        }

        .modal-speaker-placeholder {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: #f1f5f9;
            color: #64748b;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.2rem;
            border: 2px solid #e2e8f0;
            flex-shrink: 0;
        }

        .modal-speaker-info {
            flex-grow: 1;
        }

        .modal-speaker-name {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 2px;
        }

        .modal-speaker-role {
            font-size: 0.9rem;
            color: #D94A2B; /* Brand Color */
            font-weight: 600;
            line-height: 1.3;
        }

        .modal-speaker-company {
            font-size: 0.85rem;
            color: #64748b;
            margin-top: 2px;
        }

        /* --- SPEAKER PROFILE MODAL STYLES --- */
        .modal-body-grid {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 30px;
            padding: 30px;
        }

        .modal-sidebar {
            text-align: center;
        }

        .speaker-avatar-container {
            width: 180px;
            height: 180px;
            margin: 0 auto 15px;
            position: relative;
        }

        .modal-profile-img-circle {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #fff;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .modal-company-logo-circle {
            position: absolute;
            bottom: 0;
            right: 0;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: contain;
            background: #fff;
            border: 2px solid #f1f5f9;
            padding: 4px;
        }

        .modal-main-info h2 {
            font-size: 1.8rem;
            color: #1e293b;
            margin-bottom: 5px;
        }

        .modal-designation {
            font-size: 1.1rem;
            color: #D94A2B;
            font-weight: 600;
            margin-bottom: 10px;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .modal-body-grid {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .modal-main-info {
                text-align: center;
            }

                .modal-main-info h2 {
                    font-size: 1.5rem;
                }
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

        <div id="detailsModal" class="modal-overlay" style="display: none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitle">Session Title</h2>
                    <button type="button" class="close-modal" onclick="closeModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="modal-meta-row">
                        <span id="modalDay"></span>
                        <span id="modalTime"></span>
                        <span id="modalTrack"></span>
                    </div>

                    <span class="modal-section-label">Brief Overview</span>
                    <div class="brief-box">
                        <p id="modalBrief" class="text-brief"></p>
                    </div>

                    <span class="modal-section-label">Full Session Details</span>
                    <p id="modalSynopsis" class="text-synopsis"></p>
                </div>
            </div>
        </div>
        <div id="sessionSpeakersModal" class="modal-overlay" style="display: none;">
            <div class="modal-content" style="max-width: 500px;">
                <div class="modal-header">
                    <h2>Session Speakers</h2>
                    <button type="button" class="close-modal" onclick="closeSessionSpeakersModal()">&times;</button>
                </div>

                <div class="modal-body">
                    <div id="sessionSpeakersList" class="session-speakers-list">
                    </div>
                </div>

            </div>
        </div>
        <div id="speakerProfileModal" class="modal-overlay" style="display: none;">
            <div class="modal-content" style="max-width: 800px; position: relative;">

                <button type="button" class="close-modal" onclick="closeSpeakerProfile()"
                    style="position: absolute; right: 25px; top: 25px; z-index: 10; width: 35px; height: 35px; font-size: 24px;">
                    &times;
                </button>

                <div class="modal-body-grid">
                    <div class="modal-sidebar">
                        <div class="speaker-avatar-container">
                            <img id="profPhoto" src="" class="modal-profile-img-circle">
                            <img id="profLogo" src="" class="modal-company-logo-circle" style="display: none;">
                        </div>
                        <h4 id="profCompany" style="color: #D94A2B; font-weight: 700; margin-bottom: 15px;"></h4>

                        <a id="profLinkedIn" href="#" target="_blank" style="display: none; padding: 8px 25px; background-color: #0077b5; color: white; border-radius: 50px; text-decoration: none; font-weight: 600; font-size: 13px;">
                            <i class="fab fa-linkedin" style="margin-right: 5px;"></i>Connect
                        </a>
                    </div>

                    <div class="modal-main-info">
                        <h2 id="profName"></h2>
                        <p id="profDesignation" class="modal-designation"></p>

                        <hr style="border: 0; height: 1px; background: #e2e8f0; margin: 20px 0;">

                        <h5 style="color: #1e293b; font-size: 14px; font-weight: 700; text-transform: uppercase; margin-bottom: 10px;">Professional Bio</h5>
                        <p id="profBio" style="line-height: 1.6; color: #4a5568;"></p>
                    </div>
                </div>
            </div>
        </div>

        <footer class="footer">
            <div class="footer-content">
                <div class="footer-links">
                    <a href="#home">Home</a>
                    <a href="Conference.aspx">Conference</a>
                    <a href="#speakers">Speakers</a>
                    <a href="Exhibitors.aspx">Exhibitors</a>
                    <a href="TermsConditions.aspx">Terms & Conditions</a>
                    <a href="PrivacyPolicy.aspx">Privacy Policy</a>
                </div>
                <p style="margin-top: 20px; opacity: 0.8;">
                    © 2025 Lubricant India Expo. All rights reserved.
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

            // Clear existing buttons (except the first 'All' button)
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
                    btn.type = "button"; // Prevents Postback
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
                    btn.type = "button"; // Prevents Postback
                    btn.onclick = () => filterAgenda('track', track, btn);
                    trackContainer.appendChild(btn);
                }
            });
        }

        function filterAgenda(type, value, clickedBtn) {
            // 1. Update active state visual
            if (clickedBtn) {
                const parent = clickedBtn.parentElement;
                const siblings = parent.getElementsByClassName('filter-btn');
                for (let btn of siblings) {
                    btn.classList.remove('active');
                }
                clickedBtn.classList.add('active');
            } else if (value === 'all') {
                const containerId = type === 'day' ? 'dayFilters' : 'trackFilters';
                const container = document.getElementById(containerId);
                const allBtn = container.querySelector('.filter-btn');
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
        <div class="agenda-card" onclick="openModal(${item.AgendaID})">
            
            <div class="agenda-meta">
                <span class="agenda-day">${item.Day}</span>
                <span class="agenda-track" style="font-size: 0.75rem; padding: 4px 8px;">${item.Track}</span>
                <span class="agenda-time"><i class="far fa-clock"></i> ${item.Time}</span>
            </div>
             
            <h3 class="agenda-title">${item.AgendaTitle}</h3>
            
            <div class="card-footer-row" style="justify-content: center;">
                <div class="action-group">
                    
                    <button type="button" class="btn-view-details" onclick="event.stopPropagation(); loadSessionSpeakers(${item.AgendaID})" title="View Speakers">
    <i class="fas fa-users"></i> View Speakers
</button>

                    <a href="User/RegisterSpeaker.aspx" class="btn-register" onclick="event.stopPropagation()">
                        Register Now <i class="fas fa-arrow-right" style="margin-left:5px;"></i>
                    </a>

                </div>
            </div>
        </div>`;
            });
            container.innerHTML = html;
        }
        // --- MODAL FUNCTIONS (FIXED: Moved outside renderAgenda) ---

        function openModal(id) {
            const item = allAgendaData.find(x => x.AgendaID === id);

            if (item) {
                document.getElementById('modalTitle').innerText = item.AgendaTitle;

                // Badges
                document.getElementById('modalDay').innerHTML = `<div class="meta-badge badge-day"><i class="far fa-calendar"></i> ${item.Day}</div>`;
                document.getElementById('modalTime').innerHTML = `<div class="meta-badge badge-time"><i class="far fa-clock"></i> ${item.Time}</div>`;
                document.getElementById('modalTrack').innerHTML = `<div class="meta-badge badge-track"><i class="fas fa-map-marker-alt"></i> ${item.Track}</div>`;

                // --- SHOW BOTH BRIEF AND SYNOPSIS ---

                // 1. Set the Brief
                document.getElementById('modalBrief').innerText = item.AgendaBrief || "No brief available.";

                // 2. Set the Synopsis
                // If synopsis is empty, we can say "No additional details." or just hide it.
                document.getElementById('modalSynopsis').innerText = item.AgendaSynopsis || "No detailed synopsis provided.";

                document.getElementById('detailsModal').style.display = 'flex';
            }
        }

        function closeModal() {
            document.getElementById('detailsModal').style.display = 'none';
        }

        // Close modal if clicking outside content
        window.onclick = function (event) {
            const modal = document.getElementById('detailsModal');
            if (event.target == modal) {
                closeModal();
            }
        }

        async function loadSessionSpeakers(agendaId) {
            try {
                document.body.style.cursor = 'wait';

                const response = await fetch('Conference.aspx/GetSpeakersForSession', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                    body: JSON.stringify({ agendaId: agendaId })
                });

                const data = await response.json();
                const speakers = data.d;

                document.body.style.cursor = 'default';

                // Container for the list
                const listContainer = document.getElementById('sessionSpeakersList');

                if (!speakers || speakers.length === 0) {
                    listContainer.innerHTML = '<p style="text-align:center; color:#666; padding:20px;">Speakers for this session are being finalized.</p>';
                } else {
                    // Generate HTML for each speaker
                    let html = '';
                    speakers.forEach(s => {
                        // Decide whether to show Image or Initials
                        let imageHtml = '';
                        if (s.PhotoPath) {
                            imageHtml = `<img src="${s.PhotoPath}" alt="${s.Name}" class="modal-speaker-avatar">`;
                        } else {
                            // Get initials
                            const initials = s.Name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase();
                            imageHtml = `<div class="modal-speaker-placeholder">${initials}</div>`;
                        }

                        html += `
    <div class="modal-speaker-item" onclick="openSpeakerProfile(${s.SpeakerID})" style="cursor: pointer;">
        ${imageHtml}
        <div class="modal-speaker-info">
            <div class="modal-speaker-name">${s.Name}</div>
            <div class="modal-speaker-role">${s.Designation}</div>
            <div class="modal-speaker-company">${s.Company}</div>
        </div>
        <i class="fas fa-chevron-right" style="color:#cbd5e1;"></i> </div>`;
                    });

                    listContainer.innerHTML = html;
                }

                // Show the Modal
                document.getElementById('sessionSpeakersModal').style.display = 'flex';

            } catch (err) {
                document.body.style.cursor = 'default';
                console.error("Error loading speakers:", err);
            }
        }

        function closeSessionSpeakersModal() {
            document.getElementById('sessionSpeakersModal').style.display = 'none';
        }

        // Close if clicking outside the white box (Optional, for better UX)
        window.addEventListener('click', function (event) {
            const modal = document.getElementById('sessionSpeakersModal');
            if (event.target == modal) {
                closeSessionSpeakersModal();
            }
        });

        async function openSpeakerProfile(speakerId) {
            try {
                // 1. Fetch Details
                const response = await fetch('Conference.aspx/GetSpeakerDetails', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                    body: JSON.stringify({ speakerId: speakerId })
                });
                const data = await response.json();
                const d = data.d;

                if (d) {
                    // 2. Populate Data
                    document.getElementById('profName').innerText = d.Name || "";
                    document.getElementById('profDesignation').innerText = d.Designation || "";
                    document.getElementById('profCompany').innerText = d.Company || "";
                    document.getElementById('profBio').innerText = d.ProfessionalBio || "Bio not available.";

                    // 3. Images
                    document.getElementById('profPhoto').src = d.PhotoPath ? d.PhotoPath : 'Images/default_user.png';

                    const logo = document.getElementById('profLogo');
                    if (d.LogoPath) {
                        logo.src = d.LogoPath;
                        logo.style.display = 'block';
                    } else {
                        logo.style.display = 'none';
                    }

                    // 4. LinkedIn
                    const lnk = document.getElementById('profLinkedIn');
                    if (d.LinkedInProfile && d.LinkedInProfile.trim() !== "") {
                        lnk.href = d.LinkedInProfile;
                        lnk.style.display = 'inline-block';
                    } else {
                        lnk.style.display = 'none';
                    }

                    // 5. Open Modal (Stacked on top of the list)
                    document.getElementById('speakerProfileModal').style.display = 'flex';
                }
            } catch (err) {
                console.error(err);
            }
        }

        function closeSpeakerProfile() {
            document.getElementById('speakerProfileModal').style.display = 'none';
        }

        // Close profile on outside click
        window.addEventListener('click', function (event) {
            const modal = document.getElementById('speakerProfileModal');
            if (event.target == modal) {
                closeSpeakerProfile();
            }
        });
    </script>
</body>
</html>
