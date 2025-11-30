<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExhibitorDashboard.aspx.cs" Inherits="Expo_Panel.ExhibitorDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Exhibitor Dashboard - Expo Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <!-- Favicons -->
    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" />

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Poppins', sans-serif; background: #fff7ed; min-height: 100vh; }

        /* --- ORANGE THEME VARIABLES --- */
        :root {
            --primary: #dd6b20;       /* Dark Orange */
            --primary-light: #ed8936; /* Light Orange */
            --primary-bg: #fffaf0;    /* Very Light Orange Background */
            --text-dark: #2d3748;
            --text-light: #718096;
            --border: #fed7aa;
        }

        /* HEADER */
        .dashboard-header {
            background: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 15px 30px;
            display: flex; justify-content: space-between; align-items: center;
            position: sticky; top: 0; z-index: 1000;
            border-bottom: 3px solid var(--primary);
        }
        .header-logo img { height: 60px; width: auto; }
        .header-right { display: flex; align-items: center; gap: 20px; }
        
        .user-info {
            display: flex; align-items: center; gap: 12px;
            padding: 8px 16px; background: var(--primary-bg);
            border-radius: 8px; border: 1px solid var(--border);
        }
        .user-avatar {
            width: 40px; height: 40px; border-radius: 50%;
            background: var(--primary); color: white;
            display: flex; align-items: center; justify-content: center;
            font-weight: 600; font-size: 16px;
        }
        .user-details h4 { font-size: 14px; font-weight: 600; color: var(--text-dark); margin: 0; }
        .user-details p { font-size: 12px; color: var(--text-light); margin: 0; }

        .btn-logout {
            padding: 10px 20px; background: #ef4444; color: white;
            border: none; border-radius: 8px; cursor: pointer;
            font-size: 14px; font-weight: 500; transition: all 0.3s;
            display: flex; align-items: center; gap: 8px;
        }
        .btn-logout:hover { background: #dc2626; transform: translateY(-1px); }

        /* CONTAINER */
        .dashboard-container { max-width: 1400px; margin: 30px auto; padding: 0 30px; }

        /* WELCOME CARD */
        .welcome-section {
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
            color: white; padding: 30px; border-radius: 15px;
            margin-bottom: 30px; box-shadow: 0 4px 15px rgba(221, 107, 32, 0.2);
        }
        .welcome-section h1 { font-size: 32px; margin-bottom: 10px; }
        .welcome-section p { font-size: 16px; opacity: 0.95; }

        /* TABS */
        .tab-navigation { display: flex; gap: 10px; margin-bottom: 30px; border-bottom: 2px solid #fed7aa; }
        .tab-btn {
            padding: 12px 24px; background: none; border: none;
            border-bottom: 3px solid transparent; cursor: pointer;
            font-size: 16px; font-weight: 500; color: var(--text-light);
            transition: all 0.3s; display: flex; align-items: center; gap: 8px;
        }
        .tab-btn:hover { color: var(--primary); }
        .tab-btn.active { color: var(--primary); border-bottom-color: var(--primary); }
        
        .tab-content { display: none; animation: fadeIn 0.4s ease; }
        .tab-content.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        /* CARDS & SECTIONS */
        .profile-card {
            background: white; padding: 30px; border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); margin-bottom: 20px;
            border-top: 4px solid var(--primary);
        }
        .profile-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 25px; padding-bottom: 15px; border-bottom: 1px solid #edf2f7;
        }
        .profile-header h2 { font-size: 20px; color: var(--text-dark); display: flex; align-items: center; gap: 10px; }
        
        .btn-edit {
            padding: 10px 20px; background: var(--primary); color: white;
            border: none; border-radius: 8px; cursor: pointer;
            font-size: 14px; font-weight: 500; transition: all 0.3s;
            text-decoration: none; display: flex; align-items: center; gap: 8px;
        }
        .btn-edit:hover { background: #c05621; transform: translateY(-1px); }

        /* Change Password Button */
        .btn-password {
            padding: 10px 20px;
            background: #4a5568; /* Slate Gray */
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            display: flex; align-items: center; gap: 8px; text-decoration: none;
        }
        .btn-password:hover { background: #2d3748; transform: translateY(-1px); }

        /* Password Modal */
        .pwd-modal {
            display: none; /* Hidden by default */
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.6); z-index: 2000;
            justify-content: center; align-items: center;
            backdrop-filter: blur(2px);
        }
        .pwd-content {
            background: white; padding: 30px; border-radius: 12px;
            width: 90%; max-width: 400px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            animation: fadeIn 0.3s ease;
        }
        .form-group { margin-bottom: 15px; }
        .form-label { display: block; margin-bottom: 6px; font-weight: 600; color: #4a5568; font-size: 13px; }
        
        /* Wrapper to hold Input + Eye Icon */
        .password-wrapper { position: relative; width: 100%; }
        .form-input {
            width: 100%; padding: 10px; border: 1px solid #e2e8f0;
            border-radius: 6px; font-size: 14px; outline: none; padding-right: 40px; 
        }
        .form-input:focus { border-color: var(--primary); }

        /* The Eye Icon Style */
        .toggle-eye {
            position: absolute; right: 12px; top: 50%;
            transform: translateY(-50%); color: #718096;
            cursor: pointer; z-index: 5; font-size: 14px;
        }
        .toggle-eye:hover { color: #2d3748; }

        /* Validation Hint Text */
        .pass-hint {
            font-size: 12px; margin-top: 5px; display: block;
            color: #64748b; transition: all 0.3s ease;
        }
        .pass-hint.invalid { color: #e53e3e; } /* Red */
        .pass-hint.valid { color: #38a169; font-weight: 600; } /* Green */

        .pwd-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
        .btn-cancel { background: #edf2f7; color: #4a5568; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; }
        .btn-save { background: var(--primary); color: white; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; }

        /* INFO GRIDS */
        .profile-info { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; }
        .info-item { padding: 15px; background: #fffaf0; border-radius: 8px; border: 1px solid #feebc8; }
        .info-label { font-size: 12px; color: var(--text-light); font-weight: 600; text-transform: uppercase; margin-bottom: 5px; }
        .info-value { font-size: 15px; color: var(--text-dark); font-weight: 500; }

        /* SUPPLIES GRID */
        .supplies-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; }
        .supply-item { 
            background: white; border: 1px solid var(--border); 
            border-radius: 10px; padding: 20px; text-align: center;
            transition: all 0.3s;
        }
        .supply-item:hover { transform: translateY(-5px); box-shadow: 0 5px 15px rgba(221, 107, 32, 0.1); }
        .supply-icon { 
            font-size: 32px; color: var(--primary); margin-bottom: 15px; 
            background: var(--primary-bg); width: 70px; height: 70px;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            margin: 0 auto 15px auto;
        }
        .supply-status {
            display: inline-block; padding: 4px 10px; border-radius: 20px;
            font-size: 12px; font-weight: 600; margin-top: 10px;
        }
        .status-yes { background: #c6f6d5; color: #22543d; }
        .status-no { background: #fed7d7; color: #822727; }

        /* BOOTH BADGE */
        .booth-badge {
            background: var(--primary-bg); color: var(--primary);
            padding: 5px 15px; border-radius: 50px; font-weight: 700;
            border: 1px solid var(--border);
        }

        /* Alert Messages */
        .alert {
            padding: 15px 20px; border-radius: 8px; margin-bottom: 20px;
            display: flex; align-items: center; gap: 10px;
        }
        .alert-success { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
        .alert-danger { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            .dashboard-header { flex-direction: column; gap: 15px; padding: 15px; }
            .profile-info { grid-template-columns: 1fr; }
            .tab-navigation { overflow-x: auto; white-space: nowrap; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <!-- HEADER -->
        <div class="dashboard-header">
            <div class="header-logo">
                <img src="/Images/Expo_logo.png" alt="Expo Logo" />
            </div>
            <div class="header-right">
                <div class="user-info">
                    <div class="user-avatar">
                        <asp:Literal ID="litUserInitials" runat="server"></asp:Literal>
                    </div>
                    <div class="user-details">
                        <h4><asp:Literal ID="litUserName" runat="server"></asp:Literal></h4>
                        <p><asp:Literal ID="litUserEmail" runat="server"></asp:Literal></p>
                    </div>
                </div>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
            </div>
        </div>

        <!-- MAIN CONTAINER -->
        <div class="dashboard-container">
            
            <!-- WELCOME BANNER -->
            <div class="welcome-section">
                <h1>Welcome, <asp:Literal ID="litWelcomeName" runat="server"></asp:Literal>! 👋</h1>
                <p>Manage your booth, update your profile, and request additional supplies.</p>
            </div>

            <asp:Literal ID="litMessage" runat="server"></asp:Literal>

            <!-- TAB NAVIGATION -->
            <div class="tab-navigation">
                <button type="button" class="tab-btn active" onclick="openTab(event, 'profile')">
                    <i class="fas fa-building"></i> Company Profile
                </button>
                <button type="button" class="tab-btn" onclick="openTab(event, 'booth')">
                    <i class="fas fa-store"></i> Booth Details
                </button>
                <button type="button" class="tab-btn" onclick="openTab(event, 'supplies')">
                    <i class="fas fa-boxes"></i> Additional Supplies
                </button>
            </div>

            <!-- 1. PROFILE TAB -->
            <div id="profile" class="tab-content active">
                <div class="profile-card">
                    <div class="profile-header">
                        <h2><i class="fas fa-id-card"></i> Company Information</h2>
                        <div style="display: flex; gap: 10px;">
                            <!-- CHANGE PASSWORD BUTTON -->
                            <button type="button" class="btn-password" onclick="openPwdModal()">
                                <i class="fas fa-key"></i>Change Password
                            </button>
                            <a href="PostApprovalExhibitor.aspx" class="btn-edit">
                                <i class="fas fa-edit"></i> Edit Profile
                            </a>
                        </div>
                    </div>
                    <div class="profile-info">
                        <div class="info-item">
                            <div class="info-label">Company Name</div>
                            <div class="info-value"><asp:Literal ID="litCompany" runat="server"></asp:Literal></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Representative Name</div>
                            <div class="info-value"><asp:Literal ID="litRepName" runat="server"></asp:Literal></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Designation</div>
                            <div class="info-value"><asp:Literal ID="litDesignation" runat="server"></asp:Literal></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Contact Email</div>
                            <div class="info-value"><asp:Literal ID="litEmail" runat="server"></asp:Literal></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Website</div>
                            <div class="info-value"><asp:Literal ID="litWebsite" runat="server"></asp:Literal></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Establishment Year</div>
                            <div class="info-value"><asp:Literal ID="litYear" runat="server"></asp:Literal></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 2. BOOTH DETAILS TAB -->
            <div id="booth" class="tab-content">
                <div class="profile-card">
                    <div class="profile-header">
                        <h2><i class="fas fa-store-alt"></i> Booth Allocation</h2>
                        <span class="booth-badge"><asp:Literal ID="litBoothType" runat="server"></asp:Literal></span>
                    </div>
                    <div class="profile-info">
                        <div class="info-item">
                            <div class="info-label">Hall Number</div>
                            <div class="info-value"><asp:Literal ID="litHallNo" runat="server"></asp:Literal></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Booth Number</div>
                            <div class="info-value"><asp:Literal ID="litBoothNo" runat="server"></asp:Literal></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Area (Sqm)</div>
                            <div class="info-value"><asp:Literal ID="litArea" runat="server"></asp:Literal> Sqm</div>
                        </div>
                        <div class="info-item" style="grid-column: 1 / -1;">
                            <div class="info-label">Exhibitor Profile Description</div>
                            <div class="info-value" style="line-height: 1.6;">
                                <asp:Literal ID="litProfileDesc" runat="server"></asp:Literal>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 3. ADDITIONAL SUPPLIES TAB -->
            <div id="supplies" class="tab-content">
                <div class="profile-card">
                    <div class="profile-header">
                        <h2><i class="fas fa-truck-loading"></i> Logistics & Supplies Status</h2>
                        <a href="PostApprovalExhibitor.aspx" class="btn-edit">
                            <i class="fas fa-edit"></i> Request Supplies
                        </a>
                    </div>
                    
                    <div class="supplies-grid">
                        <!-- Power Supply -->
                        <div class="supply-item">
                            <div class="supply-icon"><i class="fas fa-bolt"></i></div>
                            <h4>Power Supply</h4>
                            <div class="info-label" style="margin-top:5px;">Req: <asp:Literal ID="litPowerKwh" runat="server"></asp:Literal></div>
                            <asp:Literal ID="litPowerStatus" runat="server"></asp:Literal>
                        </div>

                        <!-- Internet -->
                        <div class="supply-item">
                            <div class="supply-icon"><i class="fas fa-wifi"></i></div>
                            <h4>Internet</h4>
                            <asp:Literal ID="litInternetStatus" runat="server"></asp:Literal>
                        </div>

                        <!-- Furniture -->
                        <div class="supply-item">
                            <div class="supply-icon"><i class="fas fa-chair"></i></div>
                            <h4>Furniture</h4>
                            <asp:Literal ID="litFurnitureStatus" runat="server"></asp:Literal>
                        </div>

                        <!-- AV Equipment -->
                        <div class="supply-item">
                            <div class="supply-icon"><i class="fas fa-tv"></i></div>
                            <h4>AV Equipment</h4>
                            <asp:Literal ID="litAVStatus" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <div style="margin-top: 25px; padding: 20px; background: #fffaf0; border: 1px solid #feebc8; border-radius: 8px;">
                        <h4 style="color: #c05621; margin-bottom: 10px;"><i class="fas fa-info-circle"></i> Other Requirements</h4>
                        <p style="color: #2d3748;"><asp:Literal ID="litOtherReq" runat="server"></asp:Literal></p>
                    </div>
                </div>
            </div>

        </div>

        <!-- Password Change Modal -->
        <div id="pwdModal" class="pwd-modal">
            <div class="pwd-content">
                <h3 style="margin-bottom:20px; color:#1e293b;">Change Password</h3>
                
                <div class="form-group">
                    <label class="form-label">Current Password</label>
                    <div class="password-wrapper">
                        <asp:TextBox ID="txtOldPass" runat="server" CssClass="form-input" TextMode="Password"></asp:TextBox>
                        <i class="fas fa-eye toggle-eye" onclick="togglePassword(this)"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">New Password</label>
                    <div class="password-wrapper">
                        <asp:TextBox ID="txtNewPass" runat="server" CssClass="form-input" TextMode="Password" onkeyup="validateLength(this); validateMatch();"></asp:TextBox>
                        <i class="fas fa-eye toggle-eye" onclick="togglePassword(this)"></i>
                    </div>
                    <span id="lenHint" class="pass-hint">Must be at least 6 characters</span>
                </div>

                <div class="form-group">
                    <label class="form-label">Confirm New Password</label>
                    <div class="password-wrapper">
                        <asp:TextBox ID="txtConfPass" runat="server" CssClass="form-input" TextMode="Password" onkeyup="validateMatch()"></asp:TextBox>
                        <i class="fas fa-eye toggle-eye" onclick="togglePassword(this)"></i>
                    </div>
                    <span id="matchHint" class="pass-hint"></span>
                </div>

                <div class="pwd-actions">
                    <button type="button" class="btn-cancel" onclick="closePwdModal()">Cancel</button>
                    <asp:Button ID="btnSavePassword" runat="server" Text="Update Password" 
                        CssClass="btn-save" OnClick="btnSavePassword_Click" />
                </div>
            </div>
        </div>

    </form>

    <script>
        function openTab(evt, tabName) {
            var i, tabcontent, tablinks;
            tabcontent = document.getElementsByClassName("tab-content");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].classList.remove("active");
            }
            tablinks = document.getElementsByClassName("tab-btn");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].classList.remove("active");
            }
            document.getElementById(tabName).classList.add("active");
            evt.currentTarget.classList.add("active");
        }

        // --- PASSWORD MODAL LOGIC ---
        function openPwdModal() {
            document.getElementById('pwdModal').style.display = 'flex';
        }
        function closePwdModal() {
            document.getElementById('pwdModal').style.display = 'none';
            // Clear fields (optional)
            document.getElementById('<%= txtOldPass.ClientID %>').value = '';
            document.getElementById('<%= txtNewPass.ClientID %>').value = '';
            document.getElementById('<%= txtConfPass.ClientID %>').value = '';
            document.getElementById('lenHint').innerHTML = "Must be at least 6 characters";
            document.getElementById('lenHint').className = "pass-hint";
            document.getElementById('matchHint').innerHTML = "";
        }

        function togglePassword(icon) {
            const wrapper = icon.parentElement;
            const input = wrapper.querySelector('input');
            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = "password";
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        function validateLength(input) {
            const hint = document.getElementById('lenHint');
            const val = input.value;
            if (val.length === 0) {
                hint.className = "pass-hint";
                hint.innerText = "Must be at least 6 characters";
            } 
            else if (val.length < 6) {
                hint.className = "pass-hint invalid";
                hint.innerText = "Too short (at least 6 characters required)";
            } 
            else {
                hint.className = "pass-hint valid";
                hint.innerHTML = '<i class="fas fa-check"></i> Length OK';
            }
        }

        function validateMatch() {
            const pass1 = document.getElementById('<%= txtNewPass.ClientID %>').value;
            const pass2 = document.getElementById('<%= txtConfPass.ClientID %>').value;
            const hint = document.getElementById('matchHint');

            if (pass2.length === 0) {
                hint.innerHTML = "";
                hint.className = "pass-hint";
                return;
            }

            if (pass1 === pass2) {
                hint.innerHTML = '<i class="fas fa-check"></i> Passwords match';
                hint.className = "pass-hint valid";
            } else {
                hint.innerHTML = '<i class="fas fa-times"></i> Passwords do not match';
                hint.className = "pass-hint invalid";
            }
        }
    </script>
</body>
</html>