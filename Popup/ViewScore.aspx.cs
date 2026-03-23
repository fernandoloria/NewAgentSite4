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
    public partial class ViewScore : BasePage, IRequiresSessionState
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
            if (!Common.HasRights(ReportPosition.PLAYERHISTORY))
                return;
            this.LoadData();
        }

        private void LoadData()
        {
            System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo(Session["CultureInfo"].ToString());
            System.Threading.Thread.CurrentThread.CurrentCulture = ci;
            System.Threading.Thread.CurrentThread.CurrentUICulture = ci;

            AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
            CResultGameScore cresultGameScore = new CResultGameScore();
            long prmIdWager = 0;
            if (this.Request.QueryString["Id"] != null)
                prmIdWager = long.Parse(this.Request.QueryString["Id"].ToString());
            try
            {
                CResultGameScore reportGameScore = agentInstance.GetReportGameScore(prmIdWager);
                if (reportGameScore.ErrorCode == CErrorCode.ErrorNone)
                {
                    string str = "../App_Themes/" + this.Theme + "/";
                    XmlDocument xmlDocument = new XmlDocument();
                    xmlDocument.LoadXml(reportGameScore.ToXml());
                    xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                    xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                    XslCompiledTransform compiledTransform = new XslCompiledTransform();
                    StringWriter stringWriter = new StringWriter();
                    compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\ViewScore.xsl"));
                    compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                    StringBuilder stringBuilder = new StringBuilder();
                    stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                    stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                    this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                }
                else if (reportGameScore.ErrorCode == CErrorCode.ErrorValidation)
                    this.Response.Redirect("../Logout.aspx");
                else
                    this.Response.Redirect("~/Report/ErrorHandle.aspx");
            }
            catch (Exception ex)
            {
                this.Response.Redirect("ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
        }
    }

}

