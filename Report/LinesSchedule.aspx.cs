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
    public partial class LinesSchedule : BasePage, IRequiresSessionState
    {

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;


        protected void Page_Load(object sender, EventArgs e)
        {
            System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo(Session["CultureInfo"].ToString());
            System.Threading.Thread.CurrentThread.CurrentCulture = ci;
            System.Threading.Thread.CurrentThread.CurrentUICulture = ci;
        }
        protected void saveScheduleAgent(int idAgent, int idLeague, int timeSchedule)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();

            try
            {
                SqlCommand comm = new SqlCommand("LinesSchedule_Insert", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmidAgent", SqlDbType.Int)).Value = idAgent;
                ((SqlParameter)comm.Parameters.Add("@prmidLeague", SqlDbType.Int)).Value = idLeague;
                ((SqlParameter)comm.Parameters.Add("@prmtimeBefore", SqlDbType.Int)).Value = timeSchedule;

                SqlDataReader reader;
                reader = comm.ExecuteReader();

            }
            catch (Exception myErr)
            {
                string error = myErr.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();

            }
        }

        protected void saveSchedule(int idLeague, int timeSchedule)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable dt = new DataTable();

            try
            {
                SqlCommand comm = new SqlCommand("AddOn_DDLAgent", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = Convert.ToInt32(ddlAgents.SelectedValue);

                SqlDataReader reader;
                reader = comm.ExecuteReader();
                dt.Load(reader);
                foreach (DataRow linea in dt.Rows)
                {
                    saveScheduleAgent(Convert.ToInt32(linea["idAgent"]), idLeague, timeSchedule);
                }

            }
            catch (Exception myErr)
            {
                string error = myErr.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();

            }
        }

        protected void ddlAgents_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }


        protected void btnSve_Command(object sender, CommandEventArgs e)
        {

        }

        protected void btnSve_Click(object sender, EventArgs e)
        {
            if (chkAppyAllLeagues.Checked)
            {
                foreach (GridViewRow linea in GridView1.Rows)
                {
                    int timeBefore = Convert.ToInt32(ddlTimeBefore.SelectedValue);
                    int idLeague = Convert.ToInt32(((HiddenField)linea.Cells[1].FindControl("HiddenField1")).Value);
                    saveSchedule(idLeague, timeBefore);
                }
            }
            else
            {
                foreach (GridViewRow linea in GridView1.Rows)
                {
                    int timeBefore = Convert.ToInt32(((DropDownList)linea.Cells[1].FindControl("ddlTimeBefore")).SelectedValue);
                    int idLeague = Convert.ToInt32(((HiddenField)linea.Cells[1].FindControl("HiddenField1")).Value);
                    saveSchedule(idLeague, timeBefore);
                }
            }
            GridView1.DataBind();
        }

        protected void ddlTimeBefore_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
