using System;
using System.Configuration;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;

namespace AgentSite4
{
    public class BasePage : Page
    {
        private static string _PageTheme = null;

        private static string PageTheme
        {
            get
            {
                if (string.IsNullOrEmpty(_PageTheme))
                {
                    var themeFromAppSettings = ConfigurationManager.AppSettings["ThemeName"];
                    if (!string.IsNullOrEmpty(themeFromAppSettings))
                    {
                        _PageTheme = themeFromAppSettings.Trim();
                    }
                    else
                    {
                        var pages = WebConfigurationManager.GetSection("system.web/pages") as PagesSection;
                        _PageTheme = (pages != null && !string.IsNullOrEmpty(pages.Theme))
                            ? pages.Theme.Trim()
                            : "Classic";
                    }
                }
                return _PageTheme;
            }
            set { _PageTheme = value; }
        }

        private string GetAppPath()
        {
            var ap = Request.ApplicationPath;
            if (!ap.EndsWith("/", StringComparison.Ordinal)) ap += "/";
            return ap.ToLowerInvariant();
        }

        private bool IsRestricted(string[] segments)
        {
            bool restricted = true;
            string acc = "";
            for (int i = 0; i < segments.Length; i++)
            {
                if (segments[i].IndexOf(".", StringComparison.Ordinal) == -1)
                    acc += segments[i];
            }

            string lower = acc.ToLowerInvariant();
            if (!(lower == GetAppPath() + "frames/") &&
                !(lower == GetAppPath() + "movelines/") &&
                !(lower == GetAppPath() + "report/") &&
                !(lower == GetAppPath() + "popup/") &&
                !(lower == GetAppPath() + "agentlines/"))
            {
                restricted = false;
            }
            return restricted;
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            if ((Session["Validated"] != null && (bool)Session["Validated"]) || !IsRestricted(Request.Url.Segments))
            {
                var ciName = (Session["CultureInfo"] as string) ?? "en-US";
                var ci = new System.Globalization.CultureInfo(ciName);
                System.Threading.Thread.CurrentThread.CurrentCulture = ci;
                System.Threading.Thread.CurrentThread.CurrentUICulture = ci;
                return;
            }

            Response.Redirect(GetAppPath() + "Logout.aspx");
        }

        protected override void OnPreInit(EventArgs e)
        {
            base.OnPreInit(e);
            if (MasterPageFile == null) return;

            string absPath = Request.Url.AbsolutePath;

            string themeFolder = PageTheme;

            if (absPath.IndexOf("report", StringComparison.OrdinalIgnoreCase) >= 0)
                MasterPageFile = "~/Master/" + themeFolder + "/Report.master";
            else if (absPath.IndexOf("movelines", StringComparison.OrdinalIgnoreCase) >= 0)
                MasterPageFile = "~/Master/" + themeFolder + "/MoveLines.master";
            else if (absPath.IndexOf("agentlines", StringComparison.OrdinalIgnoreCase) >= 0)
                MasterPageFile = "~/Master/" + themeFolder + "/AgentLines.master";
            else if (absPath.IndexOf("popup", StringComparison.OrdinalIgnoreCase) >= 0)
                MasterPageFile = "~/Master/" + themeFolder + "/Popup.master";
            else if (absPath.IndexOf("frames", StringComparison.OrdinalIgnoreCase) >= 0)
                MasterPageFile = "";
            else
                MasterPageFile = "~/Master/" + themeFolder + "/Home.master";
        }
    }
}
