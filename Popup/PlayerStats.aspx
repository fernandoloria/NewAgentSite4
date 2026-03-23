<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Popup.Master" AutoEventWireup="true" CodeBehind="PlayerStats.aspx.cs" Inherits="AgentSite4.Popup.PlayerStats" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
    <div id="UpdatePanelReport">
        <asp:HiddenField ID="hdfval" runat="server" />

        <div class="card">
            <table cellspacing="0" cellpadding="2" border="0" width="100%" style="border-bottom: 1px solid #fff;">
                <tbody>
                    <tr class="GameHeader" style="height: 35px;">
                        <td>
                            <div class="stats">
                                Player:
                            <asp:Label ID="lblPlayer1" runat="server" Text=""></asp:Label>
                            </div>
                    </tr>
                </tbody>
            </table>
            <div class="card-body">
                <div class="form-horizontal">
                    <div class="form-group row">
                        <div class="col-3">
                            <label class="text-right control-label col-form-label">Name</label>
                        </div>
                        <div class="col-6">
                            <strong>
                                <asp:Label ID="lblName" runat="server" Text=""></asp:Label></strong>
                        </div>
                        <div class="col-3">
                            <strong>
                                <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label></strong>
                        </div>
                    </div>
                    <div class="form-group row">
                        <div class="col-3">This Week</div>
                        <div class="col-3">
                            <strong>
                                <asp:Label ID="lblthisWeek" runat="server" Text=""></asp:Label></strong>
                        </div>
                        <div class="col-3">Credit Limit</div>
                        <div class="col-3">
                            <strong>
                                <asp:Label ID="lblCreditLimit" runat="server" Text=""></asp:Label></strong>
                        </div>
                    </div>
                    <div class="form-group row">
                        <div class="col-3">Last Week</div>
                        <div class="col-3">
                            <strong>
                                <asp:Label ID="lblLastWeek" runat="server" Text=""></asp:Label></strong>
                        </div>
                        <div class="col-3">Balance</div>
                        <div class="col-3">
                            <strong>
                                <asp:Label ID="lblBalance" runat="server" Text=""></asp:Label></strong>
                        </div>
                    </div>
                    <div class="form-group row">
                        <div class="col-3">Lifetime</div>
                        <div class="col-3">
                            <strong>
                                <asp:Label ID="lblLifetime" runat="server" Text=""></asp:Label></strong>
                        </div>
                        <div class="col-3">At Risk</div>
                        <div class="col-3">
                            <strong>
                                <asp:Label ID="lblAtRisk" runat="server" Text=""></asp:Label></strong>
                        </div>
                    </div>
                    <div class="form-group row">
                        <br />

                    </div>

                    <div class="form-group row">
                        <div class="col-3" style="text-align: center;">
                            <button type="button" class="btn btn-warning" language="javascript" onclick="OpenEditPlayer('<%=IdPlayer %>')">
                                <i class="fa fa-pencil-square" aria-hidden="true"></i>
                                <br />
                                Edit</button>
                        </div>
                        <div runat="server" id="divPayment" class="col-3" style="text-align: center;">
                            <button type="button" class="btn btn-success" language="javascript" onclick="OpenPlayerPayment('<%=IdPlayer %>')">
                                <i class="fa fa-usd" aria-hidden="true"></i>
                                <br />
                                Payment</button>
                        </div>
                        <div runat="server" id="divMessage" class="col-3" style="text-align: center;">
                            <button type="button" class="btn btn-primary" language="javascript" onclick="OpenPlayerMessage('<%=IdPlayer %>')">
                                <i class="fa fa-envelope" aria-hidden="true"></i>
                                <br />
                                Message</button>
                        </div>
                        <div class="col-3" style="text-align: center;">
                            <button type="button" class="btn btn-inverse waves-effect waves-light" language="javascript" data-bs-dismiss="modal">
                                <i class="fa fa-times" aria-hidden="true"></i>
                                <br />
                                Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            function getUrlVars() {
                var vars = [], hash;
                var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for (var i = 0; i < hashes.length; i++) {
                    hash = hashes[i].split('=');
                    vars.push(hash[0]);
                    vars[hash[0]] = hash[1];
                }
                return vars;
            }

        </script>
    </div>
</asp:Content>
