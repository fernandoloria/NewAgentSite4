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
using AddOnWebClient;
using DGSinterface;

namespace AgentSite4.Report
{
    public partial class AddAgent  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        void Page_Load(object sender, System.EventArgs e)
        {
            if (!IsPostBack)
            {
                loadAgentDDL();
                loadAgentRights();

            }
            if (!Common.HasRights(ReportPosition.ADDAGENT))
            {
                Response.End();
            }
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
                ((SqlParameter)comm1.Parameters.Add("@IsDistributor", SqlDbType.Int)).Value = 1;
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
                    lblError.Text = "Agent can't be added, an agent can only be created under a Distributor, please contact customer service";
                    txtUser.Enabled = false;
                    txtPassword.Enabled = false;
                    txtPassword1.Enabled = false;
                    txtLastName.Enabled = false;
                    txtName.Enabled = false;
                    ddlAgent.Enabled = false;
                    ddlAgentCloneRights.Enabled = false;
                    chkCloneRights.Enabled = false;
                    chkDistributor.Enabled = false;
                    ckCarryPlayersBalance.Enabled = false;
                    btnRefresh.Enabled = false;
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


        protected AgentClone AddOn_GetAgentInfo()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            AgentClone agent = new AgentClone();
            try
            {
                Cnn.Open();
                int prmIdAgent = int.Parse(ddlAgentCloneRights.SelectedValue);
                SqlCommand comm1 = new SqlCommand("AddOn_GetAgentInfo", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;
                comm1.Parameters.Add("@idAgent", SqlDbType.Int).Value = prmIdAgent;
                SqlDataReader reader = comm1.ExecuteReader();

                while (reader.Read())
                {
                    agent.idAgent = prmIdAgent;
                    agent.IdBook = reader["IdBook"] != DBNull.Value ? Convert.ToInt16(reader["IdBook"]) : default(short);
                    agent.IdCurrency = reader["IdCurrency"] != DBNull.Value ? Convert.ToInt16(reader["IdCurrency"]) : default(short);
                    agent.IdGrouping = reader["IdGrouping"] != DBNull.Value ? Convert.ToInt16(reader["IdGrouping"]) : default(short);
                    agent.IdLanguage = reader["IdLanguage"] != DBNull.Value ? Convert.ToInt16(reader["IdLanguage"]) : default(short);
                    agent.IdLineType = reader["IdLineType"] != DBNull.Value ? Convert.ToInt16(reader["IdLineType"]) : Convert.ToInt16(-1);
                }
            }
            catch (Exception e)
            {
                lblError.Text = e.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open)
                    Cnn.Close();
            }
            return agent;
        }


        protected void loadAgentRights()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                //Convert.ToInt32(Request.QueryString["idPlayer"]);
                int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                SqlCommand comm1 = new SqlCommand("AddOn_GetAgentsByIdAgent", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm1.Parameters.Add("@idAgent", SqlDbType.Int)).Value = prmIdAgent;
                SqlDataReader reader;
                reader = comm1.ExecuteReader();
                ListItem newItem = new ListItem();
                while (reader.Read())
                {
                    newItem = new ListItem();
                    newItem.Value = reader["IdAgent"].ToString();
                    newItem.Text = reader["AGENT"].ToString();
                    ddlAgentCloneRights.Items.Add(newItem);
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


        protected void AGENTRIGHTS_Clone(int idAgentFrom, int idAgentTo)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                //Convert.ToInt32(Request.QueryString["idPlayer"]);
                int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                SqlCommand comm1 = new SqlCommand("AGENTRIGHTS_Clone", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm1.Parameters.Add("@prmIdAgentFrom", SqlDbType.Int)).Value = idAgentFrom;
                ((SqlParameter)comm1.Parameters.Add("@prmIdAgentTo", SqlDbType.Int)).Value = idAgentTo;
                comm1.ExecuteReader();
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


        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            lblError.Text = "";
            try
            {
                Cnn.Open();

                if (ddlAgent.SelectedValue.Length == 0)
                {
                    Response.End();
                }

                int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
                bool prmIsDistributor = Convert.ToBoolean(chkDistributor.Checked.ToString());
                int prmDistributor = int.Parse(ddlAgent.SelectedValue);
                string prmAgent = txtUser.Text;
                string prmName = txtName.Text;
                string prmPassword = txtPassword.Text;
                string lastName = txtLastName.Text;

                AgentClone agentClone = AddOn_GetAgentInfo();

                SqlCommand comm = new SqlCommand("Agent_Insert", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmEnable", SqlDbType.Bit)).Value = true;
                ((SqlParameter)comm.Parameters.Add("@prmDontXfer", SqlDbType.Bit)).Value = ckCarryPlayersBalance.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmIsDistributor", SqlDbType.Bit)).Value = chkDistributor.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.Int)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmDistributor", SqlDbType.Int)).Value = prmDistributor;
                ((SqlParameter)comm.Parameters.Add("@prmMakeup", SqlDbType.Money)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmCommSports", SqlDbType.Money)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmCommCasino", SqlDbType.TinyInt)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmCommHorses", SqlDbType.TinyInt)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgentType", SqlDbType.SmallInt)).Value = 1;
                ((SqlParameter)comm.Parameters.Add("@prmIdCurrency", SqlDbType.SmallInt)).Value = agentClone.IdCurrency;
                ((SqlParameter)comm.Parameters.Add("@prmIdBook", SqlDbType.SmallInt)).Value = agentClone.IdBook;
                ((SqlParameter)comm.Parameters.Add("@prmIdGrouping", SqlDbType.SmallInt)).Value = agentClone.IdGrouping;
                ((SqlParameter)comm.Parameters.Add("@prmAgent", SqlDbType.VarChar)).Value = prmAgent;
                ((SqlParameter)comm.Parameters.Add("@prmName", SqlDbType.VarChar)).Value = prmName;
                ((SqlParameter)comm.Parameters.Add("@prmPassword", SqlDbType.NVarChar)).Value = prmPassword;
                ((SqlParameter)comm.Parameters.Add("@prmCity", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmState", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmCountry", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmAddress1", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmAddress2", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmEmail", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmPhone", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmFax", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmZip", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmOnlineAccess", SqlDbType.Bit)).Value = true;
                ((SqlParameter)comm.Parameters.Add("@prmOnlineMessage", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmOnlinePassword", SqlDbType.VarChar)).Value = prmPassword;
                if (agentClone.IdLineType == -1)
                {
                    comm.Parameters.Add("@prmIdLineType", SqlDbType.SmallInt).Value = DBNull.Value;
                }
                else
                {
                    comm.Parameters.Add("@prmIdLineType", SqlDbType.SmallInt).Value = agentClone.IdLineType;
                }
                ((SqlParameter)comm.Parameters.Add("@prmIdAgentPerHead", SqlDbType.Int)).Value = DBNull.Value;
                ((SqlParameter)comm.Parameters.Add("@prmIdLanguage", SqlDbType.SmallInt)).Value = agentClone.IdLanguage;

                SqlParameter prmOutIdAgent = new SqlParameter();
                prmOutIdAgent.ParameterName = "@prmOutIdAgent";
                prmOutIdAgent.SqlDbType = System.Data.SqlDbType.Int;
                prmOutIdAgent.Direction = System.Data.ParameterDirection.Output;
                comm.Parameters.Add(prmOutIdAgent);

                SqlParameter prmOutResult = new SqlParameter();
                prmOutResult.ParameterName = "@prmOutResult";
                prmOutResult.SqlDbType = System.Data.SqlDbType.Int;
                prmOutResult.Direction = System.Data.ParameterDirection.Output;
                comm.Parameters.Add(prmOutResult);

                SqlDataReader reader;
                reader = comm.ExecuteReader();

                int outResult = Convert.ToInt32(prmOutResult.Value.ToString());
                int outIdAgent = Convert.ToInt32(prmOutIdAgent.Value.ToString());

                string strMesage = "";
                string title = "";
                switch (outResult)
                {
                    case -1: //Agent already exists
                        title = "Agent already exists";
                        strMesage = "Agent already exist, please choose another username";
                        break;
                    case -2://Error inserting agent.
                        title = "Error inserting agent.";
                        strMesage = "Error inserting agent, please try again.";
                        break;
                    case -3://Error inserting agent statistic.
                        title = "Error inserting agent statistic";
                        strMesage = "Error inserting agent statistic, please try again";
                        break;
                    case 0://Completed Sucessfully
                        title = "Agent Added Sucessfully";
                        strMesage = "Agent added.";
                        Session.Remove("GetReportAgentList"); // to refresh agent Tree
                        Session.Remove("GetHierarchy"); // to refresh the search bar
                        if (chkCloneRights.Checked)
                        {
                            AGENTRIGHTS_Clone(agentClone.idAgent, outIdAgent);
                        }
                        string key = prmIdAgent + "," + this.Session["Agent"].ToString() + ",GetReportAgentList";
                        HttpContext.Current.Cache[key] = null;
                       
                        break;
                }

                string endTag = "</" + "script>";
                string script = string.Format(@"
                        <script language='javascript'>
                            document.addEventListener('DOMContentLoaded', function() {{
                                swal({{ title: '{0}', text: '{1}', timer: 2000, showConfirmButton: false }});
                            }});
                            {2}", title, strMesage, endTag);
                Page.ClientScript.RegisterStartupScript(this.GetType(), "alertScript", script);

                //lblError.Text = strMesage;

                Cnn.Close();
                txtUser.Text = "";
                txtName.Text = "";
            }
            catch (Exception myErr)
            {
                lblError.Text = "Agent can't be added, please try later";
                lblError.Text = myErr.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }

        public class AgentClone
        {

            int i_idAgent;
            short i_IdCurrency;
            short i_IdBook;
            short i_IdGrouping;
            short i_IdLineType;
            short i_IdLanguage;

            public int idAgent { get { return i_idAgent; } set { i_idAgent = value; } }
            public short IdCurrency { get { return i_IdCurrency; } set { i_IdCurrency = value; } }
            public short IdBook { get { return i_IdBook; } set { i_IdBook = value; } }
            public short IdGrouping { get { return i_IdGrouping; } set { i_IdGrouping = value; } }
            public short IdLineType { get { return i_IdLineType; } set { i_IdLineType = value; } }
            public short IdLanguage { get { return i_IdLanguage; } set { i_IdLanguage = value; } }
        }
    }
}
