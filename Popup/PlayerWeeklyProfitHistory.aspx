<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Popup.Master" AutoEventWireup="true" CodeBehind="PlayerWeeklyProfitHistory.aspx.cs" Inherits="AgentSite4.Popup.PlayerWeeklyProfitHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
    <div id="UpdatePanelReport">
        <div id="popup">
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
        </div>
    </div>
</asp:Content>
