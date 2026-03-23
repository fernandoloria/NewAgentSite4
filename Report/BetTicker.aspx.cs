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
    public partial class BetTicker : BasePage, IRequiresSessionState
    {

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Init(object sender, EventArgs e)
        {
            HttpCookie myCookie = Request.Cookies["minAmount"];
            if (myCookie != null)
            {
                txtMinAmount.Text = myCookie.Value;
            }
            else
            {
                //Cookie not set.
            }

        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void txtMinAmount_TextChanged(object sender, EventArgs e)
        {

        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            int minAmount = 0;
            if (txtMinAmount.Text != "")
            {
                minAmount = Convert.ToInt32(txtMinAmount.Text);
            }

            HttpCookie myCookie = new HttpCookie("minAmount");
            myCookie.Value = minAmount.ToString();
            myCookie.Expires = DateTime.Now.AddDays(15d);
            Response.Cookies.Add(myCookie);
        }
    }
}