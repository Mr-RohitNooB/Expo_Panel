<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Expo_Panel.Index" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lubricant India Expo 2026</title>
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

        /* Compact Venue Section */
        .venue-content-compact {
            background: #fff;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
        }

        .venue-grid-compact {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
        }

        .venue-left-compact {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        /* Info Cards - Compact */
        .info-card-compact {
            background: #f8fafc;
            border-radius: 8px;
            padding: 15px;
            border-left: 3px solid #D94A2B;
        }

        .info-header-compact {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }

            .info-header-compact i {
                font-size: 18px;
                color: #D94A2B;
            }

            .info-header-compact h3 {
                font-size: 16px;
                color: #1e293b;
                margin: 0;
                font-weight: 600;
            }

        .info-text-compact {
            color: #64748b;
            font-size: 14px;
            line-height: 1.6;
            margin: 0;
        }

        /* Contact Grid - Compact */
        .contact-grid-compact {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }

        .contact-item-compact {
            font-size: 13px;
        }

            .contact-item-compact strong {
                display: block;
                color: #1e293b;
                font-size: 13px;
                margin-bottom: 4px;
            }

            .contact-item-compact p {
                color: #64748b;
                margin: 2px 0;
                font-size: 13px;
            }

            .contact-item-compact a {
                color: #D94A2B;
                text-decoration: none;
                font-size: 12px;
                word-break: break-word;
            }

                .contact-item-compact a:hover {
                    text-decoration: underline;
                }

        /* Timing List - Compact */
        .timing-list-compact {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .timing-item-compact {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
            padding: 6px 0;
            border-bottom: 1px solid #e2e8f0;
        }

            .timing-item-compact:last-child {
                border-bottom: none;
            }

            .timing-item-compact strong {
                color: #1e293b;
                font-size: 13px;
            }

            .timing-item-compact span {
                color: #64748b;
                font-size: 13px;
            }

        /* Compact Contact Form */
        .venue-right-compact {
            display: flex;
        }

        .contact-form-compact {
            background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
            border-radius: 10px;
            padding: 20px;
            width: 100%;
            border: 2px solid #e2e8f0;
        }

        .form-header-compact {
            text-align: center;
            margin-bottom: 15px;
        }

            .form-header-compact i {
                font-size: 28px;
                color: #D94A2B;
                margin-bottom: 8px;
            }

            .form-header-compact h3 {
                font-size: 18px;
                color: #1e293b;
                margin: 0;
                font-weight: 600;
            }

        /* Compact Form Inputs */
        .input-compact {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin-bottom: 8px;
            transition: all 0.2s ease;
            background: #fff;
        }

            .input-compact:focus {
                outline: none;
                border-color: #D94A2B;
                box-shadow: 0 0 0 2px rgba(217, 74, 43, 0.1);
            }

        .textarea-compact {
            resize: vertical;
            min-height: 70px;
        }

        .error-compact {
            display: block;
            font-size: 11px;
            margin-top: -6px;
            margin-bottom: 8px;
            font-weight: 500;
        }

        /* Compact Submit Button */
        .btn-compact {
            width: 100%;
            background: linear-gradient(135deg, #D94A2B 0%, #FF6B4A 100%);
            color: white;
            padding: 11px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s ease;
            margin-top: 5px;
        }

            .btn-compact:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(217, 74, 43, 0.3);
            }

        .msg-compact {
            display: block;
            margin-top: 10px;
            padding: 8px;
            border-radius: 5px;
            font-weight: 500;
            text-align: center;
            font-size: 13px;
        }

        /* Mobile Responsive */
        @media (max-width: 968px) {
            .venue-grid-compact {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .contact-grid-compact {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .contact-form-compact {
                padding: 18px;
            }
        }

        @media (max-width: 768px) {
            .venue-content-compact {
                padding: 20px;
            }

            .info-card-compact {
                padding: 12px;
            }

            .contact-item-compact a {
                font-size: 11px;
            }
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
        /* --- Floating Countdown Timer Styles --- */
        .sticky-timer-bar {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            background-color: #3D3935; /* Your Dark Grey Brand Color */
            border-top: 4px solid #D94A2B; /* Your Orange Brand Color */
            color: #fff;
            z-index: 9999;
            transform: translateY(100%); /* Hidden by default */
            transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 -4px 20px rgba(0,0,0,0.2);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 10px 20px;
        }

            .sticky-timer-bar.visible {
                transform: translateY(0); /* Slide up into view */
            }

        .timer-container {
            display: flex;
            align-items: center;
            gap: 30px;
            max-width: 1200px;
            width: 100%;
            justify-content: space-between;
        }

        .timer-text {
            font-size: 18px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .countdown-box {
            display: flex;
            gap: 15px;
        }

        .time-unit {
            display: flex;
            flex-direction: column;
            align-items: center;
            min-width: 60px;
        }

        .time-val {
            font-size: 24px;
            font-weight: 700;
            color: #D94A2B; /* Orange highlight */
            line-height: 1;
        }

        .time-label {
            font-size: 10px;
            text-transform: uppercase;
            opacity: 0.8;
            margin-top: 2px;
        }

        /* Button inside timer */
        .timer-btn {
            background: #D94A2B;
            color: white;
            padding: 8px 20px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

            .timer-btn:hover {
                background: #fff;
                color: #D94A2B;
            }

        /* Mobile Response */
        @media (max-width: 768px) {
            .timer-container {
                flex-direction: column;
                gap: 10px;
                padding: 5px 0;
            }

            .timer-text {
                display: none;
            }
            /* Hide text on small screens to save space */
            .time-val {
                font-size: 20px;
            }

            .sticky-timer-bar {
                padding: 10px;
            }
        }

        /* --- NEW Exhibitor Styles --- */
        .exhibitors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
        }

        .exhibitor-card {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-left: 4px solid #D94A2B; /* Orange accent */
            border-radius: 8px;
            padding: 20px;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            justify-content: center;
            min-height: 100px;
        }

            .exhibitor-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.08);
                border-color: #D94A2B;
            }

        .exhibitor-name {
            font-size: 18px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 5px;
        }

        .exhibitor-stall {
            font-size: 13px;
            color: #64748b;
            background: #f1f5f9;
            padding: 2px 8px;
            border-radius: 4px;
            align-self: flex-start;
        }

        /* Modal & Button Styles */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 2000;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .modal-content {
            background: white;
            width: 100%;
            max-width: 900px;
            border-radius: 12px;
            position: relative;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }

        .close-modal {
            position: absolute;
            top: 15px;
            right: 20px;
            background: none;
            border: none;
            font-size: 32px;
            cursor: pointer;
            color: #64748b;
        }

        .modal-body-grid {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 30px;
            padding: 40px;
        }

        .modal-profile-img {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-radius: 10px;
        }

        .modal-title {
            font-size: 32px;
            color: #1e293b;
            margin-bottom: 5px;
        }

        .modal-designation {
            font-size: 18px;
            color: #D94A2B;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .modal-badge {
            background: #f1f5f9;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }

        .modal-section {
            margin-bottom: 20px;
        }

            .modal-section h5 {
                font-size: 16px;
                color: #1e293b;
                font-weight: 700;
                margin-bottom: 8px;
                text-transform: uppercase;
            }

        .btn-view-profile {
            display: inline-block;
            margin-top: 15px;
            padding: 8px 20px;
            border: 2px solid #D94A2B;
            color: #D94A2B;
            background: transparent;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
        }

            .btn-view-profile:hover {
                background: #D94A2B;
                color: white;
            }

        @media (max-width: 768px) {
            .modal-body-grid {
                grid-template-columns: 1fr;
            }
        }

        /* --- Circular Speaker & Overlapping Logo Styles --- */
        .speaker-avatar-container {
            position: relative; /* Acts as the anchor for the logo */
            width: 220px; /* Fixed width */
            height: 220px; /* Fixed height */
            margin: 0 auto 20px auto; /* Center horizontally and add bottom space */
        }

        /* The Main Speaker Photo */
        .modal-profile-img-circle {
            width: 100%;
            height: 100%;
            object-fit: cover; /* Ensures image doesn't stretch */
            border-radius: 50%; /* Makes it a perfect circle */
            border: 4px solid #fff;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1); /* Soft shadow */
        }

        /* The Overlapping Company Logo */
        .modal-company-logo-circle {
            position: absolute;
            bottom: 5px; /* 5px from bottom of container */
            right: 5px; /* 5px from right of container */
            width: 75px; /* Logo size */
            height: 75px;
            border-radius: 50%; /* Make logo circular */
            object-fit: contain; /* Keep logo aspect ratio inside the circle */
            background: #ffffff;
            border: 3px solid #f1f5f9; /* Light grey border */
            padding: 5px; /* White space inside the circle */
            box-shadow: 0 4px 10px rgba(0,0,0,0.15); /* Lift it up a bit */
            z-index: 10; /* Ensure it sits ON TOP of the speaker photo */
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
                    <li class="nav-item"><a href="Conference.aspx" class="nav-link">Conference</a></li>
                    <li class="nav-item"><a href="#speakers" class="nav-link">Speakers</a></li>
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
                            <div><strong>60+ Speakers</strong></div>
                            <small>Industry Experts</small>
                        </div>
                    </div>
                </div>
                <a href="RegisterExhibitor.aspx" class="cta-button">Register Now</a>
            </div>
        </section>


        <!-- Speakers Section -->
        <section class="section" id="speakers" style="background: #f8fafc;">
            <h2 class="section-title">Featured Speakers</h2>
            <div class="speakers-grid">
                <!-- 
                    This grid is also intentionally left empty.
                    The 'loadDynamicData()' function will fill this section
                    with speaker data from the database.
                -->
            </div>
        </section>


        <!-- Exhibitors Section -->
        <section class="section" id="exhibitors">
            <h2 class="section-title">Featured Exhibitors</h2>
            <div class="exhibitors-grid">
            </div>
        </section>


        <!-- Venue Section -->
        <section class="section" id="venue">
            <h2 class="section-title">Venue Information</h2>
            <div class="venue-content-compact">
                <!-- Two Column Layout -->
                <div class="venue-grid-compact">
                    <!-- Left Side: Info Cards -->
                    <div class="venue-left-compact">
                        <!-- Location Card -->
                        <div class="info-card-compact">
                            <div class="info-header-compact">
                                <i class="fas fa-map-marker-alt"></i>
                                <h3>Location</h3>
                            </div>
                            <p class="info-text-compact">
                                Yashoobhumi Convention Centre<br>
                                Dwarka, New Delhi, India
                            </p>
                        </div>

                        <!-- Contact Card -->
                        <div class="info-card-compact">
                            <div class="info-header-compact">
                                <i class="fas fa-envelope"></i>
                                <h3>Contact</h3>
                            </div>
                            <div class="contact-grid-compact">
                                <div class="contact-item-compact">
                                    <strong>Booth Bookings</strong>
                                    <p>Amit Gautam</p>
                                    <a href="mailto:sales@lubricantindia.com">sales@lubricantindia.com</a>
                                </div>
                                <div class="contact-item-compact">
                                    <strong>Speaking Opportunities</strong>
                                    <p>Hema Sharma</p>
                                    <a href="mailto:confex@lubricantindia.com">confex@lubricantindia.com</a>
                                </div>
                                <div class="contact-item-compact">
                                    <strong>Sponsorship Packages</strong>
                                    <p>Shubham Kumar</p>
                                    <a href="mailto:partner@lubricantindia.com">partner@lubricantindia.com</a>
                                </div>
                            </div>
                        </div>

                        <!-- Opening Times Card -->
                        <div class="info-card-compact">
                            <div class="info-header-compact">
                                <i class="fas fa-clock"></i>
                                <h3>Opening Times</h3>
                            </div>
                            <div class="timing-list-compact">
                                <div class="timing-item-compact">
                                    <strong>Thu, Sept 24, 2026:</strong> <span>10:00 AM – 6:30 PM</span>
                                </div>
                                <div class="timing-item-compact">
                                    <strong>Fri, Sept 25 2026:</strong> <span>10:00 AM – 6:30 PM</span>
                                </div>
                                <div class="timing-item-compact">
                                    <strong>Sat, Sept 26 2026:</strong> <span>10:00 AM – 6:00 PM</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Side: Compact Contact Form -->
                    <div class="venue-right-compact">
                        <div class="contact-form-compact">
                            <div class="form-header-compact">
                                <i class="fas fa-paper-plane"></i>
                                <h3>Send Us a Message</h3>
                            </div>

                            <asp:Panel ID="pnlContactForm" runat="server">
                                <asp:TextBox ID="txtName" runat="server" placeholder="Your Name" CssClass="input-compact"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                                    ErrorMessage="*Required" ForeColor="#D94A2B" Display="Dynamic" ValidationGroup="ContactForm" CssClass="error-compact"></asp:RequiredFieldValidator>

                                <asp:TextBox ID="txtEmail" runat="server" placeholder="Your Email" TextMode="Email" CssClass="input-compact"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                                    ErrorMessage="*Required" ForeColor="#D94A2B" Display="Dynamic" ValidationGroup="ContactForm" CssClass="error-compact"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                                    ErrorMessage="*Invalid email" ForeColor="#D94A2B" Display="Dynamic"
                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="ContactForm" CssClass="error-compact"></asp:RegularExpressionValidator>

                                <asp:TextBox ID="txtMobile" runat="server" placeholder="Mobile Number" CssClass="input-compact" MaxLength="10"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvMobile" runat="server" ControlToValidate="txtMobile"
                                    ErrorMessage="*Required" ForeColor="#D94A2B" Display="Dynamic" ValidationGroup="ContactForm" CssClass="error-compact"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revMobile" runat="server" ControlToValidate="txtMobile"
                                    ErrorMessage="*Invalid mobile number" ForeColor="#D94A2B" Display="Dynamic"
                                    ValidationExpression="^[6-9]\d{9}$" ValidationGroup="ContactForm" CssClass="error-compact"></asp:RegularExpressionValidator>

                                <asp:TextBox ID="txtMessage" runat="server" placeholder="Your Message" TextMode="MultiLine" Rows="3" CssClass="input-compact textarea-compact"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage"
                                    ErrorMessage="*Required" ForeColor="#D94A2B" Display="Dynamic" ValidationGroup="ContactForm" CssClass="error-compact"></asp:RequiredFieldValidator>

                                <asp:Button ID="btnSubmitContact" runat="server" Text="Send Message"
                                    OnClick="btnSubmitContact_Click" ValidationGroup="ContactForm" CssClass="btn-compact" />

                                <asp:Label ID="lblMessage" runat="server" CssClass="msg-compact"></asp:Label>
                            </asp:Panel>
                        </div>
                    </div>
                </div>

                <a href="https://maps.app.goo.gl/pDFdFGjQq9trFb43A" target="_blank" class="cta-button" style="margin-top: 25px;">
                    <i class="fas fa-map-marked-alt" style="margin-right: 8px;"></i>View on Google Maps
                </a>
            </div>
        </section>


        <div id="stickyTimer" class="sticky-timer-bar">
            <div class="timer-container">
                <div class="timer-text">Event Starts In:</div>

                <div class="countdown-box">
                    <div class="time-unit">
                        <span class="time-val" id="days">00</span>
                        <span class="time-label">Days</span>
                    </div>
                    <div class="time-unit">
                        <span class="time-val" id="hours">00</span>
                        <span class="time-label">Hours</span>
                    </div>
                    <div class="time-unit">
                        <span class="time-val" id="minutes">00</span>
                        <span class="time-label">Mins</span>
                    </div>
                    <div class="time-unit">
                        <span class="time-val" id="seconds">00</span>
                        <span class="time-label">Secs</span>
                    </div>
                </div>

                <a href="User/RegisterExhibitor.aspx" class="timer-btn">Register Now</a>
            </div>
        </div>

        <!-- Footer -->
        <footer class="footer">
            <div style="margin-top: 40px;">
                <h3 style="color: #fff; font-size: 20px; margin-bottom: 15px;">Sign up for Updates</h3>

                <asp:Panel ID="pnlFooterSignup" runat="server" Style="max-width: 400px; margin: 0 auto;">

                    <asp:TextBox ID="txtFooterEmail" runat="server" CssClass="input-compact"
                        placeholder="Enter your email"
                        Style="border-radius: 5px; padding: 10px; width: 100%;"></asp:TextBox>

                    <asp:RequiredFieldValidator ID="rfvFooterEmail" runat="server"
                        ControlToValidate="txtFooterEmail"
                        ErrorMessage="Email is required"
                        ForeColor="#FFB3B3" ValidationGroup="FooterSignup" Display="Dynamic" />

                    <asp:RegularExpressionValidator ID="revFooterEmail" runat="server"
                        ControlToValidate="txtFooterEmail"
                        ErrorMessage="Invalid email"
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        ForeColor="#FFB3B3" ValidationGroup="FooterSignup" Display="Dynamic" />

                    <asp:Button ID="btnFooterSignup" runat="server"
                        Text="Subscribe"
                        CssClass="btn-compact"
                        ValidationGroup="FooterSignup"
                        OnClick="btnFooterSignup_Click"
                        Style="margin-top: 10px;" />

                    <asp:Label ID="lblFooterMsg" runat="server"
                        Style="display: block; margin-top: 10px; color: #FFD9D9; font-size: 14px;"></asp:Label>
                </asp:Panel>
            </div>

            <div class="footer-content">
                <div class="footer-links">
                    <a href="#home">Home</a>
                    <a href="#agenda">Agenda</a>
                    <a href="#speakers">Speakers</a>
                    <a href="Exhibitors.aspx">Exhibitors</a>
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

    <div id="speakerModal" class="modal-overlay">
        <div class="modal-content">
            <button type="button" class="close-modal" onclick="closeSpeakerModal()">&times;</button>
            <div class="modal-body-grid">
                <div class="modal-sidebar" style="text-align: center;">

                    <div class="speaker-avatar-container">
                        <img id="modalPhoto" src="" alt="Speaker" class="modal-profile-img-circle">

                        <img id="modalLogo" src="" alt="Logo" class="modal-company-logo-circle" style="display: none;">
                    </div>

                    <div style="margin-top: 15px; text-align: center;">
                        <h4 id="modalCompany" style="margin-top: 5px; color: #D94A2B; font-weight: 700;"></h4>
                    </div>
                </div>
                <div class="modal-main-info">
                    <h2 id="modalName" class="modal-title"></h2>
                    <p id="modalDesignation" class="modal-designation"></p>
                    <div class="modal-badge">Experience: <span id="modalYEO"></span>Years</div>
                    <hr style="border: 0; height: 1px; background: #e2e8f0; margin: 20px 0;">

                    <div class="modal-section">
                        <h5>Professional Bio</h5>
                        <p id="modalBio"></p>
                    </div>
                    <div class="modal-section">
                        <h5>Areas of Expertise</h5>
                        <p id="modalExpertise"></p>
                    </div>
                    <div class="modal-section">
                        <h5>Current Projects</h5>
                        <p id="modalProjects"></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

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
            loadSpeakers();
            loadExhibitors();
        });

        // 1. Update loadSpeakers to include the Button
        async function loadSpeakers() {
            try {
                const response = await fetch('Index.aspx/GetSpeakersList', {
                    method: 'POST', headers: { 'Content-Type': 'application/json; charset=utf-8' }
                });
                const data = await response.json();
                const speakers = data.d;
                const grid = document.querySelector('.speakers-grid');

                if (!speakers || speakers.length === 0) {
                    grid.innerHTML = '<p style="text-align:center; grid-column:1/-1;">Speaker list coming soon.</p>';
                    return;
                }

                let html = '';
                speakers.forEach(s => {
                    let imgHtml = s.PhotoPath
                        ? `<img src="${s.PhotoPath}" alt="${s.Name}" style="width:100%; height:100%; object-fit:cover;">`
                        : `<div style="width:100%;height:100%;background:#ddd;display:flex;align-items:center;justify-content:center;font-size:24px;color:#555;">${getInitials(s.Name)}</div>`;

                    html += `
                <div class="speaker-card">
                    <div class="speaker-avatar">${imgHtml}</div>
                    <div class="speaker-name">${s.Name}</div>
                    <div class="speaker-title">${s.Designation}</div>
                    <div class="speaker-company">${s.Company}</div>
                    <button class="btn-view-profile" onclick="openSpeakerModal(${s.SpeakerID}); return false;">View Profile</button>
                </div>
            `;
                });
                grid.innerHTML = html;
            } catch (err) { console.error('Speaker Error:', err); }
        }

        async function openSpeakerModal(speakerId) {
            try {
                // Fetch data from the C# WebMethod
                const response = await fetch('Index.aspx/GetSpeakerDetails', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                    body: JSON.stringify({ speakerId: speakerId })
                });

                const data = await response.json();
                const d = data.d; // The SpeakerDetailsDTO object

                if (d) {
                    // Fill text fields
                    document.getElementById('modalName').innerText = d.Name || "";
                    document.getElementById('modalDesignation').innerText = d.Designation || "";
                    document.getElementById('modalCompany').innerText = d.Company || "";
                    document.getElementById('modalYEO').innerText = d.YearsOfExperience || "0";
                    document.getElementById('modalBio').innerText = d.ProfessionalBio || "No bio available.";
                    document.getElementById('modalExpertise').innerText = d.AreasOfExpertise || "N/A";
                    document.getElementById('modalProjects').innerText = d.CurrentWorkProjects || "N/A";

                    // Handle Profile Photo
                    const img = document.getElementById('modalPhoto');
                    img.src = d.PhotoPath ? d.PhotoPath : 'Images/default_user.png';

                    // Handle Company Logo
                    const logo = document.getElementById('modalLogo');
                    const companyHeader = document.getElementById('modalCompany');

                    if (d.LogoPath) {
                        logo.src = d.LogoPath;
                        logo.style.display = 'inline-block';
                        companyHeader.style.display = 'none'; // Hide text if logo exists (optional preference)
                    } else {
                        logo.style.display = 'none';
                        companyHeader.style.display = 'block'; // Show text if no logo
                    }

                    // Show the Modal
                    document.getElementById('speakerModal').style.display = 'flex';
                    // Stop background scrolling
                    document.body.style.overflow = 'hidden';
                }
            } catch (err) {
                console.error(err);
                alert("Could not load details. Please try again.");
            }
        }

        function closeSpeakerModal() {
            document.getElementById('speakerModal').style.display = 'none';
            document.body.style.overflow = 'auto'; // Re-enable scrolling
        }

        // Close modal if user clicks outside the white box
        window.onclick = function (e) {
            const modal = document.getElementById('speakerModal');
            if (e.target == modal) {
                closeSpeakerModal();
            }
        }

        // 2. FETCH EXHIBITORS
        async function loadExhibitors() {
            try {
                const response = await fetch('Index.aspx/GetExhibitorsList', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' }
                });
                const data = await response.json();
                const exhibitors = data.d;
                const grid = document.querySelector('.exhibitors-grid');

                if (!exhibitors || exhibitors.length === 0) {
                    grid.innerHTML = '<p style="text-align:center; grid-column:1/-1;">Exhibitor list coming soon.</p>';
                    return;
                }

                let html = '';
                exhibitors.forEach(e => {
                    // 1. Format Location (City, State, Country)
                    let locParts = [];
                    if (e.City) locParts.push(e.City);
                    if (e.State) locParts.push(e.State);
                    if (e.Country) locParts.push(e.Country);
                    let locationStr = locParts.join(', ');

                    // 2. Build Card HTML
                    html += `
                <div class="exhibitor-card" style="display:flex; flex-direction:column; justify-content:space-between; min-height:130px;">
                    
                    <div style="margin-bottom:12px;">
                        <div style="font-size:17px; font-weight:700; color:#D94A2B; line-height:1.3;">${e.FullName}</div>
                        <div style="font-size:13px; color:#64748b; font-weight:600; margin-top:2px;">${e.Designation}</div>
                    </div>

                    <div style="border-top:1px solid #f1f5f9; padding-top:10px;">
                         <div class="exhibitor-name" style="font-size:15px; margin-bottom:4px; color:#1e293b; font-weight:700;">
                            <i class="fas fa-building" style="color:#cbd5e1; margin-right:6px; font-size:12px;"></i>${e.Company}
                         </div>
                         
                         ${locationStr ?
                            `<div style="font-size:13px; color:#94a3b8;">
                                <i class="fas fa-map-marker-alt" style="margin-right:8px; font-size:12px; margin-left:2px;"></i>${locationStr}
                            </div>` : ''
                        }
                    </div>
                </div>
            `;
                });
                grid.innerHTML = html;
            } catch (err) {
                console.error('Exhibitor Error:', err);
            }
        }

        // Helper function (Keep or Add if missing)
        function getInitials(name) {
            if (!name) return 'SP';
            const parts = name.split(' ');
            return (parts[0][0] + (parts.length > 1 ? parts[parts.length - 1][0] : '')).toUpperCase();
        }

        async function loadDynamicData() {
            try {
                const response = await fetch('Index.aspx/GetPublicAgendaDetails', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=utf-8'
                    },
                    body: JSON.stringify({})
                });

                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }

                const data = await response.json();
                const allData = data.d;

                // Separate agendas and speakers
                const agendas = allData.filter(item => item.AgendaID !== null);
                const speakers = allData.filter(item => item.SpeakerID !== null);

                // Get the containers
                const agendaGrid = document.querySelector('.agenda-grid');
                const speakersGrid = document.querySelector('.speakers-grid');

                // Build Agenda HTML
                let agendaHtml = '';
                agendas.forEach(item => {
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
                });

                agendaGrid.innerHTML = agendaHtml || '<p>Agenda details will be available soon.</p>';

                // Build Speaker HTML
                let speakersHtml = '';
                speakers.forEach(speaker => {
                    speakersHtml += `
                <div class="speaker-card">
                    <div class="speaker-avatar">
                        ${speaker.SpeakerPhoto ?
                            `<img src="${speaker.SpeakerPhoto}" alt="${speaker.SpeakerName}" 
                                  style="width:100%; height:100%; border-radius:50%; object-fit:cover;">` :
                            getInitials(speaker.SpeakerName)
                        }
                    </div>
                    <div class="speaker-name">${speaker.SpeakerName}</div>
                    <div class="speaker-title">${speaker.SpeakerDesignation}</div>
                    <div class="speaker-company">${speaker.SpeakerCompany}</div>
                </div>
            `;
                });

                speakersGrid.innerHTML = speakersHtml || '<p>Speaker details will be available soon.</p>';

            } catch (error) {
                console.error('Error loading dynamic data:', error);
                document.querySelector('.agenda-grid').innerHTML = '<p>Could not load agenda. Please try again later.</p>';
                document.querySelector('.speakers-grid').innerHTML = '<p>Could not load speakers. Please try again later.</p>';
            }
        }

        // Helper function (keep this as-is)
        function getInitials(name) {
            if (!name) return '';
            const parts = name.split(' ');
            let initials = parts[0] ? parts[0][0] : '';
            if (parts.length > 1) {
                initials += parts[parts.length - 1][0];
            }
            return initials.toUpperCase();
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

        // --- COUNTDOWN TIMER LOGIC ---

        // 1. Set the date we're counting down to (Sept 24, 2026 10:00:00)
        const countDownDate = new Date("Sep 24, 2026 10:00:00").getTime();

        const updateTimer = setInterval(function () {
            // Get today's date and time
            const now = new Date().getTime();

            // Find the distance between now and the count down date
            const distance = countDownDate - now;

            // Time calculations for days, hours, minutes and seconds
            const days = Math.floor(distance / (1000 * 60 * 60 * 24));
            const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);

            // Output the result in elements with id="days", "hours", etc.
            const elDays = document.getElementById("days");
            const elHours = document.getElementById("hours");
            const elMins = document.getElementById("minutes");
            const elSecs = document.getElementById("seconds");

            // Check if elements exist to prevent errors on other pages if you reuse this script
            if (elDays) elDays.innerText = days < 10 ? "0" + days : days;
            if (elHours) elHours.innerText = hours < 10 ? "0" + hours : hours;
            if (elMins) elMins.innerText = minutes < 10 ? "0" + minutes : minutes;
            if (elSecs) elSecs.innerText = seconds < 10 ? "0" + seconds : seconds;

            // If the count down is over, write some text 
            if (distance < 0) {
                clearInterval(updateTimer);
                document.getElementById("stickyTimer").innerHTML = "<div style='color:white; font-weight:bold; width:100%; text-align:center;'>Event has started!</div>";
            }
        }, 1000);

        // --- SCROLL TRIGGER LOGIC ---
        window.addEventListener('scroll', function () {
            const timerBar = document.getElementById('stickyTimer');
            // Show timer after scrolling 600px (past the Hero section)
            if (window.scrollY > 600) {
                timerBar.classList.add('visible');
            } else {
                timerBar.classList.remove('visible');
            }
        });
    </script>
</body>
</html>
