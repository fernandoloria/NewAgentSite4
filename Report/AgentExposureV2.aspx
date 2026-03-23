<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentExposureV2.aspx.cs" Inherits="AgentSite4.Report.AgentExposureV2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server">
            <ProgressTemplate>
                <div class="ProcessDiv">
                    <div class="modal" style="display: block !important;" tabindex="-1" role="dialog">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-body text-center">
                                    <h1 style="color: #ff0000;">
                                        <asp:Image ID="Image1" runat="server" SkinID="ProcessImg" />
                                        <i class="mdi mdi-bell"></i>Generating Report</h1>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <asp:UpdatePanel ID="UpdatePanelReport" runat="server">
            <ContentTemplate>
                <h3 class="page-title">Report Agent Exposure</h3>
                <ul class="page-breadcrumb breadcrumb">
                    <li><i class="fa fa-home"></i><a target="mainFrame" href="../Report/Welcome.aspx">Home</a> <i class="fa fa-angle-right"></i></li>
                    <li><a href="#">Report Agent Exposure</a></li>
                </ul>

                    <script language="JavaScript" src="../App_Themes/Classic/CalendarPopup.js"></script>



                    <table cellspacing="1" cellpadding="1" border="0" class="filter">
                        <tr>

                            <td class="quantity" style="width: 105px">Date From:</td>
                            <td class="quantity">
                                <asp:TextBox ID="txtDateFrom" name="txtDate" runat="server" Cssclass="form-control form-control-sm datepicker"></asp:TextBox>
                            </td>
                            <td style="width: 138px">Date to:</td>
                            <td class="quantity">
                                <asp:TextBox ID="txtDateTo" name="txtDate" runat="server" Cssclass="form-control form-control-sm datepicker"></asp:TextBox>
                            </td>

                            <td align="right">Transaction Type:
                    <asp:DropDownList ID="ddlSports" runat="server" CssClass="form-control form-control-sm tomlist" DataSourceID="SqlDataSource1"
                        DataTextField="SportName" DataValueField="IdSport">
                        <asp:ListItem Value="-1">ALL</asp:ListItem>
                        <asp:ListItem Value="0">SPORT</asp:ListItem>
                        <asp:ListItem Value="1">CASINO</asp:ListItem>
                        <asp:ListItem Value="2">RACING</asp:ListItem>
                    </asp:DropDownList>
                            </td>

                            <td>
                                <asp:Button ID="btnSumit" runat="server" Text="Submit" class="btnForm"
                                    OnClick="btnSumit_Click" />

                            </td>
                        </tr>
                    </table>

                    <table border="0" cellpadding="3" cellspacing="0" class="table-bordered" width="100%">
                        <tr class="GameTopHeader">
                            <td class="GameHeaderChartTD">#</td>
                            <td class="GameHeaderChartTD">Teams</td>
                            <td align="left" class="GameHeaderChartTD" width="20%">
                                <table border="0" width="100%">
                                    <tr class="GameHeader">
                                        <td colspan="3">Straights</td>
                                    </tr>
                                    <tr class="GameHeaderChart">
                                        <td>Spread</td>
                                        <td>Total</td>
                                        <td>$Line</td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" class="GameHeaderChartTD" width="20%">
                                <table border="0" width="100%">
                                    <tr class="GameHeader">
                                        <td colspan="3">Parlays</td>
                                    </tr>
                                    <tr class="GameHeaderChart">
                                        <td>Spread</td>
                                        <td>Total</td>
                                        <td>$Line</td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" class="GameHeaderChartTD" width="20%">
                                <table border="0" width="100%">
                                    <tr class="GameHeader">
                                        <td colspan="3">Teasers</td>
                                    </tr>
                                    <tr class="GameHeaderChart">
                                        <td>Spread</td>
                                        <td>Total</td>
                                        <td>$Line</td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" class="GameHeaderChartTD" width="20%">
                                <table border="0" width="100%">
                                    <tr class="GameHeader">
                                        <td colspan="3">Reverses</td>
                                    </tr>
                                    <tr class="GameHeaderChart">
                                        <td>Spread</td>
                                        <td>Total</td>
                                        <td>$Line</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>

                        <%=builReport()%>


                        </table>
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                            ConnectionString="<%$ ConnectionStrings:DGSDATAConnectionString %>" SelectCommand="Select 'ALL' as IdSport, 'ALL' as SportName, -1 as SportOrder union all Select IdSport, SportName, SportOrder from DGSDATA..SPORT where onlineStatus = 1 order by SportOrder"></asp:SqlDataSource>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
