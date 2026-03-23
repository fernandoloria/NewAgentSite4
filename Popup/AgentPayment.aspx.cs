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
    public partial class AgentPayment : BasePage, IRequiresSessionState
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
            if (Common.HasRights(ReportPosition.AGENTTRANSACTION))
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
            CResultAgentPayments cresultAgentPayments = new CResultAgentPayments();
            if (this.Request.QueryString["Step"] != null)
                this.CreateTransfer();
            CResultAgentPayments agentPayment = agentInstance.CreateAgentPayment(int.Parse(this.Session["IdAgent"].ToString()), this.Session["Agent"].ToString(), int.Parse(this.Session["Distributor"].ToString()));
            if (agentPayment.ErrorCode == CErrorCode.ErrorNone)
            {
                string str = "../App_Themes/" + this.Theme + "/";
                XmlDocument xmlDocument = new XmlDocument();
                xmlDocument.LoadXml(agentPayment.ToXml());
                xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                XmlAttribute attribute = xmlDocument.CreateAttribute("NegativeBalanceXFER");
                attribute.Value = ConfigurationManager.AppSettings["NegativeBalanceXFER"].ToString();
                xmlDocument.DocumentElement.SetAttributeNode(attribute);
                XslCompiledTransform compiledTransform = new XslCompiledTransform();
                StringWriter stringWriter = new StringWriter();
                compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\AgentPayment.xsl"));
                compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
            }
            else if (agentPayment.ErrorCode == CErrorCode.ErrorValidation)
                this.Response.Redirect("../Logout.aspx");
            else
                this.Response.Redirect("~/Report/ErrorHandle.aspx");
        }

        private void CreateTransfer()
        {
            string prmReference = "";
            int prmPaymentMethod = 1;
            int prmIdAgentTo = -1;
            Decimal prmAmount = new Decimal(0);
            short prmIdCurrency = short.Parse(this.Session["IdCurrency"].ToString());
            int prmIdAgentFrom = int.Parse(this.Session["IdAgent"].ToString());
            if (this.Request.Form["cPaymentMethod"] != null)
                prmPaymentMethod = int.Parse(this.Request.Form["cPaymentMethod"].ToString());
            if (this.Request.Form["txtAmount"] != null)
                prmAmount = Decimal.Parse(this.Request.Form["txtAmount"].ToString());
            if (this.Request.Form["txtReference"] != null)
                prmReference = this.Request.Form["txtReference"].ToString().Replace("'", "-");
            if (this.Request.Form["ToDistributor"] != null)
            {
                if (this.Request.Form["ToDistributor"] == "on")
                    prmIdAgentTo = int.Parse(this.Request.Form["hAgentToDist"].ToString());
                else if (this.Request.Form["cAgentTo"] != null)
                    prmIdAgentTo = int.Parse(this.Request.Form["cAgentTo"].ToString());
            }
            else if (this.Request.Form["cAgentTo"] != null)
                prmIdAgentTo = int.Parse(this.Request.Form["cAgentTo"].ToString());
            if (CDgsHelper.Instance.CreateAgentInstance().InsertAgentTransaction(prmIdAgentFrom, prmIdAgentTo, prmReference, prmPaymentMethod, prmAmount, prmIdCurrency))
                this.AlertErrorMsg("Transfer Complete.");
            else
                this.AlertErrorMsg(ConfigurationManager.AppSettings["ErrorXFER"].ToString());
        }

        private void AlertErrorMsg(string ErrorMsg)
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<script language=\"javascript\">\n");
            stringBuilder.Append("alert(");
            stringBuilder.Append("\"" + ErrorMsg + "\"");
            stringBuilder.Append(");\n");
            stringBuilder.Append("</script>\n");
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Warning", stringBuilder.ToString(), false);
        }

    }

}