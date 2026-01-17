<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExhibitorDetails.aspx.cs" Inherits="Expo_Panel.ExhibitorDetails" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exhibitor Details | Lubricant India Expo 2026</title>

    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" />
    <link rel="icon" type="image/png" sizes="16x16" href="/Images/favicon_io_Lubricant_India_Expo/favicon-16x16.png" />
    <link rel="apple-touch-icon" href="/Images/favicon_io_Lubricant_India_Expo/apple-touch-icon.png" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        /* --- GLOBAL & TYPOGRAPHY --- */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-color: #f8fafc; /* Matches Conference.aspx */
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
            line-height: 1.6;
        }

        /* --- NAVBAR STYLES (MATCHING CONFERENCE.ASPX) --- */
        .custom-navbar {
            background: #ffffff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            transition: all 0.3s ease;
            border-bottom: 3px solid #D94A2B;
        }

            .custom-navbar .scrolled {
                background: rgba(255, 255, 255, 0.98);
                backdrop-filter: blur(10px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            }

        /* Fixed Width Container for Navbar & Body Alignment */
        .layout-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
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

        /* FIX: Align Logo Vertically */
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
            margin-bottom: 0;
            padding-left: 0;
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
        .nav-item {
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

        .nav-item:hover .dropdown-content {
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
            font-size: 24px;
            cursor: pointer;
            color: #333;
        }

        @media (max-width: 991px) {
            .nav-menu {
                display: none;
                flex-direction: column;
                position: absolute;
                top: 80px;
                left: 0;
                right: 0;
                background: #fff;
                padding: 20px;
                border-top: 2px solid #D94A2B;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                align-items: center;
                text-align: center;
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
        }

        /* --- PROFILE HEADER (Matches Conference.aspx) --- */
        .page-header-profile {
            /* Exact gradient from Conference.aspx */
            background: linear-gradient(135deg, #3D3935 0%, #5C5550 50%, #3D3935 100%);
            padding: 140px 0 60px; /* Padding for fixed navbar */
            color: #fff;
            position: relative;
            margin-bottom: 20px;
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        /* Profile Specifics */
        .company-logo-lg {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.2);
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            object-fit: contain;
            background: #fff;
        }

        .company-title {
            font-weight: 800;
            font-size: 36px;
            /* Gradient text effect */
            background: linear-gradient(135deg, #D94A2B 0%, #FF6B4A 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: inline-block;
            margin-bottom: 0.25rem;
        }

        /* Rest of Profile Styles */
        .social-icon {
            width: 40px;
            height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #eee;
            color: #555;
            border-radius: 50%;
            margin-right: 5px;
            text-decoration: none;
            font-size: 18px;
            transition: all 0.3s;
        }

            .social-icon:hover {
                background: #D94A2B;
                color: white;
                transform: translateY(-3px);
            }

        .section-title {
            font-weight: 700;
            border-bottom: 3px solid #D94A2B;
            padding-bottom: 10px;
            margin-bottom: 25px;
            display: inline-block;
        }

        .info-table td {
            padding: 8px 0;
            vertical-align: top;
        }

        .info-label {
            font-weight: 600;
            color: #666;
            width: 140px;
        }

        .enquiry-card {
            background: #fff;
            border: 1px solid #e1e1e1;
            border-top: 4px solid #D94A2B;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .btn-brand-outline {
            border: 1px solid #D94A2B;
            color: #D94A2B;
            background: transparent;
            transition: all 0.3s ease;
        }

            .btn-brand-outline:hover {
                background: #D94A2B;
                color: #fff;
            }

        /* --- FOOTER --- */
        .footer {
            background: #3D3935;
            color: #fff;
            padding: 40px 20px 40px;
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
        /* --- RESPONSIVE PROFILE BUTTONS --- */
        .btn-profile-action {
            width: 100%; /* Full width on mobile for easier tapping */
            padding: 10px 0; /* Consistent height */
            margin-bottom: 10px; /* Spacing between stacked buttons on mobile */
            text-align: center;
        }

        /* For Desktop and Tablets (screens wider than 768px) */
        @media (min-width: 768px) {
            .btn-profile-action {
                width: 180px; /* Fixed equal width for both buttons */
                margin-bottom: 0; /* Remove the mobile bottom margin */
                margin-left: 15px; /* Add space between the buttons */
                display: inline-block;
            }
        }

        .bootstrap-iso {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
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

        <nav class="custom-navbar" id="navbar">
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
                    <li class="nav-item"><a href="Exhibitors.aspx" class="nav-link" style="color: #D94A2B;">Exhibitors</a></li>
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

        <div class="page-header-profile">
            <div class="layout-container header-content">
                <div class="row align-items-center">
                    <div class="col-md-2 text-center text-md-start mb-3 mb-md-0">
                        <asp:Image ID="imgLogo" runat="server" CssClass="company-logo-lg" ImageUrl="~/Images/no-logo.png" />
                    </div>
                    <div class="col-md-7 text-center text-md-start">
                        <h1 class="company-title">
                            <asp:Label ID="lblCompanyName" runat="server"></asp:Label></h1>
                        <p class="mb-3" style="color: rgba(255,255,255,0.8);">
                            <i class="fas fa-map-marker-alt me-2" style="color: #D94A2B;"></i>
                            <asp:Label ID="lblLocation" runat="server"></asp:Label>
                        </p>
                        <div>
                            <span class="badge bg-light text-dark me-2 p-2 border">Hall:
                                <asp:Label ID="lblHall" runat="server"></asp:Label></span>
                            <span class="badge p-2" style="background: #D94A2B; color: #fff;">Booth:
                                <asp:Label ID="lblBooth" runat="server"></asp:Label></span>
                        </div>
                    </div>
                    <div class="col-md-3 d-flex flex-column gap-2 align-items-center align-items-md-end mt-4 mt-md-0">

                        <button type="button" class="btn btn-outline-light"
                            style="min-width: 170px; padding: 8px 20px;"
                            onclick="showBookmarkPopup()">
                            <i class="far fa-bookmark me-1"></i>Bookmark
                        </button>

                        <button type="button" class="btn btn-danger" style="background: #D94A2B; border: none; padding: 8px 20px; min-width: 170px;">
                            Meeting Request
                        </button>

                    </div>
                </div>
            </div>
        </div>

        <div class="layout-container py-5" style="min-height: 50vh;">
            <div class="row">
                <div class="col-lg-8">
                    <div class="mb-5">
                        <h4 class="section-title">Company Overview</h4>
                        <div class="card border-0 shadow-sm p-4">
                            <table class="table table-borderless info-table mb-0">
                                <tr>
                                    <td class="info-label">Establishment Year</td>
                                    <td>
                                        <asp:Label ID="lblYearEst" runat="server"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="info-label">Nature of Biz</td>
                                    <td>
                                        <asp:Label ID="lblNature" runat="server"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="info-label">Product Index</td>
                                    <td>
                                        <asp:Label ID="lblCategories" runat="server"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="info-label">Market Index</td>
                                    <td>
                                        <asp:Label ID="lblMarkets" runat="server"></asp:Label></td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <div class="mb-5">
                        <h4 class="section-title">Exhibitor Profile</h4>
                        <div class="card border-0 shadow-sm p-4">
                            <p class="mb-0" style="white-space: pre-wrap;">
                                <asp:Label ID="lblProfile" runat="server"></asp:Label>
                            </p>
                        </div>
                    </div>

                    <div class="mb-5">
                        <h4 class="section-title">Product Showcase</h4>
                        <div class="row g-3">
                            <div class="col-md-4">
                                <asp:Image ID="imgProduct1" runat="server" CssClass="img-fluid rounded shadow-sm border" Visible="false" />
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card mb-4 border-0 shadow-sm">
                        <div class="card-body p-4">
                            <h5 class="fw-bold mb-3">Contact Information</h5>
                            <p class="mb-2">
                                <i class="fas fa-globe me-2 text-muted"></i>
                                <asp:HyperLink ID="lnkWebsite" runat="server" Target="_blank" CssClass="text-decoration-none text-dark">Visit Website</asp:HyperLink>
                            </p>
                            <p class="mb-3">
                                <i class="fas fa-map me-2 text-muted"></i>
                                <asp:Label ID="lblFullAddress" runat="server"></asp:Label>
                            </p>
                            <hr />
                            <div class="mb-3">
                                <asp:HyperLink ID="lnkFb" runat="server" CssClass="social-icon"><i class="fab fa-facebook-f"></i></asp:HyperLink>
                                <asp:HyperLink ID="lnkTwitter" runat="server" CssClass="social-icon"><i class="fab fa-twitter"></i></asp:HyperLink>
                                <asp:HyperLink ID="lnkIn" runat="server" CssClass="social-icon"><i class="fab fa-linkedin-in"></i></asp:HyperLink>
                                <asp:HyperLink ID="lnkYt" runat="server" CssClass="social-icon"><i class="fab fa-youtube"></i></asp:HyperLink>
                            </div>
                            <asp:HyperLink ID="btnBrochure" runat="server" CssClass="btn btn-brand-outline w-100" Visible="false"><i class="fas fa-file-pdf me-2"></i> Download Brochure</asp:HyperLink>
                        </div>
                    </div>

                    <div class="enquiry-card">
                        <h5 class="fw-bold mb-3">Business Enquiry</h5>
                        <div class="mb-3">
                            <label class="form-label small text-muted">I am interested in:</label>
                            <select class="form-select">
                                <option>Product Information</option>
                                <option>Scheduling a Meeting</option>
                                <option>General Enquiry</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <input type="text" class="form-control" placeholder="Your Name">
                        </div>
                        <div class="mb-3">
                            <input type="email" class="form-control" placeholder="Your Email">
                        </div>
                        <div class="mb-3">
                            <textarea class="form-control" rows="3" placeholder="Message"></textarea>
                        </div>
                        <button type="button" class="btn btn-dark w-100" style="background: #333;">Send Enquiry</button>
                    </div>
                </div>
            </div>
        </div>

        <footer class="footer">
            <div class="footer-content">
                <div class="footer-links">
                    <a href="Index.aspx">Home</a>
                    <a href="Conference.aspx">Conference</a>
                    <a href="Index.aspx#speakers">Speakers</a>
                    <a href="Exhibitors.aspx">Exhibitors</a>
                    <a href="TermsConditions.aspx">Terms & Conditions</a>
                    <a href="PrivacyPolicy.aspx">Privacy Policy</a>
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
            <h3>Shortlist Exhibitors</h3>
            <p>Please login to your <b>Visitor Dashboard</b> to bookmark exhibitors and manage your shortlist.</p>
            <div class="bookmark-actions">
                <button type="button" class="btn-cancel" onclick="closeBookmarkPopup()">Cancel</button>
                <a href="User/VisitorLogin.aspx" class="btn-login-theme">Login to Dashboard</a>
            </div>
        </div>
    </div>
    <script>
        // Navbar Scroll Effect
        window.addEventListener('scroll', function () {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 50) navbar.classList.add('scrolled');
            else navbar.classList.remove('scrolled');
        });

        // Mobile Menu Toggle
        function toggleMobileMenu() {
            document.getElementById('navMenu').classList.toggle('active');
        }

        // Dropdown Logic
        document.querySelectorAll('.nav-item.dropdown > .nav-link').forEach(dropdownLink => {
            dropdownLink.addEventListener('click', function (e) {
                const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
                const isMobileView = window.getComputedStyle(mobileMenuToggle).display === 'block';

                if (isMobileView) {
                    e.preventDefault();
                    const dropdownContent = this.nextElementSibling;
                    if (dropdownContent.style.display === 'block') {
                        dropdownContent.style.display = 'none';
                    } else {
                        dropdownContent.style.display = 'block';
                    }
                }
            });
        });

        window.addEventListener('scroll', function () {
            const navbar = document.getElementById('navbar');
            // Ensure we toggle the new class name
            if (window.scrollY > 50) navbar.classList.add('scrolled');
            else navbar.classList.remove('scrolled');
        });

        // Close menu click outside logic (around line 520)
        document.addEventListener('click', function (e) {
            const navMenu = document.getElementById('navMenu');
            const mobileToggle = document.querySelector('.mobile-menu-toggle');
            const navbar = document.getElementById('navbar');

            // This logic relies on the ID="navbar", so it still works fine without changes.
            if (!navbar.contains(e.target) && navMenu.classList.contains('active')) {
                navMenu.classList.remove('active');
            }
        });

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
