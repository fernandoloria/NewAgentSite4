<%@ Page Language="C#" AutoEventWireup="true" Theme="" StylesheetTheme="" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="DGSinterface" %>

<!DOCTYPE html>

<script runat="Server">
    private static string sConnString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
    private static string AddOnsConnString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
    CResultLogin oUser;

    void Page_Load(object sender, System.EventArgs e)
    {
        //string url = HttpContext.Current.Request.Url.Host.ToLower() +" | Agent:"+ Session["Agent"].ToString();
        //oUser = GetLogin("testh", "4321", GetClientIP(), "0",url, "");
        oUser = (CResultLogin)HttpContext.Current.Session["userdata"];
    }

    protected string getAvailableLeagues()
    {
        CResultLogin cresultLogin = oUser;

        string cacheKey = "AvailableLeagues_" + cresultLogin.Player;
        string cachedLeagues = (string)HttpContext.Current.Cache[cacheKey];

        if (cachedLeagues != null)
        {
            //   return cachedLeagues;
        }


        string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

        DataTable table = new DataTable();
        try
        {
            using (SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                Cnn.Open();
                using (SqlCommand comm = new SqlCommand("AddOn_WebGetOpenGamesLeagueUpcomming_GetLeague", Cnn))
                {
                    comm.CommandType = CommandType.StoredProcedure;

                    comm.Parameters.Add(new SqlParameter("@IdLineType", SqlDbType.Int)).Value = cresultLogin.IdLineType;
                    comm.Parameters.Add(new SqlParameter("@IdLanguage", SqlDbType.Int)).Value = cresultLogin.IdLanguage;
                    comm.Parameters.Add(new SqlParameter("@IdGame", SqlDbType.Int)).Value = -1;
                    comm.Parameters.Add(new SqlParameter("@IdAgent", SqlDbType.Int)).Value = cresultLogin.IdAgent;
                    comm.Parameters.Add(new SqlParameter("@WagerType", SqlDbType.Int)).Value = idwts.Value;
                    comm.Parameters.Add(new SqlParameter("@hours", SqlDbType.Int)).Value = 8;

                    using (SqlDataReader readerAgent = comm.ExecuteReader())
                    {
                        table.Load(readerAgent);
                    }
                }
            }
        }
        catch (Exception myError)
        {
            string err = myError.Message;
        }

        ArrayList idLeagues = new ArrayList();
        foreach (DataRow row in table.Rows)
        {
            idLeagues.Add(row["idLeague"].ToString());
        }

        string leaguesString = string.Join(",", (string[])idLeagues.ToArray(typeof(string)));

        HttpContext.Current.Cache.Insert(
            cacheKey,
            leaguesString,
            null,
            DateTime.Now.AddMinutes(10),
            System.Web.Caching.Cache.NoSlidingExpiration
        );

        return leaguesString;
    }

</script>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <link href="assets/fonts/fontawesome/css/fontawesome.css" rel="stylesheet" />
    <link href="assets/fonts/fontawesome/css/all.css" rel="stylesheet" />

    <script type="text/javascript">
        document.write('<link href="assets/css/root.css?v=' + getRandom() + '" rel="stylesheet" type="text/css" />');
        document.write('<link href="assets/css/custom.css?v=' + getRandom() + '" rel="stylesheet" type="text/css" />');

        function getRandom() {
            return Math.random();
        }
    </script>
    <script type="text/javascript" src="assets/js/jquery.min.js"></script>
    
    <script src="assets/js/bootstrap/bootstrap.min.js"></script>
    <script type="text/javascript" src="assets/js/bootstrap-select/bootstrap-select.js"></script>
    <script type="text/javascript" src="assets/js/plugins.js?v=1235"></script>
    <script type="text/javascript" src="assets/js/md5.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sticky-kit/1.1.3/sticky-kit.min.js"></script>


    <script type="text/javascript">
        document.write('<script src="assets/js/web.js?v=' + getRandom() + '"><\/script>');
        document.write('<script src="assets/js/main.js?v=' + getRandom() + '"><\/script>');
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <%
            string LS = Request.QueryString["lid"];
            string lid = Request.QueryString["lid"];
            string startLeague = "0";
            if (LS == null)
            {
                LS = "";
                //LS = Request.QueryString["ls"].ToString().ToUpper();
            }
            if (lid == null || lid == "")
            {
                startLeague = getAvailableLeagues();
                //startLeague = "1,2,3,4,5";
            }
            else
            {
                startLeague = lid;
            }
            //CResultLogin oUser = (CResultLogin)Context.Session["userdata"];
            String Player = oUser.Player;
            string p = oUser.Password;
            int idPlayer = oUser.IdPlayer;
            int idAgent = oUser.IdAgent;
            int idProfile = oUser.IdProfile;
            int idProfileLimits = oUser.IdProfileLimits;
            int idCall = oUser.IdCall;
            int idLineType = oUser.IdLineType;
            int idBook = oUser.IdBook;
            //int idBook = oUser.Password
            char LineStyle = oUser.LineStyle;
            char NHLLine = oUser.NHLLine;
            char MLBLine = oUser.MLBLine;
            float UTC = oUser.UTC;
            int idLanguage = oUser.IdLanguage;
            string phash = FormsAuthentication.HashPasswordForStoringInConfigFile(p, "MD5");
            Session["pid"] = idPlayer;

            if (LS != "")
            {
                LineStyle = LS[0];
            }

        %>

        <div>
                                <div class="alert alert-warning" role="alert" style="margin:10px 0;">
  <i class="fa fa-user"></i>
  Placing bets under <strong><%= oUser.Player %></strong>
</div>


            <div data-menu="wager-types" class="wagerTypeMobile">               
    <div data-wager-type="Straight" class="wagerTypeBtn active" onClick="start_straight()">
        <span class="one-letter">S</span>
        <span>Straight</span>
    </div>

    <div data-wager-type="Parlay" class="wagerTypeBtn" onClick="start_parlay('1')">
        <span class="one-letter">P</span>
        <span>PARLAY</span>
    </div>

    <div data-wager-type="Teaser" class="wagerTypeBtn" onClick="start_teaser()">
        <span class="one-letter">T</span>
        <span>TEASER</span>
    </div>
	<div data-wager-type="Teaser" class="wagerTypeBtn" onClick="start_parlay(5)">
        <span class="one-letter">RR</span>
        <span>ROUND ROBIN</span>
    </div>
	<div data-wager-type="IfBet" class="wagerTypeBtn" onClick="start_parlay('3')">
        <span class="one-letter">I</span>
        <span>IF BET</span>
    </div>
	<div data-wager-type="Teaser" class="wagerTypeBtn" onClick="start_parlay(7)">
        <span class="one-letter">WT</span>
        <span>WIN/TIE</span>
    </div>
	<div data-wager-type="Teaser" class="wagerTypeBtn" onClick="start_parlay(8)">
        <span class="one-letter">AR</span>
        <span>REVERSE</span>
    </div>

    
	<div  id="shoppingCart" data-action="size" data-wager-type="SIZE" class="special-type expand" onClick="openBS()">
        <i class="fa fa-shopping-cart" aria-hidden="true"></i>
        <span class="bs_cnt" data-language="L-19">POST</span>
    </div>
</div>

            <section class="left col-lg-3 col-md-3 col-sm-12 col-xs-12">
                <div class="sidebar-panel-content">
                    <ul class="sidebar-panel nav" id="sportSide"></ul>
                </div>
            </section>

            <section class="center col-lg-9 col-md-9 col-sm-12 col-xs-12" style="margin-bottom: 50px;">


                <style>
                    section.left {
                        display: block !important;
                    }

                    .classpitcher {
                        font-size: 0.9rem;
                        margin-left: 10px;
                    }

                    .toast {
                        min-width: 250px;
                        padding: 15px;
                        border-radius: 5px;
                        background-color: #f0ad4e;
                        color: #fff;
                        margin-top: 10px;
                        opacity: 0;
                        transition: opacity 0.5s ease-in-out;
                    }

                        .toast.show {
                            opacity: 1;
                        }
                </style>

                <!-- End Page Header -->
                <!-- START CONTAINER -->
                <div id="toast-container" style="position: fixed; top: 20px; right: 20px; z-index: 99999;"></div>

                <div class="container-default dynamicWagerContent">
                    
                    <div class="container-top col-lg-12">
                        <div id="playerMessages"></div>
                        <div data-menu="wager-types" id="SportWagerTypes">

                            <div data-wager-type="Straight" class="wagerTypeBtn active" onclick="start_straight()">
                                <span class="one-letter">S</span>
                                <span>Straight</span>
                            </div>

                            <div data-wager-type="Parlay" class="wagerTypeBtn" onclick="start_parlay('1')">
                                <span class="one-letter">P</span>
                                <span>PARLAY</span>
                            </div>

                            <div data-wager-type="Teaser" class="wagerTypeBtn" onclick="start_teaser()">
                                <span class="one-letter">T</span>
                                <span>TEASER</span>
                            </div>

                            <div data-wager-type="RoundRobin" class="wagerTypeBtn" onclick="start_parlay('5')">
                                <span class="one-letter">RR</span>
                                <span>ROUND ROBIN</span>
                            </div>

                            <div data-wager-type="IfBet" class="wagerTypeBtn" onclick="start_parlay('3')">
                                <span class="one-letter">I</span>
                                <span>IF BET</span>
                            </div>
                            <div data-wager-type="IfWinTie" class="wagerTypeBtn" onclick="start_parlay('7')">
                                <span class="one-letter">WT</span>
                                <span>WIN/TIE</span>
                            </div>
                            <div data-wager-type="ActionReverse" class="wagerTypeBtn" onclick="start_parlay('8')">
                                <span class="one-letter">AR</span>
                                <span>REVERSE</span>
                            </div>

                            <div id="shoppingCart" data-action="size" data-wager-type="SIZE" class="special-type expand" onclick="openBS()">
                                <i class="fa fa-shopping-cart" aria-hidden="true"></i>
                                <span class="bs_cnt" data-language="L-19">POST</span>
                            </div>


                        </div>
                    </div>

                    <div class="wager-content">

                        <div id="span-lines" class="col-xs-12 col-lg-9 expand-lines" data-content="multifunctional"></div>

                        <!-- BetTicket Desktop Start -->
                        <div class="betTicket-content hidden-xs hidden-sm hidden-md col-lg-3 padding-0 hidden1 hidden">
                            <div id="sticky-bet" class="panel panel-widget">
                                <div class="panel-title linesSlipTitle">
                                    <i class="fa fa-shopping-cart"></i>BET SLIP
                                </div>
                                <div class="panel-body" id="bs_left_cont">
                                    <div id="sporttypes"></div>

                                    <p id="errBet" class="text-danger text-center"></p>
                                    <div id="betslip_show" class="betslip"></div>
                                    <div id="betslip_show_temp"></div>
                                    <div id="betslip_final" class="hide"></div>
                                    <div id="teaser_list"></div>

                                    <div class="padding-t-5">
                                        <br />
                                        <button type="button" class="btn btn-danger pull-right btn-sm-slip btn-block" onclick="remove_all()" id="clearBtn">Clear Bets <i class="fa fa-times-circle"></i></button>
                                    </div>
                                    <div id="BT-msg">
                                        <div class="BT-startHeader"><i class="fa fa-caret-square-o-down"></i>Start Betting </div>
                                        <div class="BT-startmsg">Please add selections to your Bet Ticket.</div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <!-- BetTicket Desktop End -->
                    </div>

                </div>
                <!-- END CONTAINER -->
            </section>
            <!-- BetTicket Mobile Start -->
            <footer class="stFooter hidden-lg col-sm-12 col-xs-12 col-md-12">
                <div class="container">
                    <a href="javascript:;" data-action="continue-view-lines" data-wager-type="CONTINUE" class="btn btn-warning btn-lg btn-block betSlipt-control" onclick="betSliptControl(this)">Next</a>
                    <a href="javascript:;" data-action="back-view-lines" data-wager-type="Sports" class="btn btn-warning btn-lg btn-block" onclick="betSliptControl(this)">Back</a>
                </div>
            </footer>

            <!-- BetTicket Mobile End -->
            <div id="betslip_hide" class="hide notranslate"></div>
            <div id="betslip_temp" class="hide notranslate"></div>
            <div id="betslip_start" class="hide notranslate"></div>
            <div id="betslip_on" class="hide notranslate"></div>
            <input type="hidden" name="pid" id="pid" value="<%= idPlayer %>">
            <input type="hidden" name="aid" id="aid" value="<%= idAgent %>">
            <input type="hidden" name="idp" id="idp" value="<%= idProfile %>">
            <input type="hidden" name="idpl" id="idpl" value="<%= idProfileLimits %>">
            <input type="hidden" name="idc" id="idc" value="<%= idCall %>">
            <input type="hidden" name="idlt" id="idlt" value="<%= idLineType %>">
            <input type="hidden" name="idls" id="idls" value="<%= LineStyle %>">
            <input type="hidden" name="nhll" id="nhll" value="<%= NHLLine %>">
            <input type="hidden" name="mlbl" id="mlbl" value="<%= MLBLine %>">
            <input type="hidden" name="utc" id="utc" value="<%= UTC %>">
            <input type="hidden" name="idlan" id="idlan" value="<%= idLanguage %>">
            <input type="hidden" name="idbook" id="idbook" value="<%= idBook %>">
            <input type="hidden" name="wt" id="wt" value="0">
            <input type="hidden" name="hash" id="hash" value="<%= phash %>">
            <input type="hidden" name="p" id="p" value="<%= p %>">
            <input type="hidden" name="idwt" id="idwt" value="">
            <asp:HiddenField ID="idwts" runat="server" Value="0" />
            <input type="hidden" name="ts" id="ts" value="">
            <input type="hidden" name="maxOpenSpots" id="maxOpenSpots" value="">
            <input type="hidden" name="counter" id="counter" value="0">
            <input type="hidden" name="games-sel" id="games-sel" value="">
            <input type="hidden" name="currentLine" id="currentLine" value="">
            <input type="hidden" name="currentXML" id="currentXML" value="">

            <script>
                $(function () {
                    $('section.center').addClass('col-lg-10 col-md-9 col-sm-12 col-xs-12')

                    //$("form").addClass("form-inline");
                    $("form").submit(function (e) {
                        e.preventDefault();
                    });
                    $('#betslip_modal').on('hidden.bs.modal', function () {
                        closeBS();
                    })
            //getactiveleagues(<%= idProfile %>,<%= idLineType %>,<%= idLanguage %>,<%= idPlayer %>);
                        $('#currentLine').val("<%= startLeague %>");
                    init();
                    //      setInterval("autoRefresh()", 10000);

                });

                function syncValues() {
                    var idwt = document.getElementById("idwt");
                    var idwts = document.getElementById("ctl00_WagerContent_idwts");

                    idwt.addEventListener("change", function () {
                        idwts.value = idwt.value;
                    });
                }

                document.addEventListener("DOMContentLoaded", syncValues);
            </script>
        </div>

        <div class="modal fade" id="betslip_modal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog right">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title"><i class="fa fa-shopping-cart"></i>Bet Slip</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-12 betslip_cont" id="bs_mdl" id="bs_mdl">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-white" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
