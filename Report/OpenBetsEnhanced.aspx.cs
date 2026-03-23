using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;
using DGSinterface;
using static AgentSite4.Report.OpenBetsEnhanced;
using System.Data.SqlTypes;
using System.Globalization;

namespace AgentSite4.Report
{
    public partial class OpenBetsEnhanced : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected decimal amountAtRisk;
        protected decimal amountToWin;
        private int rowCounter = 0;
        static int sortDirection = 1;
        int currentPage;
        int maxPageNumbersToShow = 10;
        bool DELETEBETSBEFOREGAME = false;
        bool DELETEBETSANYTIME = false;
        protected bool HasDeleteRight { get; private set; }

        protected void Page_Init(object sender, EventArgs e)
        {
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            //foreach (string key in Session.Keys)
            //{
            //    Response.Write($"{key}: {Session[key]}<br />");
            //}
            if (!IsPostBack)
            {
                DELETEBETSANYTIME = Security.AgentRights.Has("DELETEBETS");                    
                DELETEBETSBEFOREGAME = Security.AgentRights.Has("DELETEBETSBEFORESTARTTIME");

                HasDeleteRight = DELETEBETSANYTIME || DELETEBETSBEFOREGAME;

                loadddlSportType();
                loadddlWagerType();
                txtDateFrom.Text = DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy");
                txtDateTo.Text = DateTime.Now.ToString("MM/dd/yyyy");
                currentPage = 1; 
                ViewState["CurrentPage"] = currentPage;

            }
            else
            {
                currentPage = ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 1;
            }
            LoadlvOpenBets(IsPostBack);

        }


        private void LoadlvOpenBets(bool isPostBack)
        {
            List<OpenBets> openBetsList;
            if (ViewState["OpenBetsList"] == null)
            {
                openBetsList = LoadOpenBets();
                ViewState["OpenBetsList"] = openBetsList;
            }
            else
            {
                openBetsList = (List<OpenBets>)ViewState["OpenBetsList"];
            }

            amountAtRisk = 0;
            amountToWin = 0;

            foreach (OpenBets ticket in openBetsList)
            {
                amountAtRisk += ticket.RiskAmount;
                amountToWin += ticket.WinAmount;
            }

            string eventTarget = Request["__EVENTTARGET"];
            string eventArgument = Request["__EVENTARGUMENT"];

            if (ViewState["LastSort"] == null || ViewState["LastSort"].ToString() != eventTarget)
            {
                SortDirection = 1;
            }
            else
            {
                SortDirection *= -1;
            }
            sortDirection = SortDirection;

            ViewState["LastSort"] = eventTarget;

            if (eventTarget == "Sort")
            {
                switch (eventArgument)
                {
                    case "Agent":
                        openBetsList.Sort(CompareByAgent);
                        break;
                    case "Player":
                        openBetsList.Sort(CompareByPlayer);
                        break;
                    case "PlacedDate":
                        openBetsList.Sort(CompareByPlacedDate);
                        break;
                    case "Risk":
                        openBetsList.Sort(CompareByRisk);
                        break;
                    case "Win":
                        openBetsList.Sort(CompareByWin);
                        break;
                    case "WagerType":
                        openBetsList.Sort(CompareByWagerType);
                        break;
                }
            }

            int itemsPerPage = Convert.ToInt32(txtBetsPerPage.Text);
            int totalItems = openBetsList.Count;
            int totalPages = totalItems / itemsPerPage;
            if (totalItems % itemsPerPage != 0)
            {
                totalPages++;
            }

            int startItemIndex = (currentPage - 1) * itemsPerPage;
            int endItemIndex = startItemIndex + itemsPerPage;
            if (endItemIndex > totalItems)
            {
                endItemIndex = totalItems;
            }

            List<OpenBets> currentPageList = openBetsList.GetRange(startItemIndex, endItemIndex - startItemIndex);


            lvOpenBets.DataSource = currentPageList;
            lvOpenBets.DataBind();
            if (!isPostBack)
            {
                PlaceHolder phDeleteColumn = (PlaceHolder)lvOpenBets.FindControl("phDeleteColumn");
                PlaceHolder phWin = (PlaceHolder)lvOpenBets.FindControl("phWin");
                PlaceHolder phRisk = (PlaceHolder)lvOpenBets.FindControl("phRisk");

                if (phDeleteColumn != null)
                {
                    phDeleteColumn.Visible = DELETEBETSANYTIME || DELETEBETSBEFOREGAME;
                }
                Label lblRisk = new Label();
                lblRisk.Text = "<th><a href=\"javascript:sort('Risk')\">Risk</a> <br /> " + amountAtRisk.ToString("N0") + "</th>";
                if (phRisk != null)
                {
                    phRisk.Controls.Add(lblRisk);
                }

                Label lblWin = new Label();
                lblWin.Text = "<th><a href=\"javascript:sort('Win')\">Win</a> <br /> " + amountToWin.ToString("N0") + "</th>";
                if (phWin != null)
                {
                    phWin.Controls.Add(lblWin);
                }

            }

            BindPager();
        }


        #region DropDownlist
        protected void loadddlWagerType()
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            try
            {
                Cnn.Open();
                int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                SqlCommand comm1 = new SqlCommand("Web_GetOpenWagerTypes", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm1.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;

                SqlDataReader reader;
                reader = comm1.ExecuteReader();
                ListItem newItem = new ListItem();
                newItem = new ListItem();
                newItem.Value = "-1";
                newItem.Text = "ALL WAGERS";
                ddlWagerType.Items.Add(newItem);
                while (reader.Read())
                {
                    newItem = new ListItem();
                    newItem.Value = reader["WagerType"].ToString();
                    newItem.Text = reader["Description"].ToString();
                    ddlWagerType.Items.Add(newItem);
                }
            }
            catch (Exception myError) { Response.Write(myError.Message); }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }
        protected void loadddlSportType()
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            try
            {
                Cnn.Open();
                int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                SqlCommand comm1 = new SqlCommand("Web_GetOpenBetsIdSports", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm1.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                SqlDataReader reader;
                reader = comm1.ExecuteReader();
                ListItem newItem = new ListItem();
                newItem = new ListItem();
                newItem.Value = "All";
                newItem.Text = "ALL SPORTS";
                ddlSportType.Items.Add(newItem);
                while (reader.Read())
                {
                    newItem = new ListItem();
                    newItem.Value = reader["idSport"].ToString();
                    newItem.Text = reader["idSport"].ToString();
                    ddlSportType.Items.Add(newItem);
                }
            }
            catch (Exception myError) { Response.Write(myError.Message); }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }
        #endregion
        protected void btnSumit_Click(object sender, EventArgs e)
        {
            ViewState["OpenBetsList"] = null;
            LoadlvOpenBets(false);
        }

        protected string GetDescription(object idSport, object wagerType, object description, object completeDescription)
        {
            if (idSport != null && (idSport.ToString() == "RAC" || idSport.ToString() == "RBL"))
            {
                return completeDescription.ToString() + " <br />" + description.ToString();
            }
            else if (idSport.ToString() == "TNT")
            {
                return completeDescription.ToString();
            }
            else if (wagerType.ToString() == "0")
            {
                return completeDescription.ToString() + " <br />" + description.ToString();
            }
            else {
                return completeDescription.ToString();
            }
        }

        protected string FormatDescription(object gameDescription, object completeDescription)
        {
            StringBuilder result = new StringBuilder();

            if (gameDescription != null && !string.IsNullOrEmpty(gameDescription.ToString()))
            {
                result.Append(@"<span class='hidden-sm-down'>" + gameDescription.ToString() + @"</span><br/>");
            }

            if (completeDescription != null)
            {
                result.Append(completeDescription.ToString());
            }

            return result.ToString();
        }

        protected string GetRowClass()
        {
            rowCounter++;
            if (rowCounter % 2 == 0)
                return "evenRow clickableRow";
            else
                return "oddRow clickableRow";
        }

        protected string GetWagerResult(int prmResult)
        {
            string str1 = "";
            string str2;
            switch (prmResult)
            {
                case 0:
                    str2 = str1 + "LOSE";
                    break;
                case 1:
                    str2 = str1 + "WIN";
                    break;
                case 2:
                    str2 = str1 + "PUSH";
                    break;
                case 3:
                    str2 = str1 + "NO BET";
                    break;
                case 4:
                    str2 = str1 + "N/A";
                    break;
                case 5:
                    str2 = str1 + "N/A PITCHER";
                    break;
                case 6:
                    str2 = str1 + "N/A CANCEL";
                    break;
                case 7:
                    str2 = str1 + "N/A SHORT";
                    break;
                case 8:
                    str2 = str1 + "N/A VOID";
                    break;
                case 9:
                    str2 = str1 + "WIN BY &frac14;";
                    break;
                case 10:
                    str2 = str1 + "LOSE BY &frac14;";
                    break;
                case 11:
                    str2 = str1 + "WIN BY &frac34;";
                    break;
                case 12:
                    str2 = str1 + "LOSE BY &frac34;";
                    break;
                case (int)byte.MaxValue:
                    str2 = str1 + "PEND";
                    break;
                default:
                    str2 = "";
                    break;
            }
            return str2;
        }

        private static int CompareByAgent(OpenBets x, OpenBets y)
        {
            return string.Compare(x.Agent, y.Agent) * sortDirection;
        }

        private static int CompareByPlayer(OpenBets x, OpenBets y)
        {
            return string.Compare(x.IdPlayer, y.IdPlayer) * sortDirection;
        }

        private static int CompareByRisk(OpenBets x, OpenBets y)
        {
            if (x.RiskAmount > y.RiskAmount) return 1 * sortDirection;
            if (x.RiskAmount < y.RiskAmount) return -1 * sortDirection;
            return 0;
        }

        private static int CompareByWin(OpenBets x, OpenBets y)
        {
            if (x.WinAmount > y.WinAmount) return 1 * sortDirection;
            if (x.WinAmount < y.WinAmount) return -1 * sortDirection;
            return 0;
        }

        private static int CompareByPlacedDate(OpenBets x, OpenBets y)
        {
            if (x.IdWager > y.IdWager) return 1 * sortDirection;
            if (x.IdWager < y.IdWager) return -1 * sortDirection;
            return 0;
        }

        private static int CompareByWagerType(OpenBets x, OpenBets y)
        {
            if (x.WagerType > y.WagerType) return 1 * sortDirection;
            if (x.WagerType < y.WagerType) return -1 * sortDirection;
            return 0;
        }

        private int SortDirection
        {
            get
            {
                if (ViewState["SortDirection"] == null)
                {
                    ViewState["SortDirection"] = 1; // Default to ascending
                }
                return (int)ViewState["SortDirection"];
            }
            set
            {
                ViewState["SortDirection"] = value;
            }
        }


        private void BindPager()
        {
            List<OpenBets> openBetsList = (List<OpenBets>)ViewState["OpenBetsList"];
            int itemsPerPage = Convert.ToInt32(txtBetsPerPage.Text);
            int totalItems = openBetsList.Count;
            int totalPages = totalItems / itemsPerPage;

            if (totalItems % itemsPerPage != 0)
            {
                totalPages++;
            }

            List<ListItem> pages = new List<ListItem>();

            int startPage = Math.Max(currentPage - maxPageNumbersToShow / 2, 1);
            int endPage = Math.Min(startPage + maxPageNumbersToShow - 1, totalPages);

            if (startPage > 1)
            {
                pages.Add(new ListItem("...", (startPage - 1).ToString()));
            }

            for (int i = startPage; i <= endPage; i++)
            {
                pages.Add(new ListItem(i.ToString(), i.ToString(), i != currentPage));
            }

            if (endPage < totalPages)
            {
                pages.Add(new ListItem("...", (endPage + 1).ToString()));
            }

            rptPager.DataSource = pages;
            rptPager.DataBind();
        }

        protected void Page_Changed(object sender, EventArgs e)
        {
            string commandArg = (sender as LinkButton).CommandArgument;

            if (commandArg == "...")
            {
                bool isFirstEllipsis = true;
                foreach (RepeaterItem item in rptPager.Items)
                {
                    LinkButton lnkPage = item.FindControl("lnkPage") as LinkButton;
                    if (lnkPage != null && lnkPage.CommandArgument == "...")
                    {
                        isFirstEllipsis = false;
                        break;
                    }
                    if (lnkPage != null && lnkPage.CommandArgument == currentPage.ToString())
                    {
                        break;
                    }
                }

                if (isFirstEllipsis)
                {
                    currentPage -= 5;
                }
                else
                {
                    currentPage += 5;
                }
            }
            else
            {
                int newPage;
                if (int.TryParse(commandArg, out newPage))
                {
                    currentPage = newPage;
                }
            }

            ViewState["CurrentPage"] = currentPage;
            LoadlvOpenBets(false);
            BindPager();
        }


        protected void rptPager_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lnkPage = e.Item.FindControl("lnkPage") as LinkButton;
                bool isEnabled = Convert.ToBoolean(DataBinder.Eval(e.Item.DataItem, "Enabled"));

                if (lnkPage != null)
                {
                    if (isEnabled)
                    {
                        lnkPage.CssClass = "page-link btn btn-primary";
                    }
                    else
                    {
                        lnkPage.CssClass = "page-link btn btn-secondary";
                    }
                }
            }
        }


        #region SQL

        private string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

        public List<OpenBets> LoadOpenBets()
        {
            List<OpenBets> openBetsList = new List<OpenBets>();
            int idAgent = Convert.ToInt32(this.Session["SubIdAgent"].ToString());
            int idPlayer = -1;
            int wagerType = Convert.ToInt32(ddlWagerType.SelectedValue);
            string idSport = ddlSportType.SelectedValue;
            int placedDate = Convert.ToInt32(ddlDate.SelectedValue);
            string player = txtPlayer.Text;
            DateTime dateFrom = Convert.ToDateTime("01/01/1999");
            DateTime dateTo = Convert.ToDateTime("01/01/2078");
            bool prmOrderByRisk = ddlSortBy.SelectedValue == "1" ? true : false;
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("AddOn_AgentPlayerOpenBetsByRiskWin", connection))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        ((SqlParameter)cmd.Parameters.Add("@IdAgent", SqlDbType.Int)).Value = idAgent;
                        ((SqlParameter)cmd.Parameters.Add("@IdPlayer", SqlDbType.Int)).Value = idPlayer;
                        ((SqlParameter)cmd.Parameters.Add("@WagerType", SqlDbType.Int)).Value = wagerType;
                        ((SqlParameter)cmd.Parameters.Add("@IdSport", SqlDbType.VarChar)).Value = idSport;
                        ((SqlParameter)cmd.Parameters.Add("@Page", SqlDbType.Int)).Value = 1;
                        ((SqlParameter)cmd.Parameters.Add("@RecsPerPage", SqlDbType.Int)).Value = 999999999;
                        ((SqlParameter)cmd.Parameters.Add("@dateFrom", SqlDbType.SmallDateTime)).Value = dateFrom; //txtDateFrom.Text;
                        ((SqlParameter)cmd.Parameters.Add("@dateTo", SqlDbType.SmallDateTime)).Value = dateTo; //txtDateTo.Text;
                        ((SqlParameter)cmd.Parameters.Add("@Player", SqlDbType.VarChar)).Value = player;
                        ((SqlParameter)cmd.Parameters.Add("@PlacedDate", SqlDbType.Int)).Value = placedDate;
                        ((SqlParameter)cmd.Parameters.Add("@prmOrderByRisk", SqlDbType.Bit)).Value = prmOrderByRisk;
                        connection.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                OpenBets openBet = new OpenBets();

                                openBet.IdPlayer = reader["IdPlayer"].ToString();
                                openBet.Agent = reader["Agent"].ToString();
                                openBet.TicketNumber = Convert.ToInt32(reader["TicketNumber"]);
                                openBet.IdWager = Convert.ToInt32(reader["IdWager"]);
                                openBet.PlacedDate = reader["PlacedDate"].ToString();
                                openBet.IdSport = reader["IdSport"].ToString();
                                openBet.Name = reader["Name"].ToString();
                                openBet.GameDateTime = reader["GameDateTime"].ToString();
                                openBet.WagerType = Convert.ToInt32(reader["wagerType"]);
                                openBet.Description = reader["Description"].ToString();
                                openBet.RiskWin = reader["riskWin"].ToString();
                                openBet.IP = reader["IP"].ToString();
                                openBet.Password = reader["Password"].ToString();
                                openBet.CompleteDescription = reader["CompleteDescription"].ToString();
                                openBet.RiskAmount = Convert.ToDecimal(reader["RiskAmount"]);
                                openBet.WinAmount = Convert.ToDecimal(reader["WinAmount"]);

                                openBet.Details = LoadDetail(Convert.ToInt32(reader["IdWager"]), reader["IdSport"].ToString(), reader["Agent"].ToString());
                                openBet.ComputeCanDelete(DELETEBETSANYTIME, DELETEBETSBEFOREGAME, DateTime.Now);

                                openBetsList.Add(openBet);
                            }
                        }
                    }
                }
            }
            catch (Exception e)
            {
            }
            return openBetsList;
        }

        public Detail[] LoadDetail(int idWager, string idSport, string agent)
        {
            List<Detail> detailsList = new List<Detail>();
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("AddOn_WebGetWagerDetailByRiskWin", connection))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        ((SqlParameter)cmd.Parameters.Add("@IdWager", SqlDbType.Int)).Value = idWager;
                        ((SqlParameter)cmd.Parameters.Add("@IdSport", SqlDbType.VarChar)).Value = idSport;
                        ((SqlParameter)cmd.Parameters.Add("@Agent", SqlDbType.VarChar)).Value = agent;

                        connection.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Detail detail = new Detail();
                                detail.IdWager = Convert.ToInt32(reader["IdWager"]);
                                detail.IdWagerDetail = Convert.ToInt32(reader["IdWagerDetail"]);
                                detail.GameSport = reader["GameSport"].ToString();
                                detail.CompleteDescription = reader["CompleteDescription"].ToString();
                                detail.GameTime = Convert.ToDateTime(reader["GameTime"]);
                                detail.GameDate = Convert.ToDateTime(reader["GameDate"]);
                                detail.Result = Convert.ToByte(reader["Result"]);
                                detail.ShortGame = Convert.ToBoolean(reader["ShortGame"]);
                                detail.PitcherChange = Convert.ToBoolean(reader["PitcherChange"]);
                                if (reader["IdGame"] != DBNull.Value)
                                {
                                    detail.IdGame = Convert.ToInt32(reader["IdGame"]);
                                }
                                if (reader["Rotation"] != DBNull.Value)
                                {
                                    detail.Rotation = Convert.ToInt32(reader["Rotation"]);
                                }
                                detail.Odds = Convert.ToInt32(reader["Odds"]);
                                detail.Points = Convert.ToSingle(reader["Points"]);
                                detail.PointsPurchased = Convert.ToSingle(reader["PointsPurchased"]);
                                detail.EventDetail = reader["Event"].ToString();
                                detail.GameDescription = reader["GameDescription"].ToString();
                                detail.GameLangDescription = reader["GameLangDescription"].ToString();
                                detailsList.Add(detail);
                            }
                        }
                    }
                }
            }
            catch (Exception e)
            { }
            return detailsList.ToArray();
        }

        #endregion

        #region ObjectDeclaration
        [Serializable]
        public class OpenBets
        {
            private string idPlayer;
            private string agent;
            private int ticketNumber;
            private int idWager;
            private string placedDate;
            private string idSport;
            private string name;
            private string gameDateTime;
            private int wagerType;
            private string description;
            private string riskWin;
            private string iP;
            private string password;
            private string completeDescription;
            private decimal riskAmount;
            private decimal winAmount;
            private Detail[] details;

            public bool CanDelete { get; private set; }

            public void ComputeCanDelete(bool canDeleteAnytime, bool canDeleteBeforeStart, DateTime now)
            {
                if (canDeleteAnytime)
                {
                    CanDelete = true;
                    return;
                }

                if (!canDeleteBeforeStart)
                {
                    CanDelete = false;
                    return;
                }

                var times = new List<DateTime>();
                if (Details != null)
                {
                    foreach (var d in Details)
                    {
                        if (d.GameDate.HasValue) times.Add(d.GameDate.Value);
                        else if (d.GameTime.HasValue) times.Add(d.GameTime.Value);
                    }
                }

                if (times.Count == 0 && DateTime.TryParse(GameDateTime, out var singleDt))
                    times.Add(singleDt);

                CanDelete = times.Count > 0 && times.TrueForAll(t => t > now);
            }

            public string IdPlayer
            {
                get { return idPlayer; }
                set { idPlayer = value; }
            }

            public string Agent
            {
                get { return agent; }
                set { agent = value; }
            }

            public int TicketNumber
            {
                get { return ticketNumber; }
                set { ticketNumber = value; }
            }

            public int IdWager
            {
                get { return idWager; }
                set { idWager = value; }
            }

            public string PlacedDate
            {
                get { return placedDate; }
                set { placedDate = value; }
            }

            public string IdSport
            {
                get { return idSport; }
                set { idSport = value; }
            }

            public string Name
            {
                get { return name; }
                set { name = value; }
            }

            public string GameDateTime
            {
                get { return gameDateTime; }
                set { gameDateTime = value; }
            }

            public int WagerType
            {
                get { return wagerType; }
                set { wagerType = value; }
            }

            public string Description
            {
                get { return description; }
                set { description = value; }
            }

            public string RiskWin
            {
                get { return riskWin; }
                set { riskWin = value; }
            }

            public string IP
            {
                get { return iP; }
                set { iP = value; }
            }

            public string Password
            {
                get { return password; }
                set { password = value; }
            }

            public string CompleteDescription
            {
                get { return completeDescription; }
                set { completeDescription = value; }
            }

            public decimal RiskAmount
            {
                get { return riskAmount; }
                set { riskAmount = value; }
            }

            public decimal WinAmount
            {
                get { return winAmount; }
                set { winAmount = value; }
            }

            public Detail[] Details
            {
                get { return details; }
                set { details = value; }
            }
        }

        [Serializable]
        public class Detail
        {
            private int idWager;
            private int idWagerDetail;
            private string gameSport;
            private string completeDescription;
            private DateTime? gameTime;
            private DateTime? gameDate;
            private byte result;
            private bool shortGame;
            private bool pitcherChange;
            private int? idGame;
            private int? rotation;
            private int odds;
            private float points;
            private float pointsPurchased;
            private string eventDetail;
            private string gameDescription;
            private string gameLangDescription;

            public int IdWager
            {
                get { return idWager; }
                set { idWager = value; }
            }

            public int IdWagerDetail
            {
                get { return idWagerDetail; }
                set { idWagerDetail = value; }
            }

            public string GameSport
            {
                get { return gameSport; }
                set { gameSport = value; }
            }

            public string CompleteDescription
            {
                get { return completeDescription; }
                set { completeDescription = value; }
            }

            public DateTime? GameTime
            {
                get { return gameTime; }
                set { gameTime = value; }
            }

            public DateTime? GameDate
            {
                get { return gameDate; }
                set { gameDate = value; }
            }

            public byte Result
            {
                get { return result; }
                set { result = value; }
            }

            public bool ShortGame
            {
                get { return shortGame; }
                set { shortGame = value; }
            }

            public bool PitcherChange
            {
                get { return pitcherChange; }
                set { pitcherChange = value; }
            }

            public int? IdGame
            {
                get { return idGame; }
                set { idGame = value; }
            }

            public int? Rotation
            {
                get { return rotation; }
                set { rotation = value; }
            }

            public int Odds
            {
                get { return odds; }
                set { odds = value; }
            }

            public float Points
            {
                get { return points; }
                set { points = value; }
            }

            public float PointsPurchased
            {
                get { return pointsPurchased; }
                set { pointsPurchased = value; }
            }

            public string EventDetail
            {
                get { return eventDetail; }
                set { eventDetail = value; }
            }

            public string GameDescription
            {
                get { return gameDescription; }
                set { gameDescription = value; }
            }

            public string GameLangDescription
            {
                get { return gameLangDescription; }
                set { gameLangDescription = value; }
            }
        }

        #endregion
    }
}
