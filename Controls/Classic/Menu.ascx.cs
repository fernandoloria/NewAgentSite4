using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;
using AgentSite4.cASEnums;

namespace AgentSite4.Controls
{
    public partial class Menu : System.Web.UI.UserControl
    {


        protected HyperLink lnkmb01;
        protected HyperLink lnkmb02;
        protected HyperLink lnkmb03;
        protected HyperLink lnkmb04;
        protected HyperLink lnkmb05;
        protected HyperLink lnkmb06;
        protected HyperLink lnkmb07;
        protected HyperLink lnkmb08;
        protected HyperLink lnkmb09;
        protected HyperLink lnkmb10;
        protected HyperLink lnkmb11;
        protected HyperLink lnkmb12;
        protected HyperLink lnkmb13;
        protected HyperLink lnkmb14;
        protected HyperLink lnkmb15;
        protected HyperLink lnkmb16;
        protected HyperLink lnkmb17;
        protected HyperLink lnkmb18;
        protected HyperLink lnkmb20;
        protected HyperLink lnkmb21;
        protected HyperLink lnkmb22;
        protected HyperLink HyperLink3;
        protected HyperLink HyperLink1;
        protected HyperLink HyperLink2;
        protected HyperLink HyperLink4;
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

        protected void Page_Load(object sender, EventArgs e)
        {
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
        }
    }
}