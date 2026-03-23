using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;

namespace AgentSite4.Services
{
    /// <summary>
    /// Summary description for UpdateLeagueFreePlay
    /// </summary>
    public class UpdateLeagueFreePlay : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //int SubIdAgent = Convert.ToInt32(context.Session["SubIdAgent"]);
            int idAgent = Convert.ToInt32(context.Request.Params["idAgent"]);

            int idLeague = Convert.ToInt32(context.Request.Params["idLeague"]);
            bool deny = Convert.ToBoolean(context.Request.Params["deny"]);

            ManageFreePlayByLeague_Insert(idAgent, idLeague, deny);

        }


        protected void ManageFreePlayByLeague_Insert(int idAgent, int idLeague, bool deny)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            using (SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                Cnn.Open();
                try
                {
                    SqlCommand comm = new SqlCommand("ManageFreePlayByLeague_Insert", Cnn);
                    comm.CommandType = CommandType.StoredProcedure;

                    comm.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = idAgent;
                    comm.Parameters.Add("@prmidLeague", SqlDbType.Int).Value = idLeague;
                    comm.Parameters.Add("@prmDeny", SqlDbType.Bit).Value = deny;

                    comm.ExecuteNonQuery();
                }
                catch (Exception myErr)
                {

                }
                finally
                {

                }
            }
        }


        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

    }
}