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
using DGSinterface;

namespace AgentSite4.Report
{
    public partial class PlayerPayment : BasePage, IRequiresSessionState
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
                if (this.Request.QueryString["Step"] == null)
                {
                    long prmIdAgent = long.Parse(this.Session["SubIdAgent"].ToString());
                    long.Parse(this.Session["IdAgent"].ToString());
                    long prmIdPlayer = long.Parse(this.Request.QueryString["player"].ToString());
                    CResultPlayerPayments cresultPlayerPayments = new CResultPlayerPayments();
                    CResultPlayerPayments reportPlayerPayment = agentInstance.GetReportPlayerPayment(prmIdAgent, prmIdPlayer);
                    if (reportPlayerPayment.ErrorCode == CErrorCode.ErrorNone)
                    {
                        string str = "../App_Themes/" + this.Theme + "/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(reportPlayerPayment.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("Today", DateTime.Now.ToString("MM/dd/yyyy"));
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\PlayerPayment.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                        stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                        this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                    }
                    else if (reportPlayerPayment.ErrorCode == CErrorCode.ErrorValidation)
                        this.Response.Redirect("../Logout.aspx");
                    else
                        this.Response.Redirect("~/Report/ErrorHandle.aspx");
                }
                else
                {
                    long prmIdPlayer = long.Parse(this.Request.Form["hPlayer"].ToString());
                    Decimal prmAmound = Decimal.Parse(this.Request.Form["txtAmount"].ToString());
                    Decimal prmFee = Decimal.Parse(this.Request.Form["txtFee"].ToString());
                    Decimal prmBonus = Decimal.Parse(this.Request.Form["txtBonus"].ToString());
                    string prmDescription = this.Request.Form["txtDescription"].ToString().Replace("'", "");
                    string prmReference = this.Request.Form["txtReference"].ToString().Replace("'", "");
                    int prmPayMethod = int.Parse(this.Request.Form["sMethod"].ToString());
                    char prmTransactionType = char.Parse(this.Request.Form["sTransac"].ToString());
                    DateTime prmDateTime = DateTime.Now;
                    if (this.Request.Form["Date1"] != null)
                        prmDateTime = DateTime.Parse(this.Request.Form["Date1"].ToString()).AddHours(12.0);
                    bool prmBOW = false;
                    if (this.Request.Form["chBOW"] != null && prmTransactionType.ToString().ToUpper() == "C")
                        prmBOW = this.Request.Form["chBOW"] == "on";
                    CResultInsertPayment cresultInsertPayment1 = new CResultInsertPayment();
                    CResultInsertPayment cresultInsertPayment2 = agentInstance.InsertPaymentMethodBOW(prmIdPlayer, prmDescription, prmAmound, prmReference, prmFee, prmBonus, prmPayMethod, prmTransactionType, prmDateTime, prmBOW);
                    if (cresultInsertPayment2.ErrorCode == CErrorCode.ErrorNone)
                    {
                        this.Response.Redirect("PlayerManagement.aspx", false);
                        this.Page.ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "<script language='javascript'>window.alert('" + this.Context.Server.HtmlDecode(ConfigurationManager.AppSettings["TransAccepted"]) + "')</script>");
                    }
                    else if (cresultInsertPayment2.ErrorCode == CErrorCode.ErrorValidation)
                        this.Response.Redirect("../Logout.aspx");
                    else
                        this.Response.Redirect("~/Report/ErrorHandle.aspx");
                }
            }
            catch (Exception ex)
            {
                this.Response.Redirect("ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
        }
    }
}
