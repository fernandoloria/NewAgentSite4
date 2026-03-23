<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Popup.Master" AutoEventWireup="true" CodeBehind="WeeklyBalanceWeekHistoryV2.aspx.cs" Inherits="AgentSite4.Popup.WeeklyBalanceWeekHistoryV2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
    <div class="dgsContent">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server">
            <ProgressTemplate>
                <div class="ProcessDiv">
                    <asp:Image ID="Image1" runat="server" SkinID="ProcessImg" />
                    Generate Report
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <asp:UpdatePanel ID="UpdatePanelReport" runat="server">
            <ContentTemplate>
                <style>
                    .table td, .table th {
                        height: 8px;
                        text-align: Center;
                        vertical-align: middle !important;
                    }
                </style>
                <table style="width: 100%;" cellspacing="0" cellpadding="3" border="0" class="filter table-bordered" align="center">
                    <tbody>
                        <tr class="page-titles">
                            <td colspan="15">
                                <h4>
                                    <asp:Label ID="lblHeader" runat="server"></asp:Label></h4>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <asp:PlaceHolder ID="ReportHolder" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
