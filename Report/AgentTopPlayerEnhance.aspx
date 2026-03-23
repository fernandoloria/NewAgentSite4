<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentTopPlayerEnhance.aspx.cs" Inherits="AgentSite4.Report.AgentTopPlayerEnhance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .blacktext {
            color: #000000 !important;
        }



        .specialCheck input[type=checkbox] {
            display: none;
        }

        .specialCheck label:before {
            top: -4px;
            height: 22px;
            border-top: 2px solid #455a64;
            border-left: 2px solid #455a64;
            border-right: 2px solid #455a64;
            border-bottom: 2px solid #455a64;
            -webkit-transform: rotate(40deg);
            -ms-transform: rotate(40deg);
            transform: rotate(0deg);
            -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
            -webkit-transform-origin: 100% 100%;
            -ms-transform-origin: 100% 100%;
            transform-origin: 100% 100%;
        }

        .specialCheck label {
            font-size: 0.9rem !important;
        }

        .stats {
            display: inline-block;
            margin-left: 10px;
        }
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">

        <div class="row page-titles">
            <div class="col-md-12 col-12 align-self-center">
                <h3 class="main-title m-b-0 m-t-0">Top Players</h3>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <label for="txtDateFrom">Initial Date:</label>
                                    <asp:TextBox ID="txtDateFrom" runat="server" class="form-control form-control-sm datepicker"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <label for="txtDateFrom">End Date:</label>
                                    <asp:TextBox ID="txtDateTo" runat="server" class="form-control form-control-sm datepicker"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <asp:Label ID="Label3" runat="server" Text="Sport"></asp:Label>
                                    <asp:DropDownList ID="ddlSport" runat="server" CssClass="form-control form-control-sm tomlist" AutoPostBack="True">
                                        <asp:ListItem Value="ALL">SPORTS</asp:ListItem>
                                        <%-- <asp:ListItem Value="CBB">CBB</asp:ListItem>
                                    <asp:ListItem Value="CFB">CFB</asp:ListItem>
                                    <asp:ListItem Value="MLB">MLB</asp:ListItem>
                                    <asp:ListItem Value="MU">MU</asp:ListItem>
                                    <asp:ListItem Value="NBA">NBA</asp:ListItem>
                                    <asp:ListItem Value="NFL">NFL</asp:ListItem>
                                    <asp:ListItem Value="NHL">NHL</asp:ListItem>
                                    <asp:ListItem Value="PROP">PROP</asp:ListItem>
                                    <asp:ListItem Value="SOC">SOC</asp:ListItem>
                                    <asp:ListItem Value="TNT">TNT</asp:ListItem>--%>
                                        <asp:ListItem Value="LIVE">LIVE BETTING</asp:ListItem>
                                        <asp:ListItem Value="CASINO">CASINO</asp:ListItem>
                                        <asp:ListItem Value="RACING">RACING</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <asp:Label ID="Label13" runat="server" Text="Order by:"></asp:Label>
                                    <asp:DropDownList ID="ddlReportType" runat="server" CssClass="form-control form-control-sm tomlist" AutoPostBack="True">
                                        <asp:ListItem Value="W">Show Winners</asp:ListItem>
                                        <asp:ListItem Value="L">Show Losers</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <label for="txtDateFrom">Number of Players:</label>
                                    <asp:TextBox ID="txtNumberOfPlayers" runat="server" class="form-control form-control-sm datepicker" Text="25"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <br />
                                    <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <asp:Panel runat="server" ID="PnGrids" CssClass="table-responsive col-lg-12">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" EnableModelValidation="True" class="table table-striped table-bordered table-sm color-table info-table hidden-md-down" border="0">
                        <AlternatingRowStyle CssClass="TrGameEven" />
                        <Columns>
                            <asp:BoundField DataField="Player" HeaderText="Player" SortExpression="Player" />
                            <asp:TemplateField HeaderText="" SortExpression="test">
                                <ItemTemplate>
                                    Sports:<br />
                                    Casino:<br />
                                    Horses:<br />
                                    Live Betting:
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Win" SortExpression="winSports">
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("winSports", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("winCasino", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label7" runat="server" Text='<%# Bind("winHorses", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label10" runat="server" Text='<%# Bind("winLiveBetting", "{0:N0}") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Lose" SortExpression="loseSports">
                                <ItemTemplate>
                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("loseSports", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("loseCasino", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label8" runat="server" Text='<%# Bind("loseHorses", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label11" runat="server" Text='<%# Bind("loseLiveBetting", "{0:N0}") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Net" SortExpression="netSports">
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("netSports", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label6" runat="server" Text='<%# Bind("netCasino", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label9" runat="server" Text='<%# Bind("netHorses", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label12" runat="server" Text='<%# Bind("netLiveBetting", "{0:N0}") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="TotalWin" HeaderText="Total Win" ReadOnly="True" SortExpression="TotalWin" DataFormatString="{0:N0}" />
                            <asp:BoundField DataField="TotalLost" HeaderText="Total Lost" ReadOnly="True" SortExpression="TotalLost" DataFormatString="{0:N0}" />
                            <asp:TemplateField HeaderText="" SortExpression="NetSports">
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("NetPer", "{0:N2}%") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Total" HeaderText="Total" ReadOnly="True" SortExpression="Total" DataFormatString="{0:N0}" />
                        </Columns>
                        <HeaderStyle CssClass="GameHeader" />

                    </asp:GridView>
                </asp:Panel>
                <div class="table-responsive">
                    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" EnableModelValidation="True" class="table table-striped table-bordered table-sm color-table info-table d-lg-none" align="center" border="0">
                        <AlternatingRowStyle CssClass="TrGameEven" />
                        <Columns>
                            <asp:TemplateField HeaderText="" SortExpression="test">
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Player") %>'></asp:Label><br />
                                    Sports:<br />
                                    Casino:<br />
                                    Horses:<br />
                                    Live:
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Win" SortExpression="winSports">
                                <ItemTemplate>
                                    <br />
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("winSports", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("winCasino", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label7" runat="server" Text='<%# Bind("winHorses", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label10" runat="server" Text='<%# Bind("winLiveBetting", "{0:N0}") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Lose" SortExpression="loseSports">
                                <ItemTemplate>
                                    <br />
                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("loseSports", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("loseCasino", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label8" runat="server" Text='<%# Bind("loseHorses", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label11" runat="server" Text='<%# Bind("loseLiveBetting", "{0:N0}") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Net" SortExpression="netSports">
                                <ItemTemplate>
                                    <br />
                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("netSports", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label6" runat="server" Text='<%# Bind("netCasino", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label9" runat="server" Text='<%# Bind("netHorses", "{0:N0}") %>'></asp:Label><br />
                                    <asp:Label ID="Label12" runat="server" Text='<%# Bind("netLiveBetting", "{0:N0}") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Totals" SortExpression="netSports">
                                <ItemTemplate>
                                    <br />
                                    Win:
                                <asp:Label ID="Label3" runat="server" Text='<%# Bind("TotalWin", "{0:N0}") %>'></asp:Label><br />
                                    Lose:
                                <asp:Label ID="Label6" runat="server" Text='<%# Bind("TotalLost", "{0:N0}") %>'></asp:Label><br />
                                    Margin:<asp:Label ID="Label9" runat="server" Text='<%# Bind("NetPer", "{0:N2}%") %>'></asp:Label><br />
                                    Total:<asp:Label ID="Label12" runat="server" Text='<%# Bind("Total", "{0:N0}") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle CssClass="GameHeader" />

                    </asp:GridView>
                </div>
            </div>
        </div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Top_Players" SelectCommandType="StoredProcedure" CacheExpirationPolicy="Absolute" OnSelecting="SqlDataSource1_Selecting">
            <SelectParameters>
                <asp:SessionParameter Name="prmIDAgent" SessionField="IdAgent" Type="Int32" />
                <asp:ControlParameter ControlID="ddlSport" Name="prmIdSport" PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="txtDateFrom" Name="prmDateFrom" PropertyName="Text" Type="DateTime" />
                <asp:ControlParameter ControlID="txtDateTo" Name="pormDateTo" PropertyName="Text" Type="DateTime" />
                <asp:ControlParameter ControlID="txtNumberOfPlayers" Name="prmTop" PropertyName="Text" Type="Int32" />
                <asp:ControlParameter ControlID="ddlReportType" Name="ReportType" PropertyName="SelectedValue" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
