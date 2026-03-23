using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.SessionState;
using AgentSite4.cASEnums;
using DGSinterface;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Xml;
using Newtonsoft.Json;

namespace AgentSite4.Services
{
    /// <summary>
    /// Summary description for PlayerAccess
    /// </summary>
    public class PlayerAccess : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {

            AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
            if (Common.HasRights(ReportPosition.PLAYERACCESS))
            {
                CResultAgentPlayerAccess agentPlayerAccess = new CResultAgentPlayerAccess();
                string prmIP = "";
                int prmIdPlayer = -1;
                string prmStartDate = DateTime.Today.AddDays(-1).ToString("MM/dd/yyyy");
                string prmEndDate = DateTime.Today.AddDays(1.0).ToString("MM/dd/yyyy");
                int subIdAgent = Convert.ToInt32(context.Session["SubIdAgent"].ToString());

                if (!String.IsNullOrEmpty(context.Request.Form["Date1"]))
                {
                    prmStartDate = context.Request.QueryString["Date1"];
                }
                if (!String.IsNullOrEmpty(context.Request.Form["Date2"]))
                {
                    prmEndDate = context.Request.QueryString["Date2"];
                }
                if (!String.IsNullOrEmpty(context.Request.Form["cPlayer"]))
                {
                    prmIdPlayer = Convert.ToInt32(context.Request.QueryString["cPlayer"]);
                }
                if (!String.IsNullOrEmpty(context.Request.Form["txtIP"]))
                {
                    prmIP = context.Request.QueryString["txtIP"];
                }


                context.Response.ContentType = "application/json";
                CResultAgentPlayerAccess playerAccessInfo = agentInstance.GetReportAgentPlayerAccessInfo(subIdAgent, prmIdPlayer, prmStartDate, prmEndDate, prmIP);
                if (playerAccessInfo.ErrorCode == CErrorCode.ErrorNone)
                {
                    context.Response.Write(JsonConvert.SerializeObject(playerAccessInfo));
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(playerAccessInfo.ErrorMsgKey));
                }

            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}