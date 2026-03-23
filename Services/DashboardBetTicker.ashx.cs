// DashboardBetTicker.ashx.cs
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Caching;
using System.Web.SessionState;
using Newtonsoft.Json;

namespace AgentSite4.Services
{
    public class DashboardBetTicker : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json; charset=utf-8";
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.Cache.SetNoStore();
            context.Response.Cache.SetRevalidation(HttpCacheRevalidation.AllCaches);
            context.Response.Cache.SetExpires(DateTime.UtcNow.AddSeconds(-1));

            try
            {
                int lastIdWager = GetIntQS(context, "tick", 0);
                int placed = GetIntQS(context, "placed", 5);
                int minAmount = GetIntQS(context, "minAmount", 0);
                int idAgent = GetIntSession(context, "idAgent", 0);

                DataTable table = GetTickerTable(idAgent, lastIdWager, minAmount, placed);

                List<object[]> rows = new List<object[]>();

                for (int i = 0; i < table.Rows.Count; i++)
                {
                    DataRow dr = table.Rows[i];

                    string sportHtml = Convert.ToString(dr["idSport"]).Trim();

                    string rawPlaced = Convert.ToString(dr["PlacedDate"]);
                    DateTime dt;
                    string placedTime = DateTime.TryParse(rawPlaced, out dt)
                        ? dt.ToString("h:mmtt").ToLowerInvariant()
                        : rawPlaced;

                    string legsSource = Convert.ToString(dr["wagerDescription"]);
                    if (string.IsNullOrEmpty(legsSource))
                    {
                        legsSource = Convert.ToString(dr["description"]);
                    }

                    string sportLegLines = PairSportWithLegs(sportHtml, legsSource);

                    bool allRbl = AreAllSportsEqualTo(sportHtml, "RBL");
                    string odds = allRbl ? string.Empty : Convert.ToString(dr["Odds"]);

                    object[] item = new object[]
                    {
                        Convert.ToString(dr["IdWager"]),            // [0]
                        Convert.ToString(dr["TicketNumber"]),       // [1]
                        Convert.ToString(dr["Player"]),             // [2]
                        Convert.ToString(dr["Agent"]),              // [3]
                        placedTime,                                  // [4]
                        Convert.ToString(dr["riskAmount"]),         // [5]
                        Convert.ToString(dr["winAmount"]),          // [6]
                        Convert.ToString(dr["description"]),        // [7]
                        Regex.Replace(Convert.ToString(dr["CompleteDescription"] ?? string.Empty), @"\t|\n|\r", ""), // [8]
                        Convert.ToString(dr["wagerDescription"]),   // [9]
                        sportHtml,                                   // [10] 
                        Convert.ToString(dr["Points"]),             // [11]
                        odds,                                        // [12]
                        sportLegLines                                // [13] 
                    };

                    rows.Add(item);
                }

                string markValue = table.Rows.Count > 0
                    ? Convert.ToString(table.Rows[0]["IdWager"])
                    : lastIdWager.ToString();

                string json = JsonConvert.SerializeObject(new
                {
                    mark = markValue,
                    data = rows
                });

                context.Response.Write(json);
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = 500;
                string json = JsonConvert.SerializeObject(new
                {
                    error = "Internal Server Error",
                    message = ex.Message
                });
                context.Response.Write(json);
            }
        }

        public bool IsReusable { get { return false; } }

        private static int GetIntQS(HttpContext ctx, string key, int @default)
        {
            int v;
            return int.TryParse(ctx.Request.QueryString[key], out v) ? v : @default;
        }

        private static int GetIntSession(HttpContext ctx, string key, int @default)
        {
            int v;
            return int.TryParse(Convert.ToString(ctx.Session[key]), out v) ? v : @default;
        }

        private static DataTable GetTickerTable(int idAgent, int lastIdWager, int minAmount, int placed)
        {
            string cs = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            string cacheKey = string.Format("DashTicker_{0}_{1}_{2}_{3}", idAgent, lastIdWager, minAmount, placed);

            DataTable cached = HttpRuntime.Cache[cacheKey] as DataTable;
            if (cached != null) return cached;

            DataTable table = new DataTable();

            using (SqlConnection cnn = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("BetTicker_ModalView", cnn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter p1 = cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int);
                p1.Value = idAgent;

                SqlParameter p2 = cmd.Parameters.Add("@prmLastIdWager", SqlDbType.Int);
                p2.Value = lastIdWager;

                SqlParameter p3 = cmd.Parameters.Add("@prmMinAmount", SqlDbType.Int);
                p3.Value = minAmount;

                SqlParameter p4 = cmd.Parameters.Add("@prmPlacedDate", SqlDbType.Int);
                p4.Value = placed;

                cnn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    table.Load(r);
                }
            }

            HttpRuntime.Cache.Insert(
                cacheKey,
                table,
                null,
                DateTime.UtcNow.AddSeconds(5),
                Cache.NoSlidingExpiration
            );

            return table;
        }

        private static string[] SplitByBr(string html)
        {
            if (string.IsNullOrEmpty(html)) return new string[0];

            string normalized = Regex.Replace(html, @"<br\s*/?>", "\n", RegexOptions.IgnoreCase);
            string[] parts = normalized.Split(new char[] { '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries);

            List<string> list = new List<string>();
            for (int i = 0; i < parts.Length; i++)
            {
                string s = parts[i].Trim();
                if (s.Length > 0) list.Add(s);
            }

            return list.ToArray();
        }

        private static string[] RepeatString(string value, int count)
        {
            if (count <= 0) return new string[0];
            string[] arr = new string[count];
            for (int i = 0; i < count; i++) arr[i] = value;
            return arr;
        }

        private static string PairSportWithLegs(string sportHtml, string legsHtml)
        {
            string[] sports = SplitByBr(sportHtml);
            string[] legs = SplitByBr(legsHtml);

            if (legs.Length == 0) return string.Empty;
            if (sports.Length == 0) return string.Join("<br />", legs);

            if (sports.Length == 1 && legs.Length > 1)
            {
                sports = RepeatString(sports[0], legs.Length);
            }

            if (sports.Length < legs.Length)
            {
                string[] expanded = new string[legs.Length];
                for (int i = 0; i < legs.Length; i++)
                {
                    expanded[i] = i < sports.Length ? sports[i] : sports[sports.Length - 1];
                }
                sports = expanded;
            }
            else if (sports.Length > legs.Length)
            {
                string[] trimmed = new string[legs.Length];
                for (int i = 0; i < legs.Length; i++)
                {
                    trimmed[i] = sports[i];
                }
                sports = trimmed;
            }

            List<string> pairs = new List<string>(legs.Length);
            for (int i = 0; i < legs.Length; i++)
            {
                pairs.Add(sports[i] + " - " + legs[i]);
            }

            return string.Join("<br />", pairs.ToArray());
        }

        private static bool AreAllSportsEqualTo(string sportHtml, string target)
        {
            string[] sports = SplitByBr(sportHtml);
            if (sports.Length == 0) return false;

            for (int i = 0; i < sports.Length; i++)
            {
                if (!string.Equals(sports[i], target, StringComparison.OrdinalIgnoreCase))
                {
                    return false;
                }
            }
            return true;
        }
    }
}
