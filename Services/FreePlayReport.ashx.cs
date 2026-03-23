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
    /// Summary description for FreePlayReport
    /// </summary>
    public class FreePlayReport : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            string IdAgent = context.Session["IdAgent"].ToString();//context.Request.Params["AgentSelected"];
            string prmIdPlayer = context.Request.Params["id"];
            string prmDateFrom = context.Request.Params["from"];
            string prmDateTo = context.Request.Params["to"];


            string DGS_AddOnsConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);

            SqlDataReader reader;

            SqlCommand comm = new SqlCommand("FreePlayReportDetail_Get", Cnn);
            comm.CommandType = CommandType.StoredProcedure;

            ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = IdAgent;
            ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = prmIdPlayer;
            ((SqlParameter)comm.Parameters.Add("@prmDateFrom", SqlDbType.DateTime)).Value = prmDateFrom;
            ((SqlParameter)comm.Parameters.Add("@prmDateTo", SqlDbType.DateTime)).Value = prmDateTo;

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