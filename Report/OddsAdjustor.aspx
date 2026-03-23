<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="OddsAdjustor.aspx.cs" Inherits="AgentSite4.Report.OddsAdjustor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">


        <div class="row page-titles">
            <div class="col-md-12 col-12 align-self-center">
                <h3 class="main-title m-b-0 m-t-0">Odds Adjustor</h3>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Odds Adjustor</h4>
                        <div class="table-responsive">
                            <table class="table color-table success-table table-bordered table-striped table-sm">
                                <tbody>
                                    <tr>
                                        <td colspan="2" class="text-center">
                                            <asp:Label ID="lblError" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">Agent to Apply</td>
                                        <td align="left">
                                            <asp:DropDownList ID="ddlAgent" CssClass="form-control form-control-sm tomlist" runat="server" AutoPostBack="True">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">Period</td>
                                        <td align="left">
                                            <asp:DropDownList ID="ddlPeriod" CssClass="form-control form-control-sm tomlist" runat="server" AutoPostBack="True">
                                                <asp:ListItem Value="0">GAME</asp:ListItem>
                                                <asp:ListItem Value="1">FIRST HALF</asp:ListItem>
                                                <asp:ListItem Value="2">SECOND HALF</asp:ListItem>
                                                <asp:ListItem Value="99">QUARTERs</asp:ListItem>
                                                <asp:ListItem Value="7">FIRST PERIOD</asp:ListItem>
                                                <asp:ListItem Value="8">SECOND PERIOD</asp:ListItem>
                                                <asp:ListItem Value="9">THIRD PERIOD</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td align="right" style="text-align: center" colspan="2">
                                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" EnableModelValidation="True" class="filter table-bordered" border="0" Width="100%">
                                                <Columns>
                                                    <asp:BoundField DataField="IdSport" HeaderText="Sport" SortExpression="IdSport" />

                                                    <asp:TemplateField HeaderText="Odds Adjustor<br><span style='font-size:10px;'>Spread</span>">
                                                        <EditItemTemplate>
                                                            <asp:Label ID="Label3Spread" runat="server" Text='<%# Eval("OddsAdjustor_Spread") %>'></asp:Label>
                                                        </EditItemTemplate>
                                                        <ItemTemplate>
                                                            <asp:DropDownList ID="ddlAdjustorSpread" runat="server" SelectedValue='<%# Eval("OddsAdjustor_Spread") %>' Text='<%# Eval("OddsAdjustor_Spread") %>' CssClass="form-control form-control-sm tomlist">
                                                                <asp:ListItem Value="-10">-10</asp:ListItem>
                                                                <asp:ListItem Value="-5">-5</asp:ListItem>
                                                                <asp:ListItem Value="-4">-4</asp:ListItem>
                                                                <asp:ListItem Value="-3">-3</asp:ListItem>
                                                                <asp:ListItem Value="-2">-2</asp:ListItem>
                                                                <asp:ListItem Value="-1">-1</asp:ListItem>
                                                                <asp:ListItem Value="0">0</asp:ListItem>
                                                                <asp:ListItem Value="1">1</asp:ListItem>
                                                                <asp:ListItem Value="2">2</asp:ListItem>
                                                                <asp:ListItem Value="3">3</asp:ListItem>
                                                                <asp:ListItem Value="4">4</asp:ListItem>
                                                                <asp:ListItem Value="5">5</asp:ListItem>
                                                                <asp:ListItem Value="10">10</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Odds Adjustor<br><span style='font-size:10px;'>Money Line</span>">
                                                        <EditItemTemplate>
                                                            <asp:Label ID="Label3ML" runat="server" Text='<%# Eval("OddsAdjustor_MoneyLine") %>'></asp:Label>
                                                        </EditItemTemplate>
                                                        <ItemTemplate>
                                                            <asp:DropDownList ID="ddlAdjustorMoneyLine" runat="server" SelectedValue='<%# Eval("OddsAdjustor_MoneyLine") %>' Text='<%# Eval("OddsAdjustor_MoneyLine") %>' CssClass="form-control form-control-sm tomlist">

                                                                <asp:ListItem Value="-10">-10</asp:ListItem>
                                                                <asp:ListItem Value="-5">-5</asp:ListItem>
                                                                <asp:ListItem Value="-4">-4</asp:ListItem>
                                                                <asp:ListItem Value="-3">-3</asp:ListItem>
                                                                <asp:ListItem Value="-2">-2</asp:ListItem>
                                                                <asp:ListItem Value="-1">-1</asp:ListItem>
                                                                <asp:ListItem Value="0">0</asp:ListItem>
                                                                <asp:ListItem Value="1">1</asp:ListItem>
                                                                <asp:ListItem Value="2">2</asp:ListItem>
                                                                <asp:ListItem Value="3">3</asp:ListItem>
                                                                <asp:ListItem Value="4">4</asp:ListItem>
                                                                <asp:ListItem Value="5">5</asp:ListItem>
                                                                <asp:ListItem Value="10">10</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Odds Adjustor<br><span style='font-size:10px;'>Total</span>">
                                                        <EditItemTemplate>
                                                            <asp:Label ID="Label3Total" runat="server" Text='<%# Eval("OddsAdjustor_Total") %>'></asp:Label>
                                                        </EditItemTemplate>
                                                        <ItemTemplate>
                                                            <asp:DropDownList ID="ddlAdjustorTotal" runat="server" SelectedValue='<%# Eval("OddsAdjustor_Total") %>' Text='<%# Eval("OddsAdjustor_Total") %>' CssClass="form-control form-control-sm tomlist">

                                                                <asp:ListItem Value="-10">-10</asp:ListItem>
                                                                <asp:ListItem Value="-5">-5</asp:ListItem>
                                                                <asp:ListItem Value="-4">-4</asp:ListItem>
                                                                <asp:ListItem Value="-3">-3</asp:ListItem>
                                                                <asp:ListItem Value="-2">-2</asp:ListItem>
                                                                <asp:ListItem Value="-1">-1</asp:ListItem>
                                                                <asp:ListItem Value="0">0</asp:ListItem>
                                                                <asp:ListItem Value="1">1</asp:ListItem>
                                                                <asp:ListItem Value="2">2</asp:ListItem>
                                                                <asp:ListItem Value="3">3</asp:ListItem>
                                                                <asp:ListItem Value="4">4</asp:ListItem>
                                                                <asp:ListItem Value="5">5</asp:ListItem>
                                                                <asp:ListItem Value="10">10</asp:ListItem>
                                                            </asp:DropDownList>
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
                                        <td colspan="2">
                                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>" SelectCommand="AddOn_Web_Report_OddsAdjustor_GetOddsByAgent" SelectCommandType="StoredProcedure">
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="ddlAgent" Name="prmIdAgent" PropertyName="SelectedValue" Type="Int32" />
                                                    <asp:ControlParameter ControlID="ddlPeriod" Name="prmPeriod" PropertyName="SelectedValue" Type="Int32" />

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
