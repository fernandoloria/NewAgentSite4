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
    public partial class ChartGameActionDetail : BasePage, IRequiresSessionState
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
                CResultAgentGameActionDetail gameActionDetail1 = new CResultAgentGameActionDetail();
                int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                int prmIdGame = 0;
                short prmWagerType = -1;
                short prmPlay = 0;
                short prmPlayerType = -1;
                if (this.Request.QueryString["GAME"] != null)
                {
                    string[] strArray = this.Request.QueryString["GAME"].ToString().Split("_".ToCharArray());
                    prmIdGame = int.Parse(strArray.GetValue(0).ToString());
                    switch (strArray.GetValue(1).ToString())
                    {
                        case "V0":
                            prmPlay = (short)0;
                            break;
                        case "V2":
                            prmPlay = (short)2;
                            break;
                        case "V4":
                            prmPlay = (short)4;
                            break;
                        case "H1":
                            prmPlay = (short)1;
                            break;
                        case "H3":
                            prmPlay = (short)3;
                            break;
                        case "H5":
                            prmPlay = (short)5;
                            break;
                        case "D":
                            prmPlay = (short)6;
                            break;
                    }
                    prmPlayerType = short.Parse(strArray.GetValue(2).ToString());
                    if (prmPlayerType == (short)2)
                        prmPlayerType = (short)-1;
                }
                else
                {
                    if (this.Request.Form["hGame"] != null)
                        prmIdGame = int.Parse(this.Request.Form["hGame"].ToString());
                    if (this.Request.Form["hPlay"] != null)
                        prmPlay = short.Parse(this.Request.Form["hPlay"].ToString());
                }
                if (this.Request.Form["cWagerType"] != null)
                    prmWagerType = short.Parse(this.Request.Form["cWagerType"].ToString());
                if (this.Request.Form["cPlayerType"] != null)
                    prmPlayerType = short.Parse(this.Request.Form["cPlayerType"].ToString());
                CResultAgentGameActionDetail gameActionDetail2 = agentInstance.GetReportAgentGameActionDetail(prmIdGame, prmWagerType, prmIdAgent, prmPlay, prmPlayerType);
                if (gameActionDetail2.ErrorCode == CErrorCode.ErrorNone)
                {
                    string str = "../App_Themes/" + this.Theme + "/";
                    XmlDocument xmlDocument = new XmlDocument();
                    xmlDocument.LoadXml(gameActionDetail2.ToXml());
                    xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                    xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                    XslCompiledTransform compiledTransform = new XslCompiledTransform();
                    StringWriter stringWriter = new StringWriter();
                    compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\ChartGameActionDetail.xsl"));
                    compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                    StringBuilder stringBuilder = new StringBuilder();
                    stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                    stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                    this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                }
                else if (gameActionDetail2.ErrorCode == CErrorCode.ErrorValidation)
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

