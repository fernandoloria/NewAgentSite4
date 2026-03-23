using AgentSite4.ASP;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AgentSite4.Report
{
    public partial class MenuConfiguration : BasePage, IRequiresSessionState
    {

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            SyncReportsWithDatabase();

        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Save")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[rowIndex];

                int idReport = Convert.ToInt32(((HiddenField)row.FindControl("hdIdReport")).Value);
                int idRight = Convert.ToInt32(((DropDownList)row.FindControl("ddlIdRight")).SelectedValue);
                int idCategory = Convert.ToInt32(((DropDownList)row.FindControl("ddlCategory")).SelectedValue);
                string reportName = ((TextBox)row.FindControl("txtReportName")).Text;
                byte reportOrder = Convert.ToByte(((TextBox)row.FindControl("txtOrder")).Text);
                UpdateAgentMenu(idReport, idRight, idCategory, reportName, reportOrder);
                GridView1.DataBind();
            }

            if (e.CommandName == "CreateAndAssignRight")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[rowIndex];
                int idReport = Convert.ToInt32(((HiddenField)row.FindControl("hdIdReport")).Value);

                string newRightDescription = ((TextBox)row.FindControl("txtNewRight")).Text;
                if (!string.IsNullOrEmpty(newRightDescription))
                {
                    int newRightId = AddRight(newRightDescription);
                    int idCategory = Convert.ToInt32(((DropDownList)row.FindControl("ddlCategory")).SelectedValue);
                    string reportName = ((TextBox)row.FindControl("txtReportName")).Text;
                    byte reportOrder = Convert.ToByte(((TextBox)row.FindControl("txtOrder")).Text);

                    UpdateAgentMenu(idReport, newRightId, idCategory, reportName, reportOrder);

                    // Refresh the GridView to reflect the changes
                    GridView1.DataBind();
                }
            }
        }


        protected void SyncReportsWithDatabase()
        {
            List<string> appReports = loadReportsFromAplication();
            DataTable dbReports = GetAllAgentMenus();

            List<string> dbReportUrls = dbReports.AsEnumerable()
                                                 .Select(row => row["reportURL"].ToString())
                                                 .ToList();

            foreach (string report in appReports)
            {
                string reportUrl = "~/Report/" + report;
                if (!dbReportUrls.Contains(reportUrl))
                {
                    InsertAgentMenu(DBNull.Value, DBNull.Value, report.Replace(".aspx", ""), reportUrl, DBNull.Value);
                }
            }
        }


        protected List<string> loadReportsFromAplication()
        {
            string reportFolderPath = Server.MapPath("~/Report");

            var fileList = Directory.GetFiles(reportFolderPath, "*.aspx")
                .Select(filePath => Path.GetFileName(filePath))
                .Where(fileName => !fileName.Equals("ErrorHandle.aspx", StringComparison.OrdinalIgnoreCase) &&
                                   !fileName.Equals("LockScreen.aspx", StringComparison.OrdinalIgnoreCase) &&
                                   !fileName.Equals("AnotherFile", StringComparison.OrdinalIgnoreCase)
                                   )
                .ToList();

            return fileList;
        }


        public int AddRight(string description)
        {
            int newRightId = 0;

            using (SqlConnection conn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("RIGHTS_Add", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@prmDescription", SqlDbType.VarChar, 30)).Value = description;
                    SqlParameter outIdRightParam = new SqlParameter("@outIdRight", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outIdRightParam);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    if (outIdRightParam.Value != DBNull.Value)
                    {
                        newRightId = (int)outIdRightParam.Value;
                    }
                }
            }

            return newRightId;
        }

        public DataTable GetAllAgentMenus()
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("AgentMenu_GetAll", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            return dt;
        }

        public DataTable GetAllAgentMenuCategories()
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("AgentMenuCategories_GetAll", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            return dt;
        }

        public int InsertAgentMenu(object idRight, object idCategory, string reportName, string reportURL, object reportOrder)
        {
            int idReport = 0;

            using (SqlConnection conn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("AgentMenu_Insert", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@idRight", (idRight == DBNull.Value) ? (object)DBNull.Value : Convert.ToInt32(idRight));
                    cmd.Parameters.AddWithValue("@idCategory", (idCategory == DBNull.Value) ? (object)DBNull.Value : Convert.ToInt32(idCategory));
                    cmd.Parameters.AddWithValue("@reportName", reportName);
                    cmd.Parameters.AddWithValue("@reportURL", reportURL);
                    cmd.Parameters.AddWithValue("@reportOrder", (reportOrder == DBNull.Value) ? (object)DBNull.Value : Convert.ToByte(reportOrder));

                    SqlParameter outIdReport = new SqlParameter("@outIdReport", SqlDbType.Int);
                    outIdReport.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outIdReport);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    idReport = Convert.ToInt32(outIdReport.Value);
                }
            }

            return idReport;
        }

        public void UpdateAgentMenu(int idReport, int idRight, int idCategory, string reportName, byte reportOrder)
        {
            using (SqlConnection conn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("AgentMenu_Update", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@idReport", idReport);
                    cmd.Parameters.AddWithValue("@idRight", idRight);
                    cmd.Parameters.AddWithValue("@idCategory", idCategory);
                    cmd.Parameters.AddWithValue("@reportName", reportName);
                    cmd.Parameters.AddWithValue("@reportOrder", reportOrder);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void btnSaveAll_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow row in GridView1.Rows)
            {
                int idReport = Convert.ToInt32(((HiddenField)row.FindControl("hdIdReport")).Value);
                int idRight = Convert.ToInt32(((DropDownList)row.FindControl("ddlIdRight")).SelectedValue);
                int idCategory = Convert.ToInt32(((DropDownList)row.FindControl("ddlCategory")).SelectedValue);
                string reportName = ((TextBox)row.FindControl("txtReportName")).Text;
                byte reportOrder = Convert.ToByte(((TextBox)row.FindControl("txtOrder")).Text);

                UpdateAgentMenu(idReport, idRight, idCategory, reportName, reportOrder);
            }

            GridView1.DataBind();
        }





    }
}