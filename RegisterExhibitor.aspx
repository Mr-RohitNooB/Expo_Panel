<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegisterExhibitor.aspx.cs" Inherits="Expo_Panel.RegisterExhibitor" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register as Exhibitor - Expo Panel</title>
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

        .registration-container {
            width: 100%;
            max-width: 900px;
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
        .form-group input[type="email"],
        .form-group input[type="tel"],
        .form-group input[type="number"],
        .form-group textarea,
        .form-group select {
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
            min-height: 80px;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #ed8936;
        }

        .booth-options {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 10px;
        }

        .booth-option {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .booth-option:hover {
            border-color: #fbd38d;
            background: #fff7ed;
        }

        .booth-option input[type="radio"] {
            margin-top: 3px;
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .booth-option-content {
            flex: 1;
        }

        .booth-option-title {
            font-weight: 500;
            color: #374151;
            margin-bottom: 5px;
        }

        .booth-option-desc {
            font-size: 13px;
            color: #6b7280;
        }

        .checkbox-group {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-top: 10px;
        }

        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .checkbox-item input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .checkbox-item label {
            margin: 0;
            cursor: pointer;
            font-weight: 400;
        }

        .declaration-box {
            background: #fff7ed;
            border: 2px solid #fed7aa;
            border-radius: 8px;
            padding: 20px;
            margin: 25px 0;
        }

        .declaration-box h3 {
            color: #dd6b20;
            font-size: 18px;
            margin-bottom: 15px;
        }

        .declaration-text {
            font-size: 14px;
            color: #374151;
            line-height: 1.6;
            margin-bottom: 15px;
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

        .btn-secondary {
            background: #e2e8f0;
            color: #374151;
        }

        .btn-secondary:hover {
            background: #fbd38d;
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

        .section-title {
            color: #dd6b20;
            font-size: 18px;
            font-weight: 600;
            margin: 30px 0 20px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #fed7aa;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }

            .form-group.full-width {
                grid-column: span 1;
            }

            .form-footer {
                flex-direction: column;
                gap: 15px;
            }
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

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="registration-container">
            <div class="header">
                <h1><i class="fas fa-store"></i> Exhibitor Registration Form</h1>
                <p>Lubricant India Expo & Summit 2026</p>
            </div>

            <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>

            <!-- Basic Information -->
            <div class="section-title"><i class="fas fa-user"></i> Basic Information</div>

            <div class="form-row">
                <div class="form-group">
                    <label for="<%=txtName.ClientID%>">Full Name <span class="required">*</span></label>
                    <asp:TextBox ID="txtName" runat="server" placeholder="Enter your full name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" 
                        ErrorMessage="Full name is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtDesignation.ClientID%>">Designation <span class="required">*</span></label>
                    <asp:TextBox ID="txtDesignation" runat="server" placeholder="Enter your designation"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDesignation" runat="server" ControlToValidate="txtDesignation" 
                        ErrorMessage="Designation is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="<%=txtMobile.ClientID%>">Phone Number <span class="required">*</span></label>
                    <asp:TextBox ID="txtMobile" runat="server" placeholder="Enter your phone number"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvMobile" runat="server" ControlToValidate="txtMobile" 
                        ErrorMessage="Phone number is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
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

            <!-- Company Information -->
            <div class="section-title"><i class="fas fa-building"></i> Company Information</div>

            <div class="form-row">
                <div class="form-group full-width">
                    <label for="<%=txtCompany.ClientID%>">Company Name <span class="required">*</span></label>
                    <asp:TextBox ID="txtCompany" runat="server" placeholder="Enter your company name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCompany" runat="server" ControlToValidate="txtCompany" 
                        ErrorMessage="Company name is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group full-width">
                    <label for="<%=txtHeadOffice.ClientID%>">Head Office Address <span class="required">*</span></label>
                    <asp:TextBox ID="txtHeadOffice" runat="server" TextMode="MultiLine" placeholder="Enter complete head office address"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvHeadOffice" runat="server" ControlToValidate="txtHeadOffice" 
                        ErrorMessage="Head office address is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="<%=txtCity.ClientID%>">City <span class="required">*</span></label>
                    <asp:TextBox ID="txtCity" runat="server" placeholder="Enter city"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="txtCity" 
                        ErrorMessage="City is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtState.ClientID%>">State <span class="required">*</span></label>
                    <asp:TextBox ID="txtState" runat="server" placeholder="Enter state"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="txtState" 
                        ErrorMessage="State is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="<%=txtCountry.ClientID%>">Country <span class="required">*</span></label>
                    <asp:TextBox ID="txtCountry" runat="server" placeholder="Enter country"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCountry" runat="server" ControlToValidate="txtCountry" 
                        ErrorMessage="Country is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtGSTNumber.ClientID%>">GST Number <span class="required">*</span></label>
                    <asp:TextBox ID="txtGSTNumber" runat="server" placeholder="Enter GST number"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvGSTNumber" runat="server" ControlToValidate="txtGSTNumber" 
                        ErrorMessage="GST number is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group full-width">
                    <label for="<%=txtBillingAddress.ClientID%>">Billing Address <span class="required">*</span></label>
                    <asp:TextBox ID="txtBillingAddress" runat="server" TextMode="MultiLine" placeholder="Enter billing address"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvBillingAddress" runat="server" ControlToValidate="txtBillingAddress" 
                        ErrorMessage="Billing address is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                </div>
            </div>

           <!-- Booth Requirements -->
            <div class="section-title"><i class="fas fa-warehouse"></i> Booth Requirements</div>

            <div class="form-group">
                <label>Preferred Booth Size / Area Required (in sq. m) <span class="required">*</span></label>
                <div class="booth-options">
                    <div class="booth-option" onclick="document.getElementById('<%=rbShellScheme.ClientID%>').click();">
                        <asp:RadioButton ID="rbShellScheme" runat="server" GroupName="BoothType" />
                        <div class="booth-option-content">
                            <div class="booth-option-title">Shell Scheme (with basic furniture, fascia, etc.)</div>
                            <div class="booth-option-desc">Minimum size: 12 Sqm</div>
                        </div>
                    </div>
                    <div class="booth-option" onclick="document.getElementById('<%=rbRawSpace.ClientID%>').click();">
                        <asp:RadioButton ID="rbRawSpace" runat="server" GroupName="BoothType" />
                        <div class="booth-option-content">
                            <div class="booth-option-title">Raw Space (for custom-built booth)</div>
                            <div class="booth-option-desc">Minimum size: 18 Sqm</div>
                        </div>
                    </div>
                </div>
            </div>


            <div class="form-row">
                <div class="form-group">
                    <label for="<%=txtAreaInSqm.ClientID%>">Area in Sqm <span class="required">*</span></label>
                    <asp:TextBox ID="txtAreaInSqm" runat="server" TextMode="Number" placeholder="Enter area in square meters"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvAreaInSqm" runat="server" ControlToValidate="txtAreaInSqm" 
                        ErrorMessage="Area is required" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="rvAreaInSqm" runat="server" ControlToValidate="txtAreaInSqm" 
                        Type="Double" MinimumValue="1" MaximumValue="10000" 
                        ErrorMessage="Please enter a valid area" ForeColor="Red" Display="Dynamic" ValidationGroup="RegistrationValidation"></asp:RangeValidator>
                </div>
            </div>

            <!-- Additional Interests -->
            <div class="section-title"><i class="fas fa-star"></i> Additional Interests</div>

            <div class="form-group">
                <label>Would you be interested in any of the following? (tick if interested)</label>
                <div class="checkbox-group">
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkConference" runat="server" />
                        <label for="<%=chkConference.ClientID%>">Conference Speaking Slot</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkSponsorship" runat="server" />
                        <label for="<%=chkSponsorship.ClientID%>">Sponsor Opportunities</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkAdvertising" runat="server" />
                        <label for="<%=chkAdvertising.ClientID%>">Advertising in Show Directory</label>
                    </div>
                    <div class="checkbox-item">
                        <asp:CheckBox ID="chkCustomPackage" runat="server" />
                        <label for="<%=chkCustomPackage.ClientID%>">Custom Packages – Please Contact Me</label>
                    </div>
                </div>
            </div>

            <!-- Declaration -->
            <div class="declaration-box">
                <h3><i class="fas fa-file-signature"></i> Declaration</h3>
                <p class="declaration-text">
                    I hereby confirm that the above information is accurate to the best of my knowledge and express my interest in exhibiting at Lubricant India Expo & Summit 2026. 
                    I understand that this form does not confirm booth allocation and the organizers will follow up with the exhibitor package and formal agreement.
                </p>
                <div class="checkbox-item">
                    <asp:CheckBox ID="chkDeclaration" runat="server" />
                    <label for="<%=chkDeclaration.ClientID%>"><strong>I agree to the above declaration <span class="required">*</span></strong></label>
                </div>
            </div>

            <div class="form-footer">
                <a href="Default.aspx" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to Home
                </a>
                <asp:Button ID="btnRegister" runat="server" Text="Submit Registration" CssClass="btn btn-primary" 
                    OnClick="btnRegister_Click" ValidationGroup="RegistrationValidation" />
            </div>

        </div>
    </form>
</body>
</html>
