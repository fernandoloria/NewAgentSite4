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
    public partial class LineAdvantage : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Init(object sender, EventArgs e)
        {
            DateTime from = fromOrTo(true);
            DateTime to = fromOrTo(false); ;

            txtDateFrom.Text = from.ToString("MM/dd/yyyy");
            txtDateTo.Text = to.ToString("MM/dd/yyyy");
        }

        protected void Page_Load(object sender, EventArgs e)
        {


            if (!String.IsNullOrEmpty(Request.QueryString["player"]) && !IsPostBack)
            {
                ddlPlayer.SelectedValue = Request.QueryString["player"].ToString();
                txtDateFrom.Text = Request.QueryString["df"];
                txtDateTo.Text = Request.QueryString["dt"];

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
            CreateReport();
        }




        protected void CreateReport()
        {
            PnGrids.Controls.Clear();

            int selected_agentID = (ddlAgent.SelectedValue == "") ? 1 : Convert.ToInt32(ddlAgent.SelectedValue);
            string agent = ddlAgent.SelectedItem.Text;

            DataTable report = getReport(selected_agentID);
            if (report.Rows.Count > 0)
            {
                Literal header = new Literal();
                Literal br = new Literal();
                header.Text = "<div class='table__title'>" + agent + "</div>";

                br.Text = "<br />";
                PnGrids.Controls.Add(header);
                PnGrids.Controls.Add(createGridView(report));
                PnGrids.Controls.Add(br);
                if (!String.IsNullOrEmpty(Request.QueryString["player"]))
                {
                    Button btnClose = new Button();
                    btnClose.Text = "Close";
                    btnClose.CssClass = "btn btn-danger";
                    btnClose.Attributes.Add("data-dismiss", "modal");
                    PnGrids.Controls.Add(btnClose);
                }
            }

        }

        protected GridView createGridView(DataTable table)
        {
            GridView grid = new GridView();
            grid.DataSource = table;

            grid.Width = new Unit(100, UnitType.Percentage);
            grid.AutoGenerateColumns = false;
            grid.EnableModelValidation = true;
            grid.CssClass = "table-dynamic table table-bordered table-striped";

            // grid.AlternatingRowStyle.CssClass = "TrGameEven";
            grid.HeaderStyle.CssClass = "page-titles";
            // grid.RowStyle.CssClass = "TrGameOdd";

            BoundField Player = new BoundField();
            Player.HeaderText = "Player";
            Player.DataField = "Player";
            grid.Columns.Add(Player);

            TemplateField customField1 = new TemplateField();
            customField1.ShowHeader = true;
            customField1.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, "Description", "", "");
            customField1.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "Sport", "Label");
            grid.Columns.Add(customField1);

            TemplateField WinLoss = new TemplateField();
            WinLoss.HeaderText = "Win/Loss";
            WinLoss.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "RiskWin", "Label");
            grid.Columns.Add(WinLoss);


            TemplateField lineField = new TemplateField();
            lineField.HeaderText = "Line Picked";
            lineField.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "Line", "Label");
            grid.Columns.Add(lineField);

            BoundField CloseLine = new BoundField();
            CloseLine.HeaderText = "Close Line";
            CloseLine.DataField = "CloseLine";
            CloseLine.ItemStyle.CssClass = "blacktext";
            grid.Columns.Add(CloseLine);

            BoundField Result = new BoundField();
            Result.HeaderText = "Result";
            Result.DataField = "Result";
            grid.Columns.Add(Result);

            grid.DataBound += new EventHandler(GridView_DataBound);

            grid.DataBind();

            return grid;
        }


        protected DataTable getReport(int prmIdAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            try
            {
                SqlCommand comm = new SqlCommand("AddOn_BeatTheLineV5", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmDateFrom", SqlDbType.DateTime)).Value = txtDateFrom.Text;
                ((SqlParameter)comm.Parameters.Add("@prmDateTo", SqlDbType.DateTime)).Value = txtDateTo.Text;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.VarChar)).Value = ddlPlayer.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmBeaterOnly", SqlDbType.Bit)).Value = 0;
                ((SqlParameter)comm.Parameters.Add("@prmPlay", SqlDbType.Int)).Value = ddlPlay.SelectedValue;


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
            if (!String.IsNullOrEmpty(Request.QueryString["player"]) && !IsPostBack)
            {
                ddlPlayer.SelectedValue = Request.QueryString["player"].ToString();
                txtDateFrom.Text = Request.QueryString["df"];
                txtDateTo.Text = Request.QueryString["dt"];
            }
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

            public GridViewTemplate(DataControlRowType type, string colname, string colNameBinding, string ctlType)
            {
                templateType = type;
                columnName = colname;
                columnNameBinding = colNameBinding;
                controlType = ctlType;
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
                        break;
                    default:
                        break;
                }
            }

            public void ctl_OnDataBinding(object sender, EventArgs e)
            {
                if (sender.GetType().Name == "Label")
                {
                    Label lb = (Label)sender;
                    GridViewRow container = (GridViewRow)lb.NamingContainer;
                    string controlType = lb.ID.Replace("lb", "");

                    if (controlType == "RiskWin")
                    {
                        decimal riskWin = Convert.ToDecimal(((DataRowView)container.DataItem)["RiskWin"]);
                        lb.Text = riskWin >= 0 ? "+" + riskWin.ToString("N0") : riskWin.ToString("N0");
                        lb.CssClass = riskWin >= 0 ? "NumPositive" : "NumNegative";
                    }

                    else if (controlType == "Line")
                    {
                        string line = ((DataRowView)container.DataItem)["Line"].ToString();
                        object difPointsObj = ((DataRowView)container.DataItem)["difPoints"];
                        object difOddsObj = ((DataRowView)container.DataItem)["difOdds"];

                        double difPoints = difPointsObj != DBNull.Value ? Convert.ToDouble(difPointsObj) : 0;
                        double difOdds = difOddsObj != DBNull.Value ? Convert.ToDouble(difOddsObj) : 0;

                        lb.Text = line;
                        lb.Attributes.Add("data-difpoints", difPoints.ToString());
                        lb.Attributes.Add("data-difodds", difOdds.ToString());
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
                    hl.Text = ((DataRowView)container.DataItem)[columnNameBinding].ToString();
                    hl.NavigateUrl = ((DataRowView)container.DataItem)[columnNameBinding].ToString();
                }
            }
        }

        protected void GridView_DataBound(object sender, EventArgs e)
        {
            GridView grid = (GridView)sender;
            foreach (GridViewRow row in grid.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    Label lb = (Label)row.FindControl("lbLine");
                    if (lb != null)
                    {
                        double difPoints = Convert.ToDouble(lb.Attributes["data-difpoints"]);
                        double difOdds = Convert.ToDouble(lb.Attributes["data-difodds"]);

                        if (difPoints != 0)
                        {
                            Label lblDifPoints = new Label();
                            lblDifPoints.Text = " (" + difPoints.ToString("0.0") + ")";
                            lblDifPoints.CssClass = difPoints > 0 ? "NumPositive" : "NumNegative";
                            row.Cells[3].Controls.Add(lblDifPoints);
                        }

                        if (difOdds != 0)
                        {
                            Label lblDifOdds = new Label();
                            lblDifOdds.Text = " (" + difOdds.ToString("+#;-#;0") + ")";
                            lblDifOdds.CssClass = difOdds > 0 ? "NumPositive" : "NumNegative";
                            row.Cells[3].Controls.Add(lblDifOdds);
                        }
                    }
                }
            }
        }




        protected void ddlAgent_DataBound(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CreateReport();
            }
        }
    }
}
