using AgentSite4.cASEnums;
using DGSinterface;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Xml;

namespace AgentSite4.Popup
{
    public partial class OpenBetsPop : System.Web.UI.Page
    {
        public static string connString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
        public string IdPlayer = "-1";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["IdPlayer"] != null)
            {
                IdPlayer = Request.QueryString["IdPlayer"];
            }

            if (!IsPostBack)
            {
                GenerateReport();
            }
        }

        protected bool verifiedAgent()
        {
            return (Session["DELETE BETS BEFORE GAME"] != null && (bool)Session["DELETE BETS BEFORE GAME"]) ||
                   (Session["DELETE BETS ANY TIME"] != null && (bool)Session["DELETE BETS ANY TIME"]);
        }

        private void GenerateReport()
        {
            StringBuilder reportContent = new StringBuilder();

            int page = 0;
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            using (SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString))
            {
                int maxPage = 0;
                try
                {
                    Cnn.Open();
                    int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());
                    int idWagerType = -1;
                    string idSport = "All";
                    int placedDate = 0;

                    int SelectedPage = 1;

                    using (SqlCommand comm1 = new SqlCommand("AddOn_AgentPlayerOpenBetsByDate", Cnn))
                    {
                        comm1.CommandType = CommandType.StoredProcedure;

                        comm1.Parameters.Add("@IdAgent", SqlDbType.Int).Value = prmIdAgent;
                        comm1.Parameters.Add("@IdPlayer", SqlDbType.Int).Value = IdPlayer;
                        comm1.Parameters.Add("@WagerType", SqlDbType.Int).Value = idWagerType;
                        comm1.Parameters.Add("@IdSport", SqlDbType.VarChar).Value = idSport;
                        comm1.Parameters.Add("@Page", SqlDbType.Int).Value = SelectedPage;
                        comm1.Parameters.Add("@RecsPerPage", SqlDbType.Int).Value = 999999999;
                        comm1.Parameters.Add("@dateFrom", SqlDbType.DateTime).Value = "01/01/1999";
                        comm1.Parameters.Add("@dateTo", SqlDbType.DateTime).Value = "01/01/2100";
                        comm1.Parameters.Add("@Player", SqlDbType.VarChar).Value = "";
                        comm1.Parameters.Add("@PlacedDate", SqlDbType.Int).Value = placedDate;

                        using (SqlDataReader reader = comm1.ExecuteReader())
                        {
                            string player = "";
                            int row = 0;

                            while (reader.Read())
                            {
                                page++;
                                maxPage++;
                                if (player != reader["idPlayer"].ToString())
                                {
                                    if (row > 0)
                                    {
                                        reportContent.Append("</table> <input type=\"button\"  value=\"Close\" onclick=\"window.close();\" class=\"btn btn-warning\" />");
                                    }

                                    reportContent.AppendFormat(@"
                                        <h4 class=""card-title""></h4>
                                        <table class=""tblWeeklyBalance table color-table success-table table-bordered  table-sm table-responsive"">
                                            <thead>
                                                <tr class=""GameHeader"">
                                                    <th colspan=""6"">{0}/{1} ({2})</th>
                                                </tr>
                                                <tr>
                                                    <th class=""ticket"">Placed</th>
                                                    <th class=""user"">User</th>
                                                    <th class=""gamedate"">Game Date</th>
                                                    <th class=""sport"">Sport</th>
                                                    <th class=""description"">Description</th>
                                                    <th class=""riskwin"">Risk/Win</th>", reader["idPlayer"], reader["Password"], reader["Agent"]);

                                    if (verifiedAgent())
                                    {
                                        reportContent.Append("<th class=\"delete\">Delete</th>");
                                    }

                                    reportContent.Append("</tr></thead><tbody>");
                                }

                                string DGSDATAConnectionStringWagerDetail = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
                                using (SqlConnection CnnWagerDetail = new SqlConnection(DGSDATAConnectionStringWagerDetail))
                                {
                                    CnnWagerDetail.Open();
                                    int prmIdIdWager = int.Parse(reader["TicketNumber"].ToString());
                                    using (SqlCommand commWagerDetail = new SqlCommand("WebGetWagerDetail", CnnWagerDetail))
                                    {
                                        commWagerDetail.CommandType = CommandType.StoredProcedure;
                                        commWagerDetail.Parameters.Add("@IdWager", SqlDbType.Int).Value = prmIdIdWager;

                                        using (SqlDataReader readerWagerDetail = commWagerDetail.ExecuteReader())
                                        {
                                            DataTable table = new DataTable();
                                            table.Load(readerWagerDetail);

                                            reportContent.AppendFormat(@"
                                                <tr>
                                                    <td>{0}<br />{1}</td>
                                                    <td>{2}</td>
                                                    <td>", reader["TicketNumber"], reader["PlacedDate"], reader["Name"]);

                                            foreach (DataRow line in table.Rows)
                                            {
                                                reportContent.AppendFormat("<br />{0}", Convert.ToDateTime(line["GameDate"]).ToString("MMM dd yyyy hh:mmtt"));
                                            }

                                            reportContent.Append("</td><td><br />");

                                            if (table.Rows.Count == 0)
                                            {
                                                reportContent.Append(reader["IdSport"].ToString());
                                            }
                                            foreach (DataRow line in table.Rows)
                                            {
                                                reportContent.AppendFormat("<br />{0}", line["GameSport"]);
                                            }

                                            reportContent.AppendFormat("</td><td style=\"text-align: center;\">{0}<br />", reader["CompleteDescription"]);
                                            if (reader["IdSport"].ToString() == "RAC")
                                            {
                                                reportContent.Append(reader["Description"]);
                                            }

                                            foreach (DataRow line in table.Rows)
                                            {
                                                reportContent.AppendFormat("<br />{0}", line["CompleteDescription"]);
                                            }

                                            reportContent.AppendFormat("</td><td>{0}</td>", reader["riskWin"]);

                                            if (verifiedAgent())
                                            {
                                                string str = $"javascript:CancelWagerPopup({reader["TicketNumber"]},'{reader["IdSport"]}');";
                                                reportContent.AppendFormat("<td><a href=\"{0}\" class=\"btn btn-danger\"><i class=\"fa fa-times\" aria-hidden=\"true\"></i></a></td>", str);
                                            }

                                            reportContent.Append("</tr>");
                                        }
                                    }
                                }

                                player = reader["idPlayer"].ToString();
                                row++;
                            }

                            reportContent.Append("</tbody><tfoot><tr><td colspan=\"6\" style=\"text-align: center;\"><input type=\"button\" class=\"btn btn-secondary\" value=\"Close\" data-bs-dismiss=\"modal\" /></td></tr></tfoot></table>");

                        }
                    }
                }
                catch (Exception ex)
                {
                    // Handle exceptions
                }
                finally
                {
                    if (Cnn.State == ConnectionState.Open) Cnn.Close();
                }
            }

            ltReportContent.Text = reportContent.ToString();
        }
    }
}
