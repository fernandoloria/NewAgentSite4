<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentStatistics.aspx.cs" Inherits="AgentSite4.Report.AgentStatistics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {

            window.toggleAgentRows = function (agentId) {
                var elements = document.getElementsByClassName('sub-agent-' + agentId);
                for (var i = 0; i < elements.length; i++) {
                    elements[i].style.display = elements[i].style.display == 'none' ? '' : 'none';
                }
            };

            window.currentColumnSet = 'default';

            window.toggleColumnSet = function (set) {
                var detailsColumns = $('.details');
                var actionsColumns = $('.actions');
                var pmtsColumn = $('.pmts');
                var actTotalColumn = $('.acttotal');
                var freePlayColumn = $('.freeplay');
                var deletedColumn = $('.deleted');

                if (window.currentColumnSet === set) {
                    detailsColumns.hide();
                    actionsColumns.hide();
                    freePlayColumn.show();
                    deletedColumn.show();
                    pmtsColumn.show();
                    actTotalColumn.show();
                    window.currentColumnSet = 'default';
                }
                else {
                    if (set === 'details') {
                        detailsColumns.show();
                        pmtsColumn.show();
                        actionsColumns.hide();
                        actTotalColumn.hide();
                    }
                    else if (set === 'actions') {
                        actionsColumns.show();
                        actTotalColumn.show();
                        detailsColumns.hide();
                        pmtsColumn.hide();
                    }
                    freePlayColumn.hide();
                    deletedColumn.hide();

                    window.currentColumnSet = set;
                }
            };


        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <div class="row">
            <div class="page-titles">
                <h4>Agent Statistics</h4>
            </div>
        </div>


                        <%

                            int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                            string prmAgent = this.Session["SubAgent"].ToString();
                            agentStatistics = LoadAgentStatistics(prmIdAgent);

                            RenderReport();

                        %>
                    </div>

</asp:Content>
