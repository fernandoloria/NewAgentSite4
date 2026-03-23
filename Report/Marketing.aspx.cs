using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;
using AgentSite4.cASEnums;

namespace AgentSite4.Report
{
    public partial class Marketing : BasePage, IRequiresSessionState
    {
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Common.HasRights(ReportPosition.AFFILIATEMANAGE))
            {
                this.lnkBanners.Visible = true;
                this.lnkTargets.Visible = true;
                this.lnkpideTargets.Visible = true;
                this.lnkpideBanners.Visible = true;
            }
            byte num = 0;
            if (this.Request.QueryString["op"] != null)
                num = byte.Parse(this.Request.QueryString["op"].ToString());
            switch (num)
            {
                case 0:
                    this.PH_Content.Controls.Add(this.Page.LoadControl("..\\controls\\" + this.Page.Theme + "\\BannerStats.ascx"));
                    break;
                case 1:
                    this.PH_Content.Controls.Add(this.Page.LoadControl("..\\controls\\" + this.Page.Theme + "\\Banners.ascx"));
                    break;
                case 2:
                    this.PH_Content.Controls.Add(this.Page.LoadControl("..\\controls\\" + this.Page.Theme + "\\BannerLinks.ascx"));
                    break;
                case 3:
                    this.PH_Content.Controls.Add(this.Page.LoadControl("..\\controls\\" + this.Page.Theme + "\\BannerTargets.ascx"));
                    break;
            }
        }
    }
}
