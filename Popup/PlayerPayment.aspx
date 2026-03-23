<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Popup.Master" AutoEventWireup="true" CodeBehind="PlayerPayment.aspx.cs" Inherits="AgentSite4.Popup.PlayerPayment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
     <div class="dgsContent">
       
            <ContentTemplate>
                <asp:PlaceHolder ID="ReportHolder" runat="server" />
            </ContentTemplate>

    </div>
</asp:Content>
