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
    public partial class ManagePlayerMessage  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Init(object sender, EventArgs e)
        {

        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {

        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            GridViewRow GridViewR = (GridViewRow)(((LinkButton)e.CommandSource).NamingContainer);
            int IdPlayerMessage = Convert.ToInt32(((HiddenField)GridViewR.Cells[0].FindControl("HiddenField1")).Value);
            string message = ((TextBox)GridViewR.Cells[0].FindControl("TextBox2")).Text.Trim();

            switch (e.CommandName)
            {
                case "btnDelete":
                    deleteMessage(IdPlayerMessage);
                    GridView1.DataBind();
                    break;
                case "btnSave":
                    UpdateMessage(IdPlayerMessage, message);
                    GridView1.DataBind();
                    break;
            }

        }

        protected void btnCreateMessage_Click(object sender, EventArgs e)
        {
            if (ddlPlayer.SelectedValue == "-1")
            {
                foreach (ListItem item in ddlPlayer.Items)
                {
                    if (item.Value == "-1")
                    {
                        continue;
                    }
                    SendMessage(Convert.ToInt32(item.Value));
                }
            }
            else
            {
                SendMessage(Convert.ToInt32(ddlPlayer.SelectedValue));
            }
            GridView1.DataBind();

        }

        protected void SendMessage(int idPlayer)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            try
            {
                bool MessageType = ddlMessageType.SelectedValue == "N" ? false : true;
                bool UseExpirationDate = chkExpirationDate.Checked;
                bool UseDisplayCounter = txtCounter.Text == "" || txtCounter.Text == "0" ? false : true;
                bool UseCloseOption = chkPlayerCanDisable.Checked;
                DateTime ExpirationDate = txtExpirationDate.Text != "" ? Convert.ToDateTime(txtExpirationDate.Text) : DateTime.Now.AddDays(180);
                byte DisplayCounter = txtCounter.Text == "" ? Convert.ToByte(0) : Convert.ToByte(txtCounter.Text);
                DateTime LastModification = DateTime.Now;
                Cnn.Open();
                SqlCommand comm = new SqlCommand("PlayerMessages_Insert", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = idPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmMessage", SqlDbType.VarChar)).Value = txtMessage.Text;
                ((SqlParameter)comm.Parameters.Add("@prmMessageType", SqlDbType.Bit)).Value = MessageType;
                ((SqlParameter)comm.Parameters.Add("@prmUseExpirationDate", SqlDbType.Bit)).Value = UseExpirationDate;
                ((SqlParameter)comm.Parameters.Add("@prmUseDisplayCounter", SqlDbType.Bit)).Value = UseDisplayCounter;
                ((SqlParameter)comm.Parameters.Add("@prmUseCloseOption", SqlDbType.Bit)).Value = UseCloseOption;
                ((SqlParameter)comm.Parameters.Add("@prmExpirationDate", SqlDbType.Date)).Value = ExpirationDate;
                ((SqlParameter)comm.Parameters.Add("@prmDisplayCounter", SqlDbType.TinyInt)).Value = DisplayCounter;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 181;

                SqlDataReader reader;
                reader = comm.ExecuteReader();
                lblMessageTitle.Text = "Message Sent";
                lblMessage.Text = "The Message has been successfully sent to the player";
                pnAlert.Visible = true;
            }
            catch (Exception myErr)
            {
                //lblMessageTitle.Text = "Message can't be sent";
                //lblMessage.Text = myErr.Message;
                //pnAlert.Visible = true;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }


        protected void UpdateMessage(int IdPlayerMessage, string message)
        {

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("ManagePlayerMessages_Update", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdPlayerMessage", SqlDbType.Int)).Value = IdPlayerMessage;
                ((SqlParameter)comm.Parameters.Add("@prmMessage", SqlDbType.VarChar)).Value = message;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
            }
            catch (Exception myErr) { Response.Write(myErr.Message); }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }

        protected void deleteMessage(int IdPlayerMessage)
        {

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("ManagePlayerMessages_Delete", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdPlayerMessage", SqlDbType.Int)).Value = IdPlayerMessage;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
            }
            catch (Exception myErr) { Response.Write(myErr.Message); }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }


        protected void ManagePlayerMessages_AllDelete(int idAgent, int idPlayer)
        {

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("ManagePlayerMessages_AllDelete", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIDAgent", SqlDbType.Int)).Value = idAgent;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = idPlayer;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
            }
            catch (Exception myErr) { Response.Write(myErr.Message); }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
        }



        protected void ddlPlayer_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlPlayer.SelectedValue == "-1")
            {
                lblTitlePlayer.Text = "Create message to all Players under agent " + ddlAgent.SelectedItem.Text;
            }
            else
            {
                lblTitlePlayer.Text = "Create message to Player " + ddlPlayer.SelectedItem.Text;
            }
        }

        protected void ddlPlayer_DataBound(object sender, EventArgs e)
        {
            if (ddlPlayer.SelectedValue == "-1")
            {
                lblTitlePlayer.Text = "Create message to all Players under agent " + ddlAgent.SelectedItem.Text;
            }
            else
            {
                lblTitlePlayer.Text = "Create message to Player " + ddlPlayer.SelectedItem.Text;
            }

        }


        protected void Button1_Click(object sender, EventArgs e)
        {
            if (txtDELETE.Text.ToUpper() == "DELETE")
            {
                lblDeleteMessage.Text = "";
                int idAgent = Convert.ToInt32(ddlAgent.SelectedValue);
                int idPlayer = Convert.ToInt32(ddlPlayer.SelectedValue);
                ManagePlayerMessages_AllDelete(idAgent, idPlayer);
                GridView1.DataBind();
            }
            else
            {
                lblDeleteMessage.Text = "To delete all messages please write the word DELETE";
            }


        }
    }
}
