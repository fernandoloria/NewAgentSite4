using AgentSite4.ASP;
using DGSinterface;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
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

namespace AgentSite4.Report
{
    public partial class AgentPlayerEdit : BasePage, IRequiresSessionState
    {
        private static string sConnString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
        private int TIME_OUT = 300;
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
                XmlDocument xmlDocument1 = new XmlDocument();
                if (this.IsPostBack)
                {
                    this.SaveChange();
                }
                else
                {
                    
                    int prmIdAgent1 = int.Parse(this.Session["SubIdAgent"].ToString());
                    int prmIdAgent2 = int.Parse(this.Session["IdAgent"].ToString());
                    string prmAgent = this.Session["SubAgent"].ToString();
                    bool prmIsDistributor = bool.Parse(this.Session["IsDistributor"].ToString());
                    bool flag = bool.Parse(ConfigurationManager.AppSettings["DistRight"].ToString());
                    int prmIdPlayer = int.Parse(this.Request.QueryString["Player"].ToString());
                    XmlDocument xmlDocument2 = !flag ? this.GetPlayerEditData(prmIdPlayer, prmIdAgent1, prmAgent, prmIsDistributor) : this.GetPlayerEditData(prmIdPlayer, prmIdAgent2, prmAgent, prmIsDistributor);
                    if (xmlDocument2["xml"].Attributes["ErrorCode"].Value == "0")
                    {
                        string str = "../App_Themes/" + this.Theme + "/";
                        xmlDocument2.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument2.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\AgentPlayerEdit.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument2, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append(stringWriter.ToString());
                        this.ReportHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                    }
                    else if (xmlDocument2["xml"].Attributes["ErrorCode"].Value == "2")
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
            int num1 = int.Parse(this.Session["SubIdAgent"].ToString());
            int num2 = int.Parse(this.Request.QueryString["Player"].ToString());
            string str1 = this.Request.Form["hRight"];
            bool prmUpdateRegionPassword = false;
            bool prmUpdateRegionStatus = false;
            bool prmUpdateRegionCredit = false;
            bool prmUpdateRegionWager = false;
            bool prmUpdateRegionTempCredit = false;
            bool prmUpdateRegionPlayerName = false;
            bool prmUpdateRegionPhoneNumber = false;
            bool prmUpdateRegionEmailAddress = false;
            bool prmUpdateRegionMarketingNotes = false;
            bool prmUpdateRegionCustomerServiceNotes = false;
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
            string prmName = "";
            string prmLastName = "";
            string prmLastName2 = "";
            string empty1 = string.Empty;
            string empty2 = string.Empty;
            string empty3 = string.Empty;
            string empty4 = string.Empty;
            string empty5 = string.Empty;
            string empty6 = string.Empty;
            string empty7 = string.Empty;
            string empty8 = string.Empty;
            try
            {
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
                    short num3 = !(this.Request.Form["hckOnline"] == "True") ? (short)0 : (short)1;
                    if ((int)prmOnlineAccess != (int)num3)
                        prmUpdateRegionStatus = true;
                    prmEnableCasino = !(this.Request.Form["ckCasino"] == "on") ? (short)0 : (short)1;
                    short num4 = !(this.Request.Form["hckCasino"] == "True") ? (short)0 : (short)1;
                    if ((int)prmEnableCasino != (int)num4)
                        prmUpdateRegionStatus = true;
                    prmEnableRacing = !(this.Request.Form["ckHorses"] == "on") ? (short)0 : (short)1;
                    short num5 = !(this.Request.Form["hckHorses"] == "True") ? (short)0 : (short)1;
                    if ((int)prmEnableRacing != (int)num5)
                        prmUpdateRegionStatus = true;
                    prmEnableSports = !(this.Request.Form["ckSports"] == "on") ? (short)0 : (short)1;
                    short num6 = !(this.Request.Form["hckSports"] == "True") ? (short)0 : (short)1;
                    if ((int)prmEnableSports != (int)num6)
                        prmUpdateRegionStatus = true;
                    prmEnableCards = !(this.Request.Form["ckCards"] == "on") ? (short)0 : (short)1;
                    short num7 = !(this.Request.Form["hckCards"] == "True") ? (short)0 : (short)1;
                    if ((int)prmEnableCards != (int)num7)
                        prmUpdateRegionStatus = true;
                }
                if (str1.IndexOf("ICL") != -1 || str1.IndexOf("DCL") != -1)
                {
                    prmCreditLimit = Decimal.Parse(this.Request.Form["txtCreLimit"]);
                    Decimal num3 = Decimal.Parse(this.Request.Form["hCreditLimitOld"]);
                    bool flag;
                    if (prmCreditLimit != num3)
                    {
                        if (str1.IndexOf("ICL") != -1 && str1.IndexOf("DCL") != -1)
                            prmUpdateRegionCredit = true;
                        else if (str1.IndexOf("ICL") != -1)
                        {
                            if (prmCreditLimit < num3)
                            {
                                this.AlertErrorMsg(ConfigurationManager.AppSettings["mDCL"].ToString());
                                flag = false;
                                return;
                            }
                            prmUpdateRegionCredit = true;
                        }
                        else
                        {
                            if (prmCreditLimit > num3)
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
                    Decimal num3 = Decimal.Parse(this.Request.Form["hWagerMax"].ToString());
                    Decimal num4 = Decimal.Parse(this.Request.Form["hWagerMin"].ToString());
                    if (prmMaxWager != num3)
                    {
                        if (str1.IndexOf("IWL") != -1 && str1.IndexOf("DWL") != -1)
                            prmUpdateRegionWager = true;
                        else if (str1.IndexOf("IWL") != -1)
                        {
                            if (prmMaxWager < num3)
                            {
                                this.AlertErrorMsg(ConfigurationManager.AppSettings["mDWL"].ToString());
                                flag1 = false;
                                return;
                            }
                            prmUpdateRegionWager = true;
                        }
                        else
                        {
                            if (prmMaxWager > num3)
                            {
                                this.AlertErrorMsg(ConfigurationManager.AppSettings["mIWL"].ToString());
                                flag1 = false;
                                return;
                            }
                            prmUpdateRegionWager = true;
                        }
                    }
                    if (prmMinWager != num4)
                    {
                        if (str1.IndexOf("IWL") != -1 && str1.IndexOf("DWL") != -1)
                            prmUpdateRegionWager = true;
                        else if (str1.IndexOf("IWL") != -1)
                        {
                            if (prmMinWager < num4)
                            {
                                this.AlertErrorMsg(ConfigurationManager.AppSettings["mDWL"].ToString());
                                flag1 = false;
                                return;
                            }
                            prmUpdateRegionWager = true;
                        }
                        else
                        {
                            if (prmMinWager > num4)
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
                    Decimal num3 = Decimal.Parse(this.Request.Form["hOnlineWagerMax"].ToString());
                    Decimal num4 = Decimal.Parse(this.Request.Form["hOnlineWagerMin"].ToString());
                    if (prmMaxWagerOnline != num3)
                    {
                        if (str1.IndexOf("IWO") != -1 && str1.IndexOf("DWO") != -1)
                            prmUpdateRegionWager = true;
                        else if (str1.IndexOf("IWO") != -1)
                        {
                            if (prmMaxWagerOnline < num3)
                            {
                                this.AlertErrorMsg(ConfigurationManager.AppSettings["mDWO"].ToString());
                                flag1 = false;
                                return;
                            }
                            prmUpdateRegionWager = true;
                        }
                        else
                        {
                            if (prmMaxWagerOnline > num3)
                            {
                                this.AlertErrorMsg(ConfigurationManager.AppSettings["mIWO"].ToString());
                                flag1 = false;
                                return;
                            }
                            prmUpdateRegionWager = true;
                        }
                    }
                    if (prmMinWagerOnline != num4)
                    {
                        if (str1.IndexOf("IWO") != -1 && str1.IndexOf("DWO") != -1)
                            prmUpdateRegionWager = true;
                        else if (str1.IndexOf("IWO") != -1)
                        {
                            if (prmMinWagerOnline < num4)
                            {
                                this.AlertErrorMsg(ConfigurationManager.AppSettings["mDWO"].ToString());
                                flag1 = false;
                                return;
                            }
                            prmUpdateRegionWager = true;
                        }
                        else
                        {
                            if (prmMinWagerOnline > num4)
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
                    Decimal num3 = Decimal.Parse(this.Request.Form["hSettledFigure"].ToString());
                    if (prmSettledFigure < new Decimal(0))
                    {
                        this.AlertErrorMsg(ConfigurationManager.AppSettings["mSF"].ToString());
                        flag1 = false;
                        return;
                    }
                    if (prmSettledFigure != num3)
                        prmUpdateRegionWager = true;
                }
                if (str1.IndexOf("CTC") != -1)
                {
                    prmTempCredit = Decimal.Parse(this.Request.Form["txtTempCredit"].ToString());
                    str2 = this.Request.Form["txtTempCreditExp"].ToString();
                    Decimal num3 = Decimal.Parse(this.Request.Form["hTempCredit"].ToString());
                    string str3 = this.Request.Form["hTempCreditExp"].ToString();
                    bool flag2;
                    if (prmTempCredit != num3)
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
                    prmName = this.Request.Form["txtName"];
                if (prmName != this.Request.Form["htxtName"])
                    prmUpdateRegionPlayerName = true;
                if (this.Request.Form["txtLastName"] != null)
                    prmLastName = this.Request.Form["txtLastName"];
                if (prmLastName != this.Request.Form["htxtLastName"])
                    prmUpdateRegionPlayerName = true;
                if (this.Request.Form["txtLastName2"] != null)
                    prmLastName2 = this.Request.Form["txtLastName2"];
                if (prmLastName2 != this.Request.Form["htxtLastName2"])
                    prmUpdateRegionPlayerName = true;
                if (ConfigurationManager.AppSettings["NamePass"].ToString() == "Yes")
                {
                    prmUpdateRegionPlayerName = true;
                    prmName = this.Request.Form["txtPass"];
                }
                if (this.Request.Form["txtPhoneNumber"] != null)
                    empty7 = this.Request.Form["txtPhoneNumber"];
                if (empty7 != this.Request.Form["htxtPhoneNumber"])
                    prmUpdateRegionPhoneNumber = true;
                if (this.Request.Form["txtEmail"] != null)
                    empty8 = this.Request.Form["txtEmail"];
                if (empty8 != this.Request.Form["htxtEmail"])
                    prmUpdateRegionEmailAddress = true;
                if (this.Request.Form["txtNote01"] != null)
                    empty1 = this.Request.Form["txtNote01"];
                if (this.Request.Form["txtNote02"] != null)
                    empty2 = this.Request.Form["txtNote02"];
                if (this.Request.Form["txtNote03"] != null)
                    empty3 = this.Request.Form["txtNote03"];
                if (empty1 != this.Request.Form["htxtNote01"] || empty2 != this.Request.Form["htxtNote02"] || empty3 != this.Request.Form["htxtNote03"])
                    prmUpdateRegionMarketingNotes = true;
                if (this.Request.Form["txtNote04"] != null)
                    empty4 = this.Request.Form["txtNote04"];
                if (this.Request.Form["txtNote05"] != null)
                    empty5 = this.Request.Form["txtNote05"];
                if (this.Request.Form["txtNote06"] != null)
                    empty6 = this.Request.Form["txtNote06"];
                if (empty4 != this.Request.Form["htxtNote04"] || empty5 != this.Request.Form["htxtNote05"] || empty6 != this.Request.Form["htxtNote06"])
                    prmUpdateRegionCustomerServiceNotes = true;
                if (!prmUpdateRegionPassword && !prmUpdateRegionStatus && (!prmUpdateRegionCredit && !prmUpdateRegionWager) && (!prmUpdateRegionTempCredit && !prmUpdateRegionPlayerName && (!prmUpdateRegionPhoneNumber && !prmUpdateRegionEmailAddress)) && (!prmUpdateRegionMarketingNotes && !prmUpdateRegionCustomerServiceNotes))
                    return;
                if (this.DBUpdatePlayerInformation(prmUpdateRegionPassword, prmUpdateRegionStatus, prmUpdateRegionCredit, prmUpdateRegionWager, prmUpdateRegionTempCredit, prmUpdateRegionPlayerName, prmUpdateRegionPhoneNumber, prmUpdateRegionEmailAddress, prmUpdateRegionMarketingNotes, prmUpdateRegionCustomerServiceNotes, prmPasswordOnline, prmPassword, prmEnable, prmOnlineAccess, prmEnableSports, prmEnableRacing, prmEnableCasino, prmEnableCards, prmCreditLimit, prmMaxWager, prmMinWager, prmMaxWagerOnline, prmMinWagerOnline, prmTempCredit, str2, (long)num1, (long)num2, prmName, prmLastName, prmLastName2, prmIP, prmSettledFigure, empty7, empty8, empty1, empty2, empty3, empty4, empty5, empty6))
                    this.Response.Redirect("PlayerManagement.aspx", true);
                else
                    this.Response.Redirect("ErrorHandle.aspx?Er=" + ConfigurationManager.AppSettings["mErrUpdatePlayer"].ToString());
            }
            catch (Exception ex)
            {
                Logger.Log("PlayerEdit", ex.Message);
            }
        }

        private XmlDocument GetPlayerEditData(
          int prmIdPlayer,
          int prmIdAgent,
          string prmAgent,
          bool prmIsDistributor)
        {
            XmlDocument xmlDocument = new XmlDocument();
            List<CAgentRight> cagentRightList = new List<CAgentRight>();
            XmlElement element1 = xmlDocument.CreateElement("xml");
            xmlDocument.AppendChild((XmlNode)element1);
            try
            {
                DataSet playerEditData = this.DBGetPlayerEditData(prmIdPlayer, prmIdAgent);
                if (playerEditData.Tables[0].Rows.Count > 0)
                {
                    DataRow row = playerEditData.Tables[0].Rows[0];
                    element1.SetAttribute("ErrorCode", "0");
                    element1.SetAttribute("ErrorMsgKey", string.Empty);
                    element1.SetAttribute("ErrorMsgParams", string.Empty);
                    element1.SetAttribute("ErrorMsg", string.Empty);
                    element1.SetAttribute("IdPlayer", row["IdPlayer"].ToString());
                    element1.SetAttribute("Player", row["Player"].ToString());
                    element1.SetAttribute("Password", row["Password"].ToString());
                    element1.SetAttribute("OnlinePassword", row["OnlinePassword"].ToString());
                    element1.SetAttribute("CreditLimit", row["CreditLimit"].ToString());
                    element1.SetAttribute("OnlineMaxWager", row["OnlineMaxWager"].ToString());
                    element1.SetAttribute("OnlineMinWager", row["OnlineMinWager"].ToString());
                    element1.SetAttribute("MaxWager", row["MaxWager"].ToString());
                    element1.SetAttribute("MinWager", row["MinWager"].ToString());
                    element1.SetAttribute("EnableOnline", bool.Parse(row["OnlineAccess"].ToString()).ToString());
                    element1.SetAttribute("EnableCasino", bool.Parse(row["EnableCasino"].ToString()).ToString());
                    element1.SetAttribute("EnableHorses", bool.Parse(row["EnableHorses"].ToString()).ToString());
                    element1.SetAttribute("EnableSport", bool.Parse(row["EnableSports"].ToString()).ToString());
                    element1.SetAttribute("TempCredit", row["TempCredit"].ToString());
                    element1.SetAttribute("TempCreditExpire", DateTime.Parse(row["TempCreditExpire"].ToString()).ToString("MM/dd/yyyy"));
                    element1.SetAttribute("Name", row["Name"].ToString());
                    element1.SetAttribute("LastName", row["LastName"].ToString());
                    element1.SetAttribute("LastName2", row["LastName2"].ToString());
                    element1.SetAttribute("EnableCards", bool.Parse(row["EnableCards"].ToString()).ToString());
                    element1.SetAttribute("SettledFigure", row["SettledFigure"].ToString());
                    element1.SetAttribute("Status", row["Status"].ToString());
                    element1.SetAttribute("Phone", row["Phone"].ToString());
                    element1.SetAttribute("Email", row["Email"].ToString());
                    element1.SetAttribute("Notes0", row["Notes0"].ToString());
                    element1.SetAttribute("Notes1", row["Notes1"].ToString());
                    element1.SetAttribute("Notes2", row["Notes2"].ToString());
                    element1.SetAttribute("Notes3", row["Notes3"].ToString());
                    element1.SetAttribute("Notes4", row["Notes4"].ToString());
                    element1.SetAttribute("Notes5", row["Notes5"].ToString());
                    element1.SetAttribute("Notes6", row["Notes6"].ToString());
                }
                foreach (CAgentRight right in this.GetRightList(prmIdAgent, string.Empty))
                {
                    XmlElement element2 = xmlDocument.CreateElement("right");
                    element2.SetAttribute("Name", right.Name);
                    element2.SetAttribute("Description", right.Description);
                    element2.SetAttribute("Allow", right.Allow.ToString());
                    element1.AppendChild((XmlNode)element2);
                }
            }
            catch (Exception ex)
            {
                Logger.Log(nameof(GetPlayerEditData), ex.ToString());
                element1.SetAttribute("ErrorCode", "-1001");
                element1.SetAttribute("ErrorMsgKey", "");
                element1.SetAttribute("ErrorMsgParams", "");
                element1.SetAttribute("ErrorMsg", ex.ToString());
            }
            return xmlDocument;
        }

        private List<CAgentRight> GetRightList(int prmIdAgent, string prmRight)
        {
            List<CAgentRight> cagentRightList = new List<CAgentRight>();
            bool Allow1 = false;
            bool Allow2 = false;
            bool[] flagArray = new bool[9];
            string Description = "";
            try
            {
                DataSet agentRightList = this.DBGetAgentRightList(prmIdAgent, prmRight);
                for (int index = 0; index < agentRightList.Tables[0].Rows.Count; ++index)
                {
                    DataRow row = agentRightList.Tables[0].Rows[index];
                    if (row["DES"].ToString() == "INCREASE CREDIT LIMIT")
                    {
                        Description += "ICL_";
                        Allow1 = true;
                        Allow2 = true;
                        flagArray[0] = true;
                    }
                    if (row["DES"].ToString() == "DECREASE CREDIT LIMIT")
                    {
                        Description += "DCL_";
                        flagArray[1] = true;
                        Allow2 = true;
                        Allow1 = true;
                    }
                    if (row["DES"].ToString() == "INCREASE WAGER LIMIT LOCAL")
                    {
                        Description += "IWL_";
                        flagArray[2] = true;
                        Allow2 = true;
                        Allow1 = true;
                    }
                    if (row["DES"].ToString() == "DECREASE WAGER LIMIT LOCAL")
                    {
                        Description += "DWL_";
                        flagArray[3] = true;
                        Allow1 = true;
                    }
                    if (row["DES"].ToString() == "INCREASE WAGER LIMIT ONLINE")
                    {
                        Description += "IWO_";
                        flagArray[4] = true;
                        Allow2 = true;
                        Allow1 = true;
                    }
                    if (row["DES"].ToString() == "DECREASE WAGER LIMIT ONLINE")
                    {
                        Description += "DWO_";
                        flagArray[5] = true;
                        Allow2 = true;
                        Allow1 = true;
                    }
                    if (row["DES"].ToString() == "ENABLE OR DISABLE PLAYER")
                    {
                        Description += "EDP_";
                        Allow2 = true;
                        flagArray[6] = true;
                    }
                    if (row["DES"].ToString() == "CHANGE PLAYER PASSWORDS")
                    {
                        Description += "CPP_";
                        Allow2 = true;
                        flagArray[7] = true;
                    }
                    if (row["DES"].ToString() == "CHANGE TEMPORAL CREDIT")
                    {
                        Description += "CTC_";
                        Allow2 = true;
                        flagArray[8] = true;
                    }
                }
                cagentRightList.Add(new CAgentRight("PERMISOLIMITSCREINC", "INCREASE CREDIT LIMIT", flagArray[0]));
                cagentRightList.Add(new CAgentRight("PERMISOLIMITSCREDEC", "DECREASE CREDIT LIMIT", flagArray[1]));
                cagentRightList.Add(new CAgentRight("PERMISOLIMITSWAGLINC", "INCREASE WAGER LIMIT LOCAL", flagArray[2]));
                cagentRightList.Add(new CAgentRight("PERMISOLIMITSWAGLDEC", "DECREASE WAGER LIMIT LOCAL", flagArray[3]));
                cagentRightList.Add(new CAgentRight("PERMISOLIMITSWAGOINC", "INCREASE WAGER LIMIT ONLINE", flagArray[4]));
                cagentRightList.Add(new CAgentRight("PERMISOLIMITSWAGODEC", "DECREASE WAGER LIMIT ONLINE", flagArray[5]));
                cagentRightList.Add(new CAgentRight("PERMISOACCESS", "ENABLE OR DISABLE PLAYER", flagArray[6]));
                cagentRightList.Add(new CAgentRight("PERMISOPLAYER", "CHANGE PLAYER PASSWORDS", flagArray[7]));
                cagentRightList.Add(new CAgentRight("PERMISOCHANGETEMP", "CHANGE TEMPORAL CREDIT", flagArray[8]));
                cagentRightList.Add(new CAgentRight("PERMISOLIMITS", "EDITAR LIMITER", Allow1));
                cagentRightList.Add(new CAgentRight("PERMISOEDIT", "EDITAR", Allow2));
                cagentRightList.Add(new CAgentRight("STRRIGHT", Description, true));
            }
            catch (Exception ex)
            {
                Logger.Log(nameof(GetRightList), ex.ToString());
            }
            return cagentRightList;
        }

        private void AlertErrorMsg(string ErrorMsg)
        {
            this.Response.Redirect("ErrorHandle.aspx?Validate=" + ErrorMsg);
        }

        private DataSet DBGetPlayerEditData(int prmIdPlayer, int prmIdAgent)
        {
            DataSet dataSet = (DataSet)null;
            SqlConnection connection = new SqlConnection(AgentPlayerEdit.sConnString);
            try
            {
                SqlCommand selectCommand = new SqlCommand("WebAgent_GetPlayerEdit", connection);
                selectCommand.CommandType = CommandType.StoredProcedure;
                selectCommand.CommandTimeout = this.TIME_OUT;
                selectCommand.Parameters.Add("@prmIdAgent", SqlDbType.Int, 8).Value = (object)prmIdAgent;
                selectCommand.Parameters.Add("@prmIdPlayer", SqlDbType.Int, 8).Value = (object)prmIdPlayer;
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand);
                dataSet = new DataSet();
                sqlDataAdapter.Fill(dataSet, "DataSet");
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }
            return dataSet;
        }

        private DataSet DBGetAgentRightList(int prmIdAgent, string prmRight)
        {
            DataSet dataSet = (DataSet)null;
            SqlConnection connection = new SqlConnection(AgentPlayerEdit.sConnString);
            try
            {
                connection.Open();
                SqlCommand selectCommand = new SqlCommand("Web_GetSelectAgentInformation", connection);
                selectCommand.CommandType = CommandType.StoredProcedure;
                selectCommand.CommandTimeout = this.TIME_OUT;
                if (prmRight == "")
                {
                    selectCommand.Parameters.Add("@prmSelect", SqlDbType.SmallInt).Value = (object)12;
                    selectCommand.Parameters.Add("@prmId", SqlDbType.Int).Value = (object)prmIdAgent;
                    selectCommand.Parameters.Add("@prmId2", SqlDbType.Int).Value = (object)0;
                    selectCommand.Parameters.Add("@prmInfo", SqlDbType.VarChar).Value = (object)"";
                }
                else
                {
                    selectCommand.Parameters.Add("@prmSelect", SqlDbType.SmallInt).Value = (object)13;
                    selectCommand.Parameters.Add("@prmId", SqlDbType.Int).Value = (object)prmIdAgent;
                    selectCommand.Parameters.Add("@prmId2", SqlDbType.Int).Value = (object)0;
                    selectCommand.Parameters.Add("@prmInfo", SqlDbType.VarChar).Value = (object)prmRight;
                }
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand);
                dataSet = new DataSet();
                sqlDataAdapter.Fill(dataSet, "DataSet");
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }
            return dataSet;
        }

        private bool DBUpdatePlayerInformation(
          bool prmUpdateRegionPassword,
          bool prmUpdateRegionStatus,
          bool prmUpdateRegionCredit,
          bool prmUpdateRegionWager,
          bool prmUpdateRegionTempCredit,
          bool prmUpdateRegionPlayerName,
          bool prmUpdateRegionPhoneNumber,
          bool prmUpdateRegionEmailAddress,
          bool prmUpdateRegionMarketingNotes,
          bool prmUpdateRegionCustomerServiceNotes,
          string prmPasswordOnline,
          string prmPassword,
          string prmEnable,
          short prmOnlineAccess,
          short prmEnableSports,
          short prmEnableRacing,
          short prmEnableCasino,
          short prmEnableCards,
          Decimal prmCreditLimit,
          Decimal prmMaxWager,
          Decimal prmMinWager,
          Decimal prmMaxWagerOnline,
          Decimal prmMinWagerOnline,
          Decimal prmTempCredit,
          string TempCreditExpire,
          long prmIdAgent,
          long prmIdPlayer,
          string prmName,
          string prmLastName,
          string prmLastName2,
          string prmIP,
          Decimal prmSettledFigure,
          string prmPhoneNumber,
          string prmEmailAddress,
          string prmNotes01,
          string prmNotes02,
          string prmNotes03,
          string prmNotes04,
          string prmNotes05,
          string prmNotes06)
        {
            SqlConnection connection = new SqlConnection(AgentPlayerEdit.sConnString);
            try
            {
                connection.Open();
                SqlCommand sqlCommand = new SqlCommand("WebAgent_SetPlayerEdit", connection);
                sqlCommand.CommandType = CommandType.StoredProcedure;
                sqlCommand.CommandTimeout = this.TIME_OUT;
                sqlCommand.Parameters.Add("@prmUpdateRegionPassword", SqlDbType.Bit).Value = (object)prmUpdateRegionPassword;
                sqlCommand.Parameters.Add("@prmUpdateRegionStatus", SqlDbType.Bit).Value = (object)prmUpdateRegionStatus;
                sqlCommand.Parameters.Add("@prmUpdateRegionCredit", SqlDbType.Bit).Value = (object)prmUpdateRegionCredit;
                sqlCommand.Parameters.Add("@prmUpdateRegionWager", SqlDbType.Bit).Value = (object)prmUpdateRegionWager;
                sqlCommand.Parameters.Add("@prmUpdateRegionTempCredit", SqlDbType.Bit).Value = (object)prmUpdateRegionTempCredit;
                sqlCommand.Parameters.Add("@prmUpdateRegionPlayerName", SqlDbType.Bit).Value = (object)prmUpdateRegionPlayerName;
                sqlCommand.Parameters.Add("@prmUpdateRegionPhoneNumber", SqlDbType.Bit).Value = (object)prmUpdateRegionPhoneNumber;
                sqlCommand.Parameters.Add("@prmUpdateRegionEmailAddr", SqlDbType.Bit).Value = (object)prmUpdateRegionEmailAddress;
                sqlCommand.Parameters.Add("@prmUpdateRegionMarkNotes", SqlDbType.Bit).Value = (object)prmUpdateRegionMarketingNotes;
                sqlCommand.Parameters.Add("@prmUpdateRegionCustSerNot", SqlDbType.Bit).Value = (object)prmUpdateRegionCustomerServiceNotes;
                sqlCommand.Parameters.Add("@prmPasswordOnline", SqlDbType.VarChar, 20).Value = (object)prmPasswordOnline;
                sqlCommand.Parameters.Add("@prmPassword", SqlDbType.VarChar, 20).Value = (object)prmPassword;
                sqlCommand.Parameters.Add("@prmEnable", SqlDbType.Char, 1).Value = (object)prmEnable;
                sqlCommand.Parameters.Add("@prmOnlineAccess", SqlDbType.Bit).Value = (object)prmOnlineAccess;
                sqlCommand.Parameters.Add("@prmEnableSports", SqlDbType.Bit).Value = (object)prmEnableSports;
                sqlCommand.Parameters.Add("@prmEnableRacing", SqlDbType.Bit).Value = (object)prmEnableRacing;
                sqlCommand.Parameters.Add("@prmEnableCasino", SqlDbType.Bit).Value = (object)prmEnableCasino;
                sqlCommand.Parameters.Add("@prmEnableCards", SqlDbType.Bit).Value = (object)prmEnableCards;
                sqlCommand.Parameters.Add("@prmCreditLimit", SqlDbType.Money).Value = (object)prmCreditLimit;
                sqlCommand.Parameters.Add("@prmMaxWager", SqlDbType.Money).Value = (object)prmMaxWager;
                sqlCommand.Parameters.Add("@prmMinWager", SqlDbType.Money).Value = (object)prmMinWager;
                sqlCommand.Parameters.Add("@prmMaxWagerOnline", SqlDbType.Money).Value = (object)prmMaxWagerOnline;
                sqlCommand.Parameters.Add("@prmMinWagerOnline", SqlDbType.Money).Value = (object)prmMinWagerOnline;
                sqlCommand.Parameters.Add("@prmTempCredit", SqlDbType.Money).Value = (object)prmTempCredit;
                sqlCommand.Parameters.Add("@TempCreditExpire", SqlDbType.DateTime).Value = (object)TempCreditExpire;
                sqlCommand.Parameters.Add("@prmIdAgent", SqlDbType.Int, 8).Value = (object)prmIdAgent;
                sqlCommand.Parameters.Add("@prmIdPlayer", SqlDbType.Int, 8).Value = (object)prmIdPlayer;
                sqlCommand.Parameters.Add("@prmName", SqlDbType.VarChar, 50).Value = (object)prmName;
                sqlCommand.Parameters.Add("@prmLastName", SqlDbType.VarChar, 50).Value = (object)prmLastName;
                sqlCommand.Parameters.Add("@prmLastName2", SqlDbType.VarChar, 50).Value = (object)prmLastName2;
                sqlCommand.Parameters.Add("@prmIP", SqlDbType.VarChar, 100).Value = (object)prmIP;
                sqlCommand.Parameters.Add("@prmSettledFigure", SqlDbType.Money).Value = (object)prmSettledFigure;
                sqlCommand.Parameters.Add("@prmPhoneNumber", SqlDbType.VarChar, 15).Value = (object)prmPhoneNumber;
                sqlCommand.Parameters.Add("@prmEmailAddress", SqlDbType.VarChar, 50).Value = (object)prmEmailAddress;
                sqlCommand.Parameters.Add("@prmNote1", SqlDbType.VarChar, (int)byte.MaxValue).Value = (object)prmNotes01;
                sqlCommand.Parameters.Add("@prmNote2", SqlDbType.VarChar, (int)byte.MaxValue).Value = (object)prmNotes02;
                sqlCommand.Parameters.Add("@prmNote3", SqlDbType.VarChar, (int)byte.MaxValue).Value = (object)prmNotes03;
                sqlCommand.Parameters.Add("@prmNote4", SqlDbType.VarChar, (int)byte.MaxValue).Value = (object)prmNotes04;
                sqlCommand.Parameters.Add("@prmNote5", SqlDbType.VarChar, (int)byte.MaxValue).Value = (object)prmNotes05;
                sqlCommand.Parameters.Add("@prmNote6", SqlDbType.VarChar, (int)byte.MaxValue).Value = (object)prmNotes06;
                sqlCommand.ExecuteNonQuery();
                return true;
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }
        }
    }
}
