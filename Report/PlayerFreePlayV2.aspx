<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerFreePlayV2.aspx.cs" Inherits="AgentSite4.Report.PlayerFreePlayV2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 <style>
        html, body
        {
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

        #freeplaytable a {
            color: rgb(0, 102, 187);
            text-decoration: underline rgba(0, 102, 187, 0.4);
            vertical-align: middle;
        }

        .fixed-table-loading {
            position: relative;
            animation: progress-indeterminate 3s linear infinite;
            background: #0069d9;
            color: #0069d9;
            height: 5px;
            top: unset !important;
        }

            .fixed-table-loading.table {
                margin-bottom: unset !important;
            }

        @keyframes progress-indeterminate {
            from {
                left: -25%;
                width: 25%;
            }

            to {
                left: 100%;
                width: 25%;
            }
        }
    </style>

    <asp:TextBox ID="txtNumber" runat="server" CssClass="form-control form-control-sm"
        Width="100%"></asp:TextBox>
    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
        ErrorMessage="This field must be a number." ValidationExpression="^-?[0-9]\d*(\.\d+)?$"
        ControlToValidate="txtNumber"></asp:RegularExpressionValidator>

    <div class="row page-titles">
        <div class="col-md-12 col-12 align-self-center">
            <h3 class="main-title m-b-0 m-t-0">FREE PLAYS</h3>
            <h3 class="main-title m-b-0 m-t-0"><asp:Label runat="server" ID="lblAvailableFreePlayBalance"></asp:Label></h3>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-12">
            <div class="card no-space">

                <div class="card-body no-space">
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                            <div class="form-group serachContainer">
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                            <div class="form-group">
                                <button type="button" class="btn btn-primary dropdown-toggle " data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    Select Week
                                </button>
                                <div class="dropdown-menu">
                                    <a class="dropdown-item" href="javascript:changeTable(22)">All Players</a>
                                    <a class="dropdown-item" href="javascript:changeTable(7)">This Week</a>
                                    <a class="dropdown-item" href="javascript:changeTable(14)">Last Week</a>
                                    <a class="dropdown-item" href="javascript:changeTable(21)">Two Weeks Ago</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                            <div class="form-group">
                                <span class="selectedPlayers"></span>
                            </div>
                        </div>
                        <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6" style="text-align: right">
                            <div class="form-group">
                                <button id="btnCreateFreePlays" class="btn btn-secondary" tabindex="0" type="button" data-toggle="modal" data-target="#freeplaymodal" disabled>Create FreePlays</button>
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
                <table id="freeplaytable" data-toggle="table" data-pagination="true" class="table-dynamic table table-bordered table-striped" data-url="/services/FreePlay.ashx?idplayer=-1&active=0&days=14"
                    data-search-align="left" data-filter-control-placeholder="Player" data-click-to-select="true" data-search="true" data-loading-template="loadingTemplate">
                    <thead>
                        <tr>
                            <th data-checkbox="true"></th>
                            <th data-field="Player" data-filter-control="input">Player</th>
                            <th data-field="FreePlayAmount" data-formatter="LinkFormatter">Free Play Amount</th>
                            <th data-field="LifeTimeFreePlays">Life Time Free Plays</th>
                            <th data-field="TotalCount">Total Count</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="freeplaymodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">CREATE QUICK FREE PLAYS</h5>
                    <button type="button" class="close"  data-bs-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                        <div class="form-group">
                            <input type="text" id="txtAmount" class="form-control form-control-sm" placeholder="Amount" />
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                        <div class="form-group">
                            <input type="text" id="txtDescription" class="form-control form-control-sm" placeholder="Description" value="Free Play" />
                        </div>
                    </div><%--
                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                        <div class="form-group">
                            <input type="text" id="txtReference" class="form-control form-control-sm" placeholder="Reference" />
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                        <div class="form-group">
                            <input type="text" id="txtTransactionDate" class="form-control form-control-sm" placeholder="Transaction Date" data-provide="datepicker" />
                            <asp:Label ID="lblDateRange" runat="server" Text=""></asp:Label>
                        </div>
                    </div>--%>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" id="btnPostFreePlay" class="btn btn-primary">Save changes</button>
                </div>
            </div>
        </div>
    </div>

<div class="modal fade" id="errorModal" tabindex="-1" role="dialog" aria-labelledby="errorModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="errorModalLabel">Error</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>



    <div class="modal fade" id="modalFreePlayHistory" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modaltitle">PLAYER FREE PLAY HISTORY</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    </button>
                </div>
                <div class="modal-body ">
                    <div class="form-horizontal" style="display: flex !important;">
                            <div class="col-3">
                                <div class="form-group">
                                    <input type="text" id="txtdatefrom" class="form-control form-control-sm" placeholder="from" data-provide="datepicker" />
                                    <input type="hidden" id="p" />
                                </div>

                            </div>
                            <div class="col-1"> TO </div>
                            <div class="col-3">
                                <div class="form-group">
                                    <input type="text" id="txtdateto" class="form-control form-control-sm" placeholder="To" data-provide="datepicker" />
                                </div>
                            </div>
                            <div class="col-3"> </div>
                            <div class="col-2">
                                <div class="form-group">
                                    <button type="button" id="btnSearchHistory" class="btn btn-primary">Search</button>
                                </div>
                            </div>
                        </div>
                    <table id="tblFreePlayHistory" data-toggle="table" data-pagination="true" class="display table table-bordered">
                        <thead>
                            <tr>
                                <th data-field="Player">Player</th>
                                <th data-field="IdTransaction">Transaction</th>
                                <th data-field="Amount">Amount</th>
                                <th data-field="Description">Description</th>
                                <th data-field="Reference">Reference</th>
                                <th data-field="PlacedDate" data-formatter="dateFormat">PlacedDate</th>
                            </tr>
                        </thead>
                    </table>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" >Close</button>
                </div>
            </div>
        </div>
    </div>



    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <script src="https://unpkg.com/bootstrap-table@1.16.0/dist/bootstrap-table.min.js"></script>


    <script type="text/javascript">
        var list = [];

        function modalFreePlayHistory(id) {
            $('#tblFreePlayHistory').bootstrapTable('hideLoading')
            var url = "/services/FreePlayReport.ashx?id=" + id + "&from=<%=from %>&to=<%=to %>";
            $('#p').val(id);
            $.ajax({
                method: 'GET',
                dataType: 'json',
                url: url,
                success: function (response) {
                    console.log(response);
                    $('#tblFreePlayHistory').bootstrapTable({ data: response });
                    $('#tblFreePlayHistory').bootstrapTable('load', response);
                    $('#modalFreePlayHistory').modal('show');
                }
            });
        }

        function LinkFormatter(value, row, index) {
            var amount = row.FreePlayAmount;
            if (amount > 0) {
                return "<a href='javascript:modalFreePlayHistory(" + row.idPlayer + ")'>" + row.FreePlayAmount + "</a>";
            } else {
                return row.FreePlayAmount
            }
        }

        function dateFormat(value, row, index) {
            return getFormattedDate(new Date(row.PlacedDate));
        }

        function getFormattedDate(date) {
            var year = date.getFullYear();

            var month = (1 + date.getMonth()).toString();
            month = month.length > 1 ? month : '0' + month;

            var day = date.getDate().toString();
            day = day.length > 1 ? day : '0' + day;

            return month + '/' + day + '/' + year;
        }

        function searchFreePlayHistory() {
            $('#tblFreePlayHistory').bootstrapTable('hideLoading')
            var from = $('#txtdatefrom').val();
            var to = $('#txtdateto').val();
            var id = $('#p').val();
            var url = "/services/FreePlayReport.ashx?id=" + id + "&from=" + from + "&to=" + to;
            $.ajax({
                method: 'GET',
                dataType: 'json',
                url: url,
                success: function (response) {
                    console.log(response);
                    $('#tblFreePlayHistory').bootstrapTable({ data: response });
                    $('#tblFreePlayHistory').bootstrapTable('load', response);
                    $('#modalFreePlayHistory').modal('show');
                }
            });
        }



        function changeTable(days) {
            var active = 0;
            if (days > 21) {
                active = 0;
            }
            var url = "/services/FreePlay.ashx?idplayer=-1&active=" + active + "&days=" + days;
            $('#freeplaytable').attr('data-url', url);
            $.ajax({
                method: 'GET',
                dataType: 'json',
                url: url,
                success: function (response) {
                    console.log(response);
                    $('#freeplaytable').bootstrapTable({ data: response });
                    $('#freeplaytable').bootstrapTable('load', response);
                }
            });
        }

        $('#freeplaytable').on('check.bs.table', function (e, row) {

            if (row.idPlayer != undefined || row.idPlayer != null) {
                list.push(row.idPlayer);
            }

            if (list.length > 0) {
                $('.selectedPlayers').text('Selected Players: ' + list.length);
                $('#btnPostFreePlay').html('Create for ' + list.length + ' player');
                $('#btnCreateFreePlays').removeAttr('disabled');
                $('#btnCreateFreePlays').removeClass("btn btn-secondary").addClass("btn btn-success");
            }
            else {
                $("#btnCreateFreePlays").attr("disabled", true);
                $('#btnCreateFreePlays').removeClass("btn btn-success").addClass("btn btn-secondary");
            }
            console.log(row);
        })

        $('#freeplaytable').on('uncheck.bs.table', function (e, row) {
            if (row.idPlayer != undefined || row.idPlayer != null) {
                list.splice($.inArray(row.idPlayer, list), 1);
            }

            if (list.length > 0) {
                $('.selectedPlayers').text('Selected Players: ' + list.length);
                $('#btnPostFreePlay').html('Create for ' + list.length + ' player');
                $('#btnCreateFreePlays').removeAttr('disabled');
                $('#btnCreateFreePlays').removeClass("btn btn-secondary").addClass("btn btn-success");
            }
            else {
                $('.selectedPlayers').text('Selected Players: ' + list.length);
                $("#btnCreateFreePlays").attr("disabled", true);
                $('#btnCreateFreePlays').removeClass("btn btn-success").addClass("btn btn-secondary");
            }
        })

		$('#freeplaytable').on('check-all.bs.table', function (e, rows) {
			for(var i = 0; i < rows.length; i++) {
				if(rows[i].idPlayer != undefined && rows[i].idPlayer != null && list.indexOf(rows[i].idPlayer) === -1) {
					list.push(rows[i].idPlayer);
				}
			}

			$('.selectedPlayers').text('Selected Players: ' + list.length);
			$('#btnPostFreePlay').html('Create for ' + list.length + ' player');
			$('#btnCreateFreePlays').removeAttr('disabled');
			$('#btnCreateFreePlays').removeClass("btn btn-secondary").addClass("btn btn-success");
		});
		
		$('#freeplaytable').on('uncheck-all.bs.table', function (e) {
			list = [];  
				$('.selectedPlayers').text('Selected Players: ' + list.length);
                $("#btnCreateFreePlays").attr("disabled", true);
                $('#btnCreateFreePlays').removeClass("btn btn-success").addClass("btn btn-secondary");

			
		});

        $(document).ready(function () {
            $('.loading-text').text("");
            $(function () {
                $('#freeplaytable').bootstrapTable();
            })

            $('.search-input').attr('placeholder', 'Search Player');
            $('.search-input').appendTo(".serachContainer");
<%--            $('#txtTransactionDate').datepicker({
                format: 'mm-dd-yyyy',
                startDate: '<%=startDay%>d',
                endDate: new Date('<%=endDate%>')
            });--%>

            

            $('#btnPostFreePlay').on('click', function () {
                var postvalues = { idPlayer: list.join(), prmDescription: $('#txtDescription').val(), prmAmount: $('#txtAmount').val() };
                $('#btnPostFreePlay').attr("disabled", true);
                $.ajax({
                    type: 'POST',
                    url: "/services/FreePlayAdd.ashx",
                    data: postvalues,
                    dataType: "json", 
                    success: function (resultData) {
                        $('#btnPostFreePlay').removeAttr("disabled");
                        if (resultData.Code !== 200) {
                            $('#errorModal .modal-body').text(resultData.Titulo);
                            $('#errorModal').modal('show');
                        } else {
                            $('#freeplaymodal').modal('hide');
                            changeTable(14);
                            list = [];
                        }
                    }
                });
            });


            $('#btnSearchHistory').click(function () {
                searchFreePlayHistory();
            });
        });
    </script>
</asp:Content>
