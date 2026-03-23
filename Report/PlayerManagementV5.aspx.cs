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
using AgentSite4.ASP;

namespace AgentSite4.Report
{
    public partial class PlayerManagementV5  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        int howManyPlayers = 0;
        int TotalMasterPlayers = 0;
        int TotalMasterPlayers2 = 0;
        int GranTotalPlayers = 0;
        int GranTotalPlayersNoAcction = 0;
        bool isTableOpen = false;
        int agentLevel = 0;
        string AgentCurrecncy = "$";
        bool editRight = true;
        bool paymentRight = true;

        protected void Page_Init(object sender, EventArgs e)
        {
            paymentRight = HasRights("PLAYER PAYMENT");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                string prmAgent = this.Session["SubAgent"].ToString();
                buildAgent(prmIdAgent, prmAgent);
            }
            paymentRight = HasRights("PLAYER PAYMENT");
        }

        protected DataTable getAllAgents(int prmIdAgent)
        {

            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("WebGetAllSubAgentsOneLevel", Cnn);

                comm.CommandTimeout = 120;
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmLevel", SqlDbType.Bit)).Value = 0;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception myErr)
            {
                Response.Write(myErr.Message);
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
        }

        protected bool hasPlayers(int idAgent)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("select * from Player where idAgent = @idAgent", Cnn);
                comm.CommandType = CommandType.Text;
                comm.CommandTimeout = 120;
                comm.Parameters.AddWithValue("@idAgent", idAgent);
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception myErr)
            {
                Response.Write(myErr.Message);
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            if (table.Rows.Count > 0)
            {
                return true;
            }
            else
            {
                return false;
            }

        }

        protected DataTable PlayersManagementV5(int idAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            DataTable table = new DataTable();
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("PlayersManagementV5", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
                table.Load(reader);
            }
            catch (Exception myErr)
            {
                Response.Write(myErr.Message);
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            return table;
        }


        protected bool isDistributor(int idAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            DataTable table = new DataTable();
            bool IsDistributor = false;
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("AddOn_GetAgentInfo", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@idAgent", SqlDbType.Int)).Value = idAgent;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
                table.Load(reader);
            }
            catch (Exception myErr)
            {
                Response.Write(myErr.Message);
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            if (table.Rows.Count > 0)
            {
                IsDistributor = Convert.ToBoolean(table.Rows[0]["IsDistributor"]);
            }

            return IsDistributor;
        }

        protected bool hasPlayers(int idAgent, bool isDistributor)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            DataTable table = new DataTable();
            bool hasPlayers = false;
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("AddOn_Agent_GetPlayers", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
                table.Load(reader);
            }
            catch (Exception myErr)
            {
                Response.Write(myErr.Message);
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            if (table.Rows.Count > 0)
            {
                hasPlayers = true;
            }

            return hasPlayers;
        }

        protected string playerRow(DataRow player)
        {
            string IdPlayer = player["IdPlayer"].ToString();
            string Player = player["Player"].ToString();
            string Name = player["Name"].ToString();
            string Password = player["Password"].ToString();
            string OnlinePassword = player["OnlinePassword"].ToString();
            string CreditLimit = Convert.ToDecimal(player["CreditLimit"]).ToString("###,##0");
            string MaxWager = Convert.ToDecimal(player["MaxWager"]).ToString("###,##0");
            string OnlineMaxWager = Convert.ToDecimal(player["OnlineMaxWager"]).ToString("###,##0");
            string MinWager = Convert.ToDecimal(player["MinWager"]).ToString("###,##0");
            string OnlineMinWager = Convert.ToDecimal(player["OnlineMinWager"]).ToString("###,##0");
            string Status = player["Status"].ToString() == "E" ? "Yes" : "<spanclass='neg'>No</span>";
            string onlineAccess = Convert.ToBoolean(player["onlineAccess"]) ? "Yes" : "<spanclass='neg'>No</span>";
            string EnableSports = Convert.ToBoolean(player["EnableSports"]) ? "Yes" : "<spanclass='neg'>No</span>";
            string EnableCasino = Convert.ToBoolean(player["EnableCasino"]) ? "Yes" : "<spanclass='neg'>No</span>";
            string EnableHorses = Convert.ToBoolean(player["EnableHorses"]) ? "Yes" : "<spanclass='neg'>No</span>";
            string LastWager = player["LastWager"] == System.DBNull.Value ? "" : Convert.ToDateTime(player["LastWager"]).ToString("MMM dd");


            string playerrow =
            "<TR>" +
            "<TD>" +
            "<AHREF='#'onclick='OpenPlayerStats(" + IdPlayer + ")'>" +
            Player +
            "</A>-" + OnlinePassword +
            "</TD>" +
            "<TD>" +
            AgentCurrecncy +
            CreditLimit +
            "</TD>" +
            "<TD>" +
            AgentCurrecncy +
            MaxWager +
            "</TD>" +
            "<TD class='hidden-sm-down'>" +
            AgentCurrecncy +
            MinWager +
            "</TD>" +
            "<TD class='hidden-sm-down'>" +
            Status +
            "</TD>" +
            "<TD class='hidden-sm-down'>" +
            EnableSports +
            "</TD>" +
            "<TD class='hidden-sm-down'>" +
            EnableCasino +
            "</TD>" +
            "<TD class='hidden-sm-down'>" +
            EnableHorses +
            "</TD>" +
            "<TD class='hidden-sm-down'>" +
            LastWager +
            "</TD>" +
            "<TD>" +
            PayButton(IdPlayer) +
            "</TD>" +
            "<TD>" +
            EditButton(IdPlayer) +
            "</TD>" +
            "</TR>";

            return playerrow;
        }

        protected string PayButton(string IdPlayer)
        {
            string response = "";
            if (editRight)
            {
                response = "<A HREF='PlayerEditEnhanced.aspx?player=" + IdPlayer + "'><button type='button' class='btn btn-warning btn-sm'><i class='fa fa-pencil-square-o' aria-hidden='true'></i></button></A>";
            }
            return response;
        }

        protected string EditButton(string IdPlayer)
        {
            string response = "";
            if (editRight)
            {
                response = "<a href='PlayerPayment.aspx?player=" + IdPlayer + "'><button type='button' class='btn btn-success btn-sm'><i class='fa fa-usd' aria-hidden='true'></i></button></a>";
            }
            return response;
        }

        protected string buildAgent(int idAgent, string agent)
        {
            string result = "";
            bool IsDistributor = isDistributor(idAgent);

            int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
            if (prmIdAgent == idAgent)
            {
                result += "<div class='card'><div class='card-body'><h4 class='card-title'></h4><div class='table-responsive'>";
                result += "<TABLE CLASS='table-dynamic table table-bordered table-striped table-sm hover-table'>";
            }
            if (hasPlayers(idAgent))
            {
                DataTable players = PlayersManagementV5(idAgent);


                result += "<THEAD><tr class='trAgent'><th class='hidden-sm-down' colspan='11'>" + agent + "</th><th class='hidden-md-up' colspan='5'>" + agent + "</th></tr>";
                result += "<TR><TH>Player/Pass</TH><TH>Credit Limit</TH><TH>MaxWager</TH><TH class='hidden-sm-down'>Life Time</TH><TH class='hidden-sm-down'>Enable</TH><TH class='hidden-sm-down'>Sport</TH><TH class='hidden-sm-down'>Casino</TH><TH class='hidden-sm-down'>Horses</TH><TH class='hidden-sm-down'>Last Wager</TH><TH>Edit</TH><TH>$PMT</TH></TR></THEAD><TBODY>";

                foreach (DataRow lineaP in players.Rows)
                {
                    result += playerRow(lineaP);
                }

            }
            DataTable Agents = getAllAgents(idAgent);
            if (Agents.Rows.Count > 0)
            {
                if (hasPlayers(idAgent, true))
                {
                    string cssClass = IsDistributor ? "page-titles trAgent" : "trAgent";
                    string style = IsDistributor ? "style='text-align: center;'" : "";
                    result += "<THEAD><tr class='trAgent'><th class='hidden-sm-down' " + style + " colspan='11'>" + agent + "</th><th class='hidden-md-up' " + style + " colspan='5'>" + agent + "</th></tr>";
                    foreach (DataRow linea in Agents.Rows)
                    {
                        result += buildAgent(Convert.ToInt32(linea["idAgent"]), linea["Agent"].ToString());
                    }
                }

            }
            if (prmIdAgent == idAgent)
            {
                result += "</TBODY></TABLE>";
                result += "</div></div></div>";

            }
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="rightDescription">PLAYER PAYMENT,</param>
        /// <returns></returns>
        protected bool HasRights(string rightDescription)
        {
            int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
            bool hasRights = false;
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                SqlCommand comm1 = new SqlCommand("AddOn_AgentRights_GetRights_Description", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm1.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm1.Parameters.Add("@prmDescription", SqlDbType.VarChar)).Value = rightDescription;
                SqlDataReader reader = comm1.ExecuteReader();
                DataTable table = new DataTable();
                table.Load(reader);
                if (table.Rows.Count > 0)
                {
                    hasRights = Convert.ToBoolean(table.Rows[0]["hasRight"]);
                }
            }
            catch
            {
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            return hasRights;
        }

    }
}
