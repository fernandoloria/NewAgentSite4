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
    public partial class DetailedSalesReport  : BasePage, IRequiresSessionState
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
                    header.Text = "<div class='portlet-title'><h4>" + agente["Agent"] + "</h4></div>";
                    br.Text = "<br />";
                    PnGrids.Controls.Add(header);
                    PnGrids.Controls.Add(createGridView(report));
                    PnGrids.Controls.Add(br);
                }
            }
            int prmIdAgent = Convert.ToInt32(Session["SubIdAgent"]);
            DataTable totalReport = getTotalReport(prmIdAgent);
            Literal header2 = new Literal();
            Literal br2 = new Literal();
            header2.Text = "<div class='portlet-title'><h4> TOTAL " + Session["Agent"] + "</h4></div>";
            br2.Text = "<br />";
            PnGrids.Controls.Add(header2);
            PnGrids.Controls.Add(createGridView(totalReport));
            PnGrids.Controls.Add(br2);




        }

        protected GridView createGridView(DataTable table)
        {
            GridView grid = new GridView();
            grid.DataSource = table;

            grid.Width = new Unit(100, UnitType.Percentage);
            grid.AutoGenerateColumns = false;
            grid.EnableModelValidation = true;
            grid.CssClass = "table-bordered";

            grid.AlternatingRowStyle.CssClass = "TrGameEven";
            grid.HeaderStyle.CssClass = "page-titles";
            grid.RowStyle.CssClass = "TrGameOdd";

            BoundField Player = new BoundField();
            Player.HeaderText = "player";
            Player.DataField = "player";
            grid.Columns.Add(Player);

            BoundField StraightsRiskAmount = new BoundField();
            StraightsRiskAmount.HeaderText = "STR Risk";
            StraightsRiskAmount.DataField = "StraightsRiskAmount";
            StraightsRiskAmount.DataFormatString = "{0:N0}";
            grid.Columns.Add(StraightsRiskAmount);

            BoundField ParlaysRiskAmount = new BoundField();
            ParlaysRiskAmount.HeaderText = "Parlays Risk";
            ParlaysRiskAmount.DataField = "ParlaysRiskAmount";
            ParlaysRiskAmount.DataFormatString = "{0:N0}";
            grid.Columns.Add(ParlaysRiskAmount);

            BoundField OtherRiskAmount = new BoundField();
            OtherRiskAmount.HeaderText = "Other Risk";
            OtherRiskAmount.DataField = "OtherRiskAmount";
            OtherRiskAmount.DataFormatString = "{0:N0}";
            grid.Columns.Add(OtherRiskAmount);

            BoundField totalRisk = new BoundField();
            totalRisk.HeaderText = "Total";
            totalRisk.DataField = "totalRisk";
            totalRisk.DataFormatString = "{0:N0}";
            grid.Columns.Add(totalRisk);

            BoundField StraightsPayoutAmount = new BoundField();
            StraightsPayoutAmount.HeaderText = "STR Payout";
            StraightsPayoutAmount.DataField = "StraightsPayoutAmount";
            StraightsPayoutAmount.DataFormatString = "{0:N0}";
            grid.Columns.Add(StraightsPayoutAmount);

            BoundField ParlaysPayoutAmount = new BoundField();
            ParlaysPayoutAmount.HeaderText = "Parlays Payout";
            ParlaysPayoutAmount.DataField = "ParlaysPayoutAmount";
            ParlaysPayoutAmount.DataFormatString = "{0:N0}";
            grid.Columns.Add(ParlaysPayoutAmount);

            BoundField OtherPayoutAmount = new BoundField();
            OtherPayoutAmount.HeaderText = "Other Payout";
            OtherPayoutAmount.DataField = "OtherPayoutAmount";
            OtherPayoutAmount.DataFormatString = "{0:N0}";
            grid.Columns.Add(OtherPayoutAmount);

            BoundField totalPayout = new BoundField();
            totalPayout.HeaderText = "Total";
            totalPayout.DataField = "totalPayout";
            totalPayout.DataFormatString = "{0:N0}";
            grid.Columns.Add(totalPayout);

            BoundField PushAmount = new BoundField();
            PushAmount.HeaderText = "Push";
            PushAmount.DataField = "PushAmount";
            PushAmount.DataFormatString = "{0:N0}";
            grid.Columns.Add(PushAmount);

            BoundField NoActionAmount = new BoundField();
            NoActionAmount.HeaderText = "NoActionAmount";
            NoActionAmount.DataField = "NoActionAmount";
            NoActionAmount.DataFormatString = "{0:N0}";
            grid.Columns.Add(NoActionAmount);


            BoundField utilityTotal = new BoundField();
            utilityTotal.HeaderText = "Profit";
            utilityTotal.DataField = "utilityTotal";
            utilityTotal.DataFormatString = "{0:N0}";
            grid.Columns.Add(utilityTotal);

            BoundField utilityPercentage = new BoundField();
            utilityPercentage.HeaderText = "%";
            utilityPercentage.DataField = "utilityPercentage";
            utilityPercentage.DataFormatString = "{0:N2}";
            grid.Columns.Add(utilityPercentage);

            BoundField DeletedAmount = new BoundField();
            DeletedAmount.HeaderText = "Deleted";
            DeletedAmount.DataField = "DeletedAmount";
            DeletedAmount.DataFormatString = "{0:N0}";
            grid.Columns.Add(DeletedAmount);





            grid.Columns[0].HeaderText = "Player";
            grid.Columns[1].HeaderText = "STRRisk";
            grid.Columns[2].HeaderText = "ParlaysRisk";
            grid.Columns[3].HeaderText = "OtherRisk";
            grid.Columns[4].HeaderText = "TotalRisk";
            grid.Columns[5].HeaderText = "STRPayout";
            grid.Columns[6].HeaderText = "ParlaysPayout";
            grid.Columns[7].HeaderText = "OtherPayout";
            grid.Columns[8].HeaderText = "TotalPayout";
            grid.Columns[9].HeaderText = "Push";
            grid.Columns[10].HeaderText = "NoAction";
            grid.Columns[11].HeaderText = "Profit";
            grid.Columns[12].HeaderText = "Percentage";
            grid.Columns[13].HeaderText = "Deleted";



            grid.Columns[0].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[1].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[2].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[3].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[4].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[5].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[6].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[7].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[8].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[9].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[10].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[11].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[12].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            grid.Columns[13].ItemStyle.Width = new Unit(20, UnitType.Pixel);

            grid.DataBind();

            return grid;
        }






        protected DataTable getTotalReport(int prmIdAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("DetailedSalesReportTotal", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandTimeout = 60;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmDateFrom", SqlDbType.DateTime)).Value = txtDateFrom.Text;
                ((SqlParameter)comm.Parameters.Add("@prmDateTo", SqlDbType.DateTime)).Value = txtDateTo.Text;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);

            }
            catch (Exception e)
            {
                Response.Write(e.Message);
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
        }

        protected DataTable getReport(int prmIdAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("DetailedSalesReport3", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmDateFrom", SqlDbType.DateTime)).Value = txtDateFrom.Text;
                ((SqlParameter)comm.Parameters.Add("@prmDateTo", SqlDbType.DateTime)).Value = txtDateTo.Text;

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
