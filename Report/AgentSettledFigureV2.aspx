<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentSettledFigureV2.aspx.cs" Inherits="AgentSite4.Report.AgentSettledFigureV2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <h3 class="page-title">Agent Settled Figures</h3>
        <ul class="page-breadcrumb breadcrumb">
            <li><i class="fa fa-home"></i><a href="../Report/Welcome.aspx">Home</a> <i class="fa fa-angle-right"></i></li>
            <li><a href="#">Agent Settled Figures </a></li>
        </ul>

        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1"
            EnableModelValidation="True" OnDataBound="GridView1_DataBound" Width="99%" class="filter table-bordered"
            border="0">
            <AlternatingRowStyle CssClass="TrGameEven" />
            <Columns>
                <asp:BoundField DataField="Player" HeaderText="Player"
                    SortExpression="Player" ReadOnly="True" />
                <asp:BoundField DataField="SettledFigure" HeaderText="SettledFigure"
                    SortExpression="SettledFigure" ReadOnly="True" DataFormatString="{0:N0}"></asp:BoundField>
                <asp:BoundField DataField="CurrentBalance" HeaderText="CurrentBalance"
                    ReadOnly="True" SortExpression="CurrentBalance" DataFormatString="{0:N0}" />
                <asp:BoundField DataField="balance" HeaderText="balance" ReadOnly="True"
                    SortExpression="balance" />
                <asp:BoundField DataField="idplayer" HeaderText="idplayer"
                    SortExpression="idplayer" ReadOnly="True" DataFormatString="{0:N0}" />
            </Columns>
            <HeaderStyle CssClass="GameHeader" />
            <RowStyle CssClass="TrGameOdd " />
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
            SelectCommand="AddOn_SettledFiguresByAgent"
            SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:SessionParameter DefaultValue="" Name="prmIDAgent"
                    SessionField="SubIdAgent" Type="Int32" />
                <asp:Parameter DefaultValue="false" Name="totals" Type="Boolean" />
            </SelectParameters>
        </asp:SqlDataSource>


        <h1>
            <asp:Label ID="lblError" runat="server"></asp:Label></h1>
    </div>
</asp:Content>
