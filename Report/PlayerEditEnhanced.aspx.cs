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
    public partial class PlayerEditEnhanced : BasePage, IRequiresSessionState
    {

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                load();
                authoriseControls();

            }
            verifiedHierarchy();
        }


        protected DataTable PlayerEdit_GetPlayerByID(int IdPlayer)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            DataTable table = new DataTable();
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("PlayerEdit_GetPlayerByID", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = IdPlayer;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
                table.Load(reader);
            }
            catch (Exception myErr)
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            return table;
        }

        protected DataTable PlayerMessages_LastMessage(int IdPlayer)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            DataTable table = new DataTable();
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("PlayerMessages_LastMessage", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = IdPlayer;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
                table.Load(reader);
                if (table.Rows.Count > 0)
                {
                    DataRow linea = table.Rows[0];
                    txtMessage.Text = linea["Message"].ToString();
                    hdfIdPlayerMessage.Value = linea["IdPlayerMessage"].ToString();
                    ddlMessageType.SelectedValue = linea["MessageType"].ToString();
                    chkExpirationDate.Checked = Convert.ToBoolean(linea["UseExpirationDate"]);
                    txtExpirationDate.Text = Convert.ToDateTime(linea["ExpirationDate"]).ToString("MM/dd/yyyy");
                    chkDisplaycounter.Checked = Convert.ToBoolean(linea["UseDisplayCounter"]);
                    txtCounter.Text = linea["DisplayCounter"].ToString();
                    chkPlayerCanDisable.Checked = Convert.ToBoolean(linea["UseDisplayCounter"]);


                }
                else
                {
                    btnUpdate.Visible = false;
                }
            }
            catch (Exception myErr)
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            return table;
        }

        protected void load()
        {
            int idPlayer = Convert.ToInt32(Request.QueryString["player"]);
            PlayerMessages_LastMessage(idPlayer);
            DataTable table = PlayerEdit_GetPlayerByID(idPlayer);
            if (table.Rows.Count > 0)
            {
                DataRow player = table.Rows[0];
                hdfval.Value = player["idAgent"].ToString();
                //player["IdLineType"].ToString();
                hdfPlayerProfile.Value = ddlPlayerProfile.SelectedValue = player["IdProfile"].ToString();
                hdfTimeZone.Value = ddlTimeZone.SelectedValue = player["IdTimeZone"].ToString();
                //player["ScheduleStyle"].ToString();
                lblPlayer1.Text = lblPlayer2.Text = player["Player"].ToString();
                //player["Password"].ToString();
                hdfName.Value = txtName.Text = player["Name"].ToString();
                hdfLastName.Value = txtLastName.Text = player["LastName"].ToString();
                hdfLastName2.Value = txtLastName.Text = player["LastName2"].ToString();
                hdfStatus.Value = ddlStatus.Text = player["Status"].ToString();
                //int creditLimit = getAgentCreditLimit(Convert.ToInt32(player["idAgent"].ToString()));
                int creditLimit = getAgentCreditLimit(Convert.ToInt32(Session["SubIdAgent"].ToString()));
                if (creditLimit > 0)
                {
                    rngValidatorCreditLimit.MaximumValue = creditLimit.ToString();
                    rngValidatorCreditLimit.ErrorMessage = "MAXIMUM AMOUNT " + creditLimit.ToString();
                    rngValidatorCreditLimit.Style.Add("min-height", "86px");
                    rngValidatorCreditLimit.Style.Add("text-align", "center");
                    rngValidatorCreditLimit.Style.Add("background", "#dc3545");
                    rngValidatorCreditLimit.Style.Add("color", "#fff");

                    int tempCredit = creditLimit - Convert.ToInt32(player["CreditLimit"]);
                    if (tempCredit <= 0)
                    {
                        tempCredit = 0;
                    }
                    rngTemValidatorCreditLimit.ErrorMessage = "MAXIMUM AMOUNT " + tempCredit.ToString();
                    rngTemValidatorCreditLimit.MaximumValue = tempCredit.ToString();
                    rngTemValidatorCreditLimit.Style.Add("min-height", "86px");
                    rngTemValidatorCreditLimit.Style.Add("text-align", "center");
                    rngTemValidatorCreditLimit.Style.Add("background", "#dc3545");
                    rngTemValidatorCreditLimit.Style.Add("color", "#fff");
                }
                else
                {
                    rngValidatorCreditLimit.Enabled = false;
                    rngTemValidatorCreditLimit.Enabled = false;
                }
                hdfCreLimit.Value = txtCreLimit.Text = Convert.ToInt32(player["CreditLimit"]).ToString();

                hdfTempCredit.Value = txtTempCredit.Text = Convert.ToInt32(player["TempCredit"]).ToString();
                hdfTempCreditExp.Value = txtTempCreditExp.Text = Convert.ToDateTime(player["TempCreditExpire"]).ToString("MM/dd/yyyy");
                //ddlStatus.SelectedValue = player["Status"].ToString();
                hdfOnlinePassword.Value = txtOnlinePassword.Text = player["OnlinePassword"].ToString();
                //player["OnlineMessage"].ToString();
                hdfMaxOnLine.Value = txtMaxOnLine.Text = Convert.ToInt32(player["OnlineMaxWager"]).ToString();
                hdfMinOnLine.Value = txtMinOnLine.Text = Convert.ToInt32(player["OnlineMinWager"]).ToString();
                hdfMax.Value = txtMax.Text = Convert.ToInt32(player["MaxWager"]).ToString();
                hdfMin.Value = txtMin.Text = Convert.ToInt32(player["MinWager"]).ToString();
                hdfLineStyle.Value = ddlLineStyle.SelectedValue = player["LineStyle"].ToString();
                hdfHockeyLine.Value = ddlHockeyLine.SelectedValue = player["NHLLine"].ToString();
                hdfBaseballLine.Value = ddlBaseballLine.SelectedValue = player["MLBLine"].ToString();
                hdfSettledFigure.Value = txtSettledFigure.Text = Convert.ToInt64(player["SettledFigure"]).ToString();
                hdfOnline.Value = player["OnlineAccess"].ToString();
                chkOnline.Checked = Convert.ToBoolean(player["OnlineAccess"]);
                hdfHorses.Value = player["EnableHorses"].ToString();
                chkHorses.Checked = Convert.ToBoolean(player["EnableHorses"]);
                hdfCasino.Value = player["EnableCasino"].ToString();
                chkCasino.Checked = Convert.ToBoolean(player["EnableCasino"]);
                hdfSports.Value = player["EnableSports"].ToString();
                chkSports.Checked = Convert.ToBoolean(player["EnableSports"]);
                //player["HoldBets"].ToString();
                //player["HoldDelay"].ToString();
                hdfPlayerProfileLimits.Value = ddlPlayerProfileLimits.SelectedValue = player["IdProfileLimits"].ToString();
                hdfParlay.Value = player["EnableCards"].ToString();
                chkParlay.Checked = Convert.ToBoolean(player["EnableCards"]);
                lblCurrentBalance.Text = Convert.ToDecimal(player["currentBalance"]).ToString("N0");
                lblAtRisk.Text = Convert.ToDecimal(player["AmountAtRisk"]).ToString("N0");
                player["AvailBalance"].ToString();
                lblLifeTime.Text = Convert.ToDecimal(player["lifeTime"]).ToString("N0");

                int idAgent = Convert.ToInt32(player["idAgent"].ToString());
                hdfIdAgent.Value = idAgent.ToString();
                loadAgentDDL(idAgent);

            }

            if (Convert.ToBoolean(Session["PLAYERCANCELRACTICKET"]))
            {
                DataTable tbCancelRights = PlayerCancelBet_Get();

                if (tbCancelRights.Rows.Count > 0)
                {
                    chkCancelRaceTicket.Checked = Convert.ToBoolean(tbCancelRights.Rows[0]["canCancelRacing"]);
                }
            }
            else
            {
                divCancelRights.Visible = false;
            }


        }

        protected void authoriseControls()
        {
            DataTable agentRights = ManageSubAgent_GetAgentRights();

            if (!hasRight(agentRights, "CHANGE PROFILE LIMIT"))
            {
                divProfile.Visible = false;
                divPlayerProfileLimits.Visible = false;
            }
            if (!hasRight(agentRights, "CHANGE TEMPORAL CREDIT"))
            {
                divTempCredit.Visible = false;
                divTempCreditExp.Visible = false;
            }
            if (!hasRight(agentRights, "EDIT CREDIT LIMIT"))
            {
                divCreLimit.Visible = false;
            }
            if (!hasRight(agentRights, "INCREASE WAGER LIMIT LOCAL"))
            {
                divMaxWager.Visible = false;
                divMinWager.Visible = false;
            }
            if (!hasRight(agentRights, "INCREASE WAGER LIMIT ONLINE"))
            {
                divOMaxWager.Visible = false;
                divOMinWager.Visible = false;
            }

        }

        protected bool hasRight(DataTable agentRights, string rightName)
        {
            bool haveRight = false;
            foreach (DataRow right in agentRights.Rows)
            {
                if (right["Description"].ToString() == rightName.ToString())
                {
                    haveRight = true;
                }
            }
            return haveRight;

        }

        protected DataTable ManageSubAgent_GetAgentRights()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            DataTable table = new DataTable();
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("ManageSubAgent_GetAgentRights", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = Convert.ToInt32(Session["idAgent"]);
                SqlDataReader reader;
                reader = comm.ExecuteReader();
                table.Load(reader);
            }
            catch (Exception myErr)
            {
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
        }



        protected DataTable PlayerCancelBet_Get()
        {

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            int idPlayer = Convert.ToInt32(Request.QueryString["player"]);
            DataTable table = new DataTable();
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("PlayerCancelBet_Get", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = idPlayer;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
                table.Load(reader);
            }
            catch (Exception myErr)
            {
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
        }

        protected int getAgentCreditLimit(int prmIdAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            int agentCreaditLimit = 0;
            try
            {

                SqlCommand comm = new SqlCommand("AgentCreditLimitGet", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;

                SqlDataReader reader;
                reader = comm.ExecuteReader();
                DataTable table = new DataTable();
                table.Load(reader);
                if (table.Rows.Count > 0)
                {
                    agentCreaditLimit = Convert.ToInt32(table.Rows[0]["CreditLimit"]);
                }

            }
            catch { }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return agentCreaditLimit;
        }


        protected void verifiedHierarchy()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();

            bool hasAcces = false;
            int prmDistributor = int.Parse(this.Session["IdAgent"].ToString());
            int idAgent = Convert.ToInt32(hdfval.Value);

            SqlCommand comm = new SqlCommand("VerifiedHierarchy", Cnn);
            comm.CommandType = CommandType.StoredProcedure;
            ((SqlParameter)comm.Parameters.Add("@prmDistributor", SqlDbType.Int)).Value = prmDistributor;
            ((SqlParameter)comm.Parameters.Add("@prmIdgent", SqlDbType.Int)).Value = idAgent;
            SqlDataReader reader;

            try
            {
                reader = comm.ExecuteReader();
                while (reader.Read())
                {
                    hasAcces = Convert.ToBoolean(reader["inHierarchy"]);
                }
                reader.Close();
            }
            catch (Exception err)
            {
                //Response.Write(err.Message);
            }
            finally
            {
                Cnn.Close();
            }
            if (!hasAcces)
            {
                Response.Redirect("~/Report/Welcome.aspx");
            }
        }


        protected void SaveField(string field, string value)
        {
            verifiedHierarchy();
            int idPlayer = Convert.ToInt32(Request.QueryString["player"]);
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();

            try
            {
                SqlCommand comm = new SqlCommand("PlayerEditEnhanced_Update", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = idPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmField", SqlDbType.VarChar)).Value = field;
                ((SqlParameter)comm.Parameters.Add("@prmValue", SqlDbType.VarChar)).Value = value;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
            }
            catch (Exception myErr)
            {
                //lblError.Text = "Agent can't be added, plase try later";
                lblError.Text = myErr.Message;
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            Session["tblPlayerList"] = null;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {

            if (hdfCreLimit.Value != txtCreLimit.Text) SaveField("CreditLimit", txtCreLimit.Text);
            if (Convert.ToBoolean(hdfParlay.Value) != chkParlay.Checked) SaveField("EnableCards", chkParlay.Checked.ToString());
            if (Convert.ToBoolean(hdfCasino.Value) != chkCasino.Checked) SaveField("EnableCasino", chkCasino.Checked.ToString());
            if (Convert.ToBoolean(hdfHorses.Value) != chkHorses.Checked) SaveField("EnableHorses", chkHorses.Checked.ToString());
            if (Convert.ToBoolean(hdfSports.Value) != chkSports.Checked) SaveField("EnableSports", chkSports.Checked.ToString());
            //hdfHoldBets.Value != txtHoldBets.Text) SaveField("HoldBets", txtHoldBets.Text);
            //hdfHoldDelay.Value != txtHoldDelay.Text) SaveField("HoldDelay", txtHoldDelay.Text);

            if (hdfPlayerProfile.Value != ddlPlayerProfile.SelectedValue) SaveField("IdProfile", ddlPlayerProfile.SelectedValue);
            if (hdfPlayerProfileLimits.Value != ddlPlayerProfileLimits.SelectedValue) SaveField("IdProfileLimits", ddlPlayerProfileLimits.SelectedValue);
            if (hdfTimeZone.Value != ddlTimeZone.SelectedValue) SaveField("IdTimeZone", ddlTimeZone.SelectedValue);
            if (hdfLastName.Value != txtLastName.Text) SaveField("LastName", txtLastName.Text);
            if (hdfLastName2.Value != txtLastName2.Text) SaveField("LastName2", txtLastName2.Text);
            if (hdfLineStyle.Value != ddlLineStyle.Text) SaveField("LineStyle", ddlLineStyle.SelectedValue);
            if (hdfMax.Value != txtMax.Text) SaveField("MaxWager", txtMax.Text);
            if (hdfMin.Value != txtMin.Text) SaveField("MinWager", txtMin.Text);

            if (hdfMax.Value != txtMax.Text) SaveField("OnlineMaxWager", txtMax.Text);
            if (hdfMin.Value != txtMin.Text) SaveField("OnlineMinWager", txtMin.Text);
            //if (hdfMaxOnLine.Value != txtMaxOnLine.Text) SaveField("OnlineMaxWager", txtMaxOnLine.Text);
            //if (hdfMinOnLine.Value != txtMinOnLine.Text) SaveField("OnlineMinWager", txtMinOnLine.Text);



            if (hdfBaseballLine.Value != ddlBaseballLine.SelectedValue) SaveField("MLBLine", ddlBaseballLine.SelectedValue);
            if (hdfName.Value != txtName.Text) SaveField("Name", txtName.Text);
            if (hdfHockeyLine.Value != ddlHockeyLine.SelectedValue) SaveField("NHLLine", ddlHockeyLine.SelectedValue);
            if (Convert.ToBoolean(hdfOnline.Value) != chkOnline.Checked) SaveField("OnlineAccess", chkOnline.Checked.ToString());
            //if(hdfOnlineMessage.Value != txtOnlineMessage.Text) SaveField("OnlineMessage", txtOnlineMessage.Text);                
            if (hdfOnlinePassword.Value != txtOnlinePassword.Text) SaveField("OnlinePassword", txtOnlinePassword.Text);
            //if(hdfPassword.Value != txtPassword.Text) SaveField("Password", txtPassword.Text);
            //if(hdfPlayer.Value != txtPlayer.Text) SaveField("Player", txtPlayer.Text);
            //if(hdfScheduleStyle.Value != txtScheduleStyle.Text) SaveField("ScheduleStyle", txtScheduleStyle.Text);
            if (hdfSettledFigure.Value != txtSettledFigure.Text) SaveField("SettledFigure", txtSettledFigure.Text);
            if (hdfStatus.Value != ddlStatus.SelectedValue) SaveField("Status", ddlStatus.SelectedValue);
            if (hdfTempCredit.Value != txtTempCredit.Text) SaveField("TempCredit", txtTempCredit.Text);
            if (hdfTempCreditExp.Value != txtTempCreditExp.Text) SaveField("TempCreditExpire", txtTempCreditExp.Text);

            if (hdfIdAgent.Value != ddlAgent.SelectedValue)
            {
                int oldIdAgent = int.Parse(hdfIdAgent.Value);
                int idAgent = int.Parse(ddlAgent.SelectedValue);
                SaveIdAgent();
                PlayersManagementV5(oldIdAgent);
                PlayersManagementV5(idAgent);
            }
            else
            {
                int idAgent = int.Parse(ddlAgent.SelectedValue);
                PlayersManagementV5(idAgent);
            }
            lblMessageTitle.Text = "Changes Applied";
            lblMessage.Text = "The player changes were made successfully";
            pnAlert.Visible = true;
            load();



        }

        protected void btnCreateMessage_Click(object sender, EventArgs e)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            try
            {
                int idPlayer = Convert.ToInt32(Request.QueryString["player"]);
                bool MessageType = ddlMessageType.SelectedValue == "N" ? false : true;
                bool UseExpirationDate = chkExpirationDate.Checked;
                bool UseDisplayCounter = txtCounter.Text == "" || txtCounter.Text == "0" ? false : true;
                bool UseCloseOption = chkPlayerCanDisable.Checked;
                DateTime ExpirationDate = txtExpirationDate.Text != "" ? Convert.ToDateTime(txtExpirationDate.Text) : DateTime.Now.AddDays(180);
                byte DisplayCounter = txtCounter.Text == "" ? Convert.ToByte(0) : Convert.ToByte(txtCounter.Text);
                DateTime LastModification = DateTime.Now;
                Cnn.Open();
                SqlCommand comm = new SqlCommand("PlayerMessages_Insert", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = idPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmMessage", SqlDbType.VarChar)).Value = txtMessage.Text;
                ((SqlParameter)comm.Parameters.Add("@prmMessageType", SqlDbType.Bit)).Value = MessageType;
                ((SqlParameter)comm.Parameters.Add("@prmUseExpirationDate", SqlDbType.Bit)).Value = UseExpirationDate;
                ((SqlParameter)comm.Parameters.Add("@prmUseDisplayCounter", SqlDbType.Bit)).Value = UseDisplayCounter;
                ((SqlParameter)comm.Parameters.Add("@prmUseCloseOption", SqlDbType.Bit)).Value = UseCloseOption;
                ((SqlParameter)comm.Parameters.Add("@prmExpirationDate", SqlDbType.Date)).Value = ExpirationDate;
                ((SqlParameter)comm.Parameters.Add("@prmDisplayCounter", SqlDbType.TinyInt)).Value = DisplayCounter;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 0;

                SqlDataReader reader;
                reader = comm.ExecuteReader();
                lblMessageTitle.Text = "Message Sent";
                lblMessage.Text = "The Message has been successfully sent to the player";
                pnAlert.Visible = true;
            }
            catch (Exception myErr)
            {
                //lblMessageTitle.Text = "Message can't be sent";
                //lblMessage.Text = myErr.Message;
                //pnAlert.Visible = true;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }


        protected void btnUpdateMessage_Click(object sender, EventArgs e)
        {
            UpdateMessage(Convert.ToInt32(hdfIdPlayerMessage.Value), txtMessage.Text);
        }

        protected void UpdateMessage(int IdPlayerMessage, string message)
        {

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("ManagePlayerMessages_Update", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdPlayerMessage", SqlDbType.Int)).Value = IdPlayerMessage;
                ((SqlParameter)comm.Parameters.Add("@prmMessage", SqlDbType.VarChar)).Value = message;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
            }
            catch (Exception myErr) { Response.Write(myErr.Message); }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }


        protected void PlayerCancelBet_Insert(bool canCancelRacing, bool canCancelSports)
        {
            if (Convert.ToBoolean(Session["PLAYERCANCELRACTICKET"]))
            {
                int idPlayer = Convert.ToInt32(Request.QueryString["player"]);
                string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
                SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
                try
                {
                    Cnn.Open();
                    SqlCommand comm = new SqlCommand("PlayerCancelBet_Insert", Cnn);
                    comm.CommandType = CommandType.StoredProcedure;

                    ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = idPlayer;
                    ((SqlParameter)comm.Parameters.Add("@prmCanCancelRacing", SqlDbType.Bit)).Value = canCancelRacing;
                    ((SqlParameter)comm.Parameters.Add("@prmCanCancelSports", SqlDbType.Bit)).Value = canCancelSports;
                    SqlDataReader reader;
                    reader = comm.ExecuteReader();
                }
                catch (Exception myErr) { Response.Write(myErr.Message); }
                finally
                {
                    if (Cnn.State == ConnectionState.Open) Cnn.Close();
                }
            }
        }

        protected void chkCancelRaceTicket_CheckedChanged(object sender, EventArgs e)
        {
            PlayerCancelBet_Insert(chkCancelRaceTicket.Checked, false);
        }

        protected void loadAgentDDL(int idAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                //Convert.ToInt32(Request.QueryString["idPlayer"]);
                int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());

                SqlCommand comm1 = new SqlCommand("Agent_GetAgentsOrDistributors", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm1.Parameters.Add("@idAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm1.Parameters.Add("@IsDistributor", SqlDbType.Bit)).Value = 0;
                SqlDataReader reader;
                reader = comm1.ExecuteReader();
                ListItem newItem = new ListItem();
                while (reader.Read())
                {
                    newItem = new ListItem();
                    newItem.Value = reader["IdAgent"].ToString();
                    newItem.Text = reader["AGENT"].ToString();
                    ddlAgent.Items.Add(newItem);
                }
                if (ddlAgent.Items.Count == 0)
                {
                    newItem = new ListItem();
                    newItem.Value = this.Session["IdAgent"].ToString();
                    newItem.Text = AgentName();
                    ddlAgent.Items.Add(newItem);
                }
                else if (Session["Agent"].ToString() == "BTQZ2A" || Session["Agent"].ToString() == "BTQZ2B")
                {
                    ddlAgent.SelectedValue = idAgent.ToString();
                }
                else
                {
                    ddlAgent.SelectedValue = idAgent.ToString();
                    ddlAgent.Enabled = true;
                }
            }
            catch (Exception e)
            {
                lblError.Text = e.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

        }

        protected string AgentName()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            string agent = "";
            try
            {
                Cnn.Open();
                //Convert.ToInt32(Request.QueryString["idPlayer"]);
                int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());

                SqlCommand Cmd = new SqlCommand("select * from agent where IdAgent = @IdAgent", Cnn);
                Cmd.CommandType = CommandType.Text;
                ((SqlParameter)Cmd.Parameters.Add("@IdAgent", SqlDbType.Int)).Value = prmIdAgent;

                SqlDataReader reader;
                reader = Cmd.ExecuteReader();
                ListItem newItem = new ListItem();


                while (reader.Read())
                {
                    agent = reader["AGENT"].ToString();
                }

            }
            catch (Exception e)
            {
                lblError.Text = e.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            return agent;
        }

        protected void SaveIdAgent()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn2 = new SqlConnection(DGS_AddOnsConnectionString);

            try
            {
                Cnn2.Open();

                int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
                int prmSubIdAgent = int.Parse(ddlAgent.SelectedValue);
                int idPlayer = Convert.ToInt32(Request.QueryString["player"]);

                SqlCommand comm1 = new SqlCommand("AddOn_EditPlayer", Cnn2);
                comm1.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm1.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = idPlayer;
                ((SqlParameter)comm1.Parameters.Add("@prmCurrentIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm1.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmSubIdAgent;

                SqlDataReader reader;
                reader = comm1.ExecuteReader();

                Cnn2.Close();


            }
            catch (Exception myErr)
            {
                //lblError2.Text = "Player can't be edited, please try later";
                //lblError2.Text = myErr.Message;
            }
            finally
            {
                if (Cnn2.State == ConnectionState.Open) Cnn2.Close();
            }
        }

        protected DataTable PlayersManagementV5(int idAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            DataTable table = new DataTable();
            try
            {
                string key = idAgent + ",PlayersManagementV5";

                if (HttpContext.Current.Cache[key] != null)
                {
                    table = (DataTable)HttpContext.Current.Cache[key];
                }
                else
                {
                    Cnn.Open();
                    SqlCommand comm = new SqlCommand("PlayersManagementV5", Cnn);
                    comm.CommandType = CommandType.StoredProcedure;
                    ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
                    SqlDataReader reader;
                    reader = comm.ExecuteReader();
                    table.Load(reader);
                    HttpContext.Current.Cache.Insert(key, table, null, DateTime.Now.AddMinutes(20), System.Web.Caching.Cache.NoSlidingExpiration);
                }
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
    }
}
