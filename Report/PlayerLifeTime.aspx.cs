using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;

namespace AgentSite4.Report
{
    public partial class PlayerLifeTime  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Init(object sender, EventArgs e)
        {
            DateTime from = fromOrTo(true);
            DateTime to = fromOrTo(false); ;

            txtDateFrom.Text = from.ToString("MM/dd/yyyy");
            txtDateTo.Text = to.ToString("MM/dd/yyyy");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CreateReport();
            }
        }

        protected DateTime fromOrTo(bool esFrom)
        {
            DayOfWeek todayDay = DateTime.Now.DayOfWeek;
            int minusdays = 0;
            int plusdays = 0;
            switch (todayDay)
            {
                case DayOfWeek.Monday:
                    minusdays = 0;
                    plusdays = 6;
                    break;
                case DayOfWeek.Tuesday:
                    minusdays = 1;
                    plusdays = 5;
                    break;
                case DayOfWeek.Wednesday:
                    minusdays = 2;
                    plusdays = 4;
                    break;
                case DayOfWeek.Thursday:
                    minusdays = 3;
                    plusdays = 3;
                    break;
                case DayOfWeek.Friday:
                    minusdays = 4;
                    plusdays = 2;
                    break;
                case DayOfWeek.Saturday:
                    minusdays = 5;
                    plusdays = 1;
                    break;
                case DayOfWeek.Sunday:
                    minusdays = 6;
                    plusdays = 0;
                    break;
            }
            if (esFrom)
            {
                return DateTime.Now.AddDays(-minusdays);
            }
            else
            {
                return DateTime.Now.AddDays(plusdays);
            }

        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            CreateReport();
        }

        protected void CreateReport()
        {
            DataTable agents = getAllAgents();
            foreach (DataRow agente in agents.Rows)
            {
                DataTable report = getReport(Convert.ToInt32(agente["idAgent"]));
                if (report.Rows.Count > 0)
                {
                    Literal header = new Literal();
                    Literal br = new Literal();
                    header.Text = "<div class='page-titles'><h4>" + agente["Agent"] + "</h4></div><div class=\"table-responsive\">";
                    br.Text = "</div><br />";
                    PnGrids.Controls.Add(header);
                    PnGrids.Controls.Add(createGridView(report));
                    PnGrids.Controls.Add(br);
                }
            }
        }

        protected GridView createGridView(DataTable table)
        {
            GridView grid = new GridView();
            grid.DataSource = table;

            grid.Width = new Unit(100, UnitType.Percentage);
            grid.AutoGenerateColumns = false;
            grid.EnableModelValidation = true;
            grid.CssClass = "table-dynamic table table-bordered table-striped";

            grid.AlternatingRowStyle.CssClass = "TrGameEven";
            grid.HeaderStyle.CssClass = "page-titles";
            grid.RowStyle.CssClass = "TrGameOdd";

            TemplateField Player = new TemplateField();
            Player.ItemTemplate = new AddTemplateToGridView(ListItemType.Item, "Player", "", ListItemType.Item, "OnlinePassword", "");
            Player.HeaderText = "Player";
            grid.Columns.Add(Player);

            TemplateField Sports = new TemplateField();
            Sports.ItemTemplate = new AddTemplateToGridView(ListItemType.Item, "SportsWin", "N0", ListItemType.Item, "SportsLose", "N0");
            Sports.HeaderText = "Sports";
            grid.Columns.Add(Sports);

            TemplateField Racing = new TemplateField();
            Racing.ItemTemplate = new AddTemplateToGridView(ListItemType.Item, "RacingWin", "N0", ListItemType.Item, "RacingLose", "N0");
            Racing.HeaderText = "Racing";
            grid.Columns.Add(Racing);

            TemplateField Casino = new TemplateField();
            Casino.ItemTemplate = new AddTemplateToGridView(ListItemType.Item, "CasinoWin", "N0", ListItemType.Item, "CasinoLose", "N0");
            Casino.HeaderText = "Casino";
            grid.Columns.Add(Casino);

            BoundField Adjustments = new BoundField();
            Adjustments.HeaderText = "Adjustments";
            Adjustments.DataField = "Adjustments";
            //Adjustments.DataFormatString = "{0:N0}";
            grid.Columns.Add(Adjustments);

            BoundField NetWorth = new BoundField();
            NetWorth.HeaderText = "NetWorth";
            NetWorth.DataField = "NetWorth";
            // NetWorth.DataFormatString = "{0:N0}";
            grid.Columns.Add(NetWorth);


            TemplateField AccountOpened = new TemplateField();
            AccountOpened.ItemTemplate = new AddTemplateToGridView(ListItemType.Item, "AccountOpened", "yyyy-MM-dd", ListItemType.Item, "LastWager", "yyyy-MM-dd <br/> HH:mm:ss");
            AccountOpened.HeaderText = "Account Opened / Last Wager";
            grid.Columns.Add(AccountOpened);




            grid.Columns[0].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[1].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[2].ItemStyle.Width = new Unit(70, UnitType.Pixel);
            grid.Columns[3].ItemStyle.Width = new Unit(60, UnitType.Pixel);
            grid.Columns[4].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[5].ItemStyle.Width = new Unit(70, UnitType.Pixel);
            grid.Columns[6].ItemStyle.Width = new Unit(150, UnitType.Pixel);

            grid.DataBind();
            return grid;
        }

        public class AddTemplateToGridView : ITemplate
        {
            ListItemType _type1;
            string _colName1;
            string _dataFormat1;
            ListItemType _type2;
            string _colName2;
            string _dataFormat2;

            public AddTemplateToGridView(ListItemType type1, string colname1, string dataFormat1, ListItemType type2, string colname2, string dataFormat2)
            {
                _type1 = type1;
                _colName1 = colname1;
                _dataFormat1 = dataFormat1;
                _type2 = type2;
                _colName2 = colname2;
                _dataFormat2 = dataFormat2;
            }
            void ITemplate.InstantiateIn(System.Web.UI.Control container)
            {
                switch (_type1)
                {
                    case ListItemType.Item:
                        Label ht = new Label();
                        ht.DataBinding += new EventHandler(ht_DataBinding);
                        container.Controls.Add(ht);
                        break;
                }
                switch (_type2)
                {
                    case ListItemType.Item:
                        Label ht = new Label();
                        ht.DataBinding += new EventHandler(ht_DataBinding2);
                        Literal lt = new Literal();
                        lt.Text = "<br/>";
                        container.Controls.Add(lt);
                        container.Controls.Add(ht);
                        break;
                }
            }

            void ht_DataBinding(object sender, EventArgs e)
            {
                Label lnk = (Label)sender;
                GridViewRow container = (GridViewRow)lnk.NamingContainer;
                object dataValue = DataBinder.Eval(container.DataItem, _colName1);
                if (dataValue != DBNull.Value)
                {
                    switch (dataValue.GetType().ToString())
                    {
                        case "System.Decimal":
                            lnk.Text = ((Decimal)dataValue).ToString(_dataFormat1);
                            break;
                        case "System.DateTime":
                            lnk.Text = ((DateTime)dataValue).ToString(_dataFormat1);
                            break;
                        default:
                            lnk.Text = dataValue.ToString();
                            break;
                    }

                }
            }
            void ht_DataBinding2(object sender, EventArgs e)
            {
                Label lnk = (Label)sender;
                GridViewRow container = (GridViewRow)lnk.NamingContainer;
                object dataValue = DataBinder.Eval(container.DataItem, _colName2);
                if (dataValue != DBNull.Value)
                {
                    switch (dataValue.GetType().ToString())
                    {
                        case "System.Decimal":
                            lnk.Text = ((Decimal)dataValue).ToString(_dataFormat2);
                            break;
                        case "System.DateTime":
                            lnk.Text = ((DateTime)dataValue).ToString(_dataFormat2);
                            break;
                        default:
                            lnk.Text = dataValue.ToString();
                            break;
                    }
                }
            }
        }

        protected DataTable getReport(int prmIdAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("PlayerLifeTime", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmDateFrom", SqlDbType.DateTime)).Value = txtDateFrom.Text;
                ((SqlParameter)comm.Parameters.Add("@prmDateTo", SqlDbType.DateTime)).Value = txtDateTo.Text;
                ((SqlParameter)comm.Parameters.Add("@prmLifeTime", SqlDbType.Bit)).Value = !chkBeaters.Checked;


                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);

            }
            catch { }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
        }


        protected DataTable getAllAgents()
        {
            int prmIdAgent = Convert.ToInt32(Session["SubIdAgent"]);
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("AddOn_BuildAgentTree", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch { }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
        }

        protected void ddlPlayer_DataBound(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CreateReport();
            }
        }
    }
}
