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
using AgentSite4.ASP;
using AgentSite4.cASEnums;
using DGSinterface;

namespace AgentSite4.Report
{
    public partial class PlayerMessage : BasePage, IRequiresSessionState
    {
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {
            this.LoadData();
        }

        private void LoadData()
        {
            try
            {
                System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo(Session["CultureInfo"].ToString());
                System.Threading.Thread.CurrentThread.CurrentCulture = ci;
                System.Threading.Thread.CurrentThread.CurrentUICulture = ci;
               AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
                if (Common.HasRights(ReportPosition.PLAYERMANAGEMENT))
                {
                    int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                    int prmIdProfile = -1;
                    int prmIdBook = -1;
                    int prmIdOffice = -1;
                    int prmIdGrouping = -1;
                    int prmIdLineType = -1;
                    int prmIdPlayerRate = -1;
                    int prmPlayerProfileLimits = -1;
                    string prmPlayer = "";
                    string prmAgent = "";
                    CResultAgentPlayerMessage agentPlayerMessage1 = new CResultAgentPlayerMessage();
                    if (this.Request.QueryString["Step"] != null)
                        this.CreateMessage(agentInstance);
                    if (this.Request.Form["cProfile"] != null)
                        prmIdProfile = int.Parse(this.Request.Form["cProfile"].ToString());
                    if (this.Request.Form["cOffice"] != null)
                        prmIdOffice = int.Parse(this.Request.Form["cOffice"].ToString());
                    if (this.Request.Form["cLineType"] != null)
                        prmIdLineType = int.Parse(this.Request.Form["cLineType"].ToString());
                    if (this.Request.Form["cProfileLimits"] != null)
                        prmPlayerProfileLimits = int.Parse(this.Request.Form["cProfileLimits"].ToString());
                    if (this.Request.Form["cBook"] != null)
                        prmIdBook = int.Parse(this.Request.Form["cBook"].ToString());
                    if (this.Request.Form["cGrouping"] != null)
                        prmIdGrouping = int.Parse(this.Request.Form["cGrouping"].ToString());
                    if (this.Request.Form["cPlayerRate"] != null)
                        prmIdPlayerRate = int.Parse(this.Request.Form["cPlayerRate"].ToString());
                    if (this.Request.Form["txtPlayer"] != null)
                        prmPlayer = this.Request.Form["txtPlayer"].ToString();
                    CResultAgentPlayerMessage agentPlayerMessage2 = agentInstance.GetAgentPlayerMessage(prmIdAgent, prmPlayer, prmAgent, prmIdProfile, prmIdBook, prmIdOffice, prmIdGrouping, prmIdLineType, prmIdPlayerRate, prmPlayerProfileLimits);
                    if (agentPlayerMessage2.ErrorCode == CErrorCode.ErrorNone)
                    {
                        string str = "../App_Themes/" + this.Theme + "/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(agentPlayerMessage2.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\PlayerMessage.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                        stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                        this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                    }
                    else if (agentPlayerMessage2.ErrorCode == CErrorCode.ErrorValidation)
                        this.Response.Redirect("../Logout.aspx");
                    else
                        this.Response.Redirect("~/Report/ErrorHandle.aspx");
                }
                else
                    this.Response.Redirect("../Logout.aspx");
            }
            catch (Exception ex)
            {
                this.Response.Redirect("ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
        }

        private void CreateMessage(IAgent oAgent)
        {
            string prmIdPlayer = "";
            string prmExpDate = DateTime.Today.ToString();
            short prmDisplayCounter = 0;
            try
            {
                string prmMessage = this.Request.Form["txtMsg"].ToString().Replace("'", "-");
                foreach (string key in this.Request.Form.Keys)
                {
                    if (key != null && key.Length > 4 && key.Substring(0, 4) == "chk_")
                        prmIdPlayer = !(prmIdPlayer == "") ? prmIdPlayer + "," + this.Request.Form[key].ToString().Trim() : this.Request.Form[key].ToString().Trim();
                }
                bool prmMessageType = !(this.Request.Form["MsgType"].ToString() == "Normal");
                bool prmUseExpDate;
                if (this.Request.Form["ch_Expiration"] == "on")
                {
                    prmUseExpDate = true;
                    prmExpDate = this.Request.Form["Date1"].ToString();
                }
                else
                    prmUseExpDate = false;
                bool prmUseDispCounter;
                if (this.Request.Form["ch_DisplayCounter"] == "on")
                {
                    prmUseDispCounter = true;
                    prmDisplayCounter = short.Parse(this.Request.Form["txtCounter"].ToString());
                }
                else
                    prmUseDispCounter = false;
                bool prmUseCloseOpt = this.Request.Form["ch_DisableMsg"] == "on";
                if (!oAgent.InsertPlayerMessage(prmIdPlayer, prmMessage, prmMessageType, prmUseExpDate, prmUseDispCounter, prmUseCloseOpt, prmExpDate, prmDisplayCounter))
                    return;
                this.AlertErrorMsg("Message Created.");
            }
            catch (Exception ex)
            {
                this.Response.Redirect("ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
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
    }
}
