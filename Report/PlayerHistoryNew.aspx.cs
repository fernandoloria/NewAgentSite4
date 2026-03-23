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
using System.Xml.Linq;
using AgentSite4.ASP;

namespace AgentSite4.Report
{
    public partial class PlayerHistoryNew  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Init(object sender, EventArgs e)
        {
            txtInitialDate.Text = fromOrTo(true).ToString("MM/dd/yyyy");
            txtFinalDate.Text = fromOrTo(false).ToString("MM/dd/yyyy");
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                getPlayers();
                loadReport();
            }

        }

        protected void getPlayers()
        {

            int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());

            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            DataTable tableResult = new DataTable();

            try
            {
                SqlCommand comm = new SqlCommand("Web_GetAgentAllPlayers", Cnn);

                comm.CommandTimeout = 120;
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;


                SqlDataReader reader;
                reader = comm.ExecuteReader();
                tableResult.Load(reader);
            }
            catch { }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }


            if (tableResult.Rows.Count > 0)
            {

                ddlPlayer.DataSource = tableResult;
                ddlPlayer.DataTextField = "Player";
                ddlPlayer.DataValueField = "IdPlayer";
                ddlPlayer.DataBind();

                // Add the initial item
                ddlPlayer.Items.Insert(0, new ListItem("ALL", "-1"));
            }

        }

        protected void loadReport()
        {
            gvMaster.DataSource = null;
            gvMaster.DataBind();

            int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
            int prmIdPlayer = int.Parse(ddlPlayer.SelectedValue);
            string prmStartDate = txtInitialDate.Text;
            string prmEndDate = txtFinalDate.Text;
            int prmTranType = int.Parse(ddlTranType.SelectedValue);
            int prmRecsPerPage = 1000;

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable tableResult = new DataTable();

            try
            {
                SqlCommand comm = new SqlCommand("AddOn_Web_Report_Agent_History_BYPageV2", Cnn);

                comm.CommandTimeout = 120;
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = prmIdPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmStartDate", SqlDbType.VarChar)).Value = prmStartDate;
                ((SqlParameter)comm.Parameters.Add("@prmEndDate", SqlDbType.VarChar)).Value = prmEndDate;
                ((SqlParameter)comm.Parameters.Add("@prmTranType", SqlDbType.Int)).Value = prmTranType;
                ((SqlParameter)comm.Parameters.Add("@prmPage", SqlDbType.Int)).Value = 1;
                ((SqlParameter)comm.Parameters.Add("@prmRecsPerPage", SqlDbType.Int)).Value = prmRecsPerPage;
                ((SqlParameter)comm.Parameters.Add("@prmNormalOrder", SqlDbType.Int)).Value = 1;


                SqlDataReader reader;
                reader = comm.ExecuteReader();
                tableResult.Load(reader);
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message);
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }


            if (tableResult.Rows.Count > 0)
            {

                lblRowCount.Text = "Rows: " + tableResult.Rows.Count.ToString();

                if (tableResult.Rows.Count >= prmRecsPerPage)
                {
                    lblRowCount.Text = "Rows: +" + prmRecsPerPage + ". The total search count exceeded the maximum display limit.";
                }

                DataTable dt = new DataTable();
                dt.Columns.Add("Player", typeof(string));
                dt.Columns.Add("User/Phone", typeof(string));
                dt.Columns.Add("Date", typeof(string));
                dt.Columns.Add("Sport", typeof(string));
                dt.Columns.Add("Description", typeof(string));
                dt.Columns.Add("Risk/Win", typeof(string));
                dt.Columns.Add("Amount", typeof(int));
                dt.Columns.Add("Result", typeof(string));
                dt.Columns.Add("Placed", typeof(string));

                int IdPlayerAcc = 0;
                string dateColumn = "";
                string sportColumn = "";
                string resultColumn = "";
                string detailResultColumn = "";

                DataRow newRow = dt.NewRow();

                foreach (DataRow row in tableResult.Rows)
                {

                    sportColumn = "<br>";
                    detailResultColumn = row["DetailResult"].ToString();

                    if (row["TransactionType"].ToString() == "K" || row["Result"].ToString() == "-1")
                    {

                        sportColumn = "";

                    }

                    sportColumn += row["IdSport"].ToString();

                    switch (row["DetailResult"].ToString())
                    {
                        case "1":
                            detailResultColumn = "<span style='font-size:0.85em;color:blue;'>Win</span>";
                            break;
                        case "0":
                            detailResultColumn = "<span style='font-size:0.85em;color:red;'>Lose</span>";
                            break;
                        case "255":
                            detailResultColumn = "<span style='font-size:0.85em;'>Pend</span>";
                            break;
                        case "2":
                            detailResultColumn = "<span style='font-size:0.85em;'>Push</span>";
                            break;
                        case "6":
                            detailResultColumn = "<span style='font-size:0.85em;'>Cancel</span>";
                            break;
                    }


                    if (IdPlayerAcc != int.Parse(row["IdPlayerAcc"].ToString()))
                    {

                        if (IdPlayerAcc != 0) dt.Rows.Add(newRow);

                        dateColumn = (row["idTrans"].ToString() == "-99") ? row["SettledDate"].ToString() : "Ticket #" + row["idTrans"].ToString() + "<br>" + row["GameDateTime"].ToString() + "";

                        switch (row["Result"].ToString())
                        {
                            case "1":
                                resultColumn = "WIN";
                                break;
                            case "0":
                                resultColumn = "LOSE";
                                break;
                            case "2":
                                resultColumn = "PUSH";
                                break;
                            case "3":
                                resultColumn = "CANCEL";
                                break;
                            default:
                                resultColumn = "";
                                break;
                        }


                        newRow = dt.NewRow();
                        newRow["Player"] = row["Player"];
                        newRow["User/Phone"] = row["LoginName"];
                        newRow["Date"] = dateColumn;
                        newRow["Sport"] = sportColumn;
                        newRow["Description"] = row["CompleteDesc"] + "<br>" + row["DetailDesc"] + row["GameDescription"];
                        newRow["Risk/Win"] = (row["RiskAmount"].ToString() == "") ? "" : row["RiskAmount"] + "/" + row["WinAmount"];
                        newRow["Amount"] = row["Amount"];
                        newRow["Result"] = resultColumn + "<br>" + detailResultColumn;
                        newRow["Placed"] = row["PlacedDate"];


                    }
                    else
                    {
                        newRow["Date"] += "<br>" + row["GameDateTime"].ToString();
                        newRow["Sport"] += sportColumn;
                        newRow["Description"] += "<br>" + row["DetailDesc"] + row["GameDescription"];
                        newRow["Result"] += "<br>" + detailResultColumn;
                    }

                    IdPlayerAcc = int.Parse(row["IdPlayerAcc"].ToString());
                }
                dt.Rows.Add(newRow);


                gvMaster.DataSource = dt;
                gvMaster.DataBind();

                // add header
                gvMaster.HeaderRow.TableSection = TableRowSection.TableHeader;

            }
        }

        protected void btnSumit_Click(object sender, EventArgs e)
        {

            loadReport();

        }

        protected void gvMaster_RowDataBound(object sender, GridViewRowEventArgs e)
        {

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[2].Text = Server.HtmlDecode(e.Row.Cells[2].Text);
                e.Row.Cells[3].Text = Server.HtmlDecode(e.Row.Cells[3].Text);
                e.Row.Cells[4].Text = Server.HtmlDecode(e.Row.Cells[4].Text);
                e.Row.Cells[7].Text = Server.HtmlDecode(e.Row.Cells[7].Text);
            }
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
    }
}
