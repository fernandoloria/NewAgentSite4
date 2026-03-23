using AgentSite4.ASP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AgentSite4.Report
{
    public partial class AgentDistributionEnhanced : BasePage, IRequiresSessionState
    {

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DateTime today = DateTime.Now;
                txtDateFrom.Text = today.AddDays(-7).ToString("MM/dd/yyyy");
            }

        }


        protected void btnSumit_Click(object sender, EventArgs e)
        {

        }

        protected void GridView1_DataBound(object sender, EventArgs e)
        {

        }
    }
}