using System;
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
    public partial class Default : BasePage, IRequiresSessionState
    {

        private static string AddOnsConnString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
        private static string sConnString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;


        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            if (!hasRights("Ticket Writer"))
            {
                Response.Redirect("~/Report/Welcome.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    int prmIdAgent = Convert.ToInt32(Session["IdAgent"].ToString());
                    TicketWriter_GetPlayers(prmIdAgent);
                }
                catch (Exception ex)
                {
                    litMsg.Text = "<div class='alert alert-danger'>Error: " + Server.HtmlEncode(ex.Message) + "</div>";
                }
            }
        }

        private void TicketWriter_GetPlayers(int prmIdAgent)
        {
            ddlPlayers.Items.Clear();
            ddlPlayers.AppendDataBoundItems = true;
            ddlPlayers.Items.Add(new System.Web.UI.WebControls.ListItem("Pick a Player...", ""));

            var playerPwd = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

            using (SqlConnection cn = new SqlConnection(AddOnsConnString))
            using (SqlCommand cmd = new SqlCommand("TicketWriter_GetPlayers", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = prmIdAgent;

                cn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        string player = dr["Player"] == DBNull.Value ? "" : dr["Player"].ToString();
                        string name = dr["Name"] == DBNull.Value ? "" : dr["Name"].ToString();
                        string agent = dr["Agent"] == DBNull.Value ? "" : dr["Agent"].ToString();
                        string pwd = dr["OnlinePassword"] == DBNull.Value ? "" : dr["OnlinePassword"].ToString();

                        if (string.IsNullOrEmpty(player)) continue;

                        string text = agent + " - " + player + " (" + name + ")";

                        string dataContent = "<span class='text-muted'>" + Html(agent) + " - </span>" +
                                             "<span class='player-strong'>" + Html(player) + "</span> " +
                                             "<span class='text-muted'>(" + Html(name) + ")</span>";

                        var li = new System.Web.UI.WebControls.ListItem(text, player);
                        li.Attributes["data-content"] = dataContent;
                        li.Attributes["data-tokens"] = player; // búsqueda por player
                        ddlPlayers.Items.Add(li);

                        if (!playerPwd.ContainsKey(player)) playerPwd[player] = pwd;
                    }
                }
            }

            Session["PlayerPwdMap"] = playerPwd;

            ddlPlayers.Attributes["title"] = "Type an Account.";
        }

        protected void ddlPlayers_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedPlayer = ddlPlayers.SelectedValue;
            if (string.IsNullOrEmpty(selectedPlayer))
            {
                litMsg.Text = "<div class='alert alert-warning'>You must pick a player.</div>";
                return;
            }

            try
            {
                var map = Session["PlayerPwdMap"] as Dictionary<string, string>;
                string onlinePwd = (map != null && map.ContainsKey(selectedPlayer)) ? map[selectedPlayer] : "";

                string agentStr = (Session["Agent"] == null) ? "" : Session["Agent"].ToString();
                string url = HttpContext.Current.Request.Url.Host.ToLower() + " | Agent:" + agentStr;

                CResultLogin oUser = GetLogin(selectedPlayer, onlinePwd, GetClientIP(), "0", url, "");
                HttpContext.Current.Session["userdata"] = (object)oUser;


                Response.Redirect("TicketWriter.aspx", false);
            }
            catch (Exception ex)
            {
                litMsg.Text = "<div class='alert alert-danger'>Account not found: " +
                              Server.HtmlEncode(ex.Message) + "</div>";
            }
        }

        protected bool hasRights(string rightDescription)
        {
            long prmIdAgent = long.Parse(HttpContext.Current.Session["IdAgent"].ToString());
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

        protected CResultLogin GetLogin(string prmUserName, string prmPassword, string prmIp, string prmIdBook, string URL, string prmGeoLocation)
        {
            short prmPhoneLine = -1;
            short Days = -1;
            char prmSystem = 'A';
            string empty1 = string.Empty;
            string empty2 = string.Empty;
            string empty3 = string.Empty;
            string empty4 = string.Empty;
            CResultLogin cresultLogin = new CResultLogin();
            prmUserName = prmUserName.Trim().ToUpper().Replace("'", "''");
            prmPassword = prmPassword.Trim();
            try
            {

                DataSet playerForLogin = GetPlayerForLogin(prmUserName);
                if (playerForLogin != null && playerForLogin.Tables.Count > 0 && playerForLogin.Tables[0].Rows.Count > 0)
                {
                    DataRow row1 = playerForLogin.Tables[0].Rows[0];

                    int num1 = (int)row1["IdPlayer"];

                    cresultLogin.IdPlayer = num1;
                    cresultLogin.IdUser = 285;
                    cresultLogin.EnableSports = (bool)row1["EnableSports"];
                    cresultLogin.EnableCasino = (bool)row1["EnableCasino"];
                    cresultLogin.EnableHorses = (bool)row1["EnableHorses"];
                    cresultLogin.LastCall = row1["LastCall"].ToString();
                    cresultLogin.IdAgent = row1["IdAgent"] == DBNull.Value ? -1 : (int)row1["IdAgent"];

                    int call = CreateCall(num1, prmPhoneLine, prmIp, prmSystem, URL, prmGeoLocation);

                    DataRow row2 = WebGetPlayer(num1).Tables[0].Rows[0];
                    if (row2["OnlineMessage"] != DBNull.Value)
                        row2["OnlineMessage"].ToString();
                    cresultLogin.IdProfile = (short)row2["IdProfile"];
                    cresultLogin.IdProfileLimits = (short)row2["IdProfileLimits"];
                    cresultLogin.Player = prmUserName;
                    cresultLogin.Password = prmPassword;
                    cresultLogin.IdCall = call;
                    cresultLogin.IdLineType = (short)row2["IdLineType"];
                    cresultLogin.LineStyle = row2["LineStyle"].ToString()[0];
                    cresultLogin.NHLLine = row2["NHLLine"].ToString()[0];
                    cresultLogin.MLBLine = row2["MLBLine"].ToString()[0];
                    cresultLogin.IdBook = (short)row2["IdBook"];
                    cresultLogin.OnlineMessage = row2["OnlineMessage"].ToString().Trim();
                    cresultLogin.Currency = row2["Currency"].ToString();
                    cresultLogin.CurrencySymbol = row2["CurrencySymbol"].ToString();
                    cresultLogin.UTC = (float)row2["GMT"];
                    cresultLogin.IdLanguage = (byte)row2["IdLanguage"];
                    cresultLogin.IdCurrency = (short)row2["IdCurrency"];
                    cresultLogin.CultureInfo = row2["CultureInfo"].ToString();
                    cresultLogin.PitcherDefault = (byte)row2["PitcherDefault"];
                    cresultLogin.BonusPointsStatus = row2["BonusPointsStatus"].ToString()[0];
                    cresultLogin.EnableParlayCards = (bool)row2["EnableCards"];
                    cresultLogin.ResetPassword = (bool)row2["Reset_Password"];
                    cresultLogin.EnforcesPassRules = (bool)row2["EnforcePassRules"];
                    cresultLogin.IdSession = call;
                    cresultLogin.GeoLocalition = prmGeoLocation;
                    DataRow row3 = GetPlayerBalance(num1).Tables[0].Rows[0];
                    cresultLogin.PrevCurrentBalance = (Decimal)row3["CurrentBalance"];
                    cresultLogin.PrevAvailBalance = (Decimal)row3["AvailBalance"];
                    cresultLogin.PrevAmountAtRisk = (Decimal)row3["AmountAtRisk"];
                    cresultLogin.PrevCreditLimit = (Decimal)row3["CreditLimit"];
                    cresultLogin.PrevFreePlayAmount = (Decimal)row3["FreePlayAmount"];

                }
            }
            catch (Exception ex)
            {
                string Msg = ex.ToString();
                if (ex.Message.IndexOf("System.NullReferenceException") != -1)
                    Msg = Msg + "Parameters [UserName: " + prmUserName + " ,Password: " + prmPassword + " ,IP: " + prmIp + " ,IDBook: " + prmIdBook + " ,IDUser: 285" + " ,URL: " + URL + " ,GeoLocation: " + prmGeoLocation + "]";
                cresultLogin.ErrorMsg = ex.ToString();
                cresultLogin.ErrorCode = CErrorCode.ErrorException;
                Logger.Log("Player.Login", Msg);
            }
            finally
            {
            }

            return cresultLogin;
        }

        protected DataSet GetPlayerBalance(int prmIdPlayer)
        {
            DataSet dataSet = (DataSet)null;
            SqlConnection connection = new SqlConnection(sConnString);
            try
            {
                SqlCommand selectCommand = new SqlCommand("GetPlayerBalance", connection);
                selectCommand.CommandType = CommandType.StoredProcedure;
                selectCommand.Parameters.Add("@prmIdPlayer", SqlDbType.Int, 0).Value = (object)prmIdPlayer;
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand);
                dataSet = new DataSet();
                sqlDataAdapter.Fill(dataSet, "DataSet");
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }
            return dataSet;
        }

        protected DataSet GetPlayerForLogin(string prmUserName)
        {
            DataSet dataSet = (DataSet)null;
            SqlConnection connection = new SqlConnection(sConnString);
            try
            {
                SqlCommand selectCommand = new SqlCommand("GetPlayerForLogin", connection);
                selectCommand.CommandType = CommandType.StoredProcedure;
                selectCommand.Parameters.Add("@UserName", SqlDbType.VarChar, 20).Value = (object)prmUserName;
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand);
                dataSet = new DataSet();
                sqlDataAdapter.Fill(dataSet, "DataSet");
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }
            return dataSet;
        }

        protected int CreateCall(int prmIdPlayer, short prmPhoneLine, string prmIp, char prmSystem, string URL, string GEO)
        {
            SqlConnection connection = new SqlConnection(sConnString);
            try
            {
                connection.Open();
                SqlCommand sqlCommand = new SqlCommand("CreateCallWeb", connection);
                sqlCommand.CommandType = CommandType.StoredProcedure;
                sqlCommand.Parameters.Add("@IdPlayer", SqlDbType.Int, 0).Value = (object)prmIdPlayer;
                sqlCommand.Parameters.Add("@PhoneLine", SqlDbType.SmallInt, 0).Value = (object)prmPhoneLine;
                sqlCommand.Parameters.Add("@IdUser", SqlDbType.SmallInt, 0).Value = 285;
                sqlCommand.Parameters.Add("@IP", SqlDbType.VarChar, 100).Value = (object)prmIp;
                sqlCommand.Parameters.Add("@System", SqlDbType.Char, 1).Value = (object)prmSystem;
                sqlCommand.Parameters.Add("@IdCall", SqlDbType.Int, 1).Direction = ParameterDirection.Output;
                sqlCommand.Parameters.Add("@URL", SqlDbType.VarChar, 50).Value = (object)URL;
                sqlCommand.Parameters.Add("@GEO", SqlDbType.VarChar, 250).Value = (object)GEO;
                sqlCommand.ExecuteNonQuery();
                return (int)sqlCommand.Parameters["@IdCall"].Value;
            }
            catch (Exception ex)
            {
                Logger.Log("DBaccess.CreateCall", ex.ToString());
                return -1;
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }
        }

        protected DataSet WebGetPlayer(int prmIdPlayer)
        {
            DataSet dataSet = (DataSet)null;
            SqlConnection connection = new SqlConnection(sConnString);
            try
            {
                SqlCommand selectCommand = new SqlCommand("WebGetPlayerOnline", connection);
                selectCommand.CommandType = CommandType.StoredProcedure;
                selectCommand.Parameters.Add("@IdPlayer", SqlDbType.Int, 0).Value = (object)prmIdPlayer;
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectCommand);
                dataSet = new DataSet();
                sqlDataAdapter.Fill(dataSet, "DataSet");
            }
            finally
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
            }
            return dataSet;
        }

        public string GetClientIP()
        {
            HttpRequest request = HttpContext.Current.Request;
            string serverVariable = request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (serverVariable == null || serverVariable == "")
            {
                serverVariable = request.ServerVariables["REMOTE_ADDR"];
            }
            serverVariable += ", Agent:" + Session["Agent"].ToString();
            return serverVariable;
        }


        private static string Html(string s)
        {
            return System.Web.HttpUtility.HtmlEncode(s ?? "");
        }
    }
}