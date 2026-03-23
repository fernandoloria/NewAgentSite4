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
    public partial class HoldPercentV2  : BasePage, IRequiresSessionState
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
        }

        protected GridView createGridView(DataTable table)
        {
            double sum1 = 0;
            double sum2 = 0;
            double sum3 = 0;

            foreach (DataRow linea in table.Rows)
            {
                sum1 += Convert.ToDouble(linea["Amount"]);
                sum2 += Convert.ToDouble(linea["WinLost"]);
            }
            sum3 = (sum2 / sum1) * 100;

            GridView grid = new GridView();

            grid.DataSource = table;

            grid.Width = new Unit(100, UnitType.Percentage);
            grid.AutoGenerateColumns = false;
            grid.EnableModelValidation = true;
            grid.CssClass = "table-bordered";

            grid.AlternatingRowStyle.CssClass = "TrGameEven";
            grid.HeaderStyle.CssClass = "page-titles";
            grid.FooterStyle.CssClass = "TrGameBottom";
            grid.RowStyle.CssClass = "TrGameOdd";



            BoundField IdSport = new BoundField();
            IdSport.HeaderText = "IdSport";
            IdSport.DataField = "IdSport";
            grid.Columns.Add(IdSport);

            BoundField Description = new BoundField();
            Description.HeaderText = "Description";
            Description.DataField = "Description";
            grid.Columns.Add(Description);

            BoundField Amount = new BoundField();
            Amount.HeaderText = "Amount";
            Amount.DataField = "Amount";
            Amount.DataFormatString = "{0:N0}";
            Amount.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            grid.Columns.Add(Amount);

            BoundField WinLost = new BoundField();
            WinLost.HeaderText = "WinLost";
            WinLost.DataField = "WinLost";
            WinLost.DataFormatString = "{0:N0}";
            WinLost.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            grid.Columns.Add(WinLost);

            BoundField HoldPercent = new BoundField();
            HoldPercent.HeaderText = "HoldPercent";
            HoldPercent.DataField = "HoldPercent";
            HoldPercent.DataFormatString = "{0:N2}";
            HoldPercent.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            grid.Columns.Add(HoldPercent);

            grid.Columns[0].HeaderText = "Sport";
            grid.Columns[1].HeaderText = "Wager Type";
            grid.Columns[2].HeaderText = "Amount";
            grid.Columns[3].HeaderText = "Win / Lost";
            grid.Columns[4].HeaderText = "Hold %";


            grid.Columns[1].FooterText = "Total";
            grid.Columns[1].FooterStyle.Font.Bold = true;
            grid.Columns[0].FooterText = "";//
            grid.Columns[2].FooterText = sum1.ToString("N0");
            grid.Columns[2].FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            grid.Columns[3].FooterText = sum2.ToString("N0");
            grid.Columns[3].FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            grid.Columns[4].FooterText = sum3.ToString("N2") + " %";
            grid.Columns[4].FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            grid.ShowFooter = true;


            grid.Columns[0].ItemStyle.Width = new Unit(60, UnitType.Pixel);
            grid.Columns[1].ItemStyle.Width = new Unit(300, UnitType.Pixel);
            grid.Columns[2].ItemStyle.Width = new Unit(60, UnitType.Pixel);
            grid.Columns[3].ItemStyle.Width = new Unit(60, UnitType.Pixel);
            grid.Columns[4].ItemStyle.Width = new Unit(60, UnitType.Pixel);



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
                SqlCommand comm = new SqlCommand("AddOn_HoldPercentV2", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmDateFrom", SqlDbType.DateTime)).Value = txtDateFrom.Text;
                ((SqlParameter)comm.Parameters.Add("@prmDateTo", SqlDbType.DateTime)).Value = txtDateTo.Text;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.VarChar)).Value = ddlPlayer.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmIsDetail", SqlDbType.Bit)).Value = chkDetail.Checked;
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
