<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentSettledFigure.aspx.cs" Inherits="AgentSite4.Report.AgentSettledFigure" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
            <ContentTemplate>
                <asp:PlaceHolder ID="ReportHolder" runat="server" />
            </ContentTemplate>
    </div>
</asp:Content>
