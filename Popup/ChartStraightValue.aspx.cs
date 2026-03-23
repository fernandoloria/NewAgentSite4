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
    public partial class ChartStraightValue : BasePage, IRequiresSessionState
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
            if (!Common.HasRights(ReportPosition.MOVELINES))
                return;
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
                CResultAgentChartStraight agentChartStraight1 = new CResultAgentChartStraight();
                long prmIdAgent = long.Parse(this.Session["IdAgent"].ToString());
                string[] strArray = this.Request.QueryString["Data"].ToString().Split("_".ToCharArray());
                long prmIdGame = long.Parse(strArray[0].ToString());
                string prmWagerType = strArray[1].ToString();
                string prmPlay = strArray[2].ToString();
                CResultAgentChartStraight agentChartStraight2 = agentInstance.GetReportAgentChartStraight(prmIdAgent, prmIdGame, prmWagerType, prmPlay);
                if (agentChartStraight2.ErrorCode == CErrorCode.ErrorNone)
                {
                    string str = "../App_Themes/" + this.Theme + "/";
                    XmlDocument xmlDocument = new XmlDocument();
                    xmlDocument.LoadXml(agentChartStraight2.ToXml());
                    xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                    xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                    XslCompiledTransform compiledTransform = new XslCompiledTransform();
                    StringWriter stringWriter = new StringWriter();
                    compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\ChartStraightValue.xsl"));
                    compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                    StringBuilder stringBuilder = new StringBuilder();
                    stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                    stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                    this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                }
                else
                    this.Close();
            }
            catch
            {
                this.Close();
            }
        }

        private void Close()
        {
            if (this.ClientScript.IsClientScriptBlockRegistered("CloseScript"))
                return;
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "CloseScript", "<script language='javascript'>ClosePage();</script>");
        }
    }


}

