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
using System.Web.Script.Services;
using System.Web.Services;

namespace AgentSite4.Report
{
    public partial class AgentHistory : BasePage, IRequiresSessionState
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
                if (Common.HasRights(ReportPosition.SHOWAGENTHISTORY))
                {
                    CResultAgentHistory cresultAgentHistory = new CResultAgentHistory();
                    long prmIdAgent = long.Parse(this.Session["SubIdAgent"].ToString());
                    string prmStartDate = DateTime.Today.ToString("MM/dd/yyyy");
                    string prmEndDate = DateTime.Today.ToString("MM/dd/yyyy");
                    int prmFilter = 0;
                    short prmIdCurrency = short.Parse(this.Session["IdCurrency"].ToString());
                    if (this.Request.Form["Date1"] != null && this.Request.Form["Date2"] != null)
                    {
                        prmStartDate = this.Request.Form["Date1"].ToString();
                        prmEndDate = this.Request.Form["Date2"].ToString();
                    }
                    if (this.Request.Form["Filter"] != null)
                        prmFilter = int.Parse(this.Request.Form["Filter"].ToString());
                    if (this.Request.Form["cCurrency"] != null)
                        prmIdCurrency = short.Parse(this.Request.Form["cCurrency"].ToString());
                    CResultAgentHistory reportAgentHistory = agentInstance.GetReportAgentHistory(prmIdAgent, prmStartDate, prmEndDate, prmFilter, prmIdCurrency);
                    if (reportAgentHistory.ErrorCode == CErrorCode.ErrorNone)
                    {
                        string str = "../App_Themes/" + this.Theme + "/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(reportAgentHistory.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\AgentHistory.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                        stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                        this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                    }
                    else if (reportAgentHistory.ErrorCode == CErrorCode.ErrorValidation)
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

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Xml)]
        public static string LoadAgentHistory(string prmStartDate, string prmEndDate, int prmFilter, short prmIdCurrency)
        {
            //long prmIdAgent
            string response = "";
            try
            {
                long prmIdAgent = Convert.ToInt64(HttpContext.Current.Session["SubIdAgent"]);
                //string prmStartDate = HttpContext.Current.Request.Form["Date1"] ?? DateTime.Today.ToString("MM/dd/yyyy");
                //string prmEndDate = HttpContext.Current.Request.Form["Date2"] ?? DateTime.Today.ToString("MM/dd/yyyy");
                //int prmFilter = HttpContext.Current.Request.Form["Filter"] != null ? int.Parse(HttpContext.Current.Request.Form["Filter"].ToString()) : 0;
                //short prmIdCurrency = HttpContext.Current.Request.Form["cCurrency"] != null ? short.Parse(HttpContext.Current.Request.Form["cCurrency"].ToString()) : Convert.ToInt16(HttpContext.Current.Session["IdCurrency"]);

                AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
                if (Common.HasRights(ReportPosition.SHOWAGENTHISTORY))
                {
                    CResultAgentHistory reportAgentHistory = agentInstance.GetReportAgentHistory(prmIdAgent, prmStartDate, prmEndDate, prmFilter, prmIdCurrency);
                    if (reportAgentHistory.ErrorCode == CErrorCode.ErrorNone)
                    {
                        // Assuming you have a way to get the theme from a static context
                        string str = $"../App_Themes/Classic/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(reportAgentHistory.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(HttpContext.Current.Server.MapPath($"..\\App_Themes\\Classic\\xsl\\AgentHistory.xsl"));
                        compiledTransform.Transform(xmlDocument, null, stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                        response = stringBuilder.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle the exception
            }
            return response;
        }

    }
}
