<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerProfileLimits.aspx.cs" Inherits="AgentSite4.Report.PlayerProfileLimits" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <style>
            input[type="text"]:disabled {
                background: #dddddd;
            }

            [type="radio"] {
                display: none;
            }

            @media (max-width: 480px) {

                input[type="text"] {
                    width: 40px !important;
                }

                .table {
                    width: 100vw;
                    position: relative;
                    margin-left: -50vw;
                    left: 50%;
                    background: #fff;
                }

                td, th {
                    font-size: 8px;
                }
            }
        </style>

        <script language="JavaScript" type="text/JavaScript">

            function showWagerType() {
                $('.straights').removeClass('hidden-md-down');
                $('.parlays').removeClass('hidden-md-down');
                $('.teasers').removeClass('hidden-md-down');
                $('.reverses').removeClass('hidden-md-down');

                if ($('select[name=wagerType]').val() != 'S') {
                    $('.straights').addClass('hidden-md-down');
                }
                if ($('select[name=wagerType]').val() != 'P') {
                    $('.parlays').addClass('hidden-md-down');
                }
                if ($('select[name=wagerType]').val() != 'T') {
                    $('.teasers').addClass('hidden-md-down');
                }
                if ($('select[name=wagerType]').val() != 'R') {
                    $('.reverses').addClass('hidden-md-down');
                }
            }


        </script>


        <div class="row page-titles">
            <div class="col-md-12 col-12 align-self-center">
                <h3 class="main-title m-b-0 m-t-0">Player Profile Limits</h3>
            </div>
        </div>

        <asp:Panel ID="pnDAtos" runat="server">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group">
                                    <asp:Label ID="Label1" runat="server" Text="Agent"></asp:Label>

                                    <asp:DropDownList ID="ddlAgents" runat="server" DataSourceID="SqlDataSource2"
                                        DataTextField="Agent" DataValueField="IdAgent" AutoPostBack="True"
                                        OnSelectedIndexChanged="ddlAgents_SelectedIndexChanged" CssClass="form-control form-control-sm tomlist">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group">
                                    <asp:Label ID="Players" runat="server" Text="Player:"></asp:Label>

                                    <asp:DropDownList ID="ddlPlayers" runat="server" DataSourceID="SqlDataSource3"
                                        DataTextField="Player" DataValueField="IdPlayer" AutoPostBack="True"
                                        OnSelectedIndexChanged="ddlPlayers_SelectedIndexChanged" CssClass="form-control form-control-sm tomlist">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-3">
                                <div class="form-group">
                                    <asp:Label ID="Players0" runat="server" Text="Change Profile Limits:"></asp:Label>

                                    <asp:DropDownList ID="ddlProfiles" runat="server" DataSourceID="SqlDataSource5"
                                        DataTextField="ProfileName" DataValueField="IdProfileLimits"
                                        OnDataBound="ddlProfiles_DataBound" CssClass="form-control form-control-sm tomlist">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-3">
                                <div class="form-group">
                                    <asp:Button ID="btnCreate" runat="server" Text="Create Custom Profile"
                                        CssClass="btn btn-success" OnClick="btnCreate_Click" />
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group">
                                    <asp:Button ID="btnSetProfile" runat="server" CssClass="btn btn-primary"
                                        OnClick="btnSetProfile_Click" Text="Set Profile" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-4">
                                <div class="form-group">
                                    Sport
                                <asp:DropDownList ID="ddlGameType" runat="server" AutoPostBack="True"
                                    OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged"
                                    DataSourceID="SqlDataSource1" DataTextField="SportName"
                                    DataValueField="IdSport" CssClass="form-control form-control-sm tomlist">
                                </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-4">
                                <div class="form-group">
                                    Options
                        <asp:RadioButton ID="rdnOnline" runat="server" AutoPostBack="True"
                            Checked="True" GroupName="Online" OnCheckedChanged="rdnOnline_CheckedChanged"
                            Style="font-size: large" Text="Online" />
                                    <asp:RadioButton ID="rdnLocal" runat="server" AutoPostBack="True"
                                        GroupName="Online" OnCheckedChanged="rdnLocal_CheckedChanged"
                                        Style="font-size: large" Text="Phone" />
                                    &nbsp;
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-4">
                                <div class="form-group">


                                    <asp:Label runat="server" ID="lblAg" />

                                </div>
                            </div>

                            <div class="col-xs-12 col-sm-12 col-md-2 d-lg-none">
                                <div class="form-group">
                                    <select class="form-control form-control-sm" name="wagerType" id="wagerType" onchange="showWagerType();">
                                        <option value="S" selected="">Side, Total & $Lines</option>
                                        <option value="P">Parlays, Teasers, If Bets,Reverses, Related</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-8">
                                <div class="form-group">
                                    <asp:Label ID="lblWarning" runat="server" Font-Bold="True" Font-Size="Large" ForeColor="Red"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-12">

                                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
                                    DataSourceID="SqlDataSource4" EnableModelValidation="True"
                                    OnDataBound="GridView1_DataBound" CssClass="table-dynamic table table-bordered table-striped table-sm">

                                    <Columns>
                                        <asp:TemplateField HeaderText="Game Type" SortExpression="Description">
                                            <ItemTemplate>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                                                <asp:HiddenField ID="hdfIdGameType" runat="server"
                                                    Value='<%# Eval("IdGameType") %>' />
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:TextBox ID="TextBox1" Width="160px" runat="server" Text='<%# Bind("Description") %>'></asp:TextBox>
                                            </EditItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Side" SortExpression="Side" ItemStyle-CssClass="GameHeaderChartTD straights" HeaderStyle-CssClass="GameHeaderChartTD straights">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtSide" Width="80px" runat="server" Text='<%# Bind("Side", "{0:N0}") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Total" SortExpression="Total" ItemStyle-CssClass="GameHeaderChartTD straights" HeaderStyle-CssClass="GameHeaderChartTD straights">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtTotal" Width="80px" runat="server" Text='<%# Bind("Total", "{0:N0}") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Money Line" SortExpression="MoneyLine" ItemStyle-CssClass="GameHeaderChartTD straights" HeaderStyle-CssClass="GameHeaderChartTD straights">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtMoneyLine" Width="80px" runat="server" Text='<%# Bind("MoneyLine", "{0:N0}") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Parlays" SortExpression="Parlays" ItemStyle-CssClass="GameHeaderChartTD parlays hidden-md-down" HeaderStyle-CssClass="GameHeaderChartTD parlays hidden-md-down">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtParlays" Width="80px" runat="server" Text='<%# Bind("Parlays", "{0:N0}") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Teasers" SortExpression="Teasers" ItemStyle-CssClass="GameHeaderChartTD parlays hidden-md-down" HeaderStyle-CssClass="GameHeaderChartTD parlays hidden-md-down">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtTeasers" Width="80px" runat="server" Text='<%# Bind("Teasers", "{0:N0}") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="If Bets" SortExpression="IfBets" ItemStyle-CssClass="GameHeaderChartTD parlays hidden-md-down" HeaderStyle-CssClass="GameHeaderChartTD parlays hidden-md-down">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtIfBets" Width="80px" runat="server" Text='<%# Bind("IfBets", "{0:N0}") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Reverses" SortExpression="Reverses" ItemStyle-CssClass="GameHeaderChartTD parlays hidden-md-down" HeaderStyle-CssClass="GameHeaderChartTD parlays hidden-md-down">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtReverses" Width="80px" runat="server" Text='<%# Bind("Reverses", "{0:N0}") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Related" SortExpression="Related" ItemStyle-CssClass="GameHeaderChartTD parlays hidden-md-down" HeaderStyle-CssClass="GameHeaderChartTD parlays hidden-md-down">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtRelated" Width="80px" runat="server" Text='<%# Bind("Related", "{0:N0}") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <HeaderStyle CssClass="GameHeader" BackColor="#353852" ForeColor="#FFFFFF" />

                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-12">
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
                                    <div class="form-group" style="text-align: center;">
                                        Amount:
                                 <asp:TextBox ID="txtApplyAll" runat="server" Width="120px"></asp:TextBox>
                                        <asp:Button ID="btnRefresh" runat="server" Text="Apply All" OnClick="btnRefresh_Click"
                                            CssClass="btn btn-primary" />
                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
                                    <div class="form-group" style="text-align: center;">
                                        <asp:Button ID="btnApplyOnlinePhone" runat="server" OnClick="btnApplyOnlinePhone_Click" Text="Save Online & Phone" CssClass="btn btn-warning" />
                                        <asp:Button ID="btnApply" runat="server" OnClick="btnApply_Click" Text="Save" CssClass="btn btn-success" />
                                        <asp:Button ID="btnReset" runat="server" OnClick="btnReset_Click" Text="Reset" CssClass="btn btn-danger" />
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>


                <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                    ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                    SelectCommand="AddOn_GetSports" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server"
                    ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                    SelectCommand="AddOn_Agent_GetAgents"
                    SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:SessionParameter Name="prmIdAgent" SessionField="SubIdAgent"
                            Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource3" runat="server"
                    ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                    SelectCommand="AddOn_Agent_GetPlayers" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="ddlAgents" Name="prmIdAgent"
                            PropertyName="SelectedValue" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource4" runat="server"
                    ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                    SelectCommand="Addon_Web_PlayerProfileLimits"
                    SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="ddlPlayers" Name="prmIdPlayer"
                            PropertyName="SelectedValue" Type="Int32" />
                        <asp:ControlParameter ControlID="ddlGameType" Name="prmIdSport"
                            PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="rdnOnline" Name="prmOnline"
                            PropertyName="Checked" Type="Boolean" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource5" runat="server"
                    ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
                    SelectCommand="Addon_Web_PlayerProfileLimits_GetByAgent"
                    SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:SessionParameter Name="prmIDAgent" SessionField="SubIdAgent"
                            Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
        </asp:Panel>
    </div>
</asp:Content>
