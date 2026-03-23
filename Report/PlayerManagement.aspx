<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerManagement.aspx.cs" Inherits="AgentSite4.Report.PlayerManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
        <div class="row page-titles">
            <div class="col-md-12 align-self-center">
                <h3 class="text-themecolor m-b-0 m-t-0">Player Management</h3>
                                </div>
                            </div>
        <div class="input-group mb-3">
            <span class="input-group-text eye-icon"><i class="fa-duotone fa-user-magnifying-glass"></i></span>
            <input type="text" id="searchPlayers" class="form-control form-control-sm" placeholder="Search Players" />
                        </div>
        <div id="filteredPlayers" style="display: none;"></div>
        <div id="playerManagement"></div>

                    </div>
    <asp:HiddenField ID="hdfAccounts" runat="server" />
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Footer">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.7.7/handlebars.min.js"></script>

    <script>
        $(document).ready(function () {
            $('#playerManagement').html('<div id="load_screen"><div class="loader"><div class="loader-content"><div class="spinner-grow align-self-center"></div></div></div></div>');

            function loadPlayers() {
                $.ajax({
                    url: '/Services/PlayerManagement.ashx',
                    type: 'GET',
                    dataType: 'json',
                    success: function (data) {
                        var template = Handlebars.compile($('#player-template').html());
                        var html = template(data);
                        $('#playerManagement').html(html);
                    },
                    error: function (error) {
                        console.log('Error fetching player data:', error);
                        $('#playerManagement').html('<p>Error loading player data.</p>');
                    }
                });
            }

            loadPlayers();

            function filterPlayers() {
                var searchTerm = $('#searchPlayers').val().toLowerCase();

                if (searchTerm) {
                    var filteredRows = [];
                    $('.player-row').each(function () {
                        var playerName = $(this).data('player').toLowerCase();

                        if (playerName.includes(searchTerm)) {
                            filteredRows.push($(this).prop('outerHTML'));
                        }
                    });

                    $('#filteredPlayers').empty(); // Vacía el contenedor antes de añadir nuevos resultados
                    if (filteredRows.length > 0) {
                        $('#filteredPlayers').html('<table class="table color-table success-table table-bordered table-striped table-sm hover-table"><tbody>' + filteredRows.join('') + '</tbody></table>');
                    } else {
                        $('#filteredPlayers').html('<p>No results found.</p>'); // Mensaje si no hay resultados
                    }
                    $('#filteredPlayers').show();
                    $('#playerManagement').hide();
                } else {
                    $('#filteredPlayers').hide();
                    $('#playerManagement').show();
                }
            }

            $('#searchPlayers').keyup(function (e) {
                filterPlayers();
            });

        });

        Handlebars.registerHelper('formatCurrency', function (value) {
            return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(value);
        });

        

    </script>


    <script id="player-template" type="text/x-handlebars-template">
        {{#each ListAgent}}
            <div class="mb-3">
                <h2 class="ui center sub header mb-3">
                    {{Agent}}
                </h2>
                    <div class="table-responsive">
                        <table class="table color-table success-table table-bordered table-striped table-sm hover-table">
                            <thead>
                                <tr>
                                    <th>Player / Pass</th>
                                    <th>Credit Limit</th>
                                    <th>Max Wager</th>
                                    <th>Min Wager</th>
                                    <th>Enable</th>
                                    <th>Sport</th>
                                    <th>Casino</th>
                                    <th>Horses</th>
                                    <th>Last Wager</th>
                                    <th>Edit</th>
                                    <th>$PMT</th>
                                </tr>
                            </thead>
                            <tbody>
                                {{#each ListPlayer}}
                                <tr class="player-row" data-player="{{Player}}">
                                    <td><a href="#" onclick="OpenPlayerStats('{{IdPlayer}}')">{{Player}} - {{Password}}</a></td>
                                    <td>{{formatCurrency CreditLimit}}</td>
                                    <td>{{formatCurrency MaxWager}}</td>
                                    <td>{{formatCurrency MinWager}}</td>
                                    <td>{{#if Enabled}}Yes{{else}}No{{/if}}</td>
                                    <td>{{#if EnableSport}}Yes{{else}}No{{/if}}</td>
                                    <td>{{#if EnableCasino}}Yes{{else}}No{{/if}}</td>
                                    <td>{{#if EnableHorses}}Yes{{else}}No{{/if}}</td>
                                    <td>{{LastWager}}</td>
                                    <td>
                                        <button type="button" class="btn btn-warning btn-sm" onclick="OpenEditPlayer('{{IdPlayer}}')">Edit</button></td>
                                    <td>
                                        <button type="button" class="btn btn-success btn-sm" onclick="OpenPlayerPayment('{{IdPlayer}}')">$</button></td>
                                </tr>
                                {{/each}}
                            </tbody>
                        </table>
                </div>
    </div>
        {{/each}}
    </script>


    


</asp:Content>
