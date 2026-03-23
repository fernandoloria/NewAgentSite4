using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AgentSite4.Master
{
    public partial class Report : System.Web.UI.MasterPage
    {
        public Random rnd = new Random();
        protected void Page_Load(object sender, EventArgs e)
        {
            string currentPage = Path.GetFileName(Request.Url.AbsolutePath);
            string domainName = GetFormattedDomainName();
            Page.Title = domainName;

            if (currentPage != "LockScreen.aspx")
            {
                if (Session["Authenticated"] == null || !(bool)Session["Authenticated"])
                {
                    Response.Redirect("~/Report/LockScreen.aspx");
                }
            }
        }

        private string GetFormattedDomainName()
        {
            string host = Request.Url.Host;
            string cacheKey = "DomainName_" + host;
            string domainName = HttpContext.Current.Cache[cacheKey] as string;

            if (string.IsNullOrEmpty(domainName))
            {
                domainName = ExtractDomainName(host);
                domainName = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(domainName.Replace("-", " ")); // Format the domain name

                HttpContext.Current.Cache.Insert(cacheKey, domainName, null, DateTime.Now.AddMinutes(10), System.Web.Caching.Cache.NoSlidingExpiration); // Cache the domain name for 10 minutes
            }

            return domainName;
        }

        private string ExtractDomainName(string host)
        {
            string[] parts = host.Split('.');
            if (parts.Length > 2)
            {
                return parts[parts.Length - 3];
            }
            else if (parts.Length == 2)
            {
                return parts[0];
            }
            return host; 
        }
    }
}