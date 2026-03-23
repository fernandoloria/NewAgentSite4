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
using AgentSite4.cASEnums;

namespace AgentSite4.Report
{
    public partial class AddPlayer  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        void Page_Load(object sender, System.EventArgs e)
        {
            if (!Common.HasRights(ReportPosition.ADDPLAYER))
            {
                Response.End();
            }
            if (!IsPostBack)
            {
                loadAgentDDL();
                setCreditLimit();
            }

        }

        protected void setCreditLimit()
        {

        }

        protected void loadAgentDDL()
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

                SqlCommand Cmd = new SqlCommand("select agent from agent where IdAgent = @IdAgent", Cnn);
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


        protected DataTable AddPlayer_GetIdForClone(int idAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            DataTable playerFoClone = new DataTable();
            try
            {
                Cnn.Open();
                SqlCommand Cmd = new SqlCommand("AddPlayer_GetIdForClone", Cnn);
                Cmd.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)Cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;

                SqlDataReader reader;
                reader = Cmd.ExecuteReader();
                playerFoClone.Load(reader);

            }
            catch (Exception e)
            {
                lblError.Text = e.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            return playerFoClone;
        }

        protected int getIdBook()
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            int prmSubIdAgent = int.Parse(ddlAgent.SelectedValue);
            SqlCommand Cmd = new SqlCommand("select idBook from Agent where idAgent = @IdAgent", Cnn);
            Cmd.CommandType = CommandType.Text;
            ((SqlParameter)Cmd.Parameters.Add("@IdAgent", SqlDbType.Int)).Value = prmSubIdAgent;
            int idBook = 0;
            Cmd.ExecuteNonQuery();

            SqlDataReader topPlayer;
            topPlayer = Cmd.ExecuteReader();
            ListItem newItem = new ListItem();
            while (topPlayer.Read())
            {
                idBook = Convert.ToInt16(topPlayer["idBook"].ToString());
            }
            Cnn.Close();
            return idBook;

        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn2 = new SqlConnection(DGS_AddOnsConnectionString);

            SqlConnection Cnn3 = new SqlConnection(DGS_AddOnsConnectionString);

            try
            {
                Cnn2.Open();
                //Convert.ToInt32(Request.QueryString["idPlayer"]);
                int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
                int prmSubIdAgent = int.Parse(ddlAgent.SelectedValue);
                SqlCommand comm1 = new SqlCommand("AddOn_GetPlayerByPlayer", Cnn2);
                comm1.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm1.Parameters.Add("@player", SqlDbType.VarChar)).Value = txtUser.Text;

                SqlDataReader reader;
                reader = comm1.ExecuteReader();

                if (reader.HasRows)
                {
                    lblError.Text = "Player already exist, please choose another username";
                    Cnn2.Close();
                    return;
                }
                Cnn2.Close();
                Cnn.Open();

                decimal Credit = Convert.ToDecimal(txtCredit.Text);
                decimal max = Convert.ToDecimal(txtMaxPlay.Text);
                decimal min = Convert.ToDecimal(txtMinPlay.Text);
                string Player = txtUser.Text;
                string name = txtName.Text.Trim();
                string lastName = txtLastName.Text.Trim();
                string password = txtPassword.Text;
                short IdLineType = 0;
                short IdOffice = 0;
                int IdAgent = prmSubIdAgent;
                short IdCurrency = 0;
                int? IdGrouping = 0;
                short? IdSource = 0;
                short IdProfile = 0;
                byte IdPlayerRate = 0;
                short IdBook = 0;
                int IdTimeZone = 0;
                byte IdLanguage = 0;
                char ScheduleStyle = 'E';
                string Status = "";
                bool AutoPay = false;
                bool BalanceChecked = false;
                decimal CreditLimit = Credit;
                bool NoLimit = false;
                decimal TempCredit = 0;
                byte SoftLimitPercent = 0;
                DateTime TempCreditExpire = DateTime.Now;
                bool OnlineAccess = true;
                string OnlinePassword = txtPassword.Text;
                string OnlineMessage = "";
                decimal OnlineMaxWager = max;
                decimal OnlineMinWager = min;
                decimal MaxWager = max;
                decimal MinWager = min;
                decimal CapPerGame = 0;
                short ChartPercent = 0;
                short MasterChart = 0;
                bool Master = false;
                string FlagMessage;
                byte IdFlagMessageType = 0;
                byte MaxActionPoints = 0;
                char BonusPointsStatus = 'N';
                DateTime BonusPointsExpire = DateTime.Now;
                DateTime BonusPointsStart = DateTime.Now;
                char LineStyle = 'N';
                char NHLLine = 'N';
                char MLBLine = 'N';
                byte PitcherDefault = 0;
                bool DuplicatedBets = false;
                bool DuplicatedBetsOnline = false;
                bool ScheduleFB = false;
                bool ScheduleBB = false;
                bool ScheduleHK = false;
                bool ScheduleBS = false;
                decimal SettledFigure = 0;
                bool ShowInTicker = false;
                bool EPOSPlayer = false;
                bool EnableHorses = false;
                bool EnableCasino = false;
                bool EnableSports = false;
                DateTime DateOfBirth = DateTime.Now;
                string SecQuestion = "";
                string SecAnswer = "";
                string SignUpIP = "";
                bool AllowNegTrans = false;
                short LastModificationUser = 0;
                bool HoldBets = false;
                byte HoldDelay = 0;
                short IdProfileLimits = 0;
                bool EnableCards = false;
                int IdAffiliate = 0;

                DataTable playerForClone = AddPlayer_GetIdForClone(prmSubIdAgent);
                if (playerForClone.Rows.Count < 0)
                {
                    lblMensage.Visible = true;
                    return;
                }
                else
                {
                    lblMensage.Visible = false;
                }
                DataRow topPlayer = playerForClone.Rows[0];

                IdLineType = Convert.ToInt16(topPlayer["IdLineType"].ToString());
                IdOffice = Convert.ToInt16(topPlayer["IdOffice"].ToString());
                IdAgent = prmSubIdAgent;
                IdCurrency = Convert.ToInt16(topPlayer["IdCurrency"].ToString());
                int intValue;
                int.TryParse(topPlayer["IdGrouping"].ToString(), out intValue);
                if (intValue == 0)
                {
                    intValue = 6; //default value of PHN;
                }
                IdGrouping = intValue;
                //lblError.Text = intValue.ToString(); ;
                IdSource = 0;
                IdProfile = Convert.ToInt16(topPlayer["IdProfile"].ToString());
                IdPlayerRate = Convert.ToByte(topPlayer["IdPlayerRate"].ToString());
                IdBook = Convert.ToInt16(getIdBook());  //Convert.ToInt16(topPlayer["IdBook"].ToString());
                IdTimeZone = Convert.ToInt16(topPlayer["IdTimeZone"].ToString());
                IdLanguage = Convert.ToByte(topPlayer["IdLanguage"].ToString());
                ScheduleStyle = Convert.ToChar(topPlayer["ScheduleStyle"].ToString());
                Status = topPlayer["Status"].ToString();
                AutoPay = Convert.ToBoolean(topPlayer["AutoPay"].ToString());
                BalanceChecked = Convert.ToBoolean(topPlayer["BalanceChecked"].ToString());
                NoLimit = Convert.ToBoolean(topPlayer["NoLimit"].ToString());
                TempCredit = 0;
                SoftLimitPercent = Convert.ToByte(topPlayer["SoftLimitPercent"].ToString());
                TempCreditExpire = DateTime.Now;
                CapPerGame = Convert.ToDecimal(topPlayer["CapPerGame"].ToString());
                ChartPercent = Convert.ToInt16(topPlayer["ChartPercent"].ToString());
                MasterChart = Convert.ToInt16(topPlayer["MasterChart"].ToString());
                Master = Convert.ToBoolean(topPlayer["Master"].ToString());
                FlagMessage = "";
                IdFlagMessageType = Convert.ToByte(topPlayer["IdFlagMessageType"].ToString());
                MaxActionPoints = Convert.ToByte(topPlayer["MaxActionPoints"].ToString());
                BonusPointsStatus = Convert.ToChar(topPlayer["BonusPointsStatus"].ToString());
                BonusPointsExpire = DateTime.Now;
                BonusPointsStart = DateTime.Now; ;
                LineStyle = Convert.ToChar(topPlayer["LineStyle"].ToString());
                NHLLine = Convert.ToChar(topPlayer["NHLLine"].ToString());
                MLBLine = Convert.ToChar(topPlayer["MLBLine"].ToString());
                PitcherDefault = Convert.ToByte(topPlayer["PitcherDefault"].ToString());
                DuplicatedBets = Convert.ToBoolean(topPlayer["DuplicatedBets"].ToString());
                DuplicatedBetsOnline = Convert.ToBoolean(topPlayer["DuplicatedBetsOnline"].ToString());
                ScheduleFB = Convert.ToBoolean(topPlayer["ScheduleFB"].ToString());
                ScheduleBB = Convert.ToBoolean(topPlayer["ScheduleBB"].ToString());
                ScheduleHK = Convert.ToBoolean(topPlayer["ScheduleHK"].ToString());
                ScheduleBS = Convert.ToBoolean(topPlayer["ScheduleBS"].ToString());
                SettledFigure = 0;
                ShowInTicker = Convert.ToBoolean(topPlayer["ShowInTicker"].ToString());
                EPOSPlayer = Convert.ToBoolean(topPlayer["EPOSPlayer"].ToString());
                EnableHorses = Convert.ToBoolean(topPlayer["EnableHorses"].ToString());
                EnableCasino = Convert.ToBoolean(topPlayer["EnableCasino"].ToString());
                EnableSports = Convert.ToBoolean(topPlayer["EnableSports"].ToString());
                DateOfBirth = DateTime.Now;
                SecQuestion = "";
                SecAnswer = "";
                SignUpIP = Request.UserHostAddress;
                AllowNegTrans = Convert.ToBoolean(topPlayer["AllowNegTrans"].ToString());
                //LastModificationUser = Convert.ToInt16(topPlayer["LastModificationUser"].ToString());;
                HoldBets = Convert.ToBoolean(topPlayer["HoldBets"].ToString());
                HoldDelay = Convert.ToByte(topPlayer["HoldDelay"].ToString());
                IdProfileLimits = Convert.ToInt16(topPlayer["IdProfileLimits"].ToString());
                EnableCards = Convert.ToBoolean(topPlayer["EnableCards"].ToString());
                IdAffiliate = 0;

                Cnn.Close();
                Cnn.Open();

                SqlCommand comm = new SqlCommand("Player_Insert", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdLineType", SqlDbType.SmallInt)).Value = IdLineType;
                ((SqlParameter)comm.Parameters.Add("@prmIdOffice", SqlDbType.TinyInt)).Value = IdOffice;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = IdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmIdCurrency", SqlDbType.SmallInt)).Value = IdCurrency;
                ((SqlParameter)comm.Parameters.Add("@prmIdGrouping", SqlDbType.SmallInt)).Value = IdGrouping;
                ((SqlParameter)comm.Parameters.Add("@prmIdSource", SqlDbType.SmallInt)).Value = IdSource;
                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.SmallInt)).Value = IdProfile;
                ((SqlParameter)comm.Parameters.Add("@prmIdProfileLimits", SqlDbType.SmallInt)).Value = IdProfileLimits;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayerRate", SqlDbType.TinyInt)).Value = IdPlayerRate;
                ((SqlParameter)comm.Parameters.Add("@prmIdBook", SqlDbType.SmallInt)).Value = IdBook;
                ((SqlParameter)comm.Parameters.Add("@prmIdTimeZone", SqlDbType.Int)).Value = IdTimeZone;
                ((SqlParameter)comm.Parameters.Add("@prmIdLanguage", SqlDbType.TinyInt)).Value = IdLanguage;
                ((SqlParameter)comm.Parameters.Add("@prmScheduleStyle", SqlDbType.Char)).Value = ScheduleStyle;
                ((SqlParameter)comm.Parameters.Add("@prmPlayer", SqlDbType.VarChar)).Value = Player;
                ((SqlParameter)comm.Parameters.Add("@prmPassword", SqlDbType.VarChar)).Value = password;
                ((SqlParameter)comm.Parameters.Add("@prmName", SqlDbType.NVarChar)).Value = name;
                ((SqlParameter)comm.Parameters.Add("@prmLastName", SqlDbType.NVarChar)).Value = lastName;
                ((SqlParameter)comm.Parameters.Add("@prmLastName2", SqlDbType.NVarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmTitle", SqlDbType.VarChar)).Value = "Mr";
                ((SqlParameter)comm.Parameters.Add("@prmAddress1", SqlDbType.NVarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmAddress2", SqlDbType.NVarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmCity", SqlDbType.NVarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmState", SqlDbType.NVarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmCountry", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmZip", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmPhone", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmFax", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmEmail", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmStatus", SqlDbType.Char)).Value = Status;
                ((SqlParameter)comm.Parameters.Add("@prmAutoPay", SqlDbType.Bit)).Value = AutoPay;
                ((SqlParameter)comm.Parameters.Add("@prmBalanceChecked", SqlDbType.Bit)).Value = BalanceChecked;
                ((SqlParameter)comm.Parameters.Add("@prmCreditLimit", SqlDbType.Money)).Value = CreditLimit;

                ((SqlParameter)comm.Parameters.Add("@prmTempCredit", SqlDbType.Money)).Value = TempCredit;
                ((SqlParameter)comm.Parameters.Add("@prmSoftLimitPercent", SqlDbType.TinyInt)).Value = SoftLimitPercent;
                ((SqlParameter)comm.Parameters.Add("@prmTempCreditExpire", SqlDbType.DateTime)).Value = TempCreditExpire;
                ((SqlParameter)comm.Parameters.Add("@prmOnlineAccess", SqlDbType.Bit)).Value = OnlineAccess;
                ((SqlParameter)comm.Parameters.Add("@prmOnlinePassword", SqlDbType.NVarChar)).Value = OnlinePassword;
                ((SqlParameter)comm.Parameters.Add("@prmOnlineMessage", SqlDbType.NVarChar)).Value = OnlineMessage;
                ((SqlParameter)comm.Parameters.Add("@prmOnlineMaxWager", SqlDbType.Money)).Value = OnlineMaxWager;
                ((SqlParameter)comm.Parameters.Add("@prmOnlineMinWager", SqlDbType.Money)).Value = OnlineMinWager;
                ((SqlParameter)comm.Parameters.Add("@prmMaxWager", SqlDbType.Money)).Value = MaxWager;
                ((SqlParameter)comm.Parameters.Add("@prmMinWager", SqlDbType.Money)).Value = MinWager;
                ((SqlParameter)comm.Parameters.Add("@prmChartPercent", SqlDbType.SmallInt)).Value = ChartPercent;
                ((SqlParameter)comm.Parameters.Add("@prmMasterChart", SqlDbType.SmallInt)).Value = MasterChart;
                ((SqlParameter)comm.Parameters.Add("@prmMaster", SqlDbType.Bit)).Value = Master;
                ((SqlParameter)comm.Parameters.Add("@prmIdFlagMessageType", SqlDbType.TinyInt)).Value = IdFlagMessageType;
                ((SqlParameter)comm.Parameters.Add("@prmMaxActionPoints", SqlDbType.TinyInt)).Value = MaxActionPoints;
                ((SqlParameter)comm.Parameters.Add("@prmBonusPointsStatus", SqlDbType.Char)).Value = BonusPointsStatus;
                ((SqlParameter)comm.Parameters.Add("@prmBonusPointsExpire", SqlDbType.DateTime)).Value = BonusPointsExpire;
                ((SqlParameter)comm.Parameters.Add("@prmBonusPointsStart", SqlDbType.DateTime)).Value = BonusPointsStart;
                ((SqlParameter)comm.Parameters.Add("@prmLineStyle", SqlDbType.Char)).Value = LineStyle;
                ((SqlParameter)comm.Parameters.Add("@prmNHLLine", SqlDbType.Char)).Value = NHLLine;
                ((SqlParameter)comm.Parameters.Add("@prmMLBLine", SqlDbType.Char)).Value = MLBLine;
                ((SqlParameter)comm.Parameters.Add("@prmPitcherDefault", SqlDbType.TinyInt)).Value = PitcherDefault;
                ((SqlParameter)comm.Parameters.Add("@prmDuplicatedBets", SqlDbType.Bit)).Value = DuplicatedBets;
                ((SqlParameter)comm.Parameters.Add("@prmDuplicatedBetsOnline", SqlDbType.Bit)).Value = DuplicatedBetsOnline;
                ((SqlParameter)comm.Parameters.Add("@prmScheduleFB", SqlDbType.Bit)).Value = ScheduleFB;
                ((SqlParameter)comm.Parameters.Add("@prmScheduleBB", SqlDbType.Bit)).Value = ScheduleBB;
                ((SqlParameter)comm.Parameters.Add("@prmScheduleHK", SqlDbType.Bit)).Value = ScheduleHK;
                ((SqlParameter)comm.Parameters.Add("@prmScheduleBS", SqlDbType.Bit)).Value = ScheduleBS;
                ((SqlParameter)comm.Parameters.Add("@prmSettledFigure", SqlDbType.Money)).Value = SettledFigure;
                ((SqlParameter)comm.Parameters.Add("@prmShowInTicker", SqlDbType.Bit)).Value = ShowInTicker;
                ((SqlParameter)comm.Parameters.Add("@prmEPOSPlayer", SqlDbType.Bit)).Value = EPOSPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmEnableSports", SqlDbType.Bit)).Value = EnableSports;
                ((SqlParameter)comm.Parameters.Add("@prmEnableCasino", SqlDbType.Bit)).Value = EnableCasino;
                ((SqlParameter)comm.Parameters.Add("@prmEnableHorses", SqlDbType.Bit)).Value = EnableHorses;
                ((SqlParameter)comm.Parameters.Add("@prmEnableCards", SqlDbType.Bit)).Value = EnableCards;
                ((SqlParameter)comm.Parameters.Add("@prmDateOfBirth", SqlDbType.DateTime)).Value = DateOfBirth;
                ((SqlParameter)comm.Parameters.Add("@prmSignUpIP", SqlDbType.VarChar)).Value = SignUpIP;
                ((SqlParameter)comm.Parameters.Add("@prmSecQuestion", SqlDbType.NVarChar)).Value = SecQuestion;
                ((SqlParameter)comm.Parameters.Add("@prmSecAnswer", SqlDbType.NVarChar)).Value = SecAnswer;
                ((SqlParameter)comm.Parameters.Add("@prmHoldBets", SqlDbType.Bit)).Value = HoldBets;
                ((SqlParameter)comm.Parameters.Add("@prmHoldDelay", SqlDbType.TinyInt)).Value = HoldDelay;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 118;
                ((SqlParameter)comm.Parameters.Add("@prmIdAffiliate", SqlDbType.TinyInt)).Value = DBNull.Value;
                ((SqlParameter)comm.Parameters.Add("@prmOutIdPlayer", SqlDbType.Int)).Direction = ParameterDirection.Output;
                ((SqlParameter)comm.Parameters.Add("@prmOutResult", SqlDbType.Int)).Direction = ParameterDirection.Output;

                SqlDataReader reader2;
                reader2 = comm.ExecuteReader();

                Session.Remove("GetHierarchy");
                string title = "Player added";
                string message = "Player added successfully!";
                string endTag = "</" + "script>";
                string script = string.Format(@"
                        <script language='javascript'>
                            document.addEventListener('DOMContentLoaded', function() {{
                                swal({{ title: '{0}', text: '{1}', timer: 2000, showConfirmButton: false }});
                            }});
                            {2}", title, message, endTag);
                Page.ClientScript.RegisterStartupScript(this.GetType(), "alertScript", script);


                txtUser.Text = "";


            }
            catch (Exception myErr)
            {
                //lblError.Text += "Player can't be added, please try later";
                lblError.Text += myErr.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            Session["tblPlayerList"] = null;
        }
    }
}
