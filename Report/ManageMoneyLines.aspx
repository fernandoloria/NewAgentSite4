<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="ManageMoneyLines.aspx.cs" Inherits="AgentSite4.Report.ManageMoneyLines" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">

        <div class="row page-titles">
            <div class="col-md-12 col-12 align-self-center">
                <h3 class="main-title m-b-0 m-t-0">Manage Max Money Lines</h3>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Manage Max Money Lines</h4>
                        <div class="table-responsive">
                            <table class="table color-table success-table table-bordered table-striped table-sm">
                                <tbody>
                                    <tr>
                                        <td colspan="2" class="text-center">
                                            <asp:Label ID="lblError" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" colspan="2">The number 0 is used for default, which signifies no moneyline restriction</td>
                                    </tr>
                                    <tr>
                                        <td align="right">Agent to Apply</td>
                                        <td align="left">
                                            <asp:DropDownList ID="ddlAgent" CssClass="form-control form-control-sm tomlist" runat="server" AutoPostBack="True">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">Money Line</td>
                                        <td align="left">
                                            <asp:TextBox CssClass="form-control form-control-sm" ID="txtMoneyLine" runat="server" Text="0" />
                                            <asp:RangeValidator ID="valMoneyLine" ControlToValidate="txtMoneyLine"
                                                Type="Integer" MinimumValue="-10000000" MaximumValue="10000000" Display="None"
                                                ErrorMessage="$Line must be positive."
                                                runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">&nbsp;</td>
                                        <td align="left">
                                            <asp:CheckBox ID="chkApplyAll" runat="server" Text="Apply all Sports" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" style="text-align: center" colspan="2">
                                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" EnableModelValidation="True" class="filter table-bordered" border="0">
                                                <Columns>
                                                    <asp:BoundField DataField="IdSport" HeaderText="Sport" SortExpression="IdSport" />
                                                    <asp:TemplateField HeaderText="$ Line" SortExpression="moneyLine">
                                                        <EditItemTemplate>
                                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("moneyLine") %>'></asp:Label>
                                                        </EditItemTemplate>
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="txtMoneyLines" CssClass="form-control form-control-sm" runat="server" Text='<%# Bind("moneyLine") %>'></asp:TextBox>
                                                            <asp:RangeValidator ID="txtMoneyLine" runat="server" ControlToValidate="txtMoneyLines" Display="None" ErrorMessage="$Line must be positive." MaximumValue="10000000" MinimumValue="-10000000" Type="Integer" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Disable">
                                                        <EditItemTemplate>
                                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("disable") %>'></asp:Label>
                                                        </EditItemTemplate>
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="txtMoneyLines2" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" data-size="small" runat="server" Checked='<%# DataBinder.GetPropertyValue(Container.DataItem,"disable").ToString()=="1" %>' Text='Disable'></asp:CheckBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" colspan="2">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="HideAgentLinesV2_GetbyIdAgent" SelectCommandType="StoredProcedure">
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="ddlAgent" Name="prmIdAgent" PropertyName="SelectedValue" Type="Int32" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                            <asp:Button ID="btnRefresh" runat="server" CssClass="btn btn-primary" Text="Apply Rule" OnClick="btnRefresh_Click" />
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
