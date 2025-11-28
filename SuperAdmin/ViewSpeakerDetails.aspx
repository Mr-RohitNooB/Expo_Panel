<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewSpeakerDetails.aspx.cs" Inherits="Expo_Panel.Admin.ViewSpeakerDetails" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Speaker Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f8fafc; padding: 20px; }
        .container { max-width: 1000px; margin: 0 auto; background: white; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); overflow: hidden; }
        
        /* Header */
        .header { background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); padding: 30px; color: white; display: flex; align-items: center; gap: 20px; }
        .profile-img { width: 100px; height: 100px; border-radius: 50%; border: 4px solid rgba(255,255,255,0.3); object-fit: cover; background: #fff; }
        .header-info h1 { margin: 0; font-size: 24px; font-weight: 600; }
        .header-info p { margin: 5px 0 0; opacity: 0.9; }
        
        /* Layout */
        .content { padding: 30px; display: grid; grid-template-columns: 2fr 1fr; gap: 30px; }
        
        .section-title { font-size: 16px; font-weight: 600; color: #38a169; margin-bottom: 15px; border-bottom: 2px solid #e2e8f0; padding-bottom: 8px; display: flex; align-items: center; gap: 8px; }
        
        .info-group { margin-bottom: 25px; }
        .label { font-size: 12px; color: #64748b; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; display: block; }
        .value { font-size: 15px; color: #1e293b; font-weight: 400; line-height: 1.6; white-space: pre-wrap; }
        
        /* Badges */
        .badge { display: inline-block; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 500; }
        .badge-active { background: #d1fae5; color: #065f46; }
        .badge-inactive { background: #fee2e2; color: #991b1b; }

        /* Sidebar Styling */
        .sidebar { background: #f8fafc; padding: 20px; border-radius: 12px; height: fit-content; }
        .company-logo { max-height: 80px; max-width: 100%; object-fit: contain; background: white; padding: 8px; border-radius: 6px; border: 1px solid #e2e8f0; margin-top: 5px; }

        /* Checkbox Visual Style */
        .checkbox-container { display: flex; gap: 20px; margin-top: 5px; }
        .checkbox-item { display: flex; align-items: center; gap: 8px; font-size: 14px; color: #334155; }
        .checkbox-item i { font-size: 18px; }
        .fa-check-square { color: #38a169; }
        .fa-square { color: #cbd5e1; }

        /* NEW: LinkedIn Button Style */
        .btn-linkedin {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background-color: #0077b5; /* LinkedIn Blue */
            color: white !important;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            transition: background 0.2s;
            font-size: 13px;
            margin-top: 2px;
        }
        .btn-linkedin:hover {
            background-color: #005582;
            text-decoration: none;
        }
        .btn-linkedin i { font-size: 16px; }

        @media (max-width: 768px) {
            .content { grid-template-columns: 1fr; }
            .header { flex-direction: column; text-align: center; }
            .checkbox-container { flex-direction: column; gap: 10px; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <asp:Image ID="imgProfile" runat="server" CssClass="profile-img" ImageUrl="~/Images/default-user.png" />
                <div class="header-info">
                    <h1><asp:Label ID="lblName" runat="server"></asp:Label></h1>
                    <p><i class="fas fa-briefcase"></i> <asp:Label ID="lblDesignationCompany" runat="server"></asp:Label></p>
                </div>
            </div>

            <div class="content">
                <div class="main-column">
                    <div class="info-group">
                        <div class="section-title"><i class="fas fa-user"></i> Professional Bio</div>
                        <div class="value"><asp:Label ID="lblBio" runat="server"></asp:Label></div>
                    </div>

                    <div class="info-group">
                        <div class="section-title"><i class="fas fa-star"></i> Expertise & Topics</div>
                        
                        <div class="info-group">
                            <span class="label">Areas of Expertise</span>
                            <div class="value"><asp:Label ID="lblExpertise" runat="server"></asp:Label></div>
                        </div>

                        <div class="info-group">
                            <span class="label">Current Projects</span>
                            <div class="value"><asp:Label ID="lblProjects" runat="server"></asp:Label></div>
                        </div>

                        <div class="info-group">
                            <span class="label">Suggested Topics</span>
                            <div class="value"><asp:Label ID="lblTopics" runat="server"></asp:Label></div>
                        </div>
                    </div>

                    <div class="info-group">
                        <div class="section-title"><i class="fas fa-microphone"></i> Speaking Experience</div>
                        <div class="value"><asp:Label ID="lblPreviousEngagements" runat="server"></asp:Label></div>
                    </div>

                    <div class="info-group">
                        <span class="label">Preferred Discussion Format</span>
                        <div class="value">
                            <asp:Literal ID="litFormatCheckboxes" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <div class="info-group">
                        <div class="section-title"><i class="fas fa-calendar-check"></i> Selected Agenda Topics</div>
                        <div class="value"><asp:Label ID="lblSelectedAgendas" runat="server"></asp:Label></div>
                    </div>
                </div>

                <div class="sidebar">
                    <div class="section-title"><i class="fas fa-info-circle"></i> Overview</div>

                    <asp:Panel ID="pnlLogo" runat="server" Visible="false" CssClass="info-group">
                        <span class="label">Company Logo</span>
                        <div>
                            <asp:Image ID="imgLogo" runat="server" CssClass="company-logo" />
                        </div>
                    </asp:Panel>

                    <div class="info-group">
                        <span class="label">Status</span>
                        <div class="value"><asp:Label ID="lblStatus" runat="server"></asp:Label></div>
                    </div>

                    <div class="info-group">
                        <span class="label">Experience</span>
                        <div class="value"><asp:Label ID="lblExperience" runat="server"></asp:Label> Years</div>
                    </div>

                    <div class="section-title" style="margin-top: 20px;"><i class="fas fa-address-card"></i> Contact</div>
                    
                    <div class="info-group">
                        <span class="label">Email</span>
                        <div class="value"><asp:Label ID="lblEmail" runat="server"></asp:Label></div>
                    </div>
                    
                    <div class="info-group">
                        <span class="label">Mobile</span>
                        <div class="value"><asp:Label ID="lblMobile" runat="server"></asp:Label></div>
                    </div>

                    <asp:Panel ID="pnlLinkedIn" runat="server" Visible="false" CssClass="info-group">
                        <span class="label">LinkedIn</span>
                        <div class="value"><asp:HyperLink ID="hlLinkedIn" runat="server" Target="_blank" CssClass="btn-linkedin"><i class="fab fa-linkedin"></i> View Profile</asp:HyperLink></div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </form>
</body>
</html>