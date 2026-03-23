using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Remoting;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using DGSinterface;

namespace AgentSite4
{
    public class Global : System.Web.HttpApplication
    {
        public override void Init()
        {
           // CDgsHelper.Instance.ConfigureDGSRemoting(HttpRuntime.AppDomainAppPath + "web.config");
        }

        protected void Application_Start(object sender, EventArgs e)
        {
          //  RemotingConfiguration.Configure(HttpRuntime.AppDomainAppPath + "web.config", false);
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}