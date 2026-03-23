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
    /// Summary description for GetPlayersByAgent
    /// </summary>
    public class GetPlayersByAgent : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            string agentSelected = context.Session["IdAgent"].ToString();//context.Request.Params["AgentSelected"];
            string page = "10";//context.Request.Params["page"];
            string startsWith = context.Request.Params["startsWith"];

            //SqlConnection Cnn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ASIDbConnectionString"].ConnectionString);


            string DGS_AddOnsConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);

            SqlDataReader reader;

            SqlCommand comm = new SqlCommand("AddOn_GetPlayerFilter", Cnn);
            comm.CommandType = CommandType.StoredProcedure;

            ((SqlParameter)comm.Parameters.Add("@idAgent", SqlDbType.Int)).Value = agentSelected;
            ((SqlParameter)comm.Parameters.Add("@page", SqlDbType.Int)).Value = page;
            ((SqlParameter)comm.Parameters.Add("@Player", SqlDbType.VarChar)).Value = startsWith;

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