<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerFreePlay.aspx.cs" Inherits="AgentSite4.Report.PlayerFreePlay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
 <style>
        .card {
            min-height: 310px;
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


    <div class="row page-titles">
        <div class="col-md-12 col-12 align-self-center">
            <h3 class="main-title m-b-0 m-t-0">Free Play Amount</h3>      
            <h3 class="main-title m-b-0 m-t-0"><asp:Label runat="server" ID="lblAvailableFreePlayBalance"></asp:Label></h3>
    </div>
    </div>
         <div class="row">
    <div class="col-lg-12">
        <div class="card">
    <table  cellspacing="0" cellpadding="3" border="0" class="tblWeeklyBalance table color-table success-table table-sm table-responsive" >
        <tbody>
            <tr class="GameHeader">
                <td colspan="3" style="padding: 10px;">Free Play Amount</td>
            </tr>
            <tr>
                <td style="width: 180px;border: 0;">&nbsp;</td>
                <td style="width: 180px;border: 0;">
                    <asp:Label ID="lblError" runat="server"></asp:Label>
                </td>
                <td style=" text-align: left;border: 0;">&nbsp;</td>
                
            </tr>

            <tr>
                <td align="right" style="width: 180px;border: 0;">Agent</td>
                <td align="left" style=" width: 180px; border: 0;">
                    <asp:DropDownList ID="ddlAgent" runat="server" CssClass="form-control form-control-sm tomlist"
                        DataSourceID="SqlDataSource2" DataTextField="agent" OnSelectedIndexChanged="ddlAgent_SelectedIndexChanged"
                        OnDataBound="ddlAgent_DataBound" DataValueField="IdAgent" AutoPostBack="True">
                    </asp:DropDownList>
                </td>
                <td style=" width: 180px; border: 0;">&nbsp;</td>
                
            </tr>

            <tr>
                <td align="right" style="width: 180px; border: 0;">Player: </td>
                <td align="left" style=" width: 180px; border: 0;">
                    
                    <asp:DropDownList ID="ddlPLayers" runat="server" CssClass="form-control form-control-sm tomlist"
                        OnSelectedIndexChanged="ddlPLayers_SelectedIndexChanged" OnDataBound="ddlPlayer_DataBound"
                        AutoPostBack="True">
                    </asp:DropDownList>
                        
                    <div>
                    <asp:CheckBox ID="chkActive" CssClass="specialCheck text-right control-label col-form-labe" runat="server" Text="Active in the last:" AutoPostBack="True" OnCheckedChanged="chkActive_CheckedChanged" />
                    <asp:TextBox ID="txtDays" runat="server" Width="36px" CssClass="form-control form-control-sm">30</asp:TextBox>
                    &nbsp;<strong>days.</strong>
                    </div>
                        </td>
                <td style=" width: 180px; border: 0;">
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtDays" ErrorMessage="For days only numbers are accepted from 1 to 360" ValidationExpression="^([1-9][0-9]?|[12][0-9][0-9]|3[0-5][0-9]|36[0-5])$"></asp:RegularExpressionValidator>
                </td>
                
            </tr>
            <td align="right" style="width: 180px; border: 0;">FreePlay Balance</td>
            <td style="border: 0;">
                <asp:Label ID="lblFreePlay" runat="server"></asp:Label>
            </td>
            <td style="border: 0;">
                <asp:RangeValidator ID="RangeValidator1" ControlToValidate="txtNumber" runat="server" ErrorMessage="Invalid free play amount. Player can't have a negative freeplay balance." MaximumValue="10000" MinimumValue="0" Type="Double"></asp:RangeValidator>
            </td>
            <tr>
                <td align="right" style="width: 180px; border: 0;">Free Play Amount:</td>
                <td style=" width: 180px; border: 0;">
                    <asp:TextBox ID="txtNumber" runat="server" CssClass="form-control form-control-sm"
                        Width="100%"></asp:TextBox>
                </td>
                <td style=" width: 180px; border: 0;">
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                        ErrorMessage="This field must be a number." ValidationExpression="^-?[0-9]\d*(\.\d+)?$"
                        ControlToValidate="txtNumber"></asp:RegularExpressionValidator>
                </td>
                
            </tr>

            <tr>
                <td style="width: 180px; border: 0;">&nbsp;</td>
                <td style="border: 0;">
                    <asp:Button ID="btnAdd" runat="server" Text="Save" OnClick="btnAdd_Click" CssClass="btn btn-success"/>
                </td>
                <td style="border: 0;">&nbsp;</td>
                
            </tr>

            <tr>
                <td style="width: 180px; border: 0;">&nbsp;</td>
                <td style="border: 0;">&nbsp;</td>
                <td style="border: 0;">&nbsp;</td>
                
            </tr>

        </tbody>
    </table>

            </div></div></div>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server"
        ConnectionString="<%$ ConnectionStrings:DGSDATAConnectionString %>" SelectCommand="select IdAgent, agent from Func_GetDistributorList_New(@idAgent) order by Agent">
        <SelectParameters>
            <asp:SessionParameter Name="idAgent"
                SessionField="SubIdAgent" />
        </SelectParameters>
    </asp:SqlDataSource>

    </div>
</asp:Content>
