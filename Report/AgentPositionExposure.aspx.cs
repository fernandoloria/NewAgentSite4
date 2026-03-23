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
using AgentSite4.ASP;
using AgentSite4.cASEnums;
using DGSinterface;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Xml;

namespace AgentSite4.Report
{
    public partial class AgentPositionExposure : BasePage, IRequiresSessionState
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
                if (Common.HasRights(ReportPosition.AGENTEXPOSURE))
                {
                    CResultAgentPositionExposure cresultAgentExposure = new CResultAgentPositionExposure();
                    long prmIdAgent = long.Parse(this.Session["subIdAgent"].ToString());
                    string str1 = "NFL";
                    short prmIdCurrency = short.Parse(this.Session["IdCurrency"].ToString());
                    if (this.Request.Form["cSport"] != null)
                        str1 = this.Request.Form["cSport"].ToString();
                    if (this.Request.Form["cCurrency"] != null)
                        prmIdCurrency = short.Parse(this.Request.Form["cCurrency"].ToString());
                    CResultAgentPositionExposure reportAgentExposure = agentInstance.GetReportAgentPositioExposure(prmIdAgent, str1.Trim(), prmIdCurrency);
                    if (reportAgentExposure.ErrorCode == CErrorCode.ErrorNone)
                    {
                        string str2 = "../App_Themes/" + this.Theme + "/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(reportAgentExposure.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str2);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\AgentPositionExposure.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                        stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                        this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                    }
                    else if (reportAgentExposure.ErrorCode == CErrorCode.ErrorValidation)
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