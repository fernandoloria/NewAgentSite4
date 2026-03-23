using AgentSite4.ASP;
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

namespace AgentSite4.Report
{
    public partial class SharpAnalysis : BasePage, IRequiresSessionState
    {

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Init(object sender, EventArgs e)
        {
            DateTime from = DateTime.Now.AddDays(-1);
            DateTime to = from;

            txtDateFrom.Text = from.ToString("MM/dd/yyyy");
            txtDateTo.Text = to.ToString("MM/dd/yyyy");
        }

        protected void Page_Load(object sender, EventArgs e)
        {


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
            CreateReport();
        }

        protected void CreateReport()
        {
            //PnGrids.Controls.Clear();

            int selected_agentID = (ddlAgent.SelectedValue == "") ? 1 : Convert.ToInt32(ddlAgent.SelectedValue);
            string agent = ddlAgent.SelectedItem.Text;
            DataTable report = getReport(selected_agentID);
            if (report.Rows.Count > 0)
            {
                Literal header = new Literal();
                Literal br = new Literal();
                header.Text = "<table style='width: 100%;' cellspacing='0' cellpadding='3' border='0' class='filter table-bordered' align='center'><tbody><tr class='page-titles'><td colspan='15'><h4>" + agent + "</h4></td></tr></tbody></table><div class=\"table-responsive\">";

                br.Text = "</div><br />";
                PnGrids.Controls.Add(header);
                createGridView(report);
                
                //PnGrids.Controls.Add();
                //PnGrids.Controls.Add(br);
            }
        }

        protected GridView createGridView(DataTable table)
        {
            grid.Columns.Clear();
            grid.DataSource = table;

            string currentSortExpression = (string)ViewState["SortExpression"];
            string currentSortDirection = (string)ViewState["SortDirection"];

            string cssClass = currentSortDirection == "ASC" ? "asc" : "desc";


            grid.Width = new Unit(100, UnitType.Percentage);
            grid.AutoGenerateColumns = false;
            grid.EnableModelValidation = true;
            grid.CssClass = "table-dynamic table table-bordered table-striped";
            grid.AllowSorting = true;

            grid.HeaderStyle.CssClass = "page-titles";

            BoundField Player = new BoundField();
            Player.HeaderText = "Player";
            Player.DataField = "Player";
            Player.SortExpression = "Player";
            if (currentSortExpression == "Player")
            {
                Player.HeaderStyle.CssClass = cssClass;
            }
            grid.Columns.Add(Player);

            TemplateField result = new TemplateField();
            result.ShowHeader = true;
            result.HeaderText = "Beat Line / Total Bets";
            //result.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, "Beat Line / Total Bets", "", "","","");
            result.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "beats", "Label", "", "");
            result.SortExpression = "beats";
            if (currentSortExpression == "beats")
            {
                result.HeaderStyle.CssClass = cssClass;
            }
            grid.Columns.Add(result);



            TemplateField WinLoss = new TemplateField();
            WinLoss.HeaderText = "Win/Loss";
            if (currentSortExpression == "RisWinAmount")
            {
                WinLoss.HeaderStyle.CssClass = cssClass;
            }
            WinLoss.ItemTemplate = new GridViewNumericTemplate("RisWinAmount");
            WinLoss.SortExpression = "RisWinAmount";
            grid.Columns.Add(WinLoss);

            BoundField CloseLine = new BoundField();
            CloseLine.HeaderText = "Percentage";
            CloseLine.DataField = "effectivity";
            CloseLine.DataFormatString = "{0:P}";
            CloseLine.ItemStyle.CssClass = "blacktext";
            CloseLine.SortExpression = "effectivity";
            if (currentSortExpression == "effectivity" || String.IsNullOrEmpty(currentSortExpression))
            {
                CloseLine.HeaderStyle.CssClass = cssClass;
            }
            grid.Columns.Add(CloseLine);

            BoundField LifeTimeNet = new BoundField();
            LifeTimeNet.HeaderText = "Life Time";
            LifeTimeNet.DataField = "LifeTimeNet";
            LifeTimeNet.DataFormatString = "{0:N0}";
            LifeTimeNet.ItemStyle.CssClass = "blacktext";
            LifeTimeNet.SortExpression = "LifeTimeNet";
            if (currentSortExpression == "LifeTimeNet")
            {
                LifeTimeNet.HeaderStyle.CssClass = cssClass;
            }
            grid.Columns.Add(LifeTimeNet);

            grid.Sorting += new GridViewSortEventHandler(GridView_Sorting);


            TemplateField customField1 = new TemplateField();
            customField1.ShowHeader = true;

            customField1.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, "Full Analysis", "", "", "", "");
            customField1.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "idPlayer", "HyperLink", txtDateFrom.Text, txtDateTo.Text);
            grid.Columns.Add(customField1);


            grid.DataBind();
            return grid;
        }


        public class GridViewNumericTemplate : ITemplate
        {
            private string _dataField;

            public GridViewNumericTemplate(string dataField)
            {
                _dataField = dataField;
            }

            public void InstantiateIn(Control container)
            {
                Label lbl = new Label();
                lbl.DataBinding += new EventHandler(lbl_DataBinding);
                container.Controls.Add(lbl);
            }

            private void lbl_DataBinding(object sender, EventArgs e)
            {
                Label lbl = (Label)sender;
                GridViewRow row = (GridViewRow)lbl.NamingContainer;
                object dataValue = DataBinder.Eval(row.DataItem, _dataField);
                if (dataValue != DBNull.Value && dataValue != null)
                {
                    decimal value = Convert.ToDecimal(dataValue);
                    lbl.Text = value.ToString("N0");
                    lbl.CssClass = value < 0 ? "NumNegative" : "NumPositive";
                }
            }
        }


        protected void GridView1_RowCommand(Object sender, GridViewCommandEventArgs e)
        {
            int index = Int32.Parse((string)e.CommandArgument);

            Response.Redirect("/Report/BeatTheLine.aspx?player=");
            if (e.CommandName == "view")
            {
                Response.Redirect("/Report/BeatTheLine.aspx?player=");

            }
        }

        protected DataTable getReport(int prmIdAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("AddOn_BeatTheLineAnalysisV2", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandTimeout = 120;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmDateFrom", SqlDbType.DateTime)).Value = txtDateFrom.Text;
                ((SqlParameter)comm.Parameters.Add("@prmDateTo", SqlDbType.DateTime)).Value = txtDateTo.Text;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.VarChar)).Value = ddlPlayer.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmPlay", SqlDbType.Int)).Value = ddlPlay.SelectedValue;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);

                ViewState["ReportTable"] = table;

            }
            catch { }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
        }

        protected DataTable getAllAgents()
        {
            int prmIdAgent = Convert.ToInt32(Session["SubIdAgent"]);
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("AddOn_BuildAgentTree", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandTimeout = 120;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch { }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
        }

        protected void ddlPlayer_DataBound(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CreateReport();
            }
        }

        public class GridViewTemplate : ITemplate
        {
            private DataControlRowType templateType;
            private string columnName;
            private string columnNameBinding;
            private string controlType;
            private string DateFrom;
            private string DateTo;

            public GridViewTemplate(DataControlRowType type, string colname, string colNameBinding, string ctlType, string dateFrom, string dateTo)
            {
                templateType = type;
                columnName = colname;
                columnNameBinding = colNameBinding;
                controlType = ctlType;
                DateFrom = dateFrom;
                DateTo = dateTo;
            }

            public void InstantiateIn(System.Web.UI.Control container)
            {
                switch (templateType)
                {
                    case DataControlRowType.Header:
                        Literal lc = new Literal();
                        lc.Text = columnName;
                        container.Controls.Add(lc);

                        break;
                    case DataControlRowType.DataRow:
                        if (controlType == "Label")
                        {
                            Label lb = new Label();
                            lb.ID = "lb" + columnNameBinding;
                            lb.DataBinding += new EventHandler(this.ctl_OnDataBinding);
                            container.Controls.Add(lb);
                        }
                        else if (controlType == "TextBox")
                        {
                            TextBox tb = new TextBox();
                            tb.ID = "tb" + columnNameBinding;
                            tb.DataBinding += new EventHandler(this.ctl_OnDataBinding);
                            container.Controls.Add(tb);
                        }
                        else if (controlType == "CheckBox")
                        {
                            CheckBox cb = new CheckBox();
                            cb.ID = "cb1";
                            cb.DataBinding += new EventHandler(this.ctl_OnDataBinding);
                            container.Controls.Add(cb);
                        }
                        else if (controlType == "HyperLink")
                        {
                            HyperLink hl = new HyperLink();
                            hl.ID = "hl1";
                            hl.DataBinding += new EventHandler(this.ctl_OnDataBinding);
                            container.Controls.Add(hl);
                        }
                        else if (controlType == "Button")
                        {
                            Button hl = new Button();
                            hl.ID = "hl1";
                            // hl.DataBinding += new EventHandler(this.ctl_OnDataBinding);
                            hl.Click += new EventHandler(this.btnDetails_Click);
                            hl.Text = "Details";
                            container.Controls.Add(hl);
                        }
                        break;
                    default:
                        break;
                }
            }

            protected void btnDetails_Click(object sender, EventArgs e)
            {
                HttpContext context = HttpContext.Current;
                context.Response.Redirect("www.google.com");
            }

            public void ctl_OnDataBinding(object sender, EventArgs e)
            {
                if (sender.GetType().Name == "Label")
                {
                    Label lb = (Label)sender;
                    GridViewRow container = (GridViewRow)lb.NamingContainer;
                    string controlType = lb.ID.Replace("lb", "");

                    if (controlType == "beats")
                    {
                        lb.Text = ((DataRowView)container.DataItem)["beats"].ToString() + "/" + ((DataRowView)container.DataItem)["bets"].ToString();
                    }
                    else
                    {
                        lb.Text = ((DataRowView)container.DataItem)["WagerType"].ToString() + "<br/>" + Convert.ToDateTime(((DataRowView)container.DataItem)["GameDate"].ToString()).ToString("MM-dd hh:mmtt") + "<br/> " + ((DataRowView)container.DataItem)["Sport"].ToString() + " - " + ((DataRowView)container.DataItem)["Description"].ToString();
                    }
                }
                else if (sender.GetType().Name == "TextBox")
                {
                    TextBox tb = (TextBox)sender;
                    GridViewRow container = (GridViewRow)tb.NamingContainer;
                    tb.Text = ((DataRowView)container.DataItem)[columnNameBinding].ToString();
                }
                else if (sender.GetType().Name == "CheckBox")
                {
                    CheckBox cb = (CheckBox)sender;
                    GridViewRow container = (GridViewRow)cb.NamingContainer;
                    cb.Checked = Convert.ToBoolean(((DataRowView)container.DataItem)[columnNameBinding].ToString());
                }
                else if (sender.GetType().Name == "HyperLink")
                {
                    HyperLink hl = (HyperLink)sender;
                    GridViewRow container = (GridViewRow)hl.NamingContainer;
                    string playerId = ((DataRowView)container.DataItem)["idPlayer"].ToString();
                    string dateFrom = DateFrom;
                    string dateTo = DateTo;
                    hl.Text = "View";
                    hl.Attributes["onclick"] = String.Format("GetBeatTheLineAnalis({0}, '{1}', '{2}'); return false;", playerId, dateFrom, dateTo);
                    hl.NavigateUrl = "#";
                }
                else if (sender.GetType().Name == "Button")
                {
                    Button hl = (Button)sender;
                    GridViewRow container = (GridViewRow)hl.NamingContainer;
                    hl.Text = ((DataRowView)container.DataItem)[columnNameBinding].ToString();
                    hl.CommandArgument = ((DataRowView)container.DataItem)[columnNameBinding].ToString();
                }
            }
        }

        protected void GridView_Sorting(object sender, GridViewSortEventArgs e)
        {
            DataTable dataTable = ViewState["ReportTable"] as DataTable;

            if (dataTable != null)
            {
                DataView dataView = new DataView(dataTable);
                dataView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression);

                string agent = ddlAgent.SelectedItem.Text;
                Literal header = new Literal();
                Literal br = new Literal();
                header.Text = "<table style='width: 100%;' cellspacing='0' cellpadding='3' border='0' class='filter table-bordered' align='center'><tbody><tr class='page-titles'><td colspan='15'><h4>" + agent + "</h4></td></tr></tbody></table>";

                br.Text = "<br />";
                PnGrids.Controls.Add(header);
                createGridView(dataView.ToTable());
                

            }
        }

        private string GetSortDirection(string column)
        {
            string sortDirection = "ASC";

            string sortExpression = ViewState["SortExpression"] as string;

            if (sortExpression != null)
            {
                if (sortExpression == column)
                {
                    string lastDirection = ViewState["SortDirection"] as string;
                    if ((lastDirection != null) && (lastDirection == "ASC"))
                    {
                        sortDirection = "DESC";
                    }
                }
            }

            ViewState["SortDirection"] = sortDirection;
            ViewState["SortExpression"] = column;

            return sortDirection;
        }


        protected void ddlAgent_DataBound(object sender, EventArgs e)
        {
            CreateReport();
        }
    }
}