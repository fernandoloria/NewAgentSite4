using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;
using DGSinterface;
using AgentSite4.cASEnums;
using System.Xml;
using System.Xml.Xsl;
using System.IO;
using System.Text;
using System.Configuration;
using System.Xml.XPath;

namespace AgentSite4.Report
{
    public partial class AgentPlayerCount : BasePage, IRequiresSessionState
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
                if (Common.HasRights(ReportPosition.PLAYERCOUNT))
                {
                    string prmStartDate = DateTime.Today.ToString("MM/dd/yyyy");
                    string prmEndDate = DateTime.Today.AddDays(1.0).ToString("MM/dd/yyyy");
                    long prmIdAgent = long.Parse(this.Session["SubIdAgent"].ToString());
                    byte prmAccess = 3;
                    byte prmWagerSource = 3;
                    byte prmWagerStatus = 2;
                    byte prmActivity = 2;
                    if (this.Request.Form["Date1"] != null)
                        prmStartDate = this.Request.Form["Date1"];
                    if (this.Request.Form["Date2"] != null)
                        prmEndDate = this.Request.Form["Date2"];
                    if (this.Request.Form["FilterAccess"] != null)
                        prmAccess = byte.Parse(this.Request.Form["FilterAccess"]);
                    if (this.Request.Form["FilterWS"] != null)
                        prmWagerSource = byte.Parse(this.Request.Form["FilterWS"]);
                    if (this.Request.Form["FilterWT"] != null)
                        prmWagerStatus = byte.Parse(this.Request.Form["FilterWT"]);
                    if (this.Request.Form["FilterActivity"] != null)
                        prmActivity = byte.Parse(this.Request.Form["FilterActivity"]);
                    CResultAgentPlayerCount agentPlayerCount1 = new CResultAgentPlayerCount();
                    CResultAgentPlayerCount agentPlayerCount2 = agentInstance.GetReportAgentPlayerCount(prmIdAgent, prmStartDate, prmEndDate, prmActivity, prmAccess, prmWagerSource, prmWagerStatus);
                    if (agentPlayerCount2.ErrorCode == CErrorCode.ErrorNone)
                    {
                        string str = "../App_Themes/" + this.Theme + "/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(agentPlayerCount2.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\AgentPlayerCount.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                        stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                        this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                    }
                    else if (agentPlayerCount2.ErrorCode == CErrorCode.ErrorValidation)
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
    }
}
