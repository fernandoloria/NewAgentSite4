<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="LineAdvantage.aspx.cs" Inherits="AgentSite4.Report.LineAdvantage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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

        .playerName {
            width: 10% !important;
            max-width: 113px !important;
            /*min-width:113px !important;*/
        }

        .weekDay {
            width: 7%;
        }

        .bow {
            width: 9%;
        }

        @media(min-width:480px) {
            .wbtable td {
                font-weight: 600;
            }

            .bold td {
                font-weight: 900 !important;
            }
        }

        @media (max-width: 767px) {
            td, th {
                padding: 1px;
                font-size: 7px;
            }

            .wb_passowrd {
                font-size: 0.4rem;
            }

            a.editUser {
            }

            .playerName {
                max-width: 65px !important;
                /*min-width: 65px !important;*/
            }

            .container-fluid {
                padding: 0 2px 25px 2px !important;
            }



            .table-sm td, .table-sm th {
                padding-left: .1rem;
                padding-right: .1rem;
            }
        }

        @media (max-width: 480px) {
            .wbtable td {
                font-size: 6.5px;
            }

            .wbtable.wb-smallFont td {
                font-size: 6px !important;
            }
        }

        .NumPositive, .pos, .pos a {
            color: green;
            font-weight: bold;
        }

        .NumNegative, .neg, .neg a {
            color: #F00;
            font-weight: bold;
        }


        td {
            padding-left: 5px;
        }
    </style>


    <script language="JavaScript">




        $(document).ready(function () {
            $('#ctl00_MainContent_txtDateFrom').datepicker({
                startDate: '-3m',
                endDate: '-1d'
            });

            $('#ctl00_MainContent_txtDateTo').datepicker({
                startDate: '-3m',
                endDate: '0d'
            });
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <div class="row">
            <div class="col-lg-12">
                <h4 class="ui dividing header">Line Advantage 1</h4>

                <div class="wrapper__form mb-3">
                    <div class="ui form">
                        <div class="fields mb-3">
                            <div class="field">
                                <label>Test Initial Date:</label>
                                <asp:TextBox ID="txtDateFrom" runat="server" class="datepicker"></asp:TextBox>
                            </div>
                            <div class="field">
                                <label>Initial Date:</label>
                                <asp:TextBox ID="txtDateTo" runat="server" class="datepicker"></asp:TextBox>
                            </div>
                            <div class="field">
                                <label><asp:Label ID="Label1" runat="server" Text="Agent"></asp:Label></label>
                                <asp:DropDownList ID="ddlAgent" runat="server" DataSourceID="SqlDataSource1" CssClass="ui dropdown"
                                    DataTextField="Agent" DataValueField="IdAgent" AutoPostBack="True" OnDataBound="ddlAgent_DataBound">
                                </asp:DropDownList>
                            </div>
                            <div class="field">
                                <label><asp:Label ID="Label2" runat="server" Text="Player"></asp:Label></label>
                                <asp:DropDownList ID="ddlPlayer" CssClass="ui dropdown" runat="server" DataSourceID="SqlDataSource2" DataTextField="player" DataValueField="idPlayer" OnDataBound="ddlPlayer_DataBound">
                                </asp:DropDownList>
                            </div>
                            <div class="field">
                                <label><asp:Label ID="Label3" runat="server" Text="Play"></asp:Label></label>
                                <asp:DropDownList ID="ddlPlay" CssClass="ui dropdown" runat="server">
                                    <asp:ListItem Value="0">All Plays</asp:ListItem>
                                    <asp:ListItem Value="1">Spread</asp:ListItem>
                                    <asp:ListItem Value="2">Total</asp:ListItem>
                                    <asp:ListItem Value="3">Money Line</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-success" OnClick="btnSubmit_Click" />
                    </div>
                </div>
            </div>
        </div>

    <asp:Panel runat="server" ID="PnGrids" CssClass="">
    </asp:Panel>

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
