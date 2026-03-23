using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Caching;

namespace AgentSite4.Security
{
    public static class AgentRights
    {
        private const string RightsLoadedFlag = "AgentRightsLoaded";
        private const string RightsMapCacheKey = "RIGHTS_MAP_CACHE";
        private static readonly TimeSpan RightsMapTtl = TimeSpan.FromMinutes(15);
        private static readonly TimeSpan NoSessionTtl = TimeSpan.FromMinutes(5);

        /// <summary>
        /// Ensures rights are loaded for the current request's agent (reads Session["IdAgent"]).
        /// </summary>
        public static void Load()
        {
            HttpContext ctx = HttpContext.Current;
            if (ctx == null) return;

            int idAgent = 0;
            object raw = (ctx.Session != null) ? ctx.Session["IdAgent"] : null;
            if (!int.TryParse(Convert.ToString(raw), out idAgent)) idAgent = 0;

            EnsureLoaded(idAgent);
        }

        /// <summary>
        /// Ensures rights are loaded for the specified agent.
        /// Caches the AddOn_GetAgentRights result and sets per-right booleans in Session.
        /// </summary>
        public static void EnsureLoaded(int idAgent)
        {
            HttpContext ctx = HttpContext.Current;
            System.Web.SessionState.HttpSessionState session = (ctx != null) ? ctx.Session : null;

            // If we already loaded this request, skip.
            if (session != null && session[RightsLoadedFlag] is bool && (bool)session[RightsLoadedFlag]) return;

            string sessionKey = "AddOn_GetAgentRights_" + idAgent;
            DataTable table = null;

            // 1) Try Session cache
            if (session != null && session[sessionKey] is DataTable)
            {
                table = (DataTable)session[sessionKey];
            }
            else
            {
                // 2) Try App cache
                object cached = HttpRuntime.Cache[sessionKey];
                if (cached is DataTable) table = (DataTable)cached;
            }

            // 3) Load from DB if needed
            if (table == null)
            {
                table = GetAgentRightsFromDb(idAgent);

                if (session != null)
                    session[sessionKey] = table;
                else
                    HttpRuntime.Cache.Insert(sessionKey, table, null, DateTime.UtcNow.Add(NoSessionTtl), Cache.NoSlidingExpiration);
            }

            // 4) Apply to Session (set all known rights to false, then enable those returned)
            if (table != null)
            {
                Dictionary<int, string> map = GetRightsMap(); // IdRight -> cleaned key (no spaces)
                InitializeAllRightsFalse(map, session);
                EnableReturnedRights(table, map, session);
                if (session != null) session[RightsLoadedFlag] = true;
            }
        }

        /// <summary>
        /// Forces a fresh load from DB and updates caches/session.
        /// </summary>
        public static void Refresh(int idAgent)
        {
            HttpContext ctx = HttpContext.Current;
            System.Web.SessionState.HttpSessionState session = (ctx != null) ? ctx.Session : null;

            string sessionKey = "AddOn_GetAgentRights_" + idAgent;
            DataTable table = GetAgentRightsFromDb(idAgent);

            if (session != null)
            {
                session[sessionKey] = table;
                session[RightsLoadedFlag] = false; // clear flag so EnsureLoaded re-applies
            }
            HttpRuntime.Cache.Insert(sessionKey, table, null, DateTime.UtcNow.Add(NoSessionTtl), Cache.NoSlidingExpiration);

            // Immediately apply
            EnsureLoaded(idAgent);
        }

        /// <summary>
        /// Checks if a right is set in Session by its string key (e.g., "PlayerManagement").
        /// </summary>
        public static bool Has(string rightKey)
        {
            HttpContext ctx = HttpContext.Current;
            if (ctx == null || ctx.Session == null) return false;

            object v = ctx.Session[rightKey];
            return (v is bool) && (bool)v;
        }

        /// <summary>
        /// Checks if a right is enabled by IdRight, using the rights map.
        /// </summary>
        public static bool Has(int idRight)
        {
            Dictionary<int, string> map = GetRightsMap();
            string key;
            if (!map.TryGetValue(idRight, out key)) return false;
            return Has(key);
        }

        // -------------------- internals --------------------

        private static DataTable GetAgentRightsFromDb(int idAgent)
        {
            string cs = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            DataTable table = new DataTable();

            using (SqlConnection conn = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("AddOn_GetAgentRights", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@idAgent", idAgent);

                try
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        table.Load(reader);
                    }
                }
                catch
                {
                    // TODO: log if needed
                }
            }
            return table;
        }

        private static Dictionary<int, string> GetRightsMap()
        {
            object cached = HttpRuntime.Cache[RightsMapCacheKey];
            if (cached is Dictionary<int, string>) return (Dictionary<int, string>)cached;

            string cs = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            DataTable rightsTable = new DataTable();
            Dictionary<int, string> rightsMap = new Dictionary<int, string>();

            using (SqlConnection conn = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("RIGHTS_Get", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                try
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        rightsTable.Load(reader);
                    }
                }
                catch
                {
                    // TODO: log if needed
                }
            }

            // Map IdRight -> Description (spaces removed)
            foreach (DataRow row in rightsTable.Rows)
            {
                int idRight = Convert.ToInt32(row["IdRight"]);
                string description = Convert.ToString(row["Description"]);
                if (description == null) description = String.Empty;
                description = description.Replace(" ", String.Empty);
                rightsMap[idRight] = description;
            }

            HttpRuntime.Cache.Insert(RightsMapCacheKey, rightsMap, null,
                                     DateTime.UtcNow.Add(RightsMapTtl),
                                     Cache.NoSlidingExpiration);
            return rightsMap;
        }

        private static void InitializeAllRightsFalse(Dictionary<int, string> map, System.Web.SessionState.HttpSessionState session)
        {
            if (session == null) return;
            foreach (KeyValuePair<int, string> kv in map)
            {
                session[kv.Value] = false;
            }
        }

        private static void EnableReturnedRights(DataTable table, Dictionary<int, string> map, System.Web.SessionState.HttpSessionState session)
        {
            if (session == null) return;
            if (table == null || table.Rows.Count == 0) return;

            for (int i = 0; i < table.Rows.Count; i++)
            {
                DataRow row = table.Rows[i];
                string enable = Convert.ToString(row["Enable"]);
                if (enable == "1")
                {
                    int idRight = Convert.ToInt32(row["IdRight"]);
                    string key;
                    if (map.TryGetValue(idRight, out key))
                    {
                        session[key] = true;
                    }
                }
            }
        }
    }
}
