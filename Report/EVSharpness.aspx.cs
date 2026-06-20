using AgentSite4.ASP;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;

namespace AgentSite4.Report
{
    public partial class EVSharpness : BasePage, IRequiresSessionState
    {
        private const decimal MinRisk = 10000m;

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DateTime dateTo = DateTime.Today;
                DateTime dateFrom = dateTo.AddDays(-7);

                txtDateFrom.Text = dateFrom.ToString("MM/dd/yyyy");
                txtDateTo.Text = dateTo.ToString("MM/dd/yyyy");
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RenderReport();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            RenderReport();
        }

        private void RenderReport()
        {
            ReportHolder.Controls.Clear();

            StringBuilder sb = new StringBuilder();
            DateTime dateFrom;
            DateTime dateTo;

            if (!TryParseDate(txtDateFrom.Text, out dateFrom) || !TryParseDate(txtDateTo.Text, out dateTo))
            {
                AddLiteral("<div class='alert alert-danger'>Invalid date format. Use MM/dd/yyyy.</div>");
                return;
            }

            if (dateFrom > dateTo)
            {
                AddLiteral("<div class='alert alert-danger'>Date From cannot be greater than Date To.</div>");
                return;
            }

            int prmIdAgent = int.Parse(Session["SubIdAgent"].ToString());
            DataTable sharpness = GetEVSharpness(prmIdAgent, dateFrom, dateTo);

            sb.Append("<h3 class='page-title'>EV Sharpness</h3>");
            sb.Append("<ul class='page-breadcrumb breadcrumb'>");
            sb.Append("<li><i class='fa fa-home'></i><a href='../Report/Welcome.aspx' target='_self'>Home</a><i class='fa fa-angle-right'></i></li>");
            sb.Append("<li><a href='#'>EV Sharpness</a></li>");
            sb.Append("</ul>");
            sb.Append("<div class='ev-period text-center'>Period: ");
            sb.Append(dateFrom.ToString("MM/dd/yyyy"));
            sb.Append(" To ");
            sb.Append(dateTo.ToString("MM/dd/yyyy"));
            sb.Append("</div><br />");

            if (sharpness.Rows.Count == 0)
            {
                sb.Append("<div class='alert alert-info text-center'>No data found for the selected period.</div>");
                AddLiteral(sb.ToString());
                return;
            }

            AddScoreColumns(sharpness);
            CalculateScores(sharpness);

            DataView view = sharpness.DefaultView;
            view.Sort = "TierOrder ASC, Total DESC";

            RenderKpis(sb, view);
            RenderGrid(sb, view);
            RenderActions(sb);

            AddLiteral(sb.ToString());
        }

        private void RenderKpis(StringBuilder sb, DataView view)
        {
            int totalPlayers = 0;
            int sharpPlayers = 0;
            int semiSharpPlayers = 0;
            int regularPlayers = 0;
            int insufficientDataPlayers = 0;

            foreach (DataRowView rowView in view)
            {
                totalPlayers++;
                string tier = rowView["Tier"].ToString();

                if (tier == "SHARP") sharpPlayers++;
                else if (tier == "SEMI-SHARP") semiSharpPlayers++;
                else if (tier == "REGULAR") regularPlayers++;
                else insufficientDataPlayers++;
            }

            sb.Append("<table cellspacing='0' cellpadding='3' border='0' class='table table-bordered table-condensed tblWeeklyBalance' align='center'>");
            sb.Append("<tr class='GameHeader'><td align='center'>Total Players</td><td align='center'>SHARP</td><td align='center'>SEMI-SHARP</td><td align='center'>REGULAR</td><td align='center'>Insufficient Data</td></tr>");
            sb.Append("<tr class='TrGameOdd'>");
            sb.Append("<td align='center' style='font-size:20px;font-weight:bold;'>" + totalPlayers.ToString("N0") + "</td>");
            sb.Append("<td align='center' class='tier-sharp' style='font-size:20px;font-weight:bold;'>" + sharpPlayers.ToString("N0") + "</td>");
            sb.Append("<td align='center' class='tier-semi-sharp' style='font-size:20px;font-weight:bold;'>" + semiSharpPlayers.ToString("N0") + "</td>");
            sb.Append("<td align='center' class='tier-regular' style='font-size:20px;font-weight:bold;'>" + regularPlayers.ToString("N0") + "</td>");
            sb.Append("<td align='center' class='tier-insufficient' style='font-size:20px;font-weight:bold;'>" + insufficientDataPlayers.ToString("N0") + "</td>");
            sb.Append("</tr></table><br />");
        }

        private void RenderGrid(StringBuilder sb, DataView view)
        {
            sb.Append("<table id='tblEVSharpness' cellspacing='0' cellpadding='3' border='0' class='table table-bordered table-condensed tblWeeklyBalance' align='center'>");
            sb.Append("<tr><td colspan='13'><div class='portlet-title'><h4>EV Platform - Sharpness Assessment</h4></div></td></tr>");
            sb.Append("<tr class='GameHeader'><td align='center'>#</td><td>Player</td><td align='right'>Risk</td><td align='right'>Net Result</td><td align='center'>Bet Type</td><td align='right'>ROI Points</td><td align='right'>Volume Points</td><td align='right'>Type Points</td><td align='right'>Consistency Points</td><td align='right'>Score</td><td align='center'>Tier</td><td>Action</td><td>Notes</td></tr>");

            int index = 1;
            foreach (DataRowView rowView in view)
            {
                sb.Append(RenderPlayerRow(rowView.Row, index));
                index++;
            }

            sb.Append("</table><br />");
        }

        private string RenderPlayerRow(DataRow row, int index)
        {
            StringBuilder sb = new StringBuilder();
            string rowClass = (index % 2 == 0) ? "TrGameEven" : "TrGameOdd";
            string player = GetString(row, "PlayerId");
            string idPlayer = GetString(row, "IdPlayer");
            decimal risk = GetDecimal(row, "TotalRisk");
            decimal netResult = GetDecimal(row, "NetResult");
            string betType = GetString(row, "BetType").ToUpper();
            string tier = row["Tier"].ToString();
            string action = row["ActionFlag"].ToString();
            decimal roi = Convert.ToDecimal(row["Roi"]);
            string notes = GetString(row, "Notes");
            int totalWagers = Convert.ToInt32(GetDecimal(row, "TotalWagers"));
            int clBets = Convert.ToInt32(GetDecimal(row, "CLBets"));
            int clBeats = Convert.ToInt32(GetDecimal(row, "CLBeats"));
            decimal beatPct = GetDecimal(row, "BeatPct");
            string tierClass = GetTierCssClass(tier);
            string resultClass = DetermineClass(netResult);

            sb.Append("<tr class='" + rowClass + "'>");
            sb.Append("<td align='center'>" + index.ToString() + "</td>");

            if (!String.IsNullOrEmpty(idPlayer)) sb.Append("<td><a class='editUser' href=\"PlayerEdit2.aspx?player=" + HttpUtility.UrlEncode(idPlayer) + "\">" + HttpUtility.HtmlEncode(player) + "</a></td>");
            else sb.Append("<td>" + HttpUtility.HtmlEncode(player) + "</td>");

            sb.Append("<td align='right'>" + risk.ToString("N0") + "</td>");
            sb.Append("<td align='right' class='" + resultClass + "'>" + netResult.ToString("N0") + "</td>");
            sb.Append("<td align='center' style='font-weight:bold;'>" + HttpUtility.HtmlEncode(betType) + "</td>");
            sb.Append("<td align='right'>" + GetScoreDisplay(row, "RoiPts") + "</td>");
            sb.Append("<td align='right'>" + GetScoreDisplay(row, "VolPts") + "</td>");
            sb.Append("<td align='right'>" + GetScoreDisplay(row, "TypePts") + "</td>");
            sb.Append("<td align='right'>" + GetScoreDisplay(row, "ConsPts") + "</td>");
            sb.Append("<td align='right' style='font-weight:bold;'>" + GetScoreDisplay(row, "Total") + "</td>");
            sb.Append("<td align='center' class='" + tierClass + "'>" + HttpUtility.HtmlEncode(tier) + "</td>");
            sb.Append("<td class='" + tierClass + "'>" + HttpUtility.HtmlEncode(action) + "</td>");
            sb.Append("<td style='font-size:10px;font-style:italic;color:#555;'>ROI " + roi.ToString("P1"));
            sb.Append(" | Wagers: " + totalWagers.ToString("N0"));
            sb.Append(" | CL: " + clBeats.ToString("N0") + "/" + clBets.ToString("N0") + " (" + beatPct.ToString("N1") + "%)");
            sb.Append(" | " + HttpUtility.HtmlEncode(notes) + "</td></tr>");

            return sb.ToString();
        }

        private void RenderActions(StringBuilder sb)
        {
            sb.Append("<br /><table cellspacing='0' cellpadding='3' border='0' class='table table-bordered table-condensed tblWeeklyBalance' align='center'>");
            sb.Append("<tr><td colspan='2'><div class='portlet-title'><h4>Recommended Actions By Tier</h4></div></td></tr>");
            sb.Append("<tr><td class='tier-sharp' align='center' style='width:140px;'>SHARP</td><td>Escalate to senior trading. Review open bets and full history. Consider severe stake restrictions or account suspension.</td></tr>");
            sb.Append("<tr><td class='tier-semi-sharp' align='center'>SEMI-SHARP</td><td>Review limits. Monitor score trend. Consider lowering the maximum stake. Re-evaluate in 30 days.</td></tr>");
            sb.Append("<tr><td class='tier-regular' align='center'>REGULAR</td><td>Standard treatment. Normal monitoring. Re-evaluate in 90 days.</td></tr>");
            sb.Append("<tr><td class='tier-insufficient' align='center'>INSUFFICIENT DATA</td><td>Monitor only. Player volume is too low to classify with confidence.</td></tr>");
            sb.Append("</table>");
        }

        private DataTable GetEVSharpness(int prmIdAgent, DateTime dateFrom, DateTime dateTo)
        {
            DataTable table = new DataTable();
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    using (SqlCommand command = new SqlCommand("dbo.EVSharpness", connection))
                    {
                        command.CommandTimeout = 120;
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = prmIdAgent;
                        command.Parameters.Add("@prmDateFrom", SqlDbType.DateTime).Value = dateFrom.Date;
                        command.Parameters.Add("@prmDateTo", SqlDbType.DateTime).Value = dateTo.Date;

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            table.Load(reader);
                        }
                    }
                }
                catch (Exception ex)
                {
                    AddLiteral("<div class='alert alert-danger'>Error loading EV Sharpness: " + HttpUtility.HtmlEncode(ex.Message) + "</div>");
                }
            }

            return table;
        }

        private void AddScoreColumns(DataTable table)
        {
            AddColumn(table, "Roi", typeof(decimal));
            AddColumn(table, "RoiPts", typeof(int));
            AddColumn(table, "VolPts", typeof(int));
            AddColumn(table, "TypePts", typeof(int));
            AddColumn(table, "ConsPts", typeof(int));
            AddColumn(table, "Total", typeof(int));
            AddColumn(table, "Tier", typeof(string));
            AddColumn(table, "TierOrder", typeof(int));
            AddColumn(table, "ActionFlag", typeof(string));
        }

        private void AddColumn(DataTable table, string columnName, Type type)
        {
            if (!table.Columns.Contains(columnName)) table.Columns.Add(columnName, type);
        }

        private void CalculateScores(DataTable table)
        {
            foreach (DataRow row in table.Rows)
            {
                decimal risk = GetDecimal(row, "TotalRisk");
                decimal netResult = GetDecimal(row, "NetResult");
                string betType = GetString(row, "BetType").ToUpper();
                decimal roi = risk > 0 ? netResult / risk : 0m;
                int roiPts = RoiScore(roi, betType);
                int volPts = VolumeScore(risk);
                int typePts = BetTypeScore(betType);
                int consPts = ConsistencyScore(roi, risk, betType);
                int total = risk >= MinRisk ? roiPts + volPts + typePts + consPts : 0;
                string tier = risk < MinRisk ? "INSUFFICIENT DATA" : total >= 70 ? "SHARP" : total >= 40 ? "SEMI-SHARP" : "REGULAR";

                row["Roi"] = roi;
                row["RoiPts"] = roiPts;
                row["VolPts"] = volPts;
                row["TypePts"] = typePts;
                row["ConsPts"] = consPts;
                row["Total"] = total;
                row["Tier"] = tier;
                row["TierOrder"] = TierOrder(tier);
                row["ActionFlag"] = ActionFlag(tier);
            }
        }

        private int RoiScore(decimal roi, string betType)
        {
            if (betType == "PARLAY" && roi > 1.0m) roi = 0.5m;
            if (roi >= 0.12m) return 35;
            if (roi >= 0.08m) return 28;
            if (roi >= 0.04m) return 20;
            if (roi >= 0.01m) return 12;
            if (roi >= -0.03m) return 7;
            if (roi >= -0.10m) return 3;
            return 0;
        }

        private int VolumeScore(decimal risk)
        {
            if (risk >= 500000m) return 20;
            if (risk >= 200000m) return 16;
            if (risk >= 50000m) return 11;
            if (risk >= 10000m) return 6;
            return 2;
        }

        private int BetTypeScore(string betType)
        {
            if (betType == "STRAIGHT") return 25;
            if (betType == "MIXED") return 12;
            return 0;
        }

        private int ConsistencyScore(decimal roi, decimal risk, string betType)
        {
            int points = 0;

            if (roi > 0 && risk >= 100000m) points += 12;
            else if (roi > 0 && risk >= 50000m) points += 8;
            else if (roi > 0 && risk >= 10000m) points += 4;

            if (roi > 0.05m && betType == "STRAIGHT") points += 8;
            else if (roi > 0.02m && (betType == "STRAIGHT" || betType == "MIXED")) points += 4;

            return points > 20 ? 20 : points;
        }

        private int TierOrder(string tier)
        {
            if (tier == "SHARP") return 0;
            if (tier == "SEMI-SHARP") return 1;
            if (tier == "REGULAR") return 2;
            return 3;
        }

        private string ActionFlag(string tier)
        {
            if (tier == "SHARP") return "ESCALATE TO TRADING";
            if (tier == "SEMI-SHARP") return "Review limits";
            if (tier == "REGULAR") return "Standard";
            return "Monitor - low volume";
        }

        private string GetTierCssClass(string tier)
        {
            if (tier == "SHARP") return "tier-sharp";
            if (tier == "SEMI-SHARP") return "tier-semi-sharp";
            if (tier == "REGULAR") return "tier-regular";
            return "tier-insufficient";
        }

        private bool TryParseDate(string value, out DateTime date)
        {
            return DateTime.TryParseExact(value, "MM/dd/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out date);
        }

        private decimal GetDecimal(DataRow row, string columnName)
        {
            if (!row.Table.Columns.Contains(columnName)) return 0m;
            if (row[columnName] == DBNull.Value) return 0m;
            if (row[columnName].ToString() == String.Empty) return 0m;
            return Convert.ToDecimal(row[columnName]);
        }

        private string GetString(DataRow row, string columnName)
        {
            if (!row.Table.Columns.Contains(columnName)) return String.Empty;
            if (row[columnName] == DBNull.Value) return String.Empty;
            return row[columnName].ToString().Trim();
        }

        private string GetScoreDisplay(DataRow row, string columnName)
        {
            return row["Tier"].ToString() == "INSUFFICIENT DATA" ? "-" : row[columnName].ToString();
        }

        private string DetermineClass(decimal value)
        {
            if (value == 0) return String.Empty;
            return value > 0 ? "NumPositive" : "NumNegative";
        }

        private void AddLiteral(string html)
        {
            ReportHolder.Controls.Add(new LiteralControl(html));
        }
    }
}
