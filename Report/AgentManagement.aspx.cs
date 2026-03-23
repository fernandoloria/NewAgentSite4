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
    public partial class AgentManagement  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
        //    if (e.CommandName == "btnSave")
        //    {
        //        string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
        //        SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
        //        Cnn.Open();

        //        try
        //        {
        //            int indexGrid = Convert.ToInt32(e.CommandArgument);
        //            GridViewRow GridViewR = GridView1.Rows[indexGrid];

        //            string agent = GridViewR.Cells[0].Text;
        //            string password = ((TextBox)GridViewR.Cells[1].FindControl("TextBox1")).Text;
        //            bool enable = ((CheckBox)GridViewR.Cells[4].FindControl("CheckBox1")).Checked;

        //            SqlCommand comm = new SqlCommand("AgentManagmentUpdate", Cnn);
        //            comm.CommandType = CommandType.StoredProcedure;

        //            ((SqlParameter)comm.Parameters.Add("@Agent", SqlDbType.VarChar)).Value = agent;
        //            ((SqlParameter)comm.Parameters.Add("@password", SqlDbType.VarChar)).Value = password;
        //            ((SqlParameter)comm.Parameters.Add("@email", SqlDbType.VarChar)).Value = "";
        //            ((SqlParameter)comm.Parameters.Add("@enableTicketAlert", SqlDbType.Bit)).Value = true;
        //            ((SqlParameter)comm.Parameters.Add("@emailTicketAlert", SqlDbType.VarChar)).Value = "";
        //            ((SqlParameter)comm.Parameters.Add("@RiskAmount", SqlDbType.Float)).Value = 0;
        //            ((SqlParameter)comm.Parameters.Add("@WinAmount", SqlDbType.Float)).Value = 0;
        //            ((SqlParameter)comm.Parameters.Add("@enableDeleteWager", SqlDbType.Bit)).Value = false;
        //            ((SqlParameter)comm.Parameters.Add("@enable", SqlDbType.Bit)).Value = enable;

        //            SqlDataReader reader;
        //            reader = comm.ExecuteReader();
        //        }
        //        catch (Exception myErr)
        //        {
        //            Response.Write(myErr.Message);
        //            //lblError.Text = "Agent can't be added, plase try later";
        //            //lblError.Text = myErr.Message;
        //        }
        //        finally
        //        {
        //            if (Cnn.State == ConnectionState.Open) Cnn.Close();
        //        }
        //    }
        //    if (e.CommandName == "btnProfile")
        //    {
        //        try
        //        {
        //            int indexGrid = Convert.ToInt32(e.CommandArgument);
        //            GridViewRow GridViewR = GridView1.Rows[indexGrid];
        //            string agent = GridViewR.Cells[0].Text;
        //            Response.Redirect("~/Report/ManageSubAgent.aspx?idAgent=" + GetAgent(agent));
        //        }
        //        catch (Exception myErr)
        //        {
        //            Response.Write(myErr.Message);
        //        }

        //    }
        }

        protected string GetAgent(string agent)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            SqlCommand comm = new SqlCommand("Select idagent from Agent where agent = @prmAgent", Cnn);
            comm.CommandType = CommandType.Text;
            ((SqlParameter)comm.Parameters.Add("@prmAgent", SqlDbType.VarChar)).Value = agent;
            SqlDataReader readerAgent;
            readerAgent = comm.ExecuteReader();
            table.Load(readerAgent);
            if (Cnn.State == ConnectionState.Open) Cnn.Close();

            if (table.Rows.Count > 0)
            {
                return table.Rows[0]["idAgent"].ToString();
            }
            return "";

        }
    }
}
