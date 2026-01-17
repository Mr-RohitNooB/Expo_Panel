<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewExhibitorDetails.aspx.cs" Inherits="Expo_Panel.Admin.ViewExhibitorDetails_Admin" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>View Exhibitor Details - Expo Panel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%); /* Orange Gradient from ManageExhibitor */
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px 30px;
            margin-bottom: 25px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

            .header h1 {
                color: #dd6b20; /* Matches theme */
                font-size: 24px;
                font-weight: 600;
            }

        .dashboard-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .section-divider {
            margin: 30px 0 20px 0;
            padding: 10px 0;
            border-bottom: 2px solid #e2e8f0;
            color: #dd6b20;
            font-size: 18px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-bottom: 10px;
        }

        .info-row {
            display: flex;
            flex-direction: column;
            padding: 10px;
            border-bottom: 1px solid #f1f5f9;
        }

        .info-label {
            font-size: 12px;
            color: #64748b;
            font-weight: 500;
            text-transform: uppercase;
            margin-bottom: 4px;
        }

        .info-value {
            font-size: 15px;
            color: #1e293b;
            font-weight: 500;
        }

        /* Badges */
        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .badge-approved {
            background: #d1fae5;
            color: #065f46;
        }

        .badge-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .badge-rejected {
            background: #fee2e2;
            color: #991b1b;
        }

        .badge-bool-yes {
            color: #059669;
            font-weight: bold;
        }

        .badge-bool-no {
            color: #94a3b8;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }

        .btn-back {
            background: #e2e8f0;
            color: #475569;
        }

            .btn-back:hover {
                background: #cbd5e1;
            }

        .btn-doc {
            background: #3b82f6;
            color: white;
            font-size: 13px;
            padding: 6px 12px;
        }

            .btn-doc:hover {
                background: #2563eb;
            }

        .social-links a {
            color: #64748b;
            font-size: 20px;
            margin-right: 15px;
            transition: color 0.3s;
        }

            .social-links a:hover {
                color: #dd6b20;
            }

        /* Profile Missing State */
        .no-profile-banner {
            background: #fff7ed;
            border: 1px solid #ffedd5;
            color: #9a3412;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            margin-top: 30px;
        }

        @media (max-width: 768px) {
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-id-card-alt"></i>Exhibitor Details</h1>
                <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="~/Admin/ManageExhibitor.aspx" CssClass="btn btn-back">
                    <i class="fas fa-arrow-left"></i> Back to List
                </asp:HyperLink>
            </div>

            <div class="dashboard-card">

                <div class="section-divider">
                    <i class="fas fa-user-check"></i>Basic Registration Info
                </div>

                <div class="info-grid">
                    <div class="info-row">
                        <span class="info-label">Full Name</span>
                        <span class="info-value">
                            <asp:Label ID="lblName" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Designation</span>
                        <span class="info-value">
                            <asp:Label ID="lblDesignation" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Email Address</span>
                        <span class="info-value">
                            <asp:Label ID="lblEmail" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Mobile</span>
                        <span class="info-value">
                            <asp:Label ID="lblMobile" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Company Name</span>
                        <span class="info-value">
                            <asp:Label ID="lblCompany" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Approval Status</span>
                        <span class="info-value">
                            <asp:Label ID="lblApprovalStatus" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Registration Type</span>
                        <span class="info-value">
                            <asp:Label ID="lblRegType" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Registered On</span>
                        <span class="info-value">
                            <asp:Label ID="lblRegDate" runat="server"></asp:Label></span>
                    </div>
                </div>

                <div class="section-divider">
                    <i class="fas fa-map-marker-alt"></i>Address & Billing
                </div>
                <div class="info-grid">
                    <div class="info-row">
                        <span class="info-label">Head Office Address</span>
                        <span class="info-value">
                            <asp:Label ID="lblHeadOffice" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">City / State / Country</span>
                        <span class="info-value">
                            <asp:Label ID="lblLocation" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">GST Number</span>
                        <span class="info-value">
                            <asp:Label ID="lblGST" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Billing Address</span>
                        <span class="info-value">
                            <asp:Label ID="lblBillingAddress" runat="server"></asp:Label></span>
                    </div>
                </div>

                <div class="section-divider">
                    <i class="fas fa-store"></i>Booth & Participation Interests
                </div>
                <div class="info-grid">
                    <div class="info-row">
                        <span class="info-label">Booth Type</span>
                        <span class="info-value">
                            <asp:Label ID="lblBoothType" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Area (Sqm)</span>
                        <span class="info-value">
                            <asp:Label ID="lblArea" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Interests</span>
                        <span class="info-value">
                            <asp:Label ID="lblInterests" runat="server"></asp:Label>
                        </span>
                    </div>
                </div>


                <asp:Panel ID="pnlProfile" runat="server" Visible="false">

                    <div class="section-divider" style="margin-top: 50px; background: #fff7ed; padding: 10px; border-radius: 5px;">
                        <i class="fas fa-star"></i>Exhibitor Profile Details
                    </div>

                    <div class="info-grid">
                        <div class="info-row">
                            <span class="info-label">Booth Number</span>
                            <span class="info-value" style="font-size: 18px; color: #dd6b20;">
                                <asp:Label ID="lblBoothNo" runat="server"></asp:Label></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Hall Number</span>
                            <span class="info-value">
                                <asp:Label ID="lblHallNo" runat="server"></asp:Label></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Year Established</span>
                            <span class="info-value">
                                <asp:Label ID="lblYearEst" runat="server"></asp:Label></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Website</span>
                            <span class="info-value">
                                <asp:HyperLink ID="hlWebsite" runat="server" Target="_blank" Style="color: #3b82f6;"></asp:HyperLink></span>
                        </div>
                    </div>

                    <div class="info-row" style="margin-bottom: 20px;">
                        <span class="info-label">Exhibitor Profile (Bio)</span>
                        <span class="info-value" style="line-height: 1.6;">
                            <asp:Label ID="lblProfileBio" runat="server"></asp:Label></span>
                    </div>

                    <div class="info-row">
                        <span class="info-label">Social Media</span>
                        <div class="social-links" style="margin-top: 5px;">
                            <asp:HyperLink ID="hlLinkedIn" runat="server" Target="_blank" Visible="false"><i class="fab fa-linkedin"></i></asp:HyperLink>
                            <asp:HyperLink ID="hlTwitter" runat="server" Target="_blank" Visible="false"><i class="fab fa-twitter"></i></asp:HyperLink>
                            <asp:HyperLink ID="hlFacebook" runat="server" Target="_blank" Visible="false"><i class="fab fa-facebook"></i></asp:HyperLink>
                            <asp:HyperLink ID="hlYouTube" runat="server" Target="_blank" Visible="false"><i class="fab fa-youtube"></i></asp:HyperLink>
                        </div>
                    </div>

                    <div class="section-divider">
                        <i class="fas fa-briefcase"></i>Business Categories
                    </div>
                    <div class="info-grid">
                        <div class="info-row">
                            <span class="info-label">Nature of Business</span>
                            <span class="info-value">
                                <asp:Label ID="lblNature" runat="server"></asp:Label></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Company Category</span>
                            <span class="info-value">
                                <asp:Label ID="lblCategory" runat="server"></asp:Label></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Markets Catered To</span>
                            <span class="info-value">
                                <asp:Label ID="lblMarkets" runat="server"></asp:Label></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Geographic Reach</span>
                            <span class="info-value">
                                <asp:Label ID="lblGeoReach" runat="server"></asp:Label></span>
                        </div>
                    </div>

                    <div class="section-divider">
                        <i class="fas fa-headset"></i>Customer Support
                    </div>
                    <div class="info-grid">
                        <div class="info-row">
                            <span class="info-label">Contact Person</span>
                            <span class="info-value">
                                <asp:Label ID="lblSupportName" runat="server"></asp:Label></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Contact Number</span>
                            <span class="info-value">
                                <asp:Label ID="lblSupportContact" runat="server"></asp:Label></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Support Email</span>
                            <span class="info-value">
                                <asp:Label ID="lblSupportEmail" runat="server"></asp:Label></span>
                        </div>
                    </div>

                    <div class="section-divider">
                        <i class="fas fa-plug"></i>Logistics & Requirements
                    </div>
                    <div class="info-grid">
                        <div class="info-row">
                            <span class="info-label">Power Supply</span>
                            <span class="info-value">
                                <asp:Label ID="lblPower" runat="server"></asp:Label></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Internet</span>
                            <span class="info-value">
                                <asp:Label ID="lblInternet" runat="server"></asp:Label></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Furniture Rental</span>
                            <span class="info-value">
                                <asp:Label ID="lblFurniture" runat="server"></asp:Label></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">AV Equipment</span>
                            <span class="info-value">
                                <asp:Label ID="lblAV" runat="server"></asp:Label></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Interpreter</span>
                            <span class="info-value">
                                <asp:Label ID="lblInterpreter" runat="server"></asp:Label></span>
                        </div>
                    </div>
                    <div class="info-row" style="margin-top: 10px;">
                        <span class="info-label">Other Requirements</span>
                        <span class="info-value">
                            <asp:Label ID="lblOtherReq" runat="server"></asp:Label></span>
                    </div>

                    <div class="section-divider">
                        <i class="fas fa-bullseye"></i>Objectives & Notes
                    </div>
                    <div class="info-row">
                        <span class="info-label">Participation Objectives</span>
                        <span class="info-value">
                            <asp:Label ID="lblObjectives" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-row" style="margin-top: 10px;">
                        <span class="info-label">Additional Notes</span>
                        <span class="info-value">
                            <asp:Label ID="lblNotes" runat="server"></asp:Label></span>
                    </div>

                    <div class="section-divider">
                        <i class="fas fa-file-alt"></i>Uploaded Documents
                    </div>
                    <div class="info-grid">
                        <div class="info-row">
                            <span class="info-label">Company Logo</span>
                            <span class="info-value">
                                <asp:Literal ID="litLogo" runat="server"></asp:Literal>
                            </span>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Product Picture</span>
                            <span class="info-value">
                                <asp:Literal ID="litProductPic" runat="server"></asp:Literal>
                            </span>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Company Brochure</span>
                            <span class="info-value">
                                <asp:Literal ID="litBrochure" runat="server"></asp:Literal>
                            </span>
                        </div>
                    </div>

                </asp:Panel>

                <asp:Panel ID="pnlNoProfile" runat="server" Visible="false">
                    <div class="no-profile-banner">
                        <i class="fas fa-exclamation-circle"></i>
                        <strong>Profile Pending:</strong> This exhibitor has not filled out their Post-Approval profile details yet.
                    </div>
                </asp:Panel>

            </div>
        </div>
    </form>
</body>
</html>
