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
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace AgentSite4.Popup
{
    public partial class PlayerPayment : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            this.LoadData();
        }

        private void LoadData()
        {
            try
            {
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
                        string str = "../App_Themes/Classic/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(reportPlayerPayment.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("Today", DateTime.Now.ToString("MM/dd/yyyy"));
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\Classic\\xsl\\PlayerPaymentPopUp.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append(stringWriter.ToString());
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
                        string message = this.Context.Server.HtmlDecode(ConfigurationManager.AppSettings["TransAccepted"]);
                        if (cresultInsertPayment2.Result == -1 && prmTransactionType == 'P')
                        {
                               message = this.Context.Server.HtmlDecode(ConfigurationManager.AppSettings["FreePlayDenied"]);
                        }
                        string script = string.Format(@"<script language='javascript'>window.alert('{0}'); </ script>", message.Replace("'", "\\'"));
                        Page.ClientScript.RegisterStartupScript(this.GetType(), "alertScript", script);

                    }
                    else if (cresultInsertPayment2.ErrorCode == CErrorCode.ErrorValidation)
                        this.Response.Redirect("../Logout.aspx");
                    else
                        Response.Write(cresultInsertPayment2.ToXml());
                }
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message);

            }
        }

    }

}

