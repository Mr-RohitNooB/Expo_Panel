<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PostSpeakerRegistration.aspx.cs" Inherits="Expo_Panel.PostSpeakerRegistration" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Complete Your Speaker Profile - Expo Panel</title>
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

        .header .logout-btn {
            position: absolute;
            top: 40px;
            right: 40px;
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
        .form-group textarea:focus {
            outline: none;
            border-color: #48bb78;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 120px;
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

        .agenda-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .agenda-card {
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            padding: 15px;
            background: #f8fafc;
            transition: all 0.3s;
            cursor: pointer;
            position: relative;
        }

        .agenda-card:hover {
            border-color: #48bb78;
            box-shadow: 0 4px 12px rgba(72, 187, 120, 0.2);
        }

        .agenda-card.selected {
            border-color: #38a169;
            background: #f0fdf4;
        }

        .agenda-checkbox {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 24px;
            height: 24px;
            cursor: pointer;
        }

        .agenda-day {
            color: #38a169;
            font-weight: 600;
            font-size: 13px;
            margin-bottom: 8px;
        }

        .agenda-title {
            font-size: 15px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 8px;
            padding-right: 30px;
        }

        .agenda-meta {
            display: flex;
            flex-direction: column;
            gap: 5px;
            font-size: 12px;
            color: #64748b;
        }

        .agenda-meta span {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .agenda-meta i {
            width: 16px;
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

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
        }

        .form-footer {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e2e8f0;
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

        .alert-info {
            background: #dbeafe;
            color: #1e40af;
            border: 1px solid #bfdbfe;
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

        .char-counter {
            font-size: 12px;
            color: #64748b;
            text-align: right;
            margin-top: 5px;
        }

        @media (max-width: 768px) {
            .registration-container {
                padding: 25px;
            }

            .header h1 {
                font-size: 24px;
            }

            .header .logout-btn {
                position: static;
                margin-top: 15px;
            }

            .agenda-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="registration-container">
            <div class="header">
                <div class="logout-btn">
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-danger" OnClick="btnLogout_Click" />
                </div>
                <h1><i class="fas fa-user-check"></i> Complete Your Speaker Profile</h1>
                <p>Welcome, <asp:Label ID="lblSpeakerName" runat="server"></asp:Label></p>
            </div>

            <asp:Literal ID="litMessage" runat="server" EnableViewState="false"></asp:Literal>

            <!-- Section 1: Profile Information -->
            <div class="form-section">
                <h3><i class="fas fa-id-card"></i> Profile Information</h3>

                <div class="form-group">
                    <label for="fuPhoto">Upload Your Photo <span class="required">*</span></label>
                    <p class="info-text">Please upload a professional headshot (JPG, PNG - Max 2MB)</p>
                    <div class="file-upload-wrapper">
                        <asp:FileUpload ID="fuPhoto" runat="server" CssClass="file-upload-input" 
                            accept="image/jpeg,image/png,image/jpg" onchange="displayFileName(this, 'photoFileName')" />
                        <label for="<%=fuPhoto.ClientID%>" class="file-upload-label">
                            <i class="fas fa-cloud-upload-alt"></i>
                            <span>Choose Photo</span>
                        </label>
                    </div>
                    <div id="photoFileName" class="file-name"></div>
                    <asp:RequiredFieldValidator ID="rfvPhoto" runat="server" ControlToValidate="fuPhoto"
                        ErrorMessage="Photo is required" ForeColor="Red" Display="Dynamic" 
                        ValidationGroup="ProfileValidation"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtLinkedIn.ClientID%>">LinkedIn Profile URL <span class="required">*</span></label>
                    <asp:TextBox ID="txtLinkedIn" runat="server" placeholder="https://linkedin.com/in/yourprofile"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvLinkedIn" runat="server" ControlToValidate="txtLinkedIn"
                        ErrorMessage="LinkedIn profile is required" ForeColor="Red" Display="Dynamic" 
                        ValidationGroup="ProfileValidation"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revLinkedIn" runat="server" ControlToValidate="txtLinkedIn"
                        ErrorMessage="Please enter a valid LinkedIn URL" ForeColor="Red" Display="Dynamic"
                        ValidationExpression="^https?://(www\.)?linkedin\.com/.*$" 
                        ValidationGroup="ProfileValidation"></asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <label for="<%=txtBio.ClientID%>">Professional Bio</label>
                    <p class="info-text">Brief description about your professional background and expertise (optional)</p>
                    <asp:TextBox ID="txtBio" runat="server" TextMode="MultiLine" Rows="5"
                        placeholder="Share your professional journey, key achievements, and areas of expertise..."></asp:TextBox>
                    <div id="bioCharCount" class="char-counter">0 characters</div>
                </div>
            </div>

            <!-- Section 2: Select Agenda Topics -->
            <div class="form-section">
                <h3><i class="fas fa-calendar-check"></i> Select Topics You'd Like to Speak On</h3>
                
                <div class="selection-counter">
                    <i class="fas fa-info-circle"></i>
                    <span>You can select up to 3 topics. Currently selected: <strong><span id="selectedCount">0</span>/3</strong></span>
                </div>

                <asp:Panel ID="pnlAgendaGrid" runat="server">
                    <!-- Agenda cards will be populated here -->
                </asp:Panel>

                <asp:HiddenField ID="hdnSelectedAgendas" runat="server" />
                <asp:CustomValidator ID="cvAgendaSelection" runat="server"
                    ErrorMessage="Please select at least 1 topic (maximum 3)" ForeColor="Red" Display="Dynamic"
                    ClientValidationFunction="validateAgendaSelection" 
                    OnServerValidate="cvAgendaSelection_ServerValidate"
                    ValidationGroup="ProfileValidation"></asp:CustomValidator>
            </div>

            <div class="form-footer">
                <asp:Button ID="btnSubmit" runat="server" Text="Submit Profile" CssClass="btn btn-primary"
                    OnClick="btnSubmit_Click" ValidationGroup="ProfileValidation" 
                    OnClientClick="return collectSelectedAgendas();" />
            </div>
        </div>

        <script type="text/javascript">
            function displayFileName(input, displayId) {
                var display = document.getElementById(displayId);
                if (input.files && input.files[0]) {
                    var fileName = input.files[0].name;
                    var fileSize = (input.files[0].size / 1024 / 1024).toFixed(2);
                    display.innerHTML = '<i class="fas fa-check-circle"></i> ' + fileName + ' (' + fileSize + ' MB)';
                } else {
                    display.innerHTML = '';
                }
            }

            function updateCharCount() {
                var textarea = document.getElementById('<%=txtBio.ClientID%>');
                var counter = document.getElementById('bioCharCount');
                if (textarea && counter) {
                    counter.textContent = textarea.value.length + ' characters';
                }
            }

            function toggleAgendaSelection(checkbox, agendaId) {
                var card = checkbox.closest('.agenda-card');
                var selectedCount = document.querySelectorAll('.agenda-card input[type="checkbox"]:checked').length;
                
                if (checkbox.checked) {
                    if (selectedCount > 3) {
                        checkbox.checked = false;
                        alert('You can only select up to 3 topics.');
                        return false;
                    }
                    card.classList.add('selected');
                } else {
                    card.classList.remove('selected');
                }
                
                updateSelectedCount();
            }

            function updateSelectedCount() {
                var selectedCount = document.querySelectorAll('.agenda-card input[type="checkbox"]:checked').length;
                document.getElementById('selectedCount').textContent = selectedCount;
            }

            function collectSelectedAgendas() {
                var checkboxes = document.querySelectorAll('.agenda-card input[type="checkbox"]:checked');
                var selectedIds = [];
                
                checkboxes.forEach(function(cb) {
                    selectedIds.push(cb.value);
                });
                
                document.getElementById('<%=hdnSelectedAgendas.ClientID%>').value = selectedIds.join(',');
                return true;
            }

            function validateAgendaSelection(sender, args) {
                var checkboxes = document.querySelectorAll('.agenda-card input[type="checkbox"]:checked');
                var count = checkboxes.length;
                args.IsValid = (count >= 1 && count <= 3);
            }

            window.onload = function() {
                updateCharCount();
                updateSelectedCount();
                
                var bioTextarea = document.getElementById('<%=txtBio.ClientID%>');
                if (bioTextarea) {
                    bioTextarea.addEventListener('input', updateCharCount);
                }
            };
        </script>
    </form>
</body>
</html>