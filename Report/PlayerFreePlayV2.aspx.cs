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
    public partial class PlayerFreePlayV2  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        int startDay = 0;
        public string endDate = "";
        public string from, to;
        void Page_Load(object sender, System.EventArgs e)
        {
            if (!IsPostBack)
            {
                string dateFrom, dateTo;

                getThisWeek(out dateFrom, out dateTo);
                from = dateFrom;
                to = dateTo;
                //lblDateRange.Text = "Can be only between " + dateFrom + " and " + dateTo;
                VerifyWeeklyFreePlayLimit();
            }
        }

        private void getThisWeek(out string dateFrom, out string dateTo)
        {
            DateTime currentDate = DateTime.Now;
            int endDate = 6;
            switch (currentDate.DayOfWeek)
            {
                case DayOfWeek.Tuesday:
                    startDay = -1;
                    endDate = 5;
                    break;
                case DayOfWeek.Wednesday:
                    startDay = -2;
                    endDate = 4;
                    break;
                case DayOfWeek.Thursday:
                    startDay = -3;
                    endDate = 3;
                    break;
                case DayOfWeek.Friday:
                    startDay = -4;
                    endDate = 2;
                    break;
                case DayOfWeek.Saturday:
                    startDay = -5;
                    endDate = 1;
                    break;
                case DayOfWeek.Sunday:
                    startDay = -6;
                    endDate = 0;
                    break;
            }
            dateFrom = currentDate.AddDays(startDay).ToString("MM-dd-yyyy");
            dateTo = this.endDate = currentDate.AddDays(endDate).ToString("MM-dd-yyyy");

        }

        public void VerifyWeeklyFreePlayLimit()
        {
            bool isAllowed = false;
            decimal availableBalance = 0;
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("WeeklyFreePlayLimit_VerifyLimit_Agent", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = Convert.ToInt32(Session["IdAgent"]);
                cmd.Parameters.Add("@prmCurrentDate", SqlDbType.Date).Value = DateTime.Now;
                cmd.Parameters.Add("@prmFreePlayAmount", SqlDbType.Money).Value = 0;
                cmd.Parameters.Add("@outAllowed", SqlDbType.Bit).Direction = ParameterDirection.Output;
                cmd.Parameters.Add("@outAvailableBalance", SqlDbType.Money).Direction = ParameterDirection.Output;

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    isAllowed = (bool)cmd.Parameters["@outAllowed"].Value;
                    availableBalance = (decimal)cmd.Parameters["@outAvailableBalance"].Value;
                }
                catch (Exception ex)
                {

                }
            }
            if (!isAllowed || availableBalance == 0)
            {
                Response.Redirect("~/Report/NoFreePlayAvailableBalance.aspx");
            }
            if (availableBalance > 0)
            {
                lblAvailableFreePlayBalance.Text = "Available Free Play Balance: " + availableBalance.ToString("N0");
            }

        }
    }
}
