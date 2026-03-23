<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="ManageSubAgent.aspx.cs" Inherits="AgentSite4.Report.ManageSubAgent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="/assets/src/plugins/src/filepond/filepond.min.css">
    <link rel="stylesheet" href="/assets/src/plugins/src/filepond/FilePondPluginImagePreview.min.css">
    <link href="/assets/src/plugins/src/notification/snackbar/snackbar.min.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="/assets/src/plugins/src/sweetalerts2/sweetalerts2.css">

    <link href="/assets/src/plugins/css/light/filepond/custom-filepond.css" rel="stylesheet" type="text/css" />
    <link href="/assets/src/assets/css/light/components/tabs.css?v2" rel="stylesheet" type="text/css">
    <link rel="stylesheet" type="text/css" href="/assets/src/assets/css/light/elements/alert.css">

    <link href="/assets/src/plugins/css/light/sweetalerts2/custom-sweetalert.css" rel="stylesheet" type="text/css" />
    <link href="/assets/src/plugins/css/light/notification/snackbar/custom-snackbar.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="/assets/src/assets/css/light/forms/switches.css?v1">
    <link href="/assets/src/assets/css/light/components/list-group.css" rel="stylesheet" type="text/css">

    <link href="/assets/src/assets/css/light/users/account-setting.css?v7" rel="stylesheet" type="text/css" />



    <link href="/assets/src/plugins/css/dark/filepond/custom-filepond.css" rel="stylesheet" type="text/css" />
    <link href="/assets/src/assets/css/dark/components/tabs.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" type="text/css" href="/assets/src/assets/css/dark/elements/alert.css">

    <link href="/assets/src/plugins/css/dark/sweetalerts2/custom-sweetalert.css" rel="stylesheet" type="text/css" />
    <link href="/assets/src/plugins/css/dark/notification/snackbar/custom-snackbar.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="/assets/src/assets/css/dark/forms/switches.css">
    <link href="/assets/src/assets/css/dark/components/list-group.css" rel="stylesheet" type="text/css">

    <link href="/assets/src/assets/css/dark/users/account-setting.css?v1" rel="stylesheet" type="text/css" />
    <style>
        .account-settings-container a i {
            margin-right: 8px;
        }

        .btn-checkbox input[type="checkbox"] {
            display: none;
        }

        .btn-checkbox.active span {
            color: #fff;
        }

        .btn-checkbox span {
            margin-left: 5px;
        }

        .btn-check {
            position: absolute;
            clip: rect(0,0,0,0);
            pointer-events: none;
        }

            .btn-check label {
                transition: background-color 0.3s ease, color 0.3s ease;
            }
    </style>

    <script>
        $('.iModal').on('click', function (e) {
            e.preventDefault();
            var url = $(this).attr('href');
            $(".modal-body").html('<iframe id="wb-frame" class="wbframe" frameborder="0" scrolling="auto" allowtransparency="true" src="' + url + '"  onload="resizeIframe(this)"></iframe>');
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="account-settings-container layout-top-spacing">

        <div class="account-content mb-3">
            <div class="row mb-3">
                <div class="col-md-12">
                    <h2>Agent Profile:&nbsp;
                        <asp:Label ID="lblAgent" runat="server" CssClass="subtitle"></asp:Label></h2>

                    <ul class="nav nav-pills" id="animateLine" role="tablist">
                        <li class="nav-item" role="presentation">
                            <a class="nav-link active" id="basics" data-bs-toggle="tab" href="#pnBasic" role="tab" aria-controls="animated-underline-home" aria-selected="true">
                                <i class="fa-duotone fa-user-gear"></i><span>Basics</span></a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link" id="transactions" data-bs-toggle="tab" href="#pnTransactions" role="tab" aria-controls="animated-underline-profile" aria-selected="false" tabindex="-1">
                                <i class="fa-duotone fa-money-bill-transfer"></i>Transactions</a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link" id="Permission" data-bs-toggle="tab" href="#pnPermission" role="tab" aria-controls="animated-underline-preferences" aria-selected="false" tabindex="-1">
                                <i class="fa-duotone fa-list-check"></i>Permission</a>
                        </li>
                        <%--<li class="nav-item" role="presentation">
                            <a class="nav-link" id="offerings" data-bs-toggle="tab" href="#pnofferings" role="tab" aria-controls="animated-underline-home" aria-selected="true" tabindex="-1">
                                <i class="fa-duotone fa-sliders"></i>Offerings</a>
                        </li>--%>
                        <%--<li class="nav-item" role="presentation">
                            <a class="nav-link" id="FreePlay" data-bs-toggle="tab" href="#pnFreePlay" role="tab" aria-controls="animated-underline-contact" aria-selected="false" tabindex="-1">
                                <i class="fa-duotone fa-hand-holding-heart"></i>Free Play</a>
                        </li>--%>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link" id="dynamicLive" data-bs-toggle="tab" href="#pndynamicLive" role="tab" aria-controls="dynamicLive-tab" aria-selected="false" tabindex="-1">
                                <i class="fa-duotone fa-screencast"></i>Player Limits</a>
                        </li>

                        <li class="nav-item" role="presentation">
                            <a class="nav-link" id="vigSetUp" data-bs-toggle="tab" href="#pnvigSetUp" role="tab" aria-controls="animated-underline-contact" aria-selected="false" tabindex="-1">
                                <i class="fa-duotone fa-cards"></i>Others Limits</a>
                        </li>
                        
                    </ul>
                </div>
            </div>

            <div class="tab-content" id="animateLineContent-4">
                <div class="tab-pane fade show active" id="pnBasic" role="tabpanel" aria-labelledby="animated-underline-home-tab">
                    <div class="row">
                        <div class="col-xl-12 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Profile Info</h6>
                                    <div class="row">
                                        <div class="row">

                                            <div class="form-horizontal">
                                                <div class="row mb-1">
                                                    <div class="col-lg-1 col-sm-6">
                                                        <asp:Label ID="Label14" runat="server" Text="Name:" CssClass="text-right control-label col-form-label"></asp:Label>
                                                    </div>
                                                    <div class="col-lg-6 col-sm-6">
                                                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>

                                                    </div>
                                                    <div class="col-lg-4 d-none d-lg-block"></div>
                                                </div>
                                                <div class="row mb-1">
                                                    <div class="col-lg-1 col-sm-6">
                                                        <asp:Label ID="Label1" runat="server" Text="Adress:" CssClass="text-right control-label col-form-label"></asp:Label>
                                                    </div>
                                                    <div class="col-lg-10 col-sm-6">
                                                        <asp:TextBox ID="txtAdresLine1" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>

                                                    </div>

                                                </div>
                                                <div class="row mb-3">
                                                    <div class="col-lg-1 col-sm-6">
                                                    </div>
                                                    <div class="col-lg-10 col-sm-6">
                                                        <asp:TextBox ID="txtAdressLine2" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>

                                                    </div>
                                                </div>

                                                <div class="row mb-1">
                                                    <div class="col-lg-6 col-sm-12">
                                                        <div class="row">
                                                            <div class="col-2">
                                                                <asp:Label ID="Label2" runat="server" Text="City:" CssClass="text-right control-label col-form-label"></asp:Label>
                                                            </div>
                                                            <div class="col-6">
                                                                <asp:TextBox ID="txtCity" runat="server" class="form-control form-control-sm"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-6 col-sm-12">
                                                        <div class="row">
                                                            <div class="col-2">
                                                                <asp:Label ID="lblState" runat="server" Text="State:" CssClass="text-right control-label col-form-label"></asp:Label>
                                                            </div>
                                                            <div class="col-6">
                                                                <asp:TextBox ID="txtState" runat="server" class="form-control form-control-sm"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row mb-1">
                                                    <div class="col-lg-6 col-sm-12">
                                                        <div class="row">
                                                            <div class="col-2">
                                                                <asp:Label ID="Label9" runat="server" Text="Fax:" CssClass="text-right control-label col-form-label"></asp:Label>
                                                            </div>
                                                            <div class="col-6">
                                                                <asp:TextBox ID="txtFax" runat="server" class="form-control form-control-sm"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-lg-6 col-sm-12">
                                                        <div class="row">
                                                            <div class="col-2">

                                                                <asp:Label ID="Label3" runat="server" Text="Country:" CssClass="text-right control-label col-form-label"></asp:Label>
                                                            </div>
                                                            <div class="col-6">
                                                                <asp:TextBox ID="txtCountry" runat="server" class="form-control form-control-sm"></asp:TextBox>
                                                            </div>

                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row mb-1">
                                                    <div class="col-lg-6 col-sm-12">
                                                        <div class="row">
                                                            <div class="col-2">
                                                                <asp:Label ID="lblPhone" runat="server" Text="Phone:" CssClass="text-right control-label col-form-label"></asp:Label>
                                                            </div>
                                                            <div class="col-6">
                                                                <asp:TextBox ID="txtPhone" runat="server" class="form-control form-control-sm"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-6 col-sm-12">
                                                        <div class="row">
                                                            <div class="col-2">
                                                                <asp:Label ID="Label4" runat="server" Text="E-Mail:" CssClass="text-right control-label col-form-label"></asp:Label>
                                                            </div>
                                                            <div class="col-6">
                                                                <asp:TextBox ID="txtEmail" runat="server" class="form-control form-control-sm"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="row mb-1">
                                                    <div class="col-lg-4 col-md-3 col"></div>
                                                    <div class="col-lg-4 col-md-6" style="text-align: center;">
                                                    </div>
                                                    <div class="col-lg-4 col-md-3"></div>
                                                </div>
                                                <br />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="pnTransactions" role="tabpanel" aria-labelledby="animated-underline-profile-tab">
                    <div class="row">
                        <div class="col-xl-12 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <div class="row">
                                        <div class="col-lg-12 mx-auto">
                                            <asp:PlaceHolder ID="phAgentHistory" runat="server" />

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="tab-pane fade" id="pnPermission" role="tabpanel" aria-labelledby="animated-underline-preferences-tab">
                    <div class="row">
                        <div class="col-xl-12 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Agent Profile Management:</h6>
                                    <div class="row">
                                        <div class="col-lg-11 mx-auto">
                                            <div class="row">
                                                <asp:Panel ID="pnCheckBox" runat="server">
                                                    <div class="row">
                                                        <div class="col-lg-12 col-md-12 col-sm-12">
                                                            <asp:CheckBox ID="chkCheckAll" runat="server" AutoPostBack="True" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small"
                                                                OnCheckedChanged="chkCheckAll_CheckedChanged" Text="Check All" />
                                                        </div>

                                                        <div class="agent__panel">
                                                            <div class="col-lg-12 col-md-12 col-sm-12 trAgent" style="background-color: #353852; color: #ffffff; padding: .3rem; text-align: center; margin-bottom: 10px;">
                                                                Agent
                                                            </div>
                                                            <asp:Panel ID="pnAgentCheckBoxes" runat="server" CssClass="row"></asp:Panel>

                                                            <div class="col-lg-12 col-md-12 col-sm-12 trAgent" style="background-color: #353852; color: #ffffff; padding: .3rem; text-align: center; margin-bottom: 10px;">
                                                                Agent Report
                                                            </div>
                                                            <asp:Panel ID="pnAgentReportCheckBoxes" runat="server" CssClass="row"></asp:Panel>
                                                        </div>
                                                    </div>
                                                </asp:Panel>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="pnofferings" role="tabpanel" aria-labelledby="pnofferings-tab">
                    <div class="row">

                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Straights</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Parlays</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Round Robins</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Teasers</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">If-Bets</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Horses</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>



                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Casino</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Live Betting</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Live Casino</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>



                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Prop Builder</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Squares</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Fantasy</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Crash</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Mines</h6>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="publicProfile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%-- <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Example of Rights</h6>
                                    <p>Enable your <span class="text-success">right</span> for a description</p>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-secondary mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="socialprofile" checked>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>--%>
                    </div>

                </div>

                <div class="tab-pane fade" id="pnFreePlay" role="tabpanel" aria-labelledby="animated-underline-contact-tab">
                    <div class="alert alert-arrow-right alert-icon-right alert-light-warning alert-dismissible fade show mb-4" role="alert">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle">
                            <circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12" y2="16"></line></svg>
                        <strong>Warning!</strong> Please proceed with caution. For any assistance - <a href="javascript:void(0);">Contact Us</a>
                    </div>

                    <div class="row">
                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Purge Cache</h6>
                                    <p>Remove the active resource from the cache without waiting for the predetermined cache expiry time.</p>
                                    <div class="form-group mt-4">
                                        <button class="btn btn-secondary btn-clear-purge">Clear</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Deactivate Account</h6>
                                    <p>You will not be able to receive messages, notifications for up to 24 hours.</p>
                                    <div class="form-group mt-4">
                                        <div class="switch form-switch-custom switch-inline form-switch-success mt-1">
                                            <input class="switch-input" type="checkbox" role="switch" id="socialformprofile-custom-switch-success">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-4 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Delete Account</h6>
                                    <p>Once you delete the account, there is no going back. Please be certain.</p>
                                    <div class="form-group mt-4">
                                        <button class="btn btn-danger btn-delete-account">Delete my account</button>
                                    </div>
                                </div>
                            </div>
                        </div>


                    </div>
                </div>

                <div class="tab-pane fade" id="pndynamicLive" role="tabpanel" aria-labelledby="dynamicLive-tab">
                    <div class="row">
                        <div class="col-xl-12 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info payment-info">
                                <div class="info">
                                    <h6 class="">Player Limits</h6>
                                    <div class="row mb-3">
                                        <label for="creditLimitMin" class="col-sm-3 col-form-label">Credit Limit</label>
                                        <div class="col-sm-3">
                                            <asp:TextBox ID="creditLimitMin" runat="server" CssClass="form-control" Placeholder="Min"></asp:TextBox>
                                        </div>
                                        <div class="col-sm-3">
                                            <asp:TextBox ID="creditLimitMax" runat="server" CssClass="form-control" Placeholder="Max"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <label for="parlayLimitMin" class="col-sm-3 col-form-label">Parlay Limit</label>
                                        <div class="col-sm-3">
                                            <asp:TextBox ID="parlayLimitMin" runat="server" CssClass="form-control" Placeholder="Min"></asp:TextBox>
                                        </div>
                                        <div class="col-sm-3">
                                            <asp:TextBox ID="parlayLimitMax" runat="server" CssClass="form-control" Placeholder="Max"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <label for="contestLimitMin" class="col-sm-3 col-form-label">Contest Limit</label>
                                        <div class="col-sm-3">
                                            <asp:TextBox ID="contestLimitMin" runat="server" CssClass="form-control" Placeholder="Min"></asp:TextBox>
                                        </div>
                                        <div class="col-sm-3">
                                            <asp:TextBox ID="contestLimitMax" runat="server" CssClass="form-control" Placeholder="Max"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <label for="wagerLimitMin" class="col-sm-3 col-form-label">Wager Limit</label>
                                        <div class="col-sm-3">
                                            <asp:TextBox ID="wagerLimitMin" runat="server" CssClass="form-control" Placeholder="Min"></asp:TextBox>
                                        </div>
                                        <div class="col-sm-3">
                                            <asp:TextBox ID="wagerLimitMax" runat="server" CssClass="form-control" Placeholder="Max"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <label for="teaserLimitMin" class="col-sm-3 col-form-label">Teaser Limit</label>
                                        <div class="col-sm-3">
                                            <asp:TextBox ID="teaserLimitMin" runat="server" CssClass="form-control" Placeholder="Min"></asp:TextBox>
                                        </div>
                                        <div class="col-sm-3">
                                            <asp:TextBox ID="teaserLimitMax" runat="server" CssClass="form-control" Placeholder="Max"></asp:TextBox>
                                        </div>
                                    </div>
                                   
                                    <div class="row mb-3">
                                        <label for="freePlayWeeklyMaxMin" class="col-sm-3 col-form-label">Free Play Weekly Max</label>
                                        <div class="col-sm-3">
                                            <asp:TextBox ID="txtFreePlayLimit" runat="server" CssClass="form-control" Placeholder="Max"></asp:TextBox>
                                            
                                        </div>
                                        <div class="col-sm-3">
                                            <asp:Literal ID="litRuleCreatedIcon" runat="server"></asp:Literal>
                                            </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>


                <div class="tab-pane fade" id="pnvigSetUp" role="tabpanel" aria-labelledby="animated-underline-home-tab">
                    <div class="row">
                        <div class="col-xl-12 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <div class="info">
                                        <div class="info">
                                            <h6 class="">Live Casino Limits</h6>
                                            <div class="row">
                                                <div class="col-lg-11 mx-auto">
                                                    <div class="row mb-3">
                                                        <label for="txtAllDailyMaxLoss" class="col-sm-2 col-form-label"></label>
                                                        <div class="col-sm-2">
                                                            <asp:TextBox ID="txtAllDailyMaxLoss" runat="server" CssClass="form-control form-control-sm" Placeholder="Daily Max Loss"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="revDailyMaxLoss" runat="server" ControlToValidate="txtAllDailyMaxLoss" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                                        </div>

                                                        <div class="col-sm-2">
                                                            <asp:TextBox ID="txtAllDailyMaxWin" runat="server" CssClass="form-control form-control-sm" Placeholder="Daily Max Win"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtAllDailyMaxWin" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                                        </div>

                                                        <div class="col-sm-2">
                                                            <asp:TextBox ID="txtAllWeeklyMaxLoss" runat="server" CssClass="form-control form-control-sm" Placeholder="Weekly Max Loss"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtAllWeeklyMaxLoss" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                                        </div>

                                                        <div class="col-sm-2">
                                                            <asp:TextBox ID="txtAllWeeklyMaxWin" runat="server" CssClass="form-control form-control-sm" Placeholder="Weekly Max Win"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtAllWeeklyMaxWin" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                                        </div>


                                                    </div>
                                                </div>
                                            </div>
                                            <h6 class="">CRASH Limits</h6>
                                            <div class="row">
                                                <div class="col-lg-11 mx-auto">
                                                    <div class="row mb-3">
                                                        <label for="txtAllDailyMaxLoss" class="col-sm-2 col-form-label"></label>
                                                        <div class="col-sm-2">
                                                            <asp:TextBox ID="txtCrashDailyLoss" runat="server" CssClass="form-control form-control-sm" Placeholder="Daily Max Loss"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="txtCrashDailyLoss" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                                        </div>

                                                        <div class="col-sm-2">
                                                            <asp:TextBox ID="txtCrashDailyWin" runat="server" CssClass="form-control form-control-sm" Placeholder="Daily Max Win"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" ControlToValidate="txtCrashDailyWin" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                                        </div>

                                                        <div class="col-sm-2">
                                                            <asp:TextBox ID="txtCrashWeeklyLoss" runat="server" CssClass="form-control form-control-sm" Placeholder="Weekly Max Loss"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server" ControlToValidate="txtCrashWeeklyLoss" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                                        </div>

                                                        <div class="col-sm-2">
                                                            <asp:TextBox ID="txtCrashWeeklyWin" runat="server" CssClass="form-control form-control-sm" Placeholder="Weekly Max Win"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator7" runat="server" ControlToValidate="txtCrashWeeklyWin" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                                        </div>


                                                    </div>
                                                </div>
                                            </div>
                                            <h6 class="">Mines Limits</h6>
                                            <div class="row">
                                                <div class="col-lg-11 mx-auto">
                                                    <div class="row mb-3">
                                                        <label for="txtAllDailyMaxLoss" class="col-sm-2 col-form-label"></label>
                                                        <div class="col-sm-2">
                                                            <asp:TextBox ID="txtMinesDailyLoss" runat="server" CssClass="form-control form-control-sm" Placeholder="Daily Max Loss"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator8" runat="server" ControlToValidate="txtMinesDailyLoss" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                                        </div>

                                                        <div class="col-sm-2">
                                                            <asp:TextBox ID="txtMinesDailyWin" runat="server" CssClass="form-control form-control-sm" Placeholder="Daily Max Win"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator9" runat="server" ControlToValidate="txtMinesDailyWin" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                                        </div>

                                                        <div class="col-sm-2">
                                                            <asp:TextBox ID="txtMinesWeeklyLoss" runat="server" CssClass="form-control form-control-sm" Placeholder="Weekly Max Loss"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server" ControlToValidate="txtMinesWeeklyLoss" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                                        </div>

                                                        <div class="col-sm-2">
                                                            <asp:TextBox ID="txtMinesWeeklyWin" runat="server" CssClass="form-control form-control-sm" Placeholder="Weekly Max Win"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator11" runat="server" ControlToValidate="txtMinesWeeklyWin" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                                        </div>


                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>


                <%--    <div class="tab-pane fade" id="pncasinoSetUp" role="tabpanel" aria-labelledby="animated-underline-home-tab">
                    <div class="row">
                        <div class="col-xl-12 col-lg-12 col-md-12 layout-spacing">
                            <div class="section general-info">
                                <div class="info">
                                    <h6 class="">Live Casino Limits</h6>
                                    <div class="row">
                                        <div class="col-lg-11 mx-auto">
                                           <div class="row mb-3">
                                            <label for="txtAllDailyMaxLoss" class="col-sm-2 col-form-label">Apply All</label>
                                            <div class="col-sm-2">
                                                <asp:TextBox ID="txtAllDailyMaxLoss" runat="server" CssClass="form-control form-control-sm" Placeholder="Daily Max Loss"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="revDailyMaxLoss" runat="server" ControlToValidate="txtAllDailyMaxLoss" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                            </div>
                                            
                                            <div class="col-sm-2">
                                                <asp:TextBox ID="txtAllDailyMaxWin" runat="server" CssClass="form-control form-control-sm" Placeholder="Daily Max Win"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtAllDailyMaxWin" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                            </div>
                                            
                                            <div class="col-sm-2">
                                                <asp:TextBox ID="txtAllWeeklyMaxLoss" runat="server" CssClass="form-control form-control-sm" Placeholder="Weekly Max Loss"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtAllWeeklyMaxLoss" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                            </div>
                                            
                                            <div class="col-sm-2">
                                                <asp:TextBox ID="txtAllWeeklyMaxWin" runat="server" CssClass="form-control form-control-sm" Placeholder="Weekly Max Win"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtAllWeeklyMaxWin" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                            </div>
                                            
                                            
                                        </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                --%>
            </div>

        </div>

        <div class="row">

            <div class="col-12">
                <center>
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel"
                        OnClick="btnCancel_Click" CssClass="btn btn-warnig btn-inverse" />
                    &nbsp;<asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save"
                        CssClass="btn btn-success" /></center>
                <br />
            </div>
        </div>
    </div>

    <div class="dgsContent" style="display: none">





        <div class="col-lg-6">
            <div class="card">
                <div class="card-body">
                    <h3 class="box-title m-b-0">Settings
                    </h3>
                    <div class="form-horizontal">
                        <div class="form-group row">
                            <div class="col-lg-4 col-sm-6">
                                <asp:Label ID="Label5" runat="server" Text="Online Message:" CssClass="text-right control-label col-form-label"></asp:Label>
                            </div>
                            <div class="col-lg-6 col-sm-6">
                                <asp:TextBox ID="txtOnlineMessage" runat="server" class="form-control form-control-sm"></asp:TextBox>
                            </div>
                            <div class="col-lg-2 d-none d-lg-block"></div>
                        </div>
                        <div class="form-group row">
                            <div class="col-lg-4 col-sm-6">

                                <asp:Label ID="Label6" runat="server" Text="Password" CssClass="text-right control-label col-form-label"></asp:Label>
                            </div>
                            <div class="col-lg-6 col-sm-6">
                                <asp:TextBox ID="txtPassword" runat="server" class="form-control form-control-sm"></asp:TextBox>
                            </div>

                            <div class="col-lg-2 d-none d-lg-block"></div>

                        </div>
                        <div class="form-group row">
                            <div class="col-lg-4 col-sm-6">

                                <asp:Label ID="Label11" runat="server" Text="Commission" CssClass="text-right control-label col-form-label"></asp:Label>
                            </div>
                            <div class="col-lg-6 col-sm-6">
                                <asp:TextBox ID="txtCommission" runat="server" class="form-control form-control-sm"></asp:TextBox>
                            </div>

                            <div class="col-lg-2 d-none d-lg-block"></div>

                        </div>
                        <div class="form-group row">
                            <div class="col-lg-4 col-sm-6">

                                <asp:Label ID="Label7" runat="server" Text="Master" CssClass="text-right control-label col-form-label"></asp:Label>
                            </div>
                            <div class="col-lg-6 col-sm-6">
                                <asp:DropDownList ID="ddlMasterAgent" runat="server" CssClass="form-control form-control-sm tomlist">
                                </asp:DropDownList>
                            </div>

                            <div class="col-lg-2 d-none d-lg-block"></div>

                        </div>

                        <div class="form-group row">
                            <div class="col-lg-6 col-sm-12">
                                <asp:CheckBox ID="chkEnable" runat="server" AutoPostBack="True" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small"
                                    Text="Enable" />
                            </div>
                            <div class="col-lg-6 col-sm-12">
                                <asp:CheckBox ID="chkOnlineAccess" runat="server" AutoPostBack="True" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small"
                                    Text="Online Access" />
                            </div>
                            <div class="col-lg-6 col-sm-12">
                                <asp:CheckBox ID="chkDistributor" runat="server" AutoPostBack="True" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small"
                                    OnCheckedChanged="chkDistributor_CheckedChanged" Text="Is Distributor" />
                            </div>
                            <div class="col-lg-6 col-sm-12">
                                <asp:CheckBox ID="chkDontXFer" runat="server" AutoPostBack="True" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small"
                                    OnCheckedChanged="chkDistributor_CheckedChanged" Text="Don't Xfer Player Activity" />
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <asp:Panel ID="pnMove" runat="server" CssClass="col-lg-12" Visible="False">

            <div class="card" style="min-height: 188px;">
                <div class="card-body">
                    <h3 class="box-title m-b-0">Move Players
                    </h3>
                    <div class="form-horizontal">
                        <div class="form-group row">
                            <div class="col-lg-2 col-sm-6">
                                <asp:Label ID="Label8" runat="server" Text="Agent From" CssClass="text-right control-label col-form-label"></asp:Label>
                            </div>
                            <div class="col-lg-4 col-sm-6">
                                <asp:Label ID="lblCurrentAgent" runat="server" CssClass="subtitle"></asp:Label>
                            </div>

                        </div>
                        <div class="form-group row">
                            <div class="col-lg-2 col-sm-6">

                                <asp:Label ID="Label10" runat="server" Text="Agent To" CssClass="text-right control-label col-form-label"></asp:Label>
                            </div>
                            <div class="col-lg-4 col-sm-6">
                                <asp:DropDownList ID="ddlAgentTo" runat="server" CssClass="form-control form-control-sm tomlist" OnSelectedIndexChanged="ddlAgentTo_SelectedIndexChanged" AutoPostBack="True">
                                </asp:DropDownList>
                            </div>



                        </div>
                        <div class="form-group row">
                            <div class="col-lg-3 d-none d-lg-block"></div>
                            <div class="col-lg-6 col-sm-12">
                                <center>
                                    <asp:Button ID="btnMovePlayers" runat="server" OnClick="btnMovePlayers_Click" Text="Move Players" CssClass="btn btn-danger" Enabled="False" />
                                </center>
                            </div>

                            <div class="col-lg-3 d-none d-lg-block"></div>

                        </div>
                    </div>

                </div>
            </div>

        </asp:Panel>

        <asp:Panel ID="pnMoveAgents" runat="server" CssClass="col-lg-12" Visible="False">

            <div class="card" style="min-height: 188px;">
                <div class="card-body">
                    <h3 class="box-title m-b-0">Move Agents
                    </h3>
                    <div class="form-horizontal">
                        <div class="form-group row">
                            <div class="col-lg-2 col-sm-6">
                                <asp:Label ID="labelX" runat="server" Text="Agent From" CssClass="text-right control-label col-form-label"></asp:Label>
                            </div>
                            <div class="col-lg-4 col-sm-6">
                                <asp:Label ID="lblCurrenMaster" runat="server" CssClass="subtitle"></asp:Label>
                            </div>

                        </div>
                        <div class="form-group row">
                            <div class="col-lg-2 col-sm-6">

                                <asp:Label ID="Label13" runat="server" Text="Agent To" CssClass="text-right control-label col-form-label"></asp:Label>
                            </div>
                            <div class="col-lg-4 col-sm-6">
                                <asp:DropDownList ID="ddlMasterTo" runat="server" CssClass="form-control form-control-sm tomlist" OnSelectedIndexChanged="ddlAgentTo_SelectedIndexChanged" AutoPostBack="True">
                                </asp:DropDownList>
                            </div>



                        </div>
                        <div class="form-group row">
                            <div class="col-lg-3 d-none d-lg-block"></div>
                            <div class="col-lg-6 col-sm-12">
                                <center>
                                    <asp:Button ID="btnMoveAgents" runat="server" OnClick="btnMoveAgents_Click" Text="Move Agents" CssClass="btn btn-danger" Enabled="False" />
                                </center>
                            </div>

                            <div class="col-lg-3 d-none d-lg-block"></div>

                        </div>
                    </div>

                </div>
            </div>
        </asp:Panel>



    </div>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"></asp:SqlDataSource>

    <script>
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        })
    </script>
    <asp:HiddenField ID="hfActiveTabIndex" runat="server" />

</asp:Content>
<asp:Content ContentPlaceHolderID="Footer" runat="server">
    <script src="/assets/src/plugins/src/filepond/filepond.min.js"></script>
    <script src="/assets/src/plugins/src/filepond/FilePondPluginFileValidateType.min.js"></script>
    <script src="/assets/src/plugins/src/filepond/FilePondPluginImageExifOrientation.min.js"></script>
    <script src="/assets/src/plugins/src/filepond/FilePondPluginImagePreview.min.js"></script>
    <script src="/assets/src/plugins/src/filepond/FilePondPluginImageCrop.min.js"></script>
    <script src="/assets/src/plugins/src/filepond/FilePondPluginImageResize.min.js"></script>
    <script src="/assets/src/plugins/src/filepond/FilePondPluginImageTransform.min.js"></script>
    <script src="/assets/src/plugins/src/filepond/filepondPluginFileValidateSize.min.js"></script>
    <script src="/assets/src/plugins/src/notification/snackbar/snackbar.min.js"></script>
    <script src="/assets/src/plugins/src/sweetalerts2/sweetalerts2.min.js"></script>
    <script src="/assets/src/assets/js/users/account-settings.js?v2"></script>

    <script>
        $(document).ready(function () {
            $('.btn-check').change(function () {
                $(this).parent().toggleClass('active', $(this).prop('checked'));
            });
            $('a[data-bs-toggle="tab"]').on('shown.bs.tab', function (e) {
                var activeTabIndex = $(e.target).parent().index();
                $('#<%= hfActiveTabIndex.ClientID %>').val(activeTabIndex);
            });

        });

        function addHashToAction() {
            var form = document.getElementById('btn_Submit').form;
            form.action = form.action.split('#')[0] + '#pnTransactions'; // Remove any existing hash and add the new one
            form.submit(); // Submit the form
        }

    </script>

</asp:Content>
