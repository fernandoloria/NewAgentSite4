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
    public partial class OddsAdjustor  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        void Page_Load(object sender, System.EventArgs e)
        {
            if (!IsPostBack)
            {

                loadAgendDDL();

            }

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
                    newItem.Text = this.Session["Agent"].ToString();
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

        protected void OddsAdjustor_InsertRule(string idSport, int spread, int moneyLine, int total)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                //int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
                int idAgent = Convert.ToInt32(ddlAgent.SelectedValue);
                int idPeriod = Convert.ToInt32(ddlPeriod.SelectedValue);

                SqlCommand comm = new SqlCommand("AddOn_Web_Report_OddsAdjustor_InsertOddsByAgent", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
                ((SqlParameter)comm.Parameters.Add("@prmIdSport", SqlDbType.VarChar)).Value = idSport;
                ((SqlParameter)comm.Parameters.Add("@prmPeriod", SqlDbType.Int)).Value = idPeriod;
                ((SqlParameter)comm.Parameters.Add("@prmOddsAdjustor_Spread", SqlDbType.Int)).Value = spread;
                ((SqlParameter)comm.Parameters.Add("@prmOddsAdjustor_MoneyLine", SqlDbType.Int)).Value = moneyLine;
                ((SqlParameter)comm.Parameters.Add("@prmOddsAdjustor_Total", SqlDbType.Int)).Value = total;

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

            lblError.Text = "Rules Apply under Agent ";
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

                string idSport = grow.Cells[0].Text;
                int spread = int.Parse(((DropDownList)grow.Cells[1].FindControl("ddlAdjustorSpread")).SelectedValue);
                int moneyLine = int.Parse(((DropDownList)grow.Cells[2].FindControl("ddlAdjustorMoneyLine")).SelectedValue);
                int total = int.Parse(((DropDownList)grow.Cells[3].FindControl("ddlAdjustorTotal")).SelectedValue);

                OddsAdjustor_InsertRule(idSport, spread, moneyLine, total);
            }

            GridView1.DataBind();

        }
    }
}
