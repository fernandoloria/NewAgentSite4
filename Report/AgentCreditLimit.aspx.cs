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
using AgentSite4.cASEnums;

namespace AgentSite4.Report
{
    public partial class AgentCreditLimit  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        void Page_Load(object sender, System.EventArgs e)
        {
            if (!IsPostBack)
            {
                loadAgendDDL();
            }

            if (!Common.HasRights(ReportPosition.AGENTCREDITLIMIT))
            { 
                Response.End();
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

                SqlCommand Cmd = new SqlCommand("select * from DGSDATA..agent where IdAgent = @IdAgent", Cnn);
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

        protected void loadAgendDDL()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                //Convert.ToInt32(Request.QueryString["idPlayer"]);
                int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                SqlCommand comm1 = new SqlCommand("AddOn_Agent_GetAgents", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm1.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
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

        protected void AgentCreditLimitSetLimit(int idAgent, decimal creditLimit)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("AgentCreditLimitSetLimit", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
                ((SqlParameter)comm.Parameters.Add("@prmCreditLimit", SqlDbType.Money)).Value = creditLimit;
                ((SqlParameter)comm.Parameters.Add("@prmCreatedBy", SqlDbType.Money)).Value = int.Parse(this.Session["IdAgent"].ToString());

                SqlDataReader reader;
                reader = comm.ExecuteReader();

                AgentCreditLimitUpadtePlayers(idAgent, creditLimit);
            }
            catch (Exception myErr)
            {
                lblError.Text = myErr.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }

        protected void AgentCreditLimitDelete(int idAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("AgentCreditLimitDelete", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
                ((SqlParameter)comm.Parameters.Add("@prmCreatedBy", SqlDbType.Int)).Value = int.Parse(this.Session["IdAgent"].ToString());
                SqlDataReader reader;
                reader = comm.ExecuteReader();
            }
            catch (Exception myErr)
            {
                lblError.Text = myErr.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }

        protected void AgentCreditLimitUpadtePlayers(int idAgent, decimal creditLimit)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {
                if (creditLimit > 0)
                {
                    SqlCommand comm = new SqlCommand("AgentCreditLimitUpadtePlayers", Cnn);
                    comm.CommandType = CommandType.StoredProcedure;
                    ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.VarChar)).Value = idAgent;
                    ((SqlParameter)comm.Parameters.Add("@prmCreditLimit", SqlDbType.VarChar)).Value = creditLimit;
                    ((SqlParameter)comm.Parameters.Add("@prmCreatedBy", SqlDbType.Int)).Value = int.Parse(this.Session["IdAgent"].ToString());
                    SqlDataReader reader;
                    reader = comm.ExecuteReader();
                }
            }
            catch (Exception myErr)
            {
                //Response.Write(myErr.Message);
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            if (chkApplyAll.Checked)
            {
                decimal creditLimit = Convert.ToDecimal(txtMoneyLine.Text);
                int idAgent = Convert.ToInt32(ddlAgent.SelectedValue);
                chkApplyAll.Checked = false;
                txtMoneyLine.Text = "";
                if (creditLimit > 0)
                {
                    AgentCreditLimitSetLimit(idAgent, creditLimit);
                }
                else
                {
                    AgentCreditLimitDelete(idAgent);
                }
                GridView1.DataBind();
                return;

            }
            foreach (GridViewRow grow in GridView1.Rows)
            {
                decimal creditLimit = Convert.ToDecimal(((TextBox)grow.Cells[1].FindControl("txtCreditLimit")).Text);
                int idAgent = Convert.ToInt32(((HiddenField)grow.Cells[1].FindControl("hdfIdAgent")).Value);
                if (creditLimit > 0)
                {
                    AgentCreditLimitSetLimit(idAgent, creditLimit);
                }
                else
                {
                    AgentCreditLimitDelete(idAgent);
                }
            }
            GridView1.DataBind();
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "btnUpdate")
            {
                int indexGrid = Convert.ToInt32(e.CommandArgument);
                GridViewRow GridViewR = GridView1.Rows[indexGrid];
                decimal creditLimit = Convert.ToDecimal(((TextBox)GridViewR.Cells[1].FindControl("txtCreditLimit")).Text);
                int idAgent = Convert.ToInt32(((HiddenField)GridViewR.Cells[1].FindControl("hdfIdAgent")).Value);
                AgentCreditLimitUpadtePlayers(idAgent, creditLimit);
            }
            else if (e.CommandName == "btnSave")
            {
                int indexGrid = Convert.ToInt32(e.CommandArgument);
                GridViewRow GridViewR = GridView1.Rows[indexGrid];
                decimal creditLimit = Convert.ToDecimal(((TextBox)GridViewR.Cells[1].FindControl("txtCreditLimit")).Text);
                int idAgent = Convert.ToInt32(((HiddenField)GridViewR.Cells[1].FindControl("hdfIdAgent")).Value);
                if (creditLimit > 0)
                {
                    AgentCreditLimitSetLimit(idAgent, creditLimit);
                }
                else
                {
                    AgentCreditLimitDelete(idAgent);
                }
            }

        }
    }
}
