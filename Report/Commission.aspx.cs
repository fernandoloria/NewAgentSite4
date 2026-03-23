using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;

namespace AgentSite4.Report
{
    public partial class Commission  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Xml)]
        public static string CommissionGetTemp(DateTime d1, DateTime d2, string agent)
        {
            HttpContext context = HttpContext.Current;
            string html = "";

            int i = 0;
            int commSports = 0;
            int agentid = 0;
            int distributor = 0;

            context.Session["d1"] = d1;
            context.Session["d2"] = d2;
            context.Session["agentList"] = "";

            html += "<div class='card card-custom gutter-b'>" +
                        "<div class='card-header flex-wrap border-0 pt-6 pb-0'>" +
                            "<div class='card-title'>" +
                                "<h3 class='card-label'>Agent Commission - Agent: " + agent + "<br>" +
                                "<span class='d-block text-muted pt-2 font-size-sm'>" + "Week: " + d1 + " - " + d2 + "</span></h3>" +
                            "</div>" +
                        "</div>" +
                        "<div class='card-body'>";

            string sqlStr = "SELECT IdAgent, CommSports, IsDistributor FROM AGENT WHERE Agent = '" + agent + "'";
            //DataSet data = Common.ExecuteQuery(sqlStr, "DGSDATA");

            DataSet data = (DataSet)null;
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection connection = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                SqlCommand selectCommand = new SqlCommand(sqlStr, connection);

                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand);
                data = new DataSet();
                sqlDataAdapter.Fill(data, "DataSet");
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }



            if (data.Tables[0].Rows.Count > 0)
            {
                DataRow row = data.Tables[0].Rows[0];
                commSports = Convert.ToInt32(row["CommSports"]);
                agentid = Convert.ToInt32(row["IdAgent"]);
                distributor = Convert.ToInt32(row["IsDistributor"]);
            }

            if (agentid > 0)
            {
                if (distributor == 1)
                {
                    //GetAgentList(agentid);
                    string agentList = "select idagent from DGSDATA.dbo.Func_GetDistributorList_New(" + agentid + ")";
                   // context.Session["agentList"] = context.Session["agentList"].ToString().Substring(0, context.Session["agentList"].ToString().Length - 1);
                    html += GetVolumePlayersByAgentList_TEMP(agentList, d1, d2);
                }
                else
                {
                    html += GetVolumePlayersByAgentList_TEMP(agentid.ToString(), d1, d2);
                }
            }

            context.Session["d1"] = "";
            context.Session["d2"] = "";
            context.Session.Contents.RemoveAll();

            html += "</div></div>";

            return html;
        }
        public static void GetAgentList(int agentid)
        {
            HttpContext context = HttpContext.Current;
            string sqlStr = "SELECT IdAgent, Agent, IsDistributor FROM AGENT WHERE Distributor = @AgentId";

            SqlParameter[] parameters = { new SqlParameter("@AgentId", SqlDbType.Int) { Value = agentid } };

            DataSet data = ExecuteQuery(sqlStr, parameters, "DGSDATAConnectionString");

            foreach (DataRow row in data.Tables[0].Rows)
            {
                int subagentid = Convert.ToInt32(row["IdAgent"]);
                string subagent = row["Agent"].ToString();
                int subdistributor = Convert.ToInt32(row["IsDistributor"]);

                if (subdistributor == 1)
                {
                    GetAgentList(subagentid);
                }
                else
                {
                    context.Session["agentList"] = context.Session["agentList"].ToString() + subagentid + ",";
                }
            }
        }

        public static DataSet ExecuteQuery(string query, SqlParameter[] parameters, string connectionStringName)
        {
            string connectionString = ConfigurationManager.ConnectionStrings[connectionStringName].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddRange(parameters);
                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        DataSet dataSet = new DataSet();
                        adapter.Fill(dataSet);
                        return dataSet;
                    }
                }
            }
        }

        public static string GetVolumePlayersByAgentList_TEMP(string agentList, DateTime d1, DateTime d2)
        {
            HttpContext context = HttpContext.Current;
            string text = "";

            int i = 0;
            int currentPlayer = 0;
            int newPlayer = 0;

            string sqlStr = "SELECT GWH.IdAgent, A.Agent, GWH.IdPlayer, P.Player, CAST(GWH.SettledDate AS DATE) AS SettledDate, " +
                            "COALESCE(SUM(CASE WHEN OriginalRiskAmount < OriginalWinAmount THEN OriginalRiskAmount ELSE OriginalWinAmount END ),0) AS OriginalWagerAmount FROM GRADEDWAGERHEADER AS GWH, Agent AS A, Player AS P " +
                            "WHERE GWH.IdAgent IN (" + agentList + ") AND GWH.SettledDate BETWEEN '" + d1.ToString("yyyy-MM-dd") + " 00:00:00' AND '" + d2.ToString("yyyy-MM-dd") + "  23:59:59.995' " +
                            "AND GWH.Result NOT IN (2,3,4,5,6,7,8) AND GWH.IdAgent = A.IdAgent AND GWH.IdPlayer = P.IdPlayer " +
                            "AND GWH.IdPlayer IN (select IdPlayer from [DGS_AddOns]..[PlayerTypeConfig]) " +
                            "GROUP BY GWH.IdAgent, A.Agent, GWH.IdPlayer, P.Player, CAST(GWH.SettledDate AS DATE) " +
                            "ORDER BY A.Agent, GWH.IdPlayer, P.Player, CAST(GWH.SettledDate AS DATE)";

            //DataSet data = ExecuteQuery(sqlStr, "DGSDATA");

            DataSet data = (DataSet)null;
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection connection = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                SqlCommand selectCommand = new SqlCommand(sqlStr, connection);

                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand);
                data = new DataSet();
                sqlDataAdapter.Fill(data, "DataSet");
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }

            text += "<table class='table'><thead>" +
                        "<tr style='background-color:#fff;color:#000;'>" +
                        "<th></th>" +
                        "<th>Account</th>" +
                        "<th>Mon</th>" +
                        "<th>Tue</th>" +
                        "<th>Wed</th>" +
                        "<th>Thu</th>" +
                        "<th>Fri</th>" +
                        "<th>Sat</th>" +
                        "<th>Sun</th>" +
                        "<th>Total Volume</th>" +
                        "<th>Commission</th>" +
                        "</tr></thead><tbody>";

            context.Session["volumenTotal"] = 0;
            context.Session["commTotal"] = 0;
            context.Session["agentVolume"] = 0;
            context.Session["agentCommission"] = 0;
            double adjDate = 0;
            int tempPlayer = 0;
            newPlayer = 0;
            string tempAgent = "";
            DateTime tempadjDate = new DateTime(1970, 1, 1);

            if (data.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow row in data.Tables[0].Rows)
                {
                    string player = row["Player"].ToString();
                    int IdPlayer = Convert.ToInt32(row["IdPlayer"]);
                    currentPlayer = IdPlayer;
                    string currentAgent = row["Agent"].ToString();
                    DateTime settledDate = Convert.ToDateTime(row["SettledDate"]);
                    double amt = Convert.ToDouble(row["OriginalWagerAmount"]);
                    double commmissionByPlayer = GetCommissionByCustomer(IdPlayer);
                    float commSports = 0;

                    if (commmissionByPlayer > 0)
                    {
                        commSports = Convert.ToSingle(commmissionByPlayer);
                    }

                    if (currentPlayer != newPlayer)
                    {
                        i++;

                        if (i > 1)
                        {
                            text += closePlayer(tempPlayer, tempadjDate, d2);
                            if (tempAgent != currentAgent)
                            {
                                text += "<tr class='alert-info'><td></td><td><strong>" + tempAgent + "</strong></td>" +
                                        "<td colspan='7'></td><td><strong>" + Convert.ToDouble(context.Session["agentVolume"]).ToString("C") + "</strong></td>" +
                                        "<td><strong>" + Convert.ToDouble(context.Session["agentCommission"]).ToString("C") + "</strong></td></tr>";

                                context.Session["agentVolume"] = 0;
                                context.Session["agentCommission"] = 0;
                            }
                        }

                        adjDate = (settledDate - d1).TotalDays;
                        text += "<tr>" +
                                    "<td>" + i + "</td>" +
                                    "<td>" + player + "</td>";

                        for (int x = 1; x <= adjDate; x++)
                        {
                            text += "<td>" + "0" + "</td>";
                        }

                        text += "<td>" + amt.ToString() + "</td>";
                        tempadjDate = settledDate;
                    }
                    else
                    {
                        adjDate = (settledDate - tempadjDate).TotalDays;

                        for (int x = 1; x <= (adjDate - 1); x++)
                        {
                            text += "<td>" + "0" + "</td>";
                        }

                        text += "<td>" + amt.ToString() + "</td>";
                        tempadjDate = settledDate;
                    }

                    newPlayer = IdPlayer;
                    tempPlayer = currentPlayer;
                    tempAgent = row["Agent"].ToString();
                }

                text += closePlayer(tempPlayer, tempadjDate, d2);
                text += "<tr class='alert-info'><td></td><td><strong>" + tempAgent + "</strong></td>" +
                        "<td colspan='7'></td><td><strong>" + Convert.ToDouble(context.Session["agentVolume"]).ToString("C") + "</strong></td>" +
                        "<td><strong>" + Convert.ToDouble(context.Session["agentCommission"]).ToString("C") + "</strong></td></tr>";

                text += "<tr class='alert-success'><td></td><td><strong>Total</strong></td><td colspan='7'></td>" +
                        "<td><strong>" + Convert.ToDouble(context.Session["volumenTotal"]).ToString("C") + "</strong></td>" +
                        "<td><strong>" + Convert.ToDouble(context.Session["commTotal"]).ToString("C") + "</strong></td></tr>";
            }

            text += "</tbody></table>";

            context.Session["volumenTotal"] = 0;

            return text;
        }
        private static double GetCommissionByCustomer(int pid)
        {
            double commission = 0;
            string sqlStr = "SELECT SportPercentage FROM [DGS_AddOns]..[PlayerTypeConfig] WHERE idplayer = " + pid;

            //DataSet data = ExecuteQuery(sqlStr, "DGSDATA");
            DataSet data = (DataSet)null;
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection connection = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                SqlCommand selectCommand = new SqlCommand(sqlStr, connection);

                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand);
                data = new DataSet();
                sqlDataAdapter.Fill(data, "DataSet");
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }

            if (data.Tables[0].Rows.Count > 0)
            {
                commission = Convert.ToDouble(data.Tables[0].Rows[0]["SportPercentage"]);
            }

            return commission;
        }
        private static string closePlayer(int tempPlayer, DateTime tempadjDate, DateTime finaldate)
        {
            HttpContext context = HttpContext.Current;

            string text = "";
            double adjDate = (finaldate - tempadjDate).TotalDays;
            for (int x = 1; x <= adjDate; x++)
            {
                text += "<td>" + "0" + "</td>";
            }
            text += getJuiceByPlayer(tempPlayer);
            text += "</tr>";

            context.Session["volumenTotal"] = Convert.ToDouble(context.Session["volumenTotal"]) + Convert.ToDouble(context.Session["volumenbyPlayer"]);
            context.Session["commTotal"] = Convert.ToDouble(context.Session["commTotal"]);

            return text;
        }
        private static string getJuiceByPlayer(int pid)
        {
            HttpContext context = HttpContext.Current;

            string text = "";
            double amt = 0;

            string sqlStr = "EXECUTE GetPlayerCommission @prmIdPlayer = " + pid + ", @prmStartDate = '" + Convert.ToDateTime(context.Session["d1"]).ToString("yyyy-MM-dd") + " 00:00', @prmEndDate = '" + Convert.ToDateTime(context.Session["d2"]).ToString("yyyy-MM-dd") + " 23:59:59.995'";
            //DataSet data = ExecuteQuery(sqlStr, "DGSDATA");

            DataSet data = (DataSet)null;
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection connection = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                SqlCommand selectCommand = new SqlCommand(sqlStr, connection);

                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand);
                data = new DataSet();
                sqlDataAdapter.Fill(data, "DataSet");
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }

            if (data.Tables[0].Rows.Count > 0)
            {
                DataRow row = data.Tables[0].Rows[0];
                double volumen = Convert.ToDouble(row["Volume"]);
                double juice = Convert.ToDouble(row["LastWeekSportsJuice"]);
                string playerType = row["Player_CommissionTYPE"].ToString();

                text += "<td>" + volumen.ToString() + "</td>" +
                        "<td>" + juice.ToString() + "</td>";

                context.Session["commTotal"] = Convert.ToSingle(context.Session["commTotal"]) + Convert.ToSingle(juice);
                context.Session["agentVolume"] = Convert.ToSingle(context.Session["agentVolume"]) + Convert.ToSingle(volumen);
                context.Session["agentCommission"] = Convert.ToSingle(context.Session["agentCommission"]) + Convert.ToSingle(juice);
            }

            return text;
        }

        public static string FormatNumber(decimal number, string type)
        {
            string newNumber = "";

            switch (type)
            {
                case "$":
                    if (Convert.ToInt64(number) == number)
                    {
                        newNumber = number.ToString("C").Replace(".00", "").Replace("$", "").Replace("(", "-").Replace(")", "");
                    }
                    else
                    {
                        newNumber = number.ToString("C").Replace("$", "").Replace("(", "-").Replace(")", "");
                    }
                    break;

                case "%":
                    if (Convert.ToInt64(number) == number)
                    {
                        newNumber = Convert.ToInt64(number).ToString() + "%";
                    }
                    else
                    {
                        newNumber = Decimal.Round(number, 2, MidpointRounding.AwayFromZero).ToString() + "%";
                    }
                    break;

                case "N":
                    if (Convert.ToInt64(number) == number)
                    {
                        newNumber = number.ToString("N").Replace(".00", "").Replace("(", "-").Replace(")", "");
                    }
                    else
                    {
                        newNumber = number.ToString("N").Replace("(", "-").Replace(")", "");
                    }
                    break;

                default:
                    if (Convert.ToInt64(number) == number)
                    {
                        newNumber = Convert.ToInt64(number).ToString();
                    }
                    else
                    {
                        newNumber = number.ToString();
                    }
                    break;
            }

            return newNumber;
        }
    }
}
