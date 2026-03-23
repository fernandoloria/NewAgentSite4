<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentPlayerCount.aspx.cs" Inherits="AgentSite4.Report.AgentPlayerCount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server">
            <ProgressTemplate>
                <div class="ProcessDiv">
                    <div class="modal" style="display: block !important;" tabindex="-1" role="dialog">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-body text-center">
                                    <h1 style="color: #ff0000;">
                                        <asp:Image ID="Image1" runat="server" SkinID="ProcessImg" />
                                        <i class="mdi mdi-bell"></i>Generating Report</h1>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <asp:UpdatePanel ID="UpdatePanelReport" runat="server">
            <ContentTemplate>
                <asp:PlaceHolder ID="ReportHolder" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
