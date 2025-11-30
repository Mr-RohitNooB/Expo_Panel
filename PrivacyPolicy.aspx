<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrivacyPolicy.aspx.cs" Inherits="Expo_Panel.PrivacyPolicy" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Privacy Policy | Lubricant India Expo</title>

    <!-- Favicons (Same as Index) -->
    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" media="(prefers-color-scheme: light)" />
    <link rel="icon" type="image/png" sizes="16x16" href="/Images/favicon_io_Lubricant_India_Expo/favicon-16x16.png" media="(prefers-color-scheme: light)" />
    <link rel="apple-touch-icon" href="/Images/favicon_io_Lubricant_India_Expo/apple-touch-icon.png" media="(prefers-color-scheme: light)" />
    <link rel="shortcut icon" href="/Images/favicon_io_Lubricant_India_Expo/favicon.ico" media="(prefers-color-scheme: light)" />

    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" media="(prefers-color-scheme: dark)" />
    <link rel="icon" type="image/png" sizes="16x16" href="/Images/favicon_io_Lubricant_India_Expo/favicon-16x16.png" media="(prefers-color-scheme: dark)" />
    <link rel="apple-touch-icon" href="/Images/favicon_io_Lubricant_India_Expo/apple-touch-icon.png" media="(prefers-color-scheme: dark)" />
    <link rel="shortcut icon" href="/Images/favicon_io_Lubricant_India_Expo/favicon.ico" media="(prefers-color-scheme: dark)" />

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <!-- CSS Styles (Copied from Index for consistency) -->
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
            background-color: #f8fafc;
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

        /* Page Banner (Modified Hero) */
        .page-banner {
            background: linear-gradient(135deg, #3D3935 0%, #5C5550 50%, #3D3935 100%);
            padding: 120px 20px 60px; /* Reduced padding compared to main hero */
            text-align: center;
            color: #fff;
            position: relative;
            overflow: hidden;
        }

            .page-banner::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><defs><pattern id="grid" width="100" height="100" patternUnits="userSpaceOnUse"><path d="M 100 0 L 0 0 0 100" fill="none" stroke="rgba(217,74,43,0.1)" stroke-width="1"/></pattern></defs><rect width="100%" height="100%" fill="url(%23grid)"/></svg>');
                opacity: 0.5;
            }

            .page-banner h1 {
                font-size: 42px;
                margin-bottom: 10px;
                background: linear-gradient(135deg, #D94A2B 0%, #FF6B4A 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                position: relative;
                z-index: 1;
            }

            .page-banner p {
                font-size: 18px;
                opacity: 0.9;
                position: relative;
                z-index: 1;
            }

        /* Content Section */
       .content-section {
    padding: 1px 20px;
    max-width: 1000px;
    margin: 0 auto;
    background: white;
    margin-top: 3px;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
    position: relative;
    z-index: 2;
    margin-bottom: 60px;
}

        .policy-text h2 {
            color: #3D3935;
            font-size: 24px;
            margin-top: 30px;
            margin-bottom: 15px;
            border-left: 4px solid #D94A2B;
            padding-left: 15px;
        }

        .policy-text p {
            margin-bottom: 15px;
            color: #555;
            text-align: justify;
        }

        .policy-text ul, .policy-text ol {
            margin-left: 20px;
            margin-bottom: 15px;
            color: #555;
        }

        .policy-text li {
            margin-bottom: 10px;
        }

        .policy-text strong {
            color: #333;
        }

        /* Footer (Same as Index) */
        .footer {
            background: #3D3935;
            color: #fff;
            padding: 40px 20px 40px 20px;
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

        /* Responsive */
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

            .page-banner h1 {
                font-size: 32px;
            }

            .content-section {
                padding: 30px;
                margin-top: 0;
                border-radius: 0;
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
                    <a href="Index.aspx">
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
                    <li class="nav-item"><a href="Index.aspx#conference" class="nav-link">Conference</a></li>
                    <li class="nav-item"><a href="Index.aspx#speakers" class="nav-link">Speakers</a></li>
                    <li class="nav-item"><a href="Index.aspx#exhibitors" class="nav-link">Exhibitors</a></li>
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

        <!-- Page Banner -->
        <section class="page-banner">
            <h1>Privacy Policy</h1>
            <p>Transparency and Trust</p>
        </section>

        <!-- Privacy Policy Content -->
        <div class="content-section">
            <div class="policy-text">
                <h2>Introduction</h2>
                <p>At Lubricant India Expo, we value the privacy of our visitors and are committed to protecting their personal information. This detailed Privacy Policy explains the types of information we collect, how we use and safeguard it, and the rights you have concerning your data.</p>

                <h2>Scope of this Policy</h2>
                <p>This Privacy Policy applies exclusively to our online activities and is relevant to visitors of our website with regard to the information they share and/or collect on the website. This policy does not extend to any information collected offline or through channels other than this website.</p>

                <h2>Consent</h2>
                <p>By using our website, you hereby consent to our Privacy Policy and agree to its terms.</p>

                <h2>Information We Collect</h2>
                <p>We collect two types of information:</p>
                <ol>
                    <li><strong>Personal Information:</strong> This includes data that can personally identify you, such as your name, email address, phone number, company name, and address. We collect this information when you voluntarily provide it to us, for example, when you contact us through our website or register as exhibitor or visitor.</li>
                    <li><strong>Log File Information:</strong> Like many website operators, we collect information that your browser sends whenever you visit our website. This log file information includes your IP address, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks. We use this information for analysing trends, administering the site, tracking users’ movement on the website, and gathering demographic information.</li>
                </ol>

                <h2>How We Use Your Information</h2>
                <p>We use the information we collect for various purposes, including:</p>
                <ul>
                    <li>To provide, operate, and maintain our website: This includes ensuring the website functions properly, providing customer support, and making improvements to the site.</li>
                    <li>To personalize and enhance your experience: We may use your information to personalize your interactions with our website, such as by tailoring content and recommendations.</li>
                    <li>To understand and analyse how you use our website: We analyse user behaviour to improve our website’s design, content, and functionality.</li>
                    <li>To develop new products, services, features, and functionality: Your feedback and usage patterns help us create offerings that better meet your needs.</li>
                    <li>To communicate with you: We may use your contact information to send you updates, newsletters, promotional materials, or respond to your inquiries.</li>
                    <li>To detect and prevent fraud: We may use your information to identify and prevent fraudulent activities.</li>
                </ul>

                <h2>Cookies and Similar Technologies</h2>
                <p>We use cookies and similar tracking technologies to collect and store information about your preferences and how you interact with our website. However, Users can control the use of cookies at the individual browser level.</p>

                <h2>Third-Party Links</h2>
                <p>Lubricant India Expo Privacy Policy does not apply to other advertisers or websites. Our website may include links to external sites, and we encourage you to consult the respective Privacy Policies of these third-party websites for detailed information on their data practices.</p>

                <h2>Disclosure of Information</h2>
                <p>We will not disclose any information that we obtain from you to any third parties other than where we have specifically indicated on any application or registration form that the information will be provided to the particular exhibition or fair organizer and other third parties involved in making the arrangements for the exhibition or fair. When such personal information is obtained from yourself, we will take all practical steps to protect the personal information from misuse.</p>

                <h2>Changes to This Privacy Policy</h2>
                <p>We may update our Privacy Policy from time to time to reflect changes in our practices or for other operational, legal, or regulatory reasons. We will post any updates on this page, and the revised policy will be effective immediately upon posting.</p>

                <p style="margin-top: 30px; padding: 20px; background: #f1f5f9; border-left: 4px solid #D94A2B;">
                    If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at <a href="mailto:admin@lubricantindia.com" style="color: #D94A2B; text-decoration: none; font-weight: bold;">admin@lubricantindia.com</a>
                </p>
            </div>
        </div>

        <!-- Footer -->
        <footer class="footer">
            <div class="footer-content">
                <div class="footer-links">
                    <a href="Index.aspx">Home</a>
                    <a href="Index.aspx#conference">Conference</a>
                    <a href="Index.aspx#speakers">Speakers</a>
                    <a href="Index.aspx#exhibitors">Exhibitors</a>
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

        // Dropdown toggle for mobile
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
    </script>
</body>
</html>
