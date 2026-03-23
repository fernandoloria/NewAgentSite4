<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="HoldPercentV2.aspx.cs" Inherits="AgentSite4.Report.HoldPercentV2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
        <h3 class="page-title">Hold Percent</h3>
    <ul class="page-breadcrumb breadcrumb">
        <li><i class="fa fa-home"></i><a href="../Report/Welcome.aspx">Home</a> <i class="fa fa-angle-right"></i></li>
        <li><a href="#">Hold Percent</a></li>
    </ul>

    <table cellspacing="1" cellpadding="1" border="0" class="filter">
        <tr>
            <td>Initial Date:</td>
            <td>
                <asp:TextBox ID="txtDateFrom" runat="server" class="form-control form-control-sm datepicker"></asp:TextBox>
            </td>
            <td>End Date:</td>
            <td>
                <asp:TextBox ID="txtDateTo" runat="server" Date2 class="form-control form-control-sm datepicker"></asp:TextBox>
            </td>
            <td>
                <asp:CheckBox ID="chkDetail" runat="server" Text="View Detail" />
            </td>

            <td>&nbsp;</td>

        </tr>
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="Agent"></asp:Label>
            </td>
            <td>
                <asp:DropDownList ID="ddlAgent" runat="server" DataSourceID="SqlDataSource1" CssClass="form-control form-control-sm tomlist"
                    DataTextField="Agent" DataValueField="IdAgent" AutoPostBack="True">
                </asp:DropDownList>
            </td>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Player"></asp:Label>
            </td>
            <td>
                <asp:DropDownList ID="ddlPlayer" runat="server" DataSourceID="SqlDataSource2" CssClass="form-control form-control-sm tomlist"
                    DataTextField="player" DataValueField="idPlayer" OnDataBound="ddlPlayer_DataBound">
                </asp:DropDownList>
            </td>
            <td>
                &nbsp;</td>
            <td>
                <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btnForm"
                    OnClick="btnSubmit_Click" />
            </td>
        </tr>
    </table>
    <asp:Panel runat="server" i ID="PnGrids">
    </asp:Panel>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
        SelectCommand="AddOn_DDLAgent" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter Name="prmIDAgent" SessionField="SubIdAgent"
                Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server"
        ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
        SelectCommand="AddOn_GetPlayersDDL" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddlAgent" Name="prmIdAgent"
                PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    </div>
</asp:Content>
