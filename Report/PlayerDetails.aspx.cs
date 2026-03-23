using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using AgentSite4.ASP;
using static AgentSite4.Report.OpenBetsEnhanced;

namespace AgentSite4.Report
{
    public partial class PlayerDetails  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        public static string connString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
        public static string connStringAddOns = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Account"] != null)
            {
                getOpenBets();
                loadPlayerInfo();
            }
        }

        protected void loadPlayerInfo()
        {
            DataTable playerInfo = getPlayerInfo();

            foreach (DataRow linea in playerInfo.Rows)
            {
                lblAccount.Text = linea["Player"].ToString();

                txtPassword.Text = linea["OnlinePassword"].ToString();
                txtName.Text = linea["Name"].ToString();
                ddlUnderAgent.SelectedValue = linea["idAgent"].ToString();
                lblSportsTW.Text = linea["ThisWeekSports"].ToString();
                lblCasinoTW.Text = linea["ThisWeekCasino"].ToString();
                lblHorsesTW.Text = linea["ThisWeekHorses"].ToString();
                lblSportsLw.Text = linea["LastWeekSports"].ToString();
                lblCasinoLW.Text = linea["LastWeekCasino"].ToString();
                lblHorsesTW.Text = linea["LastWeekHorses"].ToString();
                lblLifeTime.Text = linea["LifeTimeWin"].ToString();
                lblCasinoLT.Text = linea["LifeTimeNetCasino"].ToString();
                lblHorsesLT.Text = linea["LifeTimeNetHorses"].ToString();
                txtCreditLimit.Text = linea["CreditLimit"].ToString();
                lblCurrentBalance.Text = linea["CurrentBalance"].ToString();
                lblAmountatRisk.Text = linea["AmountAtRisk"].ToString();
                lblAvailableBalance.Text = linea["AvailBalance"].ToString();
                lblFreePlay.Text = linea["FreePlayAmount"].ToString();
                lblBonusPoints.Text = linea["BonusPointsStatus"].ToString();
                lblTemporaryCreditAmount.Text = linea["TempCredit"].ToString();
                lblTemporaryCreditDate.Text = linea["TempCreditExpire"].ToString();
                lblLastWager.Text = linea["LastWager"].ToString();
                chkOnlineAccess.Checked = Convert.ToBoolean(linea["OnlineAccess"].ToString());
                ddlStatus.SelectedValue = linea["Status"].ToString();
                chkEnableSports.Checked = Convert.ToBoolean(linea["EnableSports"].ToString());
                chkEnableCasino.Checked = Convert.ToBoolean(linea["EnableCasino"].ToString());
                chkEnableHorses.Checked = Convert.ToBoolean(linea["EnableHorses"].ToString());
                chkPlayerWatch.Checked = Convert.ToBoolean(linea["playerWacth"].ToString());
                txtOnlineMaxWager.Text = linea["OnlineMaxWager"].ToString();
                txtOnlineMinWager.Text = linea["OnlineMinWager"].ToString();
                txtPhoneMaxWager.Text = linea["MaxWager"].ToString();
                txtPhoneMinWager.Text = linea["minWager"].ToString();

            }
        }

        protected int idPlayer(string player)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            int idPlayer = 0;
            DataTable table = new DataTable();
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("AddOn_GetPlayerByPlayer", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@Player", SqlDbType.VarChar)).Value = player;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception e)
            {
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            if (table.Rows.Count > 0)
            {
                idPlayer = (int)table.Rows[0]["idPlayer"];
            }
            return idPlayer;
        }

        protected void getOpenBets()
        {
            SqlConnection Cnn = new SqlConnection(connString);
            DataTable table = new DataTable();
            try
            {
                string IdAgent = Session[1].ToString();
                int IdPlayer = idPlayer(Request.QueryString["Account"]);
                Cnn.Open();
                SqlCommand comm = new SqlCommand("AddOn_OpenBets", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@IdAgent", SqlDbType.Int)).Value = IdAgent;
                ((SqlParameter)comm.Parameters.Add("@IdPlayer", SqlDbType.Int)).Value = IdPlayer;
                ((SqlParameter)comm.Parameters.Add("@WeeklyBalanace", SqlDbType.Int)).Value = 1;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception e)
            {
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            gvOpenBets.DataSource = table;
            gvOpenBets.DataBind();
        }

        protected DataTable getPlayerInfo()
        {
            SqlConnection Cnn = new SqlConnection(connStringAddOns);
            DataTable table = new DataTable();
            try
            {
                string IdAgent = Session[1].ToString();
                int IdPlayer = idPlayer(Request.QueryString["Account"]);
                Cnn.Open();
                SqlCommand comm = new SqlCommand("WebReport_PlayerInfo", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = IdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = IdPlayer;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception e)
            {
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
        }
    }
}
