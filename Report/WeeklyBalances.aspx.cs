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
using System.Xml.XPath;
using System.Xml.Xsl;
using DGSinterface;
using System.Configuration;
using System.IO;
using System.Text;
using AgentSite4.cASEnums;

namespace AgentSite4.Report
{
    public partial class WeeklyBalances : BasePage, IRequiresSessionState
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
                if (!Common.HasRights(ReportPosition.WEEKLYBALANCE))
                {
                    CResultWeeklyStandar cresultWeeklyStandar = new CResultWeeklyStandar();
                    string prmStartDate = DateTime.Today.ToString("MM/dd/yyyy");
                    string prmIsDistributor = this.Session["IsDistributor"].ToString();
                    string prmAgent = this.Session["SubAgent"].ToString();
                    string prmAgentPagining = this.Session["SubIdAgent"].ToString();
                    long prmIdAgent = long.Parse(this.Session["SubIdAgent"].ToString());
                    int prmTransactionType = -1;
                    short prmCurrentPage = 1;
                    short prmIdCurrency = short.Parse(this.Session["IdCurrency"].ToString());
                    if (this.IsPostBack)
                    {
                        if (this.Request.Form["Date1"] != null)
                            prmStartDate = this.Request.Form["Date1"];
                        if (this.Request.Form["cType"] != null)
                            prmTransactionType = int.Parse(this.Request.Form["cType"].ToString());
                        if (this.Request.Form["cReport"] != null)
                        {
                            int num = (int)short.Parse(this.Request.Form["cReport"].ToString());
                        }
                        if (this.Request.Form["cCurrency"] != null)
                            prmIdCurrency = short.Parse(this.Request.Form["cCurrency"].ToString());
                        if (this.Request.Form["CurrentPage"] != null)
                            prmCurrentPage = short.Parse(this.Request.Form["CurrentPage"].ToString());
                        if (this.Request.Form["CurrentAgent"] != null)
                            prmAgentPagining = this.Request.Form["CurrentAgent"].ToString() != string.Empty ? this.Request.Form["CurrentAgent"].ToString() : this.Session["SubAgent"].ToString();
                    }
                    CResultWeeklyStandar standarHistoryDay = agentInstance.GetReportWeeklyBalancesStandarHistoryDay(prmStartDate, prmIsDistributor, prmAgent, prmIdAgent, prmTransactionType, Common.HasRights(ReportPosition.PLAYERHISTORY), prmIdCurrency, prmAgentPagining, prmCurrentPage);
                    if (standarHistoryDay.ErrorCode == CErrorCode.ErrorNone)
                    {
                        string str = "../App_Themes/" + this.Theme + "/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(standarHistoryDay.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\WeeklyBalances.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                        stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                        this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                    }
                    else if (standarHistoryDay.ErrorCode == CErrorCode.ErrorValidation)
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
