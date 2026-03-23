using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Caching;
using System.Web.UI;

namespace AgentSite4.Controls
{
    public partial class AgentRightsSession : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                foreach (string key in Session.Keys)
                {
                    Response.Write($"{key}: {Session[key]}<br />");
                }
                //int idAgent = TryGetIdAgent();

                //if (!IsRightsLoaded())
                //{
                //    LoadRights(idAgent);
                //}
            }
        }


        private bool IsRightsLoaded()
        {
            object flag = (HttpContext.Current != null) ? HttpContext.Current.Session["AgentRightsLoaded"] : null;
            return (flag is bool) && (bool)flag;
        }

        private int TryGetIdAgent()
        {
            object raw = (HttpContext.Current != null) ? HttpContext.Current.Session["IdAgent"] : null;
            int id;
            return int.TryParse(Convert.ToString(raw), out id) ? id : 0;
        }

        public void LoadRights(int prmIdAgent)
        {
            string sessionKey = "AddOn_GetAgentRights_" + prmIdAgent;

            HttpContext ctx = HttpContext.Current;
            System.Web.SessionState.HttpSessionState session = (ctx != null) ? ctx.Session : null;

            DataTable table = null;

            
            if (session != null && session[sessionKey] is DataTable)
            {
                table = (DataTable)session[sessionKey];
            }
            else
            {
                
                object cached = HttpRuntime.Cache[sessionKey];
                if (cached is DataTable) table = (DataTable)cached;
            }

            
            if (table == null)
            {
                table = AddOn_GetAgentRights(prmIdAgent);

                if (session != null)
                    session[sessionKey] = table;
                else
                    HttpRuntime.Cache.Insert(sessionKey, table, null, DateTime.UtcNow.AddMinutes(5), Cache.NoSlidingExpiration);
            }

            if (table != null)
            {
                LoadAgentRights(table);
                if (session != null) session["AgentRightsLoaded"] = true; // <-- correct spelling
            }
        }

        private DataTable AddOn_GetAgentRights(int prmIdAgent)
        {
            string cs = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            DataTable table = new DataTable();

            using (SqlConnection conn = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand("AddOn_GetAgentRights", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@idAgent", prmIdAgent);

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
                    
                }
            }
            return table;
        }

        private Dictionary<int, string> GetRightsMap()
        {
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
                    
                }
            }

            foreach (DataRow row in rightsTable.Rows)
            {
                int idRight = Convert.ToInt32(row["IdRight"]);
                string description = Convert.ToString(row["Description"]).Replace(" ", string.Empty);
                rightsMap[idRight] = description;
            }

            return rightsMap;
        }

        private void LoadAgentRights(DataTable table)
        {
            Dictionary<int, string> rightsMap = GetRightsMap();

            foreach (KeyValuePair<int, string> kv in rightsMap)
            {
                Session[kv.Value] = false;
            }

            foreach (DataRow row in table.Rows)
            {
                if (Convert.ToString(row["Enable"]) == "1")
                {
                    int idRight = Convert.ToInt32(row["IdRight"]);
                    string key;
                    if (rightsMap.TryGetValue(idRight, out key))
                    {
                        Session[key] = true;
                    }
                }
            }
        }
    }
}
