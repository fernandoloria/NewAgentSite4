<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="LiveCasinoLimits.aspx.cs" Inherits="AgentSite4.Report.LiveCasinoLimits" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
        <style>
        .newPlayer {
            background-color: #FFFFE0;
        }
    </style>

    <div class="dgsContent">

        <link href="app/bootstrap-switch.min.css" rel="stylesheet" />
        <script type="text/javascript" src="app/bootstrap-switch.min.js"></script>
        <style>
            .eye-icon {
                cursor: pointer;
            }
        </style>



        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row page-titles">
                            <div class="col-md-12 col-12 align-self-center">
                                <h3 class="main-title m-b-0 m-t-0">Live Casino Limits</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <div class="table-responsive">
            <div class="container mt-4">
                <div class="row">
                    <div class="col-md-12">
                        <asp:Label ID="lblError" runat="server"></asp:Label>
                    </div>

                </div>
                <asp:Panel ID="pnAgent" runat="server">
                    <div class="row mt-2">
                        <div class="col-md-3">
                            <label for="ddlAgent">
                                <h2>Agent</h2>
                            </label>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlDistributor" CssClass="form-control form-control-sm tomlist" runat="server" OnSelectedIndexChanged="ddlDistributor_SelectedIndexChanged" AutoPostBack="True" ></asp:DropDownList>

                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlAgent" CssClass="form-control form-control-sm tomlist" runat="server" OnSelectedIndexChanged="ddlAgent_SelectedIndexChanged" AutoPostBack="True" DataSourceID="SqlDataSource2" DataTextField="Agent" DataValueField="IdAgent" OnDataBound="ddlAgent_DataBound"></asp:DropDownList>
                        </div>
                        <div class="col-md-3 text-center">
                            <asp:Button ID="btnRefresh" runat="server" CssClass="btn btn-primary" Text="Search" OnClick="btnRefresh_Click" />
                        </div>
                    </div>
                </asp:Panel>

            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table-dynamic table table-bordered table-striped table-sm" border="0">
                                    <tr>
                                        <td>Apply All</td>
                                        <td>
                                            <asp:TextBox ID="txtAllDailyMaxLoss" runat="server" CssClass="form-control form-control-sm" Placeholder="Daily Max Loss"></asp:TextBox></td>
                                        <asp:RegularExpressionValidator ID="revDailyMaxLoss" runat="server" ControlToValidate="txtAllDailyMaxLoss" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>
                                        <td>
                                            <asp:Button ID="btnApplyDailyMaxLoss" runat="server" Text="Apply" OnClick="ApplyToAllDailyMaxLoss" CssClass="btn btn-primary" ValidationGroup="WeeklyBalanceGroup" /></td>

                                        <td>
                                            <asp:TextBox ID="txtAllDailyMaxWin" runat="server" CssClass="form-control form-control-sm" Placeholder="Daily Max Win"></asp:TextBox></td>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtAllDailyMaxWin" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>

                                        <td>
                                            <asp:Button ID="btnApplyDailyMaxWin" runat="server" Text="Apply" OnClick="ApplyToAllDailyMaxWin" CssClass="btn btn-primary" ValidationGroup="WeeklyBalanceGroup" /></td>

                                        <td>
                                            <asp:TextBox ID="txtAllWeeklyMaxLoss" runat="server" CssClass="form-control form-control-sm" Placeholder="Weekly Max Loss"></asp:TextBox></td>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtAllWeeklyMaxLoss" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>

                                        <td>
                                            <asp:Button ID="btnApplyWeeklyMaxLoss" runat="server" Text="Apply" OnClick="ApplyToAllWeeklyMaxLoss" CssClass="btn btn-primary" ValidationGroup="WeeklyBalanceGroup" /></td>

                                        <td>
                                            <asp:TextBox ID="txtAllWeeklyMaxWin" runat="server" CssClass="form-control form-control-sm" Placeholder="Weekly Max Win"></asp:TextBox></td>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtAllWeeklyMaxWin" Display="Dynamic" ErrorMessage="Positive number required." ValidationExpression="^[0-9]*\.?[0-9]+$" ValidationGroup="WeeklyBalanceGroup"></asp:RegularExpressionValidator>

                                        <td>
                                            <asp:Button ID="btnApplyWeeklyMaxWin" runat="server" Text="Apply" OnClick="ApplyToAllWeeklyMaxWin" CssClass="btn btn-primary" /></td>
                                        <td>
                                            <asp:Button ID="btnApplyAllValues" runat="server" Text="Apply all" OnClick="ApplyAllValues" CssClass="btn btn-primary" ValidationGroup="WeeklyBalanceGroup" />
                                        </td>
                                        <td>
                                            <asp:Button ID="Button1" runat="server" Text="Save All" CssClass="btn btn-primary" OnCommand="btnSaveAll_Command" /></center></td>
                                    </tr>
                                </table>

                                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" EnableModelValidation="True"
                                    OnRowCommand="GridView1_RowCommand" OnRowDataBound="GridView1_RowDataBound" Width="99%" class="table-dynamic table table-bordered table-striped table-sm" align="center" border="0">

                                    <AlternatingRowStyle CssClass="TrGameEven" />

                                    <Columns>
                                        <asp:BoundField DataField="Player" />
                                        <asp:TemplateField HeaderText="Daily Max Loss">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtDailyMaxLoss" runat="server" Text='<%# Bind("DailyMaxLoss") %>' CssClass="form-control form-control-sm" onchange="markRowAsModified(this)"></asp:TextBox>
                                                <asp:HiddenField ID="hfRowModified" runat="server" />
                                                <asp:RangeValidator ID="rv1" runat="server" ControlToValidate="txtDailyMaxLoss" Display="Dynamic" ErrorMessage="Positive number required." MinimumValue="0" MaximumValue="9999999" Type="Integer"></asp:RangeValidator>
                                                <asp:RequiredFieldValidator ID="rfv1" runat="server" ControlToValidate="txtDailyMaxLoss" Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Daily Max Win">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtDailyMaxWin" runat="server" Text='<%# Bind("DailyMaxWin") %>' CssClass="form-control form-control-sm" onchange="markRowAsModified(this)"></asp:TextBox>
                                                <asp:RangeValidator ID="rv2" runat="server" ControlToValidate="txtDailyMaxWin" Display="Dynamic" ErrorMessage="Positive number required." MinimumValue="0" MaximumValue="9999999" Type="Integer"></asp:RangeValidator>
                                                <asp:RequiredFieldValidator ID="rfv2" runat="server" ControlToValidate="txtDailyMaxWin" Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Weekly Max Loss">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtWeeklyMaxLoss" runat="server" Text='<%# Bind("WeeklyMaxLoss") %>' CssClass="form-control form-control-sm" onchange="markRowAsModified(this)"></asp:TextBox>
                                                <asp:RangeValidator ID="rv3" runat="server" ControlToValidate="txtWeeklyMaxLoss" Display="Dynamic" ErrorMessage="Positive number required." MinimumValue="0" MaximumValue="9999999" Type="Integer"></asp:RangeValidator>
                                                <asp:RequiredFieldValidator ID="rfv3" runat="server" ControlToValidate="txtWeeklyMaxLoss" Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Weekly Max Win">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtWeeklyMaxWin" runat="server" Text='<%# Bind("WeeklyMaxWin") %>' CssClass="form-control form-control-sm" onchange="markRowAsModified(this)"></asp:TextBox>
                                                <asp:RangeValidator ID="rv4" runat="server" ControlToValidate="txtWeeklyMaxWin" Display="Dynamic" ErrorMessage="Positive number required." MinimumValue="0" MaximumValue="9999999" Type="Integer"></asp:RangeValidator>
                                                <asp:RequiredFieldValidator ID="rfv4" runat="server" ControlToValidate="txtWeeklyMaxWin" Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:ButtonField ButtonType="Button" Text="Save" CommandName="SaveLimits">
                                            <ControlStyle CssClass="btn btn-primary" />
                                        </asp:ButtonField>
                                    </Columns>
                                    <HeaderStyle CssClass="page-titles" />

                                </asp:GridView>
                                <center>
                                    <asp:Button ID="btnSaveAll" runat="server" Text="Save All" CssClass="btn btn-primary" OnCommand="btnSaveAll_Command" />
                                </center>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <div class="table-responsive">
            <asp:Label ID="lblError2" runat="server"></asp:Label>
        </div>

        <script>

        </script>

    </div>

    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="Agent_GetAgentsOrDistributors" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddlDistributor" DefaultValue="-1" Name="idAgent" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter DefaultValue="false" Name="IsDistributor" Type="Boolean" />
        </SelectParameters>
    </asp:SqlDataSource>
    </div>
</asp:Content>
