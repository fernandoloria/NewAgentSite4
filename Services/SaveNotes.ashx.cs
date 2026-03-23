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
    /// Summary description for SaveNotes
    /// </summary>
    public class SaveNotes : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            string strMensaje = "";
            int idPlayer = Convert.ToInt32(context.Request.QueryString["idPlayer"].Replace("chk_", ""));
            string note = context.Request.QueryString["note"];

            //strJson = "{method:'delete',parameters:{idMessage:0,user:'floria'}}";
            //parameters param = JsonConvert.DeserializeObject<parameters>(strJson);
            //int idPlayer = Convert.ToInt32(param.idPlayer.Replace("chk_", ""));
            strMensaje = process(idPlayer, note);

            context.Response.ContentType = "text/plain";
            context.Response.Write(strMensaje);
        }

        protected string process(int idPlayer, string note)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            string error = "OK";
            try
            {
                SqlCommand comm = new SqlCommand("WeeklyBalanceNotes_Insert", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = idPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmNotes", SqlDbType.VarChar)).Value = note;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
            }
            catch (Exception myError)
            {
                error = myError.Message.ToString();
            }

            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return error;
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