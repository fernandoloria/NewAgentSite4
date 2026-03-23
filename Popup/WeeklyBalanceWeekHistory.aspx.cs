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
    public partial class WeeklyBalanceWeekHistory : System.Web.UI.Page
    {

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["player"]))
            {
                int player = idPlayer(Request.QueryString["player"]);
                Response.Redirect("~/Popup/WeeklyBalanceWeekHistory.aspx?id=" + player.ToString() + "&date=" + Request.QueryString["date"]);

            }

        }
        protected int idPlayer(string player)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            int idPlayer = 0;
            DataTable table = new DataTable();
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("AddOn_GetPlayerByPlayer", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@Player", SqlDbType.VarChar)).Value = player;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception e)
            {
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            if (table.Rows.Count > 0)
            {
                idPlayer = (int)table.Rows[0]["idPlayer"];
            }
            return idPlayer;
        }
    }

}

