using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;
using AgentSite4.Controls;

namespace AgentSite4.Report
{
    public partial class Welcome : BasePage, IRequiresSessionState
    {
        protected WelcomeForm WelcomeControl;
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;


        protected void Page_Load(object sender, EventArgs e)
        {
        }
    }
}
