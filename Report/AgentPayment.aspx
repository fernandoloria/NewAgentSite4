<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentPayment.aspx.cs" Inherits="AgentSite4.Report.AgentPayment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .popup {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }

        .overlay {
            position: absolute;
            top: 0px;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: #000;
            opacity: 0.8;
            z-index: 0;
        }

        #dialog {
            background-color: #fff;
            z-index: 999;
            position: relative;
            width: 440px;
            top: 40%;
            left: 50%;
            margin-left: -15%;
        }

        @media only screen and (max-width: 400px) {
            #dialog {
                width: 100%;
                left: 0px;
                margin-left: UNSET;
            }

            .row {
                margin-right: unset;
                margin-left: unset;
            }
        }
    </style>
    <script>
        function showpopup() {
            $('.popup').fadeIn();
        }

        function hidepopup() {
            $('.popup').fadeOut();
        }

        $(function () {
            $(".datepicker").datepicker();
        });


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <asp:Panel ID="pnForm" runat="server">


                            <div class="row">

                                <div class="col-md-4 col-sm-12 offset-md-2">
                                    <table style="width: 100%;">
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label1" runat="server" Text="Type:"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlTransactionType" runat="server" AutoPostBack="True"
                                                    OnDataBound="ddlTransactionType_DataBound"
                                                    OnSelectedIndexChanged="ddlTransactionType_SelectedIndexChanged"
                                                    CssClass="form-control form-control-sm tomlist">
                                                    <asp:ListItem Value="A">Adjustment</asp:ListItem>
                                                    <asp:ListItem Value="R">Receipts</asp:ListItem>
                                                    <asp:ListItem Value="D">Disbursements</asp:ListItem>
                                                    <asp:ListItem Value="T">Transfer</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label7" runat="server" Text="Agent:"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlAgent" runat="server" AutoPostBack="True"
                                                    DataSourceID="SqlDataSource1" DataTextField="Agent" DataValueField="IdAgent"
                                                    OnDataBound="ddlAgent_DataBound"
                                                    OnSelectedIndexChanged="ddlAgent_SelectedIndexChanged"
                                                    OnTextChanged="ddlAgent_TextChanged"
                                                   CssClass="form-control form-control-sm tomlist">
                                                </asp:DropDownList>
                                                <asp:CheckBox ID="CheckBox1" runat="server" AutoPostBack="True"
                                                    OnCheckedChanged="CheckBox1_CheckedChanged" Text="From Master"
                                                    Visible="False" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label8" runat="server" Text="To Agent:"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlAgentTo" runat="server" AutoPostBack="True"
                                                    DataSourceID="SqlDataSource1" DataTextField="Agent" DataValueField="IdAgent"
                                                    Enabled="False" OnDataBound="ddlAgentTo_DataBound"
                                                    OnSelectedIndexChanged="ddlAgentTo_SelectedIndexChanged"
                                                   CssClass="form-control form-control-sm tomlist">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label2" runat="server" Text="Date:"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDate" runat="server" CssClass="form-control datepicker form-control-sm"></asp:TextBox>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label3" runat="server" Text="Amount:"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtAmount" runat="server" OnTextChanged="txtAmount_TextChanged" CssClass="form-control form-control-sm"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                                    ControlToValidate="txtAmount" ErrorMessage="*"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label4" runat="server" Text="Payment Method:"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlPaymentMethod" runat="server"
                                                    DataSourceID="SqlDataSource2" DataTextField="PaymentMethod"
                                                    DataValueField="IdPaymentMethod" Enabled="False" CssClass="form-control form-control-sm tomlist">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label5" runat="server" Text="Description:"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                                    ControlToValidate="txtDescription" ErrorMessage="*"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label6" runat="server" Text="Reference:"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtReference" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                                                    ControlToValidate="txtAmount" ErrorMessage="Amount must be a number"
                                                    ValidationExpression="^-?(([1-9]\d*)|0)(.0*[1-9](0*[1-9])*)?$"></asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                            <td>
                                                <asp:Button ID="Button1" runat="server" CssClass="btn btn-success" OnClick="Button1_Click" Text="Submit" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="col-md-4 col-sm-12">
                                    <asp:Label ID="lblAgent1" runat="server"></asp:Label>
                                    <table style="width: 100%;">

                                        <tr style="vertical-align: top;">
                                            <td style="vertical-align: top;">
                                                <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False"
                                                    DataKeyNames="IdAgent" DataSourceID="SqlDataSource3" EnableModelValidation="True"
                                                    CssClass="table-dynamic table table-bordered table-striped table-sm">
                                                    <%--<AlternatingRowStyle CssClass="TrGameOdd" />--%>
                                                    <Fields>
                                                        <asp:BoundField DataField="CurrentBalance" DataFormatString="{0:N2}" HeaderText="Current Balance"
                                                            SortExpression="CurrentBalance" />
                                                        <asp:BoundField DataField="ThisWeek" DataFormatString="{0:N2}" HeaderText="This Week"
                                                            SortExpression="ThisWeek" />
                                                        <asp:BoundField DataField="LastWeek" DataFormatString="{0:N2}" HeaderText="Last Week"
                                                            SortExpression="LastWeek" />
                                                        <asp:BoundField DataField="TwoWeeksAgo" DataFormatString="{0:N2}" HeaderText="Two Weeks Ago"
                                                            SortExpression="TwoWeeksAgo" />
                                                        <asp:BoundField DataField="AgentLifeTime" DataFormatString="{0:N2}" HeaderText="Agent Lifetime"
                                                            SortExpression="AgentLifeTime" />
                                                        <asp:BoundField DataField="LifeTimeComm" DataFormatString="{0:N2}" HeaderText="Agent Lifetime Comm"
                                                            SortExpression="LifeTimeComm" />
                                                        <asp:BoundField DataField="MakeUp" DataFormatString="{0:N2}" HeaderText="MakeUp"
                                                            SortExpression="MakeUp" />
                                                        <asp:BoundField DataField="LastWeekMakeUp" DataFormatString="{0:N2}" HeaderText="Last Week MakeUp"
                                                            SortExpression="LastWeekMakeUp" />
                                                        <asp:BoundField DataField="AccountOpened" DataFormatString="{0:MM/dd/yyyy}" HeaderText="Account Opened"
                                                            SortExpression="AccountOpened" />
                                                        <asp:BoundField DataField="LastWager" DataFormatString="{0:MM/dd/yyyy HH:mm:ss}" HeaderText="Last Wager"
                                                            SortExpression="LastWager" />
                                                        <asp:BoundField DataField="LastModification" DataFormatString="{0:MM/dd/yyyy}" HeaderText="Last Modification"
                                                            SortExpression="LastModification" />
                                                    </Fields>
                                                </asp:DetailsView>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="col-md-4 col-sm-12">

                                    <asp:Label ID="lblAgent2" runat="server"></asp:Label>
                                    <table style="width: 100%;">

                                        <tr>
                                            <td>
                                                <asp:DetailsView ID="DetailsView2" runat="server" AutoGenerateRows="False"
                                                    DataKeyNames="IdAgent" DataSourceID="SqlDataSource4" EnableModelValidation="True"
                                                    Visible="False" CssClass="table-dynamic table table-bordered table-striped table-sm">
                                                    <%--<AlternatingRowStyle CssClass="TrGameOdd" />--%>
                                                    <Fields>
                                                        <asp:BoundField DataField="CurrentBalance" DataFormatString="{0:N2}" HeaderText="Current Balance"
                                                            SortExpression="CurrentBalance" />
                                                        <asp:BoundField DataField="ThisWeek" DataFormatString="{0:N2}" HeaderText="This Week"
                                                            SortExpression="ThisWeek" />
                                                        <asp:BoundField DataField="LastWeek" DataFormatString="{0:N2}" HeaderText="Last Week"
                                                            SortExpression="LastWeek" />
                                                        <asp:BoundField DataField="TwoWeeksAgo" DataFormatString="{0:N2}" HeaderText="Two Weeks Ago"
                                                            SortExpression="TwoWeeksAgo" />
                                                        <asp:BoundField DataField="AgentLifeTime" DataFormatString="{0:N2}" HeaderText="Agent Lifetime"
                                                            SortExpression="AgentLifeTime" />
                                                        <asp:BoundField DataField="LifeTimeComm" DataFormatString="{0:N2}" HeaderText="Agent Lifetime Comm"
                                                            SortExpression="LifeTimeComm" />
                                                        <asp:BoundField DataField="MakeUp" DataFormatString="{0:N2}" HeaderText="MakeUp"
                                                            SortExpression="MakeUp" />
                                                        <asp:BoundField DataField="LastWeekMakeUp" DataFormatString="{0:N2}" HeaderText="Last Week MakeUp"
                                                            SortExpression="LastWeekMakeUp" />
                                                        <asp:BoundField DataField="AccountOpened" DataFormatString="{0:MM/dd/yyyy}" HeaderText="Account Opened"
                                                            SortExpression="AccountOpened" />
                                                        <asp:BoundField DataField="LastWager" DataFormatString="{0:MM/dd/yyyy HH:mm:ss}" HeaderText="Last Wager"
                                                            SortExpression="LastWager" />
                                                        <asp:BoundField DataField="LastModification" DataFormatString="{0:MM/dd/yyyy}" HeaderText="Last Modification"
                                                            SortExpression="LastModification" />
                                                    </Fields>
                                                </asp:DetailsView>
                                            </td>
                                        </tr>
                                    </table>
                                </div>

                            </div>

                            <div class="popup" style="display: none">
                                <div class="overlay">
                                </div>
                                <div id="dialog" class="alert alert-light text-center">
                                    <h3 class="page-title">Confirm Transaction</h3>
                                    <div class="row">
                                        <div class="col-6">
                                            <strong>
                                                <asp:Label ID="lblAgent3" runat="server"></asp:Label></strong>
                                        </div>
                                        <div class="col-6">
                                            <strong>
                                                <asp:Label ID="lblAgent4" runat="server"></asp:Label></strong>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-3">
                                            <strong>Old Balance:</strong>
                                        </div>
                                        <div class="col-3">
                                            <asp:Label ID="lblOldBalance1" runat="server"></asp:Label>
                                        </div>
                                        <div class="col-3">
                                            <strong>
                                                <asp:Label ID="lblOldBalancelbl1" runat="server" Text="Old Balance:"></asp:Label></strong>
                                        </div>
                                        <div class="col-3">
                                            <asp:Label ID="lblOldBalance2" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-3">
                                            <strong>Amount:</strong>
                                        </div>
                                        <div class="col-3">
                                            <asp:Label ID="lblAmount1" runat="server"></asp:Label>
                                        </div>
                                        <div class="col-3">
                                            <strong>
                                                <asp:Label ID="lblamountlbl1" runat="server" Text="Amount:"></asp:Label></strong>
                                        </div>
                                        <div class="col-3">
                                            <asp:Label ID="lblAmount2" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-3">
                                            <strong>New Balance:</strong>
                                        </div>
                                        <div class="col-3">
                                            <asp:Label ID="lblNewBalance1" runat="server"></asp:Label>
                                        </div>
                                        <div class="col-3">
                                            <strong>
                                                <asp:Label ID="lblNewBalancelbl2" runat="server" Text="New Balance:"></asp:Label></strong>
                                        </div>
                                        <div class="col-3">
                                            <asp:Label ID="lblNewBalance2" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-6">
                                            <asp:Button ID="Button3" runat="server" CssClass="btn btn-success" Text="Submit" OnClick="Button3_Click" />
                                        </div>
                                        <div class="col-6">
                                            <input onclick="hidepopup();" type="button" class="btn btn-danger close" value="Cancel" style="color: #fff; text-shadow: unset;" />

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <br />

                            <br />
                        </asp:Panel>
                        <asp:Panel ID="pnNotAcces" runat="server">
                            <h3 class="page-title">You have not access to this area</h3>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>

        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
            SelectCommand="AgentPayment_AddOn_GetAllSubAgents" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:SessionParameter DefaultValue="0" Name="prmIdAgent" SessionField="SubIdAgent" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:DGSDATAConnectionString %>"
            SelectCommand="select * from PAYMENTMETHOD order by PAYMENTMETHOD"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
            SelectCommand="AgentPayment_getAgentStatistic" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="ddlAgent" Name="prmIDAgent" PropertyName="SelectedValue"
                    Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
            SelectCommand="AgentPayment_getAgentStatistic" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="ddlAgentTo" Name="prmIDAgent" PropertyName="SelectedValue"
                    Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
