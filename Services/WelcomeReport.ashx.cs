using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace AgentSite4.Services
{
    /// <summary>
    /// Summary description for WelcomeReport
    /// </summary>
    public class WelcomeReport : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            try
            {
                DateTime prmDateWeek = fromOrTo(true);
                int prmTranType = -1; //ALL TRANSACTION
                int prmDisplayOptions = 7; //player with balance with out balance
                int subIdAgent = int.Parse(context.Session["SubIdAgent"].ToString());

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString))
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand("WelcomeReport", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add(new SqlParameter("@prmDateWeek", SqlDbType.VarChar)).Value = prmDateWeek.ToString("yyyy-MM-dd HH:mm:ss");
                        cmd.Parameters.Add(new SqlParameter("@prmIdAgent", SqlDbType.Int)).Value = subIdAgent;
                        cmd.Parameters.Add(new SqlParameter("@prmTranType", SqlDbType.Int)).Value = prmTranType;
                        cmd.Parameters.Add(new SqlParameter("@prmDisplayOptions", SqlDbType.TinyInt)).Value = prmDisplayOptions;

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            DataTable dataTable = new DataTable();
                            dataTable.Load(reader);

                            string JSONString = JsonConvert.SerializeObject(dataTable);
                            context.Response.Write(JSONString);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                context.Response.Write("{\"error\":\"" + ex.Message.Replace("\"", "'") + "\"}");
            }
        }


        protected DateTime fromOrTo(bool esFrom)
        {
            DayOfWeek todayDay = DateTime.Now.DayOfWeek;
            int minusdays = 0;
            int plusdays = 0;
            switch (todayDay)
            {
                case DayOfWeek.Monday:
                    minusdays = 0;
                    plusdays = 6;
                    break;
                case DayOfWeek.Tuesday:
                    minusdays = 1;
                    plusdays = 5;
                    break;
                case DayOfWeek.Wednesday:
                    minusdays = 2;
                    plusdays = 4;
                    break;
                case DayOfWeek.Thursday:
                    minusdays = 3;
                    plusdays = 3;
                    break;
                case DayOfWeek.Friday:
                    minusdays = 4;
                    plusdays = 2;
                    break;
                case DayOfWeek.Saturday:
                    minusdays = 5;
                    plusdays = 1;
                    break;
                case DayOfWeek.Sunday:
                    minusdays = 6;
                    plusdays = 0;
                    break;
            }
            DateTime currentDate = DateTime.Now.Date;
            if (esFrom)
            {
                return currentDate.AddDays(-minusdays);
            }
            else
            {
                return currentDate.AddDays(plusdays);
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