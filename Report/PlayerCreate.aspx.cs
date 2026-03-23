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
    public partial class PlayerCreate : BasePage, IRequiresSessionState
    {
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Common.HasRights(ReportPosition.CREATEPLAYER))
                this.LoadData();
            else
                this.Response.Redirect("../Logout.aspx");
        }

        private void LoadData()
        {
            try
            {
               AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
                int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
                bool prmIdDistributor = bool.Parse(this.Session["IsDistributor"].ToString());
                string prmAgent = this.Session["Agent"].ToString();
                if (this.IsPostBack)
                {
                    short num = 0;
                    string prmPlayer = "";
                    if (this.Request.Form["hdStep"] != null)
                        num = short.Parse(this.Request.Form["hdStep"]);
                    if (this.Request.Form["txtPlayer"] != null)
                        prmPlayer = this.Request.Form["txtPlayer"].ToString();
                    if (num == (short)2)
                    {
                        this.SaveData();
                    }
                    else
                    {
                        if (!(prmPlayer != ""))
                            return;
                        this.CheckPlayer(prmPlayer);
                    }
                }
                else
                {
                    CResultCreatePlayer cresultCreatePlayer = new CResultCreatePlayer();
                    CResultCreatePlayer createPlayerInfo = agentInstance.GetCreatePlayerInfo(prmIdAgent, prmIdDistributor, prmAgent);
                    if (createPlayerInfo.ErrorCode == CErrorCode.ErrorNone)
                    {
                        string str = "../App_Themes/" + this.Theme + "/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(createPlayerInfo.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        xmlDocument.DocumentElement.SetAttribute("UseOnlyDefaultData", bool.Parse(ConfigurationManager.AppSettings["UseOnlyDefaultData"].ToString()).ToString());
                        xmlDocument.DocumentElement.SetAttribute("Step", "0");
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\PlayerCreate.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append(stringWriter.ToString());
                        this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                    }
                    else if (createPlayerInfo.ErrorCode == CErrorCode.ErrorValidation)
                        this.Response.Redirect("../Logout.aspx");
                    else
                        this.Response.Redirect("~/Report/ErrorHandle.aspx");
                }
            }
            catch (Exception ex)
            {
                if (ex.Message.StartsWith("Thread"))
                    return;
                this.Response.Redirect("ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
        }

        private void SaveData()
        {
            string prmPlayer = "";
            string prmPassword = "";
            string prmFistName = "";
            string prmLastName = "";
            string prmOnlinePass = "";
            string prmOnlineMessage = "";
            float prmPhoneMaxWager = 0.0f;
            float prmPhoneMinWager = 0.0f;
            float prmOnlineMaxWager = 0.0f;
            float prmOnlineMinWager = 0.0f;
            float prmCreditLimit = 0.0f;
            string prmMBLLine = "N";
            short prmPitcher = 0;
            int prmIdProfile = 0;
            int prmIdProfileLimits = 0;
            int prmIdAgent1 = -1;
            int prmIdLineType = -1;
            bool Enabled = false;
            bool Online = false;
            bool Sport = false;
            bool Casino = false;
            bool Racing = false;
            try
            {
               AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
                int prmIdAgent2 = int.Parse(this.Session["IdAgent"].ToString());
                bool prmIdDistributor = bool.Parse(this.Session["IsDistributor"].ToString());
                string prmAgent = this.Session["Agent"].ToString();
                if (this.Request.Form["txtPlayer"] != null)
                    prmPlayer = this.Request.Form["txtPlayer"].ToString();
                if (this.Request.Form["txtPassw"] != null)
                    prmPassword = this.Request.Form["txtPassw"].ToString();
                if (this.Request.Form["txtFirtName"] != null)
                    prmFistName = this.Request.Form["txtFirtName"].ToString();
                if (this.Request.Form["txtLastName"] != null)
                    prmLastName = this.Request.Form["txtLastName"].ToString();
                if (this.Request.Form["txtOnlinePass"] != null)
                    prmOnlinePass = this.Request.Form["txtOnlinePass"].ToString();
                if (this.Request.Form["ckEnabled"] == "on")
                    Enabled = true;
                if (this.Request.Form["ckOnline"] == "on")
                    Online = true;
                if (this.Request.Form["ckSport"] == "on")
                    Sport = true;
                if (this.Request.Form["ckCasino"] == "on")
                    Casino = true;
                if (this.Request.Form["ckRacing"] == "on")
                    Racing = true;
                if (this.Request.Form["txtCreditLimit"] != null)
                    prmCreditLimit = float.Parse(this.Request.Form["txtCreditLimit"].ToString());
                if (this.Request.Form["cmbMLBLine"] != null)
                    prmMBLLine = this.Request.Form["cmbMLBLine"].ToString();
                if (this.Request.Form["cmbPitcher"] != null)
                    prmPitcher = short.Parse(this.Request.Form["cmbPitcher"].ToString());
                if (this.Request.Form["cmbProfile"] != null)
                    prmIdProfile = int.Parse(this.Request.Form["cmbProfile"].ToString());
                if (this.Request.Form["cmbProfileLimits"] != null)
                    prmIdProfileLimits = int.Parse(this.Request.Form["cmbProfileLimits"].ToString());
                if (this.Request.Form["cmbAgent"] != null)
                    prmIdAgent1 = int.Parse(this.Request.Form["cmbAgent"].ToString());
                if (this.Request.Form["cmbLine"] != null)
                    prmIdLineType = int.Parse(this.Request.Form["cmbLine"].ToString());
                if (this.Request.Form["txtPhoneMaxWager"] != null)
                    prmPhoneMaxWager = float.Parse(this.Request.Form["txtPhoneMaxWager"].ToString());
                if (this.Request.Form["txtPhoneMinWager"] != null)
                    prmPhoneMinWager = float.Parse(this.Request.Form["txtPhoneMinWager"].ToString());
                if (this.Request.Form["txtOnlineMaxWager"] != null)
                    prmOnlineMaxWager = float.Parse(this.Request.Form["txtOnlineMaxWager"].ToString());
                if (this.Request.Form["txtOnlineMinWager"] != null)
                    prmOnlineMinWager = float.Parse(this.Request.Form["txtOnlineMinWager"].ToString());
                if (this.Request.Form["txtOnlineMessage"] != null)
                    prmOnlineMessage = this.Request.Form["txtOnlineMessage"].ToString();
                if (!agentInstance.CreatePlayer(prmPlayer, prmPassword, prmFistName, prmLastName, prmOnlinePass, Enabled, Online, Sport, Casino, Racing, prmCreditLimit, prmMBLLine, prmPitcher, prmIdProfile, prmIdProfileLimits, prmIdAgent1, prmIdLineType, prmPhoneMaxWager, prmPhoneMinWager, prmOnlineMaxWager, prmOnlineMinWager, prmOnlineMessage))
                    return;
                CResultCreatePlayer cresultCreatePlayer = new CResultCreatePlayer();
                CResultCreatePlayer createPlayerInfo = agentInstance.GetCreatePlayerInfo(prmIdAgent2, prmIdDistributor, prmAgent);
                if (createPlayerInfo.ErrorCode == CErrorCode.ErrorNone)
                {
                    string namespaceURI = "../App_Themes/" + this.Theme + "/";
                    XmlDocument xmlDocument = new XmlDocument();
                    xmlDocument.LoadXml(createPlayerInfo.ToXml());
                    xmlDocument.CreateElement("ThemePath", namespaceURI);
                    xmlDocument.DocumentElement.SetAttribute("Step", "3");
                    xmlDocument.DocumentElement.SetAttribute("Player", prmPlayer);
                    XslCompiledTransform compiledTransform = new XslCompiledTransform();
                    StringWriter stringWriter = new StringWriter();
                    compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\PlayerCreate.xsl"));
                    compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                    StringBuilder stringBuilder = new StringBuilder();
                    stringBuilder.Append(stringWriter.ToString());
                    this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                }
                else if (createPlayerInfo.ErrorCode == CErrorCode.ErrorValidation)
                    this.Response.Redirect("../Logout.aspx");
                else
                    this.Response.Redirect("~/Report/ErrorHandle.aspx");
            }
            catch (Exception ex)
            {
                if (ex.Message.StartsWith("Thread"))
                    return;
                this.Response.Redirect("ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
        }

        private void CheckPlayer(string prmPlayer)
        {
            string str = "1";
            try
            {
               AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
                int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
                bool prmIdDistributor = bool.Parse(this.Session["IsDistributor"].ToString());
                string prmAgent = this.Session["Agent"].ToString();
                if (agentInstance.CheckPlayerAvail(prmPlayer))
                    str = "2";
                CResultCreatePlayer cresultCreatePlayer = new CResultCreatePlayer();
                CResultCreatePlayer createPlayerInfo = agentInstance.GetCreatePlayerInfo(prmIdAgent, prmIdDistributor, prmAgent);
                if (createPlayerInfo.ErrorCode == CErrorCode.ErrorNone)
                {
                    string namespaceURI = "../App_Themes/" + this.Theme + "/";
                    XmlDocument xmlDocument = new XmlDocument();
                    xmlDocument.LoadXml(createPlayerInfo.ToXml());
                    xmlDocument.CreateElement("ThemePath", namespaceURI);
                    xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                    xmlDocument.DocumentElement.SetAttribute("UseOnlyDefaultData", bool.Parse(ConfigurationManager.AppSettings["UseOnlyDefaultData"].ToString()).ToString());
                    xmlDocument.DocumentElement.SetAttribute("Step", str);
                    xmlDocument.DocumentElement.SetAttribute("Player", prmPlayer);
                    XslCompiledTransform compiledTransform = new XslCompiledTransform();
                    StringWriter stringWriter = new StringWriter();
                    compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\PlayerCreate.xsl"));
                    compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                    StringBuilder stringBuilder = new StringBuilder();
                    stringBuilder.Append(stringWriter.ToString());
                    this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                }
                else if (createPlayerInfo.ErrorCode == CErrorCode.ErrorValidation)
                    this.Response.Redirect("../Logout.aspx");
                else
                    this.Response.Redirect("~/Report/ErrorHandle.aspx");
            }
            catch (Exception ex)
            {
                if (ex.Message.StartsWith("Thread"))
                    return;
                this.Response.Redirect("ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
        }
    }
}
