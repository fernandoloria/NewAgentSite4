using AgentSite4.ASP;
using AgentSite4.cASEnums;
using DGSinterface;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Xml;
using System.Data.SqlClient;
using System.Data;

namespace AgentSite4.AgentLines
{
    public partial class AgentLineMover : BasePage, IRequiresSessionState
    {
        protected PlaceHolder ReportHolder;

        protected DefaultProfile Profile
        {
            get
            {
                return (DefaultProfile)this.Context.Profile;
            }
        }

        protected global_asax ApplicationInstance
        {
            get
            {
                return (global_asax)this.Context.ApplicationInstance;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
            if (this.IsPostBack)
                this.CheckInfo(agentInstance);
            this.LoadData(agentInstance);
        }

        private void LoadData(IAgent oAgent)
        {
            if (Common.HasRights(ReportPosition.MOVELINES))
            {
                CResultAgentScheduleLines agentScheduleLines1 = new CResultAgentScheduleLines();
                int prmIdLeague = GetIdLeague("NFL"); ;
                int prmOrdeBy = 2;
                int prmIdEvent = -1;
                string prmIdSport = "NFL";
                string prmDisplayPeriod = "";
                int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                int prmIdLinetype = int.Parse(this.Session["AgentIdLineType"].ToString());
                if (this.Request.QueryString["RS"] != null)
                    this.ResetLine(this.Request.QueryString["RS"].ToString(), oAgent, prmIdAgent);
                if (this.Request.QueryString["Sport"] != null)
                    prmIdSport = this.Request.QueryString["Sport"].ToString();
                if (this.Request.QueryString["Event"] != null)
                    prmIdEvent = int.Parse(this.Request.QueryString["Event"].ToString());
                if (this.Request.QueryString["League"] != null)
                    prmIdLeague = int.Parse(this.Request.QueryString["League"].ToString());
                else if (this.Request.Form["cmbSport"] != null)
                    prmIdSport = this.Request.Form["cmbSport"].ToString();
                if (this.Request.Form["cmbLeague"] != null)
                    prmIdLeague = int.Parse(this.Request.Form["cmbLeague"].ToString());
                if (this.Request.Form["cmbPeriod"] != null)
                    prmDisplayPeriod = this.Request.Form["cmbPeriod"].ToString();
                if (this.Request.Form["cmbOrder"] != null)
                    prmOrdeBy = int.Parse(this.Request.Form["cmbOrder"].ToString());
                if (this.Request.Form["cmbEvent"] != null)
                    prmIdEvent = int.Parse(this.Request.Form["cmbEvent"].ToString());
                bool prmAmericanLine = this.Request.Form["cmbLine"] == null || !(prmIdSport == "ESOC") || bool.Parse(this.Request.Form["cmbLine"].ToString());
                CResultAgentScheduleLines agentScheduleLines2 = oAgent.GetReportAgentScheduleLines(prmIdAgent, prmIdLinetype, prmIdLeague, prmIdSport, prmOrdeBy, prmIdEvent, prmDisplayPeriod, prmAmericanLine);

                try
                {
                    agentScheduleLines2.ListLeague.RemoveAt(0);
                }
                catch { }
                if (agentScheduleLines2.ErrorCode == CErrorCode.ErrorNone)
                {
                    string str = "../App_Themes/" + this.Theme + "/";
                    XmlDocument xmlDocument = new XmlDocument();
                    xmlDocument.LoadXml(agentScheduleLines2.ToXml());
                    xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                    xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                    XslCompiledTransform compiledTransform = new XslCompiledTransform();
                    StringWriter stringWriter = new StringWriter();
                    compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\AgentLineMover.xsl"));
                    compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                    StringBuilder stringBuilder = new StringBuilder();
                    stringBuilder.Append(stringWriter.ToString());
                    this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                }
                else if (agentScheduleLines2.ErrorCode == CErrorCode.ErrorValidation)
                    this.Response.Redirect("../Logout.aspx");
                else
                    this.Response.Redirect("ErrorHandle.aspx");
            }
            else
                this.Response.Redirect("../Logout.aspx");
        }

        protected string GetAgentName()
        {
            //int SubIdAgent = Convert.ToInt32(Session["SubIdAgent"].ToString());
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            SqlCommand comm = new SqlCommand("Select agent from Agent where idAgent = @prmSubIdAgent", Cnn);
            comm.CommandType = CommandType.Text;
            ((SqlParameter)comm.Parameters.Add("@prmSubIdAgent", SqlDbType.Int)).Value = Session["SubIdAgent"].ToString();
            SqlDataReader readerAgent;
            readerAgent = comm.ExecuteReader();
            table.Load(readerAgent);
            if (Cnn.State == ConnectionState.Open) Cnn.Close();

            if (table.Rows.Count > 0)
            {
                return table.Rows[0]["Agent"].ToString();
            }
            return "";

        }

        protected int GetIdLeague(string IdSport)
        {
            //int SubIdAgent = Convert.ToInt32(Session["SubIdAgent"].ToString());
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            SqlCommand comm = new SqlCommand("GetAvailableLeagues", Cnn);
            comm.CommandType = CommandType.StoredProcedure;
            ((SqlParameter)comm.Parameters.Add("@prmIdSport", SqlDbType.VarChar)).Value = IdSport;
            ((SqlParameter)comm.Parameters.Add("@prmIdbook", SqlDbType.Int)).Value = 1;
            SqlDataReader readerAgent;
            readerAgent = comm.ExecuteReader();
            table.Load(readerAgent);
            if (Cnn.State == ConnectionState.Open) Cnn.Close();

            if (table.Rows.Count > 0)
            {
                return Convert.ToInt32(table.Rows[0]["IdLeague"].ToString());
            }
            return -1;

        }

        protected int GetIdLeague(string IdSport, int idLeague)
        {
            //int SubIdAgent = Convert.ToInt32(Session["SubIdAgent"].ToString());
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            SqlCommand comm = new SqlCommand("GetAvailableLeagues", Cnn);
            comm.CommandType = CommandType.StoredProcedure;
            ((SqlParameter)comm.Parameters.Add("@prmIdSport", SqlDbType.VarChar)).Value = IdSport;
            ((SqlParameter)comm.Parameters.Add("@prmIdbook", SqlDbType.Int)).Value = 1;
            SqlDataReader readerAgent;
            readerAgent = comm.ExecuteReader();
            table.Load(readerAgent);
            if (Cnn.State == ConnectionState.Open) Cnn.Close();
            foreach (DataRow linea in table.Rows)
            {
                if (Convert.ToInt32(linea["IdLeague"].ToString()) == idLeague)
                {
                    return idLeague;
                }
            }

            if (table.Rows.Count > 0)
            {
                return Convert.ToInt32(table.Rows[0]["IdLeague"].ToString());
            }
            return -1;

        }
        private void CheckInfo(IAgent oAgent)
        {
            string prmValues = "";
            string str1 = "";
            string str2 = "";
            int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
            string prmIdSport = "NFL";
            bool IsAmerican = true;
            try
            {
                if (this.Request.Form["cmbSport"] != null)
                    prmIdSport = this.Request.Form["cmbSport"].ToString();
                if (this.Request.Form["cmbLine"] != null)
                    IsAmerican = bool.Parse(this.Request.Form["cmbLine"].ToString());
                foreach (string key in this.Request.Form.Keys)
                {
                    if (key != null && key.Length > 4 && key.Substring(0, 4) == "txt_" && this.Request.Form[key] != null && this.Request.Form[key] != string.Empty)
                    {
                        if (this.Request.Form[key].ToString().Trim() == ConfigurationManager.AppSettings["NullValueOL"].ToString())
                        {
                            if (str1 != "")
                                str1 += ",";
                            str1 += this.ToOriginalLine(key, prmIdSport);
                        }
                        else
                        {
                            string str3 = !(prmIdSport == "ESOC") || IsAmerican ? this.EvaluateSelection(this.Request.Form[key] + "_" + key, IsAmerican, prmIdSport) : this.EvaluateSelection(this.ConvertDecimalToAmerican(this.Request.Form[key] + "_" + key), IsAmerican, prmIdSport);
                            if (str3 == "")
                            {
                                if (prmValues != "")
                                    prmValues += ",";
                                prmValues = !(prmIdSport == "ESOC") || IsAmerican ? prmValues + this.Request.Form[key] + "_" + key : prmValues + this.ConvertDecimalToAmerican(this.Request.Form[key] + "_" + key);
                            }
                            else
                            {
                                if (str2 != "")
                                    str2 += ", ";
                                str2 += str3;
                            }
                        }
                    }
                }
                if (this.Request.Form["TabChanged"] != null && this.Request.Form["TabChanged"] != "")
                {
                    if (prmValues != string.Empty)
                        prmValues += ",";
                    prmValues += this.Request.Form["TabChanged"].ToString();
                }
                if (str1 != string.Empty && prmValues != string.Empty)
                    prmValues = prmValues + "," + str1;
                else if (prmValues == "")
                    prmValues = str1;
                if (prmValues != string.Empty)
                    str2 = oAgent.UpdateLineValues(prmValues, prmIdAgent, this.Request.Form["cmbSport"].ToString(), int.Parse(this.Session["AgentIdLineType"].ToString()));
                if (!(str2 != string.Empty) && !(str2 != ""))
                    return;
                this.AlertErrorMsg(ConfigurationManager.AppSettings["ErrorMLV"].ToString() + ": " + str2 + ".");
            }
            catch (Exception ex)
            {
                Logger.Log("AgentMoveLines.CheckInfo", ex.Message.ToString());
            }
        }

        private string ToOriginalLine(string prmKey, string prmIdSport)
        {
            string str = "";
            try
            {
                string[] strArray = prmKey.Split("_".ToCharArray());
                switch (strArray.GetValue(1).ToString())
                {
                    case "vod":
                    case "hod":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_vod_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_hod_" + strArray.GetValue(2).ToString();
                        if (prmIdSport.Trim() == "SOC")
                        {
                            str = str + ",-1_" + strArray.GetValue(0).ToString() + "_vss_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_hss_" + strArray.GetValue(2).ToString();
                            break;
                        }
                        break;
                    case "tun":
                    case "tov":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_ood_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_uod_" + strArray.GetValue(2).ToString();
                        str = str + ",99999_" + strArray.GetValue(0).ToString() + "_tun_" + strArray.GetValue(2).ToString() + ",99999_" + strArray.GetValue(0).ToString() + "_tov_" + strArray.GetValue(2).ToString();
                        break;
                    case "ood":
                    case "uod":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_ood_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_uod_" + strArray.GetValue(2).ToString();
                        break;
                    case "vso":
                    case "hso":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_vso_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_hso_" + strArray.GetValue(2).ToString();
                        break;
                    case "vsp":
                    case "hsp":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_vso_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_hso_" + strArray.GetValue(2).ToString();
                        str = str + ",99999_" + strArray.GetValue(0).ToString() + "_vsp_" + strArray.GetValue(2).ToString() + ",99999_" + strArray.GetValue(0).ToString() + "_hsp_" + strArray.GetValue(2).ToString();
                        break;
                    case "vsl":
                    case "hsl":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_vss_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_hss_" + strArray.GetValue(2).ToString();
                        str = str + ",99999_" + strArray.GetValue(0).ToString() + "_vsl_" + strArray.GetValue(2).ToString() + ",99999_" + strArray.GetValue(0).ToString() + "_hsl_" + strArray.GetValue(2).ToString();
                        break;
                    case "vss":
                    case "hss":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_vss_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_hss_" + strArray.GetValue(2).ToString();
                        break;
                    case "odds":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_odds_" + strArray.GetValue(2).ToString() + "_" + strArray.GetValue(3).ToString() + "_" + strArray.GetValue(4).ToString();
                        break;
                }
            }
            catch
            {
            }
            return str;
        }

        private string EvaluateSelection(string prmSelection, bool IsAmerican, string prmIdSport)
        {
            string str = "";
            string[] strArray = prmSelection.Split("_".ToCharArray());
            try
            {
                switch (strArray.GetValue(2).ToString())
                {
                    case "vod":
                    case "hod":
                    case "ood":
                    case "uod":
                    case "vso":
                    case "hso":
                    case "vss":
                    case "hss":
                    case "odds":
                        str = this.ValidateOdds(prmSelection);
                        break;
                    case "tov":
                    case "tun":
                        str = this.ValidateOverUnder(prmSelection, IsAmerican, prmIdSport);
                        break;
                    case "vsp":
                    case "hsp":
                    case "vsl":
                    case "hsl":
                        str = this.ValidatePoints(prmSelection, IsAmerican, prmIdSport);
                        break;
                }
            }
            catch
            {
            }
            return str;
        }

        private string ValidateOverUnder(string prmOverUnder, bool IsAmerican, string IdSport)
        {
            string[] strArray1 = prmOverUnder.Split("_".ToCharArray());
            string str;
            try
            {
                Decimal num1 = Decimal.Parse(strArray1.GetValue(0).ToString());
                if (num1 < 0M)
                    str = num1.ToString();
                else if (strArray1.GetValue(0).ToString().IndexOf(".") != -1)
                {
                    if (IsAmerican)
                    {
                        string[] strArray2 = strArray1.GetValue(0).ToString().Split('.');
                        if (strArray2.Length > 1)
                        {
                            int num2 = int.Parse(strArray2[1]);
                            str = !(IdSport != "SOC") || num2 != 5 ? (num2 != 5 && num2 != 25 && num2 != 75 || !(IdSport == "SOC") ? num1.ToString() : "") : "";
                        }
                        else
                            str = "";
                    }
                    else
                        str = "";
                }
                else
                    str = "";
            }
            catch
            {
                str = strArray1.GetValue(0).ToString();
            }
            return str;
        }

        private string ValidateOdds(string prmOdds)
        {
            string[] strArray = prmOdds.Split("_".ToCharArray());
            string str;
            try
            {
                int num = int.Parse(strArray.GetValue(0).ToString());
                str = num <= -101 || num >= 100 ? "" : num.ToString();
            }
            catch
            {
                str = strArray.GetValue(0).ToString();
            }
            return str;
        }

        private string ValidatePoints(string prmPoints, bool IsAmerican, string IdSport)
        {
            string[] strArray1 = prmPoints.Split("_".ToCharArray());
            string str;
            try
            {
                Decimal num1 = Decimal.Parse(strArray1.GetValue(0).ToString());
                if (IsAmerican)
                {
                    string[] strArray2 = strArray1.GetValue(0).ToString().Split('.');
                    if (strArray2.Length > 1)
                    {
                        int num2 = int.Parse(strArray2[1]);
                        str = !(IdSport != "SOC") || num2 != 5 ? (num2 != 5 && num2 != 25 && num2 != 75 || !(IdSport == "SOC") ? num1.ToString() : "") : "";
                    }
                    else
                        str = "";
                }
                else
                    str = "";
            }
            catch
            {
                str = strArray1.GetValue(0).ToString();
            }
            return str;
        }

        private void AlertErrorMsg(string ErrorMsg)
        {
            // string script = "<script language='javascript'>window.alert('" + this.Context.Server.HtmlDecode(ErrorMsg) + "');</ script>";
            //this.Page.ClientScript.RegisterStartupScript(this.GetType(), "alertScript", script);
        }

        private string ConvertDecimalToAmerican(string prmValue)
        {
            string[] strArray = prmValue.Split("_".ToCharArray());
            Decimal num = 0M;
            try
            {
                Decimal d = Decimal.Parse(strArray.GetValue(0).ToString());
                num = !(d < 2M) ? Math.Round(Decimal.Subtract(d, 1) * 100M) : Math.Round(100M / Decimal.Subtract(d, 1)) * -1M;
            }
            catch
            {
            }
            return string.Format("{0:0}", (object)num) + "_" + strArray.GetValue(1).ToString() + "_" + strArray.GetValue(2).ToString() + "_" + strArray.GetValue(3).ToString() + "_" + strArray.GetValue(4).ToString();
        }

        private void ResetLine(string prmStr, IAgent oAgent, int prmIdAgent)
        {
            string[] strArray = prmStr.Split("_".ToCharArray());
            int prmTeamNumber = -1;
            try
            {
                int prmIdGame = int.Parse(strArray.GetValue(0).ToString());
                string prmIdSport = strArray.GetValue(1).ToString();
                if (strArray.GetValue(1).ToString() == "PROP")
                    prmTeamNumber = int.Parse(strArray.GetValue(2).ToString());
                if (!oAgent.GetReportAgentLineReset(prmIdGame, prmIdSport, prmTeamNumber, prmIdAgent))
                    this.AlertErrorMsg(ConfigurationManager.AppSettings["NoResetLine"].ToString());
                else
                    this.Response.Redirect("AgentLineMover.aspx?Sport=" + prmIdSport);
            }
            catch
            {
            }
        }

    }

}