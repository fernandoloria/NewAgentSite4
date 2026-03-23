<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="ManageLines.aspx.cs" Inherits="AgentSite4.Report.ManageLines" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">

        <style>
            #ctl00_MainContent_GridView1 th {
                text-align: center;
            }
        </style>

        <div class="row page-titles">
            <div class="col-md-12 col-12 align-self-center">
                <h3 class="main-title m-b-0 m-t-0">Manage Lines</h3>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Manage Lines</h4>
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
                                            <asp:DropDownList ID="ddlAgent" CssClass="form-control form-control-sm tomlist" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlAgent_Change">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <!--<tr>
                <td align="right">Money Line</td>
                <td align="left">
                    <asp:TextBox CssClass="form-control form-control-sm" ID="txtMoneyLine" runat="server" Text="0"/>
                    <asp:RangeValidator ID="valMoneyLine" ControlToValidate="txtMoneyLine"
                         Type="Integer" MinimumValue="-10000000" MaximumValue="10000000" Display="None"
                         ErrorMessage="$Line must be positive."
                         runat="server"/>
                </td>
            </tr>
            -->
                                    <tr>
                                        <td align="right">Max PROPS/TNT Money Line Limit (cap)</td>
                                        <td align="left">
                                            <asp:TextBox CssClass="form-control form-control-sm" ID="txtMaxMoneyLine" runat="server" Text="0" />
                                            <asp:RangeValidator ID="valMaxMoneyLine" ControlToValidate="txtMaxMoneyLine"
                                                Type="Integer" MinimumValue="-10000000" MaximumValue="10000000" Display="None"
                                                ErrorMessage="$Line must be positive."
                                                runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">Discount Percentage on PROPS/TNT Money Lines </td>
                                        <td align="left">
                                            <asp:TextBox CssClass="form-control form-control-sm" ID="txtDiscountPerc" runat="server" Text="0" />
                                            <asp:RangeValidator ID="valDiscountPerc" ControlToValidate="txtDiscountPerc"
                                                Type="Integer" MinimumValue="0" MaximumValue="100" Display="None"
                                                ErrorMessage="Percentage between 0 and 100."
                                                runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"></td>
                                        <td align="left">
                                            <!--<asp:CheckBox ID="chkApplyAll" runat="server" Text="Apply all Sports" />
                    -->
                                            <asp:Button ID="btnRefresh2" runat="server" CssClass="btn btn-primary" Text="Apply Rule" OnClick="btnRefresh_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" style="text-align: center" colspan="2">
                                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" EnableModelValidation="True" class="filter table-bordered" border="0" Width="100%">
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
                                                    <asp:TemplateField HeaderText="Disable $ lines">
                                                        <EditItemTemplate>
                                                            <asp:Label ID="Label2" runat="server" Text='<%# Eval("disable") %>'></asp:Label>
                                                        </EditItemTemplate>
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="txtMoneyLines2" CssClass="form-control form-control-sm" runat="server" Checked='<%# DataBinder.GetPropertyValue(Container.DataItem,"disable").ToString()=="1" %>'></asp:CheckBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Hide games<br><span style='font-size:10px;'>open X hours before start time</span>">
                                                        <EditItemTemplate>
                                                            <asp:Label ID="Label3" runat="server" Text='<%# Eval("hideLinesUntil") %>'></asp:Label>
                                                        </EditItemTemplate>
                                                        <ItemTemplate>
                                                            <asp:DropDownList ID="ddlHideGameUntil" runat="server" SelectedValue='<%# Eval("hideLinesUntil") %>' Text='<%# Eval("hideLinesUntil") %>' CssClass="form-control form-control-sm tomlist">
                                                                <asp:ListItem Value="0">0</asp:ListItem>
                                                                <asp:ListItem Value="1">1</asp:ListItem>
                                                                <asp:ListItem Value="2">2</asp:ListItem>
                                                                <asp:ListItem Value="3">3</asp:ListItem>
                                                                <asp:ListItem Value="4">4</asp:ListItem>
                                                                <asp:ListItem Value="5">5</asp:ListItem>
                                                                <asp:ListItem Value="8">8</asp:ListItem>
                                                                <asp:ListItem Value="12">12</asp:ListItem>
                                                                <asp:ListItem Value="24">24</asp:ListItem>
                                                                <asp:ListItem Value="36">36</asp:ListItem>
                                                                <asp:ListItem Value="48">48</asp:ListItem>
                                                                <asp:ListItem Value="168">1 week</asp:ListItem>
                                                                <asp:ListItem Value="336">2 weeks</asp:ListItem>
                                                                <asp:ListItem Value="720">1 month</asp:ListItem>
                                                                <asp:ListItem Value="1440">2 months</asp:ListItem>
                                                                <asp:ListItem Value="2160">3 months</asp:ListItem>
                                                                <asp:ListItem Value="4320">6 months</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="open lines by hour<br><span style='font-size:10px;'>Pacific Time</span>">
                                                        <EditItemTemplate>
                                                            <asp:Label ID="LabelOpenLines" runat="server" Text='<%# Eval("openLinesByHour") %>'></asp:Label>
                                                        </EditItemTemplate>
                                                        <ItemTemplate>
                                                            <asp:DropDownList ID="ddlOpenLinesByHour" runat="server" SelectedValue='<%# Eval("openLinesByHour") %>' Text='<%# Eval("openLinesByHour") %>' CssClass="form-control form-control-sm tomlist">
                                                                <asp:ListItem Value="0">Default</asp:ListItem>
                                                                <asp:ListItem Value="5">5am</asp:ListItem>
                                                                <asp:ListItem Value="6">6am</asp:ListItem>
                                                                <asp:ListItem Value="7">7am</asp:ListItem>
                                                                <asp:ListItem Value="8">8am</asp:ListItem>
                                                                <asp:ListItem Value="9">9am</asp:ListItem>
                                                                <asp:ListItem Value="10">10am</asp:ListItem>
                                                                <asp:ListItem Value="11">11am</asp:ListItem>
                                                                <asp:ListItem Value="12">12pm</asp:ListItem>
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
