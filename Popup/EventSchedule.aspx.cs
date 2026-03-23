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
using AgentSite4.ASP;
using System.Web.Profile;
using System.Web.SessionState;

namespace AgentSite4.Popup
{
    public partial class EventSchedule : BasePage, IRequiresSessionState
    {
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
            System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo(Session["CultureInfo"].ToString());
            System.Threading.Thread.CurrentThread.CurrentCulture = ci;
            System.Threading.Thread.CurrentThread.CurrentUICulture = ci;
            int prmIdGame = -1;
            string prmIdSport = "NFL";
            bool prmAmerincanLine = true;
            int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
            int prmIdLineType = int.Parse(this.Session["AgentIdLineType"].ToString());
            if (this.Request.QueryString["RS"] != null)
                this.ResetLine(this.Request.QueryString["RS"].ToString(), oAgent, prmIdAgent);
            if (this.Request.QueryString["INIT"] != null)
            {
                string[] strArray = this.Request.QueryString["INIT"].ToString().Split("_".ToCharArray());
                prmIdSport = strArray.GetValue(1).ToString();
                prmIdGame = int.Parse(strArray.GetValue(0).ToString());
            }
            try
            {
                CResultGetGameEvents cresultGetGameEvents = new CResultGetGameEvents();
                CResultGetGameEvents gameEvent = oAgent.GetGameEvent(prmIdAgent, prmIdGame, prmIdSport, prmIdLineType, prmAmerincanLine);
                if (gameEvent.ErrorCode == CErrorCode.ErrorNone)
                {
                    string str = "../App_Themes/" + this.Theme + "/";
                    XmlDocument xmlDocument = new XmlDocument();
                    xmlDocument.LoadXml(gameEvent.ToXml());
                    xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                    xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                    XslCompiledTransform compiledTransform = new XslCompiledTransform();
                    StringWriter stringWriter = new StringWriter();
                    compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\EventSchedule.xsl"));
                    compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                    StringBuilder stringBuilder = new StringBuilder();
                    stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                    stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                    this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                }
                else if (gameEvent.ErrorCode == CErrorCode.ErrorValidation)
                    this.Response.Redirect("../Logout.aspx");
                else
                    this.Response.Redirect("../Report/ErrorHandle.aspx");
            }
            catch (Exception ex)
            {
                this.Response.Redirect("../Report/ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
        }

        private void CheckInfo(IAgent oAgent)
        {
            string prmValues = "";
            string str1 = "";
            string str2 = "";
            int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
            bool IsAmerican = true;
            try
            {
                if (this.Request.Form["cmbLine"] != null)
                    IsAmerican = bool.Parse(this.Request.Form["cmbLine"].ToString());
                foreach (string key in this.Request.Form.Keys)
                {
                    if (key != null && key.Length > 4 && (key.Substring(0, 4) == "txt_" && this.Request.Form[key] != null) && this.Request.Form[key] != string.Empty)
                    {
                        if (this.Request.Form[key].ToString().Trim() == ConfigurationManager.AppSettings["NullValueOL"].ToString())
                        {
                            string[] strArray = key.Split("_".ToCharArray());
                            string prmIdSport = strArray.GetValue(strArray.Length - 1).ToString();
                            if (str1 != "")
                                str1 += ",";
                            str1 += this.ToOriginalLine(key, prmIdSport);
                        }
                        else
                        {
                            string[] strArray = key.Split("_".ToCharArray());
                            string prmIdSport = strArray.GetValue(strArray.Length - 1).ToString();
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
                    str2 = oAgent.UpdateEventLineValues(prmValues, prmIdAgent, int.Parse(this.Session["AgentIdLineType"].ToString()));
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
                        str = "-1_" + strArray.GetValue(0).ToString() + "_vod_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_hod_" + strArray.GetValue(2).ToString() + "_" + prmIdSport;
                        break;
                    case "tun":
                    case "tov":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_ood_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_uod_" + strArray.GetValue(2).ToString() + "_" + prmIdSport;
                        str = str + ",99999_" + strArray.GetValue(0).ToString() + "_tun_" + strArray.GetValue(2).ToString() + ",99999_" + strArray.GetValue(0).ToString() + "_tov_" + strArray.GetValue(2).ToString() + "_" + prmIdSport;
                        break;
                    case "ood":
                    case "uod":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_ood_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_uod_" + strArray.GetValue(2).ToString() + "_" + prmIdSport;
                        break;
                    case "vso":
                    case "hso":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_vso_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_hso_" + strArray.GetValue(2).ToString() + "_" + prmIdSport;
                        break;
                    case "vsp":
                    case "hsp":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_vso_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_hso_" + strArray.GetValue(2).ToString() + "_" + prmIdSport;
                        str = str + ",99999_" + strArray.GetValue(0).ToString() + "_vsp_" + strArray.GetValue(2).ToString() + ",99999_" + strArray.GetValue(0).ToString() + "_hsp_" + strArray.GetValue(2).ToString() + "_" + prmIdSport;
                        break;
                    case "vsl":
                    case "hsl":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_vss_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_hss_" + strArray.GetValue(2).ToString() + "_" + prmIdSport;
                        str = str + ",99999_" + strArray.GetValue(0).ToString() + "_vsl_" + strArray.GetValue(2).ToString() + ",99999_" + strArray.GetValue(0).ToString() + "_hsl_" + strArray.GetValue(2).ToString() + "_" + prmIdSport;
                        break;
                    case "vss":
                    case "hss":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_vss_" + strArray.GetValue(2).ToString() + ",-1_" + strArray.GetValue(0).ToString() + "_hss_" + strArray.GetValue(2).ToString() + "_" + prmIdSport;
                        break;
                    case "odds":
                        str = "-1_" + strArray.GetValue(0).ToString() + "_odds_" + strArray.GetValue(2).ToString() + "_" + strArray.GetValue(3).ToString() + "_" + strArray.GetValue(4).ToString() + "_" + prmIdSport;
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
                        str = this.ValidatePoints(prmSelection);
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
            string[] strArray = prmOverUnder.Split("_".ToCharArray());
            string str;
            try
            {
                Decimal num1 = Decimal.Parse(strArray.GetValue(0).ToString());
                if (num1 < new Decimal(0))
                    str = num1.ToString();
                else if (strArray.GetValue(0).ToString().IndexOf(".") != -1)
                {
                    if (IsAmerican)
                    {
                        int num2 = int.Parse(strArray.GetValue(0).ToString().Substring(strArray.GetValue(0).ToString().IndexOf(".") + 1));
                        str = num2 != 5 || !(IdSport != "SOC") ? (num2 != 5 && num2 != 25 && num2 != 75 || !(IdSport == "SOC") ? num1.ToString() : "") : "";
                    }
                    else
                        str = "";
                }
                else
                    str = "";
            }
            catch
            {
                str = strArray.GetValue(0).ToString();
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

        private string ValidatePoints(string prmPoints)
        {
            string[] strArray = prmPoints.Split("_".ToCharArray());
            string str;
            try
            {
                Decimal num = Decimal.Parse(strArray.GetValue(0).ToString());
                str = !(num < new Decimal(-20000)) || !(num > new Decimal(20000)) ? "" : num.ToString();
            }
            catch
            {
                str = strArray.GetValue(0).ToString();
            }
            return str;
        }

        private void AlertErrorMsg(string ErrorMsg)
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<script language=\"javascript\">\n");
            stringBuilder.Append("alert(");
            stringBuilder.Append("\"" + ErrorMsg + "\"");
            stringBuilder.Append(");\n");
            stringBuilder.Append("</script>\n");
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Warning", stringBuilder.ToString(), false);
        }

        private string ConvertDecimalToAmerican(string prmValue)
        {
            string[] strArray = prmValue.Split("_".ToCharArray());
            Decimal num = new Decimal(0);
            try
            {
                Decimal d = Decimal.Parse(strArray.GetValue(0).ToString());
                // num = !(d < new Decimal(2)) ? Math.Round(Decimal.op_Decrement(d) * new Decimal(100)) : Math.Round(new Decimal(100) / Decimal.op_Decrement(d)) * new Decimal(-1);
                num = d >= 2m ? Math.Round((d - 1m) * 100m) : Math.Round(100m / (d - 1m)) * -1m;

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
                    this.Response.Redirect("EventSchedule.aspx?INIT=" + this.Request.Form["OriGame"].ToString());
            }
            catch
            {
            }
        }
    }


}

