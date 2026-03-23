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
    public partial class PlayerEdit : BasePage, IRequiresSessionState
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
                if (this.IsPostBack)
                {
                    this.SaveChange();
                }
                else
                {
                    long prmIdAgent1 = long.Parse(this.Session["SubIdAgent"].ToString());
                    long prmIdAgent2 = long.Parse(this.Session["IdAgent"].ToString());
                    string prmAgent = this.Session["SubAgent"].ToString();
                    bool prmIsDistributor = bool.Parse(this.Session["IsDistributor"].ToString());
                    bool flag = bool.Parse(ConfigurationManager.AppSettings["DistRight"].ToString());
                    long prmIdPlayer = long.Parse(this.Request.QueryString["Player"].ToString());
                    CResultPlayerEdit cresultPlayerEdit1 = new CResultPlayerEdit();
                    CResultPlayerEdit cresultPlayerEdit2 = !flag ? agentInstance.GetReportPlayerEdit(prmIdPlayer, prmIdAgent1, prmAgent, prmIsDistributor) : agentInstance.GetReportPlayerEdit(prmIdPlayer, prmIdAgent2, prmAgent, prmIsDistributor);
                    if (cresultPlayerEdit2.ErrorCode == CErrorCode.ErrorNone)
                    {
                        string str = "../App_Themes/" + this.Theme + "/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(cresultPlayerEdit2.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\PlayerEdit.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                        stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                        this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                    }
                    else if (cresultPlayerEdit2.ErrorCode == CErrorCode.ErrorValidation)
                        this.Response.Redirect("../Logout.aspx");
                    else
                        this.Response.Redirect("~/Report/ErrorHandle.aspx");
                }
            }
            catch (Exception ex)
            {
                if (ex.Message.StartsWith("Thread"))
                    return;
                this.Response.Redirect("ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
        }

        private void SaveChange()
        {
            string prmIP = this.Session["IP"].ToString();
            long prmIdAgent = long.Parse(this.Session["SubIdAgent"].ToString());
            long prmIdPlayer = long.Parse(this.Request.QueryString["Player"].ToString());
            string str1 = this.Request.Form["hRight"];
            bool prmUpdateRegionPassword = false;
            bool prmUpdateRegionStatus = false;
            bool prmUpdateRegionCredit = false;
            bool prmUpdateRegionWager = false;
            bool prmUpdateRegionTempCredit = false;
            bool prmUpdateRegionPlayerName = false;
            string prmPasswordOnline = "";
            string prmPassword = "";
            string prmEnable = "";
            string str2 = DateTime.Now.ToString();
            short prmOnlineAccess = 0;
            short prmEnableSports = 0;
            short prmEnableRacing = 0;
            short prmEnableCasino = 0;
            short prmEnableCards = 0;
            Decimal prmCreditLimit = new Decimal(0);
            Decimal prmMaxWager = new Decimal(0);
            Decimal prmMinWager = new Decimal(0);
            Decimal prmMaxWagerOnline = new Decimal(0);
            Decimal prmMinWagerOnline = new Decimal(0);
            Decimal prmTempCredit = new Decimal(0);
            Decimal prmSettledFigure = new Decimal(1);
            string Name = "";
            string LastName = "";
            string LastName2 = "";
            if (str1.IndexOf("CPP") != -1)
            {
                prmPasswordOnline = this.Request.Form["txtPassOnline"] == null ? this.Request.Form["htxtPassOnline"] : this.Request.Form["txtPassOnline"];
                prmPassword = this.Request.Form["txtPass"];
                bool flag;
                if (prmPassword != this.Request.Form["htxtPass"])
                {
                    prmUpdateRegionPassword = true;
                    if (prmPassword.Length > 20)
                    {
                        this.AlertErrorMsg(ConfigurationManager.AppSettings["PassMaxChact"].ToString());
                        flag = false;
                        return;
                    }
                }
                if (prmPasswordOnline != this.Request.Form["htxtPassOnline"])
                {
                    prmUpdateRegionPassword = true;
                    if (prmPasswordOnline.Length > 20)
                    {
                        this.AlertErrorMsg(ConfigurationManager.AppSettings["OnlinePassMaxChact"].ToString());
                        flag = false;
                        return;
                    }
                }
            }
            if (str1.IndexOf("EDP") != -1)
            {
                prmEnable = this.Request.Form["sStatus"];
                if (prmEnable != this.Request.Form["hsStatus"].ToString())
                    prmUpdateRegionStatus = true;
                prmOnlineAccess = !(this.Request.Form["ckOnline"] == "on") ? (short)0 : (short)1;
                short num1 = !(this.Request.Form["hckOnline"] == "True") ? (short)0 : (short)1;
                if ((int)prmOnlineAccess != (int)num1)
                    prmUpdateRegionStatus = true;
                prmEnableCasino = !(this.Request.Form["ckCasino"] == "on") ? (short)0 : (short)1;
                short num2 = !(this.Request.Form["hckCasino"] == "True") ? (short)0 : (short)1;
                if ((int)prmEnableCasino != (int)num2)
                    prmUpdateRegionStatus = true;
                prmEnableRacing = !(this.Request.Form["ckHorses"] == "on") ? (short)0 : (short)1;
                short num3 = !(this.Request.Form["hckHorses"] == "True") ? (short)0 : (short)1;
                if ((int)prmEnableRacing != (int)num3)
                    prmUpdateRegionStatus = true;
                prmEnableSports = !(this.Request.Form["ckSports"] == "on") ? (short)0 : (short)1;
                short num4 = !(this.Request.Form["hckSports"] == "True") ? (short)0 : (short)1;
                if ((int)prmEnableSports != (int)num4)
                    prmUpdateRegionStatus = true;
                prmEnableCards = !(this.Request.Form["ckCards"] == "on") ? (short)0 : (short)1;
                short num5 = !(this.Request.Form["hckCards"] == "True") ? (short)0 : (short)1;
                if ((int)prmEnableCards != (int)num5)
                    prmUpdateRegionStatus = true;
            }
            if (str1.IndexOf("ICL") != -1 || str1.IndexOf("DCL") != -1)
            {
                prmCreditLimit = Decimal.Parse(this.Request.Form["txtCreLimit"]);
                Decimal num = Decimal.Parse(this.Request.Form["hCreditLimitOld"]);
                bool flag;
                if (prmCreditLimit != num)
                {
                    if (str1.IndexOf("ICL") != -1 && str1.IndexOf("DCL") != -1)
                        prmUpdateRegionCredit = true;
                    else if (str1.IndexOf("ICL") != -1)
                    {
                        if (prmCreditLimit < num)
                        {
                            this.AlertErrorMsg(ConfigurationManager.AppSettings["mDCL"].ToString());
                            flag = false;
                            return;
                        }
                        prmUpdateRegionCredit = true;
                    }
                    else
                    {
                        if (prmCreditLimit > num)
                        {
                            this.AlertErrorMsg(ConfigurationManager.AppSettings["mICL"].ToString());
                            flag = false;
                            return;
                        }
                        prmUpdateRegionCredit = true;
                    }
                }
            }
            bool flag1;
            if (str1.IndexOf("IWL") != -1 || str1.IndexOf("DWL") != -1)
            {
                prmMaxWager = Decimal.Parse(this.Request.Form["txtMax"].ToString());
                prmMinWager = Decimal.Parse(this.Request.Form["txtMin"].ToString());
                Decimal num1 = Decimal.Parse(this.Request.Form["hWagerMax"].ToString());
                Decimal num2 = Decimal.Parse(this.Request.Form["hWagerMin"].ToString());
                if (prmMaxWager != num1)
                {
                    if (str1.IndexOf("IWL") != -1 && str1.IndexOf("DWL") != -1)
                        prmUpdateRegionWager = true;
                    else if (str1.IndexOf("IWL") != -1)
                    {
                        if (prmMaxWager < num1)
                        {
                            this.AlertErrorMsg(ConfigurationManager.AppSettings["mDWL"].ToString());
                            flag1 = false;
                            return;
                        }
                        prmUpdateRegionWager = true;
                    }
                    else
                    {
                        if (prmMaxWager > num1)
                        {
                            this.AlertErrorMsg(ConfigurationManager.AppSettings["mIWL"].ToString());
                            flag1 = false;
                            return;
                        }
                        prmUpdateRegionWager = true;
                    }
                }
                if (prmMinWager != num2)
                {
                    if (str1.IndexOf("IWL") != -1 && str1.IndexOf("DWL") != -1)
                        prmUpdateRegionWager = true;
                    else if (str1.IndexOf("IWL") != -1)
                    {
                        if (prmMinWager < num2)
                        {
                            this.AlertErrorMsg(ConfigurationManager.AppSettings["mDWL"].ToString());
                            flag1 = false;
                            return;
                        }
                        prmUpdateRegionWager = true;
                    }
                    else
                    {
                        if (prmMinWager > num2)
                        {
                            this.AlertErrorMsg(ConfigurationManager.AppSettings["mIWL"].ToString());
                            flag1 = false;
                            return;
                        }
                        prmUpdateRegionWager = true;
                    }
                }
            }
            if (str1.IndexOf("IWO") != -1 || str1.IndexOf("DWO") != -1)
            {
                prmMaxWagerOnline = Decimal.Parse(this.Request.Form["txtMaxOnLine"].ToString());
                prmMinWagerOnline = Decimal.Parse(this.Request.Form["txtMinOnLine"].ToString());
                Decimal num1 = Decimal.Parse(this.Request.Form["hOnlineWagerMax"].ToString());
                Decimal num2 = Decimal.Parse(this.Request.Form["hOnlineWagerMin"].ToString());
                if (prmMaxWagerOnline != num1)
                {
                    if (str1.IndexOf("IWO") != -1 && str1.IndexOf("DWO") != -1)
                        prmUpdateRegionWager = true;
                    else if (str1.IndexOf("IWO") != -1)
                    {
                        if (prmMaxWagerOnline < num1)
                        {
                            this.AlertErrorMsg(ConfigurationManager.AppSettings["mDWO"].ToString());
                            flag1 = false;
                            return;
                        }
                        prmUpdateRegionWager = true;
                    }
                    else
                    {
                        if (prmMaxWagerOnline > num1)
                        {
                            this.AlertErrorMsg(ConfigurationManager.AppSettings["mIWO"].ToString());
                            flag1 = false;
                            return;
                        }
                        prmUpdateRegionWager = true;
                    }
                }
                if (prmMinWagerOnline != num2)
                {
                    if (str1.IndexOf("IWO") != -1 && str1.IndexOf("DWO") != -1)
                        prmUpdateRegionWager = true;
                    else if (str1.IndexOf("IWO") != -1)
                    {
                        if (prmMinWagerOnline < num2)
                        {
                            this.AlertErrorMsg(ConfigurationManager.AppSettings["mDWO"].ToString());
                            flag1 = false;
                            return;
                        }
                        prmUpdateRegionWager = true;
                    }
                    else
                    {
                        if (prmMinWagerOnline > num2)
                        {
                            this.AlertErrorMsg(ConfigurationManager.AppSettings["mIWO"].ToString());
                            flag1 = false;
                            return;
                        }
                        prmUpdateRegionWager = true;
                    }
                }
            }
            if (this.Request.Form["txtSettledFigure"] != null)
            {
                prmSettledFigure = Decimal.Parse(this.Request.Form["txtSettledFigure"].ToString());
                Decimal num = Decimal.Parse(this.Request.Form["hSettledFigure"].ToString());
                if (prmSettledFigure < new Decimal(0))
                {
                    this.AlertErrorMsg(ConfigurationManager.AppSettings["mSF"].ToString());
                    flag1 = false;
                    return;
                }
                if (prmSettledFigure != num)
                    prmUpdateRegionWager = true;
            }
            if (str1.IndexOf("CTC") != -1)
            {
                prmTempCredit = Decimal.Parse(this.Request.Form["txtTempCredit"].ToString());
                str2 = this.Request.Form["txtTempCreditExp"].ToString();
                Decimal num = Decimal.Parse(this.Request.Form["hTempCredit"].ToString());
                string str3 = this.Request.Form["hTempCreditExp"].ToString();
                bool flag2;
                if (prmTempCredit != num)
                {
                    if (str2 != "")
                    {
                        if (DateTime.Parse(str2) < DateTime.Today)
                        {
                            this.AlertErrorMsg(ConfigurationManager.AppSettings["mDate"].ToString());
                            flag2 = false;
                            return;
                        }
                        prmUpdateRegionTempCredit = true;
                    }
                    else
                    {
                        this.AlertErrorMsg(ConfigurationManager.AppSettings["mDate"].ToString());
                        flag2 = false;
                        return;
                    }
                }
                else if (str2 != str3)
                {
                    if (DateTime.Parse(str2) < DateTime.Today)
                    {
                        this.AlertErrorMsg(ConfigurationManager.AppSettings["mDate"].ToString());
                        flag2 = false;
                        return;
                    }
                    prmUpdateRegionTempCredit = true;
                }
            }
            if (this.Request.Form["txtName"] != null)
                Name = this.Request.Form["txtName"];
            if (Name != this.Request.Form["htxtName"])
                prmUpdateRegionPlayerName = true;
            if (this.Request.Form["txtLastName"] != null)
                LastName = this.Request.Form["txtLastName"];
            if (LastName != this.Request.Form["htxtLastName"])
                prmUpdateRegionPlayerName = true;
            if (this.Request.Form["txtLastName2"] != null)
                LastName2 = this.Request.Form["txtLastName2"];
            if (LastName2 != this.Request.Form["htxtLastName2"])
                prmUpdateRegionPlayerName = true;
            if (ConfigurationManager.AppSettings["NamePass"].ToString() == "Yes")
            {
                prmUpdateRegionPlayerName = true;
                Name = this.Request.Form["txtPass"];
            }
            if (prmUpdateRegionPassword || prmUpdateRegionStatus || (prmUpdateRegionCredit || prmUpdateRegionWager) || (prmUpdateRegionTempCredit || prmUpdateRegionPlayerName))
            {
               AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
                CResultUpdatePlayer cresultUpdatePlayer = new CResultUpdatePlayer();
                if (agentInstance.UpdatePlayerInfo(prmUpdateRegionPassword, prmUpdateRegionStatus, prmUpdateRegionCredit, prmUpdateRegionWager, prmUpdateRegionTempCredit, prmUpdateRegionPlayerName, prmPasswordOnline, prmPassword, prmEnable, prmOnlineAccess, prmEnableSports, prmEnableRacing, prmEnableCasino, prmEnableCards, prmCreditLimit, prmMaxWager, prmMinWager, prmMaxWagerOnline, prmMinWagerOnline, prmTempCredit, str2, prmIdAgent, prmIdPlayer, Name, LastName, LastName2, prmIP, prmSettledFigure).Update)
                    this.Response.Redirect("PlayerManagement.aspx", true);
                else
                    this.Response.Redirect("ErrorHandle.aspx?Er=" + ConfigurationManager.AppSettings["mErrUpdatePlayer"].ToString());
            }
            else
                this.Response.Redirect("PlayerManagement.aspx", true);
        }

        private void AlertErrorMsg(string ErrorMsg)
        {
            this.Response.Redirect("ErrorHandle.aspx?Validate=" + ErrorMsg);
        }
    }
}
