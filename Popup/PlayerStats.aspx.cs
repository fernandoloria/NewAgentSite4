using AgentSite4.cASEnums;
using DGSinterface;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Xml;
using System.Data.SqlClient;
using System.Data;
using System.Runtime.Remoting.Messaging;

namespace AgentSite4.Popup
{
    public partial class PlayerStats : System.Web.UI.Page
    {
        public int IdPlayer;
        protected void Page_Load(object sender, EventArgs e)
        {
            IdPlayer = Convert.ToInt32(Request.QueryString["player"]);
            if (!IsPostBack)
            {
                load();
            }
            verifiedHierarchy();
        }

        protected DataTable PlayerEdit_GetPlayerByID()
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

        protected void load()
        {
            DataTable agentRights = ManageSubAgent_GetAgentRights();

            DataTable table = PlayerEdit_GetPlayerByID();
            if (table.Rows.Count > 0)
            {
                DataRow player = table.Rows[0];
                lblPlayer1.Text = player["Player"].ToString().ToUpper() + " / " + player["onlinePassword"].ToString().ToUpper();
                hdfval.Value = player["idAgent"].ToString();

                decimal thisWeek = Convert.ToDecimal(player["ThisWeek"]);
                decimal LastWeek = Convert.ToDecimal(player["LastWeek"]);
                decimal currentBalance = Convert.ToDecimal(player["currentBalance"]);

                lblName.Text = player["Name"].ToString();
                lblthisWeek.Text = thisWeek.ToString("N0");
                if (thisWeek < 0)
                {
                    lblthisWeek.Attributes.Add("class", "neg");
                }

                lblLastWeek.Text = LastWeek.ToString("N0");
                if (LastWeek < 0)
                {
                    lblLastWeek.Attributes.Add("class", "neg");
                }

                lblLifetime.Text = Convert.ToDecimal(player["lifeTime"]).ToString("N0");
                lblCreditLimit.Text = Convert.ToDecimal(player["CreditLimit"]).ToString("N0");
                lblBalance.Text = currentBalance.ToString("N0");
                if (currentBalance < 0)
                {
                    lblBalance.Attributes.Add("class", "neg");
                }
                lblAtRisk.Text = Convert.ToDecimal(player["AmountAtRisk"]).ToString("N0");
                lblStatus.Text = player["status"].ToString() == "E" ? "Enable" : "Disable";





            }

            if (hasRight(agentRights, "AGENT ADJUSTMENT") || hasRight(agentRights, "AGENT PAYMENT"))
            {
                divPayment.Visible = true;
            }
            if (hasRight(agentRights, "CREATE PLAYER MESSAGE"))
            {
                divMessage.Visible = true;
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
    }

}

