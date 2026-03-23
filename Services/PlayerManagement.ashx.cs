using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Diagnostics;
using AgentSite4.ASP;
using AgentSite4.cASEnums;
using DGSinterface;
using System.Web.SessionState;

namespace AgentSite4.Services
{
    /// <summary>
    /// Summary description for PlayerManagement
    /// </summary>
    public class PlayerManagement : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
                if (Common.HasRights(ReportPosition.PLAYERMANAGEMENT))
                {
                    long prmIdAgent = long.Parse(context.Session["SubIdAgent"].ToString());
                    long prmDisIdAgent = long.Parse(context.Session["IdAgent"].ToString());
                    bool prmIsDistributor = bool.Parse(context.Session["IsDistributor"].ToString());
                    string prmAgent = context.Session["SubAgent"].ToString();
                    CResultPlayerManagement playerManagement = agentInstance.GetReportPlayerManagement(prmDisIdAgent, prmIdAgent, prmIsDistributor, prmAgent);
                    if (playerManagement.ErrorCode == CErrorCode.ErrorNone)
                    {
                        context.Response.ContentType = "application/json";
                        context.Response.Write(JsonConvert.SerializeObject(playerManagement, Formatting.None));
                    }
                }
            }
            catch (Exception ex)
            {
                ErrorResponse errorResponse = new ErrorResponse();
                errorResponse.Error = ex.Message;
                context.Response.Write(JsonConvert.SerializeObject(errorResponse, Formatting.None));
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