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

namespace AgentSite4.Report
{
    public partial class AgentStatistics  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        bool isTableOpen = false;
        int agentLevel = 0;

        public DataTable agentStatistics = new DataTable();


        protected void Page_Init(object sender, EventArgs e)
        {

        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void RenderReport()
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("<div class=\"table-responsive\"><table class='table-dynamic table table-bordered table-striped' align='center'>");

            sb.Append("<thead>");
            sb.Append("<tr>");
            sb.Append("<th>Agent</th>");
            sb.Append("<th class='details'>Receipt</th>");
            sb.Append("<th class='details'>Disbursement</th>");
            sb.Append("<th class='details'>Transfers</th>");
            sb.Append("<th class='details'>Accrual Adj</th>");
            sb.Append("<th class='pmts' onclick='toggleColumnSet(\"details\")'>Total Transactions</th>");
            sb.Append("<th class='actions'>Sports</th>");
            sb.Append("<th class='actions'>Adj</th>");
            sb.Append("<th class='actions'>Total Sports</th>");
            sb.Append("<th class='actions'>Casino</th>");
            sb.Append("<th class='actions'>Horses</th>");
            sb.Append("<th class='actions'>Horse Adj</th>");
            sb.Append("<th class='actions'>Total Horses</th>");
            sb.Append("<th class='acttotal' onclick='toggleColumnSet(\"actions\")'>Total Action</th>");
            sb.Append("<th class='freeplay'>Free Play</th>");
            sb.Append("<th class='deleted'>Deleted</th>");
            sb.Append("</tr>");
            sb.Append("</thead>");

            DataRow[] topLevelAgents = agentStatistics.Select("AgentLevel = 1");
            foreach (DataRow topAgent in topLevelAgents)
            {
                RenderAgent(sb, topAgent);
            }
            sb.Append("</table></div>");
            string report = sb.ToString();

            Response.Write(report);
        }

        protected void RenderAgent(StringBuilder sb, DataRow agentRow)
        {
            int idAgent = Convert.ToInt32(agentRow["IdAgent"]);
            int level = Convert.ToInt32(agentRow["AgentLevel"]);
            bool isDistributor = Convert.ToBoolean(agentRow["isDistributor"]);
            string distributor = agentRow["Distributor"].ToString();
            string agent = agentRow["Agent"].ToString();

            if (level > 2)
            {
                sb.Append("<tr class='sub-agent-" + distributor.ToString() + " agent-level-" + (level + 1).ToString() + "' style='display: none;'>");
            }
            else if (level == 2)
            {
                sb.Append("<tr class='sub-agent-" + distributor.ToString() + " agent-level-" + (level + 1).ToString() + "'>");
            }
            else
            {
                sb.Append("<tr class='agent-level-" + level.ToString() + "'>");
            }
            sb.Append(AgentRows(agentRow));
            sb.Append("</tr>");

            if (isDistributor)
            {
                DataRow[] subAgents = agentStatistics.Select("Distributor = " + idAgent.ToString());
                foreach (DataRow subAgent in subAgents)
                {
                    RenderAgent(sb, subAgent);
                }
            }

        }


        protected string AgentRows(DataRow agentRow)
        {
            StringBuilder sb = new StringBuilder();
            int idAgent = Convert.ToInt32(agentRow["IdAgent"]);
            int level = Convert.ToInt32(agentRow["AgentLevel"]);
            bool isDistributor = Convert.ToBoolean(agentRow["isDistributor"]);
            string agent = agentRow["Agent"].ToString();
            decimal receipt = Convert.ToDecimal(agentRow["Receipt"]);
            decimal disbursement = -Convert.ToDecimal(agentRow["Disbursement"]);
            decimal accrual = Convert.ToDecimal(agentRow["Accrual"]);
            decimal transfers = Convert.ToDecimal(agentRow["Transfers"]);
            decimal sports = Convert.ToDecimal(agentRow["Sports"]);
            decimal adjustments = Convert.ToDecimal(agentRow["Adjustments"]);
            decimal casino = Convert.ToDecimal(agentRow["Casino"]);
            decimal horses = Convert.ToDecimal(agentRow["Horses"]);
            decimal horseAdjustment = Convert.ToDecimal(agentRow["HAdjustment"]);
            decimal freePlay = Convert.ToDecimal(agentRow["FreePlay"]);
            decimal deleted = Convert.ToDecimal(agentRow["Deleted"]);

            decimal payments = receipt - disbursement + accrual + transfers;
            decimal totalSports = sports + adjustments;
            decimal totalHorses = horses + horseAdjustment;

            decimal action = totalSports + casino + totalHorses;

            string toggleButton = isDistributor ? "<span class='toggle-button' onclick='toggleAgentRows(" + idAgent.ToString() + ");'>[+]</span>" : "";

            sb.Append("<td>" + toggleButton + agent + "</td>");
            sb.AppendFormat("<td class='{0} details'>{1:N0}</td>", DetermineValueClass(receipt), receipt);
            sb.AppendFormat("<td class='{0} details'>{1:N0}</td>", DetermineValueClass(disbursement), disbursement);
            sb.AppendFormat("<td class='{0} details'>{1:N0}</td>", DetermineValueClass(transfers), transfers);
            sb.AppendFormat("<td class='{0} details'>{1:N0}</td>", DetermineValueClass(accrual), accrual);
            sb.AppendFormat("<td class='{0} pmts'>{1:N0}</td>", DetermineValueClass(payments), payments);

            sb.AppendFormat("<td class='{0} actions'>{1:N0}</td>", DetermineValueClass(sports), sports);
            sb.AppendFormat("<td class='{0} actions'>{1:N0}</td>", DetermineValueClass(adjustments), adjustments);
            sb.AppendFormat("<td class='{0} actions'>{1:N0}</td>", DetermineValueClass(totalSports), totalSports);

            sb.AppendFormat("<td class='{0} actions'>{1:N0}</td>", DetermineValueClass(casino), casino);

            sb.AppendFormat("<td class='{0} actions'>{1:N0}</td>", DetermineValueClass(horses), horses);
            sb.AppendFormat("<td class='{0} actions'>{1:N0}</td>", DetermineValueClass(horseAdjustment), horseAdjustment);
            sb.AppendFormat("<td class='{0} actions'>{1:N0}</td>", DetermineValueClass(totalHorses), totalHorses);

            sb.AppendFormat("<td class='{0} acttotal'>{1:N0}</td>", DetermineValueClass(action), action);

            sb.AppendFormat("<td class='{0} freeplay'>{1:N0}</td>", DetermineValueClass(freePlay), freePlay);
            sb.AppendFormat("<td class='{0} deleted'>{1:N0}</td>", DetermineValueClass(deleted), deleted);


            return sb.ToString();
        }



        #region SQLCalls

        protected DataTable LoadAgentStatistics(int prmIdAgent)
        {
            DataTable table = new DataTable();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;


            string key = prmIdAgent + ",agentStatistics";

            if (Session[key] != null && 1 == 2)
            {
                return (DataTable)Session[key];
            }

            using (SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                try
                {
                    Cnn.Open();
                    using (SqlCommand comm = new SqlCommand("AgentStatistics", Cnn))
                    {
                        comm.CommandTimeout = 120;
                        comm.CommandType = CommandType.StoredProcedure;

                        comm.Parameters.AddWithValue("@prmIdAgent", prmIdAgent);

                        using (SqlDataReader readerAgent = comm.ExecuteReader())
                        {
                            table.Load(readerAgent);
                        }
                    }
                    Session[key] = table;
                }
                catch (Exception ex)
                {
                    string Error = ex.Message;
                }
            }

            return table;
        }


        #endregion


        #region common


        protected string DetermineValueClass(decimal value)
        {
            if (value == 0) return "";
            return value < 0 ? "neg" : "pos";
        }

        #endregion


        #region actions


        #endregion


    }
}
