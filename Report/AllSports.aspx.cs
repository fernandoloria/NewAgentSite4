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
    public partial class AllSports  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Init(object sender, EventArgs e)
        {
            txtDate.Text = fromOrTo(true).ToString("MM/dd/yyyy");
        }

        protected void Page_Load(object sender, EventArgs e)
        {


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

        protected string GetWeekHeader()
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            string datestr = "";
            try
            {
                DateTime prmDateWeek = Convert.ToDateTime(txtDate.Text);

                SqlCommand comm = new SqlCommand("WebGetWeeklyHeaders", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@DateWeek", SqlDbType.DateTime)).Value = prmDateWeek;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
                DataRow linea = table.Rows[0];
                linea = table.Rows[0];
                DateTime from = Convert.ToDateTime(linea["StartDate"]);
                DateTime to = Convert.ToDateTime(linea["EndDate"]);
                datestr = from.ToString("MM/dd/yyyy") + " To " + to.ToString("MM/dd/yyyy");
            }
            catch { }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return datestr;
        }


        protected void lnkThisWeek_Click(object sender, EventArgs e)
        {
            changeDate(0);

        }

        protected void lnkLastWeek_Click(object sender, EventArgs e)
        {
            changeDate(1);
        }

        protected void lnk2Weeks_Click(object sender, EventArgs e)
        {
            changeDate(2);
        }

        protected void changeDate(int weeks)
        {
            DateTime today = DateTime.Now;
            int minusDay = 0;
            switch (today.DayOfWeek)
            {
                case DayOfWeek.Monday:
                    minusDay = 0;
                    break;
                case DayOfWeek.Tuesday:
                    minusDay = -1;
                    break;
                case DayOfWeek.Wednesday:
                    minusDay = -2;
                    break;
                case DayOfWeek.Thursday:
                    minusDay = -3;
                    break;
                case DayOfWeek.Friday:
                    minusDay = -4;
                    break;
                case DayOfWeek.Saturday:
                    minusDay = -5;
                    break;
                case DayOfWeek.Sunday:
                    minusDay = -6;
                    break;
            }
            DateTime monday = today.AddDays(minusDay);
            int minusWeeks = -7 * weeks;
            DateTime week = monday.AddDays(minusWeeks);

            txtDate.Text = week.ToString("MM/dd/yyyy");
        }


        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "btnSave")
            {
                string DGS_AddOnsTESTConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
                SqlConnection Cnn = new SqlConnection(DGS_AddOnsTESTConnectionString);
                Cnn.Open();

                try
                {
                    int indexGrid = Convert.ToInt32(e.CommandArgument);
                    GridViewRow GridViewR = GridView1.Rows[indexGrid];

                    string agent = GridViewR.Cells[0].Text;
                    string password = ((TextBox)GridViewR.Cells[1].FindControl("TextBox1")).Text;
                    string email = ((TextBox)GridViewR.Cells[2].FindControl("TextBox2")).Text;
                    bool enableTicketAlert = ((CheckBox)GridViewR.Cells[4].FindControl("CheckBox2")).Checked;
                    string emailTicketAlert = ((TextBox)GridViewR.Cells[5].FindControl("TextBox3")).Text;
                    string riskAmount = ((TextBox)GridViewR.Cells[6].FindControl("TextBox5")).Text;
                    string winAmount = ((TextBox)GridViewR.Cells[7].FindControl("TextBox4")).Text;
                    bool enable = ((CheckBox)GridViewR.Cells[8].FindControl("CheckBox1")).Checked;


                    SqlCommand comm = new SqlCommand("AgentManagmentUpdate", Cnn);
                    comm.CommandType = CommandType.StoredProcedure;

                    ((SqlParameter)comm.Parameters.Add("@Agent", SqlDbType.VarChar)).Value = agent;
                    ((SqlParameter)comm.Parameters.Add("@password", SqlDbType.VarChar)).Value = password;
                    ((SqlParameter)comm.Parameters.Add("@email", SqlDbType.VarChar)).Value = email;
                    ((SqlParameter)comm.Parameters.Add("@enableTicketAlert", SqlDbType.Bit)).Value = enableTicketAlert;
                    ((SqlParameter)comm.Parameters.Add("@emailTicketAlert", SqlDbType.VarChar)).Value = emailTicketAlert;
                    ((SqlParameter)comm.Parameters.Add("@RiskAmount", SqlDbType.Float)).Value = riskAmount;
                    ((SqlParameter)comm.Parameters.Add("@WinAmount", SqlDbType.Float)).Value = winAmount;
                    ((SqlParameter)comm.Parameters.Add("@enable", SqlDbType.Bit)).Value = enable;

                    SqlDataReader reader;
                    reader = comm.ExecuteReader();

                }
                catch (Exception myErr)
                {
                    //lblError.Text = "Agent can't be added, plase try later";
                    //lblError.Text = myErr.Message;
                }
                finally
                {
                    if (Cnn.State == ConnectionState.Open) Cnn.Close();
                }

            }
        }




        public void AddNewRow(object sender, GridViewRowEventArgs e)
        {
            //GridView GridView1 = (GridView)sender;
            //GridViewRow NewTotalRow = new GridViewRow(0, 0, DataControlRowType.DataRow, DataControlRowState.Insert);
            //NewTotalRow.Font.Bold = true;
            //NewTotalRow.BackColor = System.Drawing.Color.Aqua;
            //TableCell HeaderCell = new TableCell();
            //HeaderCell.Height = 10;
            //HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            //HeaderCell.ColumnSpan = GridView1.Columns.Count;
            //NewTotalRow.Cells.Add(HeaderCell);
            //GridView1.Controls[0].Controls.AddAt(e.Row.RowIndex + rowIndex, NewTotalRow);
            //GridView1.DataBind();
        }

        protected void txtDate_TextChanged(object sender, EventArgs e)
        {

        }

        protected void ddlSports_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            if (GridView1.Rows.Count < 1)
            {
                lblError.Text = "This Agent has no players";
            }
            else
            {
                lblError.Text = "";
            }

            try
            {
                GridView1.HeaderRow.Visible = false;
            }
            catch { }

            foreach (GridViewRow r in GridView1.Rows)
            {
                if (r.Cells[0].Text == "0")
                {
                    string AgentName = "<div class='portlet-title'><h4>" + r.Cells[1].Text + "</h4></div>" +
                    "<tr class='GameHeader'><th scope='col'>Player</th><th scope='col'>Password</th><th scope='col'>CreditLimit</th><th scope='col'>Current Balance</th><th scope='col'>Sports & Casino</th><th scope='col'>Horses</th><th scope='col'>Total</th></tr>";

                    r.Cells[1].Text = AgentName;
                    r.Cells[1].ColumnSpan = GridView1.Columns.Count;
                    // r.Cells[1].CssClass = "portlet-title";

                    r.Cells[0].Visible = false;
                    r.Cells[2].Visible = false;
                    r.Cells[3].Visible = false;
                    r.Cells[4].Visible = false;
                    r.Cells[5].Visible = false;
                    r.Cells[6].Visible = false;
                    r.Cells[7].Visible = false;


                }
                else
                {
                    r.Cells[0].Visible = false;
                }
            }


        }
    }
}
