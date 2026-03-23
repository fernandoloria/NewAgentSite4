using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;

namespace AgentSite4.Report
{
    public partial class PlayerWeeklyProfit  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        string week1, week2, week3, week4, week5;

        protected void Page_Init(object sender, EventArgs e)
        {
            DateTime from = fromOrTo(true);
            DateTime to = fromOrTo(false); ;

            txtDateFrom.Text = from.ToString("MMMM-yyyy");

        }

        protected void Page_Load(object sender, EventArgs e)
        {


            if (!String.IsNullOrEmpty(Request.QueryString["player"]) && !IsPostBack)
            {
                hdfIdPlayer.Value = Request.QueryString["player"].ToString();
                txtDateFrom.Text = Request.QueryString["df"];

            }
            else
            {
                btnBack.Visible = false;
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
        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("BeatTheLineAnalysis.aspx");
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
                header.Text = "<table style='width: 100%;' cellspacing='0' cellpadding='3' border='0' class='filter table-bordered' align='center'><tbody><tr class='page-titles'><td colspan='15'><h4>" + agent + "</h4></td></tr></tbody></table>";

                br.Text = "<br />";
                PnGrids.Controls.Add(header);
                PnGrids.Controls.Add(createGridView(report));
                PnGrids.Controls.Add(br);
            }

        }

        protected string dateParameter(string date, bool from)
        {
            if (from)
            {
                return Convert.ToDateTime(date).ToString("MM-dd-yyyy");
            }
            else
            {
                return Convert.ToDateTime(date).AddDays(6).ToString("MM-dd-yyyy");
            }
        }

        protected GridView createGridView(DataTable table)
        {
            //string week1, week2, week3, week4, week5;
            string week1From, week2From, week3From, week4From, week5From,
                week1To, week2To, week3To, week4To, week5To, totalTo;
            week1From = dateParameter(week1, true);
            week2From = dateParameter(week2, true);
            week3From = dateParameter(week3, true);
            week4From = dateParameter(week4, true);
            week1To = dateParameter(week1, false);
            week2To = dateParameter(week2, false);
            week3To = dateParameter(week3, false);
            week4To = totalTo = dateParameter(week4, false);
            if (!String.IsNullOrEmpty(week5))
            {
                week5From = dateParameter(week5, true);
                week5To = totalTo = dateParameter(week5, false);
            }
            else
            {
                week5From = week5To = "";
            }

            GridView grid = new GridView();
            grid.DataSource = table;

            grid.Width = new Unit(100, UnitType.Percentage);
            grid.AutoGenerateColumns = false;
            grid.EnableModelValidation = true;
            grid.CssClass = "table-dynamic table table-bordered table-striped table-sm";
            grid.HeaderStyle.CssClass = "GameHeader";


            BoundField Player = new BoundField();
            Player.HeaderText = "Player";
            Player.DataField = "player";
            Player.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            grid.Columns.Add(Player);


            TemplateField customField1 = new TemplateField();
            customField1.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            customField1.ShowHeader = true;
            customField1.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, Convert.ToDateTime(week1).ToString("MM/dd"), "", "", "", "", "", "");
            customField1.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "week1", "idPlayer", "click1", "HyperLink", week1From, week1To);
            grid.Columns.Add(customField1);

            TemplateField customField2 = new TemplateField();
            customField2.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            customField2.ShowHeader = true;
            customField2.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, Convert.ToDateTime(week2).ToString("MM/dd"), "", "", "", "", "", "");
            customField2.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "week2", "idPlayer", "click2", "HyperLink", week2From, week2To);
            grid.Columns.Add(customField2);

            TemplateField customField3 = new TemplateField();
            customField3.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            customField3.ShowHeader = true;
            customField3.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, Convert.ToDateTime(week3).ToString("MM/dd"), "", "", "", "", "", "");
            customField3.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "week3", "idPlayer", "click3", "HyperLink", week3From, week3To);
            grid.Columns.Add(customField3);

            TemplateField customField4 = new TemplateField();
            customField4.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            customField4.ShowHeader = true;
            customField4.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, Convert.ToDateTime(week4).ToString("MM/dd"), "", "", "", "", "", "");
            customField4.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "week4", "idPlayer", "click4", "HyperLink", week4From, week4To);
            grid.Columns.Add(customField4);

            if (!String.IsNullOrEmpty(week5))
            {
                TemplateField customField5 = new TemplateField();
                customField5.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
                customField5.ShowHeader = true;
                customField5.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, Convert.ToDateTime(week5).ToString("MM/dd"), "", "", "", "", "", "");
                customField5.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "week5", "idPlayer", "click5", "HyperLink", week5From, week5To);
                grid.Columns.Add(customField5);
            }


            TemplateField customField6 = new TemplateField();
            customField6.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            customField6.ShowHeader = true;
            customField6.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, "Monthly Total", "", "", "", "", "", "");
            customField6.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "Total", "idPlayer", "clickTotal", "HyperLink", week1From, totalTo);
            grid.Columns.Add(customField6);

            grid.DataBind();
            return grid;
        }


        protected DataTable getReport(int prmIdAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            string idPlayer = hdfIdPlayer.Value == "" ? "-1" : hdfIdPlayer.Value;
            DataTable table = new DataTable();
            try
            {

                DateTime datePicked = DateTime.ParseExact(txtDateFrom.Text, "MMMM-yyyy", CultureInfo.InvariantCulture);
                //Convert.ToDateTime(txtDateFrom.Text);

                SqlCommand comm = new SqlCommand("PlayerWeeklyProfit_Get", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = idPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmMonth", SqlDbType.Int)).Value = Convert.ToInt32(datePicked.ToString("MM"));
                ((SqlParameter)comm.Parameters.Add("@prmYear", SqlDbType.Int)).Value = Convert.ToInt32(datePicked.ToString("yyyy"));
                ((SqlParameter)comm.Parameters.Add("@prmOnlyActives", SqlDbType.Bit)).Value = chkActive.Checked;

                SqlParameter outWeek1 = new SqlParameter("@outWeek1", SqlDbType.DateTime);
                SqlParameter outWeek2 = new SqlParameter("@outWeek2", SqlDbType.DateTime);
                SqlParameter outWeek3 = new SqlParameter("@outWeek3", SqlDbType.DateTime);
                SqlParameter outWeek4 = new SqlParameter("@outWeek4", SqlDbType.DateTime);
                SqlParameter outWeek5 = new SqlParameter("@outWeek5", SqlDbType.DateTime);
                outWeek1.Direction = System.Data.ParameterDirection.Output;
                outWeek2.Direction = System.Data.ParameterDirection.Output;
                outWeek3.Direction = System.Data.ParameterDirection.Output;
                outWeek4.Direction = System.Data.ParameterDirection.Output;
                outWeek5.Direction = System.Data.ParameterDirection.Output;
                comm.Parameters.Add(outWeek1);
                comm.Parameters.Add(outWeek2);
                comm.Parameters.Add(outWeek3);
                comm.Parameters.Add(outWeek4);
                comm.Parameters.Add(outWeek5);

                SqlDataReader reader;
                reader = comm.ExecuteReader();
                table.Load(reader);

                week1 = outWeek1.Value.ToString();
                week2 = outWeek2.Value.ToString();
                week3 = outWeek3.Value.ToString();
                week4 = outWeek4.Value.ToString();
                week5 = outWeek5.Value.ToString();

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



        public class GridViewTemplate : ITemplate
        {
            private DataControlRowType templateType;
            private string columnName;
            private string columnNameBinding;
            private string columnNameBindingID;
            private string columnNameHasClick;
            private string controlType;
            private string DateFrom;
            private string DateTo;

            public GridViewTemplate(DataControlRowType type, string colname, string colNameBinding, string colNameBindingID, string colNameHasClick, string ctlType, string dateFrom, string dateTo)
            {
                templateType = type;
                columnName = colname;
                columnNameBinding = colNameBinding;
                columnNameBindingID = colNameBindingID;
                columnNameHasClick = colNameHasClick;
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
                            lb.ID = "lb1";
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
                    int value = Convert.ToInt32(((DataRowView)container.DataItem)[columnNameBinding]);
                    DataControlFieldCell cell = (DataControlFieldCell)lb.Parent;
                    if (value < 0)
                    {
                        cell.CssClass = "redCell";
                    }
                    else if (value > 0)
                    {
                        cell.CssClass = "greenCell";
                    }
                    lb.Text = value.ToString();
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
                    int value = Convert.ToInt32(((DataRowView)container.DataItem)[columnNameBinding]);
                    DataControlFieldCell cell = (DataControlFieldCell)hl.Parent;


                    if (value < 0)
                    {
                        cell.CssClass = "redCell";
                    }
                    else if (value > 0)
                    {
                        cell.CssClass = "greenCell";
                    }
                    else
                    {
                        cell.CssClass = "grayCell";
                    }
                    bool hasClick = Convert.ToBoolean(((DataRowView)container.DataItem)[columnNameHasClick]);
                    hl.Text = value.ToString();
                    if (hasClick)
                    {
                        hl.NavigateUrl = "javascript:GetPlayerProfitHistory(" + ((DataRowView)container.DataItem)[columnNameBindingID].ToString() + ",'" + DateFrom + "','" + DateTo + "');";
                        if (value == 0)
                        {
                            cell.CssClass = "blueCell";
                        }
                    }
                    else
                    {
                        if (value == 0)
                        {
                            hl.Text = "No Action";

                        }
                    }
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




        protected void ddlAgent_DataBound(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CreateReport();

            }
        }



        protected void ddlAgent_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
