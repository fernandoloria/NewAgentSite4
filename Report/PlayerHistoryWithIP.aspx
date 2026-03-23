<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerHistoryWithIP.aspx.cs" Inherits="AgentSite4.Report.PlayerHistoryWithIP" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
       <h3 class="page-title">
        Player History With IP</h3>
    <ul class="page-breadcrumb breadcrumb">
        <li><i class="fa fa-home"></i><a href="../Report/Welcome.aspx" target="mainFrame">Home</a><i
            class="fa fa-angle-right"></i></li><li><a href="#">Player History v2 (With IP)</a></li></ul>
    <table cellspacing="1" cellpadding="1" border="0" class="filter">
        <tr>
            <td>
                Initial Date:
            </td>
            <td>
                <asp:TextBox ID="Date1" runat="server" class="form-control form-control-sm datepicker"></asp:TextBox>
            </td>
            <td>
                End Date:
            </td>
            <td>
                <asp:TextBox ID="Date2" runat="server" class="form-control form-control-sm datepicker"></asp:TextBox>
            </td>
            <td>
                Agent:
            </td>
            <td>
                <asp:DropDownList ID="ddlAgents" runat="server" DataSourceID="SqlDataSource2" DataTextField="Agent" CssClass="form-control form-control-sm tomlist"
                    DataValueField="idAgent" AutoPostBack="True">
                </asp:DropDownList>
            </td>
            <td>
                Player:
            </td>
            <td>
                <asp:DropDownList ID="ddlPlayers" runat="server" DataSourceID="SqlDataSource3" DataTextField="Player" CssClass="form-control form-control-sm tomlist"
                    DataValueField="IdPlayer" AutoPostBack="True">
                </asp:DropDownList>
            </td>
            <td>
                <input type="SUBMIT" value="Submit" name="Submit" class="btnForm" />
            </td>
        </tr>
    </table>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1"
        EnableModelValidation="True" Width="100%" AllowPaging="True" 
        AllowSorting="True" PageSize="50"  onrowdatabound="GridView1_RowDataBound" >
        <AlternatingRowStyle CssClass="TrGameEven" />
        <Columns>
            <asp:BoundField DataField="Player" HeaderText="Player" SortExpression="Player"></asp:BoundField>
            <asp:BoundField DataField="Name" HeaderText="User" SortExpression="Name"></asp:BoundField>
            <asp:BoundField DataField="SettledDate" HeaderText="Settled Date" SortExpression="SettledDate">
            </asp:BoundField>
            <asp:BoundField DataField="TicketNumber" HeaderText="Ticket" SortExpression="TicketNumber">
            </asp:BoundField>
            <asp:BoundField DataField="IdSport" HeaderText="Sport" SortExpression="IdSport">
            </asp:BoundField>
            <asp:BoundField DataField="CompleteDescription" HeaderText="Description" SortExpression="CompleteDescription">
            </asp:BoundField>
            <asp:BoundField DataField="riskWin" HeaderText="Risk/Win" SortExpression="riskWin">
            </asp:BoundField>
            <asp:BoundField DataField="Result" HeaderText="Result" SortExpression="Result"></asp:BoundField>
            <asp:BoundField DataField="PlacedDate" HeaderText="Placed Date" SortExpression="PlacedDate">
            </asp:BoundField>
            <asp:BoundField DataField="IP" HeaderText="IP" SortExpression="IP" />
        </Columns>
        <HeaderStyle CssClass="GameHeader" />
        <RowStyle CssClass="TrGameOdd " />
    </asp:GridView>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
        SelectCommand="AddOn_PlayersHistoryByAgent" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddlAgents" DefaultValue="0" Name="idAgent" PropertyName="SelectedValue"
                Type="Int32" />
            <asp:ControlParameter ControlID="ddlPlayers" Name="idPlayer" PropertyName="SelectedValue"
                Type="Int32" />
            <asp:ControlParameter ControlID="Date1" DefaultValue="" Name="dateFrom" 
                PropertyName="Text" Type="DateTime" />
            <asp:ControlParameter ControlID="Date2" DefaultValue="" Name="dateTo" 
                PropertyName="Text" Type="DateTime" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
        SelectCommand="AddOn_BuildAgentTree" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="prmIDAgent" SessionField="SubIdAgent"
                Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
        SelectCommand="AddOn_GetPlayersDDL" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddlAgents" DefaultValue="0" Name="prmIdAgent" PropertyName="SelectedValue"
                Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    </div>
</asp:Content>
