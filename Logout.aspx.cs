using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Profile;
using System.Web.SessionState;

namespace AgentSite4
{
    public partial class Logout : BasePage, IRequiresSessionState
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("~/Default.aspx");
            }
        }
    }
}