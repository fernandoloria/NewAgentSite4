using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace AgentSite4.Services
{
    /// <summary>
    /// Summary description for GetPlayersPlayerWeeklyProfit
    /// </summary>
    public class GetPlayersPlayerWeeklyProfit : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            string agentSelected = context.Session["IdAgent"].ToString();//context.Request.Params["AgentSelected"];
            string startsWith = context.Request.Params["startsWith"];
            string dateFrom = context.Request.Params["dateFrom"];
            string onlyActives = context.Request.Params["onlyActives"];
            DateTime datePicked = DateTime.ParseExact(dateFrom, "MMMM-yyyy", CultureInfo.InvariantCulture);


            string DGS_AddOnsConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);

            SqlDataReader reader;

            SqlCommand comm = new SqlCommand("AddOn_GetPlayer_Filter_PlayerWeeklyProfit", Cnn);
            comm.CommandType = CommandType.StoredProcedure;


            ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = agentSelected;
            ((SqlParameter)comm.Parameters.Add("@prmPlayer", SqlDbType.VarChar)).Value = startsWith;
            ((SqlParameter)comm.Parameters.Add("@prmMonth", SqlDbType.Int)).Value = Convert.ToInt32(datePicked.ToString("MM"));
            ((SqlParameter)comm.Parameters.Add("@prmYear", SqlDbType.Int)).Value = Convert.ToInt32(datePicked.ToString("yyyy"));
            ((SqlParameter)comm.Parameters.Add("@prmOnlyActives", SqlDbType.Bit)).Value = onlyActives;

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