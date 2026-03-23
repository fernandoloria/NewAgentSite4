using AgentSite4.cASEnums;
using DGSinterface;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Xml;
using System.Data.SqlClient;
using System.Data;

namespace AgentSite4.Popup
{
    public partial class CancelWagerPopUp : System.Web.UI.Page
    {

        void Page_Load(object sender, System.EventArgs e)
        {

            bool DELETEBETSBEFOREGAME = Security.AgentRights.Has("DELETEBETS");
            bool DELETEBETSANYTIME = Security.AgentRights.Has("DELETEBETSBEFORESTARTTIME");
 
            if (!IsPostBack)
            {
                if (!(DELETEBETSBEFOREGAME || DELETEBETSANYTIME))
                {
                    Response.StatusCode = 403; 
                    Response.End();
                    return;
                }

                loadWager();
            }
        }



        protected void btnDelete_Click(object sender, EventArgs e)
        {
            bool DELETEBETSBEFOREGAME = Security.AgentRights.Has("DELETEBETS");
            bool DELETEBETSANYTIME = Security.AgentRights.Has("DELETEBETSBEFORESTARTTIME");

            if (!(DELETEBETSBEFOREGAME || DELETEBETSANYTIME))
            {
                Response.StatusCode = 403;
                Response.End();
                return;
            }

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            try
            {
                using (SqlConnection cnn = new SqlConnection(DGS_AddOnsConnectionString))
                {
                    cnn.Open();
                    int prmIdAgent = Convert.ToInt32(this.Session["IdAgent"].ToString());
                    int prmSubIdAgent = Convert.ToInt32(this.Session["SubIdAgent"].ToString());
                    int idWager = Convert.ToInt32(Request.QueryString["tn"]);

                    using (SqlCommand comm = new SqlCommand("VoidWager", cnn))
                    {
                        comm.CommandType = CommandType.StoredProcedure;
                        comm.Parameters.Add(new SqlParameter("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                        comm.Parameters.Add(new SqlParameter("@prmIdWager", SqlDbType.Int)).Value = idWager;

                        using (SqlDataReader reader = comm.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                // Uncomment and use this code if you need to show alerts based on the error value.
                                /*
                                if (reader["Error"].ToString() == "0")
                                {
                                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Hello", "alert('Wager was successfully deleted.');", true);
                                }
                                else
                                {
                                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Hello", "alert('System grading, please try again later.');", true);
                                }
                                */
                            }
                            lblError.Text = "Wager Canceled";
                        }
                    }
                }
            }
            catch (Exception err)
            {
                lblError.ForeColor = System.Drawing.Color.Red;
                lblError.Text = err.Message.ToString(); // "Error canceling bet."
            }
            finally
            {
                Response.Clear();
                Response.Write("<script>window.onunload = refreshParent;function refreshParent() {window.opener.location.reload();}window.close();</" + "script>");
                Response.Flush();
                Response.End();
            }

        }


        protected void loadWager()
        {
            try
            {
                string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

                using (SqlConnection cnn = new SqlConnection(DGS_AddOnsConnectionString))
                {
                    cnn.Open();
                    int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
                    int prmSubIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                    int idWager = Convert.ToInt32(Request.QueryString["tn"]);
                    string idSport = Request.QueryString["idsport"] != null ? Request.QueryString["idsport"].ToString() : "";

                    using (SqlCommand comm = new SqlCommand("AddOn_GetPendingBetsByMasterAgentID", cnn))
                    {
                        comm.CommandType = CommandType.StoredProcedure;
                        comm.Parameters.Add(new SqlParameter("@idAgent", SqlDbType.Int)).Value = prmIdAgent;
                        comm.Parameters.Add(new SqlParameter("@idWager", SqlDbType.Int)).Value = idWager;
                        comm.Parameters.Add(new SqlParameter("@idSport", SqlDbType.VarChar)).Value = idSport;

                        using (SqlDataReader reader = comm.ExecuteReader())
                        {
                            lblError.Text = "Pending Wager not Found.";

                            TableRow tRow = new TableRow();
                            tblResult.Rows.Add(tRow);
                            bool firstRow = true;

                            while (reader.Read())
                            {
                                DateTime gameDateTime = DateTime.Parse(reader["GameDateTime"].ToString());
                                DateTime currentDateTime = DateTime.Now;

                                if (gameDateTime <= currentDateTime && Session["DELETEBETSBEFOREGAME"] != null && (bool)Session["DELETEBETSBEFOREGAME"])
                                {
                                    lblError.Text = "Error: This wager has a game already started.";
                                    btnDelete.Enabled = false;
                                    btnDelete.Visible = false;
                                    return;
                                }

                                tRow = new TableRow();
                                tblResult.Rows.Add(tRow); // add row to table

                                TableCell tCell = new TableCell();
                                tCell.Text = reader["IdWager"].ToString().Trim();
                                tRow.Cells.Add(tCell);

                                TableCell tCell1 = new TableCell();
                                tCell1.Text = reader["PLAYER"].ToString().Trim();
                                tRow.Cells.Add(tCell1);

                                TableCell tCell2 = new TableCell();
                                tCell2.Text = firstRow
                                    ? reader["Description"].ToString().Trim() + "<br>" + reader["CompleteDesc"].ToString().Trim()
                                    : reader["CompleteDesc"].ToString().Trim();
                                tRow.Cells.Add(tCell2);

                                TableCell tCell3 = new TableCell();
                                tCell3.Text = reader["PlacedDate"].ToString().Trim();
                                tRow.Cells.Add(tCell3);

                                TableCell tCell4 = new TableCell();
                                tCell4.Text = reader["RiskAmount"].ToString().Trim();
                                tRow.Cells.Add(tCell4);

                                firstRow = false;
                            }

                            lblError.Text = "";
                            btnDelete.Enabled = true;
                        }
                    }
                }
            }
            catch (Exception err)
            {
                lblError.Text = err.Message + " Pending Wager not Found.";
                btnDelete.Enabled = false;
            }
        }

    }

}

