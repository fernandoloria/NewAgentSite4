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
    public partial class AgentPayment  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtDate.Text = DateTime.Now.ToString("MM/dd/yyyy");
            }

        }

        protected void ddlTransactionType_SelectedIndexChanged(object sender, EventArgs e)
        {

            lblAgent1.Text = "Statistics " + ddlAgent.SelectedItem.ToString();
            lblAgent2.Text = "";
            CheckBox1.Visible = false;
            switch (ddlTransactionType.SelectedValue)
            {
                case "A":
                    ddlPaymentMethod.Enabled = false;
                    ddlAgentTo.Enabled = false;
                    DetailsView2.Visible = false;
                    break;
                case "R":
                    ddlPaymentMethod.Enabled = true;
                    ddlAgentTo.Enabled = false;
                    DetailsView2.Visible = false;
                    break;
                case "D":
                    ddlPaymentMethod.Enabled = true;
                    ddlAgentTo.Enabled = false;
                    DetailsView2.Visible = false;
                    break;
                case "T":
                    ddlPaymentMethod.Enabled = false;
                    ddlAgentTo.Enabled = true;
                    DetailsView2.Visible = true;
                    CheckBox1.Visible = true;
                    lblAgent2.Text = "Statistics " + ddlAgentTo.SelectedItem.ToString();
                    break;
            }
            buildDescription();
        }

        protected void buildPopUp()
        {
            lblAmount2.Visible = true;
            lblNewBalance2.Visible = true;
            lblOldBalance2.Visible = true;
            lblAgent4.Visible = true;
            lblNewBalancelbl2.Visible = true;
            lblamountlbl1.Visible = true;
            lblOldBalancelbl1.Visible = true;

            if (txtAmount.Text == "") { return; }
            decimal old1 = Convert.ToDecimal(DetailsView1.Rows[0].Cells[1].Text);
            decimal amount = Convert.ToDecimal(txtAmount.Text.Trim());
            decimal old2 = 0.00M;
            decimal newBalance1 = 0.00M;
            decimal newBalance2 = 0.00M;

            if (ddlTransactionType.SelectedValue == "T")
            {
                //Transfer
                amount = -1 * amount;
            }
            else
            {
                //NOT Transfer
                lblAmount2.Visible = false;
                lblNewBalance2.Visible = false;
                lblOldBalance2.Visible = false;
                lblAgent4.Visible = false;
                lblNewBalancelbl2.Visible = false;
                lblamountlbl1.Visible = false;
                lblOldBalancelbl1.Visible = false;
            }

            if (ddlTransactionType.SelectedValue == "D")
            {
                //Transfer
                amount = -1 * amount;
            }
            try
            {
                old2 = Convert.ToDecimal(DetailsView2.Rows[0].Cells[1].Text);
            }
            catch { }

            newBalance1 = old1 + amount;
            newBalance2 = old2 + amount;

            lblOldBalance1.Text = old1.ToString("N2");
            lblOldBalance2.Text = old2.ToString("N2");
            lblAmount1.Text = amount.ToString("N2");
            lblAmount2.Text = (-1 * amount).ToString("N2");
            lblNewBalance1.Text = newBalance1.ToString("N2");
            lblNewBalance2.Text = newBalance2.ToString("N2");

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            buildPopUp();
            Page.ClientScript.RegisterStartupScript(this.GetType(), "Call my function", "showpopup();", true);
            //ProcessTransaction();
        }




        protected void ProcessTransaction()
        {

            decimal amount = Convert.ToDecimal(txtAmount.Text);
            int agent = Convert.ToInt32(ddlAgent.SelectedValue);

            if (ddlTransactionType.SelectedValue == "T")
            {
                agent = CheckBox1.Checked ? Convert.ToInt32(Session["idAgent"]) : agent;
            }

            switch (ddlTransactionType.SelectedValue)
            {
                case "A": //Ajustment
                    InsertAgentTransaction(agent, amount);
                    break;
                case "R": //Recieve
                    InsertAgentTransaction(agent, amount);
                    break;
                case "D": //Disburtment
                    InsertAgentTransaction(agent, -amount);
                    break;
                case "T"://Transfer
                    InsertAgentTransaction(agent, -amount);
                    InsertAgentTransaction(Convert.ToInt32(ddlAgentTo.SelectedValue), amount);
                    break;
            }
        }

        protected void InsertAgentTransaction(int idAgent, decimal amount)
        {

            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                DateTime prmDateWeek = Convert.ToDateTime(txtDate.Text);
                int prmIdAgent = idAgent;
                string prmDescription = txtDescription.Text;
                decimal prmAmount = amount;
                string prmReference = txtReference.Text;
                string prmTransactionType = ddlTransactionType.SelectedValue;
                DateTime prmTransactionDate = Convert.ToDateTime(txtDate.Text);
                string prmPaymentMethod = ddlPaymentMethod.SelectedValue;
                int prmIdUser = 181;

                SqlCommand comm = new SqlCommand("InsertAgentTransaction", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmDescription", SqlDbType.VarChar)).Value = prmDescription;
                ((SqlParameter)comm.Parameters.Add("@prmAmount", SqlDbType.Money)).Value = prmAmount;
                ((SqlParameter)comm.Parameters.Add("@prmReference", SqlDbType.VarChar)).Value = prmReference;
                ((SqlParameter)comm.Parameters.Add("@prmTransactionType", SqlDbType.Char)).Value = prmTransactionType;
                ((SqlParameter)comm.Parameters.Add("@prmTransactionDate", SqlDbType.DateTime)).Value = prmTransactionDate;
                ((SqlParameter)comm.Parameters.Add("@prmPaymentMethod", SqlDbType.Int)).Value = prmPaymentMethod;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = prmIdUser;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }

            catch (Exception myError)
            {
                lblAgent1.Text = myError.Message.ToString();
            }

            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
                DetailsView1.DataBind();
                DetailsView2.DataBind();
            }

        }


        protected void ddlAgent_TextChanged(object sender, EventArgs e)
        {
            buildDescription();
        }

        protected void ddlAgentTo_SelectedIndexChanged(object sender, EventArgs e)
        {
            buildDescription();
            lblAgent2.Text = "Statistics " + ddlAgentTo.SelectedItem.ToString();

        }

        protected void buildDescription()
        {

            switch (ddlTransactionType.SelectedValue)
            {
                case "A": //Ajustment
                    txtDescription.Text = "";
                    break;
                case "R": //Recieve
                    txtDescription.Text = "";
                    break;
                case "D": //Disburtment
                    txtDescription.Text = "DISBURSEMENT";
                    break;
                case "T"://Transfer
                    string agent = CheckBox1.Checked ? "MASTER" : ddlAgent.SelectedItem.ToString();
                    txtDescription.Text = agent + " TO/FROM " + ddlAgentTo.SelectedItem;
                    break;
            }
        }

        protected void ddlAgent_DataBound(object sender, EventArgs e)
        {
            try
            {
                lblAgent1.Text = "Statistics " + ddlAgent.SelectedItem.ToString();
                //string subId = Session["SubIdAgent"].ToString();
                //ListItem item = ddlAgent.Items.FindByValue(subId);
                //ddlAgent.Items.Remove(item);

                if (ddlAgent.Items.Count == 0)
                {
                    pnForm.Visible = false;
                    pnNotAcces.Visible = true;
                }
                else
                {
                    pnNotAcces.Visible = false;
                }

                DetailsView1.DataBind();

            }
            catch { }
        }

        protected void ddlAgentTo_DataBound(object sender, EventArgs e)
        {
            ListItem item = ddlAgentTo.Items.FindByValue(Session["SubIdAgent"].ToString());
            ddlAgentTo.Items.Remove(item);
        }

        protected void ddlAgent_SelectedIndexChanged(object sender, EventArgs e)
        {
            buildDescription();
            lblAgent1.Text = "Statistics " + ddlAgent.SelectedItem.ToString();

        }

        protected void txtAmount_TextChanged(object sender, EventArgs e)
        {
            buildPopUp();
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            ProcessTransaction();
        }

        protected void Button3_Click(object sender, EventArgs e)
        {
            ProcessTransaction();
        }


        protected void ddlTransactionType_DataBound(object sender, EventArgs e)
        {

        }

        protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
        {
            buildDescription();
            ddlAgent.Enabled = !CheckBox1.Checked;

            if (CheckBox1.Checked)
            {
                string idAgent = Session["idAgent"].ToString();
                Parameter parameter = new Parameter("IdAgent", System.TypeCode.Int32, idAgent);
                SqlDataSource3.SelectParameters["IdAgent"] = parameter;// .Parameters["@City"].Value
            }
            else
            {
                ControlParameter cp = new ControlParameter("idAgent", TypeCode.Int32, "ddlAgent", "SelectedValue");
                SqlDataSource3.SelectParameters["IdAgent"] = cp;

            }
        }
    }
}
