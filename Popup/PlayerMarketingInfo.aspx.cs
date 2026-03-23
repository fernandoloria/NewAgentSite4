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
    public partial class PlayerMarketingInfo : BasePage, IRequiresSessionState
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
            if (!Common.HasRights(ReportPosition.PLAYERMANAGEMENT))
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
                CResultAgentPlayerInfoMarketing playerInfoMarketing = new CResultAgentPlayerInfoMarketing();
                int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                long prmIdPlayer = -1;
                bool prmPlayerUpdateInfo = Common.HasRights(ReportPosition.PLAYERMARKETINGINFO);
                if (this.Request.QueryString["Step"] == null)
                {
                    if (this.Request.QueryString["Player"] != null)
                        prmIdPlayer = long.Parse(this.Request.QueryString["Player"].ToString());
                    CResultAgentPlayerInfoMarketing infoMarketingUpdate = agentInstance.GetReportAgentPlayerInfoMarketingUpdate(prmIdPlayer, (long)prmIdAgent, prmPlayerUpdateInfo);
                    if (infoMarketingUpdate.ErrorCode == CErrorCode.ErrorNone)
                    {
                        string str = "../App_Themes/" + this.Theme + "/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(infoMarketingUpdate.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\PlayerMarketingInfo.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                        stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                        this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                    }
                    else if (infoMarketingUpdate.ErrorCode == CErrorCode.ErrorValidation)
                        this.Response.Redirect("../Logout.aspx");
                    else
                        this.Response.Redirect("~/Report/ErrorHandle.aspx");
                }
                else
                {
                    string prmPlayer = this.Request.Form["hPlayer"].ToString();
                    string prmName = this.Request.Form["hName"].ToString();
                    string prmLastName = this.Request.Form["hLastName"].ToString();
                    string prmLastName2 = this.Request.Form["hLastName2"].ToString();
                    string prmAddress1 = this.Request.Form["hAddress1"].ToString();
                    string prmAddress2 = this.Request.Form["hAddress2"].ToString();
                    string prmCity = this.Request.Form["hCity"].ToString();
                    string prmState = this.Request.Form["hState"].ToString();
                    string prmCountry = this.Request.Form["hCountry"].ToString();
                    string prmZip = this.Request.Form["hZip"].ToString();
                    string prmEmail = this.Request.Form["hEmail"].ToString();
                    string prmFlagMessage = this.Request.Form["hFlagMessage"].ToString();
                    string prmOnlineMessage = this.Request.Form["hOnlineMessage"].ToString();
                    if (this.Request.Form["txtName"] != null && prmName != this.Request.Form["txtName"].ToString().Trim())
                        prmName = this.Request.Form["txtName"].ToString().Trim();
                    if (this.Request.Form["txtLastName"] != null && prmLastName != this.Request.Form["txtLastName"].ToString().Trim())
                        prmLastName = this.Request.Form["txtLastName"].ToString().Trim();
                    if (this.Request.Form["txtLastName2"] != null && prmLastName2 != this.Request.Form["txtLastName2"].ToString().Trim())
                        prmLastName2 = this.Request.Form["txtLastName2"].ToString().Trim();
                    if (this.Request.Form["txtAddress1"] != null && prmAddress1 != this.Request.Form["txtAddress1"].ToString().Trim())
                        prmAddress1 = this.Request.Form["txtAddress1"].ToString().Trim();
                    if (this.Request.Form["txtAddress2"] != null && prmAddress2 != this.Request.Form["txtAddress2"].ToString().Trim())
                        prmAddress2 = this.Request.Form["txtAddress2"].ToString().Trim();
                    if (this.Request.Form["txtCity"] != null && prmCity != this.Request.Form["txtCity"].ToString().Trim())
                        prmCity = this.Request.Form["txtCity"].ToString().Trim();
                    if (this.Request.Form["txtState"] != null && prmState != this.Request.Form["txtState"].ToString().Trim())
                        prmState = this.Request.Form["txtState"].ToString().Trim();
                    if (this.Request.Form["txtCountry"] != null && prmCountry != this.Request.Form["txtCountry"].ToString().Trim())
                        prmCountry = this.Request.Form["txtCountry"].ToString().Trim();
                    if (this.Request.Form["txtZip"] != null && prmZip != this.Request.Form["txtZip"].ToString().Trim())
                        prmZip = this.Request.Form["txtZip"].ToString().Trim();
                    if (this.Request.Form["txtEmail"] != null && prmEmail != this.Request.Form["txtEmail"].ToString().Trim())
                        prmEmail = this.Request.Form["txtEmail"].ToString().Trim();
                    if (this.Request.Form["txtFlagMessage"] != null && prmFlagMessage != this.Request.Form["txtFlagMessage"].ToString().Trim())
                        prmFlagMessage = this.Request.Form["txtFlagMessage"].ToString().Trim();
                    if (this.Request.Form["txtOnlineMessage"] != null && prmOnlineMessage != this.Request.Form["txtOnlineMessage"].ToString().Trim())
                        prmOnlineMessage = this.Request.Form["txtOnlineMessage"].ToString().Trim();
                    if (agentInstance.UpdatePlayerMarketingInfo(prmPlayer, prmIdAgent, prmName, prmLastName, prmLastName2, prmAddress1, prmAddress2, prmCity, prmState, prmCountry, prmZip, prmEmail, prmFlagMessage, prmOnlineMessage))
                        this.Close();
                    else
                        this.sMessage(ConfigurationManager.AppSettings["PlayerMarkErrorMessage"].ToString());
                }
            }
            catch (Exception ex)
            {
                this.Response.Redirect("ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
        }

        private void Close()
        {
            if (this.ClientScript.IsClientScriptBlockRegistered("CloseScript"))
                return;
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "CloseScript", "<script language='javascript'>ClosePage();</script>");
        }

        private void sMessage(string strMessage)
        {
            if (this.ClientScript.IsClientScriptBlockRegistered("ErrorMessage"))
                return;
            this.ClientScript.RegisterClientScriptBlock(this.GetType(), "ErrorMessage", "<script language='javascript'>alert(" + strMessage + ");</script>");
        }
    }


}

