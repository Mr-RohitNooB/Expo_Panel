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
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; line-height: 1.6; color: #333; background-color: #f8fafc; }

        /* Navbar Styles */
        .navbar {
            background: #ffffff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: fixed; width: 100%; top: 0; z-index: 1000;
            border-bottom: 3px solid #D94A2B;
        }
        .nav-container {
            max-width: 1200px; margin: 0 auto; padding: 0 20px;
            display: flex; justify-content: space-between; align-items: center; height: 80px;
        }
        .logo { display: flex; align-items: center; }
        .logo img { height: 60px; width: auto; }
        .nav-menu { display: flex; list-style: none; gap: 10px; }
        .nav-link {
            color: #3D3935; text-decoration: none; padding: 10px 16px;
            display: flex; align-items: center; gap: 5px; border-radius: 6px;
            transition: all 0.3s ease; font-weight: 500;
        }
        .nav-link:hover, .nav-link.active { background: rgba(217, 74, 43, 0.1); color: #D94A2B; }
        
        /* Dropdown Styles */
        .nav-item { position: relative; }
        .dropdown-content {
            display: none; position: absolute; top: 100%; left: 0;
            background: #ffffff; min-width: 220px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
            border-radius: 8px; overflow: hidden; border: 1px solid #e5e7eb;
        }
        .nav-item:hover .dropdown-content { display: block; animation: fadeIn 0.3s ease; }
        .dropdown-content a {
            color: #3D3935; padding: 12px 20px; text-decoration: none;
            display: block; transition: all 0.3s ease;
        }
        .dropdown-content a:hover { background: rgba(217, 74, 43, 0.1); color: #D94A2B; padding-left: 25px; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
        
        /* Mobile Menu */
        .mobile-menu-toggle { display: none; background: none; border: none; color: #3D3935; font-size: 24px; cursor: pointer; }

        /* --- PAGE SPECIFIC HEADER --- */
        .page-header {
            background: linear-gradient(135deg, #3D3935 0%, #5C5550 100%);
            padding: 120px 20px 60px; /* Top padding accounts for fixed navbar */
            text-align: center; color: #fff;
        }
        .page-header h1 { font-size: 36px; margin-bottom: 10px; }
        .page-header p { font-size: 18px; opacity: 0.9; }

        /* --- EXHIBITOR GRID STYLES (Copied) --- */
        .section { padding: 60px 20px; max-width: 1200px; margin: 0 auto; }
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
            display: flex; flex-direction: column; justify-content: space-between;
            min-height: 140px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .exhibitor-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.08);
            border-color: #D94A2B;
        }
        .exhibitor-name i { color: #cbd5e1; margin-right: 6px; font-size: 12px; }

        /* Footer */
        .footer { background: #3D3935; color: #fff; padding: 40px 20px; text-align: center; margin-top: auto; }
        .footer-links { display: flex; justify-content: center; gap: 30px; margin-bottom: 20px; flex-wrap: wrap; }
        .footer-links a { color: #fff; text-decoration: none; transition: color 0.3s ease; }
        .footer-links a:hover { color: #D94A2B; }

        /* Responsive */
        @media (max-width: 768px) {
            .nav-menu {
                display: none; flex-direction: column; position: absolute; top: 80px; left: 0; right: 0;
                background: #ffffff; padding: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.2);
                border-top: 2px solid #D94A2B; align-items: center; text-align: center;
            }
            .nav-menu.active { display: flex; }
            .mobile-menu-toggle { display: block; }
            .page-header { padding-top: 100px; }
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
                    <a href="Index.aspx">Home</a>
                    <a href="Index.aspx#agenda">Agenda</a>
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
        // Mobile Menu Toggle
        function toggleMobileMenu() {
            const navMenu = document.getElementById('navMenu');
            navMenu.classList.toggle('active');
        }

        // Handle Dropdowns on Mobile
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

        // Load Data on Page Load
        document.addEventListener("DOMContentLoaded", function () {
            loadAllExhibitors();
        });

        async function loadAllExhibitors() {
            try {
                // NOTICE: Fetching from Exhibitors.aspx instead of Index.aspx
                const response = await fetch('Exhibitors.aspx/GetAllExhibitors', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' }
                });
                
                const data = await response.json();
                const exhibitors = data.d;
                const grid = document.querySelector('.exhibitors-grid');

                if (!exhibitors || exhibitors.length === 0) {
                    grid.innerHTML = '<p style="text-align:center; grid-column:1/-1; padding: 40px;">No exhibitors found.</p>';
                    return;
                }

                let html = '';
                exhibitors.forEach(e => {
                    // Format Location
                    let locParts = [];
                    if (e.City) locParts.push(e.City);
                    if (e.Country) locParts.push(e.Country);
                    let locationStr = locParts.join(', ');

                    // Build Card HTML (Same design as Index)
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
                document.querySelector('.exhibitors-grid').innerHTML = '<p style="text-align:center; color:red;">Error loading data.</p>';
            }
        }
    </script>
</body>
</html>