<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="WelcomeReport.aspx.cs" Inherits="AgentSite4.Report.WelcomeReport" %>

<%@ Register Src="~/Controls/Classic/MenuButtonAllReports.ascx" TagPrefix="uc1" TagName="MenuButtonAllReports" %>
<%@ Register Src="~/Controls/Classic/Dashboard.ascx" TagPrefix="uc1" TagName="Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="simple-tab">
        <ul class="nav nav-tabs" id="myTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="home-tab" data-bs-toggle="tab" data-bs-target="#home-tab-pane" type="button" role="tab" aria-controls="home-tab-pane" aria-selected="true">Quick Links</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile-tab-pane" type="button" role="tab" aria-controls="profile-tab-pane" aria-selected="false">Dashboard</button>
            </li>
        </ul>

        <div class="tab-content" id="myTabContent">
            <div class="tab-pane fade show active" id="home-tab-pane" role="tabpanel" aria-labelledby="home-tab" tabindex="0">
                <uc1:MenuButtonAllReports runat="server" ID="MenuButtonAllReports" />
            </div>
            <div class="tab-pane fade" id="profile-tab-pane" role="tabpanel" aria-labelledby="profile-tab" tabindex="0">
                <uc1:Dashboard runat="server" ID="Dashboard" />
            </div>
        </div>
    </div>
</asp:Content>
