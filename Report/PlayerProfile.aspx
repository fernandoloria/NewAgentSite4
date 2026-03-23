<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerProfile.aspx.cs" Inherits="AgentSite4.Report.PlayerProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <style>
            input[type="text"]:disabled {
                background: #dddddd;
            }

            .rounded {
                border-radius: 7px;
                padding: 5px;
                border: 2px solid #CCC;
                background: url(images/bullet_list_icon.png) 2px 7px no-repeat #ebebeb !important;
            }

            .row {
                padding: 5px;
                background: unset !important;
            }


            .col-lg-1, .col-lg-10, .col-lg-11, .col-lg-12, .col-lg-2, .col-lg-3, .col-lg-4, .col-lg-5, .col-lg-6, .col-lg-7, .col-lg-8, .col-lg-9, .col-md-1, .col-md-10, .col-md-11, .col-md-12, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6, .col-md-7, .col-md-8, .col-md-9, .col-sm-1, .col-sm-10, .col-sm-11, .col-sm-12, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6, .col-sm-7, .col-sm-8, .col-sm-9, .col-xs-1, .col-xs-10, .col-xs-11, .col-xs-12, .col-xs-2, .col-xs-3, .col-xs-4, .col-xs-5, .col-xs-6, .col-xs-7, .col-xs-8, .col-xs-9 {
                padding-right: unset;
                padding-left: unset;
            }

            .boxes {
                min-height: 367px;
            }

            .toLeft {
                float: right;
                margin-right: 5px;
            }

            .toRight {
                float: right;
            }

            input[type="text"] {
                width: 60px;
            }

            .row h5 {
                border-bottom: 3px solid #136A98;
            }
        </style>

        <h3 class="page-title">Player Profile Management
        </h3>
        <asp:Panel ID="pnDAtos" runat="server">
            <table style="width: 100%;" cellspacing="0" cellpadding="3" border="0" class="table">
                <tbody>
                    <tr class="GameHeader">
                        <td colspan="6" style="padding: 10px;">Player Profile Limits
                        <asp:Label runat="server" ID="lblAg" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" align="center">
                            <table style="width: 100%;">
                                <tr>
                                    <td>
                                        <asp:Label ID="Label1" runat="server" Text="Agent"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlAgents" runat="server" DataSourceID="sqldsddlAgents"
                                            DataTextField="Agent" DataValueField="IdAgent" AutoPostBack="True" CssClass="form-control form-control-sm tomlist"
                                            OnSelectedIndexChanged="ddlAgents_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:Label ID="Players" runat="server" Text="Player:"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlPlayers" runat="server" DataSourceID="sqldsddlPlayers"
                                            DataTextField="Player" DataValueField="IdPlayer" AutoPostBack="True" CssClass="form-control form-control-sm tomlist"
                                            OnSelectedIndexChanged="ddlPlayers_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:Label ID="Players0" runat="server" Text="Change Profile:"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlProfiles" runat="server" DataSourceID="sqldsddlProfiles"
                                            DataTextField="ProfileName" DataValueField="IdProfile"
                                            OnDataBound="ddlProfiles_DataBound">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:Button ID="btnSetProfile" runat="server" CssClass="btnForm"
                                            OnClick="btnSetProfile_Click" Text="Set Profile" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6">&nbsp;
                        <asp:Label ID="lblWarning" runat="server" Font-Bold="True" Font-Size="Large" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <asp:Button ID="btnCreate" runat="server" CssClass="btnForm" OnClick="btnCreate_Click" Text="Create Custom Profile" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6"></td>
                    </tr>
                    <tr style="vertical-align: middle" valign="middle">
                        <td align="center"></td>
                        <td valign="bottom">&nbsp;</td>
                        <td style="text-align: left;">&nbsp;</td>
                        <td align="center">&nbsp;
                        </td>
                        <td align="center">&nbsp;
                        </td>
                        <td align="center">
                            <asp:Button ID="btnApply" runat="server" CssClass="btnForm" OnClick="btnApply_Click" Text="Save" />
                            <asp:Button ID="btnReset" runat="server" CssClass="btnForm" OnClick="btnReset_Click" Text="Reset" />
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="container">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#general" role="tab" data-toggle="tab">General</a></li>
                    <li><a href="#gameType" role="tab" data-toggle="tab">Game Type</a></li>
                    <li><a href="#straight" role="tab" data-toggle="tab">Straight</a></li>
                    <li><a href="#parlayLimits" role="tab" data-toggle="tab">Parlay Limits</a></li>
                </ul>

                <div class="tab-content">
                    <div class="tab-pane active" role="tabpanel" id="general">
                        <div>
                            <div class="row" style="background: unset !important;">
                                <div class="col-md-4 rounded">
                                    <h5><strong>Pitcher Change Type</strong></h5>
                                    <asp:RadioButtonList ID="RadioButtonList2" runat="server">
                                        <asp:ListItem Value="0">Keep Price</asp:ListItem>
                                        <asp:ListItem Value="1">Credit use line, Cash adjust win amount</asp:ListItem>
                                        <asp:ListItem Value="2">Adjust Risk Amount</asp:ListItem>
                                        <asp:ListItem Value="3">Adjust Win Amound</asp:ListItem>
                                        <asp:ListItem Value="4">Use Line</asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                                <div class="col-md-4 rounded">
                                    <h5><strong>MLB Pitcher Change</strong></h5>
                                    <asp:CheckBox ID="chkSkipSide" runat="server" Text="Skip Side" />
                                    <br />
                                    <asp:CheckBox ID="chkSkipTotal" runat="server" Text="Skip Total" />
                                    <br />
                                    <asp:CheckBox ID="chkSkipRunLine" runat="server" Text="Skip Run Line" />
                                </div>
                                <div class="col-md-4 rounded">
                                    <h5><strong>MLB Short Game</strong></h5>
                                    <asp:CheckBox ID="chkCancelSide" runat="server" Text="Cancel Side" />
                                    <br />
                                    <asp:CheckBox ID="chkCancelTotal" runat="server" Text="Cancel Total" />
                                    <br />
                                    <asp:CheckBox ID="chkCancelRunLine" runat="server" Text="Cancel Run Line" />
                                </div>
                            </div>

                            <div class="row" style="background: unset !important;">
                                <div class="col-md-6 rounded">
                                    <h5><strong>Related Options by Game</strong></h5>
                                    <div class="form-group">
                                        <asp:Label ID="Label9" runat="server" Text="Sport" CssClass="control-label"></asp:Label>
                                        <asp:DropDownList ID="ddlGeneralidSport" runat="server" AutoPostBack="True" DataSourceID="sqldsddlSport" DataTextField="SportName" DataValueField="idSport" CssClass="form-control form-control-sm tomlist">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label ID="Label8" runat="server" Text="Period" CssClass="control-label"></asp:Label>
                                        <asp:DropDownList ID="ddlGeneralIdPeriod" runat="server" AutoPostBack="True" DataSourceID="sqldsddlGeneralidSport" DataTextField="PeriodDescription" DataValueField="NumberOfPeriod" CssClass="form-control form-control-sm tomlist">
                                        </asp:DropDownList>
                                        <asp:DetailsView ID="dvRalatedOptionGame" runat="server" AutoGenerateRows="False" DataKeyNames="IdProfile,IdSport,IdPeriod" DataSourceID="GamaRelatedOptions" EnableModelValidation="True" Height="50px" Width="212px" OnDataBound="DetailsView1_DataBound" BorderStyle="None" GridLines="None">
                                            <Fields>
                                                <asp:TemplateField SortExpression="MLDog_Over">
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="MLDog_Over" runat="server" Checked='<%# Bind("MLDog_Over") %>' Text="Dog Money Line / Total Over" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField SortExpression="MLDog_Under">
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="MLDog_Under" runat="server" Checked='<%# Bind("MLDog_Under") %>' Text="Dog Money Line / Total Under" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField SortExpression="MLFav_Over">
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="MLFav_Over" runat="server" Checked='<%# Bind("MLFav_Over") %>' Text="Fav Money Line / Total Over" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField SortExpression="MLFav_Under">
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="MLFav_Under" runat="server" Checked='<%# Bind("MLFav_Under") %>' Text="Fav Money Line / Total Under" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField SortExpression="SprDog_Over">
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="SprDog_Over" runat="server" Checked='<%# Bind("SprDog_Over") %>' Text="Dog Spread / Total Over" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField SortExpression="SprDog_Under">
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="SprDog_Under" runat="server" Checked='<%# Bind("SprDog_Under") %>' Text="Dog Spread / Total Under" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField SortExpression="SprFav_Over">
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="SprFav_Over" runat="server" Checked='<%# Bind("SprFav_Over") %>' Text="Fav Spread / Total Over" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField SortExpression="SprFav_Under">
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="SprFav_Under" runat="server" Checked='<%# Bind("SprFav_Under") %>' Text="Fav Spread / Total Under" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Fields>
                                            <RowStyle BorderStyle="None" />
                                        </asp:DetailsView>
                                    </div>

                                </div>
                                <div class="col-md-6 ">
                                    <div class="col-md-12 rounded">
                                        <h5><strong>Duplicate Bets Options</strong></h5>
                                        <div class="col-md-12 rounded">
                                            <asp:Label ID="Label17" runat="server" Text="Check duplicated bets on" CssClass="control-label"></asp:Label>
                                            <br />
                                            <div class="form-inline">
                                                <asp:CheckBox CssClass="form-group" ID="chkDuplicateLineChange" runat="server" Text="Line Changes" />
                                                <asp:CheckBox CssClass="form-group" ID="chkDuplicateParlays" runat="server" Text="Parlays" />
                                                <asp:CheckBox CssClass="form-group" ID="chkDuplicateTeasers" runat="server" Text="Teasers" />
                                                <asp:CheckBox CssClass="form-group" ID="chkDuplicateIfBets" runat="server" Text="If Bets" />
                                                <asp:CheckBox CssClass="form-group" ID="chkDuplicateReveres" runat="server" Text="Reverses" />
                                            </div>
                                        </div>
                                        <div class="col-md-12" style="padding-left: 0px;">
                                            <div class="col-md-6 rounded">
                                                <div class="form-group">
                                                    <asp:Label ID="Label10" runat="server" Text="Parlays" CssClass="control-label"></asp:Label>
                                                    <asp:RadioButtonList ID="rdnGeneralPaylays" runat="server">
                                                        <asp:ListItem Value="0">Check with Straight Bets</asp:ListItem>
                                                        <asp:ListItem Value="1">Check with same details</asp:ListItem>
                                                        <asp:ListItem Value="2">None</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>

                                            </div>
                                            <div class="col-md-6" style="padding-left: 5px;">
                                                <div class="form-group rounded">
                                                    <asp:Label ID="Label11" runat="server" Text="Teasers" CssClass="control-label"></asp:Label>
                                                    <asp:RadioButtonList ID="rdnGeneralTeaser" runat="server">
                                                        <asp:ListItem Value="0">Check with Straight Bets</asp:ListItem>
                                                        <asp:ListItem Value="1">Check with same details</asp:ListItem>
                                                        <asp:ListItem Value="2">None</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-12">
                                            <asp:CheckBox ID="chkGeneralCheckIfBetsReversesWithStraightBets" Text="Check If Bets & Reverses With Straight Bets" runat="server" />
                                        </div>
                                    </div>
                                    <div class="col-md-12 rounded">
                                        <h5><strong>Free Plays</strong></h5>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <asp:Label ID="Label12" runat="server" Text="Max Payout" CssClass="control-label"></asp:Label>
                                                <asp:TextBox ID="txtGeneralMaxPayout" CssClass="toLeft" runat="server"></asp:TextBox>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="Label13" runat="server" Text="Odds Limits" CssClass="control-label"></asp:Label>
                                                <asp:TextBox ID="txtGeneralOddsLimits" CssClass="toLeft" runat="server"></asp:TextBox>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="Label14" runat="server" Text="Max # of Teams" CssClass="control-label"></asp:Label>
                                                <asp:TextBox ID="txtGeneralMaxNumofTeams" CssClass="toLeft" runat="server"></asp:TextBox>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="Label15" runat="server" Text="Max # of Favs" CssClass="control-label"></asp:Label>
                                                <asp:TextBox ID="txtGeneralMaxNumofFavs" CssClass="toLeft" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <asp:CheckBox ID="chkGeneralAllowBothSides" runat="server" Text="Allow Both Sides" />
                                            <br />
                                            <asp:CheckBox ID="chkGeneralDuplicatesBets" runat="server" Text="Duplicates Bets" />
                                            <br />
                                            <asp:CheckBox ID="chkGeneralCheckOfficeFilters" runat="server" Text="Check Office Filters" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row" style="background: unset !important;">
                                <div class="col-md-6 rounded">
                                    <h5><strong>Card Limits</strong></h5>
                                    <div class="form-group">
                                        <asp:Label ID="Label16" runat="server" Text="Max # of Favs" CssClass="control-label"></asp:Label>
                                        <asp:TextBox ID="TextBox7" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-6 rounded">
                                    <asp:CheckBox ID="chkGeneralAllowHookupsInRelatedSoccerGames" runat="server" Text="Allow Hookups in Related Soccer Games" />
                                    <br />
                                    <asp:CheckBox ID="chkGeneralAllowOpenSpotsInReverses" runat="server" Text="Allow Open Spots In Reverses" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane active" role="tabpanel" id="gameType">
                        <div>
                        </div>
                    </div>
                    <div class="tab-pane" role="tabpanel" id="straight">
                        <div>
                        </div>
                    </div>
                    <div class="tab-pane active" role="tabpanel" id="parlayLimits">
                        <div>
                            <div class="row" style="background: unset !important;">
                                <div class="col-md-12">
                                    <h1>Parlay </h1>
                                </div>
                            </div>
                            <div class="row" style="background: unset !important;">
                                <div class="col-md-6 rounded boxes">
                                    <div class="col-md-12">
                                        <h5><strong>Odds</strong></h5>
                                        <br />
                                        <br />
                                    </div>
                                    <div class="col-md-12">
                                        <asp:GridView ID="gvOdds" runat="server" AutoGenerateColumns="False" CssClass="table-bordered" DataKeyNames="IdProfile,NumTeams" DataSourceID="sqldsgvOdds" EnableModelValidation="True" Width="100%">

                                            <Columns>
                                                <asp:BoundField DataField="NumTeams" HeaderText="#Teams" ReadOnly="True" SortExpression="NumTeams" />
                                                <asp:BoundField DataField="Odds" DataFormatString="{0:N1}" HeaderText="Odds" SortExpression="Odds" />
                                                <asp:BoundField DataField="ExtraJuice" HeaderText="Extra Juice" SortExpression="ExtraJuice" />
                                                <asp:BoundField DataField="MaxRisk" HeaderText="Max Risk" SortExpression="MaxRisk" />
                                                <asp:BoundField DataField="MaxPayout" DataFormatString="{0:N0}" HeaderText="Max Payout" SortExpression="MaxPayout" />
                                                <asp:BoundField DataField="MaxOpenSpots" HeaderText="Max Open Spots" SortExpression="MaxOpenSpots" />
                                                <asp:BoundField DataField="MaxDogLines" HeaderText="Max Dog Lines" SortExpression="MaxDogLines" />
                                                <asp:BoundField DataField="MaxMoneyLines" HeaderText="Max $Lines" SortExpression="MaxMoneyLines" />
                                                <asp:BoundField DataField="MaxTotalLines" HeaderText="Max Total Lines" SortExpression="MaxTotalLines" />
                                            </Columns>
                                            <HeaderStyle CssClass="GameHeader" />
                                            <RowStyle CssClass="TrGameOdd" />
                                            <AlternatingRowStyle CssClass="TrGameEven" />
                                        </asp:GridView>
                                    </div>
                                </div>
                                <div class="col-md-4 rounded boxes">
                                    <div class="col-md-12">
                                        <h5><strong>Max Teams</strong></h5>
                                        <asp:DropDownList ID="ddlNumTeams" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm tomlist">
                                            <asp:ListItem Value="2">2 Team Parlay</asp:ListItem>
                                            <asp:ListItem Value="3">3 Team Parlay</asp:ListItem>
                                            <asp:ListItem Value="4">4 Team Parlay</asp:ListItem>
                                            <asp:ListItem Value="5">5 Team Parlay</asp:ListItem>
                                            <asp:ListItem Value="6">6 Team Parlay</asp:ListItem>
                                            <asp:ListItem Value="7">7 Team Parlay</asp:ListItem>
                                            <asp:ListItem Value="8">8 Team Parlay</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-12">
                                        <asp:GridView ID="gvMaxTeams" runat="server" CssClass="table-bordered" AutoGenerateColumns="False" DataKeyNames="IdProfile,IdSport,NumTeams" DataSourceID="sqldsgvMaxTeams" EnableModelValidation="True" Width="100%">
                                            <Columns>
                                                <asp:BoundField DataField="IdSport" HeaderText="Sport" ReadOnly="True" SortExpression="IdSport" />
                                                <asp:BoundField DataField="NumTeams" HeaderText="# Teams" ReadOnly="True" SortExpression="NumTeams" />
                                                <asp:BoundField DataField="MaxGames" HeaderText="Max Games" SortExpression="MaxGames" />
                                                <asp:BoundField DataField="MaxDogs" HeaderText="Max Dogs" SortExpression="MaxDogs" />
                                                <asp:BoundField DataField="MaxMoneyLines" HeaderText="Max $Lines" SortExpression="MaxMoneyLines" />
                                                <asp:BoundField DataField="MaxTotalLines" HeaderText="Max Total Lines" SortExpression="MaxTotalLines" />
                                            </Columns>
                                            <HeaderStyle CssClass="GameHeader" />
                                            <RowStyle CssClass="TrGameOdd" />
                                            <AlternatingRowStyle CssClass="TrGameEven" />
                                        </asp:GridView>
                                    </div>
                                </div>
                                <div class="col-md-2 rounded boxes">
                                    <div class="col-md-12">
                                        <h5><strong>Basic Sports</strong></h5>
                                        <br />
                                        <br />
                                    </div>
                                    <div class="col-md-12">
                                        <asp:GridView ID="gvBasicSports" CssClass="table-bordered" runat="server" AutoGenerateColumns="False" DataKeyNames="IdProfile,IdSport" DataSourceID="sqldsgvBasicSports" EnableModelValidation="True" Width="100%">
                                            <Columns>
                                                <asp:BoundField DataField="IdSport" HeaderText="Sport" ReadOnly="True" SortExpression="IdSport" />
                                                <asp:CheckBoxField DataField="BasicSport" HeaderText="Enable" SortExpression="BasicSport" />
                                            </Columns>
                                            <HeaderStyle CssClass="GameHeader" />
                                            <RowStyle CssClass="TrGameOdd" />
                                            <AlternatingRowStyle CssClass="TrGameEven" />
                                        </asp:GridView>
                                    </div>
                                </div>
                            </div>
                            <div class="row rounded" style="background: unset !important;">
                                <h5><strong>Parlay General Settings</strong></h5>
                                <div class="col-md-4">
                                    <asp:CheckBox ID="CheckBox1" runat="server" Text="Ties or Loses" />
                                    <br />
                                    <asp:CheckBox ID="CheckBox2" runat="server" Text="Allow Open Bets" />
                                </div>
                                <div class="col-md-4">

                                    <asp:CheckBox ID="CheckBox3" runat="server" Text="Use Table Odd Range" />
                                    <br />
                                    <asp:CheckBox ID="CheckBox4" runat="server" Text="If $Line then use true odds" />
                                </div>
                                <div class="col-md-4">

                                    <asp:CheckBox ID="CheckBox5" runat="server" Text="Allow Spread &amp; Total in Hockey" />
                                    <br />
                                    <asp:CheckBox ID="CheckBox6" runat="server" Text="Allow Spread &amp; Total in Soccer" />
                                </div>
                            </div>
                            <div class="row" style="background: unset !important;">
                                <div class="col-md-6">
                                    <div class="col-md-12 rounded">
                                        <h5><strong>Baseball</strong></h5>
                                        <div class="col-md-6">
                                            <asp:CheckBox ID="CheckBox7" runat="server" Text="Always Action" />
                                        </div>
                                        <div class="col-md-6">
                                            <asp:CheckBox ID="CheckBox8" runat="server" Text="Allow Run Line and Total" />
                                        </div>
                                    </div>
                                    <div class="col-md-12">

                                        <div class="col-md-6 rounded">
                                            <h5><strong>Parlay Formula</strong></h5>
                                            <asp:RadioButtonList ID="RadioButtonList1" runat="server">
                                                <asp:ListItem Value="0">True Odds</asp:ListItem>
                                                <asp:ListItem Value="1">Ro Mild</asp:ListItem>
                                                <asp:ListItem Value="2">Ro Total</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </div>
                                        <div class="col-md-6 rounded">
                                            <h5><strong>Check Max Dogs on</strong></h5>
                                            <asp:CheckBox ID="CheckBox9" runat="server" Text="Side" />
                                            <br />
                                            <asp:CheckBox ID="CheckBox10" runat="server" Text="Total" />
                                            <br />
                                            <asp:CheckBox ID="CheckBox11" runat="server" Text="$ Line" />
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 rounded">
                                    <h5>Extra Settings</h5>
                                    <div class="col-md-6">
                                        <div class="form-group toLeft">
                                            <asp:Label ID="Label2" runat="server" Text="Max Sides" CssClass="control-label"></asp:Label>
                                            <asp:TextBox ID="TextBox1" runat="server" Columns="8"></asp:TextBox>
                                        </div>
                                        <div class="form-group toLeft">
                                            <asp:Label ID="Label3" runat="server" Text="Max Buys Points" CssClass="control-label"></asp:Label>
                                            <asp:TextBox ID="TextBox2" runat="server" Columns="8"></asp:TextBox>
                                        </div>
                                        <div class="form-group toLeft">
                                            <asp:Label ID="Label4" runat="server" Text="Max Payout" CssClass="control-label"></asp:Label>
                                            <asp:TextBox ID="TextBox3" runat="server" Columns="8"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group toLeft">
                                            <asp:Label ID="Label5" runat="server" Text="High Level Buy Points" CssClass="control-label"></asp:Label>
                                            <asp:TextBox ID="TextBox4" runat="server" Columns="8"></asp:TextBox>
                                        </div>
                                        <div class="form-group toLeft">
                                            <asp:Label ID="Label6" runat="server" Text="Odds Default" CssClass="control-label"></asp:Label>
                                            <asp:TextBox ID="TextBox5" runat="server" Columns="8"></asp:TextBox>
                                        </div>
                                        <div class="form-group toLeft">
                                            <asp:Label ID="Label7" runat="server" Text="Odds Limit" CssClass="control-label"></asp:Label>
                                            <asp:TextBox ID="TextBox6" runat="server" Columns="8"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div></div>
                </div>
            </div>


            <asp:SqlDataSource ID="sqldsddlAgents" runat="server"
                ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                SelectCommand="AddOn_Agent_GetAgents"
                SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:SessionParameter Name="prmIdAgent" SessionField="SubIdAgent"
                        Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqldsddlPlayers" runat="server"
                ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                SelectCommand="AddOn_Agent_GetPlayers" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlAgents" Name="prmIdAgent"
                        PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="sqldsddlProfiles" runat="server"
                ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                SelectCommand="Addon_Web_PlayerProfile_GetByAgent"
                SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:SessionParameter Name="prmIDAgent" SessionField="SubIdAgent"
                        Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="sqldsgvOdds" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="AddOn_PLAYERPROFILEPARLAYLIMIT_getbyIdProfile" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlProfiles" Name="prmidProfile" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="sqldsgvBasicSports" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Addon_PLAYERPROFILEPARLAYBASICSPORTS_getbyIdProfile" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlProfiles" Name="prmidProfile" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="sqldsgvMaxTeams" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="AddOn_PLAYERPROFILEPARLAYLIMITDETAIL_getbyIdProfile" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlProfiles" Name="prmidProfile" PropertyName="SelectedValue" Type="Int32" />
                    <asp:ControlParameter ControlID="ddlNumTeams" Name="prmNumTeams" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="sqldsddlSport" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Addon_Web_PlayerProfile_ddlSport" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sqldsddlGeneralidSport" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Addon_Web_PlayerProfile_ddlPeriod" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlGeneralidSport" Name="prmidSport" PropertyName="SelectedValue" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="GamaRelatedOptions" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Addon_Web_PlayerProfile_GamaRelatedOptions" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlProfiles" Name="prmidProfile" PropertyName="SelectedValue" Type="Int32" />
                    <asp:ControlParameter ControlID="ddlGeneralidSport" Name="prmidSport" PropertyName="SelectedValue" Type="String" />
                    <asp:ControlParameter ControlID="ddlGeneralIdPeriod" Name="prmidPeriod" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
        </asp:Panel>

        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    </div>
</asp:Content>
