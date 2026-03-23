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
    public partial class PlayerPaymentBulkPayment  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtDate.Text = DateTime.Now.ToString("MM/dd/yyy");
            }
            loadValidator();

            if (!canCreateTransactions())
            {
                btnSumit.Visible = false;
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

        protected void addPayment(int idPlayer, string transactionType, int PaymentMethod, decimal amount)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            try
            {
                decimal positive = transactionType == "D" ? -1 : 1;
                SqlCommand comm = new SqlCommand("InsertPlayerTransaction", Cnn);
                comm.CommandType = CommandType.StoredProcedure;


                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = idPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmDescription", SqlDbType.VarChar)).Value = txtDescription.Text;
                ((SqlParameter)comm.Parameters.Add("@prmAmount", SqlDbType.Money)).Value = Convert.ToDecimal(amount) * positive;
                ((SqlParameter)comm.Parameters.Add("@prmReference", SqlDbType.VarChar)).Value = txtReference.Text;
                ((SqlParameter)comm.Parameters.Add("@prmFee", SqlDbType.Money)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmBonus", SqlDbType.Money)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmIdPaymentMethod", SqlDbType.TinyInt)).Value = PaymentMethod;
                ((SqlParameter)comm.Parameters.Add("@prmTransactionType", SqlDbType.Char)).Value = transactionType;
                ((SqlParameter)comm.Parameters.Add("@prmTransactionDate", SqlDbType.DateTime)).Value = txtDate.Text;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 285;
                ((SqlParameter)comm.Parameters.Add("@prmIdAdjustmentType", SqlDbType.TinyInt)).Value = 1;
                ((SqlParameter)comm.Parameters.Add("@prmOutIdTransaction", SqlDbType.Int)).Direction = ParameterDirection.Output;


                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
            }

            catch (Exception myError)
            {
                error.Text = Alert(3, "Transaction Error", "An error has occurred<br /><br />" + myError.Message);
            }

            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
                error.Text = Alert(1, "Transaction Successfully", "Transaction(s) successfully<br /><br />");

                Response.Write("<script language=javascript>alert('Transaction Successfully');</" + "script>");
            }


        }

        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            int row = 1;
            int totalRow = GridView1.Rows.Count;
            foreach (GridViewRow linea in GridView1.Rows)
            {

                DropDownList ddlTransactionType = ((DropDownList)linea.FindControl("ddlTransactionType"));
                Label lblNewBalance = ((Label)linea.FindControl("lblNewBalance"));


                ((TextBox)linea.FindControl("txtAmount")).Attributes.Add("tabindex", row.ToString());
                ((DropDownList)linea.FindControl("ddlPaymentMethod")).Attributes.Add("tabindex", (totalRow + row).ToString());
                ((DropDownList)linea.FindControl("ddlTransactionType")).Attributes.Add("tabindex", ((totalRow * 2) + row).ToString());


                ((TextBox)linea.FindControl("txtAmount")).Attributes.Add("onblur", "calculateNewBalance(" + Convert.ToDecimal(((Label)linea.FindControl("lblCurrentBalance")).Text).ToString() + "," + row + "," + ddlTransactionType.ClientID + "," + lblNewBalance.ClientID + ");");
                ((DropDownList)linea.FindControl("ddlTransactionType")).Attributes.Add("onchange", "calculateNewBalance(" + Convert.ToDecimal(((Label)linea.FindControl("lblCurrentBalance")).Text).ToString() + "," + row + "," + ddlTransactionType.ClientID + "," + lblNewBalance.ClientID + ");");

                linea.Attributes.Add("id", "row_" + row);

                linea.Cells[4].Attributes.Add("id", "cell_" + row);
                row++;
            }

            btnSumit.Attributes.Add("tabindex", ((totalRow * 3) + row).ToString());

        }


        protected void btnSumit_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow linea in GridView1.Rows)
            {
                if (((TextBox)linea.FindControl("txtAmount")).Text != "")
                {
                    int idPlayer = Convert.ToInt32(((HiddenField)linea.FindControl("hdfIdPlayer")).Value);
                    decimal amount = Convert.ToDecimal(((TextBox)linea.FindControl("txtAmount")).Text);
                    string transactionType = ((DropDownList)linea.FindControl("ddlTransactionType")).SelectedValue;
                    int paymentMethod = Convert.ToInt32(((DropDownList)linea.FindControl("ddlPaymentMethod")).SelectedValue);
                    addPayment(idPlayer, transactionType, paymentMethod, amount);
                }
            }
            GridView1.DataBind();
        }


        protected void ddlTransactionType_SelectedIndexChanged(object sender, EventArgs e)
        {
            foreach (GridViewRow linea in GridView1.Rows)
            {
                DropDownList ddl = (DropDownList)linea.FindControl("ddlTransactionType");
                ddl.SelectedValue = ddlTransactionTypeSelect.SelectedValue;

            }
        }

        protected void ddlPaymentMethodSelect_SelectedIndexChanged(object sender, EventArgs e)
        {
            foreach (GridViewRow linea in GridView1.Rows)
            {
                DropDownList ddl = (DropDownList)linea.FindControl("ddlPaymentMethod");
                ddl.SelectedValue = ddlPaymentMethodSelect.SelectedValue;
            }
        }

        protected void btnMakeZeros_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow linea in GridView1.Rows)
            {
                DropDownList ddlPaymentMethod = (DropDownList)linea.FindControl("ddlPaymentMethod");
                DropDownList ddlTransactionType = (DropDownList)linea.FindControl("ddlTransactionType");
                TextBox txtAmount = (TextBox)linea.FindControl("txtAmount");
                Label lblNewBalance = (Label)linea.FindControl("lblNewBalance");

                decimal balance = Convert.ToDecimal(((Label)linea.FindControl("lblCurrentBalance")).Text);
                if (balance < 0)
                {
                    ddlPaymentMethod.SelectedValue = "2";
                    ddlTransactionType.SelectedValue = "R";
                    txtAmount.Text = (balance * -1).ToString();
                    lblNewBalance.Text = "0.00";

                }
                else if (balance > 0)
                {
                    ddlPaymentMethod.SelectedValue = "2";
                    ddlTransactionType.SelectedValue = "D";
                    txtAmount.Text = (balance * 1).ToString();
                    lblNewBalance.Text = "0.00";
                }
            }
            lblError.Text = "If you don't want to pay/receibe to one of this players, please clean the text box of amount, and the payment will be not done.";

        }
    }
}
