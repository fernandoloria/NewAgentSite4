using AgentSite4.ASP;
using DGSinterface;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AgentSite4.Controls
{
    public partial class WelcomeForm : System.Web.UI.UserControl
    {
        private string sCurrent;
        private string sThisWeek;
        private string sLastWeek;
        private string sMakeUp;
        private string sLastMU;
        private string sErrorMsg;
        private string sMessage;
        private string sCurrentAgent;
        private string sCurrency;
        private string sPackageBal;
        private string sPackageThisWeek;
        private string sPackageLastWeek;
        private string sTotalPerHead;
        private string sWeekPerHead;

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        public string LastMakeUp => this.sLastMU;

        public string Current => this.sCurrent;

        public string ThisWeek => this.sThisWeek;

        public string LastWeek => this.sLastWeek;

        public string MakeUp => this.sMakeUp;

        public string ErrorMsg => this.sErrorMsg;

        public string Message => this.sMessage;

        public string CurrentAgent => this.sCurrentAgent;

        public string Currency => this.sCurrency;

        public string PackageBalance => this.sPackageBal;

        public string PackageThisWeek => this.sPackageThisWeek;

        public string PackageLastWeek => this.sPackageLastWeek;

        public string TotalPerHead => this.sTotalPerHead;

        public string WeekPerHead => this.sWeekPerHead;


        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                bool.Parse(this.Session["Validated"].ToString());
            }
            catch
            {
                this.Response.Redirect("../Logout.aspx");
            }
            System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo(Session["CultureInfo"].ToString());
            System.Threading.Thread.CurrentThread.CurrentCulture = ci;
            System.Threading.Thread.CurrentThread.CurrentUICulture = ci;

            this.LoadData();
        }

        private void LoadData()
        {
            long prmIdAgent = long.Parse(this.Session["SubIdAgent"].ToString());
            CResultAgentBalance cresultAgentBalance = new CResultAgentBalance();
           AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
            try
            {
                CResultAgentBalance balance = agentInstance.GetBalance(prmIdAgent);
                string key = prmIdAgent + ",CResultAgentBalance";
                if (HttpContext.Current.Cache[key] != null)
                {
                    balance = (CResultAgentBalance)HttpContext.Current.Cache[key];
                }
                else
                {
                    balance = agentInstance.GetBalance(prmIdAgent);
                    HttpContext.Current.Cache.Insert(key, balance, null, DateTime.Now.AddMinutes(1), System.Web.Caching.Cache.NoSlidingExpiration);

                }
                if (balance.ErrorCode == CErrorCode.ErrorNone)
                {
                    this.sCurrent = double.Parse(balance.CurrentBalance.ToString()).ToString("#,###,##0;-#,###,##0;0");
                    this.sThisWeek = double.Parse(balance.ThisWeek.ToString()).ToString("#,###,##0;#,-###,##0;0");
                    this.sLastWeek = double.Parse(balance.LastWeek.ToString()).ToString("#,###,##0;#,-###,##0;0");
                    this.sMakeUp = double.Parse(balance.MakeUp.ToString()).ToString("#,###,##0;#,-###,##0;0");
                    this.sLastMU = double.Parse(balance.LastWeekMakeUp.ToString()).ToString("#,###,##0;-#,###,##0;0");
                    this.sPackageBal = double.Parse(balance.PackageBalance.ToString()).ToString("#,###,##0;-#,###,##0;0");
                    this.sPackageThisWeek = double.Parse(balance.PackageThisWeek.ToString()).ToString("#,###,##0;-#,###,##0;0");
                    this.sPackageLastWeek = double.Parse(balance.PackageLastWeek.ToString()).ToString("#,###,##0;-#,###,##0;0");
                    this.sTotalPerHead = double.Parse(balance.TotalPerHead.ToString()).ToString("#,###,##0;-#,###,##0;0");
                    this.sWeekPerHead = double.Parse(balance.WeekPerHead.ToString()).ToString("#,###,##0;-#,###,##0;0");
                    this.sMessage = balance.OnlineMessage;
                    this.sCurrentAgent = this.Session["SubAgent"].ToString();
                    this.sCurrency = balance.Currency;
                }
                else if (balance.ErrorCode == CErrorCode.ErrorValidation)
                    this.Response.Redirect("../Logout.aspx");
                else
                    this.sErrorMsg = balance.ErrorMsg;
            }
            catch
            {
                this.sErrorMsg = ConfigurationManager.AppSettings["ErrorLoginRT"].ToString();
            }
        }
    }

}