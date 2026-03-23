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
    /// Summary description for FreePlayAdd
    /// </summary>
    public class FreePlayAdd : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            Error error = new Error();
            try
            {
                int idAgent = Convert.ToInt32(context.Session["IdAgent"].ToString());//context.Request.Params["AgentSelected"];
                string[] idPlayers = context.Request.Form["idPlayer"].Split(',');
                string prmDescription = context.Request.Form["prmDescription"];
                double prmAmount = Convert.ToDouble(context.Request.Form["prmAmount"]);
                string prmReference = "FREE PLAY";// context.Request.Form["prmReference"];
                DateTime prmTransactionDate = DateTime.Now;// DateTime.ParseExact(context.Request.Form["prmTransactionDate"], "MM-dd-yyyy", CultureInfo.InvariantCulture);
                if (validTransactionDate(prmTransactionDate, out error))
                {
                    error.Titulo = idPlayers.ToString();
                    error.Code = 400;
                    foreach (string idPlayer in idPlayers)
                    {

                        if (hierarchy(idAgent, Convert.ToInt32(idPlayer), "0", "14", out error) && error.Code == 200)
                        {
                            if (VerifyWeeklyFreePlayLimit(idAgent, prmAmount, out error))
                            {
                                addFreePlay(Convert.ToInt32(idPlayer), prmDescription, prmAmount, prmReference, prmTransactionDate, out error);
                                if (error.Code != 200)
                                {
                                    break;
                                }
                            }
                            else
                            {
                                break;
                            }
                        }
                        else
                        {
                            break;
                        }
                    }
                }
            }
            catch (Exception e)
            {
                // error = new Error { titulo = "Bad Request: " + e.Message, code = 400 };
            }

            context.Response.ContentType = "application/json";
            context.Response.Write(JsonConvert.SerializeObject(error, Formatting.None));

        }

        private bool hierarchy(int prmIdAgent, int prmIdPlayer, string prmActive, string prmDays, out Error error)
        {
            error = new Error();
            bool isInHierarchy = false;
            string DGS_AddOnsConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                SqlDataReader reader;
                SqlCommand comm = new SqlCommand("FreePlayReport_Get", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = prmIdPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmActive", SqlDbType.VarChar)).Value = prmActive;
                ((SqlParameter)comm.Parameters.Add("@prmDays", SqlDbType.VarChar)).Value = prmDays;

                Cnn.Open();

                reader = comm.ExecuteReader();
                DataTable table = new DataTable();
                table.Load(reader);
                if (table.Rows.Count > 0)
                {
                    isInHierarchy = true;
                    error.Titulo = "Player in hierarchy";
                    error.Code = 200;
                }
                else
                {
                    error.Titulo = "Player not in hierarchy";
                    error.Code = 401;
                }

            }
            catch (Exception e)
            {
                error.Titulo = "An error has occurred" + e.Message;
                error.Code = 500;
            }
            finally
            {
                Cnn.Close();
            }
            return isInHierarchy;
        }

        private bool validTransactionDate(DateTime prmTransactionDate, out Error error)
        {
            error = new Error();
            bool isValid = false;
            DateTime currentDate = DateTime.Today;
            int startDay = 0, endDate = 6;
            switch (currentDate.DayOfWeek)
            {
                case DayOfWeek.Tuesday:
                    startDay = -1;
                    endDate = 5;
                    break;
                case DayOfWeek.Wednesday:
                    startDay = -2;
                    endDate = 4;
                    break;
                case DayOfWeek.Thursday:
                    startDay = -3;
                    endDate = 3;
                    break;
                case DayOfWeek.Friday:
                    startDay = -4;
                    endDate = 2;
                    break;
                case DayOfWeek.Saturday:
                    startDay = -5;
                    endDate = 1;
                    break;
                case DayOfWeek.Sunday:
                    startDay = -6;
                    endDate = 0;
                    break;
            }
            DateTime dateFrom = currentDate.AddDays(startDay);
            DateTime dateTo = currentDate.AddDays(endDate + 1).AddSeconds(-1);
            if (prmTransactionDate >= dateFrom && prmTransactionDate < dateTo)
            {
                isValid = true;
                error.Titulo = "Valid Transaccion date";
                error.Code = 200;
            }
            else
            {
                error.Titulo = "Invalid Transaction date: dates range between " + dateFrom + " and " + dateTo;
                error.Code = 409;
            }
            return isValid;
        }

        protected void addFreePlay(int prmIdPlayer, string prmDescription, double prmAmount, string prmReference, DateTime prmTransactionDate, out Error error)
        {
            error = new Error();
            string DGSDATAConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("InsertPlayerTransaction", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = prmIdPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmDescription", SqlDbType.VarChar)).Value = prmDescription;
                ((SqlParameter)comm.Parameters.Add("@prmAmount", SqlDbType.Money)).Value = prmAmount;
                ((SqlParameter)comm.Parameters.Add("@prmReference", SqlDbType.VarChar)).Value = prmReference;
                ((SqlParameter)comm.Parameters.Add("@prmFee", SqlDbType.Money)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmBonus", SqlDbType.Money)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmIdPaymentMethod", SqlDbType.TinyInt)).Value = 2;
                ((SqlParameter)comm.Parameters.Add("@prmTransactionType", SqlDbType.Char)).Value = "P";
                ((SqlParameter)comm.Parameters.Add("@prmTransactionDate", SqlDbType.DateTime)).Value = prmTransactionDate;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 252; // USER AGENT ONLINE
                ((SqlParameter)comm.Parameters.Add("@prmIdAdjustmentType", SqlDbType.TinyInt)).Value = DBNull.Value;
                ((SqlParameter)comm.Parameters.Add("@prmOutIdTransaction", SqlDbType.Int)).Direction = ParameterDirection.Output;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
                error.Titulo = "Free Play added";
                error.Code = 200;
                Cnn.Close();
            }
            catch (Exception ex)
            {
                error.Titulo = "Free Play can't be added, plase try later " + ex.Message;
                error.Code = 401;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }

        public bool VerifyWeeklyFreePlayLimit(int idAgent, double amount, out Error error)
        {
            error = new Error();
            bool isAllowed = false;
            decimal availableBalance = 0;
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("WeeklyFreePlayLimit_VerifyLimit_Agent", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = idAgent;
                cmd.Parameters.Add("@prmCurrentDate", SqlDbType.Date).Value = DateTime.Now;
                cmd.Parameters.Add("@prmFreePlayAmount", SqlDbType.Money).Value = amount;
                cmd.Parameters.Add("@outAllowed", SqlDbType.Bit).Direction = ParameterDirection.Output;
                cmd.Parameters.Add("@outAvailableBalance", SqlDbType.Money).Direction = ParameterDirection.Output;

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    isAllowed = (bool)cmd.Parameters["@outAllowed"].Value;
                    availableBalance = (decimal)cmd.Parameters["@outAvailableBalance"].Value;
                }
                catch (Exception ex)
                {
                }
            }
            if (!isAllowed || availableBalance == 0)
            {
                error.Titulo = "Free Play can't be added, the available free play balance is " + availableBalance.ToString("N0");
                error.Code = 401;
            }

            if (amount > 0 && amount > Convert.ToDouble(availableBalance))
            {
                error.Titulo = "Free Play can't be added, the available free play balance is " + availableBalance.ToString("N0");
                error.Code = 401;
            }

            return isAllowed;
        }


        public class Error
        {
            private string titulo;
            private int code;
            public string Titulo { get { return titulo; } set { titulo = value; } }
            public int Code { get { return code; } set { code = value; } }
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