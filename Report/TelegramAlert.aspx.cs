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
    public partial class TelegramAlert  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DisplayPasskey();
            }
            if (!Common.HasRights(ReportPosition.TELEGRAMALERT))
            {
                Response.End();
            }
        }

        protected void btnGeneratePasskey_Click(object sender, EventArgs e)
        {
            int idAgent = Convert.ToInt32(Session["IdAgent"]);
            GeneratePasskey(idAgent);
            DisplayPasskey();
        }

        private void DisplayPasskey()
        {
            string passkey = GetPasskeyByAgent();

            if (!string.IsNullOrEmpty(passkey))
            {
                lblPasskey.Text = "PassKey: <strong>" + passkey + "</strong> ";
                lblPasskey.Attributes["onclick"] = "copyToClipboard('" + passkey + "');";
                btnGeneratePasskey.Visible = false;
                hlOpenTelegram.Visible = true;
                hlOpenTelegram.NavigateUrl = "https://t.me/MessageAlert2023Bot";
            }
            else
            {
                lblPasskey.Text = "No passkey generated";
                btnGeneratePasskey.Visible = true;
                hlOpenTelegram.Visible = false;
            }
        }



        protected void GridView1_DataBound(object sender, EventArgs e)
        {

        }


        protected void btnSumit_Click(object sender, EventArgs e)
        {
            int idPlayer = Convert.ToInt32(ddlPlayer.SelectedValue);
            decimal risk = Convert.ToDecimal(txtRiskAmount.Text);
            decimal win = Convert.ToDecimal(txtWinAmount.Text);
            InsertBotAlert(idPlayer, risk, win, true);
            GridView1.DataBind();

        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "btnSave")
            {
                int indexGrid = Convert.ToInt32(e.CommandArgument);
                GridViewRow GridViewR = GridView1.Rows[indexGrid];
                int idPlayer = Convert.ToInt32(((HiddenField)GridViewR.Cells[0].FindControl("HiddenField1")).Value);
                decimal risk = Convert.ToDecimal(((TextBox)GridViewR.Cells[2].FindControl("TextBox6")).Text);
                decimal win = Convert.ToDecimal(((TextBox)GridViewR.Cells[3].FindControl("TextBox7")).Text);
                bool active = ((CheckBox)GridViewR.Cells[0].FindControl("CheckBox1")).Checked;
                UpdateBotAlert(idPlayer, risk, win, true);
                GridView1.DataBind();

            }
            else if (e.CommandName == "btnDelete")
            {
                int indexGrid = Convert.ToInt32(e.CommandArgument);
                GridViewRow GridViewR = GridView1.Rows[indexGrid];
                int idPlayer = Convert.ToInt32(((HiddenField)GridViewR.Cells[0].FindControl("HiddenField1")).Value);

                DeleteBotAlert(idPlayer);
                GridView1.DataBind();

            }
        }

        public void InsertBotAlert(int idPlayer, decimal riskAmount, decimal winAmount, bool active)
        {
            try
            {
                int idAgent = Convert.ToInt32(Session["IdAgent"]);
                string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(DGS_AddOnsConnectionString))
                {
                    SqlCommand command = new SqlCommand("BotAlert_Insert", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@IdPlayer", idPlayer);
                    command.Parameters.AddWithValue("@IdAgent", idAgent);
                    command.Parameters.AddWithValue("@RiskAmount", riskAmount);
                    command.Parameters.AddWithValue("@WinAmount", winAmount);
                    command.Parameters.AddWithValue("@Active", active);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {


            }
        }

        public void UpdateBotAlert(int idPlayer, decimal riskAmount, decimal winAmount, bool active)
        {
            try
            {
                int idAgent = Convert.ToInt32(Session["IdAgent"]);
                string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(DGS_AddOnsConnectionString))
                {
                    SqlCommand command = new SqlCommand("BotAlert_Update", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@IdPlayer", idPlayer);
                    command.Parameters.AddWithValue("@IdAgent", idAgent);
                    command.Parameters.AddWithValue("@RiskAmount", riskAmount);
                    command.Parameters.AddWithValue("@WinAmount", winAmount);
                    command.Parameters.AddWithValue("@Active", active);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {

            }
        }

        public void DeleteBotAlert(int idPlayer)
        {
            try
            {
                int idAgent = Convert.ToInt32(Session["IdAgent"]);
                string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(DGS_AddOnsConnectionString))
                {
                    SqlCommand command = new SqlCommand("BotAlert_Delete", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@IdPlayer", idPlayer);
                    command.Parameters.AddWithValue("@IdAgent", idAgent);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
            }
        }

        private string GetPasskeyByAgent()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            string passkey = null;
            string idAgent = Session["Agent"].ToString();
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand("BotAgentSuscription_GetByAgent", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@prmAgent", idAgent);

                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            passkey = reader["ChatPassword"] as string;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
            }

            return passkey;
        }

        private void GeneratePasskey(int idAgent)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand command = new SqlCommand("BotAgentSuscription_Insert", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@IdAgent", idAgent);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
            }
        }


    }
}
