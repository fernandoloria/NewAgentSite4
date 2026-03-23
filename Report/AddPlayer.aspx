<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AddPlayer.aspx.cs" Inherits="AgentSite4.Report.AddPlayer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <style>
            .eye-icon {
                cursor: pointer;
            }
        </style>
        <div class="dgsContent">

        <div class="table-responsive">
            <div class="container mt-4">
                <div class="row">
                    <div class="col-md-12">
                        <asp:Label ID="lblError" runat="server"></asp:Label>
                    </div>
                </div>

                <div class="row mt-2">
                    <div class="col-md-3">
                        <label for="ddlAgent">Agent</label>
                    </div>
                    <div class="col-md-9">
                        <asp:DropDownList ID="ddlAgent" CssClass="form-control form-control-sm tomlist" runat="server"></asp:DropDownList>
                        <small>
                            <asp:Label ID="lblMensage" runat="server" Text="Agents with at least one player (default values)" Visible="false"></asp:Label>
                        </small>
                    </div>
                </div>

                <div class="row mt-2">
                    <div class="col-md-3">
                        <label for="txtUser">Player account</label>
                    </div>
                    <div class="col-md-9">
                        <asp:TextBox ID="txtUser" CssClass="form-control form-control-sm" runat="server" MaxLength="10"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtUser" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtUser" ErrorMessage="Player username must have between 2 and 10 alphanumeric characters." ValidationExpression="^[a-zA-Z0-9]{2,10}$" Display="Dynamic"></asp:RegularExpressionValidator>
                    </div>
                </div>


                <div class="row mt-2">
                    <div class="col-md-3">
                        <label for="txtPassword">Password</label>
                    </div>
                    <div class="col-md-9">
                        <div class="input-group">
                            <asp:TextBox ID="txtPassword" CssClass="form-control form-control-sm" runat="server" TextMode="Password"></asp:TextBox>
                            <div class="input-group-append">
                                <span class="input-group-text eye-icon" onclick="togglePasswordVisibility('ctl00_MainContent_txtPassword')"><i class="fa fa-eye" id="eyeIcon_txtPassword"></i></span>
                            </div>
                        </div>
                        <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtPassword" ControlToValidate="txtPassword1" ErrorMessage="Password must match" Display="Dynamic"></asp:CompareValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txtPassword" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <div class="row mt-2">
                    <div class="col-md-3">
                        <label for="txtPassword1">Confirm Password</label>
                    </div>
                    <div class="col-md-9">
                        <asp:TextBox ID="txtPassword1" CssClass="form-control form-control-sm" runat="server" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtPassword1" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <div class="row mt-2">
                    <div class="col-md-3">
                        <label for="txtName">Name</label>
                    </div>
                    <div class="col-md-9">
                        <asp:TextBox ID="txtName" CssClass="form-control form-control-sm" runat="server"></asp:TextBox>
                    </div>
                </div>

                <div class="row mt-2">
                    <div class="col-md-3">
                        <label for="txtLastName">Last Name</label>
                    </div>
                    <div class="col-md-9">
                        <asp:TextBox ID="txtLastName" CssClass="form-control form-control-sm" runat="server"></asp:TextBox>
                    </div>
                </div>

                <div class="row mt-2">
                    <div class="col-md-3">
                        <label for="txtCredit">Credit Limit</label>
                    </div>
                    <div class="col-md-9">
                        <asp:TextBox ID="txtCredit" CssClass="form-control form-control-sm" runat="server">0</asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtCredit" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <div class="row mt-2">
                    <div class="col-md-3">
                        <label for="txtMinPlay">Min Wager</label>
                    </div>
                    <div class="col-md-9">
                        <asp:TextBox ID="txtMinPlay" CssClass="form-control form-control-sm" runat="server">10</asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtMinPlay" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <div class="row mt-2">
                    <div class="col-md-3">
                        <label for="txtMaxPlay">Max Wager</label>
                    </div>
                    <div class="col-md-9">
                        <asp:TextBox ID="txtMaxPlay" CssClass="form-control form-control-sm" runat="server">500</asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtMaxPlay" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <div class="row mt-4">
                    <div class="col-md-12 text-center">
                        <asp:Button ID="btnRefresh" runat="server" CssClass="btn btn-primary" Text="Add Player" OnClick="btnRefresh_Click" />
                    </div>
                </div>
            </div>
        </div>
        <div class="table-responsive">
            <asp:Label ID="lblError2" runat="server"></asp:Label>
        </div>


    </div>

    </div>
</asp:Content>
