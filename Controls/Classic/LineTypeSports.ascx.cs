using AgentSite4.ASP;
using AgentSite4;
using DGSinterface;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.cASEnums;

namespace AgentSite4.Controls
{
    public partial class LineTypeSports : System.Web.UI.UserControl
    {

        protected ScriptManager ScriptManager1;
        protected DropDownList CmbLineType;
        protected Schedule CRLSchedule;
        protected UpdatePanel UpdatePanel1;
        private string strSportList;

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

        public string SportList
        {
            get
            {
                return this.strSportList;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            this.LoadData();
        }

        private void LoadData()
        {
            try
            {
               AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
                if (Common.HasRights(ReportPosition.MOVELINES))
                {
                    long IdAgent = long.Parse(this.Session["IdAgent"].ToString());
                    long LineType1 = -1;
                    if (this.Request.QueryString["LT"] != null)
                        LineType1 = long.Parse(this.Request.QueryString["LT"].ToString());
                    long LineType2 = this.LoadCmb(IdAgent, LineType1, agentInstance);
                    this.strSportList = this.LoadSports(IdAgent, LineType2, agentInstance);
                }
                else
                    this.Response.Redirect("../Logout.aspx");
            }
            catch (Exception ex)
            {
                this.Response.Redirect("../Report/ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
        }

        private long LoadCmb(long IdAgent, long LineType, IAgent oAgent)
        {
            CResultGetAgentLineType getAgentLineType = new CResultGetAgentLineType();
            long num = -1;
            bool flag = false;
            try
            {
                CResultGetAgentLineType agentLineType = oAgent.GetAgentLineType(IdAgent);
                if (agentLineType.ErrorCode == CErrorCode.ErrorNone)
                {
                    this.CmbLineType.Items.Clear();
                    ListItem listItem1 = new ListItem();
                    listItem1.Text = "-- Choose a Line Type --";
                    listItem1.Value = "-1";
                    if (LineType == -1L)
                        listItem1.Selected = true;
                    this.CmbLineType.Items.Add(listItem1);
                    for (int index = 0; index < agentLineType.LineTypeList.Count; ++index)
                    {
                        ListItem listItem2 = new ListItem();
                        listItem2.Text = agentLineType.LineTypeList[index].Description.ToString();
                        listItem2.Value = agentLineType.LineTypeList[index].IdLineType.ToString();
                        if (long.Parse(agentLineType.LineTypeList[index].IdLineType.ToString()) == LineType)
                        {
                            listItem2.Selected = true;
                            num = LineType;
                            flag = true;
                        }
                        listItem2.Attributes.Add("onclick", "ChangeLT('" + agentLineType.LineTypeList[index].IdLineType.ToString() + "')");
                        this.CmbLineType.Items.Add(listItem2);
                    }
                    if (!flag)
                    {
                        if (LineType != -1L)
                            this.Response.Redirect("../Logout.aspx");
                    }
                }
                else if (agentLineType.ErrorCode == CErrorCode.ErrorValidation)
                    this.Response.Redirect("../Logout.aspx");
                else
                    this.Response.Redirect("../Report/ErrorHandle.aspx");
            }
            catch (Exception ex)
            {
                this.Response.Redirect("../Report/ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
            return num;
        }

        private string LoadSports(long IdAgent, long LineType, IAgent oAgent)
        {
            CResultGetAgentSport cresultGetAgentSport = new CResultGetAgentSport();
            string str1 = "";
            try
            {
                CResultGetAgentSport agentSport = oAgent.GetAgentSport(IdAgent, LineType);
                if (agentSport.ErrorCode == CErrorCode.ErrorNone)
                {
                    string str2 = "<ul class=" + ConfigurationManager.AppSettings["SportsSelection"].ToString() + ">";
                    for (int index = 0; index < agentSport.SportList.Count; ++index)
                    {
                        switch (agentSport.SportList[index].Sport)
                        {
                            case "NFL":
                                str2 = str2 + "<li><a href=\"MoveLine.aspx?LT=" + (object)LineType + "&SP=NFL\" title=\"NFL Football\">NFL</a></li>";
                                break;
                            case "NBA":
                                str2 = str2 + "<li><a href=\"MoveLine.aspx?LT=" + (object)LineType + "&SP=NBA\" title=\"NBA Basketball\">NBA</a></li>";
                                break;
                            case "MLB":
                                str2 = str2 + "<li><a href=\"MoveLine.aspx?LT=" + (object)LineType + "&SP=MLB\" title=\"ML Baseball\">MLB</a></li>";
                                break;
                            case "MU":
                                str2 = str2 + "<li><a href=\"MoveLine.aspx?LT=" + (object)LineType + "&SP=MU\" title=\"Matchups\">MU</a></li>";
                                break;
                            case "TNT":
                                str2 = str2 + "<li><a href=\"MoveLine.aspx?LT=" + (object)LineType + "&SP=TNT\" title=\"Tournaments\">TNT</a></li>";
                                break;
                            case "CFB":
                                str2 = str2 + "<li><a href=\"MoveLine.aspx?LT=" + (object)LineType + "&SP=CFB\" title=\"Col. Football\">CFB</a></li>";
                                break;
                            case "CBB":
                                str2 = str2 + "<li><a href=\"MoveLine.aspx?LT=" + (object)LineType + "&SP=CBB\" title=\"Col. Basketball\">CBB</a></li>";
                                break;
                            case "NHL":
                                str2 = str2 + "<li><a href=\"MoveLine.aspx?LT=" + (object)LineType + "&SP=NHL\" title=\"NHL Hockey\">NHL</a></li>";
                                break;
                            case "SOC":
                                str2 = str2 + "<li><a href=\"MoveLine.aspx?LT=" + (object)LineType + "&SP=SOC\" title=\"Soccer\">SOC</a></li>";
                                break;
                            case "PROP":
                                str2 = str2 + "<li><a href=\"MoveLine.aspx?LT=" + (object)LineType + "&SP=PROP\" title=\"Propositions\">PROP</a></li>";
                                break;
                            case "ESOC":
                                str2 = str2 + "<li><a href=\"MoveLine.aspx?LT=" + (object)LineType + "&SP=ESOC\" title=\"European Soccer\">ESOC</a></li>";
                                break;
                        }
                    }
                    str1 = str2 + "</ul>";
                }
                else if (agentSport.ErrorCode == CErrorCode.ErrorValidation)
                    this.Response.Redirect("../Logout.aspx");
                else
                    this.Response.Redirect("../Report/ErrorHandle.aspx");
            }
            catch (Exception ex)
            {
                str1 = ex.Message.ToString();
            }
            return str1;
        }

        public void Select_ChangeLT(object sender, EventArgs e)
        {
        }
    }
}