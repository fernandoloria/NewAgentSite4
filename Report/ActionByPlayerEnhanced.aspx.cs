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
    public partial class ActionByPlayerEnhanced  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Init(object sender, EventArgs e)
        {
            DateTime from = fromOrTo(true);
            DateTime to = fromOrTo(false); ;

            txtDateFrom.Text = from.ToString("MM/dd/yyy");
            txtDateTo.Text = to.ToString("MM/dd/yyy");

            CreateReport();

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
                DataTable report = getReport(Convert.ToInt32(agente["IDAgent"]));
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
            grid.HeaderStyle.CssClass = "trAgent";
            grid.RowStyle.CssClass = "TrGameOdd";

            BoundField Player = new BoundField();
            Player.HeaderText = "Player";
            Player.DataField = "Player";
            Player.DataFormatString = "{0:MMMM, yyyy}";
            grid.Columns.Add(Player);

            BoundField TotalWin = new BoundField();
            TotalWin.HeaderText = "Total Win";
            TotalWin.DataField = "TotalWin";
            TotalWin.DataFormatString = "{0:N2}";
            grid.Columns.Add(TotalWin);

            BoundField TotalLose = new BoundField();
            TotalLose.HeaderText = "Total Lose";
            TotalLose.DataField = "TotalLose";
            TotalLose.DataFormatString = "{0:N2}";
            grid.Columns.Add(TotalLose);

            BoundField IP = new BoundField();
            IP.HeaderText = "IP's";
            IP.DataField = "IP";
            grid.Columns.Add(IP);


            grid.Columns[0].HeaderText = "Player";
            grid.Columns[1].HeaderText = "Total Win";
            grid.Columns[2].HeaderText = "Total Lose";
            grid.Columns[3].HeaderText = "IP's";


            grid.Columns[0].ItemStyle.Width = new Unit(150, UnitType.Pixel);
            grid.Columns[1].ItemStyle.Width = new Unit(25, UnitType.Percentage);
            grid.Columns[2].ItemStyle.Width = new Unit(25, UnitType.Percentage);
            grid.Columns[3].ItemStyle.Width = new Unit(60, UnitType.Percentage);

            grid.DataBind();
            return grid;
        }

        protected DataTable getReport(int prmIdAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("AddOn_AccionByPlayer", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIDAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmDateFrom", SqlDbType.DateTime)).Value = txtDateFrom.Text;
                ((SqlParameter)comm.Parameters.Add("@prmDateTo", SqlDbType.DateTime)).Value = txtDateTo.Text;
                ((SqlParameter)comm.Parameters.Add("@prmIP", SqlDbType.VarChar)).Value = txtIP.Text;
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
                SqlCommand comm = new SqlCommand("AddOn_GetAllSubAgents", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@idAgent", SqlDbType.Int)).Value = prmIdAgent;
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
    }
}
