<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="TicketWriter.aspx.cs" Inherits="AgentSite4.Report.TicketWriter" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        iframe {
            border: none;
            width: 100%;
            height: 100%;
        }
    </style>
    <iframe src="/Betslip/Default.aspx" ></iframe>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Footer" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
