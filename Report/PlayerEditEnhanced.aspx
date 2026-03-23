<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerEditEnhanced.aspx.cs" Inherits="AgentSite4.Report.PlayerEditEnhanced" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="/src/assets/css/light/scrollspyNav.css" rel="stylesheet" type="text/css" />
    <link href="/src/assets/css/light/components/tabs.css" rel="stylesheet" type="text/css" />

    <link href="/src/assets/css/dark/scrollspyNav.css" rel="stylesheet" type="text/css" />
    <link href="/src/assets/css/dark/components/tabs.css" rel="stylesheet" type="text/css" />
    
    <link rel="stylesheet" type="text/css" href="/src/assets/css/light/forms/switches.css">

    <link rel="stylesheet" type="text/css" href="/src/assets/css/dark/forms/switches.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* === Figures centrados solo dentro de kb-widget-section === */
        .kb-widget-section .card {
            height: 100%;
        }

        /* si el card es link, que el <a> envuelva todo el bloque clickeable */
        .kb-widget-section a.text-decoration-none {
            display: block;
        }

        /* centro vertical + horizontal del contenido del card */
        .kb-widget-section .card-body {
            display: flex;
            flex-direction: column;
            align-items: center; /* horizontal */
            justify-content: center; /* vertical */
            text-align: center;
            min-height: 140px; /* ajusta si quieres más/menos alto */
            padding: 1.25rem;
        }

        /* icono */
        .kb-widget-section .card-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 48px;
            height: 48px;
            border-radius: 12px;
            margin-bottom: .5rem;
            line-height: 1;
        }

        /* título */
        .kb-widget-section .card-title {
            margin: 0 0 .25rem;
            font-weight: 600;
        }

        /* valor + badge centrados en la misma línea */
        .kb-widget-section .card-body .d-flex {
            justify-content: center !important; /* anula el inicio por defecto */
            gap: .5rem;
        }

        .kb-widget-section .h4.fw-bold.mb-0 {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            line-height: 1;
            white-space: nowrap;
        }

        @media (max-width: 576px) {
            .kb-widget-section .card-body {
                min-height: 120px;
            }
        }


.form-check-label{ margin-left:.35rem; }
    </style>

    <div class="dgsContent">


        <asp:Panel ID="pnAlert" runat="server" Visible="False">
            <div id="agentMessage" class="alert alert-light alert-rounded text-center" role="alert">
                <h1 style="background-color: #678F49;"><i class="mdi mdi-success"></i>
                    <asp:Label ID="lblMessageTitle" runat="server" Text="Label"></asp:Label></h1>
                <h6><span id="spanAgentMessage">
                    <asp:Label ID="lblMessage" runat="server" Text="Label"></asp:Label></span></h6>
                <button id="btnAgentMessage" type="button" class="btn btn-alert close" data-dismiss="alert" aria-label="Close">
                    <i class="mdi mdi-close" aria-hidden="true"></i>Close
                </button>
            </div>
        </asp:Panel>

        <script>
            $(function () {
                if ((new URL(document.location)).searchParams.get("source") === "wb") {
                    $('#btnBackPlayerEdit').attr("onclick", "window.location.href = '/Report/WeeklyBalancesEnhanced.aspx'");
                }
            });
        </script>

        <div class="row page-titles">
            <div class="col-md-12 col-12 align-self-center">
                <h3 class="main-title m-b-0 m-t-0">Edit Player</h3>
            </div>
        </div>

        <!-- Stats cards -->
        <div class="kb-widget-section mb-3">
            <div class="row justify-content-center g-3">

                <!-- Player -->
                <div class="col-xxl-3 col-xl-3 col-lg-3 col-md-6 mb-3">
                    <div class="card h-100">
                        <div class="card-body">
                            <div class="card-icon mb-3 text-success">
                                <i class="fa-duotone fa-solid fa-user fa-2xl"></i>
                            </div>
                            <h5 class="card-title mb-1">Player</h5>
                            <div class="h4 fw-bold mb-0">
                                <asp:Label ID="lblPlayer1" runat="server" Text=""></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Current Balance (link a PMT) -->
                <div class="col-xxl-3 col-xl-3 col-lg-3 col-md-6 mb-3">
                    <a href="javascript:GetPlayerPayment(<%= Convert.ToInt32(Request.QueryString["player"]) %>);" class="text-decoration-none">
                        <div class="card h-100">
                            <div class="card-body">
                                <div class="card-icon mb-3 text-primary">
                                    <i class="fa-duotone fa-file-invoice-dollar fa-2xl"></i>
                                </div>
                                <h5 class="card-title mb-1">Current Balance</h5>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="h4 fw-bold mb-0">
                                        <asp:Label ID="lblCurrentBalance" runat="server" Text=""></asp:Label>
                                    </div>
                                    <span class="badge bg-primary">PMT</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- At Risk (link a Open Bets si > 0) -->
                <div class="col-xxl-3 col-xl-3 col-lg-3 col-md-6 mb-3">
                    <a href="<%= lblAtRisk.Text == "0" ? "javascript:void(0);" : "javascript:GetOpenBets(" + Convert.ToInt32(Request.QueryString["player"]) + ");" %>" class="text-decoration-none">
                        <div class="card h-100">
                            <div class="card-body">
                                <div class="card-icon mb-3 text-warning">
                                    <i class="fa-duotone fa-file-chart-pie fa-2xl"></i>
                                </div>
                                <h5 class="card-title mb-1">At Risk</h5>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="h4 fw-bold mb-0">
                                        <asp:Label ID="lblAtRisk" runat="server" Text=""></asp:Label>
                                    </div>
                                    <span class="badge bg-warning text-dark">BETS</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Lifetime -->
                <div class="col-xxl-3 col-xl-3 col-lg-3 col-md-6 mb-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="card-icon mb-4 text-danger">
                                <i class="fa-duotone fa-solid fa-file-invoice-dollar fa-2xl"></i>
                            </div>
                            <h5 class="card-title mb-0">Lifetime</h5>
                            <div class="h4 fw-bold mb-0">
                                <asp:Label ID="lblLifeTime" runat="server" Text=""></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="ctl00_MainContent_UpdatePanelReport" class="statbox widget box box-shadow">
            <!-- Tabs -->
            <!-- Tabs -->
            <div class="widget-header">
                <ul class="nav nav-tabs" id="playerEditTabs" role="tablist">

                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="tab-profile-tab" data-bs-toggle="tab"
                            data-bs-target="#tab-profile" type="button" role="tab"
                            aria-controls="tab-profile" aria-selected="true">
                            <i class="fa-duotone fa-user fa-fw me-2"></i>Profile
                        </button>
                    </li>

                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-credit-tab" data-bs-toggle="tab"
                            data-bs-target="#tab-credit" type="button" role="tab"
                            aria-controls="tab-credit" aria-selected="false">
                            <i class="fa-duotone fa-file-invoice-dollar fa-fw me-2"></i>Credit &amp; Figures
                        </button>
                    </li>

                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-status-tab" data-bs-toggle="tab"
                            data-bs-target="#tab-status" type="button" role="tab"
                            aria-controls="tab-status" aria-selected="false">
                            <i class="fa-duotone fa-user-check fa-fw me-2"></i>Status
                        </button>
                    </li>

                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-limits-tab" data-bs-toggle="tab"
                            data-bs-target="#tab-limits" type="button" role="tab"
                            aria-controls="tab-limits" aria-selected="false">
                            <i class="fa-duotone fa-gauge-high fa-fw me-2"></i>Limits
                        </button>
                    </li>

                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-settings-tab" data-bs-toggle="tab"
                            data-bs-target="#tab-settings" type="button" role="tab"
                            aria-controls="tab-settings" aria-selected="false">
                            <i class="fa-duotone fa-gear fa-fw me-2"></i>Settings
                        </button>
                    </li>

                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-message-tab" data-bs-toggle="tab"
                            data-bs-target="#tab-message" type="button" role="tab"
                            aria-controls="tab-message" aria-selected="false">
                            <i class="fa-duotone fa-message-lines fa-fw me-2"></i>Message
                        </button>
                    </li>

                </ul>
            </div>
            <div class="widget-content widget-content-area">
                <div class="tab-content tab-border p-3">
                    <!-- Profile -->
                    <div class="tab-pane fade show active" id="tab-profile" role="tabpanel">
                        <h5 class="mb-3">Edit Player:
                            <asp:Label ID="lblPlayer2" runat="server" Text=""></asp:Label></h5>
                        <div class="form-horizontal">
                            <div class="form-group row">
                                <label for="txtName" class="col-sm-4 text-right control-label col-form-label">Name</label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtName" class="form-control form-control-sm" runat="server"></asp:TextBox>
                                    <asp:HiddenField ID="hdfName" runat="server" />
                                    <asp:HiddenField ID="hdfval" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="txtLastName" class="col-sm-4 text-right control-label col-form-label">Middle Name</label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtLastName" class="form-control form-control-sm" runat="server"></asp:TextBox>
                                    <asp:HiddenField ID="hdfLastName" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="txtLastName2" class="col-sm-4 text-right control-label col-form-label">Last Name</label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtLastName2" class="form-control form-control-sm" runat="server"></asp:TextBox>
                                    <asp:HiddenField ID="hdfLastName2" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row" style="display: none">
                                <label for="txtPassword" class="col-sm-4 text-right control-label col-form-label">Password</label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtPassword" class="form-control form-control-sm" runat="server"></asp:TextBox>
                                    <asp:HiddenField ID="hdfPasswrod" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="txtOnlinePassword" class="col-sm-4 text-right control-label col-form-label">Online Password</label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtOnlinePassword" class="form-control form-control-sm" runat="server"></asp:TextBox>
                                    <asp:HiddenField ID="hdfOnlinePassword" runat="server" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Credit & Figures -->
                    <div class="tab-pane fade" id="tab-credit" role="tabpanel">
                        <h5 class="mb-3">Credit and Settled Figure</h5>
                        <div class="form-horizontal">
                            <div class="form-group row" runat="server" id="divCreLimit">
                                <label for="txtCreLimit" class="col-sm-4 text-right control-label col-form-label">Credit Limit</label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtCreLimit" class="form-control form-control-sm" runat="server"></asp:TextBox>
                                    <asp:HiddenField ID="hdfCreLimit" runat="server" />
                                    <asp:RangeValidator ID="rngValidatorCreditLimit" runat="server" ErrorMessage="MAXIMUM AMOUNT 999999" ControlToValidate="txtCreLimit" MinimumValue="0" MaximumValue="999999" Type="Integer"></asp:RangeValidator>
                                </div>
                            </div>
                            <div class="form-group row" runat="server" id="divTempCredit">
                                <label for="txtTempCredit" class="col-sm-4 text-right control-label col-form-label">Temp Credit</label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtTempCredit" class="form-control form-control-sm" runat="server"></asp:TextBox>
                                    <asp:HiddenField ID="hdfTempCredit" runat="server" />
                                    <asp:RangeValidator ID="rngTemValidatorCreditLimit" runat="server" ErrorMessage="MAXIMUM AMOUNT 999999" ControlToValidate="txtTempCredit" MinimumValue="0" MaximumValue="999999" Type="Integer"></asp:RangeValidator>
                                </div>
                            </div>
                            <div class="form-group row" runat="server" id="divTempCreditExp">
                                <label for="txtTempCreditExp" class="col-sm-4 text-right control-label col-form-label">Temp Credit Expire</label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtTempCreditExp" class="form-control form-control-sm datepicker" runat="server"></asp:TextBox>
                                    <asp:HiddenField ID="hdfTempCreditExp" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="txtSettledFigure" class="col-sm-4 text-right control-label col-form-label">Settled Figure</label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtSettledFigure" class="form-control form-control-sm" runat="server"></asp:TextBox>
                                    <asp:HiddenField ID="hdfSettledFigure" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="Credit Limit: Only numbers can be accepted" ValidationExpression="^[0-9]*$" ControlToValidate="txtCreLimit" Display="Dynamic"></asp:RegularExpressionValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Temp Credit: Only numbers can be accepted" ValidationExpression="^[0-9]*$" ControlToValidate="txtTempCredit" Display="Dynamic"></asp:RegularExpressionValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ErrorMessage="Settled Figure: Only numbers can be accepted" ValidationExpression="^[0-9]*$" ControlToValidate="txtSettledFigure" Display="Dynamic"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                    </div>

                    <!-- Status -->
                    <div class="tab-pane fade" id="tab-status" role="tabpanel">
                        <h5 class="mb-3">Player Status</h5>
                        <div class="form-horizontal">
                            <div class="form-group row">
                                <label for="ddlStatus" class="col-sm-4 text-right control-label col-form-label">Enable Player</label>
                                <div class="col-sm-8">
                                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control form-control-sm tomlist">
                                        <asp:ListItem Value="E">Enable</asp:ListItem>
                                        <asp:ListItem Value="D">Disable</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:HiddenField ID="hdfStatus" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-sm-4"></div>
                                    <div class="col-sm-8">
                                        <asp:CheckBox ID="chkOnline" runat="server" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" Text="Enable Player" />
                                    
                                    <asp:HiddenField ID="hdfOnline" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-sm-4"></div>
                                <div class="col-sm-8">
                                    <asp:CheckBox ID="chkSports" runat="server" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" Text="Enable Sports" />
                                   
                                    <asp:HiddenField ID="hdfSports" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-sm-4"></div>
                                <div class="col-sm-8">
                                    <asp:CheckBox ID="chkCasino" runat="server" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" Text="Enable Casino" />
                                    <asp:HiddenField ID="hdfCasino" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-sm-4"></div>
                                <div class="col-sm-8">
                                    <asp:CheckBox ID="chkHorses" runat="server" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" Text="Enable Horses" />
                                    <asp:HiddenField ID="hdfHorses" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row" style="display: none">
                                <div class="col-sm-4"></div>
                                <div class="col-sm-8">
                                    <asp:CheckBox ID="chkParlay" runat="server" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" Text="Parlay Cards" />
                                    <asp:HiddenField ID="hdfParlay" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row" id="divCancelRights" runat="server">
                                <div class="col-sm-4"></div>
                                <div class="col-sm-8">
                                    <asp:CheckBox ID="chkCancelRaceTicket" runat="server" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" Text="Cancel Racing Bets" OnCheckedChanged="chkCancelRaceTicket_CheckedChanged" AutoPostBack="true" />
                                    <asp:HiddenField ID="hdfCancelRaceTicket" runat="server" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Limits -->
                    <div class="tab-pane fade" id="tab-limits" role="tabpanel">
                        <h5 class="mb-3">Player Limits</h5>
                        <div class="form-horizontal">
                            <div class="form-group row" runat="server" id="divOMaxWager" style="display: none;">
                                <label for="txtMaxOnLine" class="col-sm-4 text-right control-label col-form-label">Online Max Wager</label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtMaxOnLine" class="form-control form-control-sm" runat="server"></asp:TextBox>
                                    <asp:HiddenField ID="hdfMaxOnLine" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row" runat="server" id="divOMinWager" style="display: none;">
                                <label for="txtMinOnLine" class="col-sm-4 text-right control-label col-form-label">Online Min Wager</label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtMinOnLine" class="form-control form-control-sm" runat="server"></asp:TextBox>
                                    <asp:HiddenField ID="hdfMinOnLine" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row" runat="server" id="divMaxWager">
                                <label for="txtMax" class="col-sm-4 text-right control-label col-form-label">Max Wager</label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtMax" class="form-control form-control-sm" runat="server"></asp:TextBox>
                                    <asp:HiddenField ID="hdfMax" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row" runat="server" id="divMinWager">
                                <label for="txtMin" class="col-sm-4 text-right control-label col-form-label">Min Wager</label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtMin" class="form-control form-control-sm" runat="server"></asp:TextBox>
                                    <asp:HiddenField ID="hdfMin" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server" ErrorMessage="Max Wager: Only numbers can be accepted" ValidationExpression="^[0-9]*$" ControlToValidate="txtMax" Display="Dynamic"></asp:RegularExpressionValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator7" runat="server" ErrorMessage="Min Wager: Only numbers can be accepted" ValidationExpression="^[0-9]*$" ControlToValidate="txtMin" Display="Dynamic"></asp:RegularExpressionValidator>
                                <asp:CompareValidator ID="CompareValidator2" runat="server" ErrorMessage="Max Wager must be higher that min wager" ControlToCompare="txtMax" ControlToValidate="txtMin" Operator="LessThan" Type="Integer" Display="Dynamic"></asp:CompareValidator>
                            </div>
                        </div>
                    </div>

                    <!-- Settings -->
                    <div class="tab-pane fade" id="tab-settings" role="tabpanel">
                        <h5 class="mb-3">Player Settings</h5>
                        <div class="form-horizontal">
                            <div class="form-group row" runat="server" id="divProfile">
                                <label class="col-sm-4 text-right control-label col-form-label">Profile</label>
                                <div class="col-sm-8">
                                    <asp:DropDownList ID="ddlPlayerProfile" runat="server" CssClass="form-control form-control-sm tomlist" DataSourceID="SqlDataSource1" DataTextField="ProfileName" DataValueField="IdProfile"></asp:DropDownList>
                                    <asp:HiddenField ID="hdfPlayerProfile" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row" runat="server" id="divPlayerProfileLimits">
                                <label class="col-sm-4 text-right control-label col-form-label">Limits Profile</label>
                                <div class="col-sm-8">
                                    <asp:DropDownList ID="ddlPlayerProfileLimits" runat="server" CssClass="form-control form-control-sm tomlist" DataSourceID="SqlDataSource2" DataTextField="ProfileName" DataValueField="IdProfileLimits"></asp:DropDownList>
                                    <asp:HiddenField ID="hdfPlayerProfileLimits" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row" runat="server" id="divLineStyle">
                                <label class="col-sm-4 text-right control-label col-form-label">Line Style</label>
                                <div class="col-sm-8">
                                    <asp:DropDownList ID="ddlLineStyle" runat="server" CssClass="form-control form-control-sm tomlist">
                                        <asp:ListItem Value="E">Eastern (Default)</asp:ListItem>
                                        <asp:ListItem Value="D">Decimal</asp:ListItem>
                                        <asp:ListItem Value="F">Fractional</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:HiddenField ID="hdfLineStyle" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row" runat="server" id="divHockeyLine">
                                <label class="col-sm-4 text-right control-label col-form-label">Hockey Line</label>
                                <div class="col-sm-8">
                                    <asp:DropDownList ID="ddlHockeyLine" runat="server" CssClass="form-control form-control-sm tomlist">
                                        <asp:ListItem Value="A">American (Default)</asp:ListItem>
                                        <asp:ListItem Value="C">Canadian</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:HiddenField ID="hdfHockeyLine" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row" runat="server" id="divBaseballLine">
                                <label class="col-sm-4 text-right control-label col-form-label">Baseball Line</label>
                                <div class="col-sm-8">
                                    <asp:DropDownList ID="ddlBaseballLine" runat="server" CssClass="form-control form-control-sm tomlist">
                                        <asp:ListItem Value="N">Dime Line (Default)</asp:ListItem>
                                        <asp:ListItem Value="W">Wide</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:HiddenField ID="hdfBaseballLine" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row" runat="server" id="divTimeZone">
                                <label class="col-sm-4 text-right control-label col-form-label">Time Zone</label>
                                <div class="col-sm-8">
                                    <asp:DropDownList ID="ddlTimeZone" runat="server" CssClass="form-control form-control-sm tomlist" DataSourceID="SqlDataSource3" DataTextField="Description" DataValueField="IdTimeZone"></asp:DropDownList>
                                    <asp:HiddenField ID="hdfTimeZone" runat="server" />
                                </div>
                            </div>
                            <div class="form-group row" runat="server" id="div1">
                                <label class="col-sm-4 text-right control-label col-form-label">Agent</label>
                                <div class="col-sm-8">
                                    <asp:DropDownList ID="ddlAgent" CssClass="form-control form-control-sm tomlist" runat="server" Enabled="False"></asp:DropDownList>
                                    <asp:HiddenField ID="hdfIdAgent" runat="server" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Message -->
                    <div class="tab-pane fade" id="tab-message" role="tabpanel">
                        <h5 class="mb-3">Player Message</h5>
                        <div class="form-horizontal">
                            <div class="form-group row">
                                <label class="col-sm-3 text-right control-label col-form-label">Options</label>
                                <div class="col-sm-3">
                                    <asp:HiddenField ID="hdfIdPlayerMessage" runat="server" />
                                    <asp:DropDownList ID="ddlMessageType" runat="server" CssClass="form-control form-control-sm tomlist">
                                        <asp:ListItem Value="N">Normal</asp:ListItem>
                                        <asp:ListItem Value="P">Permanet</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-sm-3">
                                    <asp:CheckBox ID="chkDisplaycounter" runat="server" Text="Display Counter" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" />
                                </div>
                                <div class="col-sm-3">
                                    <asp:TextBox ID="txtCounter" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-3" style="text-align: right;">
                                    <asp:CheckBox ID="chkExpirationDate" runat="server" Text="Expiration Date" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" />
                                </div>
                                <div class="col-sm-3">
                                    <asp:TextBox ID="txtExpirationDate" runat="server" CssClass="form-control form-control-sm datepicker"></asp:TextBox>
                                </div>
                                <div class="col-sm-6">
                                    <asp:CheckBox ID="chkPlayerCanDisable" runat="server" Text="Player can disable message" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" />
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-12">
                                    <asp:TextBox ID="txtMessage" CssClass="form-control form-control-sm" placeholder="message" runat="server" Height="115px" TextMode="MultiLine"></asp:TextBox>
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-3">
                                    <asp:Button ID="btnCreateMessage" runat="server" Text="Create Message" CssClass="btn btn-success" OnClick="btnCreateMessage_Click" />
                                </div>
                                <div class="col-sm-3"></div>
                                <div class="col-sm-3">
                                    <asp:Button ID="btnUpdate" runat="server" Text="Update Message" CssClass="btn btn-success" OnClick="btnUpdateMessage_Click" />
                                </div>
                            </div>

                            <div class="form-group row">
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator8" runat="server" ErrorMessage="Display Counter: Only numbers can be accepted" ValidationExpression="^[0-9]*$" ControlToValidate="txtCounter" Display="Dynamic"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <center class="mt-3">
                <input type="hidden" name="hRight" id="hRight" value="ICL_DCL_IWL_DWL_IWO_DWO_EDP_CPP_CTC_">
                <div>
                    <button type="button" class="btn btn-inverse waves-effect waves-light" onclick="window.location.href='PlayerManagement.aspx'" id="btnBackPlayerEdit">Back</button>
                    <asp:Button ID="btnSubmit" CssClass="btn btn-success" runat="server" Text="Save" OnClick="btnSubmit_Click"></asp:Button>
                </div>
            </center>
        </div>

        <h1>
            <asp:Label ID="lblError" runat="server"></asp:Label></h1>

        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
            SelectCommand="Addon_Web_PlayerProfile_GetByAgent"
            SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:SessionParameter Name="prmIDAgent" SessionField="SubIdAgent" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlDataSource2" runat="server"
            ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
            SelectCommand="Addon_Web_PlayerProfileLimits_GetByAgent"
            SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:SessionParameter Name="prmIDAgent" SessionField="SubIdAgent" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlDataSource3" runat="server"
            ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
            SelectCommand="AddOn_GetTimeZones"
            SelectCommandType="StoredProcedure"></asp:SqlDataSource>
    </div>

    <script src="/src/assets/js/scrollspyNav.js"></script>
</asp:Content>

