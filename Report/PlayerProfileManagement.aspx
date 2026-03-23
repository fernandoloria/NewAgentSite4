<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerProfileManagement.aspx.cs" Inherits="AgentSite4.Report.PlayerProfileManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <style>
        input[type="text"]:disabled {
            background: #dddddd;
        }

        h5 {
            border-bottom: 3px solid #C3272B;
            padding-bottom: 5px;
        }

        .heaerDetailView {
            font-weight: bold;
            padding-left: 14px;
            padding-top: 5px;
        }

        .grid-wrapper-div {
            overflow: scroll;
            height: 700px;
        }

        tr.TrGameOdd a selected,
        tr.TrGameEven a selected {
            color: #fff;
            text-decoration: none;
            font-weight: bold;
        }

        .masonry {
            column-count: 3;
            column-gap: 1em;
        }

        .masonry-type2 {
            column-count: 2;
            column-gap: 0.2em;
        }

        .masonry-only {
            column-count: 1;
            column-gap: 1em;
        }

        .masonry .item,
        .masonry-type2 .item {
            background-color: #f5f5f5;
            border-radius: 5px;
            display: inline-block;
            margin: 0 0 1em;
            padding: 10px;
            width: 100%;
        }
    </style>

    <h3 class="page-title">
        Player Profile Management
    </h3>
   
    <asp:ScriptManager runat="server" ID="ScriptManager1"></asp:ScriptManager>
    <asp:Panel ID="pnDatos" runat="server">

        <div class="row">
            <div class="col-md-12">
                <asp:Label runat="server" ID="lblAg" />
                <div class="form-inline">
                    <div class="form-group">
                        <label>
                            <asp:Label ID="Label1" runat="server" Text="Agent"></asp:Label></label>
                        <asp:DropDownList ID="ddlAgents" runat="server" CssClass="form-control form-control-sm tomlist" DataSourceID="sqldsddlAgents" DataTextField="Agent" DataValueField="IdAgent" AutoPostBack="True" OnSelectedIndexChanged="ddlAgents_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>
                            <asp:Label ID="Players" runat="server" Text="Player:"></asp:Label></label>
                        <asp:DropDownList ID="ddlPlayers" runat="server" CssClass="form-control form-control-sm tomlist" DataSourceID="sqldsddlPlayers" DataTextField="Player" DataValueField="IdPlayer" AutoPostBack="True" OnSelectedIndexChanged="ddlPlayers_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>
                            <asp:Label ID="Players0" runat="server" Text="Change Profile:"></asp:Label></label>
                        <asp:DropDownList ID="ddlProfiles" runat="server" CssClass="form-control form-control-sm tomlist" DataSourceID="sqldsddlProfiles" DataTextField="ProfileName" DataValueField="IdProfile" AutoPostBack="true" OnDataBound="ddlProfiles_DataBound" OnSelectedIndexChanged="ddlProfiles_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <asp:Button ID="btnSetProfile" runat="server" CssClass="btn btnForm" OnClick="btnSetProfile_Click" Text="Set Profile" />
                        <asp:Label ID="lblWarning" runat="server" Font-Bold="True" Font-Size="Large" ForeColor="Red"></asp:Label>
                        <asp:Button ID="btnCreate" runat="server" CssClass="btn btnForm" OnClick="btnCreate_Click" Text="Create Custom Profile" />
                    </div>
                </div>
            </div>
        </div>
        <br>
        <div class="row">
            <div class="col-md-12">
                <div class="row">
                    <div class="col-md-5">
                        <asp:TextBox ID="Notes" runat="server" CssClass="form-control form-control-sm" placeholder="Notes" Height="60px" TextMode="MultiLine"></asp:TextBox>
                        <br />
                        <asp:Button ID="btnApply1" runat="server" CssClass="btn btnForm" OnClick="btnApply_Click" Text="Save" />
                        <asp:Button ID="btnReset2" runat="server" CssClass="btn btnForm" OnClick="btnReset_Click" Text="Reset" />
                    </div>
                </div>
            </div>
        </div>

        <br>
        <div>
            <ul class="nav nav-tabs">
                <li class="active"><a href="#general" role="tab" data-toggle="tab">General</a></li>
                <li><a href="#gameType" role="tab" data-toggle="tab">Game Type</a></li>
                <li><a href="#straight" role="tab" data-toggle="tab">Straight</a></li>
                <li><a href="#parlayLimits" role="tab" data-toggle="tab">Parlay Limits</a></li>
            </ul>

            <div class="tab-content">
                <div class="tab-pane active" role="tabpanel" id="general">
                    <div class="masonry">
                        <div class="item">
                            <h5><strong>Pitcher Change Type</strong></h5>
                            <asp:RadioButtonList ID="PC_PitcherChangeType" runat="server">
                                <asp:ListItem Value="0">Keep Price</asp:ListItem>
                                <asp:ListItem Value="1">Credit use line, Cash adjust win amount</asp:ListItem>
                                <asp:ListItem Value="2">Adjust Risk Amount</asp:ListItem>
                                <asp:ListItem Value="3">Adjust Win Amound</asp:ListItem>
                                <asp:ListItem Value="4">Use Line</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>

                        <div class="item">
                            <h5><strong>MLB Pitcher Change </strong></h5>
                            <asp:CheckBox ID="PC_SkipSide" runat="server" Text="Skip Side" />
                            <br />
                            <asp:CheckBox ID="PC_SkipTotal" runat="server" Text="Skip Total" />
                            <br />
                            <asp:CheckBox ID="PC_SkipRunLine" runat="server" Text="Skip Run Line" />
                        </div>

                        <div class="item">
                            <h5><strong>MLB Short Game</strong></h5>
                            <asp:CheckBox ID="SG_CancelSide" runat="server" Text="Cancel Side" />
                            <br />
                            <asp:CheckBox ID="SG_CancelTotal" runat="server" Text="Cancel Total" />
                            <br />
                            <asp:CheckBox ID="SG_CancelRunLine" runat="server" Text="Cancel Run Line" />
                        </div>

                        <div class="item">
                            <h5><strong>Related Options by Game</strong></h5>
                            <div class="form-group">
                                <asp:Label ID="Label9" runat="server" Text="Sport"></asp:Label>
                                <asp:DropDownList ID="ddlGeneralidSport" runat="server" CssClass="form-control form-control-sm tomlist" AutoPostBack="True" DataSourceID="sqldsddlSport" DataTextField="SportName" DataValueField="idSport" OnSelectedIndexChanged="ddlGeneralidSport_SelectedIndexChanged" OnDataBound="ddlGeneralidSport_DataBound">
                                </asp:DropDownList>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="Label8" runat="server" Text="Period"></asp:Label>
                                <asp:DropDownList ID="ddlGeneralIdPeriod" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm tomlist" OnSelectedIndexChanged="ddlGeneralIdPeriod_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <asp:DetailsView ID="dvRalatedOptionGame" runat="server" AutoGenerateRows="False" DataKeyNames="IdProfile,IdSport,IdPeriod" DataSourceID="GamaRelatedOptions" EnableModelValidation="True" Height="50px" Width="212px" OnDataBound="DetailsView1_DataBound"
                                BorderStyle="None" GridLines="None">
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
                            <asp:SqlDataSource ID="sqldsddlSport" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Addon_Web_PlayerProfile_ddlSport" SelectCommandType="StoredProcedure"></asp:SqlDataSource>

                            <asp:SqlDataSource ID="GamaRelatedOptions" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Addon_Web_PlayerProfile_GamaRelatedOptions" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlProfiles" Name="prmidProfile" PropertyName="SelectedValue" Type="Int32" />
                                    <asp:ControlParameter ControlID="ddlGeneralidSport" Name="prmidSport" PropertyName="SelectedValue" Type="String" />
                                    <asp:ControlParameter ControlID="ddlGeneralIdPeriod" Name="prmidPeriod" PropertyName="SelectedValue" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>

                        <div class="item">
                            <h5><strong>Duplicate Bets Options</strong></h5>
                            <asp:Label ID="Label17" runat="server" Text="Check duplicated bets on"></asp:Label>
                            <div>
                                <asp:CheckBox ID="DuplicateBetsCheckLineChange" runat="server" Text="Line Changes" />
                            </div>
                            <div>
                                <asp:CheckBox ID="DuplicateBetsCheckParlays" runat="server" Text="Parlays" />
                            </div>
                            <div>
                                <asp:CheckBox ID="DuplicateBetsCheckTeasers" runat="server" Text="Teasers" />
                            </div>
                            <div>
                                <asp:CheckBox ID="DuplicateBetsCheckIfbets" runat="server" Text="If Bets" />
                            </div>
                            <div>
                                <asp:CheckBox ID="DuplicateBetsCheckReverses" runat="server" Text="Reverses" />
                            </div>
                            <asp:Label ID="Label10" runat="server" Text="Parlays"></asp:Label>
                            <asp:RadioButtonList ID="rdnGeneralPaylays" runat="server">
                                <asp:ListItem Value="0">Check with Straight Bets</asp:ListItem>
                                <asp:ListItem Value="1">Check with same details</asp:ListItem>
                                <asp:ListItem Value="2">None</asp:ListItem>
                            </asp:RadioButtonList>
                            <asp:Label ID="Label11" runat="server" Text="Teasers"></asp:Label>
                            <asp:RadioButtonList ID="rdnGeneralTeaser" runat="server">
                                <asp:ListItem Value="0">Check with Straight Bets</asp:ListItem>
                                <asp:ListItem Value="1">Check with same details</asp:ListItem>
                                <asp:ListItem Value="2">None</asp:ListItem>
                            </asp:RadioButtonList>
                            <asp:CheckBox ID="DuplicateBetsCheckIfSBRev" Text="Check If Bets & Reverses With Straight Bets" runat="server" />
                        </div>

                        <div class="item">
                            <h5><strong>Free Plays</strong></h5>
                            <div class="form-group">
                                <asp:Label ID="Label12" runat="server" Text="Max Payout"></asp:Label>
                                <asp:TextBox ID="FPMaxPayout" CssClass="toLeft form-control" runat="server"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="Label13" runat="server" Text="Odds Limits"></asp:Label>
                                <asp:TextBox ID="FPOddsLimit" CssClass="toLeft form-control" runat="server"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="Label14" runat="server" Text="Max # of Teams"></asp:Label>
                                <asp:TextBox ID="FPMaxTeams" CssClass="toLeft form-control" runat="server"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="Label15" runat="server" Text="Max # of Favs"></asp:Label>
                                <asp:TextBox ID="FPMaxFav" CssClass="toLeft form-control" runat="server"></asp:TextBox>
                            </div>
                            <asp:CheckBox ID="FPAllowBothSides" runat="server" Text="Allow Both Sides" />
                            <br />
                            <asp:CheckBox ID="FPAllowDuplicatedBets" runat="server" Text="Duplicates Bets" />
                            <br />
                            <asp:CheckBox ID="FPCheckOfficeFilters" runat="server" Text="Check Office Filters" />
                        </div>
                        <div class="item">
                            <h5><strong>Card Limits</strong></h5>
                            <div class="form-group">
                                <asp:Label ID="Label16" runat="server" Text="Max # of Favs"></asp:Label>
                                <asp:TextBox ID="CLMaxWager" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                <asp:CheckBox ID="Soc_Hookups" runat="server" Text="Allow Hookups in Related Soccer Games" />
                                <br />
                                <asp:CheckBox ID="Rev_AllowOpen" runat="server" Text="Allow Open Spots In Reverses" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-pane" role="tabpanel" id="gameType">
                    <div class="masonry-type2">
                        <div class="item">
                            <h5><strong>Free Play Options</strong></h5>
                            <h6><strong>Football</strong></h6>
                            <asp:CheckBox ID="AllowON3NFL" Text="Allow On 3" runat="server" />
                            <asp:CheckBox ID="AllowOFF3NFL" Text="Allow On 3" runat="server" />
                            <asp:CheckBox ID="AllowON7NFL" Text="Allow Off 7" runat="server" />
                            <asp:CheckBox ID="AllowOFF7NFL" Text="Allow Off 7" runat="server" />
                            <h6><strong>College Football</strong></h6>
                            <asp:CheckBox ID="AllowON3CFB" Text="Allow On 3" runat="server" />
                            <asp:CheckBox ID="AllowOFF3CFB" Text="Allow On 3" runat="server" />
                            <asp:CheckBox ID="AllowON7CFB" Text="Allow Off 7" runat="server" />
                            <asp:CheckBox ID="AllowOFF7CFB" Text="Allow Off 7" runat="server" />
                            <asp:Label ID="lblFreeHalf" runat="server" Text="Free &frac12; points"></asp:Label>
                            <asp:TextBox ID="FreeHalfPoints" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                            <h6><strong>Baseball</strong></h6>
                            <asp:CheckBox ID="PL_UseWideLine" Text="Calc Parlays payout with Wideline" runat="server" />
                            <asp:CheckBox ID="UseWideLine" Text="Use Wideline" runat="server" />
                        </div>

                        <div class="item">
                            <h5><strong>Max Times same team can be involved in bets</strong></h5>
                            <asp:CheckBox ID="PL_CheckSameTeam" Text="Check this limit on Parlays, allowing only" runat="server" />
                            <asp:TextBox ID="PL_MaxSameTeam" runat="server" Columns="2"></asp:TextBox>
                            <asp:Label ID="Label19" runat="server" Text="times."></asp:Label>
                            <asp:CheckBox ID="TL_CheckSameTeam" Text="Check this limit on Teasers, allowing only" runat="server" />
                            <asp:TextBox ID="TL_MaxSameTeam" runat="server" Columns="2"></asp:TextBox>
                            <asp:Label ID="Label18" runat="server" Text="times."></asp:Label>
                            <asp:CheckBox ID="IL_CheckSameTeam" Text="Check this limit on If Bets & Reverses, allowing only" runat="server" />
                            <asp:TextBox ID="IL_MaxSameTeam" runat="server" Columns="2"></asp:TextBox>
                            <asp:Label ID="Label20" runat="server" Text="times."></asp:Label>
                        </div>

                        <div class="item">
                            <h5><strong>Max Times same team can be involved in bets</strong></h5>
                            <asp:CheckBox ID="SL_CheckMLnSpread" Text="Check $Line & Spread as same play for Straight bets" runat="server" /><br />
                            <asp:CheckBox ID="PL_CheckMLnSpread" Text="Check $Line & Spread as same play for Parlays" runat="server" /><br />
                            <asp:CheckBox ID="PL_CheckTOnTU" Text="Check Total Over & Under as same play for Parlays" runat="server" /><br />
                            <asp:CheckBox ID="TL_CheckTOnTU" Text="Check Total Over & Under as same play for Teasers" runat="server" /><br />
                            <asp:CheckBox ID="RL_CheckMLnSpread" Text="Check $Line & Spread as same play for Reverses" runat="server" /><br />
                            <asp:CheckBox ID="RL_CheckTOnTU" Text="Check Total Over & Under as same play for Reverses" runat="server" /><br />
                        </div>

                        <div class="item">
                            <h5><strong>Max Points for side total combinations</strong></h5>
                            <div class="form-inline">
                                <div class="form-group">
                                    <asp:Label ID="Label21" runat="server" Text="Sport"></asp:Label>
                                    <asp:DropDownList ID="gtddlIdSport" CssClass="form-control form-control-sm tomlist" AutoPostBack="true" runat="server" OnSelectedIndexChanged="gtddlIdSport_SelectedIndexChanged">
                                        <asp:ListItem>NFL</asp:ListItem>
                                        <asp:ListItem>CFB</asp:ListItem>
                                        <asp:ListItem>NBA</asp:ListItem>
                                        <asp:ListItem>CBB</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label22" runat="server" Text="Bet Type"></asp:Label>
                                    <asp:DropDownList ID="gtddlWagerType" CssClass="form-control form-control-sm tomlist" AutoPostBack="true" runat="server" OnSelectedIndexChanged="gtddlWagerType_SelectedIndexChanged">
                                        <asp:ListItem Value="1">Parlay</asp:ListItem>
                                        <asp:ListItem Value="2">Teaser</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <asp:GridView ID="gvMaxPoints" runat="server" CssClass="table" AutoGenerateColumns="False" DataKeyNames="IdProfile,IdGameType,IdSport,WagerType" DataSourceID="sqldsgvMaxPoints" EnableModelValidation="True" ShowHeader="False" OnDataBound="gvMaxPoints_DataBound" >
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:Label ID="Label23" runat="server" Text="Points Limit"></asp:Label>
                                            <asp:TextBox ID="TextBox8" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("MaxPoints", " {0:N1}") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CheckBox12" Text="Dog Spread / Total Over" runat="server" Checked='<%# Bind("CheckDogOver") %>' />
                                            <br />
                                            <asp:CheckBox ID="CheckBox13" Text="Dog Spread / Total Under" runat="server" Checked='<%# Bind("CheckDogUnder") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CheckBox14" Text="Fav Spread / Total Over" runat="server" Checked='<%# Bind("CheckFavOver") %>' />
                                            <br />
                                            <asp:CheckBox ID="CheckBox15" Text="Fav Spread / Total Under" runat="server" Checked='<%# Bind("CheckFavUnder") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="sqldsgvMaxPoints" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Addon_Web_PlayerProfile_GamaTypeSport" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlProfiles" Name="prmidProfile" PropertyName="SelectedValue" Type="Int32" />
                                    <asp:ControlParameter ControlID="gtIdGameType" DefaultValue="2" Name="prmIdGameType" PropertyName="Value" Type="Int32" />
                                    <asp:ControlParameter ControlID="gtddlIdSport" Name="prmIdSport" PropertyName="SelectedValue" Type="String" />
                                    <asp:ControlParameter ControlID="gtddlWagerType" Name="prmWagerType" PropertyName="SelectedValue" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                        <div class="item">
                            <asp:GridView ID="gvGameTypes" CssClass="table" runat="server" AutoGenerateColumns="False" DataSourceID="sqldsgvGameType" EnableModelValidation="True" OnRowCommand="gvGameTypes_RowCommand" OnDataBound="gvGameTypes_DataBound">
                                <Columns>
                                    <asp:TemplateField SortExpression="Description">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkGvGameType" runat="server" />
                                            <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Eval("IdGameType") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:ButtonField CommandName="btnSelect" DataTextField="Description" HeaderText="GameType" />

                                </Columns>
                                <HeaderStyle CssClass="GameHeader" />
                                <RowStyle CssClass="TrGameOdd" />
                                <AlternatingRowStyle CssClass="TrGameEven" />
                            </asp:GridView>

                            <asp:HiddenField ID="gtIdGameType" runat="server" Value="2" />
                        </div>
                    </div>
                    <div>
                        <div class="row">

                            <div class="col-md-9">

                                <div class="col-md-12">

                                    <div class="col-md-12">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                            </div>
                                        </div>
                                        <div class="col-md-4"></div>
                                    </div>
                                    <div class="col-md-12">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-pane" role="tabpanel" id="straight">
                    <div class="masonry-type2">
                        <div class="item">
                            <h5><strong>Football</strong></h5>
                            <asp:DetailsView ID="dvStraightNFL" runat="server" Height="50px" AutoGenerateRows="False" DataKeyNames="IdProfile,IdSport" DataSourceID="sqldsDVStraightNFL" EnableModelValidation="True" GridLines="None" OnDataBound="dvStraightNFL_DataBound">
                                <Fields>
                                    <asp:TemplateField HeaderText="Spread" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i>  Points Purchase Max" SortExpression="SpreadPointsPurchaseMax">
                                        <ItemTemplate>
                                            <asp:TextBox ID="SpreadPointsPurchaseMax" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("SpreadPointsPurchaseMax") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Price Half Points" SortExpression="SpreadPriceHalfPoints">
                                        <ItemTemplate>
                                            <asp:TextBox ID="SpreadPriceHalfPoints" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("SpreadPriceHalfPoints") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i>  Juice Default" SortExpression="SpreadJuiceDefault">
                                        <ItemTemplate>
                                            <asp:TextBox ID="SpreadJuiceDefault" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("SpreadJuiceDefault") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Points Purchase Max" SortExpression="TotalPointsPurchaseMax">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotalPointsPurchaseMax" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("TotalPointsPurchaseMax") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Price Half Points" SortExpression="TotalPriceHalfPoints">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotalPriceHalfPoints" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("TotalPriceHalfPoints") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Juice Default" SortExpression="TotalJuiceDefault">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotalJuiceDefault" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("TotalJuiceDefault") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Surcharge" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> On 3" SortExpression="On3Surcharge">
                                        <ItemTemplate>
                                            <asp:TextBox ID="On3Surcharge" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("On3Surcharge") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Off 3" SortExpression="Off3Surcharge">
                                        <ItemTemplate>
                                            <asp:TextBox ID="Off3Surcharge" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("Off3Surcharge") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> On 7" SortExpression="On7Surcharge">
                                        <ItemTemplate>
                                            <asp:TextBox ID="On7Surcharge" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("On7Surcharge") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Off 7" SortExpression="Off7Surcharge">
                                        <ItemTemplate>
                                            <asp:TextBox ID="Off7Surcharge" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("Off7Surcharge") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Skip Half Point" SortExpression="SkipHalfPoint">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="SkipHalfPoint" runat="server" Checked='<%# Bind("SkipHalfPoint") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Surcharge" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Buying Through 3pts" SortExpression="SurchargeTwice_3pts">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="SurchargeTwice_3pts" runat="server" Checked='<%# Bind("SurchargeTwice_3pts") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Buying Through 7pts" SortExpression="SurchargeTwice_7pts">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="SurchargeTwice_7pts" runat="server" Checked='<%# Bind("SurchargeTwice_7pts") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Can Buy Points" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> On 3" SortExpression="CanBuyOn3">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CanBuyOn3" runat="server" Checked='<%# Bind("CanBuyOn3") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Off 3" SortExpression="CanBuyOff3">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CanBuyOff3" runat="server" Checked='<%# Bind("CanBuyOff3") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> On 7" SortExpression="CanBuyOn7">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CanBuyOn7" runat="server" Checked='<%# Bind("CanBuyOn7") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Off 7" SortExpression="CanBuyOff7">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CanBuyOff7" runat="server" Checked='<%# Bind("CanBuyOff7") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Fields>
                                <HeaderStyle />
                            </asp:DetailsView>
                        </div>

                        <div class="item">
                            <h5><strong>College Football</strong></h5>
                            <asp:DetailsView ID="dvStraightCFB" runat="server" Height="50px" AutoGenerateRows="False" DataKeyNames="IdProfile,IdSport" DataSourceID="sqldsDVStraightCFB" EnableModelValidation="True" GridLines="None" OnDataBound="dvStraightCFB_DataBound">
                                <Fields>
                                    <asp:TemplateField HeaderText="Spread" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i>  Points Purchase Max" SortExpression="SpreadPointsPurchaseMax">
                                        <ItemTemplate>
                                            <asp:TextBox ID="SpreadPointsPurchaseMax" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("SpreadPointsPurchaseMax") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Price Half Points" SortExpression="SpreadPriceHalfPoints">
                                        <ItemTemplate>
                                            <asp:TextBox ID="SpreadPriceHalfPoints" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("SpreadPriceHalfPoints") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i>  Juice Default" SortExpression="SpreadJuiceDefault">
                                        <ItemTemplate>
                                            <asp:TextBox ID="SpreadJuiceDefault" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("SpreadJuiceDefault") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Points Purchase Max" SortExpression="TotalPointsPurchaseMax">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotalPointsPurchaseMax" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("TotalPointsPurchaseMax") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Price Half Points" SortExpression="TotalPriceHalfPoints">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotalPriceHalfPoints" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("TotalPriceHalfPoints") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Juice Default" SortExpression="TotalJuiceDefault">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotalJuiceDefault" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("TotalJuiceDefault") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Surcharge" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> On 3" SortExpression="On3Surcharge">
                                        <ItemTemplate>
                                            <asp:TextBox ID="On3Surcharge" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("On3Surcharge") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Off 3" SortExpression="Off3Surcharge">
                                        <ItemTemplate>
                                            <asp:TextBox ID="Off3Surcharge" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("Off3Surcharge") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> On 7" SortExpression="On7Surcharge">
                                        <ItemTemplate>
                                            <asp:TextBox ID="On7Surcharge" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("On7Surcharge") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Off 7" SortExpression="Off7Surcharge">
                                        <ItemTemplate>
                                            <asp:TextBox ID="Off7Surcharge" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("Off7Surcharge") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Skip Half Point" SortExpression="SkipHalfPoint">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="SkipHalfPoint" runat="server" Checked='<%# Bind("SkipHalfPoint") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Surcharge" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Buying Through 3pts" SortExpression="SurchargeTwice_3pts">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="SurchargeTwice_3pts" runat="server" Checked='<%# Bind("SurchargeTwice_3pts") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Buying Through 7pts" SortExpression="SurchargeTwice_7pts">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="SurchargeTwice_7pts" runat="server" Checked='<%# Bind("SurchargeTwice_7pts") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Can Buy Points" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> On 3" SortExpression="CanBuyOn3">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CanBuyOn3" runat="server" Checked='<%# Bind("CanBuyOn3") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Off 3" SortExpression="CanBuyOff3">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CanBuyOff3" runat="server" Checked='<%# Bind("CanBuyOff3") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> On 7" SortExpression="CanBuyOn7">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CanBuyOn7" runat="server" Checked='<%# Bind("CanBuyOn7") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Off 7" SortExpression="CanBuyOff7">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CanBuyOff7" runat="server" Checked='<%# Bind("CanBuyOff7") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Fields>
                                <HeaderStyle />
                            </asp:DetailsView>
                        </div>

                        <div class="item">
                            <h5><strong>IfBets</strong></h5>
                            <asp:DetailsView ID="dvStraightifBets" runat="server" Height="50px" AutoGenerateRows="False" DataSourceID="sqldsgbStraightIfBets" EnableModelValidation="True" GridLines="None" OnDataBound="dvStraightifBets_DataBound">
                                <Fields>
                                    <asp:TemplateField HeaderText="Max Number of Parlays" SortExpression="IL_MaxParlays">
                                        <ItemTemplate>
                                            <asp:TextBox ID="IL_MaxParlays" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("IL_MaxParlays") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max Level of Parlays" SortExpression="IL_MaxLevelParlays">
                                        <ItemTemplate>
                                            <asp:TextBox ID="IL_MaxLevelParlays" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("IL_MaxLevelParlays") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max Number of Teasers" SortExpression="IL_MaxTeasers">
                                        <ItemTemplate>
                                            <asp:TextBox ID="IL_MaxTeasers" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("IL_MaxTeasers") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max Level of Teasers" SortExpression="IL_MaxLevelTeasers">
                                        <ItemTemplate>
                                            <asp:TextBox ID="IL_MaxLevelTeasers" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("IL_MaxLevelTeasers") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max Number of Straights" SortExpression="IL_MaxNumberSB">
                                        <ItemTemplate>
                                            <asp:TextBox ID="IL_MaxNumberSB" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("IL_MaxNumberSB") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Odds Limits" SortExpression="ILOddslimit">
                                        <ItemTemplate>
                                            <asp:TextBox ID="ILOddslimit" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("ILOddslimit") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Ask Amount for All Wager" SortExpression="IL_AskAmount">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="IL_AskAmount" runat="server" Checked='<%# Bind("IL_AskAmount") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Allow Higher Child Risk" SortExpression="IL_AllowChildHigher">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="IL_AllowChildHigher" runat="server" Checked='<%# Bind("IL_AllowChildHigher") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Straight " HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>

                                    <asp:TemplateField HeaderText="Allow Action on MLB Total Run Lile" SortExpression="SL_AlwaysActionMLBTotals">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="SL_AlwaysActionMLBTotals" runat="server" Checked='<%# Bind("SL_AlwaysActionMLBTotals") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Fields>
                                <HeaderStyle />
                            </asp:DetailsView>
                            <asp:SqlDataSource ID="sqldsgbStraightIfBets" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Addon_Web_PlayerProfile_StraightLimit_IfBets" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlProfiles" Name="prmidProfile" PropertyName="SelectedValue" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>

                        <div class="item">
                            <h5><strong>Basketball</strong></h5>
                            <asp:DetailsView ID="dvStraightNBA" runat="server" Height="50px" AutoGenerateRows="False" DataKeyNames="IdProfile,IdSport" DataSourceID="sqldsDVStraightNBA" EnableModelValidation="True" GridLines="None" OnDataBound="dvStraightNBA_DataBound">
                                <Fields>
                                    <asp:TemplateField HeaderText="Spread" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i>  Points Purchase Max" SortExpression="SpreadPointsPurchaseMax">
                                        <ItemTemplate>
                                            <asp:TextBox ID="SpreadPointsPurchaseMax" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("SpreadPointsPurchaseMax") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Price Half Points" SortExpression="SpreadPriceHalfPoints">
                                        <ItemTemplate>
                                            <asp:TextBox ID="SpreadPriceHalfPoints" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("SpreadPriceHalfPoints") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i>  Juice Default" SortExpression="SpreadJuiceDefault">
                                        <ItemTemplate>
                                            <asp:TextBox ID="SpreadJuiceDefault" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("SpreadJuiceDefault") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Points Purchase Max" SortExpression="TotalPointsPurchaseMax">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotalPointsPurchaseMax" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("TotalPointsPurchaseMax") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Price Half Points" SortExpression="TotalPriceHalfPoints">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotalPriceHalfPoints" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("TotalPriceHalfPoints") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Juice Default" SortExpression="TotalJuiceDefault">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotalJuiceDefault" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("TotalJuiceDefault") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Skip Half Point" SortExpression="SkipHalfPoint">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="SkipHalfPoint" runat="server" Checked='<%# Bind("SkipHalfPoint") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Fields>
                                <HeaderStyle />
                            </asp:DetailsView>
                        </div>

                        <div class="item">
                            <h5><strong>CollegeBasketball</strong></h5>
                            <asp:DetailsView ID="dvStraightCBB" runat="server" Height="50px" AutoGenerateRows="False" DataKeyNames="IdProfile,IdSport" DataSourceID="sqldsDVStraightCBB" EnableModelValidation="True" GridLines="None" OnDataBound="dvStraightCBB_DataBound">
                                <Fields>
                                    <asp:TemplateField HeaderText="Spread" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i>  Points Purchase Max" SortExpression="SpreadPointsPurchaseMax">
                                        <ItemTemplate>
                                            <asp:TextBox ID="SpreadPointsPurchaseMax" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("SpreadPointsPurchaseMax") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Price Half Points" SortExpression="SpreadPriceHalfPoints">
                                        <ItemTemplate>
                                            <asp:TextBox ID="SpreadPriceHalfPoints" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("SpreadPriceHalfPoints") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i>  Juice Default" SortExpression="SpreadJuiceDefault">
                                        <ItemTemplate>
                                            <asp:TextBox ID="SpreadJuiceDefault" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("SpreadJuiceDefault") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total" HeaderStyle-CssClass="heaerDetailView"></asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Points Purchase Max" SortExpression="TotalPointsPurchaseMax">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotalPointsPurchaseMax" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("TotalPointsPurchaseMax") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Price Half Points" SortExpression="TotalPriceHalfPoints">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotalPriceHalfPoints" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("TotalPriceHalfPoints") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<i class='fa fa-arrow-circle-right'></i> Juice Default" SortExpression="TotalJuiceDefault">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TotalJuiceDefault" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("TotalJuiceDefault") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Skip Half Point" SortExpression="SkipHalfPoint">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="SkipHalfPoint" runat="server" Checked='<%# Bind("SkipHalfPoint") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Fields>
                                <HeaderStyle />
                            </asp:DetailsView>
                        </div>
                    </div>

                </div>
                <div class="tab-pane" role="tabpanel" id="parlayLimits">
                    <h2>Parlay </h2>
                    <div class="masonry-only">
                        <div class="item">
                            <h5><strong>Odds</strong></h5>
                            <asp:GridView ID="gvOdds" runat="server" AutoGenerateColumns="False" CssClass="table table-responsive" DataKeyNames="IdProfile,NumTeams" DataSourceID="sqldsgvOdds" EnableModelValidation="True" OnDataBound="gvMaxPoints_DataBound">
                                <Columns>
                                    <asp:BoundField DataField="NumTeams" HeaderText="Teams" ReadOnly="True" SortExpression="NumTeams" />
                                    <asp:TemplateField HeaderText="Odds" SortExpression="Odds">
                                        <ItemTemplate>
                                            <asp:TextBox ID="Odds" runat="server" CssClass="form-control form-control-sm" Text='<%# Bind("Odds", "{0:N1}") %>'></asp:TextBox>
                                            <asp:HiddenField ID="IdWagerType" runat="server" Value='<%# Eval("IdWagerType") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Extra Juice" SortExpression="ExtraJuice">
                                        <ItemTemplate>
                                            <asp:TextBox ID="ExtraJuice" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("ExtraJuice") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max Risk" SortExpression="MaxRisk">
                                        <ItemTemplate>
                                            <asp:TextBox ID="MaxRisk" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("MaxRisk") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max Payout" SortExpression="MaxPayout">
                                        <ItemTemplate>
                                            <asp:TextBox ID="MaxPayout" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("MaxPayout", "{0:N0}") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max Open Spots" SortExpression="MaxOpenSpots">
                                        <ItemTemplate>
                                            <asp:TextBox ID="MaxOpenSpots" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("MaxOpenSpots") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max Dog Lines" SortExpression="MaxDogLines">
                                        <ItemTemplate>
                                            <asp:TextBox ID="MaxDogLines" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("MaxDogLines") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max $Lines" SortExpression="MaxMoneyLines">
                                        <ItemTemplate>
                                            <asp:TextBox ID="MaxMoneyLines" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("MaxMoneyLines") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max Total Lines" SortExpression="MaxTotalLines">
                                        <ItemTemplate>
                                            <asp:TextBox ID="MaxTotalLines" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("MaxTotalLines") %>'></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <HeaderStyle CssClass="GameHeader" />
                                <RowStyle CssClass="TrGameOdd" />
                                <AlternatingRowStyle CssClass="TrGameEven" />
                            </asp:GridView>
                        </div>
                        <div class="item">
                            <h5><strong>MaxTeams</strong></h5>
                            <asp:DropDownList ID="ddlNumTeams" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm">
                                <asp:ListItem Value="2">2 Team Parlay</asp:ListItem>
                                <asp:ListItem Value="3">3 Team Parlay</asp:ListItem>
                                <asp:ListItem Value="4">4 Team Parlay</asp:ListItem>
                                <asp:ListItem Value="5">5 Team Parlay</asp:ListItem>
                                <asp:ListItem Value="6">6 Team Parlay</asp:ListItem>
                                <asp:ListItem Value="7">7 Team Parlay</asp:ListItem>
                                <asp:ListItem Value="8">8 Team Parlay</asp:ListItem>
                            </asp:DropDownList>
                            <br>
                            <asp:GridView ID="gvMaxTeams" runat="server" CssClass="table table-responsive" AutoGenerateColumns="False" DataKeyNames="IdProfile,IdSport,NumTeams" DataSourceID="sqldsgvMaxTeams" EnableModelValidation="True" OnDataBound="gvMaxPoints_DataBound">
                                <Columns>
                                    <asp:BoundField DataField="IdSport" HeaderText="Sport" ReadOnly="True" SortExpression="IdSport" />
                                    <asp:TemplateField HeaderText="Max Games" SortExpression="MaxGames">
                                        <ItemTemplate>
                                            <asp:TextBox ID="MaxGames" runat="server" CssClass="form-control form-control-sm" Text='<%# Bind("MaxGames") %>' Width="80px"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max Dogs" SortExpression="MaxDogs">
                                        <ItemTemplate>
                                            <asp:TextBox ID="MaxDogs" runat="server" CssClass="form-control form-control-sm" Text='<%# Bind("MaxDogs") %>' Width="80px"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max $Lines" SortExpression="MaxMoneyLines">
                                        <ItemTemplate>
                                            <asp:TextBox ID="MaxMoneyLines" runat="server" CssClass="form-control form-control-sm" Text='<%# Bind("MaxMoneyLines") %>' Width="80px"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Max Total Lines" SortExpression="MaxTotalLines">
                                        <ItemTemplate>
                                            <asp:TextBox ID="MaxTotalLines" runat="server" CssClass="form-control form-control-sm" Text='<%# Bind("MaxTotalLines") %>' Width="80px"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <HeaderStyle CssClass="GameHeader" />
                                <RowStyle CssClass="TrGameOdd" />
                                <AlternatingRowStyle CssClass="TrGameEven" />
                            </asp:GridView>
                        </div>
                    </div>

                    <div class="masonry">
                        <div class="item">
                            <h5><strong>BasicSports</strong></h5>
                            <asp:GridView ID="gvBasicSports" CssClass="table table-responsive" runat="server" AutoGenerateColumns="False" DataKeyNames="IdProfile,IdSport" DataSourceID="sqldsgvBasicSports" EnableModelValidation="True" OnDataBound="gvMaxPoints_DataBound">
                                <Columns>
                                    <asp:BoundField DataField="IdSport" HeaderText="Sport" ReadOnly="True" SortExpression="IdSport" />
                                    <asp:TemplateField HeaderText="Enable" SortExpression="BasicSport">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="BasicSport" runat="server" Checked='<%# Bind("BasicSport") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <HeaderStyle CssClass="GameHeader" />
                                <RowStyle CssClass="TrGameOdd" />
                                <AlternatingRowStyle CssClass="TrGameEven" />
                            </asp:GridView>
                        </div>

                        <div class="item">
                            <h5><strong>ParlayGeneralSettings</strong></h5>
                            <asp:CheckBox ID="PL_TieLoses" runat="server" Text="Ties or Loses" />
                            <br />
                            <asp:CheckBox ID="PL_AllowOpenPlays" runat="server" Text="Allow Open Bets" />
                            <asp:CheckBox ID="PL_LowerUseDefault" runat="server" Text="Use Table Odd Range" />
                            <br />
                            <asp:CheckBox ID="PL_TrueOddsOption" runat="server" Text="If $Line then use true odds" />
                            <asp:CheckBox ID="PL_AllowSpreadTotalHK" runat="server" Text="Allow Spread &amp; Total in Hockey" />
                            <br />
                            <asp:CheckBox ID="PL_AllowSpreadTotalSOC" runat="server" Text="Allow Spread &amp; Total in Soccer" />
                        </div>

                        <div class="item">
                            <h5><strong>Baseball</strong></h5>
                            <asp:CheckBox ID="PL_AlwaysAction" runat="server" Text="Always Action" />
                            <asp:CheckBox ID="PL_AllowRunLineTotal" runat="server" Text="Allow Run Line and Total" />
                        </div>

                        <div class="item">
                            <h5><strong>ParlayFormula</strong></h5>
                            <asp:RadioButtonList ID="PL_ParlayFormula" runat="server">
                                <asp:ListItem Value="0">True Odds</asp:ListItem>
                                <asp:ListItem Value="1">Ro Mild</asp:ListItem>
                                <asp:ListItem Value="2">Ro Total</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>

                        <div class="item">
                            <h5><strong>CheckMaxDogson</strong></h5>
                            <asp:CheckBox ID="PL_MaxDogsSide" runat="server" Text="Side" />
                            <br />
                            <asp:CheckBox ID="PL_MaxDogsTotal" runat="server" Text="Total" />
                            <br />
                            <asp:CheckBox ID="PL_MaxDogsMoney" runat="server" Text="$ Line" />
                        </div>

                        <div class="item">
                            <h5>ExtraSettings</h5>
                            <label>
                                <asp:Label ID="Label2" runat="server" Text="Max Sides"></asp:Label></label>
                            <asp:TextBox ID="PL_MaxGames" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                            <label>
                                <asp:Label ID="Label3" runat="server" Text="Max Buys Points"></asp:Label></label>
                            <asp:TextBox ID="PL_MaxBuyPoints" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                            <label>
                                <asp:Label ID="Label4" runat="server" Text="Max Payout"></asp:Label></label>
                            <asp:TextBox ID="PL_MaxPayout" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                            <label>
                                <asp:Label ID="Label5" runat="server" Text="High Level Buy Points"></asp:Label></label>
                            <asp:TextBox ID="PL_MaxTeamBuyPoints" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                            <label>
                                <asp:Label ID="Label6" runat="server" Text="Odds Default"></asp:Label></label>
                            <asp:TextBox ID="PL_OddsDefault" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                            <label>
                                <asp:Label ID="Label7" runat="server" Text="Odds Limit"></asp:Label></label>
                            <asp:TextBox ID="PL_MaxOdds" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                            <asp:CheckBox ID="PL_UseMaxSumOdds" runat="server" Text="Stop combinatios with odds sum higher than:" />
                            <asp:TextBox ID="PL_MaxSumOdds" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <asp:SqlDataSource ID="sqldsddlAgents" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="AddOn_Agent_GetAgents" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:SessionParameter Name="prmIdAgent" SessionField="SubIdAgent" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqldsddlPlayers" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="AddOn_Agent_GetPlayers" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="ddlAgents" Name="prmIdAgent" PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="sqldsddlProfiles" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Addon_Web_PlayerProfile_GetByAgent" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:SessionParameter Name="prmIDAgent" SessionField="SubIdAgent" Type="Int32" />
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
        <asp:SqlDataSource ID="sqldsgvGameType" runat="server" ConnectionString="<%$ ConnectionStrings:DGSDATAConnectionString %>" SelectCommand="GameType_GetList" SelectCommandType="StoredProcedure"></asp:SqlDataSource>

        <asp:SqlDataSource ID="sqldsDVStraightNFL" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Addon_Web_PlayerProfile_StraightLimit" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="ddlProfiles" Name="prmidProfile" PropertyName="SelectedValue" Type="Int32" />
                <asp:Parameter DefaultValue="NFL" Name="prmIdSport" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="sqldsDVStraightCBB" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Addon_Web_PlayerProfile_StraightLimit" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="ddlProfiles" Name="prmidProfile" PropertyName="SelectedValue" Type="Int32" />
                <asp:Parameter DefaultValue="CBB" Name="prmIdSport" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="sqldsDVStraightCFB" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Addon_Web_PlayerProfile_StraightLimit" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="ddlProfiles" Name="prmidProfile" PropertyName="SelectedValue" Type="Int32" />
                <asp:Parameter DefaultValue="CFB" Name="prmIdSport" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="sqldsDVStraightNBA" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Addon_Web_PlayerProfile_StraightLimit" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="ddlProfiles" Name="prmidProfile" PropertyName="SelectedValue" Type="Int32" />
                <asp:Parameter DefaultValue="NBA" Name="prmIdSport" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>


            </asp:Panel>

    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
        </div>
</asp:Content>
