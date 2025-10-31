<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PostApprovalExhibitor.aspx.cs" Inherits="Expo_Panel.PostApprovalExhibitor" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Post Approval Exhibitor Profile - Expo Panel</title>
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
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
            min-height: 100vh;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .profile-container {
            width: 1000px;
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
            color: #dd6b20;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .header p {
            color: #6b7280;
            font-size: 16px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group.full-width {
            grid-column: span 2;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #374151;
            font-weight: 500;
        }

        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group input[type="email"],
        .form-group input[type="tel"],
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
            font-family: 'Poppins', sans-serif;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #ed8936;
        }

        .checkbox-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-top: 10px;
        }

        .checkbox-item {
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }

        .checkbox-item input[type="checkbox"] {
            margin-top: 3px;
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .checkbox-item label {
            margin: 0;
            cursor: pointer;
            font-weight: 400;
            font-size: 14px;
        }

        .checkbox-item input[type="text"] {
            flex: 1;
            padding: 8px 12px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            font-size: 13px;
        }

        .section-title {
            color: #dd6b20;
            font-size: 18px;
            font-weight: 600;
            margin: 30px 0 20px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #fed7aa;
        }

        .required {
            color: #ef4444;
        }

        .file-upload {
            position: relative;
            margin-top: 10px;
        }

        .file-upload input[type="file"] {
            width: 100%;
            padding: 12px;
            border: 2px dashed #e2e8f0;
            border-radius: 8px;
            cursor: pointer;
        }

        .btn {
            padding: 12px 24px;
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
            background: #dd6b20;
            color: white;
        }

        .btn-primary:hover {
            background: #ed8936;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(221, 107, 32, 0.4);
        }

        .btn-primary:disabled {
            background: #cbd5e0;
            cursor: not-allowed;
            transform: none;
        }

        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
        }

        .back-link {
            color: #dd6b20;
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 5px;
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
            position: relative;
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

        .alert .close-btn {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: inherit;
            opacity: 0.5;
            line-height: 1;
            padding: 0;
            width: 24px;
            height: 24px;
        }

        .alert .close-btn:hover {
            opacity: 1;
        }

        .additional-req-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
        }

        .additional-req-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
        }

        .additional-req-group input[type="number"],
        .additional-req-group input[type="text"] {
            flex: 1;
            padding: 8px 12px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }

            .form-group.full-width {
                grid-column: span 1;
            }

            .checkbox-group {
                grid-template-columns: 1fr;
            }

            .form-footer {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="profile-container">
            <div class="header">
                <h1><i class="fas fa-id-card"></i> Post Approval Exhibitor Profile</h1>
                <p>Complete your exhibitor profile for Lubricant India Expo & Summit 2026</p>
            </div>

            <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>

            <!-- Booth Information -->
            <div class="section-title"><i class="fas fa-map-marker-alt"></i> Booth Information</div>

            <div class="form-row">
                <div class="form-group">
                    <label for="<%=txtBoothNo.ClientID%>">Booth No <span class="required">*</span></label>
                    <asp:TextBox ID="txtBoothNo" runat="server" placeholder="Enter booth number"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvBoothNo" runat="server" ControlToValidate="txtBoothNo" 
                        ErrorMessage="Booth number is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ProfileValidation"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtHallNo.ClientID%>">Hall No <span class="required">*</span></label>
                    <asp:TextBox ID="txtHallNo" runat="server" placeholder="Enter hall number"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvHallNo" runat="server" ControlToValidate="txtHallNo" 
                        ErrorMessage="Hall number is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ProfileValidation"></asp:RequiredFieldValidator>
                </div>
            </div>

            <!-- Exhibitor Profile -->
            <div class="section-title"><i class="fas fa-building"></i> Exhibitor Profile</div>

            <div class="form-row">
                <div class="form-group">
                    <label for="<%=txtYearOfEstablishment.ClientID%>">Year of Establishment <span class="required">*</span></label>
                    <asp:TextBox ID="txtYearOfEstablishment" runat="server" TextMode="Number" placeholder="e.g., 2000"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvYear" runat="server" ControlToValidate="txtYearOfEstablishment" 
                        ErrorMessage="Year of establishment is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ProfileValidation"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtWebsite.ClientID%>">Website <span class="required">*</span></label>
                    <asp:TextBox ID="txtWebsite" runat="server" placeholder="https://www.example.com"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvWebsite" runat="server" ControlToValidate="txtWebsite" 
                        ErrorMessage="Website is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ProfileValidation"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-group full-width">
                <label>Social Media Handles</label>
                <div class="form-row">
                    <div class="form-group">
                        <asp:TextBox ID="txtLinkedIn" runat="server" placeholder="LinkedIn URL"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:TextBox ID="txtTwitter" runat="server" placeholder="Twitter URL"></asp:TextBox>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <asp:TextBox ID="txtFacebook" runat="server" placeholder="Facebook URL"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:TextBox ID="txtYouTube" runat="server" placeholder="YouTube URL"></asp:TextBox>
                    </div>
                </div>
            </div>

            <!-- Customer Support Contact -->
            <div class="section-title"><i class="fas fa-headset"></i> Customer Support Contact</div>

            <div class="form-row">
                <div class="form-group">
                    <label for="<%=txtSupportName.ClientID%>">Contact Person Name <span class="required">*</span></label>
                    <asp:TextBox ID="txtSupportName" runat="server" placeholder="Enter contact person name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSupportName" runat="server" ControlToValidate="txtSupportName" 
                        ErrorMessage="Contact person name is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ProfileValidation"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtSupportContact.ClientID%>">Contact Number <span class="required">*</span></label>
                    <asp:TextBox ID="txtSupportContact" runat="server" placeholder="Enter contact number"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSupportContact" runat="server" ControlToValidate="txtSupportContact" 
                        ErrorMessage="Contact number is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ProfileValidation"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-group">
                <label for="<%=txtSupportEmail.ClientID%>">Email <span class="required">*</span></label>
                <asp:TextBox ID="txtSupportEmail" runat="server" TextMode="Email" placeholder="Enter support email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvSupportEmail" runat="server" ControlToValidate="txtSupportEmail" 
                    ErrorMessage="Support email is required" ForeColor="Red" Display="Dynamic" ValidationGroup="ProfileValidation"></asp:RequiredFieldValidator>
            </div>

            <!-- Nature of Business -->
            <div class="section-title"><i class="fas fa-briefcase"></i> Nature of Business</div>

            <div class="form-group">
                <label>Select all that apply <span class="required">*</span></label>
                <div class="checkbox-group">
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkManufacturer" runat="server" />
                        <label for="<%=chkManufacturer.ClientID%>">Manufacturer</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkDistributor" runat="server" />
                        <label for="<%=chkDistributor.ClientID%>">Distributor / Dealer</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkImporter" runat="server" />
                        <label for="<%=chkImporter.ClientID%>">Importer / Exporter</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkServiceProvider" runat="server" />
                        <label for="<%=chkServiceProvider.ClientID%>">Service Provider</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkTechnologyProvider" runat="server" />
                        <label for="<%=chkTechnologyProvider.ClientID%>">Technology Provider</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkRnDServices" runat="server" />
                        <label for="<%=chkRnDServices.ClientID%>">R&D / Testing Services</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkConsultancy" runat="server" />
                        <label for="<%=chkConsultancy.ClientID%>">Consultancy</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkIndustryAssociation" runat="server" />
                        <label for="<%=chkIndustryAssociation.ClientID%>">Industry Association</label>
                    </div>
                </div>
                <div class="checkbox-item" style="margin-top: 12px;">
                    <asp:CheckBox ID="chkNatureOther" runat="server" />
                    <label for="<%=chkNatureOther.ClientID%>">Other:</label>
                    <asp:TextBox ID="txtNatureOther" runat="server" placeholder="Please specify"></asp:TextBox>
                </div>
            </div>

            <!-- Company Category / Primary Products -->
            <div class="section-title"><i class="fas fa-tags"></i> Company Category / Primary Products</div>

            <div class="form-group">
                <label>Select all that apply <span class="required">*</span></label>
                <div class="checkbox-group">
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkAutomotiveLubricants" runat="server" />
                        <label for="<%=chkAutomotiveLubricants.ClientID%>">Automotive Lubricants</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkIndustrialLubricants" runat="server" />
                        <label for="<%=chkIndustrialLubricants.ClientID%>">Industrial Lubricants</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkBaseOils" runat="server" />
                        <label for="<%=chkBaseOils.ClientID%>">Base Oils</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkAdditives" runat="server" />
                        <label for="<%=chkAdditives.ClientID%>">Additives</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkGreases" runat="server" />
                        <label for="<%=chkGreases.ClientID%>">Greases</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkSpecialtyFluids" runat="server" />
                        <label for="<%=chkSpecialtyFluids.ClientID%>">Specialty Fluids</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkBioBasedLubricants" runat="server" />
                        <label for="<%=chkBioBasedLubricants.ClientID%>">Bio-based / Sustainable</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkReRefinedOils" runat="server" />
                        <label for="<%=chkReRefinedOils.ClientID%>">Re-refined Oils</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkPackaging" runat="server" />
                        <label for="<%=chkPackaging.ClientID%>">Packaging Equipment</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkLabEquipment" runat="server" />
                        <label for="<%=chkLabEquipment.ClientID%>">Lab / Testing Equipment</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkLubricationSystems" runat="server" />
                        <label for="<%=chkLubricationSystems.ClientID%>">Lubrication Systems</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkSoftwareAI" runat="server" />
                        <label for="<%=chkSoftwareAI.ClientID%>">Software / AI Solutions</label>
                    </div>
                </div>
                <div class="checkbox-item" style="margin-top: 12px;">
                    <asp:CheckBox ID="chkProductOther" runat="server" />
                    <label for="<%=chkProductOther.ClientID%>">Others:</label>
                    <asp:TextBox ID="txtProductOther" runat="server" placeholder="Please specify"></asp:TextBox>
                </div>
            </div>

            <!-- Markets You Cater To -->
            <div class="section-title"><i class="fas fa-globe"></i> Markets You Cater To</div>

            <div class="form-group">
                <label>Select all that apply <span class="required">*</span></label>
                <div class="checkbox-group">
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkAutomotive" runat="server" />
                        <label for="<%=chkAutomotive.ClientID%>">Automotive</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkHeavyCommercial" runat="server" />
                        <label for="<%=chkHeavyCommercial.ClientID%>">Heavy Commercial Vehicles</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkRailways" runat="server" />
                        <label for="<%=chkRailways.ClientID%>">Railways</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkMarine" runat="server" />
                        <label for="<%=chkMarine.ClientID%>">Marine</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkAerospace" runat="server" />
                        <label for="<%=chkAerospace.ClientID%>">Aerospace</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkManufacturing" runat="server" />
                        <label for="<%=chkManufacturing.ClientID%>">Manufacturing & Processing</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkPowerEnergy" runat="server" />
                        <label for="<%=chkPowerEnergy.ClientID%>">Power & Energy</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkConstruction" runat="server" />
                        <label for="<%=chkConstruction.ClientID%>">Construction & Mining</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkAgriculture" runat="server" />
                        <label for="<%=chkAgriculture.ClientID%>">Agriculture</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkFMCG" runat="server" />
                        <label for="<%=chkFMCG.ClientID%>">FMCG / Food Processing</label>
                    </div>
                </div>
                <div class="checkbox-item" style="margin-top: 12px;">
                    <asp:CheckBox ID="chkMarketOther" runat="server" />
                    <label for="<%=chkMarketOther.ClientID%>">Other:</label>
                    <asp:TextBox ID="txtMarketOther" runat="server" placeholder="Please specify"></asp:TextBox>
                </div>
            </div>

            <!-- Geographic Reach -->
            <div class="section-title"><i class="fas fa-map"></i> Geographic Reach</div>

            <div class="form-group">
                <label>Select all that apply <span class="required">*</span></label>
                <div class="checkbox-group">
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkIndiaOnly" runat="server" />
                        <label for="<%=chkIndiaOnly.ClientID%>">India Only</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkSouthAsia" runat="server" />
                        <label for="<%=chkSouthAsia.ClientID%>">South Asia</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkAsiaPacific" runat="server" />
                        <label for="<%=chkAsiaPacific.ClientID%>">Asia-Pacific</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkMiddleEast" runat="server" />
                        <label for="<%=chkMiddleEast.ClientID%>">Middle East</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkAfrica" runat="server" />
                        <label for="<%=chkAfrica.ClientID%>">Africa</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkEurope" runat="server" />
                        <label for="<%=chkEurope.ClientID%>">Europe</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkGlobal" runat="server" />
                        <label for="<%=chkGlobal.ClientID%>">Global</label>
                    </div>
                </div>
            </div>

            <!-- Additional Requirements -->
            <div class="section-title"><i class="fas fa-cogs"></i> Additional Requirements</div>

            <div class="form-group">
                <div class="additional-req-group">
                    <asp:CheckBox ID="chkPowerSupply" runat="server" />
                    <label for="<%=chkPowerSupply.ClientID%>">Power Supply</label>
                    <asp:TextBox ID="txtPowerSupplyKwh" runat="server" TextMode="Number" placeholder="Kwh" step="0.01"></asp:TextBox>
                </div>

                <div class="checkbox-item">
                    <asp:CheckBox ID="chkInternet" runat="server" />
                    <label for="<%=chkInternet.ClientID%>">Internet</label>
                </div>

                <div class="checkbox-item">
                    <asp:CheckBox ID="chkFurniture" runat="server" />
                    <label for="<%=chkFurniture.ClientID%>">Furniture Rental</label>
                </div>

                <div class="checkbox-item">
                    <asp:CheckBox ID="chkAVEquipment" runat="server" />
                    <label for="<%=chkAVEquipment.ClientID%>">AV Equipment</label>
                </div>

                <div class="checkbox-item">
                    <asp:CheckBox ID="chkInterpreter" runat="server" />
                    <label for="<%=chkInterpreter.ClientID%>">Interpreter Support</label>
                </div>

                <div class="checkbox-item" style="margin-top: 12px;">
                    <asp:CheckBox ID="chkReqOther" runat="server" />
                    <label for="<%=chkReqOther.ClientID%>">Others:</label>
                    <asp:TextBox ID="txtReqOther" runat="server" placeholder="Please specify"></asp:TextBox>
                </div>
            </div>

            <!-- Participation Objectives -->
            <div class="section-title"><i class="fas fa-bullseye"></i> Participation Objectives</div>

            <div class="form-group">
                <label>You may select multiple <span class="required">*</span></label>
                <div class="checkbox-group">
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkGenerateLeads" runat="server" />
                        <label for="<%=chkGenerateLeads.ClientID%>">Generate Business Leads</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkLaunchProducts" runat="server" />
                        <label for="<%=chkLaunchProducts.ClientID%>">Launch New Products</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkNetworking" runat="server" />
                        <label for="<%=chkNetworking.ClientID%>">Network with Industry</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkFindPartners" runat="server" />
                        <label for="<%=chkFindPartners.ClientID%>">Find Distribution Partners</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkMarketResearch" runat="server" />
                        <label for="<%=chkMarketResearch.ClientID%>">Market Research</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkBrandVisibility" runat="server" />
                        <label for="<%=chkBrandVisibility.ClientID%>">Brand Visibility</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkAttendConference" runat="server" />
                        <label for="<%=chkAttendConference.ClientID%>">Attend Conference Sessions</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkRecruitTalent" runat="server" />
                        <label for="<%=chkRecruitTalent.ClientID%>">Recruit Talent</label>
                    </div>
                </div>
                <div class="checkbox-item" style="margin-top: 12px;">
                    <asp:CheckBox ID="chkObjectiveOther" runat="server" />
                    <label for="<%=chkObjectiveOther.ClientID%>">Other:</label>
                    <asp:TextBox ID="txtObjectiveOther" runat="server" placeholder="Please specify"></asp:TextBox>
                </div>
            </div>

            <!-- Additional Notes -->
            <div class="section-title"><i class="fas fa-comment-alt"></i> Additional Notes / Comments</div>

            <div class="form-group">
                <label for="<%=txtAdditionalNotes.ClientID%>">Any special requirements or comments</label>
                <asp:TextBox ID="txtAdditionalNotes" runat="server" TextMode="MultiLine" 
                    placeholder="Enter any additional information, special requirements, or comments here..." 
                    Rows="5"></asp:TextBox>
            </div>

            <!-- File Uploads -->
            <div class="section-title"><i class="fas fa-upload"></i> Upload Documents</div>

            <div class="form-row">
                <div class="form-group">
                    <label for="<%=fuProductPicture.ClientID%>">Product Picture <span class="required">*</span></label>
                    <div class="file-upload">
                        <asp:FileUpload ID="fuProductPicture" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvProductPicture" runat="server" 
                            ControlToValidate="fuProductPicture" 
                            ErrorMessage="Product picture is required" 
                            ForeColor="Red" Display="Dynamic" ValidationGroup="ProfileValidation"></asp:RequiredFieldValidator>
                    </div>
                    <small style="color: #6b7280; font-size: 13px;">Accepted: All image formats</small>
                </div>

                <div class="form-group">
                    <label for="<%=fuBrochure.ClientID%>">Company Brochure <span class="required">*</span></label>
                    <div class="file-upload">
                        <asp:FileUpload ID="fuBrochure" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvBrochure" runat="server" 
                            ControlToValidate="fuBrochure" 
                            ErrorMessage="Brochure is required" 
                            ForeColor="Red" Display="Dynamic" ValidationGroup="ProfileValidation"></asp:RequiredFieldValidator>
                    </div>
                    <small style="color: #6b7280; font-size: 13px;">Accepted: All document formats (PDF, DOC, DOCX, etc.)</small>
                </div>
            </div>

            <!-- Form Footer -->
            <div class="form-footer">
                <a href="Dashboard.aspx" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
                <asp:Button ID="btnSubmit" runat="server" Text="Submit Profile" 
                    CssClass="btn btn-primary" OnClick="btnSubmit_Click" 
                    ValidationGroup="ProfileValidation" />
            </div>

        </div>
    </form>

    <script>
        // Show filename after selection
        document.addEventListener('DOMContentLoaded', function() {
            const fileInputs = document.querySelectorAll('input[type="file"]');
            fileInputs.forEach(input => {
                input.addEventListener('change', function() {
                    if (this.files.length > 0) {
                        const fileName = this.files[0].name;
                        const small = this.parentElement.parentElement.querySelector('small');
                        if (small) {
                            small.innerHTML = '<i class="fas fa-check-circle" style="color: #10b981;"></i> Selected: ' + fileName;
                        }
                    }
                });
            });

            // Enable/disable Power Supply Kwh input based on checkbox
            const chkPowerSupply = document.getElementById('<%=chkPowerSupply.ClientID%>');
            const txtPowerSupplyKwh = document.getElementById('<%=txtPowerSupplyKwh.ClientID%>');
            
            if (chkPowerSupply && txtPowerSupplyKwh) {
                chkPowerSupply.addEventListener('change', function() {
                    txtPowerSupplyKwh.disabled = !this.checked;
                    if (!this.checked) {
                        txtPowerSupplyKwh.value = '';
                    }
                });
                
                // Initialize on page load
                txtPowerSupplyKwh.disabled = !chkPowerSupply.checked;
            }
        });
    </script>
</body>
</html>
