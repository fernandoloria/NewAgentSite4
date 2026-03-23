<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Popup.Master" AutoEventWireup="true" CodeBehind="CancelWagerPopUp.aspx.cs" Inherits="AgentSite4.Popup.CancelWagerPopUp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
     <div class="UpdatePanelReport">
        <asp:Panel ID="pnDAtos" runat="server">
        <h4 class="card-title">Cancel Wager</h4>
        <div class="formStyle">
            <div class="table-responsive">
                <asp:Table ID="tblResult" runat="server" class="table color-table success-table table-bordered table-striped table-sm hover-table">
                    <asp:TableHeaderRow>
                        <asp:TableHeaderCell>Ticket #</asp:TableHeaderCell>
                        <asp:TableHeaderCell>Player</asp:TableHeaderCell>
                        <asp:TableHeaderCell>Description</asp:TableHeaderCell>
                        <asp:TableHeaderCell>Place Date</asp:TableHeaderCell>
                        <asp:TableHeaderCell>Risk Amount</asp:TableHeaderCell>
                    </asp:TableHeaderRow>


                </asp:Table>

                <asp:Table ID="tblButtons" runat="server" class="table color-table success-table table-bordered table-striped table-sm hover-table">
                    <asp:TableRow>
                        <asp:TableCell colspan="8" class="text-center">
                            <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-danger" Enabled="False" OnClick="btnDelete_Click" Text="Delete" /><br>
                            <br>
                            <input type="button" class="btn btn-default" value="Close" data-bs-dismiss="modal">

                        </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>

                <asp:Label ID="lblError" runat="server" Style="text-align: left" />
            </div>
        </div>
    </asp:Panel>
    </div>
</asp:Content>
