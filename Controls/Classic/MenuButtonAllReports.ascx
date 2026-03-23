<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MenuButtonAllReports.ascx.cs" Inherits="AgentSite4.Controls.MenuButtonAllReports" %>
<div class="row">
<asp:Repeater ID="filesRepeater" runat="server">
    <ItemTemplate>
        <div class="col-2">
            <div class="card">
                <div class="card-body">
                    <asp:HyperLink runat="server"
                        NavigateUrl='<%# "~/Report/" + Container.DataItem %>'
                        Text='<%# System.Text.RegularExpressions.Regex.Replace(System.IO.Path.GetFileNameWithoutExtension((string)Container.DataItem), "([a-z])([A-Z])", "$1 $2") %>'>
                    </asp:HyperLink>
                </div>
            </div>
        </div>
    </ItemTemplate>
</asp:Repeater>
</div>