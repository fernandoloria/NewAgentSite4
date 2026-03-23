<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="Marketing.aspx.cs" Inherits="AgentSite4.Report.Marketing" %>

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
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td class="TableBotones" style="height: auto; border: 0;">
                            <asp:HyperLink runat="server" ID="lnlStats" NavigateUrl="?op=0">Stats</asp:HyperLink>
                            <asp:Label runat="server" Text="|" Visible="false" ID="lnkpideTargets" />
                            <asp:HyperLink runat="server" ID="lnkTargets" NavigateUrl="?op=3" Visible="false">Targets</asp:HyperLink>
                            <asp:Label runat="server" Text="|" Visible="false" ID="lnkpideBanners" />
                            <asp:HyperLink runat="server" ID="lnkBanners" NavigateUrl="?op=1" Visible="false">Banners</asp:HyperLink>
                            |
                            <asp:HyperLink runat="server" ID="lnkBannLnk" NavigateUrl="?op=2">Banner Links</asp:HyperLink>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:PlaceHolder runat="server" ID="PH_Content" />
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
