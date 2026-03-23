using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;
using AgentSite4.cASEnums;

namespace AgentSite4.Report
{
    public partial class SideBarTickets : BasePage, IRequiresSessionState
    {

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;



        protected void Page_Init(object sender, EventArgs e)
        {

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Common.HasRights(ReportPosition.BETTICKER))
            {
                Response.End();
            }

            Response.Write(GetTickets());


        }

        protected string GetTickets()
        {

            DataTable tableTickets = new DataTable();

            if (Session["Agent"] == null)
            {
                Response.Write("no Agent session");
                Response.End();
            }

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                String prmAgent = this.Session["Agent"].ToString();
                SqlCommand comm1 = new SqlCommand("AddOn_BetTicker", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm1.Parameters.Add("@prmAgent", SqlDbType.Char)).Value = prmAgent;


                SqlDataAdapter da = new SqlDataAdapter(comm1);

                da.Fill(tableTickets);

            }
            catch (Exception e)
            {
                Response.Write(e.Message);
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();

            }

            return GetJson(tableTickets);

        }

        internal static string GetJson(DataTable dt)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();

            serializer.MaxJsonLength = Int32.MaxValue;

            List<Dictionary<string, object>> rows =
                new List<Dictionary<string, object>>();
            Dictionary<string, object> row = null;

            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row.Add(col.ColumnName.Trim(), dr[col]);
                }
                rows.Add(row);
            }

            string json = serializer.Serialize(rows);

            //var Result = new string { ContentEncoding = Encoding.UTF8, Content = json };

            //Result.ContentType = "application/json";

            return json;

        }
    }
}
