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
using System.Web.Script.Services;
using System.Web.Services;
using System.Runtime.Remoting.Contexts;
using System.Web.Script.Serialization;
using AddOnWebClient;


namespace AgentSite4.Report
{
    public partial class WeeklyBalancesEnhanced : BasePage, IRequiresSessionState
    {

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        bool isTableOpen = false;
        int agentLevel = 0;

        DataTable weeklyBalance = new DataTable();
        DataTable agentTotals = new DataTable();
        DataTable labels = new DataTable();


        protected void Page_Init(object sender, EventArgs e)
        {
            if (Session["prmDateWeek"] != null && !String.IsNullOrEmpty(Session["prmDateWeek"].ToString()))
            {
                txtDate.Text = ((DateTime)Session["prmDateWeek"]).ToString("MM/dd/yyyy");
            }
            else
            {
                txtDate.Text = AddOnWebClient.Common.fromOrTo(true).ToString("MM/dd/yyyy");
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                string prmAgent = this.Session["SubAgent"].ToString();
                weeklyBalance = AddOn_Web_Report_Weekly_Balance_V8(prmIdAgent);
                agentTotals = AddOn_Web_Report_Weekly_Balance_V8_Totals(prmIdAgent);
                labels = AddOn_Web_Report_Weekly_Balance_V8_Labels(prmIdAgent);

                RenderReport();
            }
        }


        protected void RenderReport()
        {
            StringBuilder sb = new StringBuilder();

            DataRow[] topLevelAgents = agentTotals.Select("AgentLevel = 1");

            foreach (DataRow topAgent in topLevelAgents)
            {
                RenderAgent(sb, topAgent);
            }

            this.ReportHolder.Controls.Add(this.Page.ParseControl(sb.ToString()));
        }

        protected void RenderAgent(StringBuilder sb, DataRow agentRow)
        {
            int idAgent = Convert.ToInt32(agentRow["IdAgent"]);
            bool isDistributor = Convert.ToBoolean(agentRow["isDistributor"]);
            string agent = agentRow["Agent"].ToString();
            DataRow[] agentLabels = labels.Select("idAgent = " + idAgent);

            string hierarchy = agentLabels[0]["Hierarchy"].ToString();

            if (!string.IsNullOrEmpty(hierarchy))
            {
                hierarchy = hierarchy.Replace(agent, "").Replace(Session["SubAgent"].ToString(), "");
                hierarchy = hierarchy.Contains(" - ") ? hierarchy.Remove(hierarchy.IndexOf(" - "), 3) : hierarchy;
                hierarchy = "";// hierarchy + " - ";
            }
            agentLevel += 1;

            if (isTableOpen) Response.Write("</table>");

            isTableOpen = true;

            if (isDistributor)
            {
                sb.Append("<br><table style='width: 100%;' cellspacing='0' cellpadding='3' border='0' class='filter table-bordered' align='center'><tr class='page-titles'><td colspan='15'><h4><span class='Hierarchy'>" + hierarchy + "</span>" + agent + "</h4></td></tr>");
                DataRow[] subAgents = agentTotals.Select("Distributor = " + idAgent.ToString());
                foreach (DataRow subAgent in subAgents)
                {
                    RenderAgent(sb, subAgent);
                }

            }
            else
            {
                sb.Append("<div class='table-responsive'><table class='table-dynamic table table-bordered table-striped'><thead><tr class='table-title'><th colspan='13'><span class='Hierarchy'>" + hierarchy + "</span>" + agent + "</th></tr>");
                sb.Append("<tr><th >Player</th><th style='text-align:center;'>Bal Fwd</th><th style='text-align:center;'>Mon</th><th style='text-align:center;'>Tue</th><th style='text-align:center;'>Wed</th><th style='text-align:center;'>Thu</th><th style='text-align:center;'>Fri</th><th style='text-align:center;'>Sat</th><th style='text-align:center;'>Sun</th><th style='text-align:center;'>This Week</th><th class='desktopOnly' style='text-align:center;'>Pend</th><th style='text-align:center;'>Pmts</th><th style='text-align:center;'>Bal</th></tr></thead>");
                DataRow[] players = weeklyBalance.Select("idAgent = " + idAgent.ToString());
                foreach (DataRow player in players)
                {
                    sb.Append(playersRows(player));
                }
                sb.Append("<tr class='wb_totalsubagent bold' ><td>Total</td>" + totalRows(agentRow) + "</tr><tr class='bold'><td colspan='13' align='center'>" + agent + " Players Total: " + agentRow["CntActive"].ToString() + " of <span class='inactivePlayers'>" + agentLabels[0]["totalPLayers"].ToString() + "</span></td></tr>");

            }

            string strtotalRows2 = totalRows(agentRow);

            if (Convert.ToInt32(Session["SubIdAgent"]) == idAgent)
            {
                sb.Append("</table><br /><div class='table-responsive'><TABLE class='table-dynamic table table-bordered table-striped'><thead><tr class='table-title'><th colspan='15'>" + agent + "</th></tr><tr><th width='10%'>Player</th><th style=text-align:center; width='10%'>Bal Fwd</th><th style=text-align:center;>Mon</th><th style=text-align:center;>Tue</th><th style=text-align:center;>Wed</th><th style=text-align:center;>Thu</th><th style=text-align:center;>Fri</th><th style=text-align:center;>Sat</th><th style=text-align:center;>Sun</th><th style=text-align:center;>This Week</th><th class='desktopOnly' style=text-align:center; width='10%'>Pend</th><th style=text-align:center;>Pmts</th><th style=text-align:center;>Bal</th></tr></thead><tbody><tr class='wb_grandtotal bold' ><td class='playerName white-space:nowrap;'>Grand Total</td>" + strtotalRows2 + "</tr><tr class='bold'><td colspan='15' align='center'>Grand Total of Active Player: " + agentRow["CntActive"].ToString() + " / Players With No Action:  " + agentLabels[0]["inactivePlayers"].ToString() + "</td></tr></tbody></TABLE></div>");

            }
            else if (isDistributor)
            {
                //agentRow["CntActive"].ToString() + " / " + agentRow["CntInactive"].ToString() +
                if (!isTableOpen) sb.Append("<div class='table-responsive'><table class='table color-table success-table table-bordered table-striped table-sm'>");
                sb.Append("<tr class='bold'><td class='no-center' style='font-weight:bold;'>Total <br/>" + agent + "</td>" + strtotalRows2 + "</tr><tr class='bold'><td colspan='15' align='center'><span style='font-weight:bold;'>" + agent + "</span> Players Total: " + agentRow["CntActive"].ToString() + " of <span class='inactivePlayers'>" + agentLabels[0]["totalPLayers"].ToString() + "</span></td></tr>"); //</table></div><br />

                //sb.Append("</table>");

            }

        }




        protected string playersRows(DataRow linea)
        {
            StringBuilder sb = new StringBuilder();

            DateTime prmDateWeek = Convert.ToDateTime(txtDate.Text);
            string account = linea["Player"].ToString();
            string[] accountArray = account.Split('/');


            string player = accountArray[0] + "<br><span class='wb_passowrd'>" + accountArray[1] + "</span>";
            string idPlayer = linea["idPlayer"].ToString();

            //string date = prmDateWeek.ToString("MM") + "//" + prmDateWeek.ToString("dd") + "//" + prmDateWeek.ToString("yyyy");

            decimal day1 = Convert.ToDecimal(linea["Day1"]);
            decimal day2 = Convert.ToDecimal(linea["Day2"]);
            decimal day3 = Convert.ToDecimal(linea["Day3"]);
            decimal day4 = Convert.ToDecimal(linea["Day4"]);
            decimal day5 = Convert.ToDecimal(linea["Day5"]);
            decimal day6 = Convert.ToDecimal(linea["Day6"]);
            decimal day7 = Convert.ToDecimal(linea["Day7"]);
            decimal cntDay1 = Convert.ToDecimal(linea["CntDay1"]);
            decimal cntDay2 = Convert.ToDecimal(linea["CntDay2"]);
            decimal cntDay3 = Convert.ToDecimal(linea["CntDay3"]);
            decimal cntDay4 = Convert.ToDecimal(linea["CntDay4"]);
            decimal cntDay5 = Convert.ToDecimal(linea["CntDay5"]);
            decimal cntDay6 = Convert.ToDecimal(linea["CntDay6"]);
            decimal cntDay7 = Convert.ToDecimal(linea["CntDay7"]);
            decimal ptms = Convert.ToDecimal(linea["Pmts"]);
            decimal balFwd = Convert.ToDecimal(linea["BalFwd"]);
            decimal amountAtRisk = Convert.ToDecimal(linea["AmountAtRisk"]);
            decimal settledFigure = Convert.ToDecimal(linea["SettledFigure"].ToString());
            decimal thisWeek = Convert.ToDecimal(linea["ThisWeek"]);
            decimal balance = Convert.ToDecimal(linea["CurrentBalance"]);

            int adjustments = Convert.ToInt32(linea["adjs"]);
            int wagerDelete = Convert.ToInt32(linea["WagerDelete"].ToString());

            string trClass = adjustments > 0 ? " adjustments" : "";
            trClass += wagerDelete > 0 ? " wagerDelete" : "";

            DateTime lw;
            bool parseSuccess = DateTime.TryParse(linea["LastWager"].ToString(), out lw);
            string lastWager = parseSuccess ? lw.ToString("MM/dd/yyyy") : "";

            settledFigure = balance > settledFigure ? balance : 0;

            decimal[] days = { day1, day2, day3, day4, day5, day6, day7 };
            decimal[] cntDays = { cntDay1, cntDay2, cntDay3, cntDay4, cntDay5, cntDay6, cntDay7 };

            sb.AppendLine("<tr class='" + trClass + "'>");
            sb.AppendLine("<td class='playerName'><a class='editUser' href=\"PlayerEditEnhanced.aspx?player=" + idPlayer + "&source=wb\" >" + player + "</a></td>");
            sb.AppendLine("<td class='bow" + (balFwd < 0 ? " neg" : (balFwd > 0 ? " pos" : "")) + "' align='center'>" + balFwd.ToString("N0") + "</td>");

            for (int i = 0; i < days.Length; i++)
            {
                string classAttribute = days[i] < 0 ? "neg" : (days[i] > 0 ? "pos" : "");
                string dayValue;

                if (days[i] == 0 && cntDays[i] == 0)
                {
                    dayValue = days[i].ToString("N0");
                }
                else
                {
                    dayValue = "<a href='javascript:GetPlayerHistory(" + idPlayer + ",\"" + txtDate.Text + "\"," + (i + 1) + ");'>" + days[i].ToString("N0") + "</a>";
                }

                sb.AppendLine("<td class='weekDay " + classAttribute + "' align='center'>" + dayValue + "</td>");
            }

            sb.AppendLine("<td align='center' class='bow ThisWeek" + (thisWeek < 0 ? " neg" : (thisWeek > 0 ? " pos" : "")) + "'>" + (thisWeek == 0 ? thisWeek.ToString("N0") : "<a href='javascript:GetPlayerWeekHistoryV2(" + idPlayer + ",\"" + txtDate.Text + "\",1);'>" + thisWeek.ToString("N0") + "</a>") + "</td>");
            sb.AppendLine("<td align='center' class='desktopOnly" + (amountAtRisk < 0 ? " neg" : (amountAtRisk > 0 ? " pos" : "")) + "'>" + (amountAtRisk == 0 ? amountAtRisk.ToString("N0") : "<a href='javascript:GetOpenBets(" + idPlayer + ");'>" + amountAtRisk.ToString("N0") + "</a>") + "</td>");
            sb.AppendLine("<td align='center' class='weekDay" + (ptms < 0 ? " neg" : (ptms > 0 ? " pos" : "")) + "'>" + "<a href='javascript:GetPlayerPayment(" + idPlayer + ");'>" + ptms.ToString("N0") + "</a></td>");
            sb.AppendLine("<td align='center' class='bow" + (balance < 0 ? " neg" : (balance > 0 ? " pos" : "")) + "'>" + balance.ToString("N0") + "</td>");

            sb.AppendLine("</tr>");

            return sb.ToString();
        }



        protected string totalRows(DataRow linea)
        {
            StringBuilder sb = new StringBuilder();

            decimal day1 = 0;
            decimal day2 = 0;
            decimal day3 = 0;
            decimal day4 = 0;
            decimal day5 = 0;
            decimal day6 = 0;
            decimal day7 = 0;
            decimal cntDay1 = 0;
            decimal cntDay2 = 0;
            decimal cntDay3 = 0;
            decimal cntDay4 = 0;
            decimal cntDay5 = 0;
            decimal cntDay6 = 0;
            decimal cntDay7 = 0;
            decimal pending = 0;
            decimal ptms = 0;
            decimal balFwd = 0;
            decimal settledFigure = 0;
            decimal thisWeek = 0;
            decimal currentBalance = 0;
            decimal AmountAtRisk = 0;

            try
            {
                day1 = Convert.ToDecimal(linea["Day1"]);
                day2 = Convert.ToDecimal(linea["Day2"]);
                day3 = Convert.ToDecimal(linea["Day3"]);
                day4 = Convert.ToDecimal(linea["Day4"]);
                day5 = Convert.ToDecimal(linea["Day5"]);
                day6 = Convert.ToDecimal(linea["Day6"]);
                day7 = Convert.ToDecimal(linea["Day7"]);

                cntDay1 = Convert.ToDecimal(linea["CntDay1"]);
                cntDay2 = Convert.ToDecimal(linea["CntDay2"]);
                cntDay3 = Convert.ToDecimal(linea["CntDay3"]);
                cntDay4 = Convert.ToDecimal(linea["CntDay4"]);
                cntDay5 = Convert.ToDecimal(linea["CntDay5"]);
                cntDay6 = Convert.ToDecimal(linea["CntDay6"]);
                cntDay7 = Convert.ToDecimal(linea["CntDay7"]);

                thisWeek = Convert.ToDecimal(linea["thisWeek"]);
                currentBalance = Convert.ToDecimal(linea["CurrentBalance"]);
                AmountAtRisk = Convert.ToDecimal(linea["AmountAtRisk"]);


                pending = Convert.ToDecimal(linea["AmountAtRisk"]);
                ptms = Convert.ToDecimal(linea["Pmts"]);
                balFwd = Convert.ToDecimal(linea["BalFwd"]);
                settledFigure = Convert.ToDecimal(linea["SettledFigure"].ToString());

            }
            catch { }

            sb.AppendLine("<td class='bow' align='center'>" + balFwd.ToString("N0") + "</td>");

            decimal[] days = { day1, day2, day3, day4, day5, day6, day7 };
            decimal[] cntDays = { cntDay1, cntDay2, cntDay3, cntDay4, cntDay5, cntDay6, cntDay7 };

            for (int i = 0; i < days.Length; i++)
            {
                sb.AppendLine(string.Format("<td align='center' class='weekDay {0}'>{1}</td>", AddOnWebClient.Common.DetermineClass(days[i]), days[i].ToString("N0")));
            }

            sb.AppendLine(string.Format("<td align='center' class='bow ThisWeek {0}'>{1}</td>", AddOnWebClient.Common.DetermineClass(thisWeek), thisWeek.ToString("N0")));
            sb.AppendLine("<td class='weekDay desktopOnly' align='center'>" + pending.ToString("N0") + "</td>");
            sb.AppendLine("<td class='weekDay' align='center'>" + ptms.ToString("N0") + "</td>");
            sb.AppendLine(string.Format("<td align='center' class='weekDay {0}'>{1}</td>", AddOnWebClient.Common.DetermineClass(currentBalance), currentBalance.ToString("N0")));
            sb.AppendLine("</tr><tr>");

            // For count players
            sb.AppendLine("<td class='bow' align='center'></td>");
            sb.AppendLine("<td class='bow' align='center'></td>");

            for (int i = 0; i < cntDays.Length; i++)
            {
                sb.AppendLine(string.Format("<td align='center' class='weekDay {0}'>{1}</td>", "cnt", cntDays[i].ToString("N0")));
            }

            sb.AppendLine("<td align='center' class='bow ThisWeek'></td>");
            sb.AppendLine("<td class='weekDay desktopOnly' align='center'></td>");
            sb.AppendLine("<td class='weekDay' align='center'></td>");
            sb.AppendLine("<td align='center' class='weekDay'></td>");

            return sb.ToString();
        }


        #region SQLCalls

        protected DataTable AddOn_Web_Report_Weekly_Balance_V8_Totals(int prmIdAgent)
        {
            DataTable table = new DataTable();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            DateTime prmDateWeek = Convert.ToDateTime(txtDate.Text).Date;
            int prmTranType = Convert.ToInt32(ddlTransactionType.SelectedValue);
            int prmDisplayOptions = Convert.ToInt32(ddlDisplayOptions.SelectedValue);


            if (prmDisplayOptions == 2)
            {
                prmDisplayOptions = 7;
            }

            string key = prmDateWeek + "," + prmIdAgent + "," + prmTranType + "," + prmDisplayOptions + ",AddOn_Web_Report_Weekly_Balance_V8_Totals";

            DateTime firstDayOfWeek = Convert.ToDateTime(AddOnWebClient.Common.fromOrTo(true).ToString("MM/dd/yyyy"));
            if (prmDateWeek < firstDayOfWeek && Session[key] != null)
            {
                return (DataTable)Session[key];
                //Response.Write("FROM CACHE");
            }

            using (SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                Cnn.Open();
                try
                {
                    using (SqlCommand comm = new SqlCommand("AddOn_Web_Report_Weekly_Balance_V8_Totals", Cnn))
                    {
                        comm.CommandTimeout = 120;
                        comm.CommandType = CommandType.StoredProcedure;

                        comm.Parameters.AddWithValue("@prmDateWeek", prmDateWeek);
                        comm.Parameters.AddWithValue("@prmIdAgent", prmIdAgent);
                        comm.Parameters.AddWithValue("@prmTranType", prmTranType);
                        comm.Parameters.AddWithValue("@prmDisplayOptions", prmDisplayOptions);

                        using (SqlDataReader readerAgent = comm.ExecuteReader())
                        {
                            table.Load(readerAgent);
                        }

                        if (!AddOnWebClient.Common.IsDateInThisWeek(prmDateWeek))
                        {
                            Session[key] = table;
                        }
                    }
                }
                catch (Exception ex)
                {
                    string Error = ex.Message;
                }
            }
            return table;
        }


        protected DataTable AddOn_Web_Report_Weekly_Balance_V8(int prmIdAgent)
        {
            DataTable table = new DataTable();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            DateTime prmDateWeek = Convert.ToDateTime(txtDate.Text).Date;
            int prmTranType = Convert.ToInt32(ddlTransactionType.SelectedValue);
            int prmDisplayOptions = Convert.ToInt32(ddlDisplayOptions.SelectedValue);
            if (prmDisplayOptions == 2)
            {
                prmDisplayOptions = 7;
            }

            string key = prmDateWeek + "," + prmIdAgent + "," + prmTranType + "," + prmDisplayOptions + ",AddOn_Web_Report_Weekly_Balance_V8";

            DateTime firstDayOfWeek = Convert.ToDateTime(AddOnWebClient.Common.fromOrTo(true).ToString("MM/dd/yyyy"));
            if (prmDateWeek < firstDayOfWeek && Session[key] != null)
            {
                //return (DataTable)Session[key];
                //Response.Write("FROM CACHE");
            }

            using (SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                try
                {
                    Cnn.Open();
                    using (SqlCommand comm = new SqlCommand("AddOn_Web_Report_Weekly_Balance_V8", Cnn))
                    {
                        comm.CommandTimeout = 120;
                        comm.CommandType = CommandType.StoredProcedure;

                        comm.Parameters.AddWithValue("@prmDateWeek", prmDateWeek);
                        comm.Parameters.AddWithValue("@prmIdAgent", prmIdAgent);
                        comm.Parameters.AddWithValue("@prmTranType", prmTranType);
                        comm.Parameters.AddWithValue("@prmDisplayOptions", prmDisplayOptions);

                        using (SqlDataReader readerAgent = comm.ExecuteReader())
                        {
                            table.Load(readerAgent);
                        }
                    }
                    if (prmDateWeek < firstDayOfWeek)
                    {
                        Session[key] = table;
                    }
                }
                catch (Exception ex)
                {
                    string Error = ex.Message;
                }
            }

            return table;
        }

        protected DataTable AddOn_Web_Report_Weekly_Balance_V8_Labels(int prmIdAgent)
        {
            DataTable table = new DataTable();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            DateTime prmDateWeek = Convert.ToDateTime(txtDate.Text).Date;
            int prmTranType = Convert.ToInt32(ddlTransactionType.SelectedValue);
            int prmDisplayOptions = Convert.ToInt32(ddlDisplayOptions.SelectedValue);

            string key = prmDateWeek + "," + prmIdAgent + "," + prmTranType + "," + prmDisplayOptions + ",AddOn_Web_Report_Weekly_Balance_V8_Labels";

            DateTime firstDayOfWeek = Convert.ToDateTime(AddOnWebClient.Common.fromOrTo(true).ToString("MM/dd/yyyy"));
            if (prmDateWeek < firstDayOfWeek && Session[key] != null)
            {
                //return (DataTable)Session[key];
                //Response.Write("FROM CACHE");
            }

            using (SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                try
                {
                    Cnn.Open();
                    using (SqlCommand comm = new SqlCommand("AddOn_Web_Report_Weekly_Balance_V8_Labels", Cnn))
                    {
                        comm.CommandTimeout = 120;
                        comm.CommandType = CommandType.StoredProcedure;

                        comm.Parameters.AddWithValue("@prmDateWeek", prmDateWeek);
                        comm.Parameters.AddWithValue("@prmIdAgent", prmIdAgent);
                        comm.Parameters.AddWithValue("@prmTranType", prmTranType);
                        comm.Parameters.AddWithValue("@prmDisplayOptions", prmDisplayOptions);

                        using (SqlDataReader readerAgent = comm.ExecuteReader())
                        {
                            table.Load(readerAgent);
                        }
                    }
                    if (prmDateWeek < firstDayOfWeek)
                    {
                        Session[key] = table;
                    }
                }
                catch (Exception ex)
                {
                    string Error = ex.Message;
                }
            }

            return table;
        }


        protected string GetWeekHeader()
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            string datestr = "";
            try
            {

                DateTime prmDateWeek = Convert.ToDateTime(txtDate.Text);

                string key = prmDateWeek + ",WebGetWeeklyHeaders";

                if (Session[key] != null)
                {
                    table = (DataTable)Session[key];
                }
                else
                {
                    SqlCommand comm = new SqlCommand("WebGetWeeklyHeaders", Cnn);

                    comm.CommandTimeout = 120;
                    comm.CommandType = CommandType.StoredProcedure;

                    ((SqlParameter)comm.Parameters.Add("@DateWeek", SqlDbType.DateTime)).Value = prmDateWeek;
                    SqlDataReader readerAgent;
                    readerAgent = comm.ExecuteReader();
                    table.Load(readerAgent);
                    Session[key] = table;
                }
                DataRow linea = table.Rows[0];
                linea = table.Rows[0];
                DateTime from = Convert.ToDateTime(linea["StartDate"]);
                DateTime to = Convert.ToDateTime(linea["EndDate"]);
                to = to.AddDays(-1);
                datestr = from.ToString("MM/dd/yyyy") + " - " + to.ToString("MM/dd/yyyy");
            }
            catch { }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return datestr;
        }



        #endregion


        #region common



        protected void changeDateText()
        {
            DayOfWeek Day = Convert.ToDateTime(txtDate.Text).DayOfWeek;
            int minusdays = 0;
            int plusdays = 0;
            switch (Day)
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

            DateTime FirtsDay = Convert.ToDateTime(txtDate.Text).AddDays(-minusdays);
            txtDate.Text = FirtsDay.ToString("MM/dd/yyyy");

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



        #endregion


        #region actions

        protected void Submit_Click(object sender, EventArgs e)
        {
            changeDateText();
            Session.Add("prmDateWeek", Convert.ToDateTime(txtDate.Text).Date);
            int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
            string prmAgent = this.Session["SubAgent"].ToString();
            weeklyBalance = AddOn_Web_Report_Weekly_Balance_V8(prmIdAgent);
            agentTotals = AddOn_Web_Report_Weekly_Balance_V8_Totals(prmIdAgent);
            labels = AddOn_Web_Report_Weekly_Balance_V8_Labels(prmIdAgent);

            RenderReport();
        }

        protected void lnkWeek_Click(object sender, EventArgs e)
        {
            LinkButton lnkButton = (LinkButton)sender;
            int weeksAgo = Convert.ToInt32(lnkButton.CommandArgument);
            changeDate(weeksAgo);
        }

        protected void ddlWeeks_Change(object sender, EventArgs e)
        {
            DateTime firstDayOfWeek = Convert.ToDateTime(AddOnWebClient.Common.fromOrTo(true).ToString("MM/dd/yyyy"));
            if (!String.IsNullOrEmpty(ddlWeeks.SelectedValue))
            {
                txtDate.Text = firstDayOfWeek.AddDays(-7 * Convert.ToInt32(ddlWeeks.SelectedValue)).ToString();
            }

            Submit_Click(sender, e);
        }


        #endregion


    }
}

