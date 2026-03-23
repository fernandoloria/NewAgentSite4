<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="TopWinnersAndLosers.aspx.cs" Inherits="AgentSite4.Report.TopWinnersAndLosers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
         <style>
        .blacktext {
            color: #000000 !important;
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

        .row {
            margin-right: unset !important;
            margin-left: unset !important;
        }
    </style>


    <script language="JavaScript" src="../App_Themes/Classic/CalendarPopup.js"></script>
    <script language="JavaScript">
        var cal = new CalendarPopup();

        $(document).ready(function () {
            setInterval(function () {
                $("#ctl00_MainContent_txtDateFrom,#ctl00_MainContent_txtDateTo, input[name=Date1],input[name=Date2],input[name=Date3],input[name=Date4],input[name=Date5],input[name=ctl00_MainContent_Date2]").datepicker();
            }, 400);
        });

       
    </script>

    <div class="row page-titles">
        <div class="col-md-5 col-8 align-self-center">
            <h3 class="text-themecolor m-b-0 m-t-0">Top Winners and Losers</h3>
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="../Report/Welcome.aspx" target="_self">Home</a>
                </li>
                <li class="breadcrumb-item active">Top Winners and Losers</li>
            </ol>
        </div>
        <div class="col-md-7 col-4 align-self-center">
            <div class="d-flex m-t-10 justify-content-end">
                <div class="d-flex m-r-20 m-l-10 hidden-md-down">
                </div>
                <div class="">
                    <button class="btn btn-secondary" type="button" onclick="window.print();">
                        <i class="fa fa-print"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-12">
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                            <div class="form-group">
                                <asp:Label ID="Label1" runat="server" Text="Agent"></asp:Label>
                                <asp:DropDownList ID="ddlAgent" runat="server" DataSourceID="SqlDataSource1" CssClass="form-control form-control-sm tomlist"
                                    DataTextField="Agent" DataValueField="IdAgent" AutoPostBack="True" OnDataBound="ddlAgent_DataBound" OnSelectedIndexChanged="ddlAgent_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                            <div class="form-group">
                                <br />
                                <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-12">
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <asp:Panel runat="server" ID="PnGrids" CssClass="table-responsive col-lg-12">
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
        SelectCommand="AddOn_DDLAgent" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter Name="prmIDAgent" SessionField="SubIdAgent"
                Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server"
        ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
        SelectCommand="AddOn_GetPlayersDDL" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddlAgent" Name="prmIdAgent"
                PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    </div>
</asp:Content>
