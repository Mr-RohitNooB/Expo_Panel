<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegisterSpeaker.aspx.cs" Inherits="Expo_Panel.RegisterSpeaker" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register as Speaker - Expo Panel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
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
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }

        .registration-container {
            width: 1000px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

            .header h1 {
                color: #38a169;
                font-size: 32px;
                font-weight: 600;
                margin-bottom: 10px;
            }

            .header p {
                color: #64748b;
                font-size: 16px;
            }

        .form-section {
            margin-bottom: 35px;
            padding-bottom: 25px;
            border-bottom: 2px solid #e2e8f0;
        }

            .form-section:last-of-type {
                border-bottom: none;
            }

            .form-section h3 {
                color: #38a169;
                font-size: 20px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-row-three {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #475569;
                font-weight: 500;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                font-family: 'Poppins', sans-serif;
                transition: all 0.3s;
            }

                .form-group input:focus,
                .form-group select:focus,
                .form-group textarea:focus {
                    outline: none;
                    border-color: #48bb78;
                }

            .form-group textarea {
                resize: vertical;
                min-height: 100px;
            }

        .checkbox-group {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 12px;
            margin-top: 10px;
        }

        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

            .checkbox-item input[type="checkbox"] {
                width: 20px;
                height: 20px;
                cursor: pointer;
            }

            .checkbox-item label {
                margin: 0;
                cursor: pointer;
                font-weight: 400;
                color: #475569;
            }

        .char-counter {
            font-size: 12px;
            color: #64748b;
            text-align: right;
            margin-top: 5px;
        }

        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 16px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: #38a169;
            color: white;
        }

            .btn-primary:hover {
                background: #2f855a;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(56, 161, 105, 0.4);
            }

        .btn-secondary {
            background: #e2e8f0;
            color: #475569;
        }

            .btn-secondary:hover {
                background: #cbd5e1;
            }

        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e2e8f0;
        }

        .back-link {
            color: #38a169;
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }

            .back-link:hover {
                text-decoration: underline;
            }

        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .required {
            color: #ef4444;
        }

        .info-text {
            font-size: 13px;
            color: #64748b;
            font-style: italic;
            margin-top: 5px;
        }

        /* Commented out for future use */
        .file-upload-section {
            display: none;
        }

        @media (max-width: 768px) {
            .form-row,
            .form-row-three {
                grid-template-columns: 1fr;
            }

            .form-footer {
                flex-direction: column;
                gap: 15px;
            }

            .checkbox-group {
                grid-template-columns: 1fr;
            }

            .registration-container {
                padding: 25px;
            }

            .header h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="registration-container">
            <div class="header">
                <h1><i class="fas fa-microphone"></i> Register as Speaker</h1>
                <p>Share your expertise and insights as a speaker at our expo</p>
            </div>

            <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>

            <!-- Section 1: Personal Information -->
            <div class="form-section">
                <h3><i class="fas fa-user"></i> Personal Information</h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="<%=txtName.ClientID%>">Full Name <span class="required">*</span></label>
                        <asp:TextBox ID="txtName" runat="server" placeholder="Enter your full name"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                            ErrorMessage="Name is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="<%=txtEmail.ClientID%>">Email Address <span class="required">*</span></label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter your email"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Invalid email format" ForeColor="Red" Display="Dynamic"
                            ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" ValidationGroup="RegistrationValidation"></asp:RegularExpressionValidator>
                    </div>
                </div>

                <div class="form-row-three">
                    <div class="form-group">
                        <label for="<%=txtMobile.ClientID%>">Mobile Number</label>
                        <asp:TextBox ID="txtMobile" runat="server" placeholder="Enter your mobile number"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="<%=txtDesignation.ClientID%>">Designation <span class="required">*</span></label>
                        <asp:TextBox ID="txtDesignation" runat="server" placeholder="Enter your designation"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvDesignation" runat="server" ControlToValidate="txtDesignation"
                            ErrorMessage="Designation is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="<%=txtYearsOfExperience.ClientID%>">Years of Experience</label>
                        <asp:TextBox ID="txtYearsOfExperience" runat="server" TextMode="Number" placeholder="Enter years" min="0"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label for="<%=txtCompany.ClientID%>">Company/Organization <span class="required">*</span></label>
                    <asp:TextBox ID="txtCompany" runat="server" placeholder="Enter your company name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCompany" runat="server" ControlToValidate="txtCompany"
                        ErrorMessage="Company is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>

                <!-- COMMENTED OUT FOR FUTURE USE -->
                <!--
                <div class="form-group file-upload-section">
                    <label for="<%=txtLinkedInProfile.ClientID%>">LinkedIn Profile</label>
                    <asp:TextBox ID="txtLinkedInProfile" runat="server" placeholder="https://linkedin.com/in/username"></asp:TextBox>
                </div>

                <div class="form-row file-upload-section">
                    <div class="form-group">
                        <label>Recent Photo</label>
                        <asp:FileUpload ID="fuPhoto" runat="server" />
                    </div>

                    <div class="form-group">
                        <label>Company Logo (High Resolution)</label>
                        <asp:FileUpload ID="fuLogo" runat="server" />
                    </div>
                </div>
                -->
            </div>

            <!-- Section 2: Professional Profile -->
            <div class="form-section">
                <h3><i class="fas fa-briefcase"></i> Professional Profile</h3>

                <div class="form-group">
                    <label for="<%=txtProfessionalBio.ClientID%>">Professional Bio (150-250 words recommended)</label>
                    <p class="info-text">This will be used for promotional and agenda material</p>
                    <asp:TextBox ID="txtProfessionalBio" runat="server" TextMode="MultiLine" Rows="5"
                        placeholder="Enter your professional bio"></asp:TextBox>
                    <div id="bioCharCount" class="char-counter">0 characters</div>
                </div>

                <div class="form-group">
                    <label>Areas of Expertise</label>
                    <p class="info-text">Please select or mention your core areas of domain expertise</p>
                    <div class="checkbox-group">
                        <div class="checkbox-item">
                            <input type="checkbox" id="chkBaseOils" />
                            <label for="chkBaseOils">Base Oils</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="chkAdditives" />
                            <label for="chkAdditives">Lubricant Additives</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="chkIndustrial" />
                            <label for="chkIndustrial">Industrial Lubrication</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="chkAutomotive" />
                            <label for="chkAutomotive">Automotive & EV Fluids</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="chkSynthetic" />
                            <label for="chkSynthetic">Synthetic and Bio-Based Lubricants</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="chkSustainability" />
                            <label for="chkSustainability">Sustainability & Circularity</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="chkTribology" />
                            <label for="chkTribology">Tribology & Wear Performance</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="chkMonitoring" />
                            <label for="chkMonitoring">Condition Monitoring & Smart Maintenance</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="chkRegulatory" />
                            <label for="chkRegulatory">Regulatory Compliance & Standards</label>
                        </div>
                    </div>
                    <asp:TextBox ID="txtOtherExpertise" runat="server" placeholder="Other areas (please specify)" style="margin-top: 12px;"></asp:TextBox>
                    <asp:HiddenField ID="hdnAreasOfExpertise" runat="server" />
                </div>
            </div>

            <!-- Section 3: Current Work & Projects -->
            <div class="form-section">
                <h3><i class="fas fa-project-diagram"></i> Current Work & Projects</h3>

                <div class="form-group">
                    <label for="<%=txtCurrentWorkProjects.ClientID%>">Current Work & Projects</label>
                    <p class="info-text">Description of current projects, research or industry initiatives you're involved in</p>
                    <asp:TextBox ID="txtCurrentWorkProjects" runat="server" TextMode="MultiLine" Rows="4"
                        placeholder="Describe your current work, projects, research or industry initiatives"></asp:TextBox>
                    <div id="workCharCount" class="char-counter">0 characters</div>
                </div>

                <div class="form-group">
                    <label for="<%=txtSuggestedTopics.ClientID%>">Suggested Topics/Themes You'd Be Comfortable Speaking On</label>
                    <p class="info-text">You may list 2-3 topics that reflect your current work or thought leadership areas</p>
                    <asp:TextBox ID="txtSuggestedTopics" runat="server" TextMode="MultiLine" Rows="3"
                        placeholder="List 2-3 topics"></asp:TextBox>
                </div>
            </div>

            <!-- Section 4: Discussion Format & Speaking Experience -->
            <div class="form-section">
                <h3><i class="fas fa-comments"></i> Discussion Format & Speaking Experience</h3>

                <div class="form-group">
                    <label>Preferred Discussion Format</label>
                    <p class="info-text">Select all that apply</p>
                    <div class="checkbox-group">
                        <div class="checkbox-item">
                            <input type="checkbox" id="chkPanel" />
                            <label for="chkPanel">Panel Discussion</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="chkPresentation" />
                            <label for="chkPresentation">Technical Presentation</label>
                        </div>
                    </div>
                    <asp:HiddenField ID="hdnPreferredFormat" runat="server" />
                </div>

                <div class="form-group">
                    <label for="<%=txtPreviousSpeakingEngagements.ClientID%>">Previous Speaking Engagements</label>
                    <p class="info-text">Please list any conferences, webinars or forums where you've recently spoken (Include links to recordings or published content if available)</p>
                    <asp:TextBox ID="txtPreviousSpeakingEngagements" runat="server" TextMode="MultiLine" Rows="4"
                        placeholder="List your speaking engagements with links if available"></asp:TextBox>
                    <div id="engagementsCharCount" class="char-counter">0 characters</div>
                </div>
            </div>

            <!-- Section 5: Consent & Availability -->
            <div class="form-section">
                <h3><i class="fas fa-check-circle"></i> Consent & Availability</h3>

                <div class="form-group">
                    <label for="<%=ddlIsAvailable.ClientID%>">Are you available to speak during the scheduled event dates? <span class="required">*</span></label>
                    <asp:DropDownList ID="ddlIsAvailable" runat="server">
                        <asp:ListItem Text="Yes" Value="Yes" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="No" Value="No"></asp:ListItem>
                        <asp:ListItem Text="Tentative" Value="Tentative"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkMarketingConsent" runat="server" />
                        <label for="<%=chkMarketingConsent.ClientID%>">
                            I consent to the use of my photo, name and bio in event marketing materials
                        </label>
                    </div>
                </div>
            </div>

            <div class="form-footer">
                <a href="Default.aspx" class="back-link">
                    <i class="fas fa-arrow-left"></i>Back to Home
                </a>
                <asp:Button ID="btnRegister" runat="server" Text="Submit Registration" CssClass="btn btn-primary"
                    OnClick="btnRegister_Click" ValidationGroup="RegistrationValidation" OnClientClick="return collectCheckboxData();" />
            </div>
        </div>

        <script type="text/javascript">
            function updateCharCount(textboxId, counterId) {
                var textbox = document.getElementById(textboxId);
                var counter = document.getElementById(counterId);
                if (textbox && counter) {
                    counter.textContent = textbox.value.length + ' characters';
                }
            }

            function collectCheckboxData() {
                // Collect Areas of Expertise
                var expertise = [];
                if (document.getElementById('chkBaseOils').checked) expertise.push('Base Oils');
                if (document.getElementById('chkAdditives').checked) expertise.push('Lubricant Additives');
                if (document.getElementById('chkIndustrial').checked) expertise.push('Industrial Lubrication');
                if (document.getElementById('chkAutomotive').checked) expertise.push('Automotive & EV Fluids');
                if (document.getElementById('chkSynthetic').checked) expertise.push('Synthetic and Bio-Based Lubricants');
                if (document.getElementById('chkSustainability').checked) expertise.push('Sustainability & Circularity');
                if (document.getElementById('chkTribology').checked) expertise.push('Tribology & Wear Performance');
                if (document.getElementById('chkMonitoring').checked) expertise.push('Condition Monitoring & Smart Maintenance');
                if (document.getElementById('chkRegulatory').checked) expertise.push('Regulatory Compliance & Standards');

                var otherExpertise = document.getElementById('<%=txtOtherExpertise.ClientID%>').value.trim();
                if (otherExpertise) {
                    expertise.push('Other: ' + otherExpertise);
                }

                document.getElementById('<%=hdnAreasOfExpertise.ClientID%>').value = expertise.join(', ');

                // Collect Preferred Discussion Format
                var formats = [];
                if (document.getElementById('chkPanel').checked) formats.push('Panel Discussion');
                if (document.getElementById('chkPresentation').checked) formats.push('Technical Presentation');

                document.getElementById('<%=hdnPreferredFormat.ClientID%>').value = formats.join(', ');

                return true; // Allow form submission
            }

            // Initialize character counters on page load - use window.onload for better compatibility
            window.onload = function() {
                // Initialize counters
                updateCharCount('<%=txtProfessionalBio.ClientID%>', 'bioCharCount');
                updateCharCount('<%=txtCurrentWorkProjects.ClientID%>', 'workCharCount');
                updateCharCount('<%=txtPreviousSpeakingEngagements.ClientID%>', 'engagementsCharCount');

                // Add event listeners for real-time updates
                var bioTextbox = document.getElementById('<%=txtProfessionalBio.ClientID%>');
                if (bioTextbox) {
                    bioTextbox.addEventListener('input', function() {
                        updateCharCount('<%=txtProfessionalBio.ClientID%>', 'bioCharCount');
                    });
                }

                var workTextbox = document.getElementById('<%=txtCurrentWorkProjects.ClientID%>');
                if (workTextbox) {
                    workTextbox.addEventListener('input', function() {
                        updateCharCount('<%=txtCurrentWorkProjects.ClientID%>', 'workCharCount');
                    });
                }

                var engagementsTextbox = document.getElementById('<%=txtPreviousSpeakingEngagements.ClientID%>');
                if (engagementsTextbox) {
                    engagementsTextbox.addEventListener('input', function() {
                        updateCharCount('<%=txtPreviousSpeakingEngagements.ClientID%>', 'engagementsCharCount');
                    });
                }
            };
        </script>
    </form>
</body>
</html>