<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Exhibitors.aspx.cs" Inherits="Expo_Panel.Exhibitors" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exhibitors | Lubricant India Expo 2026</title>
    <link rel="icon" type="image/png" sizes="32x32" href="Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        /* --- GLOBAL STYLES (Copied from Index) --- */
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
            border-bottom: 3px solid #D94A2B;
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

            .nav-link:hover, .nav-link.active {
                background: rgba(217, 74, 43, 0.1);
                color: #D94A2B;
            }

        /* Dropdown Styles */
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

        /* Mobile Menu */
        .mobile-menu-toggle {
            display: none;
            background: none;
            border: none;
            color: #3D3935;
            font-size: 24px;
            cursor: pointer;
        }

        /* --- PAGE SPECIFIC HEADER --- */
        .page-header {
            background: linear-gradient(135deg, #3D3935 0%, #5C5550 100%);
            padding: 120px 20px 60px; /* Top padding accounts for fixed navbar */
            text-align: center;
            color: #fff;
        }

            .page-header h1 {
                font-size: 36px;
                margin-bottom: 10px;
            }

            .page-header p {
                font-size: 18px;
                opacity: 0.9;
            }

        /* --- EXHIBITOR GRID STYLES (Copied) --- */
        .section {
            padding: 60px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .exhibitors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); /* Slightly wider cards */
            gap: 25px;
        }

        .exhibitor-card {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-left: 4px solid #D94A2B;
            border-radius: 8px;
            padding: 20px;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 140px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

            .exhibitor-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.08);
                border-color: #D94A2B;
            }

        .exhibitor-name i {
            color: #cbd5e1;
            margin-right: 6px;
            font-size: 12px;
        }

        /* Footer */
        .footer {
            background: #3D3935;
            color: #fff;
            padding: 40px 20px;
            text-align: center;
            margin-top: auto;
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

            .page-header {
                padding-top: 100px;
            }
        }

        /* --- Modal & Button Styles --- */
        .btn-view-profile {
            display: block;
            width: 100%;
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
            text-align: center;
        }

            .btn-view-profile:hover {
                background: #D94A2B;
                color: white;
            }

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
            max-width: 600px;
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
        /* Compact Contact items inside Modal */
        .contact-item-compact {
            display: block;
            color: #D94A2B;
            text-decoration: none;
            font-size: 13px;
            transition: all 0.3s ease;
        }

            .contact-item-compact:hover {
                transform: translateY(-2px);
            }

        .btn-compact {
            background: linear-gradient(135deg, #D94A2B 0%, #FF6B4A 100%);
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

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
                    <li class="nav-item"><a href="Exhibitors.aspx" class="nav-link active">Exhibitors</a></li>
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
            <h1>Our Exhibitors</h1>
            <p>Meet the industry leaders showcasing at Lubricant India Expo 2026</p>
        </header>

        <section class="section">
            <div class="exhibitors-grid">
                <p style="grid-column: 1/-1; text-align: center; color: #666;">Loading exhibitors...</p>
            </div>
        </section>

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
    <div id="exhibitorModal" class="modal-overlay">
        <div class="modal-content">
            <button type="button" class="close-modal" onclick="closeExhibitorModal()">×</button>
            <div style="padding: 30px;">
                <div style="text-align: center; margin-bottom: 25px;">
                    <h2 id="exhName" style="color: #1e293b; margin-bottom: 5px;"></h2>
                    <p id="exhDesignation" style="color: #64748b; font-size: 16px;"></p>
                    <div id="exhCompany" style="color: #D94A2B; font-weight: 700; font-size: 18px; margin-top: 5px;"></div>
                </div>
                <hr style="border: 0; height: 1px; background: #e2e8f0; margin: 20px 0;">

                <div id="exhProductSection" style="display: none; margin-bottom: 25px;">
                    <h5 style="color: #1e293b; font-size: 14px; font-weight: 700; margin-bottom: 10px; text-transform: uppercase;">Product Showcase</h5>
                    <img id="exhProductImg" src="" style="width: 100%; border-radius: 8px; border: 1px solid #e2e8f0;">
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 25px;">
                    <a id="linkWeb" href="#" target="_blank" class="contact-item-compact" style="display: none; padding: 10px; background: #f8fafc; border-radius: 6px; text-align: center;">
                        <i class="fas fa-globe" style="color: #64748b; font-size: 20px; display: block; margin-bottom: 5px;"></i>Website
                    </a>
                    <a id="linkLinkedIn" href="#" target="_blank" class="contact-item-compact" style="display: none; padding: 10px; background: #f8fafc; border-radius: 6px; text-align: center;">
                        <i class="fab fa-linkedin" style="color: #0077b5; font-size: 20px; display: block; margin-bottom: 5px;"></i>LinkedIn
                    </a>
                    <a id="linkTwitter" href="#" target="_blank" class="contact-item-compact" style="display: none; padding: 10px; background: #f8fafc; border-radius: 6px; text-align: center;">
                        <i class="fab fa-twitter" style="color: #1da1f2; font-size: 20px; display: block; margin-bottom: 5px;"></i>Twitter
                    </a>
                    <a id="linkFacebook" href="#" target="_blank" class="contact-item-compact" style="display: none; padding: 10px; background: #f8fafc; border-radius: 6px; text-align: center;">
                        <i class="fab fa-facebook" style="color: #1877f2; font-size: 20px; display: block; margin-bottom: 5px;"></i>Facebook
                    </a>
                </div>

                <a id="btnBrochure" href="#" download class="btn-compact" style="display: none; text-align: center; display: block;">
                    <i class="fas fa-file-pdf" style="margin-right: 8px;"></i>Download Brochure
                </a>
            </div>
        </div>
    </div>

    <script>
        // Store exhibitor data globally so the modal can access it
        let exhibitorsData = [];

        function toggleMobileMenu() {
            const navMenu = document.getElementById('navMenu');
            navMenu.classList.toggle('active');
        }

        // Mobile dropdown logic
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

        document.addEventListener("DOMContentLoaded", function () {
            loadAllExhibitors();
        });

        async function loadAllExhibitors() {
            try {
                const response = await fetch('Exhibitors.aspx/GetAllExhibitors', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' }
                });
                const data = await response.json();

                // 1. STORE DATA GLOBALLY
                exhibitorsData = data.d;

                const grid = document.querySelector('.exhibitors-grid');
                if (!exhibitorsData || exhibitorsData.length === 0) {
                    grid.innerHTML = '<p style="text-align:center; grid-column:1/-1; padding: 40px;">No exhibitors found.</p>';
                    return;
                }

                let html = '';
                // 2. USE INDEX (i) IN LOOP FOR BUTTON CLICK
                exhibitorsData.forEach((e, i) => {
                    let locParts = [];
                    if (e.City) locParts.push(e.City);
                    if (e.Country) locParts.push(e.Country);
                    let locationStr = locParts.join(', ');

                    html += `
                        <div class="exhibitor-card">
                            <div style="margin-bottom:12px;">
                                <div style="font-size:17px; font-weight:700; color:#D94A2B; line-height:1.3;">${e.FullName}</div>
                                <div style="font-size:13px; color:#64748b; font-weight:600; margin-top:2px;">${e.Designation}</div>
                            </div>
                            <div style="border-top:1px solid #f1f5f9; padding-top:10px;">
                                <div class="exhibitor-name" style="font-size:15px; margin-bottom:4px; color:#1e293b; font-weight:700;">
                                    <i class="fas fa-building"></i> ${e.Company}
                                </div>
                                ${locationStr ? `<div style="font-size:13px; color:#94a3b8;"><i class="fas fa-map-marker-alt" style="margin-right:8px; font-size:12px; margin-left:2px;"></i>${locationStr}</div>` : ''}
                                
                                <button type="button" class="btn-view-profile" onclick="openExhibitorModal(${i})">
                                    View Details
                                </button>
                            </div>
                        </div>
                    `;
                });
                grid.innerHTML = html;

            } catch (err) {
                console.error('Exhibitor Error:', err);
            }
        }

        // --- MODAL FUNCTIONS (Copied from Index.aspx) ---
        function openExhibitorModal(index) {
            const d = exhibitorsData[index];
            if (d) {
                document.getElementById('exhName').innerText = d.FullName || "";
                document.getElementById('exhDesignation').innerText = d.Designation || "";
                document.getElementById('exhCompany').innerText = d.Company || "";

                // Product Image
                const prodSection = document.getElementById('exhProductSection');
                const prodImg = document.getElementById('exhProductImg');
                if (d.ProductPicturePath) {
                    prodImg.src = d.ProductPicturePath;
                    prodSection.style.display = 'block';
                } else {
                    prodSection.style.display = 'none';
                }

                // Social Links Helper
                const setLink = (id, url) => {
                    const el = document.getElementById(id);
                    if (url && url.trim() !== "") {
                        let finalUrl = url.trim();
                        if (!finalUrl.match(/^https?:\/\//i)) finalUrl = 'https://' + finalUrl;
                        el.href = finalUrl;
                        el.onclick = function (e) { e.stopPropagation(); window.open(finalUrl, '_blank'); return false; };
                        el.style.display = 'block';
                    } else {
                        el.style.display = 'none';
                    }
                };

                setLink('linkWeb', d.Website);
                setLink('linkLinkedIn', d.LinkedIn);
                setLink('linkTwitter', d.Twitter);
                setLink('linkFacebook', d.Facebook);

                // Brochure
                const btnBrochure = document.getElementById('btnBrochure');
                if (d.BrochurePath) {
                    btnBrochure.href = d.BrochurePath;
                    btnBrochure.setAttribute('download', '');
                    btnBrochure.style.display = 'block';
                } else {
                    btnBrochure.style.display = 'none';
                }

                document.getElementById('exhibitorModal').style.display = 'flex';
                document.body.style.overflow = 'hidden';
            }
        }

        function closeExhibitorModal() {
            document.getElementById('exhibitorModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        window.addEventListener('click', function (e) {
            const exhModal = document.getElementById('exhibitorModal');
            if (e.target == exhModal) closeExhibitorModal();
        });
    </script>
</body>
</html>
