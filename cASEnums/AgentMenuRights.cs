using AgentSite4.cASEnums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AgentSite4.cASEnums
{
    public static class AgentMenuRights
    {
        static AgentMenuRights()
        {
            LoadData();
        }

        public static bool AgentHistory { get; private set; }
        public static bool MoveLines { get; private set; }
        public static bool WeeklyBalances { get; private set; }
        public static bool PlayerHistory { get; private set; }
        public static bool OpenBets { get; private set; }
        public static bool ActionByPlayer { get; private set; }
        public static bool PlayerManagement { get; private set; }
        public static bool PlayerStanding { get; private set; }
        public static bool AgentExposure { get; private set; }
        public static bool AgentPosition { get; private set; }
        public static bool AgentDistribution { get; private set; }
        public static bool HoldPercent { get; private set; }
        public static bool ChangedWager { get; private set; }
        public static bool CashFlow { get; private set; }
        public static bool WebVrsPhone { get; private set; }
        public static bool PlayerTotals { get; private set; }
        public static bool AgentCommission { get; private set; }
        public static bool AgentAdjustment { get; private set; }
        public static bool AgentBalanceHistory { get; private set; }
        public static bool AgentGrossWeek { get; private set; }
        public static bool AgentWagerListing { get; private set; }
        public static bool AgentWeeklyPayments { get; private set; }
        public static bool AgentAffilMarketing { get; private set; }
        public static bool AgentPlayerAccess { get; private set; }
        public static bool AgentPlayerCount { get; private set; }
        public static bool SettledFigure { get; private set; }
        public static bool TopPlayers { get; private set; }
        public static bool CreateAgent { get; private set; }
        public static bool CreatePlayer { get; private set; }
        public static bool EditPlayer { get; private set; }
        public static bool PlayerPayment { get; private set; }

        // AddOns
        public static bool PokerManagement { get; private set; }
        public static bool PokerAccess { get; private set; }
        public static bool AddPlayer { get; private set; }
        public static bool AddAgent { get; private set; }
        public static bool CancelBets { get; private set; }
        public static bool InsertWager { get; private set; }
        public static bool ManageProfileLimits { get; private set; }
        public static bool ManageProfile { get; private set; }
        public static bool ManageSubAgent { get; private set; }
        public static bool ManageMoneyLines { get; private set; }
        public static bool WagerEmailNotification { get; private set; }
        public static bool WagerSmsNotification { get; private set; }
        public static bool AgentChangePassword { get; private set; }
        public static bool PlayerMessages { get; private set; }
        public static bool HiddenLeagues { get; private set; }
        public static bool BetTicker { get; private set; }
        public static bool PlayerBulkPayment { get; private set; }
        public static bool TrackPlayerActivity { get; private set; }
        public static bool BeatTheLine { get; private set; }
        public static bool HorseMaster { get; private set; }
        public static bool AllSports { get; private set; }
        public static bool PlayerOverview { get; private set; }
        public static bool PlayerLifetime { get; private set; }
        public static bool PlayerZeroBalance { get; private set; }
        public static bool RolloverReport { get; private set; }
        public static bool HandleReport { get; private set; }
        public static bool TopWinnersAndLooser { get; private set; }
        public static bool WiseGuyMonitor { get; private set; }
        public static bool AgentAccessLog { get; private set; }
        public static bool CreateFreePlay { get; private set; }
        public static bool AgentPPH { get; private set; }
        public static bool AgentPPHTransaction { get; private set; }
        public static bool AgentActivePlayers { get; private set; }
        public static bool LineSchedule { get; private set; }
        public static bool DetailedSalesReport { get; private set; }
        public static bool PlayerManagementEnhaced { get; private set; }

        // Método para cargar datos
        private static void LoadData()
        {
            AgentHistory = Common.HasRights(ReportPosition.SHOWAGENTHISTORY);
            MoveLines = Common.HasRights(ReportPosition.MOVELINES);
            WeeklyBalances = Common.HasRights(ReportPosition.WEEKLYBALANCE);
            PlayerHistory = Common.HasRights(ReportPosition.PLAYERHISTORY);
            OpenBets = Common.HasRights(ReportPosition.OPENBETS);
            ActionByPlayer = Common.HasRights(ReportPosition.ACTIONBYPLAYER);
            PlayerManagement = Common.HasRights(ReportPosition.PLAYERMANAGEMENT);
            PlayerStanding = Common.HasRights(ReportPosition.PLAYERSTANDING);
            AgentExposure = Common.HasRights(ReportPosition.AGENTEXPOSURE);
            AgentPosition = Common.HasRights(ReportPosition.AGENTPOSITION);
            AgentDistribution = Common.HasRights(ReportPosition.AGENTDISTRIBUTION);
            HoldPercent = Common.HasRights(ReportPosition.HOLDPERCENT);
            ChangedWager = Common.HasRights(ReportPosition.CHANGEDWAGER);
            CashFlow = Common.HasRights(ReportPosition.CASHFLOW);
            WebVrsPhone = Common.HasRights(ReportPosition.WEBVRSPHONE);
            PlayerTotals = Common.HasRights(ReportPosition.PLAYERTOTALS);
            AgentCommission = Common.HasRights(ReportPosition.AGENTCOMMISSION);
            AgentAdjustment = Common.HasRights(ReportPosition.AGENTADJUSTMENT);
            AgentBalanceHistory = Common.HasRights(ReportPosition.AGENTBALANCEHISTORY);
            AgentGrossWeek = Common.HasRights(ReportPosition.AGENTGROSSWEEK);
            AgentWagerListing = Common.HasRights(ReportPosition.AGENTWAGERLISTING);
            AgentWeeklyPayments = Common.HasRights(ReportPosition.AGENTWEEKLYPAYMENTS);
            AgentAffilMarketing = Common.HasRights(ReportPosition.AFFILIATEMARKETING);
            AgentPlayerAccess = Common.HasRights(ReportPosition.PLAYERACCESS);
            AgentPlayerCount = Common.HasRights(ReportPosition.PLAYERCOUNT);
            SettledFigure = Common.HasRights(ReportPosition.SETTLEDFIGURE);
            TopPlayers = Common.HasRights(ReportPosition.AGENTTOPPLAYER);
            CreateAgent = Common.HasRights(ReportPosition.CREATEAGENT);
            CreatePlayer = Common.HasRights(ReportPosition.CREATEPLAYER);
            EditPlayer = Common.HasRights(ReportPosition.EditPlayer);
            PlayerPayment = Common.HasRights(ReportPosition.PLAYERPAYMENT);
            PokerManagement = Common.HasRights(ReportPosition.POKERMANAGEMENT);
            PokerAccess = Common.HasRights(ReportPosition.POKERACCESS);
            AddPlayer = Common.HasRights(ReportPosition.ADDPLAYER);
            AddAgent = Common.HasRights(ReportPosition.ADDAGENT);
            CancelBets = Common.HasRights(ReportPosition.CANCELBETS);
            InsertWager = Common.HasRights(ReportPosition.INSERTWAGER);
            ManageProfileLimits = Common.HasRights(ReportPosition.MANAGEPROFILELIMITS);
            ManageProfile = Common.HasRights(ReportPosition.MANAGEPROFILE);
            ManageSubAgent = Common.HasRights(ReportPosition.MANAGESUBAGENT);
            ManageMoneyLines = Common.HasRights(ReportPosition.MANAGEMONEYLINES);
            WagerEmailNotification = Common.HasRights(ReportPosition.WAGEREMAILNOTIFICATION);
            WagerSmsNotification = Common.HasRights(ReportPosition.WAGERSMSNOTIFICATION);
            AgentChangePassword = Common.HasRights(ReportPosition.AGENTCHANGEPASSWORD);
            PlayerMessages = Common.HasRights(ReportPosition.PLAYERMESSAGES);
            HiddenLeagues = Common.HasRights(ReportPosition.HIDDENLEAGUES);
            BetTicker = Common.HasRights(ReportPosition.BETTICKER);
            PlayerBulkPayment = Common.HasRights(ReportPosition.PLAYERBULKPAYMENT);
            TrackPlayerActivity = Common.HasRights(ReportPosition.TRACKPLAYERACTIVITY);
            BeatTheLine = Common.HasRights(ReportPosition.BEATTHELINE);
            HorseMaster = Common.HasRights(ReportPosition.HORSEMASTER);
            AllSports = Common.HasRights(ReportPosition.ALLSPORTS);
            PlayerOverview = Common.HasRights(ReportPosition.PLAYEROVERVIEW);
            PlayerLifetime = Common.HasRights(ReportPosition.PLAYERLIFETIME);
            PlayerZeroBalance = Common.HasRights(ReportPosition.PLAYERZEROBALANCE);
            RolloverReport = Common.HasRights(ReportPosition.ROLLOVERREPORT);
            HandleReport = Common.HasRights(ReportPosition.HANDLEREPORT);
            TopWinnersAndLooser = Common.HasRights(ReportPosition.TOPWINNERSANDLOOSER);
            WiseGuyMonitor = Common.HasRights(ReportPosition.WISEGUYMONITOR);
            AgentAccessLog = Common.HasRights(ReportPosition.AGENTACCESSLOG);
            CreateFreePlay = Common.HasRights(ReportPosition.CREATEFREEPLAY);
            AgentPPH = Common.HasRights(ReportPosition.AGENTPPH);
            AgentPPHTransaction = Common.HasRights(ReportPosition.AGENTPPHTRANSACTION);
            AgentActivePlayers = Common.HasRights(ReportPosition.AGENTPPHACTIVEPLAYERS);
            LineSchedule = Common.HasRights(ReportPosition.LINESSCHEDULE);
            DetailedSalesReport = Common.HasRights(ReportPosition.DETAILEDSALESREPORT);
            PlayerManagementEnhaced = Common.HasRights(ReportPosition.PLAYERMANAGEMENTENHANCED);
        }
    }
}
