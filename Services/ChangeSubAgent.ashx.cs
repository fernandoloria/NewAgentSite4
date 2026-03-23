using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace AgentSite4.Services
{
    /// <summary>
    /// Summary description for ChangeSubAgent
    /// </summary>
    public class ChangeSubAgent : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            string subAgentID = "";
            if (String.IsNullOrEmpty(context.Request.Form["id"]))
            {
                subAgentID = context.Request.QueryString["182mslf84mdls"];
            }
            else
            {
                subAgentID = context.Request.Form["id"];
            }
            string message = subAgentID;

            DataTable table = new DataTable();

            if (context.Session["GetHierarchy"] != null)
            {
                table = (DataTable)context.Session["GetHierarchy"];
            }


            DataRow[] foundRows = table.Select("Id = " + subAgentID);

            foreach (DataRow row in foundRows)
            {
                string type = row["Type"].ToString();
                if (type == "M" || type == "A" || type == "D")
                {
                    context.Session["SubIdAgent"] = Convert.ToInt32(row["Id"]);
                    context.Session["SubAgent"] = row["Account"].ToString();
                    context.Session.Remove("GetHierarchy");
                    message = "success";
                    break;
                }
            }

            context.Response.ContentType = "application/json";
            context.Response.Write(JsonConvert.SerializeObject(message, Formatting.None));
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