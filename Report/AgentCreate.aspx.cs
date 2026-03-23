using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;
using System.Xml;
using System.Xml.Xsl;
using System.IO;
using System.Text;
using System.Configuration;
using System.Xml.XPath;
using AgentSite4.cASEnums;
using DGSinterface;

namespace AgentSite4.Report
{
    public partial class AgentCreate : BasePage, IRequiresSessionState
    {
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Common.HasRights(ReportPosition.CREATEAGENT))
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
                bool prmIsDistributor = bool.Parse(this.Session["IsDistributor"].ToString());
                string prmAgent = this.Session["Agent"].ToString();
                if (this.IsPostBack)
                {
                    short num = 0;
                    string prmNewAgent = "";
                    if (this.Request.Form["hdStep"] != null)
                        num = short.Parse(this.Request.Form["hdStep"]);
                    if (this.Request.Form["txtAgent"] != null)
                        prmNewAgent = this.Request.Form["txtAgent"].ToString();
                    if (num == (short)2)
                    {
                        this.SaveData();
                    }
                    else
                    {
                        if (!(prmNewAgent != ""))
                            return;
                        this.CheckAgent(prmNewAgent);
                    }
                }
                else
                {
                    CResultCreateAgent cresultCreateAgent = new CResultCreateAgent();
                    CResultCreateAgent createAgentInfo = agentInstance.GetCreateAgentInfo(prmIdAgent, prmIsDistributor, prmAgent);
                    if (createAgentInfo.ErrorCode == CErrorCode.ErrorNone)
                    {
                        string str = "../App_Themes/" + this.Theme + "/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(createAgentInfo.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        xmlDocument.DocumentElement.SetAttribute("Step", "0");
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\AgentCreate.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append(stringWriter.ToString());
                        this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                    }
                    else if (createAgentInfo.ErrorCode == CErrorCode.ErrorValidation)
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
            string prmAgent1 = "";
            string prmName = "";
            string prmPassword = "";
            int prmIdUnder = -1;
            bool prmEnabled = false;
            bool prmXFer = false;
            try
            {
               AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
                int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
                bool prmIsDistributor = bool.Parse(this.Session["IsDistributor"].ToString());
                string prmAgent2 = this.Session["Agent"].ToString();
                if (this.Request.Form["txtAgent"] != null)
                    prmAgent1 = this.Request.Form["txtAgent"].ToString();
                if (this.Request.Form["txtName"] != null)
                    prmName = this.Request.Form["txtName"].ToString();
                if (this.Request.Form["txtPassw"] != null)
                    prmPassword = this.Request.Form["txtPassw"].ToString();
                if (this.Request.Form["cmbAgent"] != null)
                    prmIdUnder = int.Parse(this.Request.Form["cmbAgent"].ToString());
                if (this.Request.Form["ckEnabled"] == "on")
                    prmEnabled = true;
                if (this.Request.Form["ckXfer"] == "on")
                    prmXFer = true;
                if (!agentInstance.CreateAgent(prmAgent1, prmPassword, prmName, prmIdUnder, prmEnabled, prmXFer))
                    return;
                CResultCreateAgent cresultCreateAgent = new CResultCreateAgent();
                CResultCreateAgent createAgentInfo = agentInstance.GetCreateAgentInfo(prmIdAgent, prmIsDistributor, prmAgent2);
                if (createAgentInfo.ErrorCode == CErrorCode.ErrorNone)
                {
                    string namespaceURI = "../App_Themes/" + this.Theme + "/";
                    XmlDocument xmlDocument = new XmlDocument();
                    xmlDocument.LoadXml(createAgentInfo.ToXml());
                    xmlDocument.CreateElement("ThemePath", namespaceURI);
                    xmlDocument.DocumentElement.SetAttribute("Step", "3");
                    xmlDocument.DocumentElement.SetAttribute("Agent", prmAgent1);
                    XslCompiledTransform compiledTransform = new XslCompiledTransform();
                    StringWriter stringWriter = new StringWriter();
                    compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\AgentCreate.xsl"));
                    compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                    StringBuilder stringBuilder = new StringBuilder();
                    stringBuilder.Append(stringWriter.ToString());
                    this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                }
                else if (createAgentInfo.ErrorCode == CErrorCode.ErrorValidation)
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

        private void CheckAgent(string prmNewAgent)
        {
            string str = "1";
            try
            {
               AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
                CResultCreateAgent cresultCreateAgent = new CResultCreateAgent();
                int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
                bool prmIsDistributor = bool.Parse(this.Session["IsDistributor"].ToString());
                string prmAgent = this.Session["Agent"].ToString();
                if (agentInstance.CheckAgentAvailable(prmNewAgent))
                    str = "2";
                CResultCreateAgent createAgentInfo = agentInstance.GetCreateAgentInfo(prmIdAgent, prmIsDistributor, prmAgent);
                if (createAgentInfo.ErrorCode == CErrorCode.ErrorNone)
                {
                    string namespaceURI = "../App_Themes/" + this.Theme + "/";
                    XmlDocument xmlDocument = new XmlDocument();
                    xmlDocument.LoadXml(createAgentInfo.ToXml());
                    xmlDocument.CreateElement("ThemePath", namespaceURI);
                    xmlDocument.DocumentElement.SetAttribute("Step", str);
                    xmlDocument.DocumentElement.SetAttribute("Agent", prmNewAgent);
                    XslCompiledTransform compiledTransform = new XslCompiledTransform();
                    StringWriter stringWriter = new StringWriter();
                    compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\AgentCreate.xsl"));
                    compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                    StringBuilder stringBuilder = new StringBuilder();
                    stringBuilder.Append(stringWriter.ToString());
                    this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                }
                else if (createAgentInfo.ErrorCode == CErrorCode.ErrorValidation)
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
