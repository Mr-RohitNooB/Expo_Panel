<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewFinalSpeaker.aspx.cs" Inherits="Expo_Panel.Admin.ViewFinalSpeaker" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Final Speaker Selection Dashboard</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" rel="stylesheet" />
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
        * {
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(300deg, #00394e 0%, #1b887a 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        .admin-header {
            background: linear-gradient(106deg, #d3fffa 45%, #d3fffa 100%, transparent);
            backdrop-filter: blur(10px);
            padding: 15px 30px; /* Adjusted padding for better height */
            color: #2d3748;
            display: flex; /* Key for alignment */
            justify-content: space-between; /* Pushes Logo left, Info right */
            align-items: center; /* Vertically centers everything */
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

            .admin-header h2 {
                margin: 0;
                font-weight: 700;
                background: linear-gradient(135deg, #38b2ac 0%, #319795 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                font-size: 24px;
            }

            .admin-header .admin-info {
                display: flex;
                align-items: center;
                gap: 15px;
            }

                .admin-header .admin-info span {
                    color: #4a5568;
                    font-weight: 500;
                }

        .btn-logout, .btn-info {
            background: linear-gradient(135deg, #38b2ac 0%, #319795 100%);
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

            .btn-logout:hover, .btn-info:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(56, 178, 172, 0.4);
                color: white;
            }

        /* Dashboard Container */
        .dashboard-container {
            max-width: 1600px;
            margin: 0 auto;
            padding: 30px 20px;
        }

        /* Statistics Dashboard */
        .stats-dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(185px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 15px 20px; /* Reduced from 25px */
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.12);
            }

        .stat-card-icon {
            width: 45px; /* Reduced from 60px */
            height: 45px; /* Reduced from 60px */
            border-radius: 10px; /* Slightly smaller radius */
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px; /* Reduced from 28px */
            margin-bottom: 10px; /* Reduced from 15px */
        }

            .stat-card-icon.purple {
                background: #38b2ac;
                color: white;
            }

            .stat-card-icon.green {
                background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
                color: white;
            }

            .stat-card-icon.orange {
                background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
                color: white;
            }

            .stat-card-icon.blue {
                background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
                color: white;
            }

            .stat-card-icon.red {
                background: linear-gradient(135deg, #f56565 0%, #e53e3e 100%);
                color: white;
            }

        .stat-card-value {
            font-size: 28px; /* Reduced from 36px */
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 2px; /* Reduced from 5px */
        }

        .stat-card-label {
            color: #718096;
            font-size: 12px; /* Reduced from 14px */
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-card-trend {
            margin-top: 10px;
            font-size: 13px;
            color: #48bb78;
            font-weight: 600;
        }

            .stat-card-trend.down {
                color: #f56565;
            }

        /* Filter Section */
        .filter-section {
            background: white;
            padding: 25px;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

            .filter-section h3 {
                margin: 0 0 20px 0;
                color: #2d3748;
                font-weight: 600;
                font-size: 18px;
            }

        .filter-buttons {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .btn-filter {
            padding: 12px 24px;
            border: 2px solid #e2e8f0;
            background: white;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            color: #4a5568;
        }

            .btn-filter:hover {
                border-color: #667eea;
                color: #667eea;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
            }

            .btn-filter.active {
                background: linear-gradient(135deg, #38b2ac 0%, #319795 100%); /* New Teal Gradient */
                color: white;
                border-color: transparent;
                box-shadow: 0 4px 12px rgba(56, 178, 172, 0.3); /* New Teal Shadow */
            }

        .search-box {
            display: flex;
            gap: 12px;
        }

            .search-box input {
                flex: 1;
                padding: 14px 18px;
                border: 2px solid #e2e8f0;
                border-radius: 10px;
                font-size: 14px;
                transition: all 0.3s;
            }

                .search-box input:focus {
                    outline: none;
                    border-color: #667eea;
                    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                }

            .search-box button {
                padding: 14px 28px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                border-radius: 10px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s;
            }

                .search-box button:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
                }

        /* Agenda Cards */
        .agenda-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            overflow: hidden;
            transition: all 0.3s;
            scroll-margin-top: 150px;
            border-left: 5px solid transparent;
        }

            .agenda-card:hover {
                box-shadow: 0 8px 30px rgba(0,0,0,0.12);
                border-left-color: #38b2ac; /* Deep Emerald/Teal */
            }


        .agenda-header {
            padding: 25px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background 0.3s;
        }

            .agenda-header:hover {
                background: #f7fafc;
            }

        .agenda-info h3 {
            margin: 0 0 12px 0;
            color: #2d3748;
            font-size: 22px;
            font-weight: 700;
        }

        .agenda-meta {
            display: flex;
            gap: 25px;
            color: #718096;
            font-size: 14px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

            .agenda-meta span {
                display: flex;
                align-items: center;
                gap: 8px;
                background: #f7fafc;
                padding: 6px 12px;
                border-radius: 6px;
            }

            .agenda-meta i {
                color: #667eea;
            }

        .stats-row {
            display: flex;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 20px;
            margin-bottom: 15px;
        }

        .stat-item {
            /* Use a 10% opacity of your new accent color over white */
            background: rgba(56, 178, 172, 0.1);
            padding: 12px;
            border-radius: 10px;
            text-align: center;
        }

        .stat-value {
            font-weight: 700;
            font-size: 24px;
            color: #667eea;
            display: block;
        }

        .stat-label {
            color: #718096;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 4px;
            display: block;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 10px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .badge-needs-review {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            color: #92400e;
        }

        .badge-finalized {
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            color: #065f46;
        }

        .badge-pending {
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            color: #991b1b;
        }

        .badge-no-speakers {
            background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e0 100%);
            color: #1a202c;
        }

        .progress-container {
            margin-top: 15px;
        }

        .progress {
            height: 10px;
            border-radius: 10px;
            background: #e2e8f0;
            overflow: hidden;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.06);
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #48bb78, #38a169);
            transition: width 0.8s ease;
            box-shadow: 0 0 10px rgba(72, 187, 120, 0.5);
        }

        .toggle-icon {
            font-size: 24px;
            color: #a0aec0;
            transition: transform 0.3s;
        }

        .agenda-card.expanded .toggle-icon {
            transform: rotate(180deg);
        }

        /* Speakers Section */
        .speakers-section {
            padding: 30px;
            background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
            border-top: 3px solid #e2e8f0;
        }

        .speakers-list {
            display: grid;
            /* === FIX: Change grid template to support 2 columns on large screens === */
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); /* Use larger min column size for two max */
            max-width: 100%; /* Ensure it respects parent width */
            gap: 20px;
        }

        .speaker-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            transition: all 0.3s;
            border-left: 4px solid transparent;
        }

            .speaker-card:hover {
                box-shadow: 0 6px 20px rgba(0,0,0,0.1);
                border-left-color: #667eea;
            }

        .speaker-header {
            display: flex;
            gap: 20px;
            margin-bottom: 25px;
            align-items: flex-start;
        }

        .speaker-photo {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #e2e8f0;
            flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .speaker-photo-placeholder {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e0 100%);
            color: #a0aec0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .speaker-info {
            flex: 1;
        }

            .speaker-info h4 {
                margin: 0 0 8px 0;
                color: #2d3748;
                font-size: 20px;
                font-weight: 700;
            }

        .speaker-meta {
            color: #718096;
            font-size: 14px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .rating-display {
            display: flex;
            align-items: center;
            gap: 25px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            background: #f7fafc;
            padding: 20px;
            border-radius: 12px;
        }

        .avg-rating {
            font-size: 48px;
            font-weight: 900;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .rating-breakdown {
            flex: 1;
            min-width: 250px;
        }

        .rating-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 6px;
            font-size: 13px;
            font-weight: 600;
        }

        .rating-bar-fill {
            flex: 1;
            height: 8px;
            background: #e2e8f0;
            border-radius: 4px;
            overflow: hidden;
        }

        .rating-bar-fill-inner {
            height: 100%;
            background: linear-gradient(90deg, #fbbf24, #f59e0b);
            transition: width 0.6s ease;
        }

        .decision-section {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-top: 20px;
            border: 2px solid #e2e8f0;
        }

        .decision-label {
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 15px;
            display: block;
            font-size: 16px;
        }

        .decision-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
        }

        .decision-option input[type="radio"] {
            display: none;
        }

        .decision-option label {
            display: block;
            padding: 16px;
            border: 3px solid #e2e8f0;
            border-radius: 12px;
            text-align: center;
            cursor: pointer;
            font-weight: 700;
            transition: all 0.3s;
            background: white;
        }

            .decision-option label:hover {
                border-color: #667eea;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
            }

        .decision-option input[type="radio"]:checked + label {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            border-color: transparent;
            box-shadow: 0 6px 20px rgba(72, 187, 120, 0.3);
        }

        .decision-option.reject input[type="radio"]:checked + label {
            background: linear-gradient(135deg, #f56565 0%, #e53e3e 100%);
            box-shadow: 0 6px 20px rgba(245, 101, 101, 0.3);
        }

        .decision-option.hold input[type="radio"]:checked + label {
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
            box-shadow: 0 6px 20px rgba(237, 137, 54, 0.3);
        }

        .approved-agendas {
            margin-top: 15px;
            padding: 15px;
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            border-left: 4px solid #10b981;
            border-radius: 8px;
            color: #065f46;
            font-size: 14px;
            font-weight: 600;
        }

        .action-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding: 20px 0 0 0;
        }

        .btn-view-profile {
            background: linear-gradient(135deg, #805ad5 0%, #6b46c1 100%);
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

            .btn-view-profile:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(128, 90, 213, 0.4);
            }

        .btn-save-all {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            border: none;
            padding: 16px 40px;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 700;
            font-size: 16px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

            .btn-save-all:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(72, 187, 120, 0.4);
            }

        .no-records {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

            .no-records i {
                font-size: 64px;
                margin-bottom: 20px;
                display: block;
                color: #cbd5e0;
            }

            .no-records h3 {
                color: #2d3748;
                margin-bottom: 10px;
            }

            .no-records p {
                color: #a0aec0;
            }

        .loading-spinner {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 9999;
            background: rgba(255,255,255,0.95);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

            .loading-spinner.show {
                display: block;
            }

        .spinner {
            border: 5px solid #f3f3f3;
            border-top: 5px solid #667eea;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }

            100% {
                transform: rotate(360deg);
            }
        }

        /* Modal */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.7);
            backdrop-filter: blur(4px);
            z-index: 1000;
            animation: fadeIn 0.3s;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
        }

        .modal-overlay.show {
            display: block;
        }

        .modal-content {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            border-radius: 16px;
            max-width: 900px;
            width: 90%;
            max-height: 85vh;
            overflow-y: auto;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            z-index: 1001;
            animation: slideUp 0.3s;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translate(-50%, -40%);
            }

            to {
                opacity: 1;
                transform: translate(-50%, -50%);
            }
        }

        .modal-header {
            padding: 25px 30px;
            border-bottom: 2px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
            border-radius: 16px 16px 0 0;
        }

            .modal-header h3 {
                margin: 0;
                color: #2d3748;
                font-weight: 700;
                font-size: 20px;
            }

        .modal-close {
            background: none;
            border: none;
            font-size: 28px;
            cursor: pointer;
            color: #a0aec0;
            transition: all 0.3s;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

            .modal-close:hover {
                color: #2d3748;
                background: #e2e8f0;
            }

        .modal-body {
            padding: 30px;
        }

        .comment-item {
            background: #f7fafc;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 15px;
            border-left: 4px solid #667eea;
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }

        .comment-author {
            font-weight: 700;
            color: #2d3748;
        }

        .comment-rating {
            color: #f59e0b;
            font-weight: 700;
        }

        .comment-text {
            color: #4a5568;
            line-height: 1.6;
            margin-top: 10px;
        }

        .comment-meta {
            color: #a0aec0;
            font-size: 12px;
            margin-top: 10px;
        }

        .alert {
            position: fixed;
            top: 90px;
            right: 20px;
            z-index: 9999;
            padding: 18px 24px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.2);
            animation: slideIn 0.3s ease-out;
            min-width: 320px;
            font-weight: 600;
        }

        .alert-success {
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            color: #065f46;
            border-left: 5px solid #10b981;
        }

        .alert-danger {
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            color: #991b1b;
            border-left: 5px solid #ef4444;
        }

        @keyframes slideIn {
            from {
                transform: translateX(400px);
                opacity: 0;
            }

            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @media (max-width: 768px) {
            .stats-dashboard {
                grid-template-columns: 1fr;
            }

            .admin-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

                .admin-header .admin-info {
                    flex-direction: column;
                }

            .agenda-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .speaker-header {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }
        }

        .dropdown-arrow {
            transition: transform 0.3s ease;
            display: inline-block;
            font-size: 20px;
            cursor: pointer;
        }

        .agenda-card-body.expanded {
            background-color: #f8f9fa;
            border-left: 3px solid #6c63ff;
        }

        .dropdown-toggle-btn {
            background: none;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
            transition: all 0.2s ease;
            border-radius: 4px;
        }

            .dropdown-toggle-btn:hover {
                background-color: #e9ecef;
            }

            .dropdown-toggle-btn:active {
                transform: scale(0.95);
            }

        #agendaDetails_ /* your id */ {
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .dropdown-toggle-btn {
            background: none;
            border: none;
            padding: 8px 12px;
            cursor: pointer;
            transition: all 0.2s ease;
            border-radius: 6px;
            font-size: 18px;
            color: #667eea;
        }

            .dropdown-toggle-btn:hover {
                background-color: #edf2f7;
                transform: scale(1.1);
            }

            .dropdown-toggle-btn:active {
                transform: scale(0.95);
            }

        .toggle-icon {
            transition: transform 0.3s ease;
            display: inline-block;
        }

        .agenda-card.expanded .toggle-icon {
            transform: rotate(180deg);
        }

        .agenda-card.expanded {
            background: linear-gradient(to right, #f7fafc, #fff);
            border-left: 4px solid #38b2ac; /* Deep Emerald/Teal */
            box-shadow: 0 4px 12px rgba(56, 178, 172, 0.15);
        }

        @media (min-width: 992px) { /* Adjust breakpoint for two columns */
            .speakers-list {
                grid-template-columns: repeat(2, 1fr); /* Explicitly set 2 columns for wider screens */
            }
        }

        /* --- New CSS Overrides for stat-card top bar (::before) - SOLID COLORS --- */

        .stat-card.card-purple::before {
            background: #38b2ac; /* Primary purple */
        }

        .stat-card.card-blue::before {
            background: #4299e1; /* Primary blue */
        }

        .stat-card.card-green::before {
            background: #48bb78; /* Primary green */
        }

        .stat-card.card-orange::before {
            background: #ed8936; /* Primary orange */
        }

        .stat-card.card-red::before {
            background: #f56565; /* Primary red */
        }

        .btn-filter, .btn-logout, .btn-info {
            border-left: none !important;
        }
        /* --- SPEAKER HOVER COLOR OVERRIDES (Unique Color per Speaker) --- */

        .speaker-card.teal:hover {
            border-left-color: #38b2ac;
        }

        .speaker-card.indigo:hover {
            border-left-color: #667eea;
        }

        .speaker-card.orange:hover {
            border-left-color: #ed8936;
        }

        .speaker-card.red:hover {
            border-left-color: #f56565;
        }

        .speaker-card.purple:hover {
            border-left-color: #9f7aea;
        }

        .speaker-card.pink:hover {
            border-left-color: #ed64a6;
        }

        /* Filter Section Container */
        .filter-section {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05); /* Softer, deeper shadow */
            margin-bottom: 30px;
        }

        /* 1. The Container Bar - slightly darker for contrast */
        .filter-buttons {
            display: inline-flex;
            background: #e2e8f0; /* Darker grey background makes buttons stand out */
            padding: 6px;
            border-radius: 50px; /* Rounded Capsule Shape */
            gap: 5px; /* Small gap between buttons */
            margin-bottom: 25px;
            flex-wrap: wrap;
            border: 1px solid #cbd5e0; /* Subtle border to define the area */
        }

        /* 2. The Buttons (Inactive State) - Darker Text */
        .btn-filter {
            border: none;
            background: transparent;
            color: #4a5568; /* Dark Grey - Much easier to read now */
            padding: 12px 28px;
            border-radius: 40px; /* Fully rounded pill shape */
            font-weight: 600;
            font-size: 15px; /* Slightly larger text */
            cursor: pointer;
            transition: all 0.3s ease;
            outline: none !important;
        }

            /* 3. Hover Effect - Subtle light up */
            .btn-filter:hover {
                color: #1a202c; /* Almost black on hover */
                background: rgba(255, 255, 255, 0.7);
            }

            /* 4. Active State - THE HIGHLIGHT (Teal Gradient) */
            .btn-filter.active {
                background: linear-gradient(135deg, #38b2ac 0%, #319795 100%); /* Your Theme Gradient */
                color: white !important; /* Force White Text */
                font-weight: 700;
                box-shadow: 0 4px 15px rgba(56, 178, 172, 0.4); /* Teal Glow Shadow */
                transform: translateY(-1px); /* Slight lift */
            }

        .agenda-info {
            flex: 1; /* Forces it to fill the remaining width */
            min-width: 0; /* Prevents flexbox layout issues with long text */
            padding-right: 20px; /* Optional: Adds breathing room before the right-side buttons */
        }

        .progress-container {
            margin-top: 15px;
            max-width: 600px; /* Ensures the bar never gets wider than this */
            width: 100%; /* Ensures it fills space up to the max-width */
        }

        /* 1. The Card Container - Clean & Modern */
        .stat-card {
            background: #fff;
            border-radius: 20px; /* Matches your filter pills */
            padding: 24px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
            transition: all 0.3s ease;
            border: 1px solid #f1f5f9;
            position: relative;
            overflow: hidden;
            /* Layout: Uses CSS Grid to align Icon Left, Text Right perfecty */
            display: grid;
            grid-template-columns: auto 1fr;
            grid-template-areas:
                "icon value"
                "icon label";
            align-items: center;
            column-gap: 20px;
        }

            /* Remove the old top stripe - we are going for a cleaner look */
            .stat-card::before {
                display: none;
            }

            /* Hover Effect - Lift & Deepen Shadow */
            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
                border-color: #e2e8f0;
            }

        /* 2. The Icon - Soft Tinted Style */
        .stat-card-icon {
            grid-area: icon;
            width: 64px;
            height: 64px;
            border-radius: 18px; /* Soft "Squircle" shape */
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* 3. Text Typography */
        .stat-card-value {
            grid-area: value;
            font-size: 32px; /* Bigger and bolder */
            font-weight: 800;
            color: #1a202c;
            line-height: 1;
            align-self: end; /* Pushes text down slightly to align with icon center */
            margin-bottom: 4px;
        }

        .stat-card-label {
            grid-area: label;
            color: #718096;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            align-self: start;
        }

        /* 4. Color Themes - Soft Backgrounds & Hover Pop */

        /* Purple (Teal in your logic) */
        .stat-card-icon.purple {
            background: rgba(56, 178, 172, 0.12);
            color: #38b2ac;
        }

        .stat-card:hover .stat-card-icon.purple {
            background: #38b2ac;
            color: white;
            transform: scale(1.1) rotate(6deg);
            box-shadow: 0 10px 20px rgba(56, 178, 172, 0.3);
        }

        /* Blue */
        .stat-card-icon.blue {
            background: rgba(66, 153, 225, 0.12);
            color: #4299e1;
        }

        .stat-card:hover .stat-card-icon.blue {
            background: #4299e1;
            color: white;
            transform: scale(1.1) rotate(-6deg);
            box-shadow: 0 10px 20px rgba(66, 153, 225, 0.3);
        }

        /* Green */
        .stat-card-icon.green {
            background: rgba(72, 187, 120, 0.12);
            color: #48bb78;
        }

        .stat-card:hover .stat-card-icon.green {
            background: #48bb78;
            color: white;
            transform: scale(1.1) rotate(6deg);
            box-shadow: 0 10px 20px rgba(72, 187, 120, 0.3);
        }

        /* Orange */
        .stat-card-icon.orange {
            background: rgba(237, 137, 54, 0.12);
            color: #ed8936;
        }

        .stat-card:hover .stat-card-icon.orange {
            background: #ed8936;
            color: white;
            transform: scale(1.1) rotate(-6deg);
            box-shadow: 0 10px 20px rgba(237, 137, 54, 0.3);
        }

        /* Red */
        .stat-card-icon.red {
            background: rgba(245, 101, 101, 0.12);
            color: #f56565;
        }

        .stat-card:hover .stat-card-icon.red {
            background: #f56565;
            color: white;
            transform: scale(1.1) rotate(6deg);
            box-shadow: 0 10px 20px rgba(245, 101, 101, 0.3);
        }

        /*        Hide the logics*/

        .decision-section {
            display: none;
        }

        .btn-save-all {
            display: none;
        }

        .header-left {
            display: flex;
            align-items: center;
        }

        .header-logo {
            height: 55px; /* Fixed height from your original code */
            width: auto; /* Maintain aspect ratio */
            display: block;
            /* REMOVED: all negative margins */
        }

        .user-label {
            color: #4a5568;
            font-weight: 600;
            font-size: 16px;
            margin-right: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />

        <!-- Header -->
        <div class="admin-header">
            <div class="header-left">
                <img src="../Images/Expo_logo_Full.png" alt="Expo Logo" class="header-logo" />
            </div>

            <div class="admin-info">
                <span class="user-label">
                    <i class="fas fa-user-shield"></i>
                    <asp:Label ID="lblAdminName" runat="server" />
                </span>

                <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="~/Admin/Dashboard.aspx" CssClass="btn-info">
            <i class="fas fa-arrow-left"></i> Back
                </asp:HyperLink>

                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout"
                    OnClick="btnLogout_Click" />
            </div>
        </div>

        <div class="dashboard-container">

            <!-- Statistics Dashboard -->
            <div class="stats-dashboard">
                <div class="stat-card card-purple">
                    <div class="stat-card-icon purple">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <div class="stat-card-value">
                        <asp:Label ID="lblTotalAgendas" runat="server" Text="0" />
                    </div>
                    <div class="stat-card-label">Total Sessions</div>
                </div>

                <div class="stat-card card-blue">
                    <div class="stat-card-icon blue">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-card-value">
                        <asp:Label ID="lblTotalSpeakers" runat="server" Text="0" />
                    </div>
                    <div class="stat-card-label">Total Speakers</div>
                </div>

                <div class="stat-card card-green">
                    <div class="stat-card-icon green">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-card-value">
                        <asp:Label ID="lblApprovedSpeakers" runat="server" Text="0" />
                    </div>
                    <div class="stat-card-label">Approved Speakers</div>
                </div>

                <div class="stat-card card-orange">
                    <div class="stat-card-icon orange">
                        <i class="fas fa-user-tie"></i>
                    </div>
                    <div class="stat-card-value">
                        <asp:Label ID="lblTotalAdvisors" runat="server" Text="0" />
                    </div>
                    <div class="stat-card-label">Advisory Panel</div>
                </div>

                <div class="stat-card card-red">
                    <div class="stat-card-icon red">
                        <i class="fas fa-hourglass-half"></i>
                    </div>
                    <div class="stat-card-value">
                        <asp:Label ID="lblPendingReview" runat="server" Text="0" />
                    </div>
                    <div class="stat-card-label">Needs Review</div>
                </div>

                <div class="stat-card card-green">
                    <div class="stat-card-icon green">
                        <i class="fas fa-clipboard-check"></i>
                    </div>
                    <div class="stat-card-value">
                        <asp:Label ID="lblFinalizedAgendas" runat="server" Text="0" />
                    </div>
                    <div class="stat-card-label">Finalized Sessions</div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <h3><i class="fas fa-filter"></i>Filter Sessions</h3>
                <div class="filter-buttons">
                    <asp:Button ID="btnAll" runat="server" Text="All Sessions (0)" CssClass="btn-filter active"
                        CommandArgument="All" OnClick="btnStatusFilter_Click" />
                    <asp:Button ID="btnNeedsReview" runat="server" Text="Needs Review (0)" CssClass="btn-filter"
                        CommandArgument="NeedsReview" OnClick="btnStatusFilter_Click" />
                    <asp:Button ID="btnFinalized" runat="server" Text="Finalized (0)" CssClass="btn-filter"
                        CommandArgument="Finalized" OnClick="btnStatusFilter_Click" />
                    <asp:Button ID="btnPending" runat="server" Text="Pending Ratings (0)" CssClass="btn-filter"
                        CommandArgument="Pending" OnClick="btnStatusFilter_Click" />
                </div>
                <asp:Panel ID="pnlSearch" runat="server" CssClass="search-box" DefaultButton="btnSearch">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="🔍 Search agendas by title, day, or track..." />
                    <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
                </asp:Panel>
            </div>

            <!-- No Records Panel -->
            <asp:Panel ID="pnlNoRecords" runat="server" Visible="false" CssClass="no-records">
                <i class="fas fa-inbox"></i>
                <h3>No agendas found</h3>
                <p>Try adjusting your filters or search criteria</p>
            </asp:Panel>

            <!-- Agendas Repeater -->
            <asp:Repeater ID="rptAgendas" runat="server" OnItemCommand="rptAgendas_ItemCommand"
                OnItemDataBound="rptAgendas_ItemDataBound">
                <ItemTemplate>
                    <div id="agenda_<%# Eval("AgendaID") %>" class="agenda-card <%# Convert.ToInt32(Eval("AgendaID")) == ExpandedAgendaID ? "expanded" : "" %>">

                        <div class="agenda-header" onclick="toggleAgenda(<%# Eval("AgendaID") %>); return false;">
                            <div class="agenda-info">
                                <h3><%# Eval("Title") %></h3>
                                <div class="agenda-meta">
                                    <span><i class="fas fa-calendar"></i><%# Eval("Day") %></span>
                                    <span><i class="fas fa-layer-group"></i><%# Eval("Track") %></span>
                                    <span><i class="fas fa-clock"></i><%# Eval("Time") %></span>
                                </div>
                                <div class="stats-row">
                                    <div class="stat-item">
                                        <span class="stat-value"><%# Eval("TotalSpeakers") %></span>
                                        <span class="stat-label">Speakers Applied</span>
                                    </div>
                                    <div class="stat-item">
                                        <span class="stat-value"><%# Eval("TotalAdvisorsRated") %></span>
                                        <span class="stat-label">Advisors Rated</span>
                                    </div>
                                    <div class="stat-item">
                                        <span class="stat-value"><%# String.Format("{0:F1} ★", Eval("AvgRating")) %></span>
                                        <span class="stat-label">Avg Rating</span>
                                    </div>
                                    <div class="stat-item">
                                        <span class="stat-value"><%# Eval("ApprovedSpeakers") %></span>
                                        <span class="stat-label">Approved</span>
                                    </div>
                                </div>
                                <div class="progress-container">
                                    <div class="progress">
                                        <div class="progress-fill" style="width: <%# Eval("CompletionPercentage") %>%"></div>
                                    </div>
                                    <small style="color: #718096; margin-top: 8px; display: block; font-weight: 600;">
                                        <%# String.Format("{0:F0}% Finalized", Eval("CompletionPercentage")) %>
                                    </small>
                                </div>
                            </div>
                            <div style="text-align: right;">
                                <%# GetStatusBadge(Eval("StatusCategory")) %>
                                <button class="dropdown-toggle-btn" type="button"
                                    aria-expanded="false" aria-label="Toggle agenda details"
                                    onclick="toggleAgenda(<%# Eval("AgendaID") %>); return false;">
                                    <i class="fas fa-chevron-down toggle-icon"></i>
                                </button>
                            </div>

                        </div>

                        <asp:Panel ID="pnlSpeakers" runat="server" CssClass="speakers-section" Visible="false" />
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Loading Spinner -->
        <div class="loading-spinner" id="loadingSpinner">
            <div class="spinner"></div>
            <p style="text-align: center; margin-top: 15px; color: #667eea; font-weight: 600;">Loading...</p>
        </div>

        <!-- Profile Modal -->
        <div class="modal-overlay" id="profileModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><i class="fas fa-user"></i>Speaker Profile & Comments</h3>
                    <button type="button" class="modal-close" onclick="closeProfileModal()">×</button>
                </div>
                <div class="modal-body" id="profileModalBody">
                    <p style="text-align: center; color: #a0aec0; padding: 40px;">Loading profile...</p>
                </div>
            </div>
        </div>

        <!-- Hidden Fields -->
        <asp:HiddenField ID="hdnExpandedAgendaID" runat="server" Value="0" />
        <asp:HiddenField ID="hdnCurrentFilter" runat="server" Value="All" />
        <asp:Literal ID="litMessage" runat="server" />
    </form>

    <script>

        function toggleAgenda(agendaId) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            var hdnField = document.getElementById('<%= hdnExpandedAgendaID.ClientID %>');
            var currentExpanded = hdnField.value;
            var agendaCard = document.getElementById('agenda_' + agendaId);

            // Find the toggle icon element specific to this card
            var toggleIcon = agendaCard ? agendaCard.querySelector('.toggle-icon') : null;

            // Check if the current card is expanded (i.e., we want to collapse it)
            if (currentExpanded == agendaId) {
                // Client-side collapse to prevent postback
                hdnField.value = '0';
                if (agendaCard) {
                    agendaCard.classList.remove('expanded');
                    var pnlSpeakers = agendaCard.querySelector('.speakers-section');
                    if (pnlSpeakers) {
                        pnlSpeakers.style.display = 'none';
                    }
                }
                document.getElementById('loadingSpinner').classList.remove('show');
                return false;
            } else {
                // We want to EXPAND:
                // REMOVED: hdnField.value = agendaId;  <-- THIS WAS CAUSING THE BUG

                // Show loading spinner
                document.getElementById('loadingSpinner').classList.add('show');

                // Trigger postback
                __doPostBack('Toggle', agendaId);
                return false;
            }
        }

        function closeProfileModal() {
            document.getElementById('profileModal').classList.remove('show');
        }

        function saveAllDecisions(agendaId) {
            console.log('=== Save All Decisions Debug ===');
            console.log('AgendaID:', agendaId);

            var decisions = [];
            var currentAgendaCard = document.getElementById('agenda_' + agendaId);

            if (!currentAgendaCard) {
                console.error('Agenda card not found for ID:', agendaId);
                showAlert('Error: Agenda card not found', 'danger');
                return;
            }

            var speakerCards = currentAgendaCard.querySelectorAll('.speaker-card');
            console.log('Found speaker cards:', speakerCards.length);

            speakerCards.forEach(function (card) {
                var speakerId = parseInt(card.getAttribute('data-speaker-id'));
                console.log('Processing speaker:', speakerId);

                var selectedRadio = card.querySelector('input[type="radio"]:checked');

                if (selectedRadio) {
                    var decision = selectedRadio.value;
                    console.log('Speaker', speakerId, 'decision:', decision);

                    var isApproved = null;

                    if (decision === 'approved') isApproved = true;
                    else if (decision === 'rejected') isApproved = false;

                    decisions.push({
                        SpeakerID: speakerId,
                        IsApproved: isApproved,
                        Comments: null
                    });
                }
            });

            console.log('Total decisions to save:', decisions.length);
            console.log('Decisions array:', JSON.stringify(decisions));

            if (decisions.length === 0) {
                showAlert('⚠️ Please select a decision for at least one speaker.', 'danger');
                return;
            }

            var btn = event.target;
            var originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
            btn.disabled = true;

            console.log('Sending AJAX request...');

            $.ajax({
                type: "POST",
                url: "<%= ResolveUrl("~/SuperAdmin/FinalSpeakerSelection.aspx/SaveSpeakerDecisions") %>",
                data: JSON.stringify({
                    agendaId: agendaId,
                    decisions: decisions
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log('AJAX Success Response:', response);

                    btn.innerHTML = originalText;
                    btn.disabled = false;

                    if (response.d && response.d.success) {
                        showAlert('✅ ' + response.d.message, 'success');
                        setTimeout(function () { location.reload(); }, 2000);
                    } else {
                        var errorMsg = response.d ? response.d.message : 'Unknown error occurred';
                        console.error('Save failed:', errorMsg);
                        showAlert('❌ ' + errorMsg, 'danger');
                    }
                },
                error: function (xhr, status, error) {
                    console.error('AJAX Error:', {
                        status: status,
                        error: error,
                        responseText: xhr.responseText,
                        statusCode: xhr.status
                    });

                    btn.innerHTML = originalText;
                    btn.disabled = false;

                    var errorMessage = 'Error saving decisions';
                    try {
                        var response = JSON.parse(xhr.responseText);
                        if (response.Message) {
                            errorMessage = response.Message;
                        } else if (response.ExceptionMessage) {
                            errorMessage = response.ExceptionMessage;
                        }
                    } catch (e) {
                        errorMessage = xhr.responseText || error || 'Unknown error';
                    }

                    showAlert('❌ ' + errorMessage, 'danger');
                }
            });
        }

        function viewSpeakerProfile(speakerId, agendaId) {
            event.preventDefault();
            event.stopPropagation();

            var modal = document.getElementById('profileModal');
            var modalBody = document.getElementById('profileModalBody');
            var loader = document.getElementById('loadingSpinner');

            loader.classList.add('show');
            modal.classList.add('show');
            modalBody.innerHTML = '<p style="text-align: center; color: #a0aec0; padding: 40px;"><i class="fas fa-spinner fa-spin" style="font-size: 32px; display: block; margin-bottom: 15px;"></i>Loading profile and comments...</p>';

            fetch('<%= ResolveUrl("~/SuperAdmin/FinalSpeakerSelection.aspx/GetSpeakerProfileAndComments") %>', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ speakerId: speakerId, agendaId: agendaId })
            })
                .then(response => response.json())
                .then(data => {
                    loader.classList.remove('show');
                    if (data.d && data.d.success) {
                        modalBody.innerHTML = data.d.html;
                    } else {
                        modalBody.innerHTML = '<p style="color: #f56565; text-align: center; padding: 40px;"><i class="fas fa-exclamation-triangle" style="font-size: 32px; display: block; margin-bottom: 15px;"></i>Error loading data: ' + (data.d ? data.d.error : 'Unknown error') + '</p>';
                    }
                })
                .catch(error => {
                    loader.classList.remove('show');
                    modalBody.innerHTML = '<p style="color: #f56565; text-align: center; padding: 40px;"><i class="fas fa-exclamation-triangle" style="font-size: 32px; display: block; margin-bottom: 15px;"></i>Error: ' + error + '</p>';
                });
        }

        function showAlert(message, type) {
            var alertBox = document.createElement('div');
            alertBox.className = 'alert alert-' + type;
            alertBox.innerHTML = message;
            document.body.appendChild(alertBox);
            setTimeout(function () {
                alertBox.style.animation = 'slideOut 0.3s ease-out';
                setTimeout(function () { alertBox.remove(); }, 300);
            }, 4000);
        }

        window.onclick = function (event) {
            if (event.target.classList.contains('modal-overlay')) {
                event.target.classList.remove('show');
            }
        }

        window.addEventListener('load', function () {
            setTimeout(function () {
                document.getElementById('loadingSpinner').classList.remove('show');
            }, 500);
        });

        // Add CSS for slideOut animation
        var style = document.createElement('style');
        style.textContent = '@keyframes slideOut { from { transform: translateX(0); opacity: 1; } to { transform: translateX(400px); opacity: 0; } }';
        document.head.appendChild(style);

        function toggleAgendaDetails(agendaId, element) {
            var detailsDiv = document.getElementById('agendaDetails_' + agendaId);
            var arrow = element.querySelector('.dropdown-arrow');
            var cardBody = element.closest('.agenda-card-body');

            if (detailsDiv.style.display === 'none' || detailsDiv.style.display === '') {
                // Expand
                detailsDiv.style.display = 'block';
                arrow.style.transform = 'rotate(180deg)';
                cardBody.classList.add('expanded');
            } else {
                // Collapse
                detailsDiv.style.display = 'none';
                arrow.style.transform = 'rotate(0deg)';
                cardBody.classList.remove('expanded');
            }
        }
    </script>
</body>
</html>
