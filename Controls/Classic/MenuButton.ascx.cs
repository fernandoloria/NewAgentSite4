using AgentSite4.ASP;
using AgentSite4.cASEnums;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.UI;
using System.Web.UI.WebControls;
using DGSinterface;

namespace AgentSite4.Controls
{
    public partial class MenuButton : System.Web.UI.UserControl
    {
        #region Agent Rights

        private bool sAgentHistory;
        private bool sMoveLines;
        private bool sWeeklyBalances;
        private bool sPlayerHistory;
        private bool sOpenBets;
        private bool sActionByPlayer;
        private bool sPlayerManagement;
        private bool sPlayerStanding;
        private bool sAgentExposure;
        private bool sAgentPosition;
        private bool sAgentDistribution;
        private bool sHoldPercent;
        private bool sChangedWager;
        private bool sCashFlow;
        private bool sWebVrsPhone;
        private bool sPlayerTotals;
        private bool sAgentCommission;
        private bool sAgentAdjustment;
        private bool sAgentBalanceHistory;
        private bool sAgentGrossWeek;
        private bool sAgentWagerListing;
        private bool sAgentWeeklyPayments;
        private bool sAgentAffilMarketing;
        private bool sAgentPlayerAccess;
        private bool sAgentPlayerCount;
        private bool sSettledFigure;
        private bool sTopPlayers;
        private bool sCreateAgent;
        private bool sCreatePlayer;




        /// <summary>
        /// AddOns
        /// </summary>

        private bool sPokerManagement;
        private bool sPokerAccess;
        private bool sAddPlayer;
        private bool sAddAgent;
        private bool sCancelBets;
        private bool sInsertWager;
        private bool sManageProfileLimits;
        private bool sManageProfile;
        private bool sManageSubAgent;
        private bool sManageMoneyLines;
        private bool sWagerEmailNotification;
        private bool sWagerSmsNotification;
        private bool sAgentChangePassword;
        private bool sPlayerMessages;
        private bool sHiddenLeagues;
        private bool sBetTicker;
        private bool sPlayerBulkPayment;
        private bool sTrackPlayerActivity;
        private bool sBeatTheLine;
        private bool sHorseMaster;
        private bool sAllSports;
        private bool sPlayerOverview;
        private bool sPlayerLifetime;
        private bool sPlayerZeroBalance;
        private bool sRolloverReport;
        private bool sHandleReport;
        private bool sTopWinnersAndLooser;
        private bool sWiseGuyMonitor;
        private bool sAgentAccessLog;
        private bool sCreateFreePlay;
        private bool sEditPlayer;
        private bool sPlayerPayment;
        private bool sAgentPPH;
        private bool sAgentPPHTransaction;
        private bool sAgentActivePlayers;
        private bool sLineSchedule;
        private bool sDetailedSalesReport;
        private bool sPlayerManagementEnhaced;


        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;
        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;
        public bool AgentHistory => this.sAgentHistory;

        public bool MoveLines => this.sMoveLines;

        public bool WeeklyBalances => this.sWeeklyBalances;

        public bool PlayerHistory => this.sPlayerHistory;

        public bool OpenBets => this.sOpenBets;

        public bool ActionByPlayer => this.sActionByPlayer;

        public bool PlayerManagement => this.sPlayerManagement;

        public bool PlayerStanding => this.sPlayerStanding;

        public bool AgentExposure => this.sAgentExposure;

        public bool AgentPosition => this.sAgentPosition;

        public bool AgentDistribution => this.sAgentDistribution;

        public bool HoldPercent => this.sHoldPercent;

        public bool ChangedWager => this.sChangedWager;

        public bool CashFlow => this.sCashFlow;

        public bool WebVrsPhone => this.sWebVrsPhone;

        public bool PlayerTotals => this.sPlayerTotals;

        public bool AgentCommission => this.sAgentCommission;

        public bool AgentAdjustment => this.sAgentAdjustment;

        public bool AgentBalanceHistory => this.sAgentBalanceHistory;

        public bool AgentGrossWeek => this.sAgentGrossWeek;

        public bool AgentWagerListing => this.sAgentWagerListing;

        public bool AgentWeeklyPayments => this.sAgentWeeklyPayments;

        public bool AgentAffilMarketing => this.sAgentAffilMarketing;

        public bool AgentPlayerAccess => this.sAgentPlayerAccess;

        public bool AgentPlayerCount => this.sAgentPlayerCount;

        public bool SettledFigure => this.sSettledFigure;

        public bool TopPlayers => this.sTopPlayers;

        public bool CreateAgent => this.sCreateAgent;

        public bool CreatePlayer => this.sCreatePlayer;

        public bool EditPlayer => this.sEditPlayer;

        public bool PlayerPayment => this.sPlayerPayment;

        /// <summary>
        /// AddOns
        /// </summary>
        public bool PokerManagement => this.sPokerManagement;
        public bool PokerAccess => this.sPokerAccess;
        public bool AddPlayer => this.sAddPlayer;
        public bool AddAgent => this.sAddAgent;
        public bool CancelBets => this.sCancelBets;
        public bool InsertWager => this.sInsertWager;
        public bool ManageProfileLimits => this.sManageProfileLimits;
        public bool ManageProfile => this.sManageProfile;
        public bool ManageSubAgent => this.sManageSubAgent;
        public bool ManageMoneyLines => this.sManageMoneyLines;
        public bool WagerEmailNotification => this.sWagerEmailNotification;
        public bool WagerSmsNotification => this.sWagerSmsNotification;
        public bool AgentChangePassword => this.sAgentChangePassword;
        public bool PlayerMessages => this.sPlayerMessages;
        public bool HiddenLeagues => this.sHiddenLeagues;
        public bool BetTicker => this.sBetTicker;
        public bool PlayerBulkPayment => this.sPlayerBulkPayment;
        public bool TrackPlayerActivity => this.sTrackPlayerActivity;
        public bool BeatTheLine => this.sBeatTheLine;
        public bool HorseMaster => this.sHorseMaster;
        public bool AllSports => this.sAllSports;
        public bool PlayerOverview => this.sPlayerOverview;
        public bool PlayerLifetime => this.sPlayerLifetime;
        public bool PlayerZeroBalance => this.sPlayerZeroBalance;
        public bool RolloverReport => this.sRolloverReport;
        public bool HandleReport => this.sHandleReport;
        public bool TopWinnersAndLooser => this.sTopWinnersAndLooser;
        public bool WiseGuyMonitor => this.sWiseGuyMonitor;
        public bool AgentAccessLog => this.sAgentAccessLog;
        public bool CreateFreePlay => this.sCreateFreePlay;
        public bool AgentPPH => this.sAgentPPH;
        public bool AgentPPHTransaction => this.sAgentPPHTransaction;
        public bool AgentActivePlayers => this.sAgentActivePlayers;
        public bool LineSchedule => this.sLineSchedule;
        public bool DetailedSalesReport => this.sDetailedSalesReport;
        public bool PlayerManagementEnhaced => this.sPlayerManagementEnhaced;


        private void LoadData()
        {
            this.sAgentHistory = Common.HasRights(ReportPosition.SHOWAGENTHISTORY);
            this.sMoveLines = Common.HasRights(ReportPosition.MOVELINES);
            this.sOpenBets = Common.HasRights(ReportPosition.OPENBETS);
            this.sActionByPlayer = Common.HasRights(ReportPosition.ACTIONBYPLAYER);
            this.sPlayerManagement = Common.HasRights(ReportPosition.PLAYERMANAGEMENT);
            this.sPlayerStanding = Common.HasRights(ReportPosition.PLAYERSTANDING);
            this.sPlayerHistory = Common.HasRights(ReportPosition.PLAYERHISTORY);
            this.sAgentExposure = Common.HasRights(ReportPosition.AGENTEXPOSURE);
            this.sAgentPosition = Common.HasRights(ReportPosition.AGENTPOSITION);
            this.sAgentDistribution = Common.HasRights(ReportPosition.AGENTDISTRIBUTION);
            this.sHoldPercent = Common.HasRights(ReportPosition.HOLDPERCENT);
            this.sChangedWager = Common.HasRights(ReportPosition.CHANGEDWAGER);
            this.sCashFlow = Common.HasRights(ReportPosition.CASHFLOW);
            this.sWebVrsPhone = Common.HasRights(ReportPosition.WEBVRSPHONE);
            this.sPlayerTotals = Common.HasRights(ReportPosition.PLAYERTOTALS);
            this.sAgentCommission = Common.HasRights(ReportPosition.AGENTCOMMISSION);
            this.sAgentAdjustment = Common.HasRights(ReportPosition.AGENTADJUSTMENT);
            this.sAgentBalanceHistory = Common.HasRights(ReportPosition.AGENTBALANCEHISTORY);
            this.sAgentGrossWeek = Common.HasRights(ReportPosition.AGENTGROSSWEEK);
            this.sAgentWagerListing = Common.HasRights(ReportPosition.AGENTWAGERLISTING);
            this.sAgentWeeklyPayments = Common.HasRights(ReportPosition.AGENTWEEKLYPAYMENTS);
            this.sAgentAffilMarketing = Common.HasRights(ReportPosition.AFFILIATEMARKETING);
            this.sWeeklyBalances = Common.HasRights(ReportPosition.WEEKLYBALANCE);
            this.sAgentPlayerAccess = Common.HasRights(ReportPosition.PLAYERACCESS);
            this.sAgentPlayerCount = Common.HasRights(ReportPosition.PLAYERCOUNT);
            this.sSettledFigure = Common.HasRights(ReportPosition.SETTLEDFIGURE);
            this.sTopPlayers = Common.HasRights(ReportPosition.AGENTTOPPLAYER);
            this.sCreateAgent = Common.HasRights(ReportPosition.CREATEAGENT);
            this.sCreatePlayer = Common.HasRights(ReportPosition.CREATEPLAYER);

            this.sPokerManagement = Common.HasRights(ReportPosition.POKERMANAGEMENT);
            this.sPokerAccess = Common.HasRights(ReportPosition.POKERACCESS);
            this.sAddPlayer = Common.HasRights(ReportPosition.ADDPLAYER);
            this.sAddAgent = Common.HasRights(ReportPosition.ADDAGENT);
            this.sCancelBets = Common.HasRights(ReportPosition.CANCELBETS);
            this.sInsertWager = Common.HasRights(ReportPosition.INSERTWAGER);
            this.sManageProfileLimits = Common.HasRights(ReportPosition.MANAGEPROFILELIMITS);
            this.sManageProfile = Common.HasRights(ReportPosition.MANAGEPROFILE);
            this.sManageSubAgent = Common.HasRights(ReportPosition.MANAGESUBAGENT);
            this.sManageMoneyLines = Common.HasRights(ReportPosition.MANAGEMONEYLINES);
            this.sWagerEmailNotification = Common.HasRights(ReportPosition.WAGEREMAILNOTIFICATION);
            this.sWagerSmsNotification = Common.HasRights(ReportPosition.WAGERSMSNOTIFICATION);
            this.sAgentChangePassword = Common.HasRights(ReportPosition.AGENTCHANGEPASSWORD);
            this.sPlayerMessages = Common.HasRights(ReportPosition.PLAYERMESSAGES);
            this.sHiddenLeagues = Common.HasRights(ReportPosition.HIDDENLEAGUES);
            this.sBetTicker = Common.HasRights(ReportPosition.BETTICKER);
            this.sPlayerBulkPayment = Common.HasRights(ReportPosition.PLAYERBULKPAYMENT);
            this.sTrackPlayerActivity = Common.HasRights(ReportPosition.TRACKPLAYERACTIVITY);
            this.sBeatTheLine = Common.HasRights(ReportPosition.BEATTHELINE);
            this.sHorseMaster = Common.HasRights(ReportPosition.HORSEMASTER);
            this.sAllSports = Common.HasRights(ReportPosition.ALLSPORTS);
            this.sPlayerOverview = Common.HasRights(ReportPosition.PLAYEROVERVIEW);
            this.sPlayerLifetime = Common.HasRights(ReportPosition.PLAYERLIFETIME);
            this.sPlayerZeroBalance = Common.HasRights(ReportPosition.PLAYERZEROBALANCE);
            this.sRolloverReport = Common.HasRights(ReportPosition.ROLLOVERREPORT);
            this.sHandleReport = Common.HasRights(ReportPosition.HANDLEREPORT);
            this.sTopWinnersAndLooser = Common.HasRights(ReportPosition.TOPWINNERSANDLOOSER);
            this.sWiseGuyMonitor = Common.HasRights(ReportPosition.WISEGUYMONITOR);
            this.sAgentAccessLog = Common.HasRights(ReportPosition.AGENTACCESSLOG);
            this.sCreateFreePlay = Common.HasRights(ReportPosition.CREATEFREEPLAY);
            this.sEditPlayer = Common.HasRights(ReportPosition.EditPlayer);
            this.sPlayerPayment = Common.HasRights(ReportPosition.PLAYERPAYMENT);
            this.sAgentPPH = Common.HasRights(ReportPosition.AGENTPPH);
            this.sAgentPPHTransaction = Common.HasRights(ReportPosition.AGENTPPHTRANSACTION);
            this.sAgentActivePlayers = Common.HasRights(ReportPosition.AGENTPPHACTIVEPLAYERS);
            this.sLineSchedule = Common.HasRights(ReportPosition.LINESSCHEDULE);
            this.sDetailedSalesReport = Common.HasRights(ReportPosition.DETAILEDSALESREPORT);
            this.sPlayerManagementEnhaced = Common.HasRights(ReportPosition.PLAYERMANAGEMENTENHANCED);
        }


        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo(Session["CultureInfo"].ToString());
            System.Threading.Thread.CurrentThread.CurrentCulture = ci;
            System.Threading.Thread.CurrentThread.CurrentUICulture = ci;
            try
            {
                bool.Parse(this.Session["Validated"].ToString());
            }
            catch
            {
                this.Response.Redirect("../Logout.aspx");
            }
            if (this.Page.IsPostBack)
                return;
            this.LoadData();
        }

        protected void Page_Init(object sender, EventArgs e)
        {

            CreateReport();

        }


        public void CreateReport()
        {
            DataTable dt_reportsbyIdAgent = getReportsByIdAgent();
            List<Category> categories = new List<Category>();
            Dictionary<string, Category> categoryDictionary = new Dictionary<string, Category>();

            foreach (DataRow row in dt_reportsbyIdAgent.Rows)
            {
                string categoryKey = row["category"].ToString();
                string categoryIcon = row["icon"].ToString();
                if (!categoryDictionary.ContainsKey(categoryKey))
                {
                    Category newCategory = new Category();
                    newCategory.CategoryName = categoryKey;
                    newCategory.CategoryID = categoryKey.Replace(' ', '_');
                    newCategory.Icon = categoryIcon;
                    newCategory.Reports = new List<DGSinterface.Report>();
                    categoryDictionary[categoryKey] = newCategory;
                }

                DGSinterface.Report report = new DGSinterface.Report();
                report.IdReport = row["idReport"].ToString();
                report.Name = row["reportName"].ToString();
                report.URL = row["reportURL"].ToString();
                categoryDictionary[categoryKey].Reports.Add(report);
            }

            categories.AddRange(categoryDictionary.Values);

            ListViewReports.DataSource = categories;
            ListViewReports.DataBind();
            //return categories;
        }

        protected DataTable getReportsByIdAgent()
        {
            DataTable dt = (DataTable)Session["tblReports"];
            if (dt == null || dt.Rows.Count <= 0)
            {
                int prmIdAgent = Convert.ToInt32(Session["IdAgent"]);
                string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

                dt = new DataTable();

                try
                {
                    using (SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString))
                    {
                        using (SqlCommand comm = new SqlCommand("AgentMenu_Get", Cnn))
                        {
                            comm.CommandType = CommandType.StoredProcedure;
                            comm.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = prmIdAgent;

                            Cnn.Open();

                            using (SqlDataReader readerAgent = comm.ExecuteReader())
                            {
                                dt.Load(readerAgent);
                            }
                        }
                    }

                    Session["tblReports"] = dt;
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error fetching data: " + ex.Message);
                }
            }

            return (DataTable)Session["tblReports"];
        }



    }

}