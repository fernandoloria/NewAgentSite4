<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerWeeklyProfit.aspx.cs" Inherits="AgentSite4.Report.PlayerWeeklyProfit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
        <style>
        .blacktext {
            color: #000000 !important;
        }

        .redCell {
            background-color: #dc3545;
        }
        .greenCell {
            background-color: #5B923E;
        }
        .blueCell {
            background-color: #AFEEEE;
        }
        .grayCell {
            background-color: #DCDCDC;
        }
        .redCell a, .greenCell a, .greenCell span, .redCell span{
            color: white !important;
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

        .autocomplete0 {
            color:gray;
        }
        .autocomplete1 {
            font-weight: 900;
        }
    </style>



    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
  <script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.13.1/themes/base/jquery-ui.css">

    <script language="JavaScript">

        $(document).ready(function () {

            $("#ctl00_MainContent_txtPlayer")
                .focusout(function () {
                    if ($("#ctl00_MainContent_txtPlayer").val().length == 0)
                    {
                        $("#ctl00_MainContent_hdfIdPlayer").val("-1");
                    }
                    $("#ctl00_MainContent_btnSubmit").click();
                })
                .blur(function () {
                    if ($("#ctl00_MainContent_txtPlayer").val().length == 0) {
                        $("#ctl00_MainContent_hdfIdPlayer").val("-1");
                    }
                    $("#ctl00_MainContent_btnSubmit").click();
                });
                
            $("#ctl00_MainContent_txtPlayer").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        dataType: 'json',
                        url: "/services/GetPlayersPlayerWeeklyProfit.ashx",
                        type: "GET",
                        data: {
                            startsWith: request.term,
                            dateFrom: $("#ctl00_MainContent_txtDateFrom").val(),
                            onlyActives: $("#ctl00_MainContent_chkActive").prop('checked')
                        },
                        success: function (data) {
                            response($.map(data, function (el) {
                                return {
                                    label: el.Player,
                                    value: el.idPlayer,
                                    active: el.active
                                };
                            }));
                        }
                    });
                }, 
                focus: function (event, ui) {
                    event.preventDefault();
                    $("#ctl00_MainContent_hdfIdPlayer").val(ui.item.value);
                    $("#ctl00_MainContent_txtPlayer").val(ui.item.label);
                    
                },
                select: function (event, ui) {
                    event.preventDefault();
                    $("#ctl00_MainContent_hdfIdPlayer").val(ui.item.value);
                    $("#ctl00_MainContent_txtPlayer").val(ui.item.label);
                    $("#ctl00_MainContent_btnSubmit").click();
                },
                close: function (event, ui) {
                    $("#ctl00_MainContent_hdfIdPlayer").val(ui.item.value);
                    $("#ctl00_MainContent_txtPlayer").val(ui.item.label);
                }
            }).data("ui-autocomplete")._renderItem = function (ul, item) {
                return $("<li></li>").data("item.autocomplete", item).append("<span class='autocomplete" + item.active+"'>" + item.label +"</span>").appendTo(ul);
            };
        });


        
    </script>



    <div class="row page-titles">
        <div class="col-md-12 col-12 align-self-center">
            <h3 class="main-title m-b-0 m-t-0">Player Weekly Profit</h3>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-12">
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                            <div class="form-group">
                                <label for="txtDateFrom">Initial Date:</label>
                                <asp:TextBox ID="txtDateFrom" runat="server" class="form-control form-control-sm datepicker"></asp:TextBox>
                            </div>
                        </div>

                        <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                            <div class="form-group">
                                <br />
                                <br />
                                <asp:CheckBox ID="chkActive" CssClass="specialCheck text-right control-label col-form-label" data-toggle="toggle" runat="server" Text="Actives only" Checked="true"/>
                            </div>
                        </div>
                    </div>
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
                                <asp:Label ID="Label2" runat="server" Text="Player"></asp:Label>

                                <div id="searchPlayer" class="input-group ui-widget" >
                                    <asp:TextBox runat="server" id="txtPlayer" class="form-control form-control-sm" placeholder="Search, type one space to view all." autocomplete="off"  ></asp:TextBox>
                                    <asp:HiddenField ID="hdfIdPlayer" runat="server" value="-1"/>
                                </div>
                            </div>


                                

                        </div>
                        <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                            <div class="form-group">
                                <br />
                                <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
                                <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="btn btn-danger" OnClick="btnBack_Click" />
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
    </div>
</asp:Content>
