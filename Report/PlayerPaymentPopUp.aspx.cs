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
using static AgentSite4.Services.FreePlayAdd;

namespace AgentSite4.Report
{
    public partial class PlayerPaymentPopUp  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtDate.Text = DateTime.Now.ToString("MM/dd/yyy");

                DataRow[] rows;
                DataTable table = getAgentPaymentRights();
                int index = 0;

                rows = table.Select("IdRight = 168");
                if (rows.Length > 0)
                {
                    ddlTransactionType.Items.Insert(index, new ListItem("ADJUSTMENT", "A"));
                    index++;
                }

                rows = table.Select("IdRight = 169");
                if (rows.Length > 0)
                {
                    ddlTransactionType.Items.Insert(index, new ListItem("ACCRUAL ADJUSTMENT", "C"));
                    index++;
                }

                rows = table.Select("IdRight = 170");
                if (rows.Length > 0)
                {
                    ddlTransactionType.Items.Insert(index, new ListItem("HORSE ADJUSTMENT", "h"));
                    index++;
                }

                rows = table.Select("IdRight = 171");
                if (rows.Length > 0)
                {
                    ddlTransactionType.Items.Insert(index, new ListItem("DISBURSEMENT", "D"));
                    index++;
                }
                rows = table.Select("IdRight = 172");
                if (rows.Length > 0)
                {
                    ddlTransactionType.Items.Insert(index, new ListItem("RECEIPT", "R"));
                    index++;
                }
                rows = table.Select("IdRight = 184");
                if (rows.Length > 0)
                {
                    ddlTransactionType.Items.Insert(index, new ListItem("FREE PLAY", "P"));
                    index++;
                }

            }
            loadValidator();

            if (!canCreateTransactions())
            {
                Button1.Visible = false;
                error.Text = Alert(4, "Unable to make payments", "Right now you can not make payments because the week has not closed yet, please try again later. <br /><br />");
            }
        }

        protected bool canCreateTransactions()
        {
            bool enableTransactions = false;
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("AgentEnableTransactions", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
                enableTransactions = Convert.ToBoolean(table.Rows[0]["enableTransactions"].ToString());
            }

            catch (Exception myError)
            {
                //Response.Write("<script language=javascript>alert('"+myError.Message.ToString()+"');</"+"script>");
            }

            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return enableTransactions;

        }

        protected string Alert(int type, string header, string message)
        {
            string strType = "";
            switch (type)
            {
                case 1:
                    strType = "success";
                    break;
                case 2:
                    strType = "info";
                    break;
                case 3:
                    strType = "warning";
                    break;
                case 4:
                    strType = "danger";
                    break;
            }
            string str = "<div class='alert alert-" + strType + " alert-dismissible' role='alert'>";
            str += "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>";
            str += "<strong>" + header + "</strong>";
            str += "<br />" + message;
            str += "</div>";
            return str;
        }

        protected void loadValidator()
        {
            DateTime minimumValue = fromOrTo(true);
            DateTime maximunValue = minimumValue.AddDays(6);
            RangeValidator1.MinimumValue = minimumValue.ToString("MM/dd/yyyy");
            RangeValidator1.MaximumValue = maximunValue.ToString("MM/dd/yyyy");
            RangeValidator1.ErrorMessage = "(*Can be only between " + minimumValue.ToShortDateString() + " and " + maximunValue.ToShortDateString() + ")";
        }

        protected DateTime fromOrTo(bool esFrom)
        {
            DayOfWeek todayDay = DateTime.Now.DayOfWeek;
            int minusdays = 0;
            int plusdays = 0;
            switch (todayDay)
            {

                case DayOfWeek.Monday:
                    minusdays = 0;
                    plusdays = 6;
                    break;
                case DayOfWeek.Tuesday:
                    minusdays = 1;
                    plusdays = 5;
                    break;
                case DayOfWeek.Wednesday:
                    minusdays = 2;
                    plusdays = 4;
                    break;
                case DayOfWeek.Thursday:
                    minusdays = 3;
                    plusdays = 3;
                    break;
                case DayOfWeek.Friday:
                    minusdays = 4;
                    plusdays = 2;
                    break;
                case DayOfWeek.Saturday:
                    minusdays = 5;
                    plusdays = 1;
                    break;
                case DayOfWeek.Sunday:
                    minusdays = 6;
                    plusdays = 0;
                    break;
            }
            if (esFrom)
            {
                return DateTime.Now.AddDays(-minusdays);
            }
            else
            {
                return DateTime.Now.AddDays(plusdays);
            }
        }


        protected void Button1_Click(object sender, EventArgs e)
        {
            addPayment();
            loadPassword();
        }

        protected void addPayment()
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            try
            {
                decimal positive = ddlTransactionType.SelectedValue == "D" ? -1 : 1;
                SqlCommand comm = new SqlCommand("InsertPlayerTransaction", Cnn);
                comm.CommandType = CommandType.StoredProcedure;


                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = ddlPlayer.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmDescription", SqlDbType.VarChar)).Value = txtDescription.Text;
                ((SqlParameter)comm.Parameters.Add("@prmAmount", SqlDbType.Money)).Value = Convert.ToDecimal(txtAmount.Text) * positive;
                ((SqlParameter)comm.Parameters.Add("@prmReference", SqlDbType.VarChar)).Value = txtReference.Text;
                ((SqlParameter)comm.Parameters.Add("@prmFee", SqlDbType.Money)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmBonus", SqlDbType.Money)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmIdPaymentMethod", SqlDbType.TinyInt)).Value = ddlPaymentMethod.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmTransactionType", SqlDbType.Char)).Value = ddlTransactionType.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmTransactionDate", SqlDbType.DateTime)).Value = txtDate.Text;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 181;
                ((SqlParameter)comm.Parameters.Add("@prmIdAdjustmentType", SqlDbType.TinyInt)).Value = 1;
                ((SqlParameter)comm.Parameters.Add("@prmOutIdTransaction", SqlDbType.Int)).Direction = ParameterDirection.Output;


                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
            }

            catch (Exception myError)
            {
                //Response.Write("<script language=javascript>alert('"+myError.Message.ToString()+"');</"+"script>");
            }

            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
                DetailsView1.DataBind();
                Response.Write("<script language=javascript>alert('Transaction Successfully');</" + "script>");
            }


        }

        protected void ddlPlayer_DataBound(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(Request.QueryString["player"]))
            {
                ddlPlayer.SelectedValue = Request.QueryString["player"];
                ddlPlayer.Enabled = false;
                loadPassword();
            }
        }

        protected DataTable getAgentPaymentRights()
        {

            int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("AddOn_GetAgentPaymentRights", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);

                //lblPassword.Text = table.Rows[0]["Password"].ToString();

            }

            catch (Exception myError)
            {
                //Response.Write("<script language=javascript>alert('"+myError.Message.ToString()+"');</"+"script>");
            }

            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            return table;

        }

        protected void loadPassword()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("AddOn_GetPlayerInfo", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = ddlPlayer.SelectedValue;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
                lblPassword.Text = table.Rows[0]["Password"].ToString();
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

        protected void ddlPlayer_SelectedIndexChanged(object sender, EventArgs e)
        {
            loadPassword();
        }
    }
}
