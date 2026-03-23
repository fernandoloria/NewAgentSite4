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
    public partial class WeeklyBalanceDayHistory : BasePage, IRequiresSessionState
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
            if (Common.HasRights(ReportPosition.PLAYERHISTORY))
                this.LoadData();
            else
                this.Response.Redirect("../Logout.aspx");
        }

        private void LoadData()
        {
            System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo(Session["CultureInfo"].ToString());
            System.Threading.Thread.CurrentThread.CurrentCulture = ci;
            System.Threading.Thread.CurrentThread.CurrentUICulture = ci;
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
            if (this.Request.QueryString["Data"] != null)
            {
                string[] strArray = this.Request.QueryString["Data"].ToString().Split("_".ToCharArray());
                prmIdPlayer = long.Parse(strArray.GetValue(0).ToString());
                DateTime dateTime = DateTime.Parse(strArray.GetValue(1).ToString());
                prmStartDate = dateTime.AddDays(double.Parse(strArray.GetValue(2).ToString()) - 1.0).ToString("MM/dd/yyyy");
                prmEndDate = dateTime.AddDays(double.Parse(strArray.GetValue(2).ToString()) - 1.0).ToString("MM/dd/yyyy");
                prmIdCurrency = short.Parse(strArray.GetValue(3).ToString());
            }
            string prmNextQ = "&IdPlayer=" + (object)prmIdPlayer;
            CResultPlayerHistory reportPlayerHistory = agentInstance.GetReportPlayerHistory(prmIdAgent, prmIdPlayer, prmStartDate, prmEndDate, prmHistWeek, prmPage, prmRecPecPage, prmNextQ, prmIdCurrency, prmNormalOrder);
            if (reportPlayerHistory.ErrorCode == CErrorCode.ErrorNone)
            {
                string str = "../App_Themes/" + this.Theme + "/";
                XmlDocument xmlDocument = new XmlDocument();
                xmlDocument.LoadXml(reportPlayerHistory.ToXml());
                xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                XslCompiledTransform compiledTransform = new XslCompiledTransform();
                StringWriter stringWriter = new StringWriter();
                compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\WeeklyBalanceHistoryDay.xsl"));
                compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
            }
            else if (reportPlayerHistory.ErrorCode == CErrorCode.ErrorValidation)
                this.Response.Redirect("../Logout.aspx");
            else
                this.Response.Redirect("~/Report/ErrorHandle.aspx");
        }
    }


}

