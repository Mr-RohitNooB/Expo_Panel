<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegisterVisitor.aspx.cs" Inherits="Expo_Panel.RegisterVisitor" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>Visitor Registration</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <link rel="icon" type="image/png" sizes="32x32" href="/Images/favicon_io_Lubricant_India_Expo/favicon-32x32.png" />

    <style>
        /* PROFESSIONAL THEME */
        :root {
            --primary-color: #ca8a04;
            --bg-color: #f3f4f6;
            --text-color: #1f2937;
            --border-color: #e5e7eb;
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            padding: 40px 20px;
            min-height: 100vh;
            margin: 0;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            border-top: 5px solid var(--primary-color);
            width: 100%;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

            .header h1 {
                color: var(--primary-color);
                font-size: 28px;
                font-weight: 600;
                margin-bottom: 8px;
            }

            .header p {
                color: #6b7280;
                font-size: 15px;
                margin: 0;
            }

        .form-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
        }

            .form-section:last-of-type {
                border-bottom: none;
                padding-bottom: 0;
            }

            .form-section h3 {
                color: var(--primary-color);
                margin-bottom: 20px;
                font-size: 18px;
                display: flex;
                gap: 10px;
                align-items: center;
            }

        .row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .full {
            grid-column: 1 / -1;
        }

        .form-group {
            margin-bottom: 15px;
            width: 100%;
        }

        label {
            display: block;
            font-weight: 500;
            color: #374151;
            margin-bottom: 6px;
            font-size: 14px;
        }

        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-family: inherit;
            font-size: 14px;
            transition: all 0.2s ease;
            background-color: #fff;
            color: #111827;
        }

            input:focus, select:focus, textarea:focus {
                border-color: var(--primary-color);
                outline: none;
                box-shadow: 0 0 0 3px rgba(202, 138, 4, 0.1);
            }

        .checkbox-group {
            background: #f9fafb;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }

            /* Target the Table ASP.NET generates */
            .checkbox-group table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
            }

            /* Target the Table Cells (The grid items) */
            .checkbox-group td {
                padding-bottom: 12px; /* Space between rows */
                padding-right: 15px; /* Space between columns */
                vertical-align: top; /* Align to top in case text wraps */
                width: 50%; /* Force exactly 2 equal columns */
            }

            /* The Checkbox Input */
            .checkbox-group input[type="checkbox"] {
                width: 18px;
                height: 18px;
                margin-right: 8px; /* Gap between box and text */
                margin-top: 2px; /* Align nicely with text */
                accent-color: var(--primary-color);
                cursor: pointer;
                vertical-align: top;
            }

            /* The Label Text */
            .checkbox-group label {
                cursor: pointer;
                color: #4b5563;
                font-size: 14px;
                line-height: 1.5;
                display: inline; /* Ensures text flows correctly next to box */
            }

        /* MODAL STYLES (Popup) */
        .modal-overlay {
            display: none; /* Hidden by default */
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }

        .modal-box {
            background: white;
            padding: 30px;
            width: 90%;
            max-width: 700px;
            max-height: 85vh;
            overflow-y: auto;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            position: relative;
        }

        .close-btn {
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 24px;
            color: #666;
            cursor: pointer;
            background: none;
            border: none;
        }

            .close-btn:hover {
                color: #d32f2f;
            }

        .modal-body h4 {
            color: var(--primary-color);
            margin-top: 20px;
            margin-bottom: 10px;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }

        .modal-body p {
            font-size: 13px;
            color: #4b5563;
            line-height: 1.6;
            margin-bottom: 10px;
            text-align: justify;
        }

        .modal-body ul {
            font-size: 13px;
            color: #4b5563;
            padding-left: 20px;
        }

        .term-link {
            color: var(--primary-color);
            text-decoration: underline;
            cursor: pointer;
            font-weight: 600;
        }

            .term-link:hover {
                color: #a16207;
            }

        .btn-submit {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 14px;
            width: 100%;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

            .btn-submit:hover {
                background: #a16207;
                box-shadow: 0 4px 12px rgba(202, 138, 4, 0.2);
            }

        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 25px;
            font-size: 14px;
        }

        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }

            .login-link a {
                color: var(--primary-color);
                font-weight: 500;
                text-decoration: none;
            }

                .login-link a:hover {
                    text-decoration: underline;
                }

        @media (max-width: 768px) {
            .row {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .checkbox-group td {
                display: block; /* Make cells stack vertically */
                width: 100% !important;
                padding-right: 0;
            }
        }

        .checkbox-single {
            display: flex;
            align-items: center; /* Vertically centers the box and text */
            gap: 12px; /* Adds space between the box and the text */
            background: #f9fafb; /* Matches your other form fields */
            padding: 15px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            width: 100%;
        }

            /* Fix the ASP.NET generated span wrapper */
            .checkbox-single > span {
                display: flex;
                align-items: center;
            }

            /* Style the actual checkbox input */
            .checkbox-single input[type="checkbox"] {
                width: 18px;
                height: 18px;
                accent-color: var(--primary-color); /* Uses your Gold/Yellow color */
                margin: 0;
                cursor: pointer;
            }

            /* Style the label text */
            .checkbox-single label {
                margin: 0;
                cursor: pointer;
                font-size: 14px;
                color: #4b5563;
                line-height: 1.5;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h1>Visitor Registration</h1>
                <p>Join us at the Lubricant India Expo</p>
            </div>

            <asp:Literal ID="litMessage" runat="server"></asp:Literal>

            <div class="form-section">
                <h3><i class="fas fa-ticket-alt"></i>Ticket Details</h3>
                <div class="row">
                    <div class="form-group full">
                        <label>Ticket Type</label>
                        <asp:DropDownList ID="ddlTicket" runat="server">
                            <asp:ListItem Value="Free">Free Visitor Pass</asp:ListItem>
                            <asp:ListItem Value="Paid">Paid Delegate Pass</asp:ListItem>
                            <asp:ListItem Value="Student">Student Pass</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <h3><i class="fas fa-user"></i>Personal Information</h3>
                <div class="row">
                    <div class="form-group">
                        <label>Full Name</label>
                        <asp:TextBox ID="txtName" runat="server" placeholder="Enter your full name"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Job Title / Designation</label>
                        <asp:TextBox ID="txtJob" runat="server" placeholder="e.g. Manager"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="name@company.com"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Mobile Number</label>
                        <asp:TextBox ID="txtMobile" runat="server" placeholder="+91 98765 43210"></asp:TextBox>
                    </div>
                    <div class="form-group full">
                        <label>Company Name</label>
                        <asp:TextBox ID="txtCompany" runat="server" placeholder="Enter company name"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <h3><i class="fas fa-map-marker-alt"></i>Address Details</h3>
                <div class="form-group">
                    <label>Address</label>
                    <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="2" placeholder="Street address, P.O. box, etc."></asp:TextBox>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label>City</label>
                        <asp:TextBox ID="txtCity" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>State</label>
                        <asp:TextBox ID="txtState" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Country</label>
                        <asp:TextBox ID="txtCountry" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Pin Code</label>
                        <asp:TextBox ID="txtPin" runat="server"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <h3><i class="fas fa-briefcase"></i>Profile & Interests</h3>

                <div class="form-group">
                    <label>Job Function / Role</label>
                    <asp:DropDownList ID="ddlJobFunction" runat="server">
                        <asp:ListItem Text="-- Select One --" Value="" />
                        <asp:ListItem>Procurement / Purchase</asp:ListItem>
                        <asp:ListItem>R&D / Technical</asp:ListItem>
                        <asp:ListItem>Maintenance / Engineering</asp:ListItem>
                        <asp:ListItem>Quality & Testing</asp:ListItem>
                        <asp:ListItem>Sales & Marketing</asp:ListItem>
                        <asp:ListItem>Operations</asp:ListItem>
                        <asp:ListItem>Management / CXO</asp:ListItem>
                        <asp:ListItem>Academia / Student</asp:ListItem>
                        <asp:ListItem>Other</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label>Nature of Business</label>
                    <asp:DropDownList ID="ddlNature" runat="server">
                        <asp:ListItem Text="-- Select One --" Value="" />
                        <asp:ListItem>Automotive</asp:ListItem>
                        <asp:ListItem>Fleet Owners / Transportation</asp:ListItem>
                        <asp:ListItem>Heavy Equipment & Machinery</asp:ListItem>
                        <asp:ListItem>Industrial Manufacturing</asp:ListItem>
                        <asp:ListItem>Energy & Power</asp:ListItem>
                        <asp:ListItem>Renewable Energy & EV</asp:ListItem>
                        <asp:ListItem>Marine / Aviation</asp:ListItem>
                        <asp:ListItem>Railways & Defence</asp:ListItem>
                        <asp:ListItem>Dealers / Distributors / Traders</asp:ListItem>
                        <asp:ListItem>Petrochemicals</asp:ListItem>
                        <asp:ListItem>Oil & Gas</asp:ListItem>
                        <asp:ListItem>Chemicals / Additives</asp:ListItem>
                        <asp:ListItem>Cement & Building Materials</asp:ListItem>
                        <asp:ListItem>Steel & Rolling Mills</asp:ListItem>
                        <asp:ListItem>Paper & Packaging</asp:ListItem>
                        <asp:ListItem>Pharmaceuticals & Life Sciences</asp:ListItem>
                        <asp:ListItem>FMCG / Food Processing</asp:ListItem>
                        <asp:ListItem>Government / Policy</asp:ListItem>
                        <asp:ListItem>Research & Development</asp:ListItem>
                        <asp:ListItem>Others</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label>Purpose of Visit (Select Multiple)</label>
                    <div class="checkbox-group">
                        <asp:CheckBoxList ID="chkPurpose" runat="server"
                            RepeatColumns="2"
                            RepeatDirection="Horizontal"
                            Width="100%">
                            <asp:ListItem>Explore New Products & Innovations</asp:ListItem>
                            <asp:ListItem>Meet Specific Suppliers / Brands</asp:ListItem>
                            <asp:ListItem>Network with Industry Professionals</asp:ListItem>
                            <asp:ListItem>Attend Technical Sessions / Summit</asp:ListItem>
                            <asp:ListItem>Look for Partnerships / Investments</asp:ListItem>
                            <asp:ListItem>Research & Market Trends</asp:ListItem>
                            <asp:ListItem>Career Opportunities</asp:ListItem>
                            <asp:ListItem>Other</asp:ListItem>
                        </asp:CheckBoxList>
                    </div>
                </div>

                <div class="form-group">
                    <label>Product Interest (Select Multiple)</label>
                    <div class="checkbox-group">
                        <asp:CheckBoxList ID="chkProducts" runat="server"
                            RepeatColumns="2"
                            RepeatDirection="Horizontal"
                            Width="100%">
                            <asp:ListItem>Automotive & Industrial Lubricants</asp:ListItem>
                            <asp:ListItem>Base Oils & Additives</asp:ListItem>
                            <asp:ListItem>Greases</asp:ListItem>
                            <asp:ListItem>Bio-based & Sustainable Lubricants</asp:ListItem>
                            <asp:ListItem>Re-refining & Circular Economy</asp:ListItem>
                            <asp:ListItem>Tribology & Testing</asp:ListItem>
                            <asp:ListItem>Lubrication Equipment / Systems</asp:ListItem>
                            <asp:ListItem>Digital Solutions (AI, IoT, Monitoring)</asp:ListItem>
                            <asp:ListItem>Packaging / Dispensing Technology</asp:ListItem>
                            <asp:ListItem>Other</asp:ListItem>
                        </asp:CheckBoxList>
                    </div>
                </div>
            </div>

            <div class="form-section" style="border: none;">
                <div class="checkbox-single">
                    <asp:CheckBox ID="chkConsent" runat="server" />
                    <label for="chkConsent">
                        I agree to the <span class="term-link" onclick="openConsentModal()">Consent Terms & Conditions</span>.
                    </label>
                </div>
            </div>

            <asp:Button ID="btnSubmit" runat="server" Text="Complete Registration" CssClass="btn-submit" OnClick="btnSubmit_Click" />

            <div class="login-link">
                <a href="VisitorLogin.aspx">Already registered? Login here</a>
            </div>
        </div>

        <div id="consentModal" class="modal-overlay">
            <div class="modal-box">
                <button type="button" class="close-btn" onclick="closeConsentModal()">&times;</button>
                <div class="modal-body">
                    <h2 style="color: #d97706; text-align: center; margin-top: 0;">CONSENT TERMS</h2>

                    <h4>The purpose of processing your personal data</h4>
                    <p>Your personal data will be used so that we can contact you following your interest in participating in our event / exhibition / conference and provide you with necessary assistance regarding your participation.</p>

                    <h4>Type of information</h4>
                    <p>Consent is requested for the following personal data: first name, last name, telephone number, fax number, email address, postal address including postal code, city, country. Additionally, consent is required by our payment gateway partners for processing your payment information. The Company may also take pictures / videos / testimonials during the event / exhibition / conference which are used for promotional purposes.</p>

                    <h4>Transfer of data to third parties</h4>
                    <p>This personal data is stored in the back office of our website and is transferred to such authorised third-party vendors who are required to render services to you with regards to your participation in the event / exhibition / conference etc. They are subject to the same standards of data protection as us.</p>

                    <h4>Storage of data</h4>
                    <p>All the data uploaded into the platform is stored securely in a cloud infrastructure managed by a third-party service provider approved by the organizer. The data is stored in the best-in-class cloud servers hosted by Microsoft. We also use CDN networks for effective and quicker delivery of content to people distributed across multiple geographies.</p>

                    <h4>Usage of data</h4>
                    <p><strong>Personal Identify information:</strong> The data collected from the visitors and exhibitors are shared mutually for building relationship and network. The consent form as part of sign up captures this consent from visitors.</p>
                    <p><strong>Resources:</strong> The information/data that is uploaded in form of photos and pdf files in the platform can be deleted at any point of time by the exhibitors themselves. Exhibitors upload all the videos in to their YouTube channel and then only link those in to our platform. So, there is no issue in the data privacy for the same.</p>

                    <h4>Conversation data</h4>
                    <p>Conversation data from text, audio and video are not recorded or stored in the platform. The data gets deleted as an when the information is completed. The text chat can be copied by the exhibitor post the show is completed. There will not be any export option provided to exhibitor to prevent any misuse of this data.</p>

                    <h4>How long is the data stored for</h4>
                    <p>Your consent is maintained for a period of 5 (five) years unless otherwise specified.</p>

                    <h4>Withdrawal of consent</h4>
                    <p>To request the withdrawal of your personal data, you can inform us in writing by emailing <strong>admin@lubricantindia.com</strong></p>

                    <h4>Warning Regarding Phishing Attempts</h4>
                    <p>We do not use third-party contractors / vendors to solicit any type of personal information or data from you. All data required by us is obtained through our own platforms or platforms hyperlinked by us (payment gateways etc.). If you receive any request / solicitation for personal data / information from any person / entity purporting to act on our behalf, please do not share your personal data / information with such persons / entities as that may be a phishing attempt. Please inform us immediately if you receive any such requests at the following email address: <strong>admin@lubricantindia.com</strong></p>

                    <div style="background: #f9fafb; padding: 15px; border-radius: 6px; margin-top: 20px; border: 1px solid #e5e7eb;">
                        <h4 style="margin-top: 0;">Entity responsible for data processing</h4>
                        <p style="margin-bottom: 0;">
                            <strong>Etaily Marktech Private Limited</strong><br />
                            Unit No. 113, MP Mall, MP Block, Pitampura, New Delhi -110034
                        </p>
                    </div>

                    <div style="margin-top: 20px; text-align: right;">
                        <button type="button" onclick="closeConsentModal()" style="background: #ca8a04; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer;">Close</button>
                    </div>
                </div>
            </div>
        </div>

    </form>

    <script>
        function openConsentModal() {
            document.getElementById('consentModal').style.display = 'flex';
        }

        function closeConsentModal() {
            document.getElementById('consentModal').style.display = 'none';
        }

        // Close modal if user clicks outside of the box
        window.onclick = function (event) {
            var modal = document.getElementById('consentModal');
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
</body>
</html>
