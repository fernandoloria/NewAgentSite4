using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DGSinterface;
using System.Web.Profile;
using System.Web.SessionState;

namespace AgentSite4.Betslip
{
    public partial class TicketWriter : BasePage, IRequiresSessionState
    {
        private static string sConnString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
        private static string AddOnsConnString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
        protected CResultLogin oUser;

        void Page_Load(object sender, System.EventArgs e)
        {
            //string url = HttpContext.Current.Request.Url.Host.ToLower() +" | Agent:"+ Session["Agent"].ToString();
            //oUser = GetLogin("testh", "4321", GetClientIP(), "0",url, "");
            oUser = (CResultLogin)HttpContext.Current.Session["userdata"];
        }

        public string getAvailableLeagues()
        {
            CResultLogin cresultLogin = oUser;

            string cacheKey = "AvailableLeagues_" + cresultLogin.Player;
            string cachedLeagues = (string)HttpContext.Current.Cache[cacheKey];

            if (cachedLeagues != null)
            {
                //   return cachedLeagues;
            }


            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            DataTable table = new DataTable();
            try
            {
                using (SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString))
                {
                    Cnn.Open();
                    using (SqlCommand comm = new SqlCommand("AddOn_WebGetOpenGamesLeagueUpcomming_GetLeague", Cnn))
                    {
                        comm.CommandType = CommandType.StoredProcedure;

                        comm.Parameters.Add(new SqlParameter("@IdLineType", SqlDbType.Int)).Value = cresultLogin.IdLineType;
                        comm.Parameters.Add(new SqlParameter("@IdLanguage", SqlDbType.Int)).Value = cresultLogin.IdLanguage;
                        comm.Parameters.Add(new SqlParameter("@IdGame", SqlDbType.Int)).Value = -1;
                        comm.Parameters.Add(new SqlParameter("@IdAgent", SqlDbType.Int)).Value = cresultLogin.IdAgent;
                        comm.Parameters.Add(new SqlParameter("@WagerType", SqlDbType.Int)).Value = idwts.Value;
                        comm.Parameters.Add(new SqlParameter("@hours", SqlDbType.Int)).Value = 8;

                        using (SqlDataReader readerAgent = comm.ExecuteReader())
                        {
                            table.Load(readerAgent);
                        }
                    }
                }
            }
            catch (Exception myError)
            {
                string err = myError.Message;
            }

            ArrayList idLeagues = new ArrayList();
            foreach (DataRow row in table.Rows)
            {
                idLeagues.Add(row["idLeague"].ToString());
            }

            string leaguesString = string.Join(",", (string[])idLeagues.ToArray(typeof(string)));

            HttpContext.Current.Cache.Insert(
                cacheKey,
                leaguesString,
                null,
                DateTime.Now.AddMinutes(10),
                System.Web.Caching.Cache.NoSlidingExpiration
            );

            return leaguesString;
        }

    }
}