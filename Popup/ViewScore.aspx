<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Popup.Master" AutoEventWireup="true" CodeBehind="ViewScore.aspx.cs" Inherits="AgentSite4.Popup.ViewScore" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
    <div id="UpdatePanelReport">
        <div id="popup">
            <asp:PlaceHolder ID="ReportHolder" runat="server" />
        </div>
    </div>
</asp:Content>
