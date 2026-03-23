<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AddAgent.aspx.cs" Inherits="AgentSite4.Report.AddAgent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
            <ContentTemplate>
                <div class="row">
                    <asp:Label ID="lblError" runat="server"></asp:Label>
                </div>
                <div class="row">

                    <div class="col-md-4 card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-lg-12">
                                    <h3>Add Agent</h3>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label>Distributor</label>

                                        <asp:DropDownList ID="ddlAgent" CssClass="form-control form-control-sm tomlist" runat="server">
                                        </asp:DropDownList>
                                    </div>
                                    <div class="form-group">
                                        <label>Agent Account</label>
                                        <asp:TextBox ID="txtUser" runat="server" class="form-control form-control-sm" placeholder="Agent account"></asp:TextBox>
                                        <p class="help-block">
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="None" ControlToValidate="txtUser" ErrorMessage="Agent Username Required"></asp:RequiredFieldValidator>
                                        </p>
                                    </div>
                                    <div class="form-group">
                                        <label>Password</label>
                                        <div class="input-group">
                                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" class="form-control form-control-sm" placeholder="Password"></asp:TextBox>
                                            <div class="input-group-append">
                                                <span class="input-group-text eye-icon" onclick="togglePasswordVisibility('ctl00_MainContent_txtPassword')"><i class="fa fa-eye" id="eyeIcon_txtPassword1"></i></span>
                                            </div>
                                        </div>
                                        <p class="help-block">
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" Display="None" ControlToValidate="txtPassword" ErrorMessage="Agent Password Required"></asp:RequiredFieldValidator>
                                        </p>
                                        <p class="help-block">
                                            <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtPassword" ControlToValidate="txtPassword1" Display="None" ErrorMessage="Password must match">*</asp:CompareValidator>
                                        </p>
                                    </div>
                                    <div class="form-group">
                                        <label>Confirm Password</label>
                                        <asp:TextBox ID="txtPassword1" runat="server" TextMode="Password" class="form-control form-control-sm" placeholder="Confirm password"></asp:TextBox>
                                        <p class="help-block">
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="None" ControlToValidate="txtPassword1" ErrorMessage="Confirm Password Required">*</asp:RequiredFieldValidator>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4 card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-lg-12">
                                    <h3>Agent Info</h3>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label>Name</label>
                                        <asp:TextBox ID="txtName" runat="server" class="form-control form-control-sm" placeholder="Name" value="."></asp:TextBox>
                                        <p class="help-block">
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Display="None" ControlToValidate="txtName" ErrorMessage="Agent Name Required"></asp:RequiredFieldValidator>
                                        </p>
                                    </div>
                                    <div class="form-group">
                                        <label>Last Name</label>
                                        <asp:TextBox ID="txtLastName" runat="server" class="form-control form-control-sm" placeholder="Last name" value="."></asp:TextBox>
                                        <p class="help-block">
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="None" ControlToValidate="txtLastName" ErrorMessage="Lastname Required"></asp:RequiredFieldValidator>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-lg-12">
                                    <h3>Other Settings</h3>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label>Inherit Settings</label>
                                        <asp:DropDownList ID="ddlAgentCloneRights" CssClass="form-control form-control-sm tomlist" runat="server">
                                        </asp:DropDownList>
                                        <div class="form-group">
                                            <asp:CheckBox ID="chkCloneRights" runat="server" AutoPostBack="false" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" Text="Clone Rights" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="col-xs-6">
                                            <asp:CheckBox ID="chkDistributor" runat="server" AutoPostBack="false" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" Text="Distributor" />
                                        </div>
                                        <div class="col-xs-6">
                                            <asp:CheckBox ID="ckCarryPlayersBalance" runat="server" AutoPostBack="false" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" Text="Carry Over Player Balances" />
                                        </div>

                                        <asp:ValidationSummary ID="valSum" class="help-block" DisplayMode="BulletList" runat="server" HeaderText="Error:" Font-Names="verdana" Font-Size="12" />
                                    </div>
                                    <asp:Button ID="btnRefresh" runat="server" CssClass="btn btn-primary" Text="Add Agent" OnClick="btnRefresh_Click" />

                                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGSDATAConnectionString %>" SelectCommand="SELECT [IdLineType], [Description] FROM [LINETYPE]"></asp:SqlDataSource>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </ContentTemplate>
    </div>
</asp:Content>
