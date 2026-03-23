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
    public partial class AgentCommissionV2  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtDate.Text = fromOrTo(true).ToString("MM/dd/yyyy");
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

        protected DataTable getAllAgents(int prmIdAgent)
        {

            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("WebGetAllSubAgentsOneLevel", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmLevel", SqlDbType.Bit)).Value = 0;
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

        protected DataTable getTotalCommision(string agent)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("AddOn_Web_Report_Agent_Weekly_BalanceComm", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@agent", SqlDbType.VarChar)).Value = agent;
                ((SqlParameter)comm.Parameters.Add("@prmTypeList", SqlDbType.Bit)).Value = 1;
                ((SqlParameter)comm.Parameters.Add("@prmDateWeek", SqlDbType.VarChar)).Value = txtDate.Text;

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

        public DataTable getTotalsAgent(string agent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("AddOn_Web_Report_Agent_Weekly_BalanceCommSum", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@agent", SqlDbType.VarChar)).Value = agent;
                ((SqlParameter)comm.Parameters.Add("@prmDateWeek", SqlDbType.VarChar)).Value = txtDate.Text;

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

        public string printAgentComission(string agent)
        {
            DataTable totals = getTotalCommision(agent);

            DataRow linea = totals.Rows[0];

            decimal MasterSComm1 = Convert.ToDecimal(linea["Sday1"]);
            decimal MasterSComm2 = Convert.ToDecimal(linea["Sday2"]);
            decimal MasterSComm3 = Convert.ToDecimal(linea["Sday3"]);
            decimal MasterSComm4 = Convert.ToDecimal(linea["Sday4"]);
            decimal MasterSComm5 = Convert.ToDecimal(linea["Sday5"]);
            decimal MasterSComm6 = Convert.ToDecimal(linea["Sday6"]);
            decimal MasterSComm7 = Convert.ToDecimal(linea["Sday7"]);
            decimal MasterCComm1 = Convert.ToDecimal(linea["Cday1"]);
            decimal MasterCComm2 = Convert.ToDecimal(linea["Cday2"]);
            decimal MasterCComm3 = Convert.ToDecimal(linea["Cday3"]);
            decimal MasterCComm4 = Convert.ToDecimal(linea["Cday4"]);
            decimal MasterCComm5 = Convert.ToDecimal(linea["Cday5"]);
            decimal MasterCComm6 = Convert.ToDecimal(linea["Cday6"]);
            decimal MasterCComm7 = Convert.ToDecimal(linea["Cday7"]);
            decimal MasterHComm1 = Convert.ToDecimal(linea["Hday1"]);
            decimal MasterHComm2 = Convert.ToDecimal(linea["Hday2"]);
            decimal MasterHComm3 = Convert.ToDecimal(linea["Hday3"]);
            decimal MasterHComm4 = Convert.ToDecimal(linea["Hday4"]);
            decimal MasterHComm5 = Convert.ToDecimal(linea["Hday5"]);
            decimal MasterHComm6 = Convert.ToDecimal(linea["Hday6"]);
            decimal MasterHComm7 = Convert.ToDecimal(linea["Hday7"]);
            decimal NewMakeUp = Convert.ToDecimal(linea["NewMakeUp"]);
            decimal TotalComm = Convert.ToDecimal(linea["TotalComm"]);
            decimal SumSports = Convert.ToDecimal(linea["SumSports"]);
            decimal SumCasino = Convert.ToDecimal(linea["SumCasino"]);
            decimal SumHorses = Convert.ToDecimal(linea["SumHorses"]);
            decimal SportComm = Convert.ToDecimal(linea["SportComm"]);
            decimal CasinoComm = Convert.ToDecimal(linea["CasinoComm"]);
            decimal HorsesComm = Convert.ToDecimal(linea["HorsesComm"]);

            string rows =

                "<TR><TD colspan='2'><B>Sports Commission: </B></TD>" + "\n" +
                "<TD>" + MasterSComm1.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterSComm2.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterSComm3.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterSComm4.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterSComm5.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterSComm6.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterSComm7.ToString("N2") + "</TD>" + "\n" +
                "<TD><b>" + SportComm.ToString("N2") + "</b>" + "\n" +
                "</TD><TD colspan='4'><B>Total Commission: " + TotalComm.ToString("N2") + "</B></TD>" + "\n" +
                //"<TD></TD><TD></TD>"+
                "</TR>" + "\n" +
                "<TR><TD colspan='2'><B>Casino Commission: </B></TD>" + "\n" +
                "<TD>" + MasterCComm1.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterCComm2.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterCComm3.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterCComm4.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterCComm5.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterCComm6.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterCComm7.ToString("N2") + "</TD>" + "\n" +
                "<TD><b>" + CasinoComm.ToString("N2") + "</b></TD>" + "\n" +
                "<TD></TD><TD></TD>" +
                "</TR>" + "\n" +
                "<TR>" + "\n" +
                "<TD colspan='2'><B>Horses Commission: </B></TD>" + "\n" +
                "<TD>" + MasterHComm1.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterHComm2.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterHComm3.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterHComm4.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterHComm5.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterHComm6.ToString("N2") + "</TD>" + "\n" +
                "<TD>" + MasterHComm7.ToString("N2") + "</TD>" + "\n" +
                "<TD><b>" + HorsesComm.ToString("N2") + "</b></TD>" +
                "<TD></TD><TD></TD>" +
                "</TR>";

            return rows;
        }

        public string printTotalAgent(string agent)
        {
            DataTable totals = getTotalsAgent(agent);

            DataRow linea = totals.Rows[0];

            decimal MasterTotal1 = Convert.ToDecimal(linea["Day1"]);
            decimal MasterTotal2 = Convert.ToDecimal(linea["Day2"]);
            decimal MasterTotal3 = Convert.ToDecimal(linea["Day3"]);
            decimal MasterTotal4 = Convert.ToDecimal(linea["Day4"]);
            decimal MasterTotal5 = Convert.ToDecimal(linea["Day5"]);
            decimal MasterTotal6 = Convert.ToDecimal(linea["Day6"]);
            decimal MasterTotal7 = Convert.ToDecimal(linea["Day7"]);
            decimal MasterThisWeek = Convert.ToDecimal(linea["TotalWeek"]);


            string row =
                "<TR CLASS='TrSubTotal'>" + "\n" +
                "<TD colspan='2'><B>Agent " + agent + " Totals:</B></TD>" + "\n" +
                "<TD><B>" + MasterTotal1.ToString("N2") + "</B></TD>" + "\n" +
                "<TD><B>" + MasterTotal2.ToString("N2") + "</B></TD>" + "\n" +
                "<TD><B>" + MasterTotal3.ToString("N2") + "</B></TD>" + "\n" +
                "<TD><B>" + MasterTotal4.ToString("N2") + "</B></TD>" + "\n" +
                "<TD><B>" + MasterTotal5.ToString("N2") + "</B></TD>" + "\n" +
                "<TD><B>" + MasterTotal6.ToString("N2") + "</B></TD>" + "\n" +
                "<TD><B>" + MasterTotal7.ToString("N2") + "</B></TD>" + "\n" +
                "<TD><B>" + MasterThisWeek.ToString("N2") + "</B></TD>" + "\n" +
                "<TD></TD><TD></TD><TD></TD><TD></TD></TR>" + "\n";
            return row;
        }

        protected void lnkThisWeek_Click(object sender, EventArgs e)
        {
            changeDate(0);

        }

        protected void lnkLastWeek_Click(object sender, EventArgs e)
        {
            changeDate(1);
        }

        protected void lnk2Weeks_Click(object sender, EventArgs e)
        {
            changeDate(2);
        }

        protected void lnk3Weeks_Click(object sender, EventArgs e)
        {
            changeDate(3);
        }

        protected void changeDate(int weeks)
        {
            DateTime today = DateTime.Now;
            int minusDay = 0;
            switch (today.DayOfWeek)
            {
                case DayOfWeek.Monday:
                    minusDay = 0;
                    break;
                case DayOfWeek.Tuesday:
                    minusDay = -1;
                    break;
                case DayOfWeek.Wednesday:
                    minusDay = -2;
                    break;
                case DayOfWeek.Thursday:
                    minusDay = -3;
                    break;
                case DayOfWeek.Friday:
                    minusDay = -4;
                    break;
                case DayOfWeek.Saturday:
                    minusDay = -5;
                    break;
                case DayOfWeek.Sunday:
                    minusDay = -6;
                    break;
            }
            DateTime monday = today.AddDays(minusDay);
            int minusWeeks = -7 * weeks;
            DateTime week = monday.AddDays(minusWeeks);

            txtDate.Text = week.ToString("MM/dd/yyyy");
        }
    }
}
