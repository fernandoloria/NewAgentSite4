using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.SessionState;

namespace AgentSite4.Report
{
    public partial class DashboardSettings : BasePage, IRequiresSessionState
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                this.BindAll();
                int idAgent = GetIdAgent();
                string cacheKey = "DashboardMenu_" + idAgent.ToString();
                this.Session.Remove(cacheKey);
            }
        }

        private int GetIdAgent()
        {
            object raw = this.Session["idAgent"];
            int id;
            return int.TryParse(Convert.ToString(raw), out id) ? id : 0;
        }

        private void BindAll()
        {
            this.BindGrid();
            this.BindIcons(ddlAddIcon);
            this.BindColorsDefault();
            this.BindReportsDropDown();
        }

        private void BindGrid()
        {
            int idAgent = this.GetIdAgent();

            using (SqlConnection cnn = new SqlConnection(this.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.AgentMenuDashboard_Get", cnn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = idAgent;

                DataTable table = new DataTable();
                cnn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    table.Load(r);
                }

                this.gvButtons.DataSource = table;
                this.gvButtons.DataBind();

                this.ViewState["CurrentReports"] = table;
            }
        }

        private void BindReportsDropDown()
        {
            int idAgent = this.GetIdAgent();

            using (SqlConnection cnn = new SqlConnection(this.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.AgentMenu_Get", cnn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = idAgent;

                DataTable table = new DataTable();
                cnn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    table.Load(r);
                }

                DataView dv = new DataView(table);

                DataTable existing = this.ViewState["CurrentReports"] as DataTable;
                IEnumerable<int> existingIds = Enumerable.Empty<int>();
                if (existing != null)
                {
                    existingIds = existing.AsEnumerable().Select(row => row.Field<int>("idReport"));
                }

                if (existingIds.Any())
                {
                    List<string> idStrings = new List<string>();
                    foreach (int id in existingIds)
                    {
                        idStrings.Add(id.ToString());
                    }

                    string filter = string.Join(",", idStrings.ToArray());
                    dv.RowFilter = "idReport NOT IN (" + filter + ")";
                }

                this.ddlAddReport.DataSource = dv;
                this.ddlAddReport.DataTextField = "reportName";
                this.ddlAddReport.DataValueField = "idReport";
                this.ddlAddReport.DataBind();

                this.ddlAddReport.Items.Insert(0, new ListItem("-- Seleccione --", ""));
            }
        }

        private void BindColorsDefault()
        {
            if (this.ddlAddCss.Items.Count > 0) return;
        }

        private void BindIcons(DropDownList ddl)
        {
            ddl.Items.Clear();

            string basePath = this.Server.MapPath("~/src/fontawesome/duotone/");
            List<string> classes = new List<string>();

            if (Directory.Exists(basePath))
            {
                string[] files = Directory.GetFiles(basePath, "*.svg");
                for (int i = 0; i < files.Length; i++)
                {
                    string name = Path.GetFileNameWithoutExtension(files[i]).Trim();
                    if (name.Length > 0)
                    {
                        string cls = "fa-duotone fa-" + name;
                        classes.Add(cls);
                    }
                }
            }

            if (classes.Count == 0)
            {
                classes.Add("fa-solid fa-file");
                classes.Add("fa-solid fa-gauge");
                classes.Add("fa-solid fa-user");
            }

            for (int i = 0; i < classes.Count; i++)
            {
                string value = classes[i];
                string text = value;

                if (text.StartsWith("fa-duotone fa-", StringComparison.OrdinalIgnoreCase))
                    text = text.Substring("fa-duotone fa-".Length);
                else if (text.StartsWith("fa-solid fa-", StringComparison.OrdinalIgnoreCase))
                    text = text.Substring("fa-solid fa-".Length);
                else if (text.StartsWith("fa-regular fa-", StringComparison.OrdinalIgnoreCase))
                    text = text.Substring("fa-regular fa-".Length);
                else if (text.StartsWith("fa-brands fa-", StringComparison.OrdinalIgnoreCase))
                    text = text.Substring("fa-brands fa-".Length);

                if (text.StartsWith("fa-", StringComparison.OrdinalIgnoreCase))
                    text = text.Substring(3);

                text = text.Replace('-', ' ').Trim();

                ddl.Items.Add(new System.Web.UI.WebControls.ListItem(text, value));
            }


            if (ddl == this.ddlAddIcon && ddl.Items.Count > 0)
            {
                this.icoAddPreview.Attributes["class"] = ddl.SelectedValue + " fa-2xl";
            }
        }

        protected void gvButtons_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && (e.Row.RowState & DataControlRowState.Edit) == DataControlRowState.Edit)
            {
                DropDownList ddlIconEdit = e.Row.FindControl("ddlIconEdit") as DropDownList;
                DropDownList ddlCssEdit = e.Row.FindControl("ddlCssEdit") as DropDownList;

                if (ddlIconEdit != null)
                {
                    this.BindIcons(ddlIconEdit);
                    object icon = DataBinder.Eval(e.Row.DataItem, "icon");
                    ListItem li = ddlIconEdit.Items.FindByValue(Convert.ToString(icon));
                    if (li != null) ddlIconEdit.ClearSelection();
                    if (li != null) li.Selected = true;
                }

                if (ddlCssEdit != null)
                {
                    object css = DataBinder.Eval(e.Row.DataItem, "css");
                    ListItem li = ddlCssEdit.Items.FindByValue(Convert.ToString(css));
                    if (li != null) ddlCssEdit.ClearSelection();
                    if (li != null) li.Selected = true;
                }

                System.Web.UI.HtmlControls.HtmlGenericControl icoPrev = e.Row.FindControl("icoEditPreview") as System.Web.UI.HtmlControls.HtmlGenericControl;
                if (icoPrev != null && ddlIconEdit != null)
                {
                    icoPrev.Attributes["class"] = ddlIconEdit.SelectedValue;
                }
            }
        }

        protected void gvButtons_RowEditing(object sender, GridViewEditEventArgs e)
        {
            this.gvButtons.EditIndex = e.NewEditIndex;
            this.BindGrid();
        }

        protected void gvButtons_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            this.gvButtons.EditIndex = -1;
            this.BindGrid();
        }

        protected void gvButtons_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int idReport = Convert.ToInt32(this.gvButtons.DataKeys[e.RowIndex].Value);

            GridViewRow row = this.gvButtons.Rows[e.RowIndex];
            DropDownList ddlCssEdit = row.FindControl("ddlCssEdit") as DropDownList;
            DropDownList ddlIconEdit = row.FindControl("ddlIconEdit") as DropDownList;
            TextBox txtOrderEdit = row.FindControl("txtOrderEdit") as TextBox;

            string css = ddlCssEdit != null ? ddlCssEdit.SelectedValue : "bg-primary";
            string icon = ddlIconEdit != null ? ddlIconEdit.SelectedValue : "fa-solid fa-file";

            int order = 0;
            int.TryParse(txtOrderEdit != null ? txtOrderEdit.Text : "0", out order);

            this.UpsertButton(idReport, css, icon, order);

            this.gvButtons.EditIndex = -1;
            this.BindGrid();
            this.BindReportsDropDown();
        }

        protected void gvButtons_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int idReport = Convert.ToInt32(this.gvButtons.DataKeys[e.RowIndex].Value);
            this.DeleteButton(idReport);
            this.BindGrid();
            this.BindReportsDropDown();
        }


        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(this.ddlAddReport.SelectedValue))
                return;

            int idReport = Convert.ToInt32(this.ddlAddReport.SelectedValue);
            string css = this.ddlAddCss.SelectedValue;
            string icon = this.ddlAddIcon.SelectedValue;

            int order = 0;
            int.TryParse(this.txtAddOrder.Text, out order);

            this.UpsertButton(idReport, css, icon, order);

            this.txtAddOrder.Text = string.Empty;
            this.BindGrid();
            this.BindReportsDropDown();
        }


        private void UpsertButton(int idReport, string css, string icon, int order)
        {
            int idAgent = this.GetIdAgent();
            SqlConnection cnn = null;
            SqlCommand cmd = null;

            try
            {
                cnn = new SqlConnection(this.ConnectionString);
                cmd = new SqlCommand("dbo.AgentMenuDashboard_Insert", cnn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = idAgent;
                cmd.Parameters.Add("@prmIdReport", SqlDbType.Int).Value = idReport;
                cmd.Parameters.Add("@prmCss", SqlDbType.VarChar, 128).Value = css ?? "bg-primary";
                cmd.Parameters.Add("@prmIcon", SqlDbType.VarChar, 128).Value = icon ?? "fa-solid fa-file";
                cmd.Parameters.Add("@prmReportOrder", SqlDbType.Int).Value = order;

                cnn.Open();
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                if (cmd != null)
                    cmd.Dispose();

                if (cnn != null)
                {
                    if (cnn.State == ConnectionState.Open)
                        cnn.Close();

                    cnn.Dispose();
                }
            }
        }


        private void DeleteButton(int idReport)
        {
            int idAgent = this.GetIdAgent();

            using (SqlConnection cnn = new SqlConnection(this.ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.AgentMenuDashboard_Delete", cnn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = idAgent;
                cmd.Parameters.Add("@idReport", SqlDbType.Int).Value = idReport;

                cnn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}