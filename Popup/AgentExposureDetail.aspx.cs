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
using AgentSite4.cASEnums;
using DGSinterface;

namespace AgentSite4.Popup
{
    public partial class AgentExposureDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Common.HasRights(ReportPosition.AGENTEXPOSURE))
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
                CResultAgentExposureDetail agentExposureDetail1 = new CResultAgentExposureDetail();
                long prmIdAgent = long.Parse(this.Session["SubIdAgent"].ToString());
                string[] strArray = this.Request.QueryString["Data"].ToString().Split("_".ToCharArray());
                long prmIdGame = long.Parse(strArray[0].ToString());
                string prmWagerType = strArray[1].ToString();
                string prmPlay = strArray[2].ToString();
                short prmIdCurrency = short.Parse(strArray[3].ToString());
                CResultAgentExposureDetail agentExposureDetail2 = agentInstance.GetReportAgentExposureDetail(prmIdAgent, prmIdGame, prmWagerType, prmPlay, prmIdCurrency);
                if (agentExposureDetail2.ErrorCode == CErrorCode.ErrorNone)
                {
                    string str = "../App_Themes/" + this.Theme + "/";
                    XmlDocument xmlDocument = new XmlDocument();
                    xmlDocument.LoadXml(agentExposureDetail2.ToXml());
                    xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                    xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                    XslCompiledTransform compiledTransform = new XslCompiledTransform();
                    StringWriter stringWriter = new StringWriter();
                    compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\AgentExposureDetail.xsl"));
                    compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                    StringBuilder stringBuilder = new StringBuilder();
                    stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                    stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                    this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                }
                else if (agentExposureDetail2.ErrorCode == CErrorCode.ErrorValidation)
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