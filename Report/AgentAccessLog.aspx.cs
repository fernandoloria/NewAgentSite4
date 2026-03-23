using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;
using System.Web.Profile;
using System.Web.SessionState;

namespace AgentSite4.Report
{
    public partial class AgentAccessLog : BasePage, IRequiresSessionState
    {
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;
        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected DateTime from { get; set; }
        protected DateTime to { get; set; }
        protected void Page_Init(object sender, EventArgs e)
        {
            from = fromOrTo(true);
            to = fromOrTo(false);
            txtFrom.Text = from.ToString("yyyy-MM-dd");
            txtTo.Text = to.ToString("yyyy-MM-dd");

            SqlDataSource1.SelectParameters[1].DefaultValue = from.ToString("yyyy-MM-dd");
            SqlDataSource1.SelectParameters[2].DefaultValue = to.ToString("yyyy-MM-dd");

            loadDdlAgent();

        }

        protected void loadDdlAgent()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                int prmIdAgent = int.Parse(this.Session["IdAgent"].ToString());

                SqlCommand comm1 = new SqlCommand("Agent_GetAgentsByDistributor", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm1.Parameters.Add("@idAgent", SqlDbType.Int)).Value = prmIdAgent;
                SqlDataReader reader;
                reader = comm1.ExecuteReader();

                ListItem newItem = new ListItem();

                newItem = new ListItem();
                newItem.Value = "-1";
                newItem.Text = "All";
                ddlAgent.Items.Add(newItem);

                while (reader.Read())
                {
                    newItem = new ListItem();
                    newItem.Value = reader["idAgent"].ToString();
                    newItem.Text = reader["Agent"].ToString();
                    ddlAgent.Items.Add(newItem);
                }

            }
            catch (Exception e)
            {
                //lblError.Text = e.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
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

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            //HtmlControl control = (HtmlControl)this
            //GetPropValue(htm, "Date1");
            string date1 = Request.Form["Date1"];
            string date2 = Request.Form["Date2"];


        }

        protected object GetPropValue(object src, string propName)
        {
            return src.GetType().GetProperty(propName).GetValue(src, null);
        }
    }
}