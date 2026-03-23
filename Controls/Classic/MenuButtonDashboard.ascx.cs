using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace AgentSite4.Controls
{
    public class DashboardReportItem
    {
        public int IdReport { get; set; }
        public string ReportName { get; set; }
        public string ReportURL { get; set; }
        public int ReportOrder { get; set; }
        public string Css { get; set; }
        public string Icon { get; set; }
    }

    public partial class MenuButtonDashboard : System.Web.UI.UserControl
    {
        protected List<DashboardReportItem> reportList;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                int idAgent = 0;
                if (this.Context != null && this.Context.Session != null && this.Context.Session["idAgent"] != null)
                {
                    int.TryParse(Convert.ToString(this.Context.Session["idAgent"]), out idAgent);
                }

                List<DashboardReportItem> items = this.GetDashboardReportsFromCacheOrDb(idAgent);

                this.filesRepeater.DataSource = items;
                this.filesRepeater.DataBind();
            }
        }

        private List<DashboardReportItem> GetDashboardReportsFromCacheOrDb(int idAgent)
        {
            string cacheKey = "DashboardMenu_" + idAgent.ToString();

            object cached = this.Session[cacheKey];
            if (cached != null)
            {
                List<DashboardReportItem> cachedList = cached as List<DashboardReportItem>;
                if (cachedList != null)
                {
                    return cachedList;
                }
            }

            List<DashboardReportItem> list = new List<DashboardReportItem>();
            string cs = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            using (SqlConnection cnn = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("dbo.AgentMenuDashboard_Get", cnn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter p1 = cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int);
                p1.Value = idAgent;

                cnn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        DashboardReportItem item = new DashboardReportItem();
                        item.IdReport = r["idReport"] != DBNull.Value ? Convert.ToInt32(r["idReport"]) : 0;
                        item.ReportName = r["reportName"] != DBNull.Value ? Convert.ToString(r["reportName"]) : string.Empty;
                        item.ReportURL = r["reportURL"] != DBNull.Value ? Convert.ToString(r["reportURL"]) : string.Empty;
                        item.ReportOrder = r["reportOrder"] != DBNull.Value ? Convert.ToInt32(r["reportOrder"]) : 0;
                        item.Css = r["css"] != DBNull.Value ? Convert.ToString(r["css"]) : "tile-slate";
                        item.Icon = r["icon"] != DBNull.Value ? Convert.ToString(r["icon"]) : "feather-file";
                        list.Add(item);
                    }
                }
            }

            this.Session[cacheKey] = list;

            return list;
        }

        protected void filesRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

            DashboardReportItem data = e.Item.DataItem as DashboardReportItem;
            if (data == null) return;

            HtmlAnchor lnk = e.Item.FindControl("lnkReport") as HtmlAnchor;
            HtmlGenericControl ico = e.Item.FindControl("ico") as HtmlGenericControl;
            HtmlGenericControl txt = e.Item.FindControl("txt") as HtmlGenericControl;

            if (lnk == null || ico == null || txt == null) return;

            // Texto
            string safeName = this.Server.HtmlEncode(string.IsNullOrEmpty(data.ReportName) ? "(unnamed)" : data.ReportName);
            txt.InnerText = safeName;

            // URL robusta
            string url = data.ReportURL ?? string.Empty;
            string navigate;
            if (url.StartsWith("~/", StringComparison.Ordinal) || url.StartsWith("/", StringComparison.Ordinal))
                navigate = this.ResolveUrl(url);
            else
                navigate = this.ResolveUrl("~/Report/" + url.TrimStart('/'));
            lnk.HRef = navigate;

            // Color Bootstrap (bg-*)
            string bgClass = string.IsNullOrEmpty(data.Css) ? "bg-primary" : data.Css.Trim(); // azul por defecto
            string textClass = NeedsDarkText(bgClass) ? "text-dark" : "text-white";
            lnk.Attributes["class"] = "dash-btn w-100 " + bgClass + " " + textClass;

            // Icono Font Awesome
            string iconClass = NormalizeFaIcon(data.Icon);
            ico.Attributes["class"] = iconClass + " fa-2xl";
        }

        private static bool NeedsDarkText(string bgClass)
        {
            if (string.IsNullOrEmpty(bgClass)) return false;
            string k = bgClass.ToLowerInvariant();
            return k.Contains("bg-warning") || k.Contains("bg-info") || k.Contains("bg-light") || k.Contains("bg-white");
        }

        private static string NormalizeFaIcon(string icon)
        {
            if (string.IsNullOrEmpty(icon)) return "fa-solid fa-file";
            string trimmed = icon.Trim();

            if (trimmed.StartsWith("fa-solid", StringComparison.OrdinalIgnoreCase) ||
                trimmed.StartsWith("fa-regular", StringComparison.OrdinalIgnoreCase) ||
                trimmed.StartsWith("fa-light", StringComparison.OrdinalIgnoreCase) ||
                trimmed.StartsWith("fa-thin", StringComparison.OrdinalIgnoreCase) ||
                trimmed.StartsWith("fa-duotone", StringComparison.OrdinalIgnoreCase) ||
                trimmed.StartsWith("fa-brands", StringComparison.OrdinalIgnoreCase))
            {
                return trimmed;
            }

            if (trimmed.StartsWith("fa-", StringComparison.OrdinalIgnoreCase))
                return "fa-solid " + trimmed;

            return "fa-solid fa-" + trimmed;
        }
    }
}
