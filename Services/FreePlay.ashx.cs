using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace AgentSite4.Services
{
    /// <summary>
    /// Summary description for FreePlay
    /// </summary>
    public class FreePlay : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            string IdAgent = context.Session["IdAgent"].ToString();//context.Request.Params["AgentSelected"];
            string prmIdPlayer = context.Request.Params["idPlayer"];
            string prmActive = context.Request.Params["active"];
            string prmDays = context.Request.Params["days"];


            string DGS_AddOnsConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);

            SqlDataReader reader;

            SqlCommand comm = new SqlCommand("FreePlayReport_Get", Cnn);
            comm.CommandType = CommandType.StoredProcedure;

            ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = IdAgent;
            ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = prmIdPlayer;
            ((SqlParameter)comm.Parameters.Add("@prmActive", SqlDbType.VarChar)).Value = prmActive;
            ((SqlParameter)comm.Parameters.Add("@prmDays", SqlDbType.VarChar)).Value = prmDays;

            Cnn.Open();

            reader = comm.ExecuteReader();

            DataTable table = new DataTable();
            table.Load(reader);
            //table.Load(reader);

            context.Response.ContentType = "application/json";
            context.Response.Write(JsonConvert.SerializeObject(table, Formatting.None));
            Cnn.Close();
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