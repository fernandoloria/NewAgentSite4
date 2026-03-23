using AgentSite4.ASP;
using DGSinterface;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Profile;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

namespace AgentSite4.Controls
{
    public partial class LoginForm : System.Web.UI.UserControl
    {

        private string sErrorMsg;
        private int nCountLogin;

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

        public string ErrorMsg
        {
            get
            {
                return this.sErrorMsg;
            }
        }

        protected void Page_Inet(object sender, EventArgs e)
        {
            divError.Visible = false;
        } 
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!this.Page.IsPostBack)
                return;
            ++this.nCountLogin;
            this.DoLogin(this.Request.Form["Account"], this.Request.Form["Password"]);
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            string prmLoginName = "";
            string prmPassword = "";
            if (this.Request.Form["Account"] != null)
                prmLoginName = this.Request.Form["Account"];
            if (this.Request.Form["Password"] != null)
                prmPassword = this.Request.Form["Password"];
            if (!(prmLoginName != "") || !(prmPassword != "") || this.nCountLogin >= 1)
                return;
            this.DoLogin(prmLoginName, prmPassword);
        }

        public void DoLogin(string prmLoginName, string prmPassword)
        {
            try
            {
                AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
            
                string clientIp = Common.GetClientIP();
                bool prmCheckSession = bool.Parse(ConfigurationManager.AppSettings["CheckSession"].ToString());
                if (agentInstance != null)
                {
                    CResultAgentLogin cresultAgentLogin1 = new CResultAgentLogin();
                    CResultAgentLogin cresultAgentLogin2 = agentInstance.Login(prmLoginName, prmPassword, clientIp, prmCheckSession, LoginForm.GetGeolocation(clientIp));
                    if (cresultAgentLogin2.ErrorCode == CErrorCode.ErrorNone)
                    {

                        if (cresultAgentLogin2.ResetPassword)
                        {
                            this.Response.Redirect("ResetPassword.aspx");
                        }
                        else
                        {
                            string str1 = ConfigurationManager.AppSettings["RestrictedByBook"].ToString();
                            bool flag = false;
                            if (str1 != string.Empty)
                            {
                                string str2 = str1;
                                char[] chArray = new char[1] { ',' };
                                foreach (string str3 in str2.Split(chArray))
                                {
                                    if (str3.Trim() == cresultAgentLogin2.IdBook.ToString().Trim())
                                    {
                                        flag = true;
                                        break;
                                    }
                                }
                            }
                            else
                                flag = true;
                            if (flag)
                            {
                                FormsAuthentication.SetAuthCookie(prmLoginName, true);
                                this.Session["Authenticated"] = true;
                                this.Session["userdata"] = (object)cresultAgentLogin2;
                                this.Session["IdAgent"] = (object)cresultAgentLogin2.IdAgent.ToString();
                                this.Session["SubIdAgent"] = (object)cresultAgentLogin2.IdAgent.ToString();
                                this.Session["Agent"] = (object)cresultAgentLogin2.Agent.ToString().ToUpper();
                                this.Session["SubAgent"] = (object)cresultAgentLogin2.Agent.ToString().ToUpper();
                                this.Session["IsDistributor"] = (object)cresultAgentLogin2.IsDistributor.ToString();
                                this.Session["Password"] = (object)prmPassword;
                                this.Session["Validated"] = (object)true;
                                this.Session["IP"] = (object)clientIp;
                                this.Session["nLineType"] = (object)"-1";
                                this.Session["IdSport"] = (object)"";
                                this.Session["AgentRights"] = (object)0;
                                this.Session["SubAgentRights"] = (object)0;
                                this.Session["AgentIdLineType"] = (object)cresultAgentLogin2.IdLineType.ToString();
                                this.Session["IdCurrency"] = (object)cresultAgentLogin2.IdCurrency.ToString();
                                SetAgentLanguageSession(cresultAgentLogin2.IdAgent);
                                this.Session["Distributor"] = (object)cresultAgentLogin2.Distributor.ToString();
                                ulong prmMasterRight = 0;
                                ulong prmSubAgentRight = 0;
                                if (agentInstance.AgentSecurityRights((long)cresultAgentLogin2.IdAgent, (long)cresultAgentLogin2.IdAgent, out prmMasterRight, out prmSubAgentRight))
                                {
                                    Security.AgentRights.Load();
                                    this.Session["AgentRights"] = (object)prmMasterRight;
                                    this.Session["SubAgentRights"] = (object)prmSubAgentRight;
                                }

                                this.Response.Redirect("~/Report/Welcome.aspx");
                            }
                            else
                                this.sErrorMsg = ConfigurationManager.AppSettings["BookNotAccess"].ToString();
                        }
                    }
                    else
                        this.sErrorMsg = cresultAgentLogin2.ErrorMsg;
                }
                else
                    this.sErrorMsg = ConfigurationManager.AppSettings["ErrorLoginCO"].ToString();
            }
            catch (Exception ex)
            {
                this.sErrorMsg = ex.ToString();
            }
            if (this.sErrorMsg != null)
            {
                divError.Visible = true;
            }
        }

        protected void SetAgentLanguageSession(int idAgent)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("Select a.IdLanguage,l.CultureInfo from Agent a inner join Language l on a.IdLanguage = l.IdLanguage where idAgent = @prmIdAgent", Cnn);
                comm.CommandType = CommandType.Text;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch { }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            if (table.Rows.Count > 0)
            {
                this.Session["IdLanguage"] = Convert.ToInt32(table.Rows[0]["IdLanguage"]);
                this.Session["CultureInfo"] = table.Rows[0]["CultureInfo"].ToString();
            }
            else
            {
                this.Session["IdLanguage"] = 0;
                this.Session["CultureInfo"] = "en-US";
            }
            //System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo(Session["CultureInfo"].ToString());
            //System.Threading.Thread.CurrentThread.CurrentCulture = ci;
            //System.Threading.Thread.CurrentThread.CurrentUICulture = ci;

            return;
        }

        private static string GetGeolocation(string prmIP)
        {
            string requestUriString = "http://ip-api.com/xml/" + prmIP;
            string str = "";
            bool flag = false;
            try
            {
                if (ConfigurationManager.AppSettings["GeoActivate"] != null)
                    flag = bool.Parse(ConfigurationManager.AppSettings["GeoActivate"]);
                if (flag)
                {
                    StreamReader streamReader = new StreamReader(WebRequest.Create(requestUriString).GetResponse().GetResponseStream());
                    string end = streamReader.ReadToEnd();
                    streamReader.Close();
                    streamReader.Dispose();
                    using (TextReader reader = (TextReader)new StringReader(end))
                    {
                        using (DataSet dataSet = new DataSet())
                        {
                            int num = (int)dataSet.ReadXml(reader);
                            if (dataSet.Tables[0].Rows[0][0].ToString().Trim().ToLower() == "success")
                            {
                                str = str + dataSet.Tables[0].Rows[0][1].ToString() + " ";
                                str = str + "[" + dataSet.Tables[0].Rows[0][2].ToString() + "], ";
                                str = str + dataSet.Tables[0].Rows[0][5].ToString() + " ";
                                str = str + "[" + dataSet.Tables[0].Rows[0][3].ToString() + "], ";
                                str = str + "Lat: " + dataSet.Tables[0].Rows[0][7].ToString() + ", ";
                                str = str + "Lon: " + dataSet.Tables[0].Rows[0][8].ToString();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Log(nameof(GetGeolocation), ex.Message);
            }
            return str;
        }
    }

}