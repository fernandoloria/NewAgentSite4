using AgentSite4.cASEnums;
using DGSinterface;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Xml;
using System.Data.SqlClient;
using System.Data;
using System.Text.RegularExpressions;

namespace AgentSite4.Popup
{
    public partial class PlayerWeeklyProfitHistory : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Common.HasRights(ReportPosition.PLAYERHISTORY))
                this.LoadData();
            else
                this.Response.Redirect("../Logout.aspx");


        }

        private void LoadData()
        {
            AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
            CResultPlayerHistory cresultPlayerHistory = new CResultPlayerHistory();
            long prmIdPlayer = -1;
            int prmPage = 1;
            int prmRecPecPage = 2000;
            int prmHistWeek = int.Parse(ConfigurationManager.AppSettings["HistSpcWeek"].ToString());
            long prmIdAgent = long.Parse(this.Session["SubIdAgent"].ToString());
            string prmStartDate = "";
            string prmEndDate = "";
            short prmIdCurrency = short.Parse(this.Session["IdCurrency"].ToString());
            bool prmNormalOrder = bool.Parse(ConfigurationManager.AppSettings["PlayerHistoryNO"].ToString());
            string prmReportType = Request.QueryString["t"];

            prmIdPlayer = long.Parse(this.Request.QueryString["id"].ToString());
            prmStartDate = this.Request.QueryString["datefrom"].ToString();
            prmEndDate = this.Request.QueryString["dateto"].ToString();
            prmIdCurrency = 0;


            string prmNextQ = "&IdPlayer=" + (object)prmIdPlayer;
            AddOnWebClient.Agent a = new AddOnWebClient.Agent();

            CResultPlayerHistory reportPlayerHistory = GetReportPlayerHistory(prmIdAgent, prmIdPlayer, prmStartDate, prmEndDate, prmHistWeek, prmPage, prmRecPecPage, prmNextQ, prmIdCurrency, prmNormalOrder);

            if (reportPlayerHistory.ErrorCode == CErrorCode.ErrorNone)
            {
                string namespaceURI = "../App_Themes/Classic/";
                XmlDocument xmlDocument = new XmlDocument();
                xmlDocument.LoadXml(reportPlayerHistory.ToXml());
                xmlDocument.CreateElement("ThemePath", namespaceURI);
                XslCompiledTransform compiledTransform = new XslCompiledTransform();
                StringWriter stringWriter = new StringWriter();
                compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\Classic\\xsl\\WeeklyBalanceHistoryDay.xsl"));
                compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.Append(stringWriter.ToString());
                this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
            }
            else if (reportPlayerHistory.ErrorCode == CErrorCode.ErrorValidation)
                this.Response.Redirect("../Logout.aspx");
            else
                this.Response.Write(reportPlayerHistory.ErrorMsg);
            //this.Response.Redirect("~/Report/ErrorHandle.aspx");
        }


        private CResultPlayerHistory GetReportPlayerHistory(long prmIdAgent, long prmIdPlayer, string prmStartDate, string prmEndDate, int prmHistWeek, int prmPage, int prmRecPecPage, string prmNextQ, short prmIdCurrency, bool prmNormalOrder)
        {
            CResultPlayerHistory cresultPlayerHistory = new CResultPlayerHistory();
            int num1 = 0;
            double num2 = 0.0;
            Decimal num3 = new Decimal(1);
            string str1 = "";
            string str2 = "";
            List<CComboWeek> list1 = new List<CComboWeek>();
            List<CComboPlayer> list2 = new List<CComboPlayer>();
            List<CHistoryBet> list3 = new List<CHistoryBet>();
            List<CComboPageNum> list4 = new List<CComboPageNum>();
            List<CCurrencyCombo> list5 = new List<CCurrencyCombo>();
            try
            {

                cresultPlayerHistory.StartDate = prmStartDate;
                cresultPlayerHistory.EndDate = prmEndDate;

                cresultPlayerHistory.SpcWeek = prmHistWeek;
                int num4 = prmHistWeek;

                cresultPlayerHistory.ListWeeks = list1;
                string Selected1;
                if (prmIdPlayer == -2L)
                {
                    cresultPlayerHistory.OnlyPlayer = false;
                    Selected1 = "1";
                }
                else
                {
                    cresultPlayerHistory.OnlyPlayer = true;
                    Selected1 = "0";
                }
                list2.Add(new CComboPlayer("", "", "-2", Selected1));
                string Selected2;
                if (prmIdPlayer == -1L)
                {
                    cresultPlayerHistory.OnlyPlayer = false;
                    Selected2 = "1";
                }
                else
                {
                    cresultPlayerHistory.OnlyPlayer = true;
                    Selected2 = "0";
                }
                list2.Add(new CComboPlayer("", "All", "-1", Selected2));
                DataSet agentAllPlayers = GetAgentAllPlayers(prmIdAgent);
                for (int index = 0; index < agentAllPlayers.Tables[0].Rows.Count; ++index)
                {
                    DataRow dataRow = agentAllPlayers.Tables[0].Rows[index];
                    string Selected3 = prmIdPlayer != long.Parse(dataRow["IdPlayer"].ToString()) ? "0" : "1";
                    list2.Add(new CComboPlayer(dataRow["Agent"].ToString(), dataRow["Player"].ToString(), dataRow["IdPlayer"].ToString(), Selected3));
                }
                cresultPlayerHistory.ListPlayers = list2;
                DataSet currencyCombo = GetCurrencyCombo(int.Parse(prmIdAgent.ToString()), DateTime.Now.ToString());
                for (int index = 0; index < currencyCombo.Tables[0].Rows.Count; ++index)
                {
                    DataRow dataRow = currencyCombo.Tables[0].Rows[index];
                    bool AgentCurrency;
                    if ((int)short.Parse(dataRow["IdCurrency"].ToString()) == (int)prmIdCurrency)
                    {
                        num3 = Decimal.Parse(dataRow["LastMoneyChange"].ToString());
                        AgentCurrency = true;
                    }
                    else
                        AgentCurrency = false;
                    list5.Add(new CCurrencyCombo(short.Parse(dataRow["IdCurrency"].ToString()), dataRow["Currency"].ToString(), dataRow["Description"].ToString(), dataRow["Symbol"].ToString(), dataRow["LastMoneyChange"].ToString(), AgentCurrency));
                }
                cresultPlayerHistory.CurrencyCombo = list5;
                DataSet playerHistoryByPage = GetPlayerHistoryByPage(prmIdAgent, prmIdPlayer, prmStartDate, prmEndDate, prmPage, prmRecPecPage, prmNormalOrder);

                int num5;
                int num6 = num5 = playerHistoryByPage.Tables[0].Rows.Count;
                if (playerHistoryByPage.Tables[0].Rows.Count > 0)
                {
                    cresultPlayerHistory.GrandTotalAmount = playerHistoryByPage.Tables[0].Rows[0].ItemArray[34].ToString();
                    cresultPlayerHistory.GrandTotalTransacion = playerHistoryByPage.Tables[0].Rows[0].ItemArray[35].ToString();
                }
                int index1 = 0;
                while (index1 < playerHistoryByPage.Tables[0].Rows.Count)
                {

                    num1 = int.Parse(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[33].ToString());
                    string Agent = playerHistoryByPage.Tables[0].Rows[index1].ItemArray[1].ToString();
                    string Player = playerHistoryByPage.Tables[0].Rows[index1].ItemArray[2].ToString();
                    string Password = playerHistoryByPage.Tables[0].Rows[index1].ItemArray[3].ToString();
                    string Score;
                    string Text3;
                    string Text2 = "";
                    string input;
                    string Text7;
                    string Text8;
                    string str3;
                    string str4;
                    string Text1;
                    string Text5;
                    string TRisk;
                    string TWin;
                    lblHeader.Text = "PLAYER: " + Player + "<br/> WAGERS: " + Convert.ToDateTime(prmStartDate).ToString("MM/dd") + " - " + Convert.ToDateTime(prmEndDate).ToString("MM/dd");
                    if (playerHistoryByPage.Tables[0].Rows[index1].ItemArray[29].ToString() == "W")
                    {
                        Score = playerHistoryByPage.Tables[0].Rows[index1].ItemArray[15].ToString();
                        string str5 = playerHistoryByPage.Tables[0].Rows[index1].ItemArray[4].ToString();
                        str1 = playerHistoryByPage.Tables[0].Rows[index1].ItemArray[18].ToString();
                        if (playerHistoryByPage.Tables[0].Rows[index1].ItemArray[12].ToString() != "0" && playerHistoryByPage.Tables[0].Rows[index1].ItemArray[13].ToString() == "0")
                        {
                            str2 = "\n";
                            Text3 = "\n";
                        }
                        else
                        {
                            str2 = "";
                            Text3 = "";
                        }
                        Text8 = "Ticket #" + playerHistoryByPage.Tables[0].Rows[index1].ItemArray[15].ToString();
                        input = Regex.Replace(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[7].ToString(), "\n", "<BR>");
                        Text7 = GetWagerResult(int.Parse(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[11].ToString()));
                        Text8 += "<br/>" + playerHistoryByPage.Tables[0].Rows[index1].ItemArray[6].ToString(); //Placed Date
                        str3 = this.RoundWithDecimals(Decimal.Parse(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[19].ToString()) * num3 + Decimal.Parse(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[20].ToString()) * num3);
                        str4 = this.RoundWithDecimals(Decimal.Parse(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[20].ToString()) * num3);
                        Text1 = playerHistoryByPage.Tables[0].Rows[index1].ItemArray[17].ToString() + "<br/>" + (playerHistoryByPage.Tables[0].Rows[index1].ItemArray[5].ToString() == "-1" ? "" : playerHistoryByPage.Tables[0].Rows[index1].ItemArray[5].ToString());
                        Text5 = this.RoundWithDecimals(Decimal.Parse(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[8].ToString()) * num3) + "/" + this.RoundWithDecimals(Decimal.Parse(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[9].ToString()) * num3);
                        TRisk = this.RoundWithDecimals(Decimal.Parse(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[8].ToString()) * num3);
                        TWin = this.RoundWithDecimals(Decimal.Parse(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[9].ToString()) * num3);
                        bool flag = true;
                        while (flag)
                        {
                            flag = index1 < playerHistoryByPage.Tables[0].Rows.Count;
                            if (flag)
                                flag = str5 == playerHistoryByPage.Tables[0].Rows[index1].ItemArray[4].ToString();
                            if (flag)
                            {
                                if (playerHistoryByPage.Tables[0].Rows[index1].ItemArray[22].ToString() != "0")
                                {
                                    string str6 = playerHistoryByPage.Tables[0].Rows[index1].ItemArray[32] == DBNull.Value ? (playerHistoryByPage.Tables[0].Rows[index1].ItemArray[31] == DBNull.Value ? "" : (!(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[31].ToString() != "") ? "" : " (" + playerHistoryByPage.Tables[0].Rows[index1].ItemArray[31].ToString() + ")")) : (!(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[32].ToString() != "") ? "" : " (" + playerHistoryByPage.Tables[0].Rows[index1].ItemArray[32].ToString() + ")");
                                    Text2 = playerHistoryByPage.Tables[0].Rows[index1].ItemArray[25] == DBNull.Value ? Text2 + "<BR>" : Text2 + "<BR>" + playerHistoryByPage.Tables[0].Rows[index1].ItemArray[25].ToString();
                                    Text3 = Text3 + "<BR>" + playerHistoryByPage.Tables[0].Rows[index1].ItemArray[24].ToString();
                                    if (playerHistoryByPage.Tables[0].Rows[index1].ItemArray[30] != DBNull.Value)
                                    {
                                        if (playerHistoryByPage.Tables[0].Rows[index1].ItemArray[30].ToString() != "MATCH")
                                            input = input + "<BR>" + playerHistoryByPage.Tables[0].Rows[index1].ItemArray[30].ToString() + " " + playerHistoryByPage.Tables[0].Rows[index1].ItemArray[27].ToString() + str6;
                                        else if (playerHistoryByPage.Tables[0].Rows[index1].ItemArray[24].ToString().Trim() == "ESOC")
                                            input = input + "<BR>" + playerHistoryByPage.Tables[0].Rows[index1].ItemArray[30].ToString() + " " + playerHistoryByPage.Tables[0].Rows[index1].ItemArray[27].ToString() + str6;
                                    }
                                    else
                                        input = input + "<BR>" + playerHistoryByPage.Tables[0].Rows[index1].ItemArray[27].ToString() + str6;
                                    if (playerHistoryByPage.Tables[0].Rows[index1].ItemArray[24].ToString().Trim() != "RAC")
                                        Text7 = Text7 + "<BR>" + GetWagerResult(int.Parse(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[28].ToString()));
                                    if (playerHistoryByPage.Tables[0].Rows[index1].ItemArray[24].ToString() == "MLB" && playerHistoryByPage.Tables[0].Rows[index1].ItemArray[16].ToString() != "0")
                                    {
                                        Text2 += "<BR>";
                                        Text3 += "<BR>";
                                        Text7 += "<BR>";
                                    }
                                    if (playerHistoryByPage.Tables[0].Rows[index1].ItemArray[24].ToString() == "MLB" && playerHistoryByPage.Tables[0].Rows[index1].ItemArray[16].ToString() == "0")
                                        Text2 += "<BR>&nbsp;";
                                    if (playerHistoryByPage.Tables[0].Rows[index1].ItemArray[24].ToString() == "MLB" && playerHistoryByPage.Tables[0].Rows[index1].ItemArray[16].ToString() != "0")
                                    {
                                        Text2 += "<BR>";
                                        Text3 += "<BR>";
                                        Text7 += "<BR>";
                                    }
                                    if (playerHistoryByPage.Tables[0].Rows[index1].ItemArray[24].ToString() == "MLB" && playerHistoryByPage.Tables[0].Rows[index1].ItemArray[16].ToString() == "0")
                                        Text2 += "<BR>&nbsp;";
                                }
                                else
                                {
                                    Text2 += "<BR>";
                                    Text3 += "<BR>";
                                    input = input + "<BR>" + playerHistoryByPage.Tables[0].Rows[index1].ItemArray[27].ToString();
                                    Text7 += "<BR>";
                                }
                                ++index1;
                            }
                        }
                    }
                    else
                    {
                        Score = "";
                        string str5 = playerHistoryByPage.Tables[0].Rows[index1].ItemArray[18].ToString();
                        Text1 = "";
                        Text2 = playerHistoryByPage.Tables[0].Rows[index1].ItemArray[14].ToString();
                        Text3 = "";
                        input = Regex.Replace(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[7].ToString(), "\n", "<BR>");
                        Text5 = "";
                        TRisk = "0";
                        TWin = "0";
                        Text7 = "";
                        Text8 = playerHistoryByPage.Tables[0].Rows[index1].ItemArray[6].ToString();
                        str3 = this.RoundWithDecimals(Decimal.Parse(playerHistoryByPage.Tables[0].Rows[index1].ItemArray[19].ToString()) * num3);
                        str4 = playerHistoryByPage.Tables[0].Rows[index1].ItemArray[20].ToString();
                        switch (str5)
                        {
                            case "K":
                                Text3 = "CASINO";
                                break;
                            case "A":
                                Text3 = "ADJ";
                                break;
                            case "D":
                                Text3 = "DISB";
                                break;
                            case "H":
                                Text3 = "H ADJ";
                                break;
                            case "R":
                                Text3 = "RCPT";
                                break;
                            case "T":
                                Text3 = "XFER";
                                break;
                            case "P":
                                Text3 = "FREE";
                                break;
                        }
                        ++index1;
                    }
                    string TTaxAmount = !(str4 != "") ? "0" : NoDecimal(str4);
                    list3.Add(new CHistoryBet(Agent, Player, Password, Text1, Text2, Text3, Regex.Replace(input, "\x00BD", "&frac12;"), Text5, NoDecimal(str3), Text7, Text8, TRisk, TWin, TTaxAmount, Score));
                }
                cresultPlayerHistory.ListBets = list3;
                if (num6 > 0)
                {
                    if (prmPage == 1)
                    {
                        if (num1 == 0)
                        {
                            //cresultPlayerHistory.View = "Viewing 1-" + (object)num6 + " Of " + (string)(object)num6 + " ";
                            num5 = num6;
                        }
                        else
                        {
                            cresultPlayerHistory.View = "Viewing 1-" + (object)num6 + " Of " + (string)(object)(prmPage * prmRecPecPage + num1) + " ";
                            num5 = prmPage * prmRecPecPage + num1;
                        }
                    }
                    else
                    {
                        cresultPlayerHistory.View = "Viewing " + (object)((prmPage - 1) * prmRecPecPage + 1) + "-" + (string)(object)((prmPage - 1) * prmRecPecPage + num6) + " Of " + (string)(object)((prmPage - 1) * prmRecPecPage + num6 + num1) + " ";
                        num5 = (prmPage - 1) * prmRecPecPage + num6 + num1;
                    }
                    if (prmPage > 1)
                        cresultPlayerHistory.Prev = "Page=" + (object)(prmPage - 1) + prmNextQ;
                    if (num1 > 0)
                        cresultPlayerHistory.Next = "Page=" + (object)(prmPage + 1) + prmNextQ;
                }
                if (num5 > prmRecPecPage)
                {
                    int num7 = num5 / prmRecPecPage;
                    if (num7 % num5 != 0)
                        ++num7;
                    for (int index2 = 1; index2 <= num7; ++index2)
                    {
                        string Selected3 = prmPage != index2 ? "0" : "1";
                        list4.Add(new CComboPageNum("Page " + index2.ToString(), index2.ToString(), Selected3));
                    }
                    cresultPlayerHistory.ListPageNum = list4;
                }
            }
            catch (Exception ex)
            {
                cresultPlayerHistory.ErrorMsg = ex.ToString();
                cresultPlayerHistory.ErrorCode = CErrorCode.ErrorException;
                Logger.Log("Agent.GetReportPlayerHistory", ex.ToString());
            }
            finally
            {
            }
            return cresultPlayerHistory;
        }

        private string RoundWithDecimals(Decimal nVal)
        {
            //DBaccess dbaccess = new DBaccess();
            string str1 = "0";
            bool flag = false;
            try
            {
                // if (dbaccess.AgentUseDecimal())
                if (1 == 1)
                {
                    str1 = string.Format("{0:0.00}", (object)nVal);
                }
                else
                {
                    string str2 = nVal.ToString();
                    if (nVal < new Decimal(0))
                    {
                        flag = true;
                        nVal *= new Decimal(-1);
                    }
                    long num;
                    if (str2.IndexOf(".") != -1)
                    {
                        string[] strArray = nVal.ToString().Split(".".ToCharArray());
                        string str3 = strArray[0];
                        string str4 = strArray[1];
                        num = long.Parse(strArray[0]);
                    }
                    else
                        num = long.Parse(nVal.ToString());
                    str1 = flag ? (num * -1L).ToString() : num.ToString();
                }
            }
            catch (Exception ex)
            {
                Logger.Log("Agent.RoundWithDecimals", ex.ToString());
            }
            return str1;
        }

        public DataSet GetAgentAllPlayers(long prmIdAgent)
        {
            DataSet dataSet = (DataSet)null;
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection connection = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                SqlCommand selectCommand = new SqlCommand("Web_GetAgentAllPlayers", connection);
                selectCommand.CommandType = CommandType.StoredProcedure;
                selectCommand.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = (object)prmIdAgent;
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand);
                dataSet = new DataSet();
                sqlDataAdapter.Fill(dataSet, "DataSet");
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }
            return dataSet;
        }

        public DataSet GetCurrencyCombo(int prmIdAgent, string prmDate)
        {
            DataSet dataSet = (DataSet)null;
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection connection = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                SqlCommand selectCommand = new SqlCommand("Web_GetCurrencyCombo", connection);
                selectCommand.CommandType = CommandType.StoredProcedure;
                selectCommand.Parameters.Add("@prmIdAgent", SqlDbType.Int, 8).Value = (object)prmIdAgent;
                selectCommand.Parameters.Add("@prmDateTime", SqlDbType.VarChar, 30).Value = (object)prmDate;
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand);
                dataSet = new DataSet();
                sqlDataAdapter.Fill(dataSet, "DataSet");
            }
            catch (Exception ex)
            {
                Logger.Log("DBaccess.GetCurrencyCombo", ex.ToString());
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }
            return dataSet;
        }

        public DataSet playerWeeklyProfitHistory(long prmIdAgent, long prmIdPlayer, string prmStartDate, string prmEndDate, int prmPage, int prmRecsPerPage, bool prmNormalOrder)
        {
            DataSet dataSet = (DataSet)null;
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection connection = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                SqlCommand selectCommand = new SqlCommand("PlayerWeeklyProfitHistory", connection);
                selectCommand.CommandType = CommandType.StoredProcedure;
                selectCommand.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = (object)prmIdAgent;
                selectCommand.Parameters.Add("@prmIdPlayer", SqlDbType.Int).Value = (object)prmIdPlayer;
                selectCommand.Parameters.Add("@prmStartDate", SqlDbType.DateTime).Value = (object)DateTime.Parse(prmStartDate);
                selectCommand.Parameters.Add("@prmEndDate", SqlDbType.DateTime).Value = (object)DateTime.Parse(prmEndDate);
                selectCommand.Parameters.Add("@prmPage", SqlDbType.Int).Value = (object)prmPage;
                selectCommand.Parameters.Add("@prmRecsPerPage", SqlDbType.Int).Value = (object)prmRecsPerPage;
                selectCommand.Parameters.Add("@prmNormalOrder", SqlDbType.Bit).Value = (object)prmNormalOrder;
                //selectCommand.Parameters.Add("@prmTranType", SqlDbType.Int).Value = 9;
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand);
                dataSet = new DataSet();
                sqlDataAdapter.Fill(dataSet, "DataSet");
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }
            return dataSet;
        }


        public DataSet GetPlayerHistoryByPage(long prmIdAgent, long prmIdPlayer, string prmStartDate, string prmEndDate, int prmPage, int prmRecsPerPage, bool prmNormalOrder)
        {
            DataSet dataSet = (DataSet)null;
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection connection = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                SqlCommand comm = new SqlCommand("AddOn_Web_Report_Agent_History_BYPage", connection);

                comm.CommandTimeout = 120;
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = prmIdPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmStartDate", SqlDbType.VarChar)).Value = prmStartDate;
                ((SqlParameter)comm.Parameters.Add("@prmEndDate", SqlDbType.VarChar)).Value = prmEndDate;
                ((SqlParameter)comm.Parameters.Add("@prmTranType", SqlDbType.Int)).Value = 9;
                ((SqlParameter)comm.Parameters.Add("@prmPage", SqlDbType.Int)).Value = 1;
                ((SqlParameter)comm.Parameters.Add("@prmRecsPerPage", SqlDbType.Int)).Value = prmRecsPerPage;
                ((SqlParameter)comm.Parameters.Add("@prmNormalOrder", SqlDbType.Int)).Value = 1;

                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(comm);
                dataSet = new DataSet();
                sqlDataAdapter.Fill(dataSet, "DataSet");
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }
            return dataSet;
        }

        public string GetWagerResult(int prmResult)
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

        public string NoDecimal(string str)
        {
            string str1 = "";
            if (str != "")
                str1 = string.Format("{0:0}", (object)Decimal.Round(Decimal.Parse(str), 0));
            return str1;
        }
    }

}

