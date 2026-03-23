using AgentSite4.ASP;
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
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Xml;
using AgentSite4.cASEnums;

namespace AgentSite4.Report
{
    public partial class ActionByPlayer : BasePage, IRequiresSessionState
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
                if (Common.HasRights(ReportPosition.ACTIONBYPLAYER))
                {
                    long prmIdAgent = long.Parse(this.Session["SubIdAgent"].ToString());
                    short prmIdCurrency = short.Parse(this.Session["IdCurrency"].ToString());
                    string prmAgent = this.Session["SubAgent"].ToString();
                    string prmStartDate = "";
                    string prmEndDate = "";
                    if (this.IsPostBack)
                    {
                        if (this.Request.Form["Date1"] != null && this.Request.Form["Date2"] != null)
                        {
                            prmStartDate = this.Request.Form["Date1"].ToString();
                            prmEndDate = this.Request.Form["Date2"].ToString();
                        }
                        if (this.Request.Form["cCurrency"] != null)
                            prmIdCurrency = short.Parse(this.Request.Form["cCurrency"].ToString());
                    }
                    CResultActionByPlayer cresultActionByPlayer = new CResultActionByPlayer();
                    AddOnWebClient.Agent ad = new AddOnWebClient.Agent();
                    CResultActionByPlayer reportActionByPlayer = ad.GetReportActionByPlayer(prmStartDate, prmEndDate, prmIdAgent, prmAgent, prmIdCurrency);

                    //CResultActionByPlayer reportActionByPlayer = agentInstance.GetReportActionByPlayer(prmStartDate, prmEndDate, prmIdAgent, prmAgent, prmIdCurrency);
                    if (reportActionByPlayer.ErrorCode == CErrorCode.ErrorNone)
                    {
                        string str = "../App_Themes/" + this.Theme + "/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(reportActionByPlayer.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\ActionByPlayer.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                        stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                        this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                    }
                    else if (reportActionByPlayer.ErrorCode == CErrorCode.ErrorValidation)
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