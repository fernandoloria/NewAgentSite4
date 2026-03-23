<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Popup.Master" AutoEventWireup="true" CodeBehind="OpenBetsPop.aspx.cs" Inherits="AgentSite4.Popup.OpenBetsPop" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
    <div id="UpdatePanelReport">
        <contenttemplate>
            <asp:Literal ID="ltReportContent" runat="server"></asp:Literal>
            <asp:PlaceHolder ID="ReportHolder" runat="server" />
        </contenttemplate>
    </div>
    <style>
        .table td, .table th {
            height: 8px;
            text-align: Center;
            vertical-align: middle !important;
        }

        .table {
            width: 100%;
        }
    </style>
</asp:Content>
