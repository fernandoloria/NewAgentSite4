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
    public partial class LimitsProfile  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        void Page_Load(object sender, System.EventArgs e)
        {
            lblAg.Text = this.Session["SubAgent"].ToString();

            if (!IsPostBack)
            {
                int idPlayer = Convert.ToInt32(Request.QueryString["idPlayer"]);

                //LoadAgents();
                LoadPlayers();
                ddlPLayers.SelectedValue = idPlayer.ToString();
                LoadLimnitProfile();
                Response.Write("<script type='text/javascript'>" +
                         "function popWin(){ window.open('CreateProfile.aspx?idPlayer=" + ddlPLayers.SelectedValue + "','popup','width=350,height=300,center=1'); }" +
                         "<" + "/" + "script>");
                btnCreate.Attributes.Add("onclick", "popWin()");
            }


        }

        private void LoadPlayers()
        {
            ddlPLayers.Items.Clear();

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();

            int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
            int prmSubIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
            SqlCommand comm = new SqlCommand("GetPlayersByIdAgent", Cnn);

            comm.CommandType = CommandType.StoredProcedure;
            ((SqlParameter)comm.Parameters.Add("@IdAgent", SqlDbType.Int)).Value = prmSubIdAgent;
            SqlDataReader reader;
            try
            {
                ListItem newItem = new ListItem();
                reader = comm.ExecuteReader();
                while (reader.Read())
                {
                    newItem = new ListItem();
                    newItem.Text = reader["PLAYER"].ToString();
                    newItem.Value = reader["IdPlayer"].ToString();
                    ddlPLayers.Items.Add(newItem);
                }
                reader.Close();
            }
            catch (Exception err)
            {
                string error = err.Message;
                //TODO
            }
            finally
            {
                Cnn.Close();
            }
        }

        string getProfileName()
        {

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            int idPlayer = int.Parse(ddlPLayers.SelectedValue);
            SqlCommand comm = new SqlCommand("GetPlayerProfileLimitsByidPlayerWeb", Cnn);
            comm.CommandType = CommandType.StoredProcedure;
            ((SqlParameter)comm.Parameters.Add("@idPlayer", SqlDbType.Int)).Value = idPlayer;
            SqlDataReader reader;
            string nombre = "";
            try
            {
                reader = comm.ExecuteReader();
                while (reader.Read())
                {
                    nombre = reader["ProfileName"].ToString().Trim();
                }
                reader.Close();
            }

            catch (Exception err)
            {
                string error = err.Message;
                //TODO
            }
            finally
            {
                Cnn.Close();
            }
            return nombre;
        }



        private void LoadLimnitProfile()
        {
            btnApply.Enabled = true;
            btnRefresh.Enabled = true;
            btnReset.Enabled = true;
            lblWarning.Visible = false;

            lblAg.Text = ddlPLayers.SelectedItem.Text + " Profile Name: " + getProfileName();

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();

            int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
            int prmSubIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
            int idPlayer = int.Parse(ddlPLayers.SelectedValue);
            bool Online = rdnOnline.Checked ? true : false;
            int IdGameType = Convert.ToInt32(ddlGameType.SelectedValue);

            SqlCommand comm = new SqlCommand("GetProfileLimitsDetailsByIdPlayer", Cnn);
            comm.CommandType = CommandType.StoredProcedure;
            ((SqlParameter)comm.Parameters.Add("@idPlayer", SqlDbType.Int)).Value = idPlayer;
            ((SqlParameter)comm.Parameters.Add("@Online", SqlDbType.Bit)).Value = Online;
            ((SqlParameter)comm.Parameters.Add("@IdGameType", SqlDbType.Int)).Value = IdGameType;
            SqlDataReader reader;
            try
            {
                reader = comm.ExecuteReader();
                while (reader.Read())
                {
                    String IdProfileLimits = reader["IdProfileLimits"].ToString().Trim();
                    if (IdProfileLimits == "1")
                    {
                        disableTextBox();
                    }
                    String IdSport = reader["IdSport"].ToString().Trim();
                    String Side = reader["Side"].ToString().Trim();
                    String Total = reader["Total"].ToString().Trim();
                    String MoneyLine = reader["MoneyLine"].ToString().Trim();
                    String Parlays = reader["Parlays"].ToString().Trim();
                    String Teasers = reader["Teasers"].ToString().Trim();
                    String IfBets = reader["IfBets"].ToString().Trim();
                    String Reverses = reader["Reverses"].ToString().Trim();

                    ((TextBox)pnDAtos.FindControl("txtSide" + IdSport.Trim())).Text = Side.Replace(".0000", "");
                    ((TextBox)pnDAtos.FindControl("txtTotal" + IdSport.Trim())).Text = Total.Replace(".0000", "");
                    ((TextBox)pnDAtos.FindControl("txtMoneyLine" + IdSport.Trim())).Text = MoneyLine.Replace(".0000", "");
                    ((TextBox)pnDAtos.FindControl("txtParlays" + IdSport.Trim())).Text = Parlays.Replace(".0000", "");
                    ((TextBox)pnDAtos.FindControl("txtTeasers" + IdSport.Trim())).Text = Teasers.Replace(".0000", "");
                    ((TextBox)pnDAtos.FindControl("txtIfBets" + IdSport.Trim())).Text = IfBets.Replace(".0000", "");
                    ((TextBox)pnDAtos.FindControl("txtReverses" + IdSport.Trim())).Text = Reverses.Replace(".0000", "");

                }
                reader.Close();
            }
            catch (Exception err)
            {
                string error = err.Message;
                //TODO
            }
            finally
            {
                Cnn.Close();
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            LoadLimnitProfile();
        }

        protected void btnApply_Click(object sender, EventArgs e)
        {
            string[] idSport = new string[] { "CBB", "CFB", "ESOC", "MLB", "MU", "NBA", "NFL", "NHL", "PROP", "SOC", "TNT" };
            bool Online = rdnOnline.Checked;
            int IdGameType = Convert.ToInt32(ddlGameType.SelectedValue);
            int idPlayer = Convert.ToInt32(ddlPLayers.SelectedValue);

            for (int i = 0; i < idSport.Length; i++)
            {
                String IdSport = idSport[i];
                decimal Side = Convert.ToDecimal(((TextBox)pnDAtos.FindControl("txtSide" + IdSport.Trim())).Text);
                decimal Total = Convert.ToDecimal(((TextBox)pnDAtos.FindControl("txtTotal" + IdSport.Trim())).Text);
                decimal MoneyLine = Convert.ToDecimal(((TextBox)pnDAtos.FindControl("txtMoneyLine" + IdSport.Trim())).Text);
                decimal Parlays = Convert.ToDecimal(((TextBox)pnDAtos.FindControl("txtParlays" + IdSport.Trim())).Text);
                decimal Teasers = Convert.ToDecimal(((TextBox)pnDAtos.FindControl("txtTeasers" + IdSport.Trim())).Text);
                decimal IfBets = Convert.ToDecimal(((TextBox)pnDAtos.FindControl("txtIfBets" + IdSport.Trim())).Text);
                decimal Reverses = Convert.ToDecimal(((TextBox)pnDAtos.FindControl("txtReverses" + IdSport.Trim())).Text);

                string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
                SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
                Cnn.Open();
                SqlCommand comm = new SqlCommand("PLAYERPROFILELIMITSDETAILS_updateLineWEB", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@idPlayer", SqlDbType.Int)).Value = idPlayer;
                ((SqlParameter)comm.Parameters.Add("@Online", SqlDbType.TinyInt)).Value = Online;
                ((SqlParameter)comm.Parameters.Add("@IdGameType", SqlDbType.Int)).Value = IdGameType;
                ((SqlParameter)comm.Parameters.Add("@IdSport", SqlDbType.Char, 5)).Value = IdSport;
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
                    string error = err.Message;
                    //TODO
                }
                finally
                {
                    Cnn.Close();
                }
            }
            Response.Write("<script>alert('Your changes have been submitted. These changes usually take 5-7 minutes. However, it may take up to 10 minutes for these changes to take effect.');" + "<" + "/" + "script>");



        }

        protected void ddlPLayers_SelectedIndexChanged1(object sender, EventArgs e)
        {
            Response.Redirect(Request.Path + "?idPlayer=" + ddlPLayers.SelectedValue);
            LoadLimnitProfile();
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            foreach (Control c in pnDAtos.Controls)
            {
                if (c is TextBox)
                {
                    TextBox questionTextBox = c as TextBox;
                    if (questionTextBox != null)
                    {
                        questionTextBox.Text = txtApplyAll.Text;
                    }
                }
            }

        }

        protected void disableTextBox()
        {
            foreach (Control c in pnDAtos.Controls)
            {
                if (c is TextBox)
                {
                    TextBox questionTextBox = c as TextBox;
                    if (questionTextBox != null)
                    {
                        questionTextBox.Enabled = false;

                    }
                }
            }
            lblWarning.Text = "WARNING!!! Cant change a default profile.";
            lblWarning.Visible = true;
            btnApply.Enabled = false;
            btnRefresh.Enabled = false;
            btnReset.Enabled = false;
        }

        protected void rdnOnline_CheckedChanged(object sender, EventArgs e)
        {
            LoadLimnitProfile();
        }

        protected void rdnLocal_CheckedChanged(object sender, EventArgs e)
        {
            LoadLimnitProfile();
        }

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLimnitProfile();
        }
    }
}
