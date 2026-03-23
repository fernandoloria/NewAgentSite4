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
    public partial class PlayerFreePlay  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        void Page_Load(object sender, System.EventArgs e)
        {
            VerifyWeeklyFreePlayLimit(0);
        }

        private void LoadPlayers()
        {
            ddlPLayers.Items.Clear();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            //int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
            int prmSubIdAgent = int.Parse(ddlAgent.SelectedValue);
            int prmDays = int.Parse(txtDays.Text);
            bool prmActive = chkActive.Checked;
            SqlCommand comm = new SqlCommand("Player_GetActivesByAgent", Cnn);
            comm.CommandType = CommandType.StoredProcedure;
            ((SqlParameter)comm.Parameters.Add("@prmIDAgent", SqlDbType.Int)).Value = prmSubIdAgent;
            ((SqlParameter)comm.Parameters.Add("@prmActive", SqlDbType.Bit)).Value = prmActive;
            ((SqlParameter)comm.Parameters.Add("@prmDays", SqlDbType.Int)).Value = prmDays;
            SqlDataReader reader;
            try
            {
                int index = 0;
                ListItem newItem = new ListItem();
                reader = comm.ExecuteReader();
                while (reader.Read())
                {
                    if (index == 0)
                    {
                        newItem = new ListItem();
                        newItem.Text = "Add Free Play to all Players";
                        newItem.Value = "-1";
                        ddlPLayers.Items.Add(newItem);
                    }
                    newItem = new ListItem();
                    newItem.Text = reader["PLAYER"].ToString();
                    newItem.Value = reader["IdPlayer"].ToString();
                    ddlPLayers.Items.Add(newItem);
                    index++;
                }
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
            bool btnAvailable = ddlPLayers.Items.Count > 0;
            btnAdd.Enabled = btnAvailable;

        }


        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (txtNumber.Text.Trim() == "")
            {
                lblError.Text = "Invalid amount";
            }
            else
            {
                if (Convert.ToInt32(ddlPLayers.SelectedValue) == -1)
                {
                    foreach (ListItem item in ddlPLayers.Items)
                    {
                        if (VerifyWeeklyFreePlayLimit(Convert.ToDecimal(txtNumber.Text)))
                        {
                            if (Convert.ToInt32(item.Value) != -1)
                                addFreePlay(Convert.ToInt32(item.Value));
                        }
                    }
                }
                else
                {
                    if (VerifyWeeklyFreePlayLimit(Convert.ToDecimal(txtNumber.Text)))
                    {
                        addFreePlay(Convert.ToInt32(ddlPLayers.SelectedValue));
                        loadFreePlayAmount();
                    }
                }
            }

        }

        protected void addFreePlay(int idPlayer)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            try
            {

                Cnn.Open();

                SqlCommand comm = new SqlCommand("InsertPlayerTransaction", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = idPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmDescription", SqlDbType.VarChar)).Value = "Free Play";
                ((SqlParameter)comm.Parameters.Add("@prmAmount", SqlDbType.Money)).Value = txtNumber.Text;
                ((SqlParameter)comm.Parameters.Add("@prmReference", SqlDbType.VarChar)).Value = "";
                ((SqlParameter)comm.Parameters.Add("@prmFee", SqlDbType.Money)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmBonus", SqlDbType.Money)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmIdPaymentMethod", SqlDbType.TinyInt)).Value = 2;
                ((SqlParameter)comm.Parameters.Add("@prmTransactionType", SqlDbType.Char)).Value = "P";
                ((SqlParameter)comm.Parameters.Add("@prmTransactionDate", SqlDbType.DateTime)).Value = DateTime.Now;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 252; // USER AGENT ONLINE
                ((SqlParameter)comm.Parameters.Add("@prmIdAdjustmentType", SqlDbType.TinyInt)).Value = DBNull.Value;
                ((SqlParameter)comm.Parameters.Add("@prmOutIdTransaction", SqlDbType.Int)).Direction = ParameterDirection.Output;


                SqlDataReader reader;
                reader = comm.ExecuteReader();
                lblError.Text = "Free Play Added";
                lblError.CssClass = "text-success";
                //txtNumber.Text = "";

                //txtMessage.Text = "";
                Cnn.Close();

                //txtMessage.Text = "";
            }
            catch (Exception ex)
            {
                lblError.Text = "Free Play can't be added, plase try later " + ex.Message;
                lblError.CssClass = "text-danger";
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {

        }

        protected void ddlPLayers_SelectedIndexChanged(object sender, EventArgs e)
        {
            loadFreePlayAmount();

        }


        protected void loadFreePlayAmount()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("GetCurrentFPAmount", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                int idPlayer = int.Parse(ddlPLayers.SelectedValue);

                ((SqlParameter)comm.Parameters.Add("IdPlayer", SqlDbType.Int)).Value = idPlayer;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
                lblFreePlay.Text = table.Rows[0]["FreePlayAmount"].ToString();
                RangeValidator1.MinimumValue = (Convert.ToDecimal(lblFreePlay.Text) * -1).ToString();
            }

            catch (Exception myError)
            {
                //Response.Write("<script language=javascript>alert('"+myError.Message.ToString()+"');</"+"script>");
            }

            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }

        protected void ddlPlayer_DataBound(object sender, EventArgs e)
        {
            string DGS_ReportsConnString = ConfigurationManager.ConnectionStrings["DGS_ReportsConnString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_ReportsConnString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("GetCurrentFPAmount", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                int idPlayer = int.Parse(ddlPLayers.SelectedValue);

                ((SqlParameter)comm.Parameters.Add("IdPlayer", SqlDbType.Int)).Value = idPlayer;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
                lblFreePlay.Text = table.Rows[0]["FreePlayAmount"].ToString();
            }

            catch (Exception myError)
            {
                //Response.Write("<script language=javascript>alert('"+myError.Message.ToString()+"');</"+"script>");
            }

            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }

        public bool VerifyWeeklyFreePlayLimit(decimal amount)
        {
            bool isAllowed = false;
            decimal availableBalance = 0;
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("WeeklyFreePlayLimit_VerifyLimit_Agent", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = Convert.ToInt32(Session["IdAgent"]);
                cmd.Parameters.Add("@prmCurrentDate", SqlDbType.Date).Value = DateTime.Now;
                cmd.Parameters.Add("@prmFreePlayAmount", SqlDbType.Money).Value = amount;
                cmd.Parameters.Add("@outAllowed", SqlDbType.Bit).Direction = ParameterDirection.Output;
                cmd.Parameters.Add("@outAvailableBalance", SqlDbType.Money).Direction = ParameterDirection.Output;

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    isAllowed = (bool)cmd.Parameters["@outAllowed"].Value;
                    availableBalance = (decimal)cmd.Parameters["@outAvailableBalance"].Value;
                }
                catch (Exception ex)
                {

                }
            }
            if (!isAllowed || availableBalance == 0)
            {
                Response.Redirect("~/Report/NoFreePlayAvailableBalance.aspx");
            }

            if (availableBalance > 0)
            {
                lblAvailableFreePlayBalance.Text = "Available Free Play Balance: " + availableBalance.ToString("N0");
            }

            if (amount > 0 && amount > availableBalance)
            {
                lblError.Text = "Free Play can't be added, the available free play balance is " + availableBalance.ToString("N0");
                lblError.CssClass = "text-danger";
            }

            return isAllowed;
        }


        protected void ddlAgent_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadPlayers();
        }

        protected void ddlAgent_DataBound(object sender, EventArgs e)
        {
            LoadPlayers();
        }

        protected void chkActive_CheckedChanged(object sender, EventArgs e)
        {
            LoadPlayers();
        }
    }
}
