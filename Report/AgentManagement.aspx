<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentManagement.aspx.cs" Inherits="AgentSite4.Report.AgentManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/src/assets/css/light/elements/custom-tree_view.css" rel="stylesheet" type="text/css">
    <link href="/src/assets/css/dark/elements/custom-tree_view.css" rel="stylesheet" type="text/css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">

        <div class="row page-titles">
            <div class="col-md-12 col-12 align-self-center">
                <h3 class="main-title m-b-0 m-t-0">Agent Management</h3>
            </div>
        </div>
        <div class="input-group mb-3">
            <span class="input-group-text eye-icon"><i class="fa-duotone fa-user-magnifying-glass"></i></span>
            <input type="text" id="searchAccounts" class="form-control form-control-sm" placeholder="Search Agents" />
        </div>
        <div id="filterAgents"></div>

        <div id="agentManagement"></div>

    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Footer" runat="server">
    <script src="/src/plugins/src/treeview/custom-jstree.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.7.7/handlebars.min.js"></script>
    <script>

        $(document).ready(function () {
            $('#agentManagement').html('<div id="load_screen"><div class="loader"><div class="loader-content"><div class="spinner-grow align-self-center"></div></div></div></div>');
            Handlebars.registerPartial('agentTemplate', document.getElementById('agent-template').innerHTML);
            Handlebars.registerPartial('agentPartial', document.getElementById('agent-partial').innerHTML);
            Handlebars.registerHelper('formatNumber', function (number) {
                return new Intl.NumberFormat('en-US').format(number);
            });

            $.ajax({
                url: '/Services/AgentManagement.ashx',
                type: 'GET',
                dataType: 'json',
                success: function (data) {
                    var template = Handlebars.compile(document.getElementById('agent-template').innerHTML);
                    var html = template({ agents: data });
                    $('#agentManagement').html(html);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    console.log('Error: ' + textStatus + ' - ' + errorThrown);
                }
            });

            $('#searchAccounts').on('keyup', function () {
                var searchTerm = $(this).val().toLowerCase();
                var filteredRows = [];

                if (searchTerm === '') {
                    $('#filterAgents').html('');
                    $('#agentManagement').show()
                    return;
                }
                else {
                    $('#filterAgents').html('');
                    $('#agentManagement').hide()
                }

                $('.agents').each(function () {
                    var agentName = $(this).find('.agentAccount').text().toLowerCase();
                    if (agentName.includes(searchTerm)) {
                        filteredRows.push($(this).prop('outerHTML'));
                    }
                });

                $('#filterAgents').html('<table class="table-dynamic table table-bordered table-striped"><tbody>' + filteredRows.join('') + '</tbody></table>');
            });

        });




    </script>

    <script id="agent-template" type="text/x-handlebars-template">
        <div class="table-responsive">
            <table class="table-dynamic table table-bordered table-striped">
                <thead>
                    <tr class="trAgent">
                        <th></th>
                        <th>Account</th>
                        <th>Password</th>
                        <th>Settings</th>
                        <th>Current Balance</th>
                        <th>Last Week</th>
                        <th>Two Weeks Ago</th>
                        <th>MakeUp</th>
                        <th>Agent Type</th>
                        <th>Commision</th>
                        <th>Manage</th>
                    </tr>
                </thead>
                <tbody>
                    {{#each agents}}
                <tr id="node-{{IdAgent}}" class="agents">
                    <td>{{#if Children}}
                            <div class="icon" data-bs-toggle="collapse" data-bs-target="#children-{{IdAgent}}">
                                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-chevron-right" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                    <polyline points="9 6 15 12 9 18"></polyline>
                                </svg>
                            </div>
                        {{else}}
                            <div class="icon">
                                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-circle" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                    <circle cx="12" cy="12" r="9"></circle>
                                </svg>
                            </div>
                        {{/if}}
                        
                    </td>
                    <td class="agentAccount">{{Agent}}</td>
                    <td class="password">

                        <div class="input-group input-group-extra-sm mb-1">
                            <input type="password" class="form-control form-control-sm" id="password-{{IdAgent}}" value="{{Password}}">
                            <span class="input-group-text eye-icon" onclick="togglePasswordVisibility('password-{{IdAgent}}')">
                                <i class="fa fa-eye" id="eyeIcon-password-{{IdAgent}}"></i>
                            </span>
                        </div>
                    </td>
                    <td>
                            <a href="javascript:void(0);" class="dropdown-toggle" id="agentSettingsDropdown" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <div class="avatar-container">
                                    <i class="fa-solid fa-users-gear"></i>
                                    Settings
                                </div>
                            </a>

                            <div class="dropdown-menu position-absolute" aria-labelledby="agentSettingsDropdown">

                                <div class="dropdown-item">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" value="" id="enable-{{IdAgent}}" {{#if  Enable}} checked {{/if}} />
                                        <label class="form-check-label" for="enable-{{IdAgent}}">
                                            Enable
                                        </label>
                                    </div>
                                </div>

                                <div class="dropdown-item">
                                    <div class="form-check form-check-inline ">
                                        <input class="form-check-input" type="checkbox" value="" id="onlineAccess-{{IdAgent}}" {{#if OnlineAccess}}checked{{/if}}/>
                                        <label class="form-check-label" for="OnlineAccess-{{IdAgent}}">
                                            Online Access
                                        </label>
                                    </div>
                                </div>
                                <div class="dropdown-item">
                                    <div class="form-check form-check-inline ">
                                        <input class="form-check-input" type="checkbox" value="" id="isDistributor-{{IdAgent}}" {{#if IsDistributor}}checked{{/if}}/>
                                        <label class="form-check-label" for="IsDistributor-{{IdAgent}}">
                                            Is Distributor 
                                        </label>
                                    </div>
                                </div>
                                <div class="dropdown-item">
                                    <div class="form-check form-check-inline ">
                                        <input class="form-check-input" type="checkbox" value="" id="DontXferPlayerActivity-{{IdAgent}}" {{#if DontXferPlayerActivity}}checked{{/if}} />
                                        <label class="form-check-label" for="DontXferPlayerActivity-{{IdAgent}}">
                                            Roll Over
                                        </label>
                                    </div>
                                </div>
                            </div>
                      
                    </td>
                    <td>{{formatNumber CurrentBalance}}</td>
                    <td>{{formatNumber ThisWeek}}</td>
                    <td>{{formatNumber LastWeek}}</td>
                    <td><input type="text" id="makeUP-{{IdAgent}}" value="{{formatNumber MakeUp}}" /></td>
                    <td>{{AgentType}}</td>
                    <td>{{CommSports}}</td>
                    <td>
                        <a href="/Report/ManageSubAgent.aspx?idAgent={{IdAgent}}" class="btn btn-sm btn-primary">
                            <i class="fa-duotone fa-gear"></i>
                        </a>
                    </td>
                </tr>
                {{#if Children}}
                    <tr class="collapse" id="children-{{IdAgent}}">
                        <td colspan="11" style="padding:0px;">
                            {{> agentPartial Children}}
                        </td>
                    </tr>
                {{/if}}
            {{/each}}
        </tbody>
    </table>
            </div>
</script>


    <script id="agent-partial" type="text/x-handlebars-template">
    {{> agentTemplate agents=.}}
</script>


</asp:Content>
