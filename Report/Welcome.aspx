<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="Welcome.aspx.cs" Inherits="AgentSite4.Report.Welcome" %>
<%@ Register Src="~/Controls/Classic/Dashboard.ascx" TagPrefix="uc1" TagName="Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

                <uc1:Dashboard runat="server" ID="Dashboard" />

</asp:Content>
