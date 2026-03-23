using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;
using System.Text;
using System.Web;

namespace AgentSite4.Services
{
    /// <summary>
    /// Summary description for BetTicker
    /// </summary>
    public class BetTicker : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            int lastIdWager = Convert.ToInt32(context.Request.QueryString["tick"]);
            int idAgent = Convert.ToInt32(context.Session["idAgent"]);

            int minAmount = 0;
            int placed = 5;
            if (!String.IsNullOrEmpty(context.Request.QueryString["minAmount"]))
            {
                minAmount = Convert.ToInt32(context.Request.QueryString["minAmount"]);
            }
            if (!String.IsNullOrEmpty(context.Request.QueryString["placed"]))
            {
                placed = Convert.ToInt32(context.Request.QueryString["placed"]);
            }

            DataTable table = getTickerTable(idAgent, lastIdWager, minAmount, placed);

            if (!String.IsNullOrEmpty(context.Request.QueryString["History"]))
            {
                int history = Convert.ToInt32(context.Request.QueryString["History"]);
                table.Clear();
                table = getTickerTable(idAgent, lastIdWager, minAmount, placed, 1);
            }

            StringBuilder jSonResponse = new StringBuilder();

            jSonResponse.Append("{\"mark\":\"");
            for (int i = 0; i < table.Rows.Count; i++)
            {
                DataRow linea = table.Rows[i];
                if (i == 0)
                {
                    jSonResponse.Append(linea["IdWager"].ToString() + "\",\"data\":[[\"");
                }
                else
                {
                    jSonResponse.Append(",[\"");
                }
                jSonResponse.Append(linea["IdWager"].ToString() + "\",\"");
                jSonResponse.Append(linea["TicketNumber"].ToString() + "\",\"");
                jSonResponse.Append(linea["Player"].ToString() + "\",\"");
                jSonResponse.Append(linea["Agent"].ToString() + "\",\"");
                jSonResponse.Append(linea["PlacedDate"].ToString() + "\",\"");
                jSonResponse.Append(linea["riskAmount"].ToString() + "\",\"");
                jSonResponse.Append(linea["winAmount"].ToString() + "\",\"");
                jSonResponse.Append(linea["description"].ToString() + "\",\"");
                jSonResponse.Append(Regex.Replace(linea["CompleteDescription"].ToString(), @"\t|\n|\r", "") + "\",\"");
                jSonResponse.Append(linea["wagerDescription"].ToString() + "\",\"");
                jSonResponse.Append(linea["idSport"].ToString() + "\",\"");
                jSonResponse.Append(linea["Points"].ToString() + "\",\"");
                jSonResponse.Append(linea["Odds"].ToString() + "\"]");
                if ((i + 1) == table.Rows.Count)
                {
                    jSonResponse.Append("]}");
                }
            }
            if (jSonResponse.ToString() == "{\"mark\":\"")
            {
                jSonResponse.Append(lastIdWager.ToString() + "\"}");
            }


            //JsonConvert.SerializeObject(ds.Messages)
            context.Response.ContentType = "application/json";
            context.Response.Write(jSonResponse);
        }


        protected DataTable getTickerTable(int idAgent, int lastIdWager, int minAmount, int placed)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);

            DataTable table = new DataTable();
            try
            {
                Cnn.Open();
                SqlCommand comm1 = new SqlCommand("BetTicker_ModalView", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm1.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
                ((SqlParameter)comm1.Parameters.Add("@prmLastIdWager", SqlDbType.Int)).Value = lastIdWager;
                ((SqlParameter)comm1.Parameters.Add("@prmMinAmount", SqlDbType.Int)).Value = minAmount;
                ((SqlParameter)comm1.Parameters.Add("@prmPlacedDate", SqlDbType.Int)).Value = placed;
                SqlDataReader reader = comm1.ExecuteReader();
                table.Load(reader);
            }
            catch (Exception e)
            {
                string error = e.Message;
                //lblError.Text = e.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
        }

        protected DataTable getTickerTable(int idAgent, int lastIdWager, int minAmount, int placed, int history)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);

            DataTable table = new DataTable();
            try
            {
                Cnn.Open();
                SqlCommand comm1 = new SqlCommand("BetTicker_ModalView", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm1.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
                ((SqlParameter)comm1.Parameters.Add("@prmLastIdWager", SqlDbType.Int)).Value = lastIdWager;
                ((SqlParameter)comm1.Parameters.Add("@prmMinAmount", SqlDbType.Int)).Value = minAmount;
                ((SqlParameter)comm1.Parameters.Add("@prmPlacedDate", SqlDbType.Int)).Value = placed;
                ((SqlParameter)comm1.Parameters.Add("@prmHistory", SqlDbType.Int)).Value = history;
                SqlDataReader reader = comm1.ExecuteReader();
                table.Load(reader);
            }
            catch (Exception e)
            {
                string error = e.Message;
                //lblError.Text = e.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
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