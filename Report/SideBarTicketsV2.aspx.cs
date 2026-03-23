using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Text;
using System.Web;
using System.Web.Profile;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using AgentSite4.ASP;

namespace AgentSite4.Report
{
    public partial class SideBarTicketsV2 : BasePage, IRequiresSessionState
    {
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;
        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.ContentType = "application/json";
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Response.Write(GetTickets());
        }

        protected string GetTickets()
        {
            int lastIdWager = 0, idAgent = 0, placed = 5, minAmount = 0, tmp;

            if (int.TryParse(Request.QueryString["tick"], out tmp)) lastIdWager = tmp;
            if (int.TryParse(Convert.ToString(Session["idAgent"]), out tmp)) idAgent = tmp;
            if (int.TryParse(Request.QueryString["placed"], out tmp)) placed = tmp;
            if (int.TryParse(Request.QueryString["minAmount"], out tmp)) minAmount = tmp;

            DataTable table = getTickerTable(idAgent, lastIdWager, minAmount, placed);

            var data = new List<object[]>();
            foreach (DataRow linea in table.Rows)
            {
                data.Add(new object[] {
                    linea["IdWager"].ToString(),
                    linea["TicketNumber"].ToString(),
                    linea["Player"].ToString(),
                    linea["Agent"].ToString(),
                    linea["PlacedDate"].ToString(),
                    linea["riskAmount"].ToString(),
                    linea["winAmount"].ToString(),
                    linea["description"].ToString(),
                    Regex.Replace(Convert.ToString(linea["CompleteDescription"]), @"\t|\n|\r", ""),
                    linea["wagerDescription"].ToString(),
                    linea["idSport"].ToString(),
                    linea["Points"].ToString(),
                    linea["Odds"].ToString()
                });
            }

            var payload = new
            {
                mark = table.Rows.Count > 0 ? table.Rows[0]["IdWager"].ToString() : lastIdWager.ToString(),
                data = data
            };

            return new JavaScriptSerializer().Serialize(payload);
        }

        protected DataTable getTickerTable(int idAgent, int lastIdWager, int minAmount, int placed)
        {
            string cs = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            DataTable table = new DataTable();
            string cacheKey = string.Format("TickerTable_{0}_{1}_{2}_{3}", idAgent, lastIdWager, minAmount, placed);

            if (HttpContext.Current.Cache[cacheKey] != null)
                return (DataTable)HttpContext.Current.Cache[cacheKey];

            try
            {
                using (SqlConnection cnn = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand("BetTicker_ModalView", cnn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    var p1 = cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int); p1.Value = idAgent;
                    var p2 = cmd.Parameters.Add("@prmLastIdWager", SqlDbType.Int); p2.Value = lastIdWager;
                    var p3 = cmd.Parameters.Add("@prmMinAmount", SqlDbType.Int); p3.Value = minAmount;
                    var p4 = cmd.Parameters.Add("@prmPlacedDate", SqlDbType.Int); p4.Value = placed;

                    cnn.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                        table.Load(r);
                }

                HttpContext.Current.Cache.Insert(
                    cacheKey, table, null,
                    DateTime.UtcNow.AddMinutes(5),
                    System.Web.Caching.Cache.NoSlidingExpiration
                );
            }
            catch { }
            return table;
        }
    }
}
