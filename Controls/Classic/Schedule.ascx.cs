using AgentSite4.ASP;
using DGSinterface;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Profile;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace AgentSite4.Controls
{
    public partial class Schedule : System.Web.UI.UserControl
    {
        private DataSet dsSchedule = new DataSet();
        private string Null_Value = DBNull.Value.ToString();
        private long IDAGENT = -1;
        private int IDLINETYPE = -1;
        private int IDLEGAUE = -1;
        private string DISPLAY = "";
        private string IDSPORT = "";
        protected UpdateProgress UpdateProgress1;
        protected DropDownList cmbLeague;
        protected DropDownList cmbDisplay;
        protected DropDownList cmbOrder;
        protected DropDownList cmbEvent;
        protected DataGrid sDGridFB;
        protected DataGrid sDGridSM;
        protected DataGrid sDGridM;
        protected DataGrid sDGridN;
        protected DataGrid sDGridT;
        protected DataGrid sDGridP;
        protected DataGrid sDGridE;
        protected UpdatePanel UpdatePanel1;
        private int IDEVENT;
        private int IDORDER;
        private bool bDisplayData;
        private string sSportTitle;
        private string strSport;

        protected DefaultProfile Profile
        {
            get
            {
                return (DefaultProfile)this.Context.Profile;
            }
        }

        protected global_asax ApplicationInstance
        {
            get
            {
                return (global_asax)this.Context.ApplicationInstance;
            }
        }

        public bool DisplayData
        {
            get
            {
                return this.bDisplayData;
            }
        }

        public string SportTitle
        {
            get
            {
                return this.sSportTitle;
            }
        }

        public string IdSport
        {
            get
            {
                return this.strSport;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.Request.QueryString["LT"] != null && this.Request.QueryString["SP"] != null)
            {
                this.bDisplayData = true;
                this.LoadData();
            }
            else
                this.bDisplayData = false;
        }

        private void LoadData()
        {
            XmlDocument xmlDocument = new XmlDocument();
            this.IDAGENT = long.Parse(this.Session["IdAgent"].ToString());
            this.IDLINETYPE = int.Parse(this.Request.QueryString["LT"].ToString());
            this.IDSPORT = this.Request.QueryString["SP"].ToString().Trim();
            if (this.IsPostBack)
            {
                this.IDLEGAUE = int.Parse(this.cmbLeague.SelectedValue.ToString());
                this.IDORDER = int.Parse(this.cmbOrder.SelectedValue.ToString());
                this.IDEVENT = int.Parse(this.cmbEvent.SelectedValue.ToString());
                this.DISPLAY = this.cmbDisplay.SelectedValue.ToString();
            }
            this.GetSportTitle();
           AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
            CResultGetAgentSchedule getAgentSchedule = new CResultGetAgentSchedule();
            CResultGetAgentSchedule agentGameSchedule = agentInstance.GetAgentGameSchedule(this.IDAGENT, this.IDLINETYPE, this.IDLEGAUE, this.IDSPORT, this.IDORDER, this.IDEVENT, this.DISPLAY);
            if (agentGameSchedule.ErrorCode == CErrorCode.ErrorNone)
            {
                xmlDocument.LoadXml(agentGameSchedule.ToXml());
                XmlNodeList xmlLeague = xmlDocument.SelectNodes("//league");
                XmlNodeList xmlOder = xmlDocument.SelectNodes("//order");
                XmlNodeList xmlDisplay = xmlDocument.SelectNodes("//period");
                XmlNodeList xmlEvent = xmlDocument.SelectNodes("//event");
                XmlNodeList prmGames = xmlDocument.SelectNodes("//game");
                this.LoadCombos(xmlLeague, xmlOder, xmlEvent, xmlDisplay);
                this.LoadSchedule(prmGames);
                this.BindGrid();
            }
            else if (agentGameSchedule.ErrorCode == CErrorCode.ErrorValidation)
                this.Response.Redirect("../Logout.aspx");
            else
                this.Response.Redirect("../MoveLines/ErrorSchedule.aspx");
        }

        private void LoadDataUpdate()
        {
            XmlDocument xmlDocument = new XmlDocument();
           AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
            CResultGetAgentSchedule getAgentSchedule = new CResultGetAgentSchedule();
            CResultGetAgentSchedule agentGameSchedule = agentInstance.GetAgentGameSchedule(this.IDAGENT, this.IDLINETYPE, this.IDLEGAUE, this.IDSPORT, this.IDORDER, this.IDEVENT, this.DISPLAY);
            if (agentGameSchedule.ErrorCode == CErrorCode.ErrorNone)
            {
                xmlDocument.LoadXml(agentGameSchedule.ToXml());
                this.LoadSchedule(xmlDocument.SelectNodes("//game"));
            }
            else if (agentGameSchedule.ErrorCode == CErrorCode.ErrorValidation)
                this.Response.Redirect("../Logout.aspx");
            else
                this.Response.Redirect("../MoveLines/ErrorSchedule.aspx");
        }

        private void LoadCombos(
          XmlNodeList xmlLeague,
          XmlNodeList xmlOder,
          XmlNodeList xmlEvent,
          XmlNodeList xmlDisplay)
        {
            this.cmbDisplay.Items.Clear();
            this.cmbEvent.Items.Clear();
            this.cmbLeague.Items.Clear();
            this.cmbOrder.Items.Clear();
            try
            {
                foreach (XmlNode xmlNode in xmlLeague)
                    this.cmbLeague.Items.Add(new ListItem()
                    {
                        Value = xmlNode.Attributes["Value"].Value.ToString(),
                        Text = xmlNode.Attributes["Text"].Value.ToString(),
                        Selected = xmlNode.Attributes["Selected"].Value.ToString() == "1"
                    });
                foreach (XmlNode xmlNode in xmlOder)
                    this.cmbOrder.Items.Add(new ListItem()
                    {
                        Value = xmlNode.Attributes["Value"].Value.ToString(),
                        Text = xmlNode.Attributes["Text"].Value.ToString(),
                        Selected = xmlNode.Attributes["Selected"].Value.ToString() == "1"
                    });
                foreach (XmlNode xmlNode in xmlEvent)
                    this.cmbEvent.Items.Add(new ListItem()
                    {
                        Value = xmlNode.Attributes["Value"].Value.ToString(),
                        Text = xmlNode.Attributes["Text"].Value.ToString(),
                        Selected = xmlNode.Attributes["Selected"].Value.ToString() == "1"
                    });
                foreach (XmlNode xmlNode in xmlDisplay)
                    this.cmbDisplay.Items.Add(new ListItem()
                    {
                        Value = xmlNode.Attributes["Value"].Value.ToString(),
                        Text = xmlNode.Attributes["Text"].Value.ToString(),
                        Selected = xmlNode.Attributes["Selected"].Value.ToString() == "1"
                    });
                this.cmbDisplay.AutoPostBack = true;
                this.cmbEvent.AutoPostBack = true;
                this.cmbLeague.AutoPostBack = true;
                this.cmbOrder.AutoPostBack = true;
            }
            catch
            {
                this.Response.Redirect("../MoveLines/ErrorSchedule.aspx");
            }
        }

        private void LoadSchedule(XmlNodeList prmGames)
        {
           AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
            CResultGetAgentChart cresultGetAgentChart = new CResultGetAgentChart();
            DataTable table = new DataTable();
            try
            {
                switch (this.IDSPORT)
                {
                    case "CBB":
                    case "NBA":
                    case "CFB":
                    case "NFL":
                        table.Columns.Add(new DataColumn("D/T", typeof(string)));
                        table.Columns.Add(new DataColumn("#", typeof(string)));
                        table.Columns.Add(new DataColumn("Team Name", typeof(string)));
                        table.Columns.Add(new DataColumn("Sprd", typeof(string)));
                        table.Columns.Add(new DataColumn("sOdds", typeof(string)));
                        table.Columns.Add(new DataColumn("sAction", typeof(string)));
                        table.Columns.Add(new DataColumn("Total", typeof(string)));
                        table.Columns.Add(new DataColumn("tOdds", typeof(string)));
                        table.Columns.Add(new DataColumn("tAction", typeof(string)));
                        table.Columns.Add(new DataColumn("$-Line", typeof(string)));
                        table.Columns.Add(new DataColumn("Action", typeof(string)));
                        table.Columns.Add(new DataColumn("*", typeof(string)));
                        table.Columns.Add(new DataColumn("ID", typeof(string)));
                        table.Columns.Add(new DataColumn("TYPE", typeof(string)));
                        table.Columns.Add(new DataColumn("SYNC", typeof(string)));
                        break;
                    case "MU":
                    case "SOC":
                        table.Columns.Add(new DataColumn("D/T", typeof(string)));
                        table.Columns.Add(new DataColumn("#", typeof(string)));
                        table.Columns.Add(new DataColumn("Team Name", typeof(string)));
                        table.Columns.Add(new DataColumn("$-Ln", typeof(string)));
                        table.Columns.Add(new DataColumn("lnAction", typeof(string)));
                        table.Columns.Add(new DataColumn("Total", typeof(string)));
                        table.Columns.Add(new DataColumn("Total_Odds", typeof(string)));
                        table.Columns.Add(new DataColumn("oAction", typeof(string)));
                        table.Columns.Add(new DataColumn("Sprd/Goals", typeof(string)));
                        table.Columns.Add(new DataColumn("Odds", typeof(string)));
                        table.Columns.Add(new DataColumn("Action", typeof(string)));
                        table.Columns.Add(new DataColumn("*", typeof(string)));
                        table.Columns.Add(new DataColumn("ID", typeof(string)));
                        table.Columns.Add(new DataColumn("TYPE", typeof(string)));
                        table.Columns.Add(new DataColumn("SYNC", typeof(string)));
                        break;
                    case "MLB":
                        table.Columns.Add(new DataColumn("D/T", typeof(string)));
                        table.Columns.Add(new DataColumn("#", typeof(string)));
                        table.Columns.Add(new DataColumn("Team Name", typeof(string)));
                        table.Columns.Add(new DataColumn("Pitcher", typeof(string)));
                        table.Columns.Add(new DataColumn("$-Ln", typeof(string)));
                        table.Columns.Add(new DataColumn("mlAction", typeof(string)));
                        table.Columns.Add(new DataColumn("Total", typeof(string)));
                        table.Columns.Add(new DataColumn("Odds", typeof(string)));
                        table.Columns.Add(new DataColumn("tAction", typeof(string)));
                        table.Columns.Add(new DataColumn("R-L", typeof(string)));
                        table.Columns.Add(new DataColumn("rlOdds", typeof(string)));
                        table.Columns.Add(new DataColumn("rlAction", typeof(string)));
                        table.Columns.Add(new DataColumn("*", typeof(string)));
                        table.Columns.Add(new DataColumn("ID", typeof(string)));
                        table.Columns.Add(new DataColumn("TYPE", typeof(string)));
                        table.Columns.Add(new DataColumn("SYNC", typeof(string)));
                        break;
                    case "NHL":
                        table.Columns.Add(new DataColumn("D/T", typeof(string)));
                        table.Columns.Add(new DataColumn("#", typeof(string)));
                        table.Columns.Add(new DataColumn("Team Name", typeof(string)));
                        table.Columns.Add(new DataColumn("$-Ln", typeof(string)));
                        table.Columns.Add(new DataColumn("mlAction", typeof(string)));
                        table.Columns.Add(new DataColumn("Total", typeof(string)));
                        table.Columns.Add(new DataColumn("Odds", typeof(string)));
                        table.Columns.Add(new DataColumn("tAction", typeof(string)));
                        table.Columns.Add(new DataColumn("C_L", typeof(string)));
                        table.Columns.Add(new DataColumn("clOdds", typeof(string)));
                        table.Columns.Add(new DataColumn("A_L", typeof(string)));
                        table.Columns.Add(new DataColumn("alOdds", typeof(string)));
                        table.Columns.Add(new DataColumn("Action", typeof(string)));
                        table.Columns.Add(new DataColumn("*", typeof(string)));
                        table.Columns.Add(new DataColumn("ID", typeof(string)));
                        table.Columns.Add(new DataColumn("TYPE", typeof(string)));
                        table.Columns.Add(new DataColumn("SYNC", typeof(string)));
                        break;
                    case "TNT":
                        table.Columns.Add(new DataColumn("CutOff", typeof(string)));
                        table.Columns.Add(new DataColumn("#", typeof(string)));
                        table.Columns.Add(new DataColumn("Description", typeof(string)));
                        table.Columns.Add(new DataColumn("Odds", typeof(string)));
                        table.Columns.Add(new DataColumn("Action", typeof(string)));
                        table.Columns.Add(new DataColumn("LastUpdate", typeof(string)));
                        table.Columns.Add(new DataColumn("*", typeof(string)));
                        table.Columns.Add(new DataColumn("ID", typeof(string)));
                        table.Columns.Add(new DataColumn("SYNC", typeof(string)));
                        break;
                    case "PROP":
                        table.Columns.Add(new DataColumn("CutOff", typeof(string)));
                        table.Columns.Add(new DataColumn("#", typeof(string)));
                        table.Columns.Add(new DataColumn("Prop Type", typeof(string)));
                        table.Columns.Add(new DataColumn("Description", typeof(string)));
                        table.Columns.Add(new DataColumn("Odds", typeof(string)));
                        table.Columns.Add(new DataColumn("Action", typeof(string)));
                        table.Columns.Add(new DataColumn("ID", typeof(string)));
                        table.Columns.Add(new DataColumn("SYNC", typeof(string)));
                        break;
                    case "ESOC":
                        table.Columns.Add(new DataColumn("D/T", typeof(string)));
                        table.Columns.Add(new DataColumn("#", typeof(string)));
                        table.Columns.Add(new DataColumn("Teams", typeof(string)));
                        table.Columns.Add(new DataColumn("Home", typeof(string)));
                        table.Columns.Add(new DataColumn("hAction", typeof(string)));
                        table.Columns.Add(new DataColumn("Draw", typeof(string)));
                        table.Columns.Add(new DataColumn("dAction", typeof(string)));
                        table.Columns.Add(new DataColumn("Visitor", typeof(string)));
                        table.Columns.Add(new DataColumn("vAction", typeof(string)));
                        table.Columns.Add(new DataColumn("*", typeof(string)));
                        table.Columns.Add(new DataColumn("ID", typeof(string)));
                        table.Columns.Add(new DataColumn("SYNC", typeof(string)));
                        break;
                }
                switch (this.IDSPORT)
                {
                    case "CBB":
                    case "NBA":
                    case "CFB":
                    case "NFL":
                        IEnumerator enumerator1 = prmGames.GetEnumerator();
                        try
                        {
                            while (enumerator1.MoveNext())
                            {
                                XmlNode current = (XmlNode)enumerator1.Current;
                                CResultGetAgentChart chartStraightValue = agentInstance.GetAgentChartStraightValue(long.Parse(current.Attributes["IdGame"].Value.ToString()), this.IDAGENT, this.IDSPORT, "");
                                if (chartStraightValue.ErrorCode == CErrorCode.ErrorValidation)
                                    this.Response.Redirect("../Logout.aspx");
                                DataRow row1 = table.NewRow();
                                row1[0] = (object)(DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("MMM-dd") + "<br />" + DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("hh:mm tt"));
                                row1[1] = (object)(current.Attributes["VisitorNumber"].Value.ToString() + "<br />" + current.Attributes["HomeNumber"].Value.ToString());
                                row1[2] = (object)(current.Attributes["VisitorTeam"].Value.ToString() + "<br />" + current.Attributes["HomeTeam"].Value.ToString());
                                row1[3] = (object)this.ValidateNumber(current.Attributes["VisitorSpread"].Value.ToString(), "");
                                row1[4] = (object)this.ValidateNumber(current.Attributes["VisitorSpreadOdds"].Value.ToString(), "");
                                row1[5] = (object)chartStraightValue.StraightbetVSpread.ToString();
                                row1[6] = (object)this.ValidateNumber(current.Attributes["TotalOver"].Value.ToString(), "o");
                                row1[7] = (object)this.ValidateNumber(current.Attributes["OverOdds"].Value.ToString(), "");
                                row1[8] = (object)chartStraightValue.StraightbetVTotal.ToString();
                                row1[9] = (object)this.ValidateNumber(current.Attributes["VisitorOdds"].Value.ToString(), "");
                                row1[10] = (object)chartStraightValue.StraightbetVMoney.ToString();
                                row1[11] = (object)(current.Attributes["GameStat"].Value.ToString() + "<br />" + current.Attributes["GameType"].Value.ToString());
                                row1[12] = (object)current.Attributes["IdGame"].Value.ToString();
                                row1[13] = (object)"V";
                                row1[14] = (object)(current.Attributes["SyncSpread"].Value.ToString() + "_" + current.Attributes["SyncTotal"].Value.ToString() + "_" + current.Attributes["SyncML"].Value.ToString());
                                table.Rows.Add(row1);
                                DataRow row2 = table.NewRow();
                                row2[0] = (object)"";
                                row2[1] = (object)"";
                                row2[2] = (object)"";
                                row2[3] = (object)this.ValidateNumber(current.Attributes["HomeSpread"].Value.ToString(), "");
                                row2[4] = (object)this.ValidateNumber(current.Attributes["HomeSpreadOdds"].Value.ToString(), "");
                                row2[5] = (object)chartStraightValue.StraightbetHSpread.ToString();
                                row2[6] = (object)this.ValidateNumber(current.Attributes["TotalUnder"].Value.ToString(), "u");
                                row2[7] = (object)this.ValidateNumber(current.Attributes["UnderOdds"].Value.ToString(), "");
                                row2[8] = (object)chartStraightValue.StraightbetHTotal.ToString();
                                row2[9] = (object)this.ValidateNumber(current.Attributes["HomeOdds"].Value.ToString(), "");
                                row2[10] = (object)chartStraightValue.StraightbetHMoney.ToString();
                                row2[11] = (object)"";
                                row2[12] = (object)current.Attributes["IdGame"].Value.ToString();
                                row2[13] = (object)"H";
                                row2[14] = (object)(current.Attributes["SyncSpread"].Value.ToString() + "_" + current.Attributes["SyncTotal"].Value.ToString() + "_" + current.Attributes["SyncML"].Value.ToString());
                                table.Rows.Add(row2);
                            }
                            break;
                        }
                        finally
                        {
                            if (enumerator1 is IDisposable disposable)
                                disposable.Dispose();
                        }
                    case "MU":
                    case "SOC":
                        IEnumerator enumerator2 = prmGames.GetEnumerator();
                        try
                        {
                            while (enumerator2.MoveNext())
                            {
                                XmlNode current = (XmlNode)enumerator2.Current;
                                CResultGetAgentChart chartStraightValue = agentInstance.GetAgentChartStraightValue(long.Parse(current.Attributes["IdGame"].Value.ToString()), this.IDAGENT, this.IDSPORT, "");
                                if (chartStraightValue.ErrorCode == CErrorCode.ErrorValidation)
                                    this.Response.Redirect("../Logout.aspx");
                                DataRow row1 = table.NewRow();
                                row1[0] = (object)(DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("MMM-dd") + "<br />" + DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("hh:mm tt"));
                                if (this.IdSport == "SOC")
                                    row1[1] = (object)(current.Attributes["VisitorNumber"].Value.ToString() + "<br />" + current.Attributes["HomeNumber"].Value.ToString() + "<br />" + (long.Parse(current.Attributes["HomeNumber"].Value.ToString()) + 1L).ToString());
                                if (this.IdSport == "MU")
                                    row1[1] = (object)(current.Attributes["VisitorNumber"].Value.ToString() + "<br />" + current.Attributes["HomeNumber"].Value.ToString());
                                if (this.IdSport == "SOC")
                                    row1[2] = (object)(current.Attributes["VisitorTeam"].Value.ToString() + "<br />" + current.Attributes["HomeTeam"].Value.ToString() + "<br />DRAW");
                                if (this.IdSport == "MU")
                                    row1[2] = (object)(current.Attributes["VisitorTeam"].Value.ToString() + "<br />" + current.Attributes["HomeTeam"].Value.ToString());
                                row1[3] = (object)this.ValidateNumber(current.Attributes["VisitorOdds"].Value.ToString(), "");
                                row1[4] = (object)chartStraightValue.StraightbetVMoney.ToString();
                                row1[5] = (object)this.ValidateNumber(current.Attributes["TotalOver"].Value.ToString(), "o");
                                row1[6] = (object)this.ValidateNumber(current.Attributes["OverOdds"].Value.ToString(), "");
                                row1[7] = (object)chartStraightValue.StraightbetVTotal.ToString();
                                row1[8] = (object)this.ValidateNumber(current.Attributes["VisitorSpread"].Value.ToString(), "");
                                row1[9] = (object)this.ValidateNumber(current.Attributes["VisitorSpreadOdds"].Value.ToString(), "");
                                row1[10] = (object)chartStraightValue.StraightbetVSpread.ToString();
                                row1[11] = (object)(current.Attributes["GameStat"].Value.ToString() + "<br />" + current.Attributes["GameType"].Value.ToString());
                                row1[12] = (object)current.Attributes["IdGame"].Value.ToString();
                                row1[13] = (object)"V";
                                row1[14] = (object)(current.Attributes["SyncSpread"].Value.ToString() + "_" + current.Attributes["SyncTotal"].Value.ToString() + "_" + current.Attributes["SyncML"].Value.ToString());
                                table.Rows.Add(row1);
                                DataRow row2 = table.NewRow();
                                row2[0] = (object)"";
                                row2[1] = (object)"";
                                row2[2] = (object)"";
                                row2[3] = (object)this.ValidateNumber(current.Attributes["HomeOdds"].Value.ToString(), "");
                                row2[4] = (object)chartStraightValue.StraightbetHMoney.ToString();
                                row2[5] = (object)this.ValidateNumber(current.Attributes["TotalUnder"].Value.ToString(), "u");
                                row2[6] = (object)this.ValidateNumber(current.Attributes["UnderOdds"].Value.ToString(), "");
                                row2[7] = (object)chartStraightValue.StraightbetHTotal.ToString();
                                row2[8] = (object)this.ValidateNumber(current.Attributes["HomeSpread"].Value.ToString(), "");
                                row2[9] = (object)this.ValidateNumber(current.Attributes["HomeSpreadOdds"].Value.ToString(), "");
                                row2[10] = (object)chartStraightValue.StraightbetHSpread.ToString();
                                row2[11] = (object)"";
                                row2[12] = (object)current.Attributes["IdGame"].Value.ToString();
                                row2[13] = (object)"H";
                                row2[14] = (object)(current.Attributes["SyncSpread"].Value.ToString() + "_" + current.Attributes["SyncTotal"].Value.ToString() + "_" + current.Attributes["SyncML"].Value.ToString());
                                table.Rows.Add(row2);
                                if (this.IDSPORT == "SOC")
                                {
                                    DataRow row3 = table.NewRow();
                                    row3[0] = (object)"";
                                    row3[1] = (object)"";
                                    row3[2] = (object)"";
                                    row3[3] = (object)this.ValidateNumber(current.Attributes["VisitorSpecialOdds"].Value.ToString(), "");
                                    row3[4] = (object)chartStraightValue.StraightbetD.ToString();
                                    row3[5] = (object)"";
                                    row3[6] = (object)"";
                                    row3[7] = (object)"";
                                    row3[8] = (object)"";
                                    row3[9] = (object)"";
                                    row3[10] = (object)"";
                                    row3[11] = (object)"";
                                    row3[12] = (object)current.Attributes["IdGame"].Value.ToString();
                                    row3[13] = (object)"D";
                                    row3[14] = (object)(current.Attributes["SyncSpread"].Value.ToString() + "_" + current.Attributes["SyncTotal"].Value.ToString() + "_" + current.Attributes["SyncML"].Value.ToString());
                                    table.Rows.Add(row3);
                                }
                            }
                            break;
                        }
                        finally
                        {
                            if (enumerator2 is IDisposable disposable)
                                disposable.Dispose();
                        }
                    case "MLB":
                        IEnumerator enumerator3 = prmGames.GetEnumerator();
                        try
                        {
                            while (enumerator3.MoveNext())
                            {
                                XmlNode current = (XmlNode)enumerator3.Current;
                                CResultGetAgentChart chartStraightValue = agentInstance.GetAgentChartStraightValue(long.Parse(current.Attributes["IdGame"].Value.ToString()), this.IDAGENT, this.IDSPORT, "");
                                if (chartStraightValue.ErrorCode == CErrorCode.ErrorValidation)
                                    this.Response.Redirect("../Logout.aspx");
                                DataRow row1 = table.NewRow();
                                row1[0] = (object)(DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("MMM-dd") + "<br />" + DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("hh:mm tt"));
                                row1[1] = (object)(current.Attributes["VisitorNumber"].Value.ToString() + "<br />" + current.Attributes["HomeNumber"].Value.ToString());
                                row1[2] = (object)(current.Attributes["VisitorTeam"].Value.ToString() + "<br />" + current.Attributes["HomeTeam"].Value.ToString());
                                row1[3] = (object)(current.Attributes["VisitorPitcher"].Value.ToString() + "<br />" + current.Attributes["HomePitcher"].Value.ToString());
                                row1[4] = (object)this.ValidateNumber(current.Attributes["VisitorOdds"].Value.ToString(), "");
                                row1[5] = (object)chartStraightValue.StraightbetVMoney.ToString();
                                row1[6] = (object)this.ValidateNumber(current.Attributes["TotalOver"].Value.ToString(), "o");
                                row1[7] = (object)this.ValidateNumber(current.Attributes["OverOdds"].Value.ToString(), "");
                                row1[8] = (object)chartStraightValue.StraightbetVTotal.ToString();
                                row1[9] = (object)this.ValidateNumber(current.Attributes["VisitorSpread"].Value.ToString(), "");
                                row1[10] = (object)this.ValidateNumber(current.Attributes["VisitorSpreadOdds"].Value.ToString(), "");
                                row1[11] = (object)chartStraightValue.StraightbetVSpread.ToString();
                                row1[12] = (object)(current.Attributes["GameStat"].Value.ToString() + "<br />" + current.Attributes["GameType"].Value.ToString());
                                row1[13] = (object)current.Attributes["IdGame"].Value.ToString();
                                row1[14] = (object)"V";
                                row1[15] = (object)(current.Attributes["SyncSpread"].Value.ToString() + "_" + current.Attributes["SyncTotal"].Value.ToString() + "_" + current.Attributes["SyncML"].Value.ToString());
                                table.Rows.Add(row1);
                                DataRow row2 = table.NewRow();
                                row2[0] = (object)"";
                                row2[1] = (object)"";
                                row2[2] = (object)"";
                                row2[3] = (object)"";
                                row2[4] = (object)this.ValidateNumber(current.Attributes["HomeOdds"].Value.ToString(), "");
                                row2[5] = (object)chartStraightValue.StraightbetHMoney.ToString();
                                row2[6] = (object)this.ValidateNumber(current.Attributes["TotalUnder"].Value.ToString(), "u");
                                row2[7] = (object)this.ValidateNumber(current.Attributes["UnderOdds"].Value.ToString(), "");
                                row2[8] = (object)chartStraightValue.StraightbetHTotal.ToString();
                                row2[9] = (object)this.ValidateNumber(current.Attributes["HomeSpread"].Value.ToString(), "");
                                row2[10] = (object)this.ValidateNumber(current.Attributes["HomeSpreadOdds"].Value.ToString(), "");
                                row2[11] = (object)chartStraightValue.StraightbetHSpread.ToString();
                                row2[12] = (object)"";
                                row2[13] = (object)current.Attributes["IdGame"].Value.ToString();
                                row2[14] = (object)"H";
                                row2[15] = (object)(current.Attributes["SyncSpread"].Value.ToString() + "_" + current.Attributes["SyncTotal"].Value.ToString() + "_" + current.Attributes["SyncML"].Value.ToString());
                                table.Rows.Add(row2);
                            }
                            break;
                        }
                        finally
                        {
                            if (enumerator3 is IDisposable disposable)
                                disposable.Dispose();
                        }
                    case "NHL":
                        IEnumerator enumerator4 = prmGames.GetEnumerator();
                        try
                        {
                            while (enumerator4.MoveNext())
                            {
                                XmlNode current = (XmlNode)enumerator4.Current;
                                CResultGetAgentChart chartStraightValue = agentInstance.GetAgentChartStraightValue(long.Parse(current.Attributes["IdGame"].Value.ToString()), this.IDAGENT, this.IDSPORT, "");
                                if (chartStraightValue.ErrorCode == CErrorCode.ErrorValidation)
                                    this.Response.Redirect("../Logout.aspx");
                                DataRow row1 = table.NewRow();
                                row1[0] = (object)(DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("MMM-dd") + "<br />" + DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("hh:mm tt"));
                                row1[1] = (object)(current.Attributes["VisitorNumber"].Value.ToString() + "<br />" + current.Attributes["HomeNumber"].Value.ToString());
                                row1[2] = (object)(current.Attributes["VisitorTeam"].Value.ToString() + "<br />" + current.Attributes["HomeTeam"].Value.ToString());
                                row1[3] = (object)this.ValidateNumber(current.Attributes["VisitorOdds"].Value.ToString(), "");
                                row1[4] = (object)chartStraightValue.StraightbetVMoney.ToString();
                                row1[5] = (object)this.ValidateNumber(current.Attributes["TotalOver"].Value.ToString(), "o");
                                row1[6] = (object)this.ValidateNumber(current.Attributes["OverOdds"].Value.ToString(), "");
                                row1[7] = (object)chartStraightValue.StraightbetVTotal.ToString();
                                row1[8] = (object)this.ValidateNumber(current.Attributes["VisitorSpecial"].Value.ToString(), "");
                                row1[9] = (object)this.ValidateNumber(current.Attributes["VisitorSpecialOdds"].Value.ToString(), "");
                                row1[10] = (object)this.ValidateNumber(current.Attributes["VisitorSpread"].Value.ToString(), "");
                                row1[11] = (object)this.ValidateNumber(current.Attributes["VisitorSpreadOdds"].Value.ToString(), "");
                                row1[12] = (object)chartStraightValue.StraightbetVSpread.ToString();
                                row1[13] = (object)(current.Attributes["GameStat"].Value.ToString() + "<br />" + current.Attributes["GameType"].Value.ToString());
                                row1[14] = (object)current.Attributes["IdGame"].Value.ToString();
                                row1[15] = (object)"V";
                                row1[16] = (object)(current.Attributes["SyncSpread"].Value.ToString() + "_" + current.Attributes["SyncTotal"].Value.ToString() + "_" + current.Attributes["SyncML"].Value.ToString());
                                table.Rows.Add(row1);
                                DataRow row2 = table.NewRow();
                                row2[0] = (object)"";
                                row2[1] = (object)"";
                                row2[2] = (object)"";
                                row2[3] = (object)this.ValidateNumber(current.Attributes["HomeOdds"].Value.ToString(), "");
                                row2[4] = (object)chartStraightValue.StraightbetHMoney.ToString();
                                row2[5] = (object)this.ValidateNumber(current.Attributes["TotalUnder"].Value.ToString(), "u");
                                row2[6] = (object)this.ValidateNumber(current.Attributes["UnderOdds"].Value.ToString(), "");
                                row2[7] = (object)chartStraightValue.StraightbetHTotal.ToString();
                                row2[8] = (object)this.ValidateNumber(current.Attributes["HomeSpecial"].Value.ToString(), "");
                                row2[9] = (object)this.ValidateNumber(current.Attributes["HomeSpecialOdds"].Value.ToString(), "");
                                row2[10] = (object)this.ValidateNumber(current.Attributes["HomeSpread"].Value.ToString(), "");
                                row2[11] = (object)this.ValidateNumber(current.Attributes["HomeSpreadOdds"].Value.ToString(), "");
                                row2[12] = (object)chartStraightValue.StraightbetHSpread.ToString();
                                row2[13] = (object)"";
                                row2[14] = (object)current.Attributes["IdGame"].Value.ToString();
                                row2[15] = (object)"H";
                                row2[16] = (object)(current.Attributes["SyncSpread"].Value.ToString() + "_" + current.Attributes["SyncTotal"].Value.ToString() + "_" + current.Attributes["SyncML"].Value.ToString());
                                table.Rows.Add(row2);
                            }
                            break;
                        }
                        finally
                        {
                            if (enumerator4 is IDisposable disposable)
                                disposable.Dispose();
                        }
                    case "TNT":
                        IEnumerator enumerator5 = prmGames.GetEnumerator();
                        try
                        {
                            while (enumerator5.MoveNext())
                            {
                                XmlNode current = (XmlNode)enumerator5.Current;
                                CResultGetAgentChart chartStraightValue = agentInstance.GetAgentChartStraightValue(long.Parse(current.Attributes["IdGame"].Value.ToString()), this.IDAGENT, this.IDSPORT, current.Attributes["VisitorOdds"].Value.ToString());
                                if (chartStraightValue.ErrorCode == CErrorCode.ErrorValidation)
                                    this.Response.Redirect("../Logout.aspx");
                                DataRow row = table.NewRow();
                                row[0] = (object)(DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("MMM-dd") + "<br />" + DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("hh:mm tt"));
                                row[1] = (object)current.Attributes["VisitorOdds"].Value.ToString();
                                row[2] = (object)(current.Attributes["TotalOver"].Value.ToString() + " - " + current.Attributes["VisitorTeam"].Value.ToString());
                                row[3] = (object)this.ValidateNumber(current.Attributes["HomeOdds"].Value.ToString(), "");
                                row[4] = (object)chartStraightValue.TNTValue.ToString();
                                row[5] = (object)(DateTime.Parse(current.Attributes["LastModification"].Value.ToString()).ToString("MMM-dd") + "<br />" + DateTime.Parse(current.Attributes["LastModification"].Value.ToString()).ToString("hh:mm tt"));
                                row[6] = (object)current.Attributes["GameStat"].Value.ToString();
                                row[7] = (object)current.Attributes["IdGame"].Value.ToString();
                                row[8] = (object)(current.Attributes["SyncSpread"].Value.ToString() + "_" + current.Attributes["SyncTotal"].Value.ToString() + "_" + current.Attributes["SyncML"].Value.ToString());
                                table.Rows.Add(row);
                            }
                            break;
                        }
                        finally
                        {
                            if (enumerator5 is IDisposable disposable)
                                disposable.Dispose();
                        }
                    case "PROP":
                        IEnumerator enumerator6 = prmGames.GetEnumerator();
                        try
                        {
                            while (enumerator6.MoveNext())
                            {
                                XmlNode current = (XmlNode)enumerator6.Current;
                                CResultGetAgentChart chartStraightValue = agentInstance.GetAgentChartStraightValue(long.Parse(current.Attributes["IdGame"].Value.ToString()), this.IDAGENT, this.IDSPORT, "");
                                if (chartStraightValue.ErrorCode == CErrorCode.ErrorValidation)
                                    this.Response.Redirect("../Logout.aspx");
                                DataRow row = table.NewRow();
                                row[0] = (object)(DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("MMM-dd") + "<br />" + DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("hh:mm tt"));
                                row[1] = (object)current.Attributes["VisitorOdds"].Value.ToString();
                                row[2] = (object)current.Attributes["VisitorTeam"].Value.ToString();
                                row[3] = (object)current.Attributes["HomeTeam"].Value.ToString();
                                row[4] = (object)this.ValidateNumber(current.Attributes["HomeOdds"].Value.ToString(), "");
                                row[5] = (object)chartStraightValue.StraightbetVSpread.ToString();
                                row[6] = (object)current.Attributes["IdGame"].Value.ToString();
                                row[7] = (object)(current.Attributes["SyncSpread"].Value.ToString() + "_" + current.Attributes["SyncTotal"].Value.ToString() + "_" + current.Attributes["SyncML"].Value.ToString());
                                table.Rows.Add(row);
                            }
                            break;
                        }
                        finally
                        {
                            if (enumerator6 is IDisposable disposable)
                                disposable.Dispose();
                        }
                    case "ESOC":
                        IEnumerator enumerator7 = prmGames.GetEnumerator();
                        try
                        {
                            while (enumerator7.MoveNext())
                            {
                                XmlNode current = (XmlNode)enumerator7.Current;
                                CResultGetAgentChart chartStraightValue = agentInstance.GetAgentChartStraightValue(long.Parse(current.Attributes["IdGame"].Value.ToString()), this.IDAGENT, this.IDSPORT, "");
                                if (chartStraightValue.ErrorCode == CErrorCode.ErrorValidation)
                                    this.Response.Redirect("../Logout.aspx");
                                DataRow row = table.NewRow();
                                row[0] = (object)(DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("MMM-dd") + "<br />" + DateTime.Parse(current.Attributes["GameDateTime"].Value.ToString()).ToString("hh:mm tt"));
                                row[1] = (object)current.Attributes["VisitorNumber"].Value.ToString();
                                row[2] = (object)(current.Attributes["VisitorTeam"].Value.ToString() + " - " + current.Attributes["HomeTeam"].Value.ToString());
                                row[3] = (object)this.ValidateNumber(current.Attributes["HomeOdds"].Value.ToString(), "");
                                row[4] = (object)chartStraightValue.StraightbetVMoney.ToString();
                                row[5] = (object)this.ValidateNumber(current.Attributes["VisitorSpecialOdds"].Value.ToString(), "");
                                row[6] = (object)chartStraightValue.StraightbetD.ToString();
                                row[7] = (object)this.ValidateNumber(current.Attributes["VisitorOdds"].Value.ToString(), "");
                                row[8] = (object)chartStraightValue.StraightbetHMoney.ToString();
                                row[9] = (object)(current.Attributes["GameStat"].Value.ToString() + "<br />" + current.Attributes["GameType"].Value.ToString());
                                row[10] = (object)current.Attributes["IdGame"].Value.ToString();
                                row[11] = (object)(current.Attributes["SyncSpread"].Value.ToString() + "_" + current.Attributes["SyncTotal"].Value.ToString() + "_" + current.Attributes["SyncML"].Value.ToString());
                                table.Rows.Add(row);
                            }
                            break;
                        }
                        finally
                        {
                            if (enumerator7 is IDisposable disposable)
                                disposable.Dispose();
                        }
                }
                this.dsSchedule.Tables.Clear();
                this.dsSchedule.Tables.Add(table);
            }
            catch (Exception ex)
            {
                ex.ToString();
                this.Response.Redirect("../Report/ErrorHandle.aspx");
            }
        }

        private void GetSportTitle()
        {
            switch (this.IDSPORT)
            {
                case "NFL":
                    this.sSportTitle = "NFL Football";
                    break;
                case "NBA":
                    this.sSportTitle = "NBA Basketball";
                    break;
                case "MLB":
                    this.sSportTitle = "ML Baseball";
                    break;
                case "MU":
                    this.sSportTitle = "Matchups";
                    break;
                case "TNT":
                    this.sSportTitle = "Tournaments";
                    break;
                case "CFB":
                    this.sSportTitle = "College Football";
                    break;
                case "CBB":
                    this.sSportTitle = "College Basketball";
                    break;
                case "NHL":
                    this.sSportTitle = "NHL Hockey";
                    break;
                case "SOC":
                    this.sSportTitle = "Soccer";
                    break;
                case "PROP":
                    this.sSportTitle = "Propositions";
                    break;
                case "ESOC":
                    this.sSportTitle = "European Soccer";
                    break;
            }
            this.sSportTitle = this.sSportTitle.ToUpper();
            this.strSport = this.IDSPORT;
        }

        private void BindGrid()
        {
            switch (this.IDSPORT)
            {
                case "CBB":
                case "NBA":
                case "CFB":
                case "NFL":
                    this.sDGridFB.DataSource = (object)this.dsSchedule;
                    this.sDGridFB.DataBind();
                    break;
                case "MU":
                case "SOC":
                    this.sDGridSM.DataSource = (object)this.dsSchedule;
                    this.sDGridSM.DataBind();
                    break;
                case "MLB":
                    this.sDGridM.DataSource = (object)this.dsSchedule;
                    this.sDGridM.DataBind();
                    break;
                case "NHL":
                    this.sDGridN.DataSource = (object)this.dsSchedule;
                    this.sDGridN.DataBind();
                    break;
                case "TNT":
                    this.sDGridT.DataSource = (object)this.dsSchedule;
                    this.sDGridT.DataBind();
                    break;
                case "PROP":
                    this.sDGridP.DataSource = (object)this.dsSchedule;
                    this.sDGridP.DataBind();
                    break;
                case "ESOC":
                    this.sDGridE.DataSource = (object)this.dsSchedule;
                    this.sDGridE.DataBind();
                    break;
            }
            this.MergeRows();
        }

        private void MergeRows()
        {
            switch (this.IDSPORT)
            {
                case "CBB":
                case "NBA":
                case "CFB":
                case "NFL":
                    for (int index = 0; index < this.sDGridFB.Items.Count; ++index)
                    {
                        DataGridItem dataGridItem = this.sDGridFB.Items[index];
                        if (dataGridItem.ItemIndex % 2 == 0)
                        {
                            dataGridItem.Cells[0].RowSpan = 2;
                            dataGridItem.Cells[1].RowSpan = 2;
                            dataGridItem.Cells[2].RowSpan = 2;
                            dataGridItem.Cells[11].RowSpan = 2;
                            dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[3].Width = (Unit)45;
                            dataGridItem.Cells[4].Width = (Unit)45;
                            dataGridItem.Cells[5].Width = (Unit)45;
                            dataGridItem.Cells[6].Width = (Unit)45;
                            dataGridItem.Cells[7].Width = (Unit)45;
                            dataGridItem.Cells[8].Width = (Unit)45;
                            dataGridItem.Cells[9].Width = (Unit)45;
                            dataGridItem.Cells[10].Width = (Unit)45;
                            dataGridItem.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[6].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[7].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[8].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[9].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[10].HorizontalAlign = HorizontalAlign.Center;
                        }
                        if (dataGridItem.ItemIndex % 2 == 1)
                        {
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(8);
                            dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[2].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[6].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[7].HorizontalAlign = HorizontalAlign.Center;
                        }
                    }
                    break;
                case "SOC":
                    for (int index = 0; index < this.sDGridSM.Items.Count; ++index)
                    {
                        DataGridItem dataGridItem = this.sDGridSM.Items[index];
                        if (dataGridItem.ItemIndex % 3 == 0)
                        {
                            dataGridItem.Cells[0].RowSpan = 3;
                            dataGridItem.Cells[1].RowSpan = 3;
                            dataGridItem.Cells[2].RowSpan = 3;
                            dataGridItem.Cells[11].RowSpan = 3;
                            dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[3].Width = (Unit)45;
                            dataGridItem.Cells[4].Width = (Unit)45;
                            dataGridItem.Cells[5].Width = (Unit)45;
                            dataGridItem.Cells[6].Width = (Unit)45;
                            dataGridItem.Cells[7].Width = (Unit)45;
                            dataGridItem.Cells[8].Width = (Unit)45;
                            dataGridItem.Cells[9].Width = (Unit)45;
                            dataGridItem.Cells[10].Width = (Unit)45;
                            dataGridItem.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[6].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[7].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[8].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[9].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[10].HorizontalAlign = HorizontalAlign.Center;
                        }
                        if (dataGridItem.ItemIndex % 3 == 1)
                        {
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(8);
                            dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[2].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[6].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[7].HorizontalAlign = HorizontalAlign.Center;
                        }
                        if (dataGridItem.ItemIndex % 3 == 2)
                        {
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(8);
                            dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[2].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[6].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[7].HorizontalAlign = HorizontalAlign.Center;
                        }
                    }
                    break;
                case "MU":
                    for (int index = 0; index < this.sDGridSM.Items.Count; ++index)
                    {
                        DataGridItem dataGridItem = this.sDGridSM.Items[index];
                        if (dataGridItem.ItemIndex % 2 == 0)
                        {
                            dataGridItem.Cells[0].RowSpan = 2;
                            dataGridItem.Cells[1].RowSpan = 2;
                            dataGridItem.Cells[2].RowSpan = 2;
                            dataGridItem.Cells[11].RowSpan = 2;
                            dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[3].Width = (Unit)45;
                            dataGridItem.Cells[4].Width = (Unit)45;
                            dataGridItem.Cells[5].Width = (Unit)45;
                            dataGridItem.Cells[6].Width = (Unit)45;
                            dataGridItem.Cells[7].Width = (Unit)45;
                            dataGridItem.Cells[8].Width = (Unit)45;
                            dataGridItem.Cells[9].Width = (Unit)45;
                            dataGridItem.Cells[10].Width = (Unit)45;
                            dataGridItem.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[6].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[7].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[8].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[9].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[10].HorizontalAlign = HorizontalAlign.Center;
                        }
                        if (dataGridItem.ItemIndex % 2 == 1)
                        {
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(8);
                            dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[2].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[6].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[7].HorizontalAlign = HorizontalAlign.Center;
                        }
                    }
                    break;
                case "MLB":
                    for (int index = 0; index < this.sDGridM.Items.Count; ++index)
                    {
                        DataGridItem dataGridItem = this.sDGridM.Items[index];
                        if (dataGridItem.ItemIndex % 2 == 0)
                        {
                            dataGridItem.Cells[0].RowSpan = 2;
                            dataGridItem.Cells[1].RowSpan = 2;
                            dataGridItem.Cells[2].RowSpan = 2;
                            dataGridItem.Cells[3].RowSpan = 2;
                            dataGridItem.Cells[12].RowSpan = 2;
                            dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[3].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[4].Width = (Unit)40;
                            dataGridItem.Cells[5].Width = (Unit)40;
                            dataGridItem.Cells[6].Width = (Unit)40;
                            dataGridItem.Cells[7].Width = (Unit)40;
                            dataGridItem.Cells[8].Width = (Unit)40;
                            dataGridItem.Cells[9].Width = (Unit)40;
                            dataGridItem.Cells[10].Width = (Unit)40;
                            dataGridItem.Cells[11].Width = (Unit)40;
                            dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[6].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[7].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[8].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[9].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[10].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[11].HorizontalAlign = HorizontalAlign.Center;
                        }
                        if (dataGridItem.ItemIndex % 2 == 1)
                        {
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(8);
                            dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[2].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[6].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[7].HorizontalAlign = HorizontalAlign.Center;
                        }
                    }
                    break;
                case "NHL":
                    for (int index = 0; index < this.sDGridN.Items.Count; ++index)
                    {
                        DataGridItem dataGridItem = this.sDGridN.Items[index];
                        if (dataGridItem.ItemIndex % 2 == 0)
                        {
                            dataGridItem.Cells[0].RowSpan = 2;
                            dataGridItem.Cells[1].RowSpan = 2;
                            dataGridItem.Cells[2].RowSpan = 2;
                            dataGridItem.Cells[13].RowSpan = 2;
                            dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[3].Width = (Unit)45;
                            dataGridItem.Cells[4].Width = (Unit)45;
                            dataGridItem.Cells[5].Width = (Unit)45;
                            dataGridItem.Cells[6].Width = (Unit)45;
                            dataGridItem.Cells[7].Width = (Unit)45;
                            dataGridItem.Cells[8].Width = (Unit)45;
                            dataGridItem.Cells[9].Width = (Unit)45;
                            dataGridItem.Cells[10].Width = (Unit)45;
                            dataGridItem.Cells[11].Width = (Unit)45;
                            dataGridItem.Cells[12].Width = (Unit)45;
                            dataGridItem.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[6].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[7].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[8].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[9].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[10].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[11].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[12].HorizontalAlign = HorizontalAlign.Center;
                        }
                        if (dataGridItem.ItemIndex % 2 == 1)
                        {
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(0);
                            dataGridItem.Cells.RemoveAt(10);
                            dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[2].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Center;
                            dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[6].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[7].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[8].HorizontalAlign = HorizontalAlign.Right;
                            dataGridItem.Cells[9].HorizontalAlign = HorizontalAlign.Center;
                        }
                    }
                    break;
                case "PROP":
                    for (int index = 0; index < this.sDGridP.Items.Count; ++index)
                    {
                        DataGridItem dataGridItem = this.sDGridP.Items[index];
                        dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Center;
                        dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                        dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Right;
                        dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Center;
                    }
                    break;
                case "TNT":
                    for (int index = 0; index < this.sDGridT.Items.Count; ++index)
                    {
                        DataGridItem dataGridItem = this.sDGridT.Items[index];
                        dataGridItem.Cells[3].Width = (Unit)45;
                        dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Center;
                        dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                        dataGridItem.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                        dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Center;
                        dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Center;
                    }
                    break;
                case "ESOC":
                    for (int index = 0; index < this.sDGridE.Items.Count; ++index)
                    {
                        DataGridItem dataGridItem = this.sDGridE.Items[index];
                        dataGridItem.Cells[3].Width = (Unit)45;
                        dataGridItem.Cells[5].Width = (Unit)45;
                        dataGridItem.Cells[7].Width = (Unit)45;
                        dataGridItem.Cells[0].HorizontalAlign = HorizontalAlign.Center;
                        dataGridItem.Cells[1].HorizontalAlign = HorizontalAlign.Center;
                        dataGridItem.Cells[3].HorizontalAlign = HorizontalAlign.Right;
                        dataGridItem.Cells[4].HorizontalAlign = HorizontalAlign.Center;
                        dataGridItem.Cells[5].HorizontalAlign = HorizontalAlign.Right;
                        dataGridItem.Cells[6].HorizontalAlign = HorizontalAlign.Center;
                        dataGridItem.Cells[7].HorizontalAlign = HorizontalAlign.Right;
                        dataGridItem.Cells[8].HorizontalAlign = HorizontalAlign.Center;
                    }
                    break;
            }
        }

        private void AlertErrorMsg(string ErrorMsg)
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<script language=\"javascript\">\n");
            stringBuilder.Append("alert(");
            stringBuilder.Append("\"" + ErrorMsg + "\"");
            stringBuilder.Append(");\n");
            stringBuilder.Append("</script>\n");
            if (!this.Page.ClientScript.IsClientScriptBlockRegistered("Changethescrpt"))
                this.Page.ClientScript.RegisterClientScriptBlock(typeof(string), "Changethescrpt", stringBuilder.ToString());
            this.Load += new EventHandler(this.Page_Load);
        }

        public void EditEvent(object sender, DataGridCommandEventArgs e)
        {
            switch (this.IDSPORT)
            {
                case "CBB":
                case "NBA":
                case "CFB":
                case "NFL":
                    this.sDGridFB.EditItemIndex = e.Item.ItemIndex;
                    break;
                case "MU":
                case "SOC":
                    this.sDGridSM.EditItemIndex = e.Item.ItemIndex;
                    break;
                case "MLB":
                    this.sDGridM.EditItemIndex = e.Item.ItemIndex;
                    break;
                case "NHL":
                    this.sDGridN.EditItemIndex = e.Item.ItemIndex;
                    break;
                case "TNT":
                    this.sDGridT.EditItemIndex = e.Item.ItemIndex;
                    break;
                case "PROP":
                    this.sDGridP.EditItemIndex = e.Item.ItemIndex;
                    break;
                case "ESOC":
                    this.sDGridE.EditItemIndex = e.Item.ItemIndex;
                    break;
            }
            this.BindGrid();
        }

        public void CancelEvent(object sender, DataGridCommandEventArgs e)
        {
            switch (this.IDSPORT)
            {
                case "CBB":
                case "NBA":
                case "CFB":
                case "NFL":
                    this.sDGridFB.EditItemIndex = -1;
                    break;
                case "MU":
                case "SOC":
                    this.sDGridSM.EditItemIndex = -1;
                    break;
                case "MLB":
                    this.sDGridM.EditItemIndex = -1;
                    break;
                case "NHL":
                    this.sDGridN.EditItemIndex = -1;
                    break;
                case "TNT":
                    this.sDGridT.EditItemIndex = -1;
                    break;
                case "PROP":
                    this.sDGridP.EditItemIndex = -1;
                    break;
                case "ESOC":
                    this.sDGridE.EditItemIndex = -1;
                    break;
            }
            this.BindGrid();
        }

        public void UpdateEvent(object sender, DataGridCommandEventArgs e)
        {
            switch (this.IDSPORT)
            {
                case "CBB":
                case "NBA":
                case "CFB":
                case "NFL":
                    long IdGame1 = long.Parse(this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][12].ToString());
                    string prmOld1 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][3].ToString();
                    string prmOld2 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][6].ToString();
                    string prmOld3 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][9].ToString();
                    string prmOld4 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][4].ToString();
                    string prmOld5 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][7].ToString();
                    string str1 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][13].ToString();
                    string SyncList1 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][14].ToString();
                    if (str1 == "V")
                    {
                        string FieldNumber = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][1].ToString();
                        string str2 = this.Request.Form[e.Item.Cells[3].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str3 = this.Request.Form[e.Item.Cells[6].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str4 = this.Request.Form[e.Item.Cells[9].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str5 = this.Request.Form[e.Item.Cells[4].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str6 = this.Request.Form[e.Item.Cells[7].Controls[1].ClientID.ToString().Replace("_", "$")];
                        if (this.EvalChange(prmOld1, str2, "VSpread"))
                            this.Sync("Spread", FieldNumber, "VSpread", SyncList1, false, str2, true, IdGame1, 3);
                        if (this.EvalChange(prmOld2, str3, "TOver"))
                            this.Sync("Total", FieldNumber, "TOver", SyncList1, false, str3, true, IdGame1, 7);
                        if (this.EvalChange(prmOld3, str4, "VOdds"))
                            this.Sync("ML", FieldNumber, "VOdds", SyncList1, true, str4, true, IdGame1, 11);
                        if (this.EvalChange(prmOld4, str5, "VSOdds"))
                            this.Sync("Spread", FieldNumber, "VSOdds", SyncList1, true, str5, true, IdGame1, 4);
                        if (this.EvalChange(prmOld5, str6, "OOdds"))
                            this.Sync("Total", FieldNumber, "OOdds", SyncList1, true, str6, true, IdGame1, 8);
                    }
                    else
                    {
                        string FieldNumber = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex - 1][1].ToString();
                        string str2 = this.Request.Form[e.Item.Cells[0].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str3 = this.Request.Form[e.Item.Cells[3].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str4 = this.Request.Form[e.Item.Cells[6].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str5 = this.Request.Form[e.Item.Cells[1].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str6 = this.Request.Form[e.Item.Cells[4].Controls[1].ClientID.ToString().Replace("_", "$")];
                        if (this.EvalChange(prmOld1, str2, "HSpread"))
                            this.Sync("Spread", FieldNumber, "HSpread", SyncList1, false, str2, false, IdGame1, 3);
                        if (this.EvalChange(prmOld2, str3, "TUnder"))
                            this.Sync("Total", FieldNumber, "TUnder", SyncList1, false, str3, false, IdGame1, 7);
                        if (this.EvalChange(prmOld3, str4, "HOdds"))
                            this.Sync("ML", FieldNumber, "HOdds", SyncList1, true, str4, false, IdGame1, 11);
                        if (this.EvalChange(prmOld4, str5, "HSOdds"))
                            this.Sync("Spread", FieldNumber, "HSOdds", SyncList1, true, str5, false, IdGame1, 4);
                        if (this.EvalChange(prmOld5, str6, "UOdds"))
                            this.Sync("Total", FieldNumber, "UOdds", SyncList1, true, str6, false, IdGame1, 8);
                    }
                    this.sDGridFB.EditItemIndex = -1;
                    break;
                case "MU":
                case "SOC":
                    long IdGame2 = long.Parse(this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][12].ToString());
                    string prmOld6 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][8].ToString();
                    string prmOld7 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][5].ToString();
                    string prmOld8 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][3].ToString();
                    string prmOld9 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][9].ToString();
                    string prmOld10 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][6].ToString();
                    string str7 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][13].ToString();
                    string SyncList2 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][14].ToString();
                    switch (str7)
                    {
                        case "V":
                            string FieldNumber1 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][1].ToString();
                            string str8 = this.Request.Form[e.Item.Cells[3].Controls[1].ClientID.ToString().Replace("_", "$")];
                            string str9 = this.Request.Form[e.Item.Cells[5].Controls[1].ClientID.ToString().Replace("_", "$")];
                            string str10 = this.Request.Form[e.Item.Cells[6].Controls[1].ClientID.ToString().Replace("_", "$")];
                            string str11 = this.Request.Form[e.Item.Cells[8].Controls[1].ClientID.ToString().Replace("_", "$")];
                            string str12 = this.Request.Form[e.Item.Cells[9].Controls[1].ClientID.ToString().Replace("_", "$")];
                            if (this.EvalChange(prmOld8, str8, "VOdds"))
                                this.Sync("ML", FieldNumber1, "VOdds", SyncList2, true, str8, true, IdGame2, 3);
                            if (this.EvalChange(prmOld7, str9, "TOver"))
                                this.Sync("Total", FieldNumber1, "TOver", SyncList2, false, str9, true, IdGame2, 5);
                            if (this.EvalChange(prmOld10, str10, "OOdds"))
                                this.Sync("Total", FieldNumber1, "OOdds", SyncList2, true, str10, true, IdGame2, 7);
                            if (this.EvalChange(prmOld6, str11, "VSpread"))
                                this.Sync("Spread", FieldNumber1, "VSpread", SyncList2, false, str11, true, IdGame2, 10);
                            if (this.EvalChange(prmOld9, str12, "VSOdds"))
                            {
                                this.Sync("Spread", FieldNumber1, "VSOdds", SyncList2, true, str12, true, IdGame2, 11);
                                break;
                            }
                            break;
                        case "H":
                            string FieldNumber2 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex - 1][1].ToString();
                            string str13 = this.Request.Form[e.Item.Cells[0].Controls[1].ClientID.ToString().Replace("_", "$")];
                            string str14 = this.Request.Form[e.Item.Cells[2].Controls[1].ClientID.ToString().Replace("_", "$")];
                            string str15 = this.Request.Form[e.Item.Cells[3].Controls[1].ClientID.ToString().Replace("_", "$")];
                            string str16 = this.Request.Form[e.Item.Cells[5].Controls[1].ClientID.ToString().Replace("_", "$")];
                            string str17 = this.Request.Form[e.Item.Cells[6].Controls[1].ClientID.ToString().Replace("_", "$")];
                            if (this.EvalChange(prmOld8, str13, "HOdds"))
                                this.Sync("ML", FieldNumber2, "HOdds", SyncList2, true, str13, false, IdGame2, 3);
                            if (this.EvalChange(prmOld7, str14, "TUnder"))
                                this.Sync("Total", FieldNumber2, "TUnder", SyncList2, false, str14, false, IdGame2, 5);
                            if (this.EvalChange(prmOld10, str15, "UOdds"))
                                this.Sync("Total", FieldNumber2, "UOdds", SyncList2, true, str15, false, IdGame2, 7);
                            if (this.EvalChange(prmOld6, str16, "HSpread"))
                                this.Sync("Spread", FieldNumber2, "HSpread", SyncList2, false, str16, false, IdGame2, 10);
                            if (this.EvalChange(prmOld9, str17, "HSOdds"))
                            {
                                this.Sync("Spread", FieldNumber2, "HSOdds", SyncList2, true, str17, false, IdGame2, 11);
                                break;
                            }
                            break;
                        case "D":
                            string FieldNumber3 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex - 2][1].ToString();
                            string str18 = this.Request.Form[e.Item.Cells[0].Controls[1].ClientID.ToString().Replace("_", "$")];
                            if (this.EvalChange(prmOld8, str18, "DRAWV"))
                            {
                                this.Sync("ML", FieldNumber3, "DRAW", SyncList2, true, str18, true, IdGame2, 3);
                                break;
                            }
                            break;
                    }
                    this.sDGridSM.EditItemIndex = -1;
                    break;
                case "MLB":
                    long IdGame3 = long.Parse(this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][13].ToString());
                    string prmOld11 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][9].ToString();
                    string prmOld12 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][6].ToString();
                    string prmOld13 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][4].ToString();
                    string prmOld14 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][10].ToString();
                    string prmOld15 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][7].ToString();
                    string str19 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][14].ToString();
                    string SyncList3 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][15].ToString();
                    if (str19 == "V")
                    {
                        string FieldNumber4 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][1].ToString();
                        string str2 = this.Request.Form[e.Item.Cells[4].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str3 = this.Request.Form[e.Item.Cells[6].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str4 = this.Request.Form[e.Item.Cells[7].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str5 = this.Request.Form[e.Item.Cells[9].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str6 = this.Request.Form[e.Item.Cells[10].Controls[1].ClientID.ToString().Replace("_", "$")];
                        if (this.EvalChange(prmOld13, str2, "VOdds"))
                            this.Sync("ML", FieldNumber4, "VOdds", SyncList3, true, str2, true, IdGame3, 4);
                        if (this.EvalChange(prmOld12, str3, "TOver"))
                            this.Sync("Total", FieldNumber4, "TOver", SyncList3, false, str3, true, IdGame3, 7);
                        if (this.EvalChange(prmOld15, str4, "OOdds"))
                            this.Sync("Total", FieldNumber4, "OOdds", SyncList3, true, str4, true, IdGame3, 8);
                        if (this.EvalChange(prmOld11, str5, "VSpread"))
                            this.Sync("Spread", FieldNumber4, "VSpread", SyncList3, false, str5, true, IdGame3, 11);
                        if (this.EvalChange(prmOld14, str6, "VSOdds"))
                            this.Sync("Spread", FieldNumber4, "VSOdds", SyncList3, true, str6, true, IdGame3, 12);
                    }
                    else
                    {
                        string FieldNumber4 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex - 1][1].ToString();
                        string str2 = this.Request.Form[e.Item.Cells[0].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str3 = this.Request.Form[e.Item.Cells[2].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str4 = this.Request.Form[e.Item.Cells[3].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str5 = this.Request.Form[e.Item.Cells[5].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str6 = this.Request.Form[e.Item.Cells[6].Controls[1].ClientID.ToString().Replace("_", "$")];
                        if (this.EvalChange(prmOld13, str2, "HOdds"))
                            this.Sync("ML", FieldNumber4, "HOdds", SyncList3, true, str2, false, IdGame3, 4);
                        if (this.EvalChange(prmOld12, str3, "TUnder"))
                            this.Sync("Total", FieldNumber4, "TUnder", SyncList3, false, str3, false, IdGame3, 7);
                        if (this.EvalChange(prmOld15, str4, "UOdds"))
                            this.Sync("Total", FieldNumber4, "UOdds", SyncList3, true, str4, false, IdGame3, 8);
                        if (this.EvalChange(prmOld11, str5, "HSpread"))
                            this.Sync("Spread", FieldNumber4, "HSpread", SyncList3, false, str5, false, IdGame3, 11);
                        if (this.EvalChange(prmOld14, str6, "HSOdds"))
                            this.Sync("Spread", FieldNumber4, "HSOdds", SyncList3, true, str6, false, IdGame3, 12);
                    }
                    this.sDGridM.EditItemIndex = -1;
                    break;
                case "NHL":
                    long IdGame4 = long.Parse(this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][14].ToString());
                    string prmOld16 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][10].ToString();
                    string prmOld17 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][5].ToString();
                    string prmOld18 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][3].ToString();
                    string prmOld19 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][11].ToString();
                    string prmOld20 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][6].ToString();
                    string prmOld21 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][8].ToString();
                    string prmOld22 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][9].ToString();
                    string str20 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][15].ToString();
                    string SyncList4 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][16].ToString();
                    if (str20 == "V")
                    {
                        string FieldNumber4 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][1].ToString();
                        string str2 = this.Request.Form[e.Item.Cells[3].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str3 = this.Request.Form[e.Item.Cells[5].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str4 = this.Request.Form[e.Item.Cells[6].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string prmNew1 = this.Request.Form[e.Item.Cells[8].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string prmNew2 = this.Request.Form[e.Item.Cells[9].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str5 = this.Request.Form[e.Item.Cells[10].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str6 = this.Request.Form[e.Item.Cells[11].Controls[1].ClientID.ToString().Replace("_", "$")];
                        if (this.EvalChange(prmOld18, str2, "VOdds"))
                            this.Sync("ML", FieldNumber4, "VOdds", SyncList4, true, str2, true, IdGame4, 3);
                        if (this.EvalChange(prmOld17, str3, "TOver"))
                            this.Sync("Total", FieldNumber4, "TOver", SyncList4, false, str3, true, IdGame4, 6);
                        if (this.EvalChange(prmOld20, str4, "OOdds"))
                            this.Sync("Total", FieldNumber4, "OOdds", SyncList4, true, str4, true, IdGame4, 7);
                        if (this.EvalChange(prmOld21, prmNew1, "VSp"))
                            this.Sync("Spread", FieldNumber4, "VSp", SyncList4, false, str5, true, IdGame4, 10);
                        if (this.EvalChange(prmOld22, prmNew2, "VSpOdds"))
                            this.Sync("Spread", FieldNumber4, "VSpOdds", SyncList4, true, str6, true, IdGame4, 11);
                        if (this.EvalChange(prmOld16, str5, "VSpread"))
                            this.Sync("Spread", FieldNumber4, "VSpread", SyncList4, false, str5, true, IdGame4, 14);
                        if (this.EvalChange(prmOld19, str6, "VSOdds"))
                            this.Sync("Spread", FieldNumber4, "VSOdds", SyncList4, true, str6, true, IdGame4, 15);
                    }
                    else
                    {
                        string FieldNumber4 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex - 1][1].ToString();
                        string str2 = this.Request.Form[e.Item.Cells[0].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str3 = this.Request.Form[e.Item.Cells[2].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str4 = this.Request.Form[e.Item.Cells[3].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string prmNew1 = this.Request.Form[e.Item.Cells[5].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string prmNew2 = this.Request.Form[e.Item.Cells[6].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str5 = this.Request.Form[e.Item.Cells[7].Controls[1].ClientID.ToString().Replace("_", "$")];
                        string str6 = this.Request.Form[e.Item.Cells[8].Controls[1].ClientID.ToString().Replace("_", "$")];
                        if (this.EvalChange(prmOld18, str2, "HOdds"))
                            this.Sync("ML", FieldNumber4, "HOdds", SyncList4, true, str2, false, IdGame4, 3);
                        if (this.EvalChange(prmOld17, str3, "TUnder"))
                            this.Sync("Total", FieldNumber4, "TUnder", SyncList4, false, str3, false, IdGame4, 6);
                        if (this.EvalChange(prmOld20, str4, "UOdds"))
                            this.Sync("Total", FieldNumber4, "UOdds", SyncList4, true, str4, false, IdGame4, 7);
                        if (this.EvalChange(prmOld21, prmNew1, "HSp"))
                            this.Sync("Spread", FieldNumber4, "HSp", SyncList4, false, str5, false, IdGame4, 10);
                        if (this.EvalChange(prmOld22, prmNew2, "HSpOdds"))
                            this.Sync("Spread", FieldNumber4, "HSpOdds", SyncList4, true, str6, false, IdGame4, 11);
                        if (this.EvalChange(prmOld16, str5, "HSpread"))
                            this.Sync("Spread", FieldNumber4, "HSpread", SyncList4, false, str5, false, IdGame4, 14);
                        if (this.EvalChange(prmOld19, str6, "HSOdds"))
                            this.Sync("Spread", FieldNumber4, "HSOdds", SyncList4, true, str6, false, IdGame4, 15);
                    }
                    this.sDGridN.EditItemIndex = -1;
                    break;
                case "PROP":
                    string FieldNumber5 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][1].ToString();
                    long IdGame5 = long.Parse(this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][6].ToString());
                    string prmOld23 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][4].ToString();
                    string SyncList5 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][7].ToString();
                    string str21 = this.Request.Form[e.Item.Cells[4].Controls[1].ClientID.ToString().Replace("_", "$")];
                    if (this.EvalChange(prmOld23, str21, "Odds"))
                        this.Sync("ML", FieldNumber5, "Odds", SyncList5, true, str21, true, IdGame5, 4);
                    this.sDGridP.EditItemIndex = -1;
                    break;
                case "TNT":
                    string FieldNumber6 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][1].ToString();
                    long IdGame6 = long.Parse(this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][7].ToString());
                    string prmOld24 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][3].ToString();
                    string SyncList6 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][8].ToString();
                    string str22 = this.Request.Form[e.Item.Cells[3].Controls[1].ClientID.ToString().Replace("_", "$")];
                    if (this.EvalChange(prmOld24, str22, "Odds"))
                        this.Sync("ML", FieldNumber6, "Odds", SyncList6, true, str22, true, IdGame6, 3);
                    this.sDGridT.EditItemIndex = -1;
                    break;
                case "ESOC":
                    string FieldNumber7 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][1].ToString();
                    long IdGame7 = long.Parse(this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][10].ToString());
                    string SyncList7 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][11].ToString();
                    string str23 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][3].ToString();
                    string str24 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][5].ToString();
                    string str25 = this.dsSchedule.Tables[0].Rows[e.Item.ItemIndex][7].ToString();
                    string str26 = this.Request.Form[e.Item.Cells[3].Controls[1].ClientID.ToString().Replace("_", "$")];
                    string str27 = this.Request.Form[e.Item.Cells[5].Controls[1].ClientID.ToString().Replace("_", "$")];
                    string str28 = this.Request.Form[e.Item.Cells[7].Controls[1].ClientID.ToString().Replace("_", "$")];
                    if (str26.IndexOf(".") != -1)
                        str26 = str26.Substring(0, str26.IndexOf("."));
                    if (str27.IndexOf(".") != -1)
                        str27 = str27.Substring(0, str27.IndexOf("."));
                    if (str28.IndexOf(".") != -1)
                        str28 = str28.Substring(0, str28.IndexOf("."));
                    if (this.EvalChange(str23.Substring(0, str23.IndexOf(".")), str26, "HOdds"))
                        this.Sync("ML", FieldNumber7, "HOdds", SyncList7, true, str26, true, IdGame7, 3);
                    if (this.EvalChange(str24.Substring(0, str24.IndexOf(".")), str27, "DRAWV"))
                        this.Sync("ML", FieldNumber7, "DRAW", SyncList7, true, str27, true, IdGame7, 6);
                    if (this.EvalChange(str25.Substring(0, str25.IndexOf(".")), str28, "VOdds"))
                        this.Sync("ML", FieldNumber7, "VOdds", SyncList7, true, str28, true, IdGame7, 9);
                    this.sDGridE.EditItemIndex = -1;
                    break;
            }
            this.LoadDataUpdate();
            this.BindGrid();
        }

        private bool EvalChange(string prmOld, string prmNew, string prmField)
        {
            bool flag = false;
            switch (prmField)
            {
                case "VOdds":
                    if (prmOld != this.ValidadOdds(prmNew).ToString())
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "HOdds":
                    if (prmOld != this.ValidadOdds(prmNew).ToString())
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "TOver":
                    if (prmOld != this.ValidadTotal(prmNew, prmField))
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "TUnder":
                    if (prmOld != this.ValidadTotal(prmNew, prmField))
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "OOdds":
                    if (prmOld != this.ValidadOdds(prmNew).ToString())
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "UOdds":
                    if (prmOld != this.ValidadOdds(prmNew).ToString())
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "VSpread":
                    if (prmOld != this.ValidadSpread(prmNew))
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "VSOdds":
                    if (prmOld != this.ValidadOdds(prmNew).ToString())
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "HSpread":
                    if (prmOld != this.ValidadSpread(prmNew))
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "HSOdds":
                    if (prmOld != this.ValidadOdds(prmNew).ToString())
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "VSp":
                    if (prmOld != this.ValidadSpread(prmNew))
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "VSpOdds":
                    if (prmOld != this.ValidadOdds(prmNew).ToString())
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "HSp":
                    if (prmOld != this.ValidadSpread(prmNew))
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "HSpOdds":
                    if (prmOld != this.ValidadOdds(prmNew).ToString())
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "DRAWV":
                    if (prmOld != this.ValidadDraw(prmNew))
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "DRAWH":
                    if (prmOld != this.ValidadDraw(prmNew))
                    {
                        flag = true;
                        break;
                    }
                    break;
                case "Odds":
                    if (prmOld != this.ValidadOdds(prmNew).ToString())
                    {
                        flag = true;
                        break;
                    }
                    break;
            }
            return flag;
        }

        private string ValidadOdds(string sVal)
        {
            string ErrorMsg;
            if (sVal.IndexOf(".") != -1)
            {
                ErrorMsg = "Invalidad Odds Value.";
            }
            else
            {
                if (!(sVal != ""))
                    return "";
                if (sVal != "EV")
                {
                    Decimal num = Decimal.Parse(sVal);
                    ErrorMsg = !(num > new Decimal(-101)) || !(num < new Decimal(100)) ? (num > (Decimal)long.Parse("999999") || num < (Decimal)(long.Parse("999999") * -1L) ? "Invalidad Odds Value." : sVal) : "Invalidad Odds Value.";
                }
                else
                    ErrorMsg = sVal;
            }
            if (ErrorMsg == sVal)
                return ErrorMsg;
            this.AlertErrorMsg(ErrorMsg);
            return "";
        }

        private string ValidadTotal(string sVal, string sField)
        {
            string str = "";
            if (sVal != "")
            {
                if (sField == "TOver" && sVal.IndexOf("o") == -1)
                    str = "o" + sVal.Replace(".5", "\x00BD");
                else if (sField == "TOver")
                    str = sVal.Replace(".5", "\x00BD");
                if (sField == "TUnder" && sVal.IndexOf("u") == -1)
                    str = "u" + sVal.Replace(".5", "\x00BD");
                else if (sField == "TUnder")
                    str = sVal.Replace(".5", "\x00BD");
            }
            return str;
        }

        private string ValidadSpread(string sVal)
        {
            return sVal.Replace(".5", "\x00BD");
        }

        private string ValidadDraw(string sVal)
        {
            return sVal.Replace(".5", "\x00BD");
        }

        private string ConvertAmericanToDecimalOdds(int Odds)
        {
            string empty = string.Empty;
            return Odds != 100 ? (Odds >= 0 ? string.Format("{0:0.00}", (object)((double)Odds / 100.0 + 1.0)) : string.Format("{0:0.00}", (object)(100.0 / (double)Math.Abs(Odds) + 1.0))) : "2";
        }

        private string ValidateNumber(string prmStr, string strType)
        {
            return prmStr == this.Null_Value || prmStr == "999999" || prmStr == "999999.0" ? "" : (!(prmStr == "100") ? (!(prmStr != this.Null_Value) || !(this.IdSport == "ESOC") ? strType + prmStr.Replace(".5", "\x00BD") : this.ConvertAmericanToDecimalOdds(int.Parse(prmStr))) : "EV");
        }

        private string Sync(
          string FieldType,
          string FieldNumber,
          string FieldName,
          string SyncList,
          bool TypeOdds,
          string NewLineValue,
          bool VRow,
          long IdGame,
          int Column)
        {
           AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
            string str = "";
            string prmVisitorValue = "";
            string prmHomeValue = "";
            string prmVisitorField = "";
            string prmHomeField = "";
            try
            {
                NewLineValue = NewLineValue.Replace("\x00BD", ".5");
                NewLineValue = NewLineValue.Replace("o", "");
                NewLineValue = NewLineValue.Replace("u", "");
                string[] strArray1 = SyncList.Split("_".ToCharArray());
                string[] strArray2 = FieldNumber.Replace("<br />", "_").Split("_".ToCharArray());
                string prmVistorNumber;
                string prmHomeNumber;
                if (this.IdSport != "SOC")
                {
                    if (this.IdSport != "TNT" && this.IdSport != "PROP" && this.IdSport != "ESOC")
                    {
                        prmVistorNumber = strArray2.GetValue(0).ToString();
                        prmHomeNumber = strArray2.GetValue(1).ToString();
                    }
                    else
                        prmVistorNumber = prmHomeNumber = FieldNumber;
                }
                else
                    prmVistorNumber = prmHomeNumber = strArray2.GetValue(0).ToString();
                if (FieldType == "Spread" || FieldType == "ML")
                {
                    if (VRow)
                    {
                        prmHomeField = FieldName.Replace("V", "H");
                        prmVisitorField = FieldName;
                    }
                    else
                    {
                        prmHomeField = FieldName;
                        prmVisitorField = FieldName.Replace("H", "V");
                    }
                }
                else if (FieldType == "Total" && !TypeOdds)
                {
                    if (VRow)
                    {
                        prmHomeField = FieldName.Replace("Over", "Under");
                        prmVisitorField = FieldName;
                    }
                    else
                    {
                        prmHomeField = FieldName;
                        prmVisitorField = FieldName.Replace("Under", "Over");
                    }
                }
                else if (FieldType == "Total" && TypeOdds)
                {
                    if (VRow)
                    {
                        prmHomeField = "UOdds";
                        prmVisitorField = FieldName;
                    }
                    else
                    {
                        prmHomeField = FieldName;
                        prmVisitorField = "OOdds";
                    }
                }
                if (FieldName == "DRAW")
                {
                    prmHomeField = "DRAWH";
                    prmVisitorField = "DRAWV";
                    if (this.IdSport == "SOC")
                        Column = 4;
                }
                if (TypeOdds)
                {
                    if (FieldName == "DRAW" && this.IdSport != "ESOC")
                    {
                        prmVisitorValue = NewLineValue;
                        prmHomeValue = NewLineValue;
                    }
                    else if (this.IdSport != "ESOC")
                    {
                        CResultOddsValue cresultOddsValue = new CResultOddsValue();
                        CResultOddsValue oddsValue = agentInstance.GetOddsValue(NewLineValue, FieldName, this.strSport, (long)this.IDLINETYPE, IdGame);
                        if (VRow)
                        {
                            prmVisitorValue = NewLineValue;
                            prmHomeValue = oddsValue.OddsValue;
                        }
                        else
                        {
                            prmHomeValue = NewLineValue;
                            prmVisitorValue = oddsValue.OddsValue;
                        }
                    }
                    else
                    {
                        // prmHomeValue = prmVisitorValue = string.Format("{0:0}", (object)(Decimal.op_Decrement(Decimal.Parse(NewLineValue)) * new Decimal(100)));
                        prmHomeValue = prmVisitorValue = string.Format("{0:0}", (Decimal.Parse(NewLineValue) - new Decimal(1)) * new Decimal(100));

                    }
                }
                else
                {
                    switch (FieldType)
                    {
                        case "Spread":
                            if (VRow)
                            {
                                prmVisitorValue = NewLineValue;
                                prmHomeValue = (Decimal.Parse(NewLineValue) * new Decimal(-1)).ToString();
                                break;
                            }
                            prmHomeValue = NewLineValue;
                            prmVisitorValue = (Decimal.Parse(NewLineValue) * new Decimal(-1)).ToString();
                            break;
                        case "Total":
                            prmVisitorValue = prmHomeValue = NewLineValue;
                            break;
                    }
                }
                switch (FieldType)
                {
                    case "Spread":
                        bool.Parse(strArray1.GetValue(0).ToString());
                        break;
                    case "Total":
                        bool.Parse(strArray1.GetValue(1).ToString());
                        break;
                    case "ML":
                        bool.Parse(strArray1.GetValue(2).ToString());
                        break;
                }
                str = prmVistorNumber + "_" + prmVisitorField + "_" + prmVisitorValue;
                str += "|";
                str = str + prmHomeNumber + "_" + prmHomeField + "_" + prmHomeValue;
                CResultAgentChangedLine agentChangedLine = new CResultAgentChangedLine();
                agentInstance.AgentChangedLineSync(this.IDAGENT, this.IDLINETYPE, this.IDSPORT, this.IDLEGAUE, IdGame, Column, prmVistorNumber, prmHomeNumber, prmVisitorField, prmHomeField, prmVisitorValue, prmHomeValue, VRow);
            }
            catch (Exception ex)
            {
                ex.ToString();
                this.Response.Redirect("../Report/ErrorHandle.aspx");
            }
            return str;
        }
    }

}