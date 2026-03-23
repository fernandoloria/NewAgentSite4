using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;

namespace AgentSite4.Report
{
    public partial class ErrorHandle : BasePage, IRequiresSessionState
    {
        private string strErrorMsg;
        private int strBack;
        public string ErrorMsg
        {
            get
            {
                return this.strErrorMsg;
            }
        }

        public int Back
        {
            get
            {
                return this.strBack;
            }
        }
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

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
            this.LoadData();
        }

        private void LoadData()
        {
            if (this.Request.QueryString["Er"] != null)
                this.LoggerSite(this.Request.QueryString["Er"].ToString());
            if (!bool.Parse(ConfigurationManager.AppSettings["ShowErrorStandar"].ToString()))
            {
                if (this.Request.QueryString["Er"] != null)
                {
                    if (this.Request.QueryString["Er"].ToString().IndexOf("_") != -1)
                    {
                        string[] strArray = this.Request.QueryString["Er"].ToString().Split("_".ToCharArray());
                        this.strErrorMsg = strArray.GetValue(0).ToString();
                        this.strBack = int.Parse(strArray.GetValue(1).ToString());
                    }
                    else
                    {
                        this.strErrorMsg = this.Request.QueryString["Er"].ToString();
                        this.strBack = 1;
                    }
                }
                else
                {
                    this.strErrorMsg = ConfigurationManager.AppSettings["ErrorMsg"].ToString();
                    this.strBack = 1;
                }
            }
            else
            {
                this.strErrorMsg = this.Request.QueryString["Validate"] == null ? ConfigurationManager.AppSettings["ErrorMsg"].ToString() : this.Request.QueryString["Validate"].ToString();
                this.strBack = 1;
            }
        }

        private void LoggerSite(string Msg)
        {
            string path = Environment.SystemDirectory + string.Format("\\logfiles\\dgs\\web\\agentsite\\{0:yyyy_MM_dd}-Agent_log.txt", (object)DateTime.Today);
            try
            {
                StreamWriter streamWriter = File.AppendText(path);
                streamWriter.WriteLine(string.Format("{0:yyyy/MM/dd HH:mm:ss} {1:s} \r\n {2:s}", (object)DateTime.Now, (object)"Site Error", (object)Msg));
                streamWriter.WriteLine("");
                streamWriter.Close();
            }
            catch
            {
            }
        }
    }
}
