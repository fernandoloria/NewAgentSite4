<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerDetails.aspx.cs" Inherits="AgentSite4.Report.PlayerDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
        <h4 class="center clr" style="padding: 16px 0px;">- Player Overview &amp; Open Bets -</h4>
    <div class="twocol">
        <div class="col col-half">
            <table cellspacing="0" cellpadding="0" border="0" class="tblBorder fleft fieldValueTable">
                <tbody>
                    <tr class="GameHeaderMain">
                        <th colspan="2">Information</th>
                    </tr>
                    <tr class="GameHeader">
                        <th colspan="2">Player personal and account details</th>
                    </tr>
                    <tr class="TrGameOdd">
                        <td width="50%" class="TitleCell">Player ID</td>
                        <td width="50%">
                            <div style="position: relative;">
                                <asp:Label ID="lblAccount" runat="server" Text=""></asp:Label>
                                <a target="_blank" style="position: relative; left: 10px;" href="LoginAsPlayer.aspx?player=">(LOGIN)</a>
                            </div>
                        </td>
                    </tr>
                    <tr class="TrGameEven">
                        <td class="TitleCell">Password</td>
                        <td>
                            <asp:TextBox ID="txtPassword" runat="server" Text=""></asp:TextBox></td>
                    </tr>
                    <tr class="TrGameOdd">
                        <td class="TitleCell">Name</td>
                        <td>
                            <asp:TextBox ID="txtName" runat="server" Text=""></asp:TextBox></td>
                    </tr>
                    <tr class="TrGameEven">
                        <td class="TitleCell">Under Agent</td>
                        <td>
                            <asp:DropDownList ID="ddlUnderAgent" runat="server" DataSourceID="SqlDataSource1" DataTextField="Agent" DataValueField="idAgent" CssClass="form-control form-control-sm tomlist">
                            </asp:DropDownList>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="col-half col">
            <table cellspacing="0" cellpadding="0" border="0" class="tblBorder fleft paddedTable">
                <tbody>
                    <tr class="GameHeaderMain">
                        <th colspan="4">Performance</th>
                    </tr>
                    <tr class="GameHeader" colspan="8">
                        <th></th>
                        <th>This Week</th>
                        <th>Last Week</th>
                        <th>Lifetime</th>
                    </tr>
                    <tr class="TrGameOdd">
                        <td class="TitleCell">Sports</td>
                        <td><span class="PositiveNumber">
                            <asp:Label ID="lblSportsTW" runat="server" Text=""></asp:Label></span></td>
                        <td><span class="PositiveNumber">
                            <asp:Label ID="lblSportsLw" runat="server" Text=""></asp:Label></span></td>
                        <td><span class="PositiveNumber">
                            <asp:Label ID="lblLifeTime" runat="server" Text=""></asp:Label></span></td>
                    </tr>
                    <tr class="TrGameEven">
                        <td class="TitleCell">Casino</td>
                        <td><span class="PositiveNumber">
                            <asp:Label ID="lblCasinoTW" runat="server" Text=""></asp:Label></span></td>
                        <td><span class="PositiveNumber"><asp:Label ID="lblCasinoLW" runat="server" Text=""></asp:Label></span></td>
                        <td><span class="PositiveNumber"><asp:Label ID="lblCasinoLT" runat="server" Text=""></asp:Label></span></td>
                    </tr>
                    <tr class="TrGameOdd">
                        <td class="TitleCell">Horses</td>
                        <td><span class="PositiveNumber"><asp:Label ID="lblHorsesTW" runat="server" Text=""></asp:Label></span></td>
                        <td><span class="PositiveNumber"><asp:Label ID="lblHorsesLW" runat="server" Text=""></asp:Label></span></td>
                        <td><span class="PositiveNumber"><asp:Label ID="lblHorsesLT" runat="server" Text=""></asp:Label></span></td>
                    </tr>
                    <tr class="TrGameEven">
                        <td class="TitleCell">Total</td>
                        <td><span class="PositiveNumber"><asp:Label ID="lblTotalTW" runat="server" Text=""></asp:Label></span></td>
                        <td><span class="PositiveNumber"><asp:Label ID="lblTotalLW" runat="server" Text=""></asp:Label></span></td>
                        <td><span class="PositiveNumber"><asp:Label ID="lblTotalLT" runat="server" Text=""></asp:Label></span></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <p class="clr"></p>
    </div>
    <div class="twocol">
        <div class="col-half col">
            <table cellspacing="0" cellpadding="0" border="0" class="tblBorder fleft fieldValueTable">
                <tbody>
                    <tr class="GameHeaderMain">
                        <th colspan="2">Balances</th>
                    </tr>
                    <tr class="GameHeader">
                        <th colspan="2">Breakdown of player finances</th>
                    </tr>
                    <tr class="TrGameOdd">
                        <td width="50%" class="TitleCell">Credit Limit
                        </td>
                        <td width="50%"><asp:TextBox ID="txtCreditLimit" runat="server" Text=""></asp:TextBox></td>
                    </tr>
                    <tr class="TrGameEven">
                        <td class="TitleCell">Current Balance
                        </td>
                        <td><asp:Label ID="lblCurrentBalance" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr class="TrGameOdd">
                        <td class="TitleCell">Amount at Risk
                        </td>
                        <td><asp:Label ID="lblAmountatRisk" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr class="TrGameEven">
                        <td class="TitleCell">Available Balance
                        </td>
                        <td><asp:Label ID="lblAvailableBalance" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr class="TrGameOdd">
                        <td class="TitleCell">Free Play
                        </td>
                        <td><asp:Label ID="lblFreePlay" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr class="TrGameEven">
                        <td class="TitleCell">Bonus Points
                        </td>
                        <td><asp:Label ID="lblBonusPoints" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr class="TrGameOdd">
                        <td class="TitleCell">Temporary Credit
                        </td>
                        <td><asp:Label ID="lblTemporaryCreditAmount" runat="server" Text=""></asp:Label><br />
                            <asp:Label ID="lblTemporaryCreditDate" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr class="TrGameEven">
                        <td class="TitleCell">Last Wager
                        </td>
                        <td><asp:Label ID="lblLastWager" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr class="TrGameBottom">
                        <td colspan="2" style="padding: 5px 0 15px 0;">
                            <asp:ImageButton ID="ibtnAdjustment" runat="server" ImageUrl="~/App_Themes/Classic/Icons/bank2.png" />
                            <asp:HyperLink ID="hlkAdjustment" runat="server">ADJUSTMENTS</asp:HyperLink>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="col-half col">
            <table cellspacing="0" cellpadding="0" border="0" class="tblBorder fleft fieldValueTable">
                <tbody>
                    <tr class="GameHeaderMain" colspan="8">
                        <th colspan="2">Settings</th>
                    </tr>
                    <tr class="GameHeader">
                        <th colspan="2">Player access and limit configuration</th>
                    </tr>
                    <tr class="TrGameOdd">
                        <td width="50%" class="TitleCell">Web Enabled
                        </td>
                        <td width="50%"><asp:CheckBox ID="chkOnlineAccess" runat="server" Text=""></asp:CheckBox></td>
                    </tr>
                    <tr class="TrGameEven">
                        <td class="TitleCell">Player Enabled
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control form-control-sm tomlist">
                                <asp:ListItem Value="E">Enabled</asp:ListItem>
                                <asp:ListItem Value="D">Disabled</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr class="TrGameOdd">
                        <td class="TitleCell">Sports Access</td>
                        <td><asp:CheckBox ID="chkEnableSports" runat="server" Text=""></asp:CheckBox></td>
                    </tr>
                    <tr class="TrGameEven">
                        <td class="TitleCell">Casino Access</td>
                        <td><asp:CheckBox ID="chkEnableCasino" runat="server" Text=""></asp:CheckBox></td>
                    </tr>
                    <tr class="TrGameOdd">
                        <td class="TitleCell">Horse Access</td>
                        <td><asp:CheckBox ID="chkEnableHorses" runat="server" Text=""></asp:CheckBox></td>
                    </tr>
                    <tr class="TrGameEven">
                        <td class="TitleCell">Player Watch</td>
                        <td>
                            <asp:CheckBox ID="chkPlayerWatch" runat="server" />
                        </td>
                    </tr>
                    <tr class="TrGameOdd">
                        <td class="TitleCell">Web Max / Min Wager
                        </td>
                        <td><asp:TextBox ID="txtOnlineMaxWager" runat="server" Text="" Width="60px"></asp:TextBox> / <asp:TextBox ID="txtOnlineMinWager" runat="server" Text="" Width="60px"></asp:TextBox></td>
                    </tr>
                    <tr class="TrGameOdd">
                        <td class="TitleCell">Phone Max /Min Wager
                        </td>
                        <td><asp:TextBox ID="txtPhoneMaxWager" runat="server" Text="" Width="60px"></asp:TextBox> / <asp:TextBox ID="txtPhoneMinWager" runat="server" Text="" Width="60px"></asp:TextBox></td>
                    </tr>
                    <tr class="TrGameBottom">
                        <td colspan="10" style="padding: 5px 0 15px 0;">
                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/App_Themes/Classic/Icons/settings.png" />
                            <asp:HyperLink ID="HyperLink1" runat="server">CHANGE SETTINGS</asp:HyperLink>
                       
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <p class="clr"></p>
    </div>
     <h4 class="center clr" style="padding: 16px 0px;">- Open Bets -</h4>
   
    <asp:GridView runat="server" ID="gvOpenBets" CellPadding="4" 
                EnableModelValidation="True" ForeColor="#333333" GridLines="Vertical" 
                Font-Size="12px" AutoGenerateColumns="False" Width="100%">
				<Columns>
                    <asp:BoundField DataField="IdWager" HeaderText="Ticket #" SortExpression="IdWager" />
                    <asp:TemplateField HeaderText="Placed Date" SortExpression="Placed Date">
                        <ItemTemplate>
                            <asp:Literal ID="Literal1" runat="server" Text='<%# Bind("[Placed Date]") %>'></asp:Literal>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Wager Type" HeaderText="Wager Type" SortExpression="Wager Type" />
                    <asp:TemplateField HeaderText="Game Date" SortExpression="Game Date">
                        <ItemTemplate>
                            <asp:Literal ID="Literal2" runat="server" Text='<%# Bind("[Game Date]") %>'></asp:Literal>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Sport" HeaderText="Sport" SortExpression="Sport" />
                    <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
                    <asp:BoundField DataField="Risk/Win" HeaderText="Risk/Win" SortExpression="Risk/Win" />
                    <asp:BoundField DataField="ip" HeaderText="IP" SortExpression="ip" />
                </Columns>
            
                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                <EditRowStyle BackColor="#999999" />
                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <HeaderStyle Font-Bold="True" ForeColor="White" CssClass="GameHeaderMain" />
                <PagerStyle BackColor="#284775" ForeColor="White"/>
                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            </asp:GridView>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="AddOn_DDLAgentTree" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter Name="idAgent" SessionField="idAgent" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    </div>
</asp:Content>
