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
    public partial class ManageLines  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        void Page_Load(object sender, System.EventArgs e)
        {
            if (!IsPostBack)
            {
                loadAgendDDL();

                GetTNTvalues();
            }

            if (!Common.HasRights(ReportPosition.MANAGELINES))
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

                SqlCommand Cmd = new SqlCommand("select IdAgent, AGENT from DGSDATA..agent where IdAgent = @IdAgent", Cnn);
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

        protected void HideAgentLinesV2_InsertRule(string idSport, string moneyLine, string disableML, int hideGameUntil, int openLinesByHour)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                //int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
                int idAgent = Convert.ToInt32(ddlAgent.SelectedValue);

                SqlCommand comm = new SqlCommand("HideAgentLinesV2_Insert", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
                ((SqlParameter)comm.Parameters.Add("@prmIdSport", SqlDbType.VarChar)).Value = idSport;
                ((SqlParameter)comm.Parameters.Add("@prmMoneyLine", SqlDbType.VarChar)).Value = moneyLine;
                ((SqlParameter)comm.Parameters.Add("@prmDisableML", SqlDbType.VarChar)).Value = disableML;
                ((SqlParameter)comm.Parameters.Add("@prmHideGameUntil", SqlDbType.Int)).Value = hideGameUntil;
                ((SqlParameter)comm.Parameters.Add("@prmOpenLinesByHour", SqlDbType.Int)).Value = openLinesByHour;

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

            lblError.Text = "Rules Apply under Agent " + ddlAgent.SelectedItem;
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {

            /*if (chkApplyAll.Checked)
            {
                foreach (GridViewRow grow in GridView1.Rows)
                {
                    ((TextBox)grow.FindControl("txtMoneyLines")).Text = txtMoneyLine.Text;
                }
            }
            */
            foreach (GridViewRow grow in GridView1.Rows)
            {
                string moneyLine = ((TextBox)grow.Cells[1].FindControl("txtMoneyLines")).Text;
                string idSport = grow.Cells[0].Text;
                string disableML = "0";
                int hideGameUntil = int.Parse(((DropDownList)grow.Cells[3].FindControl("ddlHideGameUntil")).SelectedValue);
                int openLinesByHour = int.Parse(((DropDownList)grow.Cells[4].FindControl("ddlOpenLinesByHour")).SelectedValue);

                CheckBox chk = grow.Cells[2].Controls[1] as CheckBox;
                if (chk != null && chk.Checked)
                {
                    disableML = "1";
                }

                HideAgentLinesV2_InsertRule(idSport, moneyLine, disableML, hideGameUntil, openLinesByHour);
            }

            SaveTNTvalues();

            GridView1.DataBind();

        }

        protected void SaveTNTvalues()
        {

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();

                int idAgent = Convert.ToInt32(ddlAgent.SelectedValue);

                SqlCommand comm = new SqlCommand("HideAgentLinesV2_SaveTNTvalues", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
                ((SqlParameter)comm.Parameters.Add("@prmMaxTNTMoneyLine", SqlDbType.Int)).Value = int.Parse(txtMaxMoneyLine.Text);
                ((SqlParameter)comm.Parameters.Add("@prmDiscountTNTMoneyLine", SqlDbType.Int)).Value = int.Parse(txtDiscountPerc.Text);


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

        protected void GetTNTvalues()
        {

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();

                int idAgent = Convert.ToInt32(ddlAgent.SelectedValue);

                SqlCommand comm = new SqlCommand("HideAgentLinesV2_GetTNTvalues", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;


                SqlDataReader reader;
                reader = comm.ExecuteReader();

                if (reader.Read())
                {
                    txtMaxMoneyLine.Text = reader["MaxTNTMoneyLine"].ToString();
                    txtDiscountPerc.Text = reader["DiscountTNTMoneyLine"].ToString();
                }
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

        protected void ddlAgent_Change(object sender, EventArgs e)
        {

            GetTNTvalues();
        }
    }
}
