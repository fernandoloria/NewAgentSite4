using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AgentSite4.Services
{
    /// <summary>
    /// Summary description for MoveLines
    /// </summary>
    public class MoveLines : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("Hello World");
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