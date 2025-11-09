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
    <!-- Light Mode Favicons -->
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

    <!-- Theme Colors -->
    <meta name="theme-color" content="#ffffff" media="(prefers-color-scheme: light)" />
    <meta name="theme-color" content="#000000" media="(prefers-color-scheme: dark)" />

    <!-- Windows Tile Support -->
    <meta name="msapplication-TileColor" content="#ffffff" />

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
            max-width: 1000px;
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

        .file-upload-wrapper {
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .file-upload-input {
            opacity: 0;
            position: absolute;
            z-index: -1;
        }

        .file-upload-label {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 20px;
            background: #f8fafc;
            border: 2px dashed #cbd5e1;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }

            .file-upload-label:hover {
                background: #f1f5f9;
                border-color: #48bb78;
            }

            .file-upload-label i {
                color: #48bb78;
                font-size: 20px;
            }

        .file-name {
            margin-top: 8px;
            color: #38a169;
            font-size: 13px;
            font-weight: 500;
        }

        .photo-preview {
            margin-top: 15px;
            display: none;
        }

            .photo-preview img {
                max-width: 200px;
                max-height: 200px;
                border-radius: 10px;
                border: 3px solid #48bb78;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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

        .agenda-table-wrapper {
            overflow-x: auto;
            margin-top: 15px;
            border-radius: 8px;
            border: 2px solid #e2e8f0;
        }

        .agenda-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

            .agenda-table thead {
                background: #f8fafc;
            }

            .agenda-table th {
                padding: 12px 15px;
                text-align: left;
                font-weight: 600;
                color: #475569;
                border-bottom: 2px solid #e2e8f0;
                font-size: 14px;
            }

            .agenda-table td {
                padding: 12px 15px;
                border-bottom: 1px solid #e2e8f0;
                font-size: 14px;
                color: #475569;
            }

            .agenda-table tbody tr:hover {
                background: #f8fafc;
            }

            .agenda-table tbody tr.selected {
                background: #f0fdf4;
            }

        .agenda-checkbox {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }

        .btn-view {
            padding: 6px 12px;
            background: #38a169;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

            .btn-view:hover {
                background: #2f855a;
                transform: translateY(-1px);
            }

        .selection-counter {
            background: #fef3c7;
            border: 1px solid #fcd34d;
            border-radius: 8px;
            padding: 12px 15px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #92400e;
            font-size: 14px;
            font-weight: 500;
        }

            .selection-counter i {
                font-size: 18px;
            }

        .modal {
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(4px);
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
        }

        .modal-content {
            position: relative;
            background: white;
            margin: 5% auto;
            padding: 0;
            width: 90%;
            max-width: 700px;
            border-radius: 15px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: slideDown 0.3s ease;
            max-height: 80vh;
            display: flex;
            flex-direction: column;
        }

        @keyframes slideDown {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }

            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-header {
            padding: 25px 30px;
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

            .modal-header h2 {
                font-size: 22px;
                font-weight: 600;
                margin: 0;
            }

        .modal-close {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            font-size: 24px;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
        }

            .modal-close:hover {
                background: rgba(255, 255, 255, 0.3);
                transform: rotate(90deg);
            }

        .modal-body {
            padding: 30px;
            overflow-y: auto;
            flex: 1;
        }

        .agenda-detail-row {
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e2e8f0;
        }

            .agenda-detail-row:last-child {
                border-bottom: none;
                margin-bottom: 0;
            }

        .agenda-detail-label {
            font-weight: 600;
            color: #38a169;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .agenda-detail-value {
            color: #475569;
            font-size: 15px;
            line-height: 1.6;
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

            .btn-primary:hover:not(:disabled) {
                background: #2f855a;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(56, 161, 105, 0.4);
            }

            .btn-primary:disabled {
                background: #cbd5e1;
                cursor: not-allowed;
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

            .modal-content {
                width: 95%;
                margin: 10% auto;
            }

            .agenda-table {
                font-size: 12px;
            }

                .agenda-table th,
                .agenda-table td {
                    padding: 8px 10px;
                }
        }

        /* Current File Display Styles */
.current-file-display {
    background: #f0fdf4;
    border: 2px solid #86efac;
    border-radius: 8px;
    padding: 15px;
    margin-bottom: 15px;
}

.current-file-info {
    display: flex;
    align-items: center;
    gap: 15px;
}

.current-photo-thumb,
.current-logo-thumb {
    width: 120px;
    height: 120px;
    object-fit: cover;
    border-radius: 8px;
    border: 2px solid #38a169;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.current-logo-thumb {
    object-fit: contain;
    background: white;
    padding: 10px;
}

.current-file-details {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.current-file-label {
    color: #166534;
    font-weight: 600;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.current-file-label i {
    color: #22c55e;
    font-size: 16px;
}

.btn-remove-file {
    background: #ef4444;
    color: white;
    border: none;
    padding: 8px 16px;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    align-self: flex-start;
}

.btn-remove-file:hover {
    background: #dc2626;
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
}

.btn-remove-file::before {
    content: '\f1f8';
    font-family: 'Font Awesome 6 Free';
    font-weight: 900;
}

@media (max-width: 768px) {
    .current-file-info {
        flex-direction: column;
        text-align: center;
    }

    .current-file-details {
        align-items: center;
    }
}

.alert-info {
    background: #dbeafe;
    color: #1e40af;
    border: 1px solid #93c5fd;
}
    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="registration-container">
            <div class="header">
                <h1><i class="fas fa-microphone"></i>Register as Speaker</h1>
                <p>Share your expertise and insights as a speaker at our expo</p>
            </div>

            <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>

            <!-- Section 1: Personal Information -->
            <div class="form-section">
                <h3><i class="fas fa-user"></i>Personal Information</h3>

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
            </div>

            <!-- Section 2: Profile & Media -->
            <div class="form-section">
                <h3><i class="fas fa-id-card"></i>Profile & Media</h3>

                <div class="form-group">
                    <label for="fuPhoto">Upload Your Recent Photo <span class="required">*</span></label>
                    <p class="info-text">Please upload a professional photo (JPG, PNG)</p>

                    <!-- Current Photo Display -->
                    <asp:Panel ID="pnlCurrentPhoto" runat="server" Visible="false" CssClass="current-file-display">
                        <div class="current-file-info">
                            <asp:Image ID="imgCurrentPhoto" runat="server" CssClass="current-photo-thumb" />
                            <div class="current-file-details">
                                <span class="current-file-label"><i class="fas fa-check-circle"></i>Current Photo</span>
                                <asp:Button ID="btnRemovePhoto" runat="server" Text="Remove & Upload New"
                                    CssClass="btn-remove-file" OnClick="btnRemovePhoto_Click"
                                    OnClientClick="return confirm('Are you sure you want to remove the current photo? You will need to upload a new one.');"
                                    CausesValidation="false" />
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- Upload New Photo -->
                    <asp:Panel ID="pnlUploadPhoto" runat="server">
                        <div class="file-upload-wrapper">
                            <asp:FileUpload ID="fuPhoto" runat="server" CssClass="file-upload-input"
                                accept="image/jpeg,image/png,image/jpg" onchange="displayFileName(this, 'photoFileName', 'photoPreview')" />
                            <label for="<%=fuPhoto.ClientID%>" class="file-upload-label">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <span>Choose Photo</span>
                            </label>
                        </div>
                        <div id="photoFileName" class="file-name"></div>
                        <div id="photoPreview" class="photo-preview">
                            <img id="photoPreviewImg" src="" alt="Photo Preview" />
                        </div>
                    </asp:Panel>

                    <asp:RequiredFieldValidator ID="rfvPhoto" runat="server" ControlToValidate="fuPhoto"
                        ErrorMessage="Photo is required" ForeColor="Red" Display="Dynamic"
                        ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                    <asp:HiddenField ID="hdnCurrentPhotoPath" runat="server" />
                </div>

                <div class="form-group">
                    <label>Company Logo <span class="text-muted">(Optional)</span></label>
                    <p class="info-text">High resolution logo (JPG, PNG)</p>

                    <!-- Current Logo Display -->
                    <asp:Panel ID="pnlCurrentLogo" runat="server" Visible="false" CssClass="current-file-display">
                        <div class="current-file-info">
                            <asp:Image ID="imgCurrentLogo" runat="server" CssClass="current-logo-thumb" />
                            <div class="current-file-details">
                                <span class="current-file-label"><i class="fas fa-check-circle"></i>Current Logo</span>
                                <asp:Button ID="btnRemoveLogo" runat="server" Text="Remove & Upload New"
                                    CssClass="btn-remove-file" OnClick="btnRemoveLogo_Click"
                                    OnClientClick="return confirm('Are you sure you want to remove the current logo?');"
                                    CausesValidation="false" />
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- Upload New Logo -->
                    <asp:Panel ID="pnlUploadLogo" runat="server">
                        <div class="file-upload-wrapper">
                            <asp:FileUpload ID="fuLogo" runat="server" CssClass="file-upload-input"
                                accept="image/jpeg,image/png,image/jpg" onchange="displayFileName(this, 'logoFileName', 'logoPreview')" />
                            <label for="<%=fuLogo.ClientID%>" class="file-upload-label">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <span>Choose Logo</span>
                            </label>
                        </div>
                        <div id="logoFileName" class="file-name"></div>
                        <div id="logoPreview" class="photo-preview">
                            <img id="logoPreviewImg" src="" alt="Logo Preview" />
                        </div>
                    </asp:Panel>

                    <asp:HiddenField ID="hdnCurrentLogoPath" runat="server" />
                </div>

                <div class="form-group">
                    <label for="<%=txtLinkedIn.ClientID%>">LinkedIn Profile URL <span class="required">*</span></label>
                    <asp:TextBox ID="txtLinkedIn" runat="server" placeholder="https://linkedin.com/in/yourprofile"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvLinkedIn" runat="server" ControlToValidate="txtLinkedIn"
                        ErrorMessage="LinkedIn profile is required" ForeColor="Red" Display="Dynamic"
                        ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revLinkedIn" runat="server" ControlToValidate="txtLinkedIn"
                        ErrorMessage="Please enter a valid LinkedIn URL" ForeColor="Red" Display="Dynamic"
                        ValidationExpression="^https?://(www\.)?linkedin\.com/.*$"
                        ValidationGroup="RegistrationValidation"></asp:RegularExpressionValidator>
                </div>
            </div>


            <!-- Section 3: Professional Profile -->
            <div class="form-section">
                <h3><i class="fas fa-briefcase"></i>Professional Profile</h3>

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
                    <asp:TextBox ID="txtOtherExpertise" runat="server" placeholder="Other areas (please specify)" Style="margin-top: 12px;"></asp:TextBox>
                    <asp:HiddenField ID="hdnAreasOfExpertise" runat="server" />
                </div>
            </div>

            <!-- Section 4: Current Work & Projects -->
            <div class="form-section">
                <h3><i class="fas fa-project-diagram"></i>Current Work & Projects</h3>

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

            <!-- Section 5: Discussion Format & Speaking Experience -->
            <div class="form-section">
                <h3><i class="fas fa-comments"></i>Discussion Format & Speaking Experience</h3>

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
                    <p class="info-text">Please list any conferences, webinars or forums where you've recently spoken</p>
                    <asp:TextBox ID="txtPreviousSpeakingEngagements" runat="server" TextMode="MultiLine" Rows="4"
                        placeholder="List your speaking engagements with links if available"></asp:TextBox>
                    <div id="engagementsCharCount" class="char-counter">0 characters</div>
                </div>
            </div>

            <!-- Section 6: Select Agenda Topics -->
            <div class="form-section">
                <h3><i class="fas fa-calendar-check"></i>Select Topics You'd Like to Speak On</h3>

                <div class="selection-counter">
                    <i class="fas fa-info-circle"></i>
                    <span>You can select up to 3 topics. Currently selected: <strong><span id="selectedCount">0</span>/3</strong></span>
                </div>

                <div class="agenda-table-wrapper">
                    <asp:Literal ID="litAgendaTable" runat="server"></asp:Literal>
                </div>

                <asp:HiddenField ID="hdnSelectedAgendas" runat="server" />
                <asp:CustomValidator ID="cvAgendaSelection" runat="server"
                    ErrorMessage="Please select at least 1 topic (maximum 3)" ForeColor="Red" Display="Dynamic"
                    ClientValidationFunction="validateAgendaSelection"
                    OnServerValidate="cvAgendaSelection_ServerValidate"
                    ValidationGroup="RegistrationValidation"></asp:CustomValidator>
            </div>

            <!-- Section 7: Consent & Availability -->
            <div class="form-section">
                <h3><i class="fas fa-check-circle"></i>Consent & Availability</h3>

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
               <%-- <a href="Default.aspx" class="back-link">
                    <i class="fas fa-arrow-left"></i>Back to Home
                </a>--%>
                <asp:Button ID="btnRegister" runat="server" Text="Submit Registration" CssClass="btn btn-primary"
                    OnClick="btnRegister_Click" ValidationGroup="RegistrationValidation" OnClientClick="return collectFormData();" />
            </div>

            <!-- Agenda Details Modal -->
            <div id="agendaModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2><i class="fas fa-info-circle"></i>Agenda Details</h2>
                        <button type="button" class="modal-close" onclick="closeModal()">&times;</button>
                    </div>
                    <div class="modal-body" id="modalBody">
                        <!-- Dynamic content will be loaded here -->
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            // Photo preview function
            // Add this after the displayFileName function
            function displayFileName(input, displayId, previewId) {
                var display = document.getElementById(displayId);
                var preview = document.getElementById(previewId);
                var previewImg = document.getElementById(previewId + 'Img');

                if (input.files && input.files[0]) {
                    var file = input.files[0];
                    var fileName = file.name;
                    var fileSize = (file.size / 1024 / 1024).toFixed(2);

                    // Determine max size based on file type
                    var maxSize = displayId.includes('logo') ? 5 : 2; // 5MB for logo, 2MB for photo
                    var fileTypeName = displayId.includes('logo') ? 'Logo' : 'Photo';

                   

                    // Validate file type
                    var fileType = file.type;
                    if (fileType !== 'image/jpeg' && fileType !== 'image/png' && fileType !== 'image/jpg') {
                        alert('Only JPG and PNG files are allowed');
                        input.value = '';
                        display.innerHTML = '';
                        preview.style.display = 'none';
                        return;
                    }

                    display.innerHTML = '<i class="fas fa-check-circle"></i> ' + fileName + ' (' + fileSize + ' MB)';

                    // Show preview
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        previewImg.src = e.target.result;
                        preview.style.display = 'block';
                    };
                    reader.readAsDataURL(file);
                } else {
                    display.innerHTML = '';
                    preview.style.display = 'none';
                }
            }

            // Character counter
            function updateCharCount(textboxId, counterId) {
                var textbox = document.getElementById(textboxId);
                var counter = document.getElementById(counterId);
                if (textbox && counter) {
                    counter.textContent = textbox.value.length + ' characters';
                }
            }

            // Agenda selection
            function toggleAgendaSelection(checkbox) {
                var row = checkbox.closest('tr');
                var selectedCount = document.querySelectorAll('.agenda-checkbox:checked').length;

                if (checkbox.checked) {
                    if (selectedCount > 3) {
                        checkbox.checked = false;
                        alert('You can only select up to 3 topics.');
                        return false;
                    }
                    row.classList.add('selected');
                } else {
                    row.classList.remove('selected');
                }

                updateSelectedCount();
            }

            function updateSelectedCount() {
                var selectedCount = document.querySelectorAll('.agenda-checkbox:checked').length;
                document.getElementById('selectedCount').textContent = selectedCount;
            }

            // View agenda details in modal
            function viewAgenda(agendaId, day, track, time, title, brief, synopsis) {
                var modalBody = document.getElementById('modalBody');

                var html = '';
                html += '<div class="agenda-detail-row">';
                html += '<div class="agenda-detail-label"><i class="fas fa-calendar"></i> Day</div>';
                html += '<div class="agenda-detail-value">' + day + '</div>';
                html += '</div>';

                html += '<div class="agenda-detail-row">';
                html += '<div class="agenda-detail-label"><i class="fas fa-map-marker-alt"></i> Track</div>';
                html += '<div class="agenda-detail-value">' + track + '</div>';
                html += '</div>';

                html += '<div class="agenda-detail-row">';
                html += '<div class="agenda-detail-label"><i class="fas fa-clock"></i> Time</div>';
                html += '<div class="agenda-detail-value">' + time + '</div>';
                html += '</div>';

                html += '<div class="agenda-detail-row">';
                html += '<div class="agenda-detail-label"><i class="fas fa-heading"></i> Title</div>';
                html += '<div class="agenda-detail-value">' + title + '</div>';
                html += '</div>';

                if (brief) {
                    html += '<div class="agenda-detail-row">';
                    html += '<div class="agenda-detail-label"><i class="fas fa-align-left"></i> Brief</div>';
                    html += '<div class="agenda-detail-value">' + brief + '</div>';
                    html += '</div>';
                }

                if (synopsis) {
                    html += '<div class="agenda-detail-row">';
                    html += '<div class="agenda-detail-label"><i class="fas fa-file-alt"></i> Full Synopsis</div>';
                    html += '<div class="agenda-detail-value">' + synopsis + '</div>';
                    html += '</div>';
                }

                modalBody.innerHTML = html;
                document.getElementById('agendaModal').style.display = 'block';
            }

            function closeModal() {
                document.getElementById('agendaModal').style.display = 'none';
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                var modal = document.getElementById('agendaModal');
                if (event.target == modal) {
                    closeModal();
                }
            };

            // Collect all form data before submission
            function collectFormData() {
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

                // Collect Selected Agendas
                var checkboxes = document.querySelectorAll('.agenda-checkbox:checked');
                var selectedIds = [];

                checkboxes.forEach(function (cb) {
                    selectedIds.push(cb.value);
                });

                document.getElementById('<%=hdnSelectedAgendas.ClientID%>').value = selectedIds.join(',');

                return true;
            }

            function validateAgendaSelection(sender, args) {
                var checkboxes = document.querySelectorAll('.agenda-checkbox:checked');
                var count = checkboxes.length;
                args.IsValid = (count >= 1 && count <= 3);
            }

            // Initialize on page load
            window.onload = function () {
                // Initialize character counters
                updateCharCount('<%=txtProfessionalBio.ClientID%>', 'bioCharCount');
                updateCharCount('<%=txtCurrentWorkProjects.ClientID%>', 'workCharCount');
                updateCharCount('<%=txtPreviousSpeakingEngagements.ClientID%>', 'engagementsCharCount');

                // Add event listeners for real-time updates
                var bioTextbox = document.getElementById('<%=txtProfessionalBio.ClientID%>');
                if (bioTextbox) {
                    bioTextbox.addEventListener('input', function () {
                        updateCharCount('<%=txtProfessionalBio.ClientID%>', 'bioCharCount');
                    });
                }

                var workTextbox = document.getElementById('<%=txtCurrentWorkProjects.ClientID%>');
                if (workTextbox) {
                    workTextbox.addEventListener('input', function () {
                        updateCharCount('<%=txtCurrentWorkProjects.ClientID%>', 'workCharCount');
                    });
                }

                var engagementsTextbox = document.getElementById('<%=txtPreviousSpeakingEngagements.ClientID%>');
                if (engagementsTextbox) {
                    engagementsTextbox.addEventListener('input', function () {
                        updateCharCount('<%=txtPreviousSpeakingEngagements.ClientID%>', 'engagementsCharCount');
                    });
                }

                // Initialize selected count
                updateSelectedCount();
            };

            // Preselect agendas for logged-in speakers
            function preselectAgendas(agendaIds, hasModifiedAgenda) {
                console.log('Preselecting agendas:', agendaIds);
                console.log('Has modified agenda:', hasModifiedAgenda);

                if (!agendaIds) return;

                var ids = agendaIds.split(',');
                var selectedCount = 0;

                // Loop through agenda IDs and check the corresponding checkboxes
                ids.forEach(function (id) {
                    id = id.trim();
                    if (id) {
                        // Find checkbox by value (AgendaID)
                        var checkbox = document.querySelector('input.agenda-checkbox[value="' + id + '"]');

                        if (checkbox) {
                            checkbox.checked = true;
                            selectedCount++;
                            console.log('Checked agenda ID:', id);
                        } else {
                            console.log('Checkbox not found for agenda ID:', id);
                        }
                    }
                });

                // Update hidden field and counter
                document.getElementById('<%= hdnSelectedAgendas.ClientID %>').value = agendaIds;

                var counter = document.getElementById('topicCount');
                if (counter) {
                    counter.textContent = selectedCount;
                }

                // If speaker has already modified agenda, disable all checkboxes
                if (hasModifiedAgenda) {
                    disableAgendaSelection();
                } else {
                    // If max topics selected, disable unchecked boxes
                    if (selectedCount >= 3) {
                        var allCheckboxes = document.querySelectorAll('.agenda-checkbox');
                        allCheckboxes.forEach(function (cb) {
                            if (!cb.checked) {
                                cb.disabled = true;
                            }
                        });
                    }
                }
            }


            function disableAgendaSelection() {
                console.log('Disabling agenda selection...');

                var allCheckboxes = document.querySelectorAll('.agenda-checkbox');
                allCheckboxes.forEach(function (checkbox) {
                    checkbox.disabled = true;
                    var row = checkbox.closest('tr');
                    if (row) {
                        row.style.opacity = '0.6';
                        row.style.cursor = 'not-allowed';
                    }
                });

                // Add notice message
                var agendaSection = document.getElementById('agendaSection');
                if (agendaSection && !document.getElementById('agendaModifiedNotice')) {
                    var notice = document.createElement('div');
                    notice.id = 'agendaModifiedNotice';
                    notice.className = 'alert alert-info';
                    notice.style.marginBottom = '15px';
                    notice.innerHTML = '<i class="fas fa-info-circle"></i> You have already modified your agenda selection. No further changes are allowed.';

                    agendaSection.insertBefore(notice, agendaSection.firstChild);
                }
            }
            document.addEventListener('DOMContentLoaded', function () {
                var agendaCheckboxes = document.querySelectorAll('.agenda-checkbox');
                var hiddenField = document.getElementById('<%= hdnSelectedAgendas.ClientID %>');
                var counter = document.getElementById('topicCount');

                agendaCheckboxes.forEach(function (checkbox) {
                    checkbox.addEventListener('change', function () {
                        updateAgendaSelection();
                    });
                });

                function updateAgendaSelection() {
                    var selectedAgendas = [];
                    agendaCheckboxes.forEach(function (checkbox) {
                        if (checkbox.checked) {
                            selectedAgendas.push(checkbox.value);
                        }
                    });

                    hiddenField.value = selectedAgendas.join(',');

                    if (counter) {
                        counter.textContent = selectedAgendas.length;
                    }

                    // Disable/enable checkboxes based on selection count
                    if (selectedAgendas.length >= 3) {
                        agendaCheckboxes.forEach(function (checkbox) {
                            if (!checkbox.checked) {
                                checkbox.disabled = true;
                            }
                        });
                    } else {
                        agendaCheckboxes.forEach(function (checkbox) {
                            if (!checkbox.disabled) {
                                checkbox.disabled = false;
                            }
                        });
                    }
                }
            });

            // Function to preselect expertise and format checkboxes
            function preselectCheckboxes() {
                // Preselect Areas of Expertise
                var expertise = document.getElementById('<%=hdnAreasOfExpertise.ClientID%>').value;
                if (expertise) {
                    var expertiseItems = expertise.split(', ');
                    expertiseItems.forEach(function (item) {
                        item = item.trim();

                        if (item === 'Base Oils') document.getElementById('chkBaseOils').checked = true;
                        if (item === 'Lubricant Additives') document.getElementById('chkAdditives').checked = true;
                        if (item === 'Industrial Lubrication') document.getElementById('chkIndustrial').checked = true;
                        if (item === 'Automotive & EV Fluids') document.getElementById('chkAutomotive').checked = true;
                        if (item === 'Synthetic and Bio-Based Lubricants') document.getElementById('chkSynthetic').checked = true;
                        if (item === 'Sustainability & Circularity') document.getElementById('chkSustainability').checked = true;
                        if (item === 'Tribology & Wear Performance') document.getElementById('chkTribology').checked = true;
                        if (item === 'Condition Monitoring & Smart Maintenance') document.getElementById('chkMonitoring').checked = true;
                        if (item === 'Regulatory Compliance & Standards') document.getElementById('chkRegulatory').checked = true;

                        // Handle "Other" items
                        if (item.startsWith('Other: ')) {
                            var otherText = item.replace('Other: ', '');
                            document.getElementById('<%=txtOtherExpertise.ClientID%>').value = otherText;
                        }
                    });
                }

                // Preselect Preferred Discussion Format
                var format = document.getElementById('<%=hdnPreferredFormat.ClientID%>').value;
                if (format) {
                    var formatItems = format.split(', ');
                    formatItems.forEach(function (item) {
                        item = item.trim();

                        if (item === 'Panel Discussion') document.getElementById('chkPanel').checked = true;
                        if (item === 'Technical Presentation') document.getElementById('chkPresentation').checked = true;
                    });
                }
            }

        </script>
    </form>
</body>
</html>
