<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerPaymentPopUp.aspx.cs" Inherits="AgentSite4.Report.PlayerPaymentPopUp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <br />
        <asp:Literal runat="server" ID="error"></asp:Literal>
        <table border="0" cellpadding="1" cellspacing="0" class="table-bordered" width="100%">
            <tr>
                <td width="30%">
                    <table border="0" cellpadding="1" cellspacing="0" width="100%">
                        <tr>
                            <td>Account</td>
                            <td>
                                <asp:DropDownList ID="ddlPlayer" runat="server" DataSourceID="SqlDataSource1" CssClass="form-control form-control-sm tomlist"
                                    DataTextField="Player" DataValueField="IdPlayer" OnDataBound="ddlPlayer_DataBound"
                                    OnSelectedIndexChanged="ddlPlayer_SelectedIndexChanged">
                                </asp:DropDownList>

                            </td>
                        </tr>
                        <tr>
                            <td>Password:</td>
                            <td>
                                <asp:Label ID="lblPassword" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>Amount</td>
                            <td>
                                <asp:TextBox ID="txtAmount" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Method</td>
                            <td>
                                <asp:DropDownList ID="ddlPaymentMethod" runat="server" DataSourceID="SqlDataSource2" CssClass="form-control form-control-sm tomlist"
                                    DataTextField="PaymentMethod" DataValueField="IdPaymentMethod">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">Description</td>
                            <td>
                                <asp:TextBox ID="txtDescription" runat="server" Text="Agent Payment"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">Reference</td>
                            <td>
                                <asp:TextBox ID="txtReference" runat="server" TextMode="MultiLine"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>Transaction Type</td>
                            <td>


                                <asp:DropDownList ID="ddlTransactionType" runat="server" AutoPostBack="False" CssClass="form-control form-control-sm tomlist">
                                </asp:DropDownList>
                        </tr>
                        <tr>
                            <td>Transaction Date*</td>
                            <td>
                                <asp:TextBox ID="txtDate" name="txtDate" runat="server" Cssclass="form-control form-control-sm datepicker"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="font-size: 12px; color: #666;">
                                <asp:RangeValidator ID="RangeValidator1" runat="server" Type="Date"
                                    ErrorMessage="RangeValidator" ControlToValidate="txtDate"></asp:RangeValidator>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="font-size: 12px; color: #666;">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="2" style="font-size: 12px; color: #666;">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="2" style="font-size: 12px; color: #666;">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="2" style="font-size: 12px; color: #666;">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="2" style="font-size: 12px; color: #666;">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="2" style="font-size: 12px; color: #666;">&nbsp;</td>
                        </tr>
                        <tr>
                            <td></td>
                        </tr>
                    </table>
                </td>
                <td width="40%">
                    <table border="0" cellpadding="1" cellspacing="0" class="TableStatistic table-bordered" width="75%">
                        <tr class="GameHeader">
                            <td align="center">Player Statistics</td>
                        </tr>
                        <tr>
                            <td align="left" style="text-align: center">
                                <asp:DetailsView ID="DetailsView1" runat="server"
                                    Height="50px" Width="100%" AutoGenerateRows="False"
                                    DataSourceID="SqlDataSource3" EnableModelValidation="True"
                                    Style="margin-left: 0px">
                                    <AlternatingRowStyle CssClass="TrGameOdd" />
                                    <Fields>
                                        <asp:BoundField DataField="CurrentBalance" DataFormatString="{0:N2}" HeaderText="Current Balance"
                                            SortExpression="CurrentBalance" />
                                        <asp:BoundField DataField="ThisWeekSports" DataFormatString="{0:N2}" HeaderText="ThisWeekSports"
                                            SortExpression="ThisWeekSports" />
                                        <asp:BoundField DataField="ThisWeekCasino" DataFormatString="{0:N2}" HeaderText="ThisWeekCasino"
                                            SortExpression="ThisWeekCasino" />
                                        <asp:BoundField DataField="ThisWeekHorses" DataFormatString="{0:N2}" HeaderText="ThisWeekHorses"
                                            SortExpression="ThisWeekHorses" />
                                        <asp:BoundField DataField="LastWeekSports" DataFormatString="{0:N2}" HeaderText="LastWeekSports"
                                            SortExpression="LastWeekSports" />
                                        <asp:BoundField DataField="LastWeekCasino" DataFormatString="{0:N2}" HeaderText="LastWeekCasino"
                                            SortExpression="LastWeekCasino" />
                                        <asp:BoundField DataField="LastWeekHorses" DataFormatString="{0:N2}" HeaderText="LastWeekHorses"
                                            SortExpression="LastWeekHorses" />
                                        <asp:BoundField DataField="YTDWin" DataFormatString="{0:N2}" HeaderText="YTD Win"
                                            SortExpression="YTDWin" />
                                        <asp:BoundField DataField="YTDLose" DataFormatString="{0:N2}" HeaderText="YTD Lose"
                                            SortExpression="YTDLose" />
                                        <asp:BoundField DataField="LifetimeWin" DataFormatString="{0:N2}" HeaderText="Lifetime Win"
                                            SortExpression="LifetimeWin" />
                                        <asp:BoundField DataField="LifeTimeLose" DataFormatString="{0:N2}" HeaderText="LifeTime Lose"
                                            SortExpression="LifeTimeLose" />
                                        <asp:BoundField DataField="AccountOpened" DataFormatString="{0:MM/dd/yyyy}" HeaderText="Account Opened"
                                            SortExpression="AccountOpened" />
                                        <asp:BoundField DataField="LastModification" DataFormatString="{0:MM/dd/yyyy}" HeaderText="Last Modification"
                                            SortExpression="LastModification" />

                                        <asp:BoundField DataField="LastWager" DataFormatString="{0:MM/dd/yyyy}" HeaderText="LastWager"
                                            SortExpression="LastWager" />

                                    </Fields>
                                    <RowStyle CssClass="TrGameEven" />
                                </asp:DetailsView>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="center" colspan="2">
                    <input onclick="window.opener.location.reload(); window.close();" type="button" value="Close">
                    <asp:Button ID="Button1" runat="server" Text="Submit"
                        OnClick="Button1_Click" />
                </td>
            </tr>
        </table>

        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:DGSDATAConnectionString %>"
            SelectCommand="SELECT * FROM PLAYERSTATISTIC WHERE (idPlayer = @idPlayer)">
            <SelectParameters>
                <asp:ControlParameter ControlID="ddlPlayer" Name="idPlayer"
                    PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
            SelectCommand="GetPlayersByIdAgent" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:SessionParameter Name="idAgent" SessionField="SubIdAgent" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:DGSDATAConnectionString %>"
            SelectCommand="select * from PAYMENTMETHOD order by PAYMENTMETHOD"></asp:SqlDataSource>
    </div>
</asp:Content>
