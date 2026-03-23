using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Xml;
using AgentSite4.ASP;
using AgentSite4.cASEnums;
using DGSinterface;
using System.Globalization;
using System.Text.RegularExpressions;

namespace AgentSite4.Report
{
    public partial class OpenBets : BasePage, IRequiresSessionState
    {
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {
            this.LoadData();
        }

        private void LoadData()
        {
            try
            {
                System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo(Session["CultureInfo"].ToString());
                System.Threading.Thread.CurrentThread.CurrentCulture = ci;
                System.Threading.Thread.CurrentThread.CurrentUICulture = ci;
                AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
                bool canDeleteAnytime = Security.AgentRights.Has("DELETEBETS");
                bool canDeleteBefore = Security.AgentRights.Has("DELETEBETSBEFORESTARTTIME");


                int num = int.Parse(ConfigurationManager.AppSettings["OpenBetsRecord"].ToString());
                if (Common.HasRights(ReportPosition.OPENBETS))
                {
                    CResultPlayerOpenBet cresultPlayerOpenBet = new CResultPlayerOpenBet();
                    int prmWagerType = -1;
                    int prmRecsPerPage = num;
                    string prmIdSport = "All";
                    long prmIdPlayer = -1;
                    short prmIdCurrency = short.Parse(this.Session["IdCurrency"].ToString());
                    long prmIdAgent = long.Parse(this.Session["SubIdAgent"].ToString());
                    if (this.IsPostBack)
                    {
                        if (this.Request.Form["cWagerType"] != null)
                            prmWagerType = int.Parse(this.Request.Form["cWagerType"].ToString());
                        if (this.Request.Form["cIdSport"] != null)
                            prmIdSport = this.Request.Form["cIdSport"].ToString();
                        if (this.Request.Form["cPlayer"] != null)
                            prmIdPlayer = long.Parse(this.Request.Form["cPlayer"].ToString());
                    }
                    else
                    {
                        if (this.Request.QueryString["WagerType"] != null)
                            prmWagerType = int.Parse(this.Request.QueryString["WagerType"].ToString());
                        if (this.Request.QueryString["IdSport"] != null)
                            prmIdSport = this.Request.QueryString["IdSport"].ToString();
                        if (this.Request.QueryString["IdPlayer"] != null)
                            prmIdPlayer = long.Parse(this.Request.QueryString["IdPlayer"].ToString());
                    }
                    int prmPage = this.Request.QueryString["Page"] == "" || this.Request.QueryString["Page"] == null ? 1 : int.Parse(this.Request.QueryString["Page"].ToString());
                    if (this.Request.Form["cCurrency"] != null)
                        prmIdCurrency = short.Parse(this.Request.Form["cCurrency"].ToString());
                    string prmNextQ = "&IdSport=" + prmIdSport + "&WagerType=" + (object)prmWagerType + "&IdPlayer=" + (object)prmIdPlayer;
                    CResultPlayerOpenBet reportPlayerOpenBets = agentInstance.GetReportPlayerOpenBets(prmIdAgent, prmIdPlayer, prmWagerType, prmIdSport, prmPage, prmRecsPerPage, prmNextQ, prmIdCurrency);
                    if (reportPlayerOpenBets.ErrorCode == CErrorCode.ErrorNone)
                    {
                        string themePath = "../App_Themes/" + this.Theme + "/";
                        string moneyFormat = ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString();

                        XmlDocument xmlDocument = PrepareOpenBetsXml(
                            reportPlayerOpenBets,
                            themePath,
                            moneyFormat,
                            canDeleteAnytime,
                            canDeleteBefore
                        );

                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\OpenBets.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);

                        StringBuilder sb = new StringBuilder();
                        sb.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                        sb.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                        this.ReportHolder.Controls.Add(this.Page.ParseControl(sb.ToString()));
                    }
                    else if (reportPlayerOpenBets.ErrorCode == CErrorCode.ErrorValidation)
                        this.Response.Redirect("../Logout.aspx");
                    else
                        this.Response.Redirect("~/Report/ErrorHandle.aspx");
                }
                else
                    this.Response.Redirect("../Logout.aspx");
            }
            catch (Exception ex)
            {
                this.Response.Redirect("ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
        }

        private static XmlDocument PrepareOpenBetsXml(CResultPlayerOpenBet source, string themePath, string moneyFormat, bool canDeleteAnytime, bool canDeleteBefore)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(source.ToXml());

            XmlElement root = doc.DocumentElement;
            root.SetAttribute("ThemePath", themePath ?? string.Empty);
            root.SetAttribute("MoneyFormat", moneyFormat ?? string.Empty);
            root.SetAttribute("CanDeleteAnytime", canDeleteAnytime ? "1" : "0");
            root.SetAttribute("CanDeleteBeforeStart", canDeleteBefore ? "1" : "0");

            AnnotateRowsWithDeleteEligibility(doc, canDeleteAnytime, canDeleteBefore);

            return doc;
        }

        private static void AnnotateRowsWithDeleteEligibility(XmlDocument doc, bool canDeleteAnytime, bool canDeleteBefore)
        {
            if (doc == null || doc.DocumentElement == null) return;

            XmlNodeList rows = doc.SelectNodes("//detail[@Header='False']");
            if (rows == null || rows.Count == 0) return;

            DateTime now = DateTime.Now;                 // Usa UtcNow si tus tiempos son UTC
            CultureInfo enUS = new CultureInfo("en-US"); // Meses en inglés

            foreach (XmlElement row in rows)
            {
                string text1 = row.GetAttribute("Text1"); // "Ticket #78700062<BR />August-12,9:38:34 PM"
                string text3 = row.GetAttribute("Text3"); // "<BR />September-05,5:03:00 PM" (o varios)
                string text4 = row.GetAttribute("Text4"); // "<BR />NFL" (o varios)

                string ticket = ExtractTicketNumber(text1);
                if (!string.IsNullOrEmpty(ticket))
                    row.SetAttribute("TicketNumber", ticket);

                string sport = ExtractFirstSport(text4);
                if (!string.IsNullOrEmpty(sport))
                    row.SetAttribute("Sport", sport);

                // Tiempos (para parlays puede haber varios)
                List<DateTime> legsTimes = ExtractGameTimes(text3, now, enUS);

                bool canDelete = canDeleteAnytime
                                 || (canDeleteBefore && legsTimes.Count > 0 && legsTimes.TrueForAll(dt => dt > now));

                row.SetAttribute("CanDelete", canDelete ? "1" : "0");
            }
        }

        private static string ExtractTicketNumber(string text1)
        {
            if (string.IsNullOrEmpty(text1)) return string.Empty;
            Match m = Regex.Match(text1, @"Ticket\s*#\s*(\d+)", RegexOptions.IgnoreCase);
            return m.Success ? m.Groups[1].Value : string.Empty;
        }

        private static string ExtractFirstSport(string text4)
        {
            if (string.IsNullOrEmpty(text4)) return string.Empty;

            // Quita <br> o &lt;br&gt;, divide, toma el primer token no vacío
            string cleaned = Regex.Replace(text4, @"(<br\s*/?>)|(&lt;br\s*/?&gt;)", "\n", RegexOptions.IgnoreCase);
            string[] tokens = cleaned.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            for (int i = 0; i < tokens.Length; i++)
            {
                string s = HtmlDecodeAndTrim(tokens[i]);
                if (!string.IsNullOrEmpty(s)) return s;
            }
            return string.Empty;
        }

        private static List<DateTime> ExtractGameTimes(string text3, DateTime now, CultureInfo culture)
        {
            List<DateTime> result = new List<DateTime>();
            if (IsNullOrWhiteSpace(text3)) return result;

            string normalized = Regex.Replace(text3, @"(<br\s*/?>)|(&lt;br\s*/?&gt;)", "\n", RegexOptions.IgnoreCase);
            string[] lines = normalized.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);

            string[] fmts = new[]
            {
                "MMMM-dd h:mm:sstt yyyy",
                "MMMM-dd h:mm tt yyyy",
                "MMM-dd h:mm:sstt yyyy",
                "MMM-dd h:mm tt yyyy",
                "MMMM-dd h:mm:ss tt yyyy"
            };

            for (int i = 0; i < lines.Length; i++)
            {
                string raw = HttpUtility.HtmlDecode(lines[i]).Trim(); // ej: "September-05,5:03:00 PM"
                if (raw.Length == 0) continue;

                bool hasYear = Regex.IsMatch(raw, @"\b\d{4}\b");

                string candidate = raw.Replace(",", " ");
                candidate = Regex.Replace(candidate, @"\s+", " ");

                DateTime dt;
                bool parsed =
                    DateTime.TryParse(candidate, culture, DateTimeStyles.AllowWhiteSpaces, out dt);

                if (!parsed && !hasYear)
                {
                    string withYear = candidate + " " + now.Year.ToString(culture);
                    parsed = DateTime.TryParse(withYear, culture, DateTimeStyles.AllowWhiteSpaces, out dt);

                    if (!parsed)
                    {
                        parsed = DateTime.TryParseExact(withYear, fmts, culture, DateTimeStyles.None, out dt);
                    }
                }

                if (parsed)
                {
                    if (!hasYear && dt < now)
                    {
                        dt = dt.AddYears(1);
                    }
                    result.Add(dt);
                }
            }

            return result;
        }

        public static bool IsNullOrWhiteSpace(string value)
        {
            if (value == null) return true;
            for (int i = 0; i < value.Length; i++)
            {
                if (!char.IsWhiteSpace(value[i])) return false;
            }
            return true;
        }
        private static string HtmlDecodeAndTrim(string s)
        {
            if (string.IsNullOrEmpty(s)) return string.Empty;
            string t = System.Web.HttpUtility.HtmlDecode(s);
            t = Regex.Replace(t, @"<br\s*/?>", "", RegexOptions.IgnoreCase);
            return t.Trim();
        }
    }
}
