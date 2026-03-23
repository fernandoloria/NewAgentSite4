using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;

namespace AgentSite4.Services
{
    /// <summary>
    /// Summary description for MarkLeagueHidden
    /// </summary>
    public class MarkLeagueHidden : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            int subIdAgent = Convert.ToInt32(context.Session["SubIdAgent"]);
            int idAgent = Convert.ToInt32(context.Request.Params["idAgent"]);
            int idLeague = Convert.ToInt32(context.Request.Params["idLeague"]);
            int idLineType = Convert.ToInt32(context.Request.Params["idLineType"]);
            bool enable = Convert.ToBoolean(context.Request.Params["enable"]);
            //string selectedValue = context.Request.Params["SelectedValue"];


            //int idAgent = Convert.ToInt32(selectedValue);

            string DGS_AddOnsConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();

            try
            {
                SqlCommand comm = new SqlCommand("AddOn_AgentLeagues_HideShowLeagues", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@idAgent", SqlDbType.Int)).Value = idAgent;
                ((SqlParameter)comm.Parameters.Add("@idLeague", SqlDbType.Int)).Value = idLeague;
                ((SqlParameter)comm.Parameters.Add("@idLineType", SqlDbType.Int)).Value = idLineType;
                ((SqlParameter)comm.Parameters.Add("@enable", SqlDbType.Bit)).Value = enable;

                SqlDataReader reader;
                reader = comm.ExecuteReader();

            }
            catch (Exception myErr)
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
                //GridView1.DataBind();
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