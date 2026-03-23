<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentAdjustment.aspx.cs" Inherits="AgentSite4.Report.AgentAdjustment" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">    
                <asp:PlaceHolder ID="ReportHolder" runat="server" />
    </div>
</asp:Content>
