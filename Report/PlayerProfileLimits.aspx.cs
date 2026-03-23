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
    public partial class PlayerProfileLimits  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        void Page_Load(object sender, System.EventArgs e)
        {


        }



        protected void btnApply_Click(object sender, EventArgs e)
        {
            bool Online = rdnOnline.Checked;
            saveProfile(Online);
        }

        protected void saveProfile(bool Online)
        {
            string idSport = ddlGameType.SelectedValue;
            int idPlayer = Convert.ToInt32(ddlPlayers.SelectedValue);
            if (AceptChanges())
            {
                foreach (GridViewRow linea in GridView1.Rows)
                {
                    string idGameType = ((HiddenField)linea.FindControl("hdfIdGameType")).Value;
                    decimal Side = Convert.ToDecimal(((TextBox)linea.FindControl("txtSide")).Text);
                    decimal Total = Convert.ToDecimal(((TextBox)linea.FindControl("txtTotal")).Text);
                    decimal MoneyLine = Convert.ToDecimal(((TextBox)linea.FindControl("txtMoneyLine")).Text);
                    decimal Parlays = Convert.ToDecimal(((TextBox)linea.FindControl("txtParlays")).Text);
                    decimal Teasers = Convert.ToDecimal(((TextBox)linea.FindControl("txtTeasers")).Text);
                    decimal IfBets = Convert.ToDecimal(((TextBox)linea.FindControl("txtIfBets")).Text);
                    decimal Reverses = Convert.ToDecimal(((TextBox)linea.FindControl("txtReverses")).Text);

                    string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
                    SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
                    Cnn.Open();
                    SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfileLimits_Update", Cnn);
                    comm.CommandType = CommandType.StoredProcedure;

                    ((SqlParameter)comm.Parameters.Add("@idPlayer", SqlDbType.Int)).Value = idPlayer;
                    ((SqlParameter)comm.Parameters.Add("@Online", SqlDbType.TinyInt)).Value = Online;
                    ((SqlParameter)comm.Parameters.Add("@IdGameType", SqlDbType.Int)).Value = idGameType;
                    ((SqlParameter)comm.Parameters.Add("@IdSport", SqlDbType.Char, 5)).Value = idSport;
                    ((SqlParameter)comm.Parameters.Add("@Side", SqlDbType.Money)).Value = Side;
                    ((SqlParameter)comm.Parameters.Add("@Total", SqlDbType.Money)).Value = Total;
                    ((SqlParameter)comm.Parameters.Add("@MoneyLine", SqlDbType.Money)).Value = MoneyLine;
                    ((SqlParameter)comm.Parameters.Add("@Parlays", SqlDbType.Money)).Value = Parlays;
                    ((SqlParameter)comm.Parameters.Add("@Teasers", SqlDbType.Money)).Value = Teasers;
                    ((SqlParameter)comm.Parameters.Add("@IfBets", SqlDbType.Money)).Value = IfBets;
                    ((SqlParameter)comm.Parameters.Add("@Reverses", SqlDbType.Money)).Value = Reverses;

                    SqlDataReader reader;
                    try
                    {
                        reader = comm.ExecuteReader();
                        reader.Close();
                    }
                    catch (Exception err)
                    {
                        //TODO
                    }
                    finally
                    {
                        Cnn.Close();
                    }
                }
                lblWarning.Text = "Your changes have been submitted.";
                lblWarning.Visible = true;
            }
            else
            {
                lblWarning.Text = "WARNING!!! Can't change this profile, please create a custome limits profile.";
                lblWarning.Visible = true;
            }

        }


        protected void CloneProfile()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {

                int idPlayer = int.Parse(ddlPlayers.SelectedValue);
                SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfileLimits_ClonePlayerProfileLimits", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdProfileLimits", SqlDbType.Int)).Value = ddlProfiles.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmNewName", SqlDbType.VarChar)).Value = ddlPlayers.SelectedItem.Text;
                ((SqlParameter)comm.Parameters.Add("@idPlayer", SqlDbType.Int)).Value = idPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = Convert.ToInt32(Session["idAgent"]);
                SqlDataReader reader;
                reader = comm.ExecuteReader();
                lblWarning.Text = "Player Limits Profile Created.";
            }
            catch (Exception err)
            {
                lblWarning.Text = err.Message;
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
                SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfileLimits_ChangePlayerProfile", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmidPlayer", SqlDbType.Int)).Value = ddlPlayers.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmIdProfileLimits", SqlDbType.Int)).Value = ddlProfiles.SelectedValue;
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

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            if (AceptChanges())
            {
                foreach (GridViewRow linea in GridView1.Rows)
                {
                    ((TextBox)linea.FindControl("txtSide")).Text = txtApplyAll.Text;
                    ((TextBox)linea.FindControl("txtTotal")).Text = txtApplyAll.Text;
                    ((TextBox)linea.FindControl("txtMoneyLine")).Text = txtApplyAll.Text;
                    ((TextBox)linea.FindControl("txtParlays")).Text = txtApplyAll.Text;
                    ((TextBox)linea.FindControl("txtTeasers")).Text = txtApplyAll.Text;
                    ((TextBox)linea.FindControl("txtIfBets")).Text = txtApplyAll.Text;
                    ((TextBox)linea.FindControl("txtReverses")).Text = txtApplyAll.Text;
                    ((TextBox)linea.FindControl("txtRelated")).Text = txtApplyAll.Text;
                }
            }
            else
            {
                lblWarning.Text = "alert('WARNING!!! Cant change a this profile, please create a custome profile.";
                lblWarning.Visible = true;
            }
        }

        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            GridView1.Enabled = AceptChanges();
        }

        protected void disableTextBox()
        {
            foreach (GridViewRow linea in GridView1.Rows)
            {
                ((TextBox)linea.FindControl("txtSide")).Enabled = false;
                ((TextBox)linea.FindControl("txtTotal")).Enabled = false;
                ((TextBox)linea.FindControl("txtMoneyLine")).Enabled = false;
                ((TextBox)linea.FindControl("txtParlays")).Enabled = false;
                ((TextBox)linea.FindControl("txtTeasers")).Enabled = false;
                ((TextBox)linea.FindControl("txtIfBets")).Enabled = false;
                ((TextBox)linea.FindControl("txtReverses")).Enabled = false;
                ((TextBox)linea.FindControl("txtRelated")).Enabled = false;
            }

            lblWarning.Text = "WARNING!!! Cant change a default profile.";
            lblWarning.Visible = true;
            btnApply.Enabled = false;
            btnRefresh.Enabled = false;
            btnReset.Enabled = false;
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

                SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfileLimits_ProfileAceptChanges", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = ddlPlayers.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = Convert.ToInt32(Session["idAgent"]);
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

        protected void rdnOnline_CheckedChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }

        protected void rdnLocal_CheckedChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }

        protected void ddlPLayers_SelectedIndexChanged1(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }


        protected void btnCreate_Click(object sender, EventArgs e)
        {
            CloneProfile();

            ddlProfiles.DataBind();
            ddlProfiles.SelectedValue = GetProfileLimits().ToString();

            GridView1.DataBind();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            try
            {
                GridView1.DataBind();
                ddlProfiles.SelectedValue = GetProfileLimits().ToString();
            }
            catch { }
        }


        protected void btnSetProfile_Click(object sender, EventArgs e)
        {
            ChangeProfilePlayer();
            ddlProfiles.SelectedValue = GetProfileLimits().ToString();
            GridView1.DataBind();
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
                GridView1.DataBind();
                ddlProfiles.SelectedValue = GetProfileLimits().ToString();
            }
            catch { }
        }

        protected void ddlAgents_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                ddlPlayers.DataBind();
                GridView1.DataBind();
                ddlProfiles.SelectedValue = GetProfileLimits().ToString();
            }
            catch { }
        }

        protected void btnApplyOnlinePhone_Click(object sender, EventArgs e)
        {
            saveProfile(true);
            saveProfile(false);
        }
    }
}
