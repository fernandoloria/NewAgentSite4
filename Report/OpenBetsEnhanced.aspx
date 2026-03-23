<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="OpenBetsEnhanced.aspx.cs" Inherits="AgentSite4.Report.OpenBetsEnhanced" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dgsContent">
        <style>
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
                .tblWeeklyBalance td {
                    font-weight: 600;
                }

                .bold td {
                    font-weight: 900 !important;
                }
            }


            .oddRow td {
                color: var(--bs-table-color-state, var(--bs-table-color-type, var(--bs-table-color) #212529)) !important;
                background-color: white !important;
            }

            

            .hiddenRow {
                display: none;
            }

           

            th a {
                color: #fff;
            }
        </style>
       


        <div class="row page-titles">
            <div class="col-md-12 col-12 align-self-center">
                <h3 class="main-title m-b-0 m-t-0">Open Bets</h3>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <table class="table">
                            <tr style="display: none">
                                <td class="quantity" style="width: 105px">Date From:</td>
                                <td class="quantity">
                                    <asp:TextBox ID="txtDateFrom" name="txtDate" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                    <a href="#" onclick="JavaScript:cal.select(document.forms[0].ctl00_MainContent_txtDate,'anchor1','yyyy-MM-dd'); return false;"
                                        name="anchor2" id="a2">
                                        <!--<img src="../App_Themes/Classic/images/calendar2.png" border="0" width="24" />-->
                                    </a>
                                </td>
                                <td style="width: 138px">Date to:</td>
                                <td class="quantity">
                                    <asp:TextBox ID="txtDateTo" name="txtDate" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                    <a href="#" onclick="JavaScript:cal.select(document.forms[0].ctl00_MainContent_txtDate,'anchor1','yyyy-MM-dd'); return false;"
                                        name="anchor2" id="a3">
                                        <!--<img src="../App_Themes/Classic/images/calendar2.png" border="0" width="24" />-->
                                    </a>
                                </td>
                                <td class="quantity">&nbsp;
                                </td>
                                <td class="quantity">&nbsp;
                                </td>
                            </tr>
                        </table>

                        <div class="row">
                            <div class="col-12 col-sm-6 col-md-4 col-lg-2">
                                <div class="form-group">

                                    <asp:DropDownList ID="ddlDate" runat="server" class="form-control form-control-sm" CssClass="form-control form-control-sm tomlist">
                                        <asp:ListItem Text="PLACED DATE: ALL" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="PLACED IN CURRENT WEEK" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="PLACED TODAY" Value="2"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-12 col-sm-6 col-md-4 col-lg-2">
                                <div class="form-group">
                                    <!--label class="control-label" for="ddlWagerType">Type of Wager:</label-->
                                    <asp:DropDownList ID="ddlWagerType" runat="server" CssClass="form-control form-control-sm tomlist">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-12 col-sm-6 col-md-4 col-lg-2">
                                <div class="form-group">
                                    <!--label class="control-label" for="ddlSportType">Type of Sport:</label-->
                                    <asp:DropDownList ID="ddlSportType" runat="server" CssClass="form-control form-control-sm tomlist">
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <div class="col-xs-12 col-sm-6 col-md-4 col-lg-1">
                                <div class="form-group">
                                    <asp:TextBox ID="txtBetsPerPage" runat="server" CssClass="form-control form-control-sm" Placeholder="Bets per page" Text="250"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="regExValidator" runat="server" ControlToValidate="txtBetsPerPage" ValidationExpression="^[0-9]+$" ErrorMessage="Please enter a valid non-negative number." Display="Dynamic" />
                                </div>

                            </div>
                            <div class="col-12 col-sm-6 col-md-4 col-lg-2">
                                <div class="form-group">
                                    <!--label class="control-label" for="txtPlayer">Player Name:</label-->
                                    <asp:TextBox ID="txtPlayer" runat="server" class="form-control form-control-sm" placeholder="PLAYER NAME">
                                    </asp:TextBox>
                                </div>
                            </div>
                            <div class="col-12 col-sm-6 col-md-4 col-lg-2">
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlSortBy" runat="server" CssClass="form-control form-control-sm tomlist" AutoPostBack="True">
                                        <asp:ListItem Text="Order by Risk" Value="1" />
                                        <asp:ListItem Text="Order by Win" Value="2" />
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4 col-lg-1">
                                <div class="form-group">
                                    <asp:Button ID="btnSumit" runat="server" Text="Submit" class="btn btn-danger" OnClick="btnSumit_Click" />
                                </div>
                            </div>
                        </div>
                        <asp:Label ID="lblMensage" runat="server" Text=""></asp:Label>

                                        </div>
            </div>
        </div>
    </div>
</div>
                        <asp:ListView ID="lvOpenBets" runat="server">
                            <LayoutTemplate>
                                <table class="table-dynamic table table-bordered table-striped table-sm">
                                    <thead>
                                        <tr>
                                            <th class="d-none d-md-table-cell"><a href="javascript:sort('Agent')">Agent</a></th>
                                            <th>
                                                <a href="javascript:sort('Player')">Player</a><br />
                                                <span class="d-md-none"><a href="javascript:sort('Agent')">Agent</a></span>
                                                <span class="d-none d-md-inline">Password</span>
                                            </th>
                                            <th class="d-none d-md-table-cell"><a href="javascript:sort('PlacedDate')">Placed</a></th>
                                            <th><a href="javascript:sort('WagerType')">Description</a></th>
                                            <%-- risk/win placeholders unchanged --%>
                                            <asp:PlaceHolder runat="server" ID="phRisk"></asp:PlaceHolder>
                                            <asp:PlaceHolder runat="server" ID="phWin"></asp:PlaceHolder>
                                            <asp:PlaceHolder runat="server" ID="phDeleteColumn">
                                                <th class="delete">Delete</th>
                                            </asp:PlaceHolder>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                                    </tbody>
                                </table>
                            </LayoutTemplate>
                            <ItemTemplate>
                                <tr id="MainRow" class="clickableRow <%# GetRowClass() %>">
                                    <td class="d-none d-md-table-cell"><%# Eval("Agent") %></td>
                                    <td>
                                        <%# Eval("idPlayer") %><br />
                                        <span class="d-none d-md-inline"><%# Eval("Password") %></span>
                                        <span class="d-md-none neg"><%# Eval("Agent") %></span>
                                    </td>
                                    <td class="d-none d-md-table-cell">
                                        <%# Eval("PlacedDate") %><br />
                                        <span class="ticketNumber"><%# Eval("TicketNumber") %></span>
                                    </td>
                                    <td>
                                        <%# GetDescription(Eval("idSport"), Eval("WagerType"), Eval("description"), Eval("completeDescription")) %>
                                        <asp:Repeater DataSource='<%# Eval("Details") %>' runat="server">
                                            <ItemTemplate>
                                                <img class="d-none d-md-inline" alt=""
                                                    src="/Services/TeamLogo.ashx?idGame=<%# Eval("IdGame") %>&amp;rot=<%# Eval("Rotation") %>&amp;height=30" />
                                                <img class="d-md-none" alt=""
                                                    src="/Services/TeamLogo.ashx?idGame=<%# Eval("IdGame") %>&amp;rot=<%# Eval("Rotation") %>&amp;height=20" />
                                                <%# FormatDescription(Eval("GameDescription"), Eval("CompleteDescription")) %><br />
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </td>
                                    <td><%# Eval("riskAmount") %></td>
                                    <td><%# Eval("winAmount") %></td>
                                    <td runat="server" visible='<%# HasDeleteRight %>'>
                                        <asp:PlaceHolder runat="server" ID="phRowDelete" Visible='<%# (bool)Eval("CanDelete") %>'>
                                            <a href='javascript:CancelWagerPopup(<%# Eval("TicketNumber") %>, "<%# Eval("IdSport") %>");'
                                               class="btn btn-danger deletebtn">
                                                <i class="fa fa-times" aria-hidden="true"></i>
                                            </a>
                                        </asp:PlaceHolder>
                                    </td>
                                </tr>
                                <tr class="hiddenRow" id='<%# Eval("TicketNumber") %>'>
                                    <td colspan="7">
                                        <div class="table-responsive">
                                            <table class="table-dynamic table table-bordered table-striped table-sm">
                                                <thead>
                                                    <tr>
                                                        <th>Sport</th>
                                                        <th>Game Date</th>
                                                        <th>Description</th>
                                                        <th>Result</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td colspan="4">#: <%# Eval("ticketNumber") %> |
              Placed: <%# Eval("PlacedDate") %> |
              User: <%# Eval("Name") %> |
              IP: <%# Eval("IP") %>
                                                        </td>
                                                    </tr>

                                                    <asp:Repeater DataSource='<%# Eval("Details") %>' runat="server">
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td>
                                                                    <%# Eval("CompleteDescription").ToString() != "OPEN PLAY" ? Eval("gameSport") : "" %>
                                                                </td>
                                                                <td>
                                                                    <%# Eval("CompleteDescription").ToString() != "OPEN PLAY" ? ((DateTime)Eval("GameDate")).ToString("MMM dd hh:mmtt") : "" %>
                                                                </td>
                                                                <td>
                                                                    <img alt=""
                                                                        src="/Services/TeamLogo.ashx?idGame=<%# Eval("IdGame") %>&amp;rot=<%# Eval("Rotation") %>&amp;height=30" />
                                                                    <%# FormatDescription(Eval("GameDescription"), Eval("CompleteDescription")) %>
                                                                </td>
                                                                <td>
                                                                    <%# GetWagerResult(Convert.ToInt32(Eval("result"))) %>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </tbody>
                                            </table>
                                        </div>
                                    </td>
                                </tr>

                            </ItemTemplate>
                        </asp:ListView>
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
                                <asp:Repeater ID="rptPager" runat="server" OnItemCommand="Page_Changed" OnItemDataBound="rptPager_ItemDataBound">
                                    <ItemTemplate>
                                        <li class="page-item <%# !Convert.ToBoolean(Eval("Enabled")) ? "disabled" : "" %>">
                                            <asp:LinkButton ID="lnkPage" OnClick="Page_Changed" runat="server" CommandArgument='<%# Eval("Value") %>' Text='<%# Eval("Text") %>' Enabled='<%# Eval("Enabled") %>' CssClass="page-link"></asp:LinkButton>
                                        </li>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ul>
                        </nav>

                        <span class='hidden-sm-down'><span class='hidden-sm-up'></span></span>

                   

    <script>
        $(document).ready(function () {
            $("tr.clickableRow").click(function () {
                var ticketNumber = $(this).find(".ticketNumber").text();
                $("#" + ticketNumber).toggle();
            });
        });

        function sort(sortBy) {
            __doPostBack('Sort', sortBy);
        }
    </script>
    </div>
</asp:Content>
