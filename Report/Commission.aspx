<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="Commission.aspx.cs" Inherits="AgentSite4.Report.Commission" %>

<%@ Register Src="~/Controls/Classic/Commission.ascx" TagPrefix="uc1" TagName="Commission" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <uc1:Commission runat="server" ID="Commission1" />
       <div id="commission">
    </div>
	<script>
		agent = document.getElementById("agent").value;
    </script>
</asp:Content>
