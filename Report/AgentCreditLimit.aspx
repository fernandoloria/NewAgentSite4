<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentCreditLimit.aspx.cs" Inherits="AgentSite4.Report.AgentCreditLimit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body, input {
            text-transform: uppercase;
            font-weight: 900;
        }

        .specialCheck input[type=checkbox] {
            display: none;
        }

        .specialCheck label:before {
            top: -4px;
            height: 22px;
            border-top: 2px solid #455a64;
            border-left: 2px solid #455a64;
            border-right: 2px solid #455a64;
            border-bottom: 2px solid #455a64;
            -webkit-transform: rotate(40deg);
            -ms-transform: rotate(40deg);
            transform: rotate(0deg);
            -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
            -webkit-transform-origin: 100% 100%;
            -ms-transform-origin: 100% 100%;
            transform-origin: 100% 100%;
        }

        .specialCheck label {
            font-size: 0.9rem !important;
        }

        .stats {
            display: inline-block;
            margin-left: 10px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">



                <div class="row page-titles">
                    <div class="col-md-12 col-12 align-self-center">
                        <h3 class="main-title m-b-0 m-t-0">Agent Credit Limit</h3>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="  table color-table success-table table-bordered table-striped table-sm">
                                        <tbody>
                                            <tr>
                                                <td colspan="2" class="text-center">
                                                    <asp:Label ID="lblError" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" colspan="2" style="color: #ffffff; background-color: #000000 !important;">The number 0 is used for default, which signifies no Player Credit Limit restriction</td>
                                            </tr>
                                            <tr>
                                                <td align="right">Agent to Apply</td>
                                                <td align="left">
                                                    <asp:DropDownList ID="ddlAgent" CssClass="form-control form-control-sm tomlist" runat="server" AutoPostBack="True">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">Credit Limit</td>
                                                <td align="left">
                                                    <asp:TextBox CssClass="form-control form-control-sm" ID="txtMoneyLine" runat="server" Text="0" />
                                                    <asp:RangeValidator ID="valMoneyLine" ControlToValidate="txtMoneyLine"
                                                        Type="Integer" MinimumValue="0" MaximumValue="10000000" Display="None"
                                                        ErrorMessage="Credit Limit must be positive."
                                                        runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">&nbsp;</td>
                                                <td align="left">
                                                    <asp:CheckBox ID="chkApplyAll" runat="server" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" Text="Apply all SubAgents" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right" style="text-align: center" colspan="2">
                                                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" EnableModelValidation="True" class="filter table-bordered" border="0" OnRowCommand="GridView1_RowCommand">
                                                        <Columns>
                                                            <asp:BoundField DataField="Agent" HeaderText="Agent" SortExpression="Agent" />
                                                            <asp:TemplateField HeaderText="Credit Limit" SortExpression="CreditLimit">
                                                                <EditItemTemplate>
                                                                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("CreditLimit") %>'></asp:Label>

                                                                </EditItemTemplate>
                                                                <ItemTemplate>
                                                                    <asp:TextBox ID="txtCreditLimit" CssClass="form-control form-control-sm" runat="server" Text='<%# Eval("CreditLimit", "{0:N0}") %>'></asp:TextBox>
                                                                    <asp:RangeValidator ID="rngCreditLimit" runat="server" ControlToValidate="txtCreditLimit" Display="Dynamic" ErrorMessage='<%# Eval("MaxCreditLimit", "Maximum Credit Limit is {0:N0}") %>' MaximumValue='<%# Eval("MaxCreditLimit", "{0:G0}") %>' MinimumValue="0" />
                                                                    <asp:HiddenField ID="hdfIdAgent" runat="server" Value='<%# Eval("idAgent") %>' />
                                                                    <asp:HiddenField ID="hdfRule" runat="server" Value='<%# Eval("createdBy") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Max Credit Limit">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("maxCreditLimit2", "{0:N0}") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:ButtonField ButtonType="Button" CommandName="btnUpdate" Text="Update Player's Credit Limit">
                                                                <ControlStyle CssClass="btn btn-warning" />
                                                            </asp:ButtonField>
                                                            <asp:ButtonField ButtonType="Button" CommandName="btnSave" Text="Save">
                                                                <ControlStyle CssClass="btn btn-primary" />
                                                            </asp:ButtonField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" colspan="2">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="AgentCreditLimitGetAll" SelectCommandType="StoredProcedure">
                                                        <SelectParameters>
                                                            <asp:ControlParameter ControlID="ddlAgent" Name="prmIdAgent" PropertyName="SelectedValue" Type="Int32" />
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                    <asp:Button ID="btnRefresh" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnRefresh_Click" />
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4"></div>
                </div>

    </div>
</asp:Content>
