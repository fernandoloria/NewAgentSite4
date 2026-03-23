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
    public partial class PlayerProfile  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        void Page_Load(object sender, System.EventArgs e)
        {

        }

        protected void CloneProfile()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {

                int idPlayer = int.Parse(ddlPlayers.SelectedValue);
                SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfile_ClonePlayerProfile", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.Int)).Value = ddlProfiles.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmNewName", SqlDbType.VarChar)).Value = ddlPlayers.SelectedItem.Text;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = idPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = Convert.ToInt32(Session["idAgent"]);
                SqlDataReader reader;
                reader = comm.ExecuteReader();
            }
            catch (Exception err)
            {
                Response.Write(err.Message);
            }
            finally
            {
                Cnn.Close();
            }

        }

        protected void ChangeProfilePlayer()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {

                int idPlayer = int.Parse(ddlPlayers.SelectedValue);
                SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfile_ChangePlayerProfile", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmidPlayer", SqlDbType.Int)).Value = ddlPlayers.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.Int)).Value = ddlProfiles.SelectedValue;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
            }
            catch (Exception err)
            {
            }
            finally
            {
                Cnn.Close();
            }

        }

        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            //GridView1.Enabled = AceptChanges();
        }

        protected bool AceptChanges()
        {
            bool aceptC = false;
            DataTable table = new DataTable();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {

                SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfile_ProfileAceptChanges", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = ddlPlayers.SelectedValue;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception myError)
            {
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            if (table.Rows.Count > 0)
            {
                DataRow linea = table.Rows[0];
                if (linea[0].ToString() == "1")
                {
                    aceptC = true;
                }
            }
            return aceptC;
        }

        protected int GetProfileLimits()
        {
            int idProfileLimits = 1;
            DataTable table = new DataTable();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("AddOn_Player_GetById", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = ddlPlayers.SelectedValue;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception myError)
            {
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            if (table.Rows.Count > 0)
            {
                DataRow linea = table.Rows[0];
                idProfileLimits = Convert.ToInt32(linea["idProfileLimits"].ToString());
            }
            return idProfileLimits;
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            CloneProfile();
            ddlProfiles.DataBind();

            //GridView1.DataBind();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            try
            {
                // GridView1.DataBind();
                ddlProfiles.SelectedValue = GetProfileLimits().ToString();
            }
            catch { }
        }

        protected void btnSetProfile_Click(object sender, EventArgs e)
        {
            ChangeProfilePlayer();
            ddlProfiles.SelectedValue = GetProfileLimits().ToString();
            //  GridView1.DataBind();
        }

        protected void ddlProfiles_DataBound(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ddlProfiles.SelectedValue = GetProfileLimits().ToString();
            }
        }

        protected void ddlPlayers_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                //  GridView1.DataBind();
                ddlProfiles.SelectedValue = GetProfileLimits().ToString();
            }
            catch { }
        }

        protected void ddlAgents_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                ddlPlayers.DataBind();
                //  GridView1.DataBind();
                ddlProfiles.SelectedValue = GetProfileLimits().ToString();
            }
            catch { }
        }

        protected void btnApplyOnlinePhone_Click(object sender, EventArgs e)
        {

        }

        protected void btnApply_Click(object sender, EventArgs e)
        {

        }

        protected void DetailsView1_DataBound(object sender, EventArgs e)
        {
            for (int i = 0; i < dvRalatedOptionGame.Rows.Count; i++)
            {
                dvRalatedOptionGame.Rows[i].Controls[0].Visible = false;
            }
        }
    }
}
