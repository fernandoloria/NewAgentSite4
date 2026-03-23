using AgentSite4.ASP;
using AgentSite4.cASEnums;
using DGSinterface;
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
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace AgentSite4.Popup
{
    public partial class AgentPositionDetail : BasePage, IRequiresSessionState
    {
        //Common.HasRights(ReportPosition.$fileinputname.ToUpper()$)
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
            if (!Common.HasRights(ReportPosition.AGENTPOSITION))
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
                CResultAgentPositionDetail agentPositionDetail1 = new CResultAgentPositionDetail();
                long prmIdAgent = long.Parse(this.Session["SubIdAgent"].ToString());
                string prmStartDate = "";
                string prmEndDate = "";
                long prmIdGame = 0;
                short prmIdCurrency = short.Parse(this.Session["IdCurrency"].ToString());
                if (!this.IsPostBack)
                {
                    if (this.Request.QueryString["GAME"] != null)
                    {
                        string[] strArray = this.Request.QueryString["GAME"].ToString().Split("_".ToCharArray());
                        prmStartDate = strArray.GetValue(1).ToString();
                        prmEndDate = strArray.GetValue(2).ToString();
                        prmIdGame = long.Parse(strArray.GetValue(0).ToString());
                    }
                }
                else
                {
                    if (this.Request.Form["hStartDate"] != null)
                        prmStartDate = this.Request.Form["hStartDate"].ToString();
                    if (this.Request.Form["hEndDate"] != null)
                        prmEndDate = this.Request.Form["hEndDate"].ToString();
                    if (this.Request.Form["hCurrency"] != null)
                        prmIdCurrency = short.Parse(this.Request.Form["hCurrency"].ToString());
                    if (this.Request.Form["hGame"] != null)
                        prmIdGame = long.Parse(this.Request.Form["hGame"].ToString());
                }
                CResultAgentPositionDetail agentPositionDetail2 = agentInstance.GetReportAgentPositionDetail(prmIdAgent, prmStartDate, prmEndDate, prmIdGame, prmIdCurrency);
                if (agentPositionDetail2.ErrorCode == CErrorCode.ErrorNone)
                {
                    string str = "../App_Themes/" + this.Theme + "/";
                    XmlDocument xmlDocument = new XmlDocument();
                    xmlDocument.LoadXml(agentPositionDetail2.ToXml());
                    xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                    xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                    XslCompiledTransform compiledTransform = new XslCompiledTransform();
                    StringWriter stringWriter = new StringWriter();
                    compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\AgentPositionDetail.xsl"));
                    compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                    StringBuilder stringBuilder = new StringBuilder();
                    stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                    stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                    this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                }
                else if (agentPositionDetail2.ErrorCode == CErrorCode.ErrorValidation)
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