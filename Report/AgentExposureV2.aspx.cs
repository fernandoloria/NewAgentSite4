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
    public partial class AgentExposureV2  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtDateFrom.Text = DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy");
                txtDateTo.Text = DateTime.Now.ToString("MM/dd/yyyy");
            }

            //
        }

        protected DataTable loadAgentExposure()
        {
            DataTable table = new DataTable();

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();

            try
            {
                DateTime prmDateFrom = Convert.ToDateTime(txtDateFrom.Text);
                DateTime prmDateTo = Convert.ToDateTime(txtDateTo.Text);
                int prmIdAgent = Convert.ToInt32(Session["SubIdAgent"]);
                string prmSport = ddlSports.SelectedValue;

                SqlCommand comm = new SqlCommand("AddOn_Web_Report_Agent_Exposure_History", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmSport", SqlDbType.VarChar)).Value = prmSport;
                ((SqlParameter)comm.Parameters.Add("@prmDateFrom", SqlDbType.DateTime)).Value = prmDateFrom;
                ((SqlParameter)comm.Parameters.Add("@prmDateTo", SqlDbType.DateTime)).Value = prmDateTo;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception myError)
            {
                Response.Write(myError.ToString());
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
        }

        protected string builReport()
        {
            DataTable table = loadAgentExposure();
            table.DefaultView.Sort = "IdGame desc";
            int IdGame = 0;
            string str = "";
            string row = rowExposure();
            foreach (DataRow linea in table.Rows)
            {
                int idGame0 = Convert.ToInt32(linea["IdGame"]);
                if (IdGame == 0) { IdGame = idGame0; }
                if (IdGame != idGame0)
                {
                    row = cleanRowExposure(row);
                    str = str + row;
                    IdGame = idGame0;
                    row = rowExposure();
                }

                row = row.Replace("{idTeamV}", linea["VisitorNumber"].ToString());
                row = row.Replace("{idTeamH}", linea["HomeNumber"].ToString());
                row = row.Replace("{teamV}", linea["VisitorTeam"].ToString());
                row = row.Replace("{teamH}", linea["HomeTeam"].ToString());

                string idGame = linea["idGame"].ToString();



                string result = Convert.ToDecimal(linea["Result"].ToString()).ToString("N2");

                switch (linea["fieldName"].ToString())
                {
                    //Straight
                    case "StraightbetVSpread":
                        row = row.Replace("{StraightbetVSpread}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "SB" + "\",\"" + "0" + "\");'>" + result + "</a>");
                        break;
                    case "StraightbetVTotal":
                        row = row.Replace("{StraightbetVTotal}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "SB" + "\",\"" + "2" + "\");'>" + result + "</a>");
                        break;
                    case "StraightbetVMoney":
                        row = row.Replace("{StraightbetVMoney}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "SB" + "\",\"" + "4" + "\");'>" + result + "</a>");
                        break;
                    case "StraightbetHSpread":
                        row = row.Replace("{StraightbetHSpread}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "SB" + "\",\"" + "1" + "\");'>" + result + "</a>");
                        break;
                    case "StraightbetHTotal":
                        row = row.Replace("{StraightbetHTotal}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "SB" + "\",\"" + "3" + "\");'>" + result + "</a>");
                        break;
                    case "StraightbetHMoney":
                        row = row.Replace("{StraightbetHMoney}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "SB" + "\",\"" + "5" + "\");'>" + result + "</a>");
                        break;
                    case "StraightbetD":
                        row = row.Replace("{StraightbetD}", result);
                        break;

                    //ParlayVSpread
                    case "ParlayVSpread":
                        row = row.Replace("{ParlayVSpread}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "PB" + "\",\"" + "0" + "\");'>" + result + "</a>");
                        break;
                    case "ParlayVTotal":
                        row = row.Replace("{ParlayVTotal}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "PB" + "\",\"" + "2" + "\");'>" + result + "</a>");
                        break;
                    case "ParlayVMoney":
                        row = row.Replace("{ParlayVMoney}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "PB" + "\",\"" + "4" + "\");'>" + result + "</a>");
                        break;
                    case "ParlayHSpread":
                        row = row.Replace("{ParlayHSpread}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "PB" + "\",\"" + "1" + "\");'>" + result + "</a>");
                        break;
                    case "ParlayHTotal":
                        row = row.Replace("{ParlayHTotal}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "PB" + "\",\"" + "3" + "\");'>" + result + "</a>");
                        break;
                    case "ParlayHMoney":
                        row = row.Replace("{ParlayHMoney}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "PB" + "\",\"" + "5" + "\");'>" + result + "</a>");
                        break;
                    case "ParlayD":
                        row = row.Replace("{ParlayD}", result);
                        break;

                    //Teaser
                    case "TeaserVSpread":
                        row = row.Replace("{TeaserVSpread}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "TB" + "\",\"" + "0" + "\");'>" + result + "</a>");
                        break;
                    case "TeaserVTotal":
                        row = row.Replace("{TeaserVTotal}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "TB" + "\",\"" + "2" + "\");'>" + result + "</a>");
                        break;
                    case "TeaserVMoney":
                        row = row.Replace("{TeaserVMoney}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "TB" + "\",\"" + "4" + "\");'>" + result + "</a>");
                        break;
                    case "TeaserHSpread":
                        row = row.Replace("{TeaserHSpread}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "TB" + "\",\"" + "1" + "\");'>" + result + "</a>");
                        break;
                    case "TeaserHTotal":
                        row = row.Replace("{TeaserHTotal}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "TB" + "\",\"" + "3" + "\");'>" + result + "</a>");
                        break;
                    case "TeaserHMoney":
                        row = row.Replace("{TeaserHMoney}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "TB" + "\",\"" + "5" + "\");'>" + result + "</a>");
                        break;
                    case "TeaserD":
                        str =
                        str.Replace("{TeaserD}", result);
                        break;

                    //Reverse
                    case "ReversesVSpread":
                        row = row.Replace("{ReversesVSpread}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "RB" + "\",\"" + "0" + "\");'>" + result + "</a>");
                        break;
                    case "ReversesVTotal":
                        row = row.Replace("{ReversesVTotal}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "RB" + "\",\"" + "2" + "\");'>" + result + "</a>");
                        break;
                    case "ReversesVMoney":
                        row = row.Replace("{ReversesVMoney}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "RB" + "\",\"" + "4" + "\");'>" + result + "</a>");
                        break;
                    case "ReversesHSpread":
                        row = row.Replace("{ReversesHSpread}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "RB" + "\",\"" + "1" + "\");'>" + result + "</a>");
                        break;
                    case "ReversesHTotal":
                        row = row.Replace("{ReversesHTotal}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "RB" + "\",\"" + "3" + "\");'>" + result + "</a>");
                        break;
                    case "ReversesHMoney":
                        row = row.Replace("{ReversesHMoney}", "<a href='javascript:GetExposureDetail(\"" + idGame + "\",\"" + "RB" + "\",\"" + "5" + "\");'>" + result + "</a>");
                        break;
                    case "ReversesD":
                        row = row.Replace("{ReversesD}", result);
                        break;
                }
                IdGame = idGame0;
            }
            if (table.Rows.Count > 0)
            {
                row = cleanRowExposure(row);
                str = str + row;
            }
            return str;

        }

        protected string cleanRowExposure(string row)
        {
            row = row.Replace("{StraightbetVSpread}", "");
            row = row.Replace("{StraightbetVTotal}", "");
            row = row.Replace("{StraightbetVMoney}", "");
            row = row.Replace("{StraightbetHSpread}", "");
            row = row.Replace("{StraightbetHTotal}", "");
            row = row.Replace("{StraightbetHMoney}", "");
            row = row.Replace("{StraightbetD}", "");
            row = row.Replace("{ParlayVSpread}", "");
            row = row.Replace("{ParlayVTotal}", "");
            row = row.Replace("{ParlayVMoney}", "");
            row = row.Replace("{ParlayHSpread}", "");
            row = row.Replace("{ParlayHTotal}", "");
            row = row.Replace("{ParlayHMoney}", "");
            row = row.Replace("{ParlayD}", "");
            row = row.Replace("{TeaserVSpread}", "");
            row = row.Replace("{TeaserVTotal}", "");
            row = row.Replace("{TeaserVMoney}", "");
            row = row.Replace("{TeaserHSpread}", "");
            row = row.Replace("{TeaserHTotal}", "");
            row = row.Replace("{TeaserHMoney}", "");
            row = row.Replace("{TeaserD}", "");
            row = row.Replace("{ReversesVSpread}", "");
            row = row.Replace("{ReversesVTotal}", "");
            row = row.Replace("{ReversesVMoney}", "");
            row = row.Replace("{ReversesHSpread}", "");
            row = row.Replace("{ReversesHTotal}", "");
            row = row.Replace("{ReversesHMoney}", "");
            row = row.Replace("{ReversesD}", "");
            return row;
        }

        protected string rowExposure()
        {
            string str = "<tr class='TrGameOdd'>" +
                          "      <td>{idTeamV}<br>{idTeamH}</td>" +
                          "      <td>{teamV}<br>{teamH}I</td>" +
                          "      <td>" +
                          "      <table border='0' height='48' width='100%'>" +
                          "          <tr class='GameDetailChart'>" +
                          "              <td align='center' height='24' width='33%'>{StraightbetVSpread}</td>" +
                          "              <td align='center' height='24' width='33%'>{StraightbetVTotal}</td>" +
                          "              <td align='center' height='24' width='33%'>{StraightbetVMoney}</td>" +
                          "          </tr>" +
                          "          <tr class='GameDetailChart'>" +
                          "              <td align='center' height='24' width='33%'>{StraightbetHSpread} </td>" +
                          "              <td align='center' height='24' width='33%'>{StraightbetHTotal}</td>" +
                          "              <td align='center' height='24' width='33%'>{StraightbetHMoney}</td>" +
                          "          </tr>" +
                          "      </table>" +
                          "      </td>" +
                          "      <td>" +
                          "      <table border='0' height='48' width='100%'>" +
                          "          <tr class='GameDetailChart'>" +
                          "              <td align='center' height='24' width='33%'>{ParlayVSpread} </td>" +
                          "              <td align='center' height='24' width='33%'>{ParlayVTotal}</td>" +
                          "              <td align='center' height='24' width='33%'>{ParlayVMoney} </td>" +
                          "          </tr>" +
                          "          <tr class='GameDetailChart'>" +
                          "              <td align='center' height='24' width='33%'>{ParlayHSpread}</td>" +
                          "              <td align='center' height='24' width='33%'>{ParlayHTotal}</td>" +
                          "              <td align='center' height='24' width='33%'>{ParlayHMoney}</td>" +
                          "          </tr>" +
                          "      </table>" +
                          "      </td>" +
                          "      <td>" +
                          "      <table border='0' height='48' width='100%'>" +
                          "          <tr class='GameDetailChart'>" +
                          "              <td align='center' height='24' width='33%'>{TeaserVSpread}</td>" +
                          "              <td align='center' height='24' width='33%'>{TeaserVTotal}</td>" +
                          "              <td align='center' height='24' width='33%'>{TeaserVMoney}</td>" +
                          "          </tr>" +
                          "          <tr class='GameDetailChart'>" +
                          "              <td align='center' height='24' width='33%'>{TeaserHSpread}</td>" +
                          "              <td align='center' height='24' width='33%'>{TeaserHTotal}</td>" +
                          "              <td align='center' height='24' width='33%'>{TeaserHMoney}</td>" +
                          "          </tr>" +
                          "      </table>" +
                          "      </td>" +
                          "      <td>" +
                          "      <table border='0' height='48' width='100%'>" +
                          "          <tr class='GameDetailChart'>" +
                          "              <td align='center' height='24' width='33%'>{ReversesVSpread}</td>" +
                          "              <td align='center' height='24' width='33%'>{ReversesVTotal}</td>" +
                          "              <td align='center' height='24' width='33%'>{ReversesVMoney}</td>" +
                          "          </tr>" +
                          "          <tr class='GameDetailChart'>" +
                          "              <td align='center' height='24' width='33%'>{ReversesHSpread}</td>" +
                          "              <td align='center' height='24' width='33%'>{ReversesHTotal}</td>" +
                          "              <td align='center' height='24' width='33%'>{ReversesHMoney}</td>" +
                          "          </tr>" +
                          "      </table>" +
                          "      </td>" +
                          "  </tr>";

            return str;
        }


        protected void btnSumit_Click(object sender, EventArgs e)
        {

        }
    }
}
