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
    public partial class AgentLifeTime  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Init(object sender, EventArgs e)
        {
            DateTime from = DateTime.Now.AddYears(-1);
            DateTime to = DateTime.Now;

            txtDateFrom.Text = from.ToString("MM/dd/yyyy");
            txtDateTo.Text = to.ToString("MM/dd/yyyy");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int idAgent = Convert.ToInt32(Session["idAgent"]);
                CreateReport(idAgent);
            }
        }


        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int idAgent = Convert.ToInt32(ddlAgent.SelectedValue);
            CreateReport(idAgent);
        }



        protected void CreateReport(int idAgent)
        {
            PnGrids.Controls.Clear();

            DataSet ds = getReport(idAgent);
            foreach (DataTable report in ds.Tables)
            {
                if (report.Rows.Count > 0)
                {
                    Literal header = new Literal();
                    Literal br = new Literal();
                    header.Text = "<table style='width: 100%;' cellspacing='0' cellpadding='3' border='0' class='filter table-bordered' align='center'><tbody><tr class='page-titles'><td colspan='15'><h4>" + report.Rows[0][1].ToString() + "</h4></td></tr></tbody></table>";

                    br.Text = "<br />";
                    PnGrids.Controls.Add(header);
                    PnGrids.Controls.Add(createGridView(report));
                    PnGrids.Controls.Add(br);
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
            grid.CssClass = "table-dynamic table table-bordered table-striped table-sm";


            // grid.AlternatingRowStyle.CssClass = "TrGameEven";
            grid.HeaderStyle.CssClass = "GameHeader";
            // grid.RowStyle.CssClass = "TrGameOdd";

            //BoundField TopType = new BoundField();
            //TopType.HeaderText = "";
            //TopType.DataField = "TopType";
            //grid.Columns.Add(TopType);

            BoundField Player = new BoundField();
            Player.HeaderText = "Player";
            Player.DataField = "Player";
            grid.Columns.Add(Player);


            TemplateField lblTotal = new TemplateField();
            lblTotal.ShowHeader = true;
            lblTotal.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, "", "", "");
            lblTotal.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "Total", "Label");
            grid.Columns.Add(lblTotal);


            TemplateField Sports = new TemplateField();
            Sports.ShowHeader = true;
            Sports.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, "Sports", "", "");
            Sports.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "Sports", "Literal");
            grid.Columns.Add(Sports);

            TemplateField Casino = new TemplateField();
            Casino.ShowHeader = true;
            Casino.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, "Casino", "", "");
            Casino.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "Casino", "Literal");
            grid.Columns.Add(Casino);

            TemplateField Racing = new TemplateField();
            Racing.ShowHeader = true;
            Racing.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, "Racing", "", "");
            Racing.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "Racing", "Literal");
            grid.Columns.Add(Racing);


            TemplateField Total = new TemplateField();
            Total.ShowHeader = true;
            Total.HeaderTemplate = new GridViewTemplate(DataControlRowType.Header, "Totals", "", "");
            Total.ItemTemplate = new GridViewTemplate(DataControlRowType.DataRow, "", "Total", "Literal");
            grid.Columns.Add(Total);

            //BoundField WinSports = new BoundField();
            //WinSports.HeaderText = "Win Sports";
            //WinSports.DataField = "WinSports";
            //WinSports.DataFormatString = "{0:N0}";
            //grid.Columns.Add(WinSports);

            //BoundField LoseSports = new BoundField();
            //LoseSports.HeaderText = "Lose Sports";
            //LoseSports.DataField = "LoseSports";
            //LoseSports.DataFormatString = "{0:N0}";
            //grid.Columns.Add(LoseSports);

            //BoundField TotalSports = new BoundField();
            //TotalSports.HeaderText = "Total Sports";
            //TotalSports.DataField = "TotalSports";
            //TotalSports.DataFormatString = "{0:N0}";
            //grid.Columns.Add(TotalSports);

            //BoundField WinCasino = new BoundField();
            //WinCasino.HeaderText = "Win Casino";
            //WinCasino.DataField = "WinCasino";
            //WinCasino.DataFormatString = "{0:N0}";
            //grid.Columns.Add(WinCasino);

            //BoundField LoseCasino = new BoundField();
            //LoseCasino.HeaderText = "Lose Casino";
            //LoseCasino.DataField = "LoseCasino";
            //LoseCasino.DataFormatString = "{0:N0}";
            //grid.Columns.Add(LoseCasino);

            //BoundField TotalCasino = new BoundField();
            //TotalCasino.HeaderText = "Total Casino";
            //TotalCasino.DataField = "TotalCasino";
            //TotalCasino.DataFormatString = "{0:N0}";
            //grid.Columns.Add(TotalCasino);

            //BoundField WinRacing = new BoundField();
            //WinRacing.HeaderText = "Win Racing";
            //WinRacing.DataField = "WinRacing";
            //WinRacing.DataFormatString = "{0:N0}";
            //grid.Columns.Add(WinRacing);

            //BoundField LoseRacing = new BoundField();
            //LoseRacing.HeaderText = "Lose Racing";
            //LoseRacing.DataField = "LoseRacing";
            //LoseRacing.DataFormatString = "{0:N0}";
            //grid.Columns.Add(LoseRacing);

            //BoundField TotalRacing = new BoundField();
            //TotalRacing.HeaderText = "Total Racing";
            //TotalRacing.DataField = "TotalRacing";
            //TotalRacing.DataFormatString = "{0:N0}";
            //grid.Columns.Add(TotalRacing);

            //BoundField WinTotal = new BoundField();
            //WinTotal.HeaderText = "Win Total";
            //WinTotal.DataField = "WinTotal";
            //WinTotal.DataFormatString = "{0:N0}";
            //grid.Columns.Add(WinTotal);

            //BoundField LoseTotal = new BoundField();
            //LoseTotal.HeaderText = "Lose Total";
            //LoseTotal.DataField = "LoseTotal";
            //LoseTotal.DataFormatString = "{0:N0}";
            //grid.Columns.Add(LoseTotal);

            // BoundField Total = new BoundField();
            //Total.HeaderText = "Total";
            //Total.DataField = "Total";
            //Total.DataFormatString = "{0:N0}";
            //grid.Columns.Add(Total);

            BoundField NetPer = new BoundField();
            NetPer.HeaderText = "Net %";
            NetPer.DataField = "NetPer";
            NetPer.DataFormatString = "{0:N2}%";
            grid.Columns.Add(NetPer);



            //grid.Columns[0].HeaderText = "Player";
            //grid.Columns[1].HeaderText = "Ticket #";
            //grid.Columns[2].HeaderText = "Placed Date";
            //grid.Columns[3].HeaderText = "Type";
            //grid.Columns[4].HeaderText = "Sport";
            //grid.Columns[5].HeaderText = "Game Date";


            //grid.Columns[0].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            //grid.Columns[1].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            //grid.Columns[2].ItemStyle.Width = new Unit(70, UnitType.Pixel);
            //grid.Columns[3].ItemStyle.Width = new Unit(60, UnitType.Pixel);
            //grid.Columns[4].ItemStyle.Width = new Unit(20, UnitType.Pixel);
            //grid.Columns[5].ItemStyle.Width = new Unit(70, UnitType.Pixel);

            grid.DataBind();
            if ((grid.Rows.Count) >= 1)
            {
                grid.Rows[(grid.Rows.Count - 1)].CssClass = "wb_totalsubagent bold";
            }
            return grid;
        }


        protected DataSet getReport(int prmIdAgent)
        {

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            DataTable table = new DataTable();
            DataSet ds = new DataSet();
            try
            {
                DateTime dateFrom = Convert.ToDateTime(txtDateFrom.Text);
                DateTime dataTo = Convert.ToDateTime(txtDateTo.Text);
                SqlCommand comm = new SqlCommand("AgentLifeTime", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm.Parameters.Add("@prmDateFrom", SqlDbType.DateTime)).Value = dateFrom;
                ((SqlParameter)comm.Parameters.Add("@prmDateTo", SqlDbType.DateTime)).Value = dataTo;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);

                string TopType = "";
                int index = 0;
                foreach (DataRow linea in table.Rows)
                {
                    if (linea[0].ToString() != TopType)
                    {
                        DataTable dt = new DataTable();
                        dt = table.Copy();
                        dt.TableName = "NewName" + index;
                        dt.Clear();
                        ds.Tables.Add(dt);
                        int lastIndex = ds.Tables.Count - 1;

                        ds.Tables[lastIndex].ImportRow(linea);
                        TopType = linea[0].ToString();
                    }
                    else
                    {
                        int lastIndex = ds.Tables.Count - 1;
                        ds.Tables[lastIndex].ImportRow(linea);
                        TopType = linea[0].ToString();
                    }
                    index++;
                }
            }
            catch (Exception e) { Response.Write(e.Message); }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return ds;
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
                        if (controlType == "Literal")
                        {
                            Literal lb = new Literal();
                            lb.ID = "lb1";
                            lb.DataBinding += new EventHandler(this.ctl_OnDataBinding);
                            container.Controls.Add(lb);
                        }
                        if (controlType == "Label")
                        {
                            Label lb = new Label();
                            lb.ID = "lb1";
                            lb.DataBinding += new EventHandler(this.ctl_OnDataBinding);
                            container.Controls.Add(lb);
                        }
                        break;
                    default:
                        break;
                }
            }

            public void ctl_OnDataBinding(object sender, EventArgs e)
            {
                if (sender.GetType().Name == "Literal")
                {
                    Literal lb = (Literal)sender;
                    GridViewRow container = (GridViewRow)lb.NamingContainer;
                    decimal lose = Convert.ToDecimal(((DataRowView)container.DataItem)["Lose" + columnNameBinding].ToString());
                    string strLose = lose.ToString("N0");
                    if (lose < 0)
                    {
                        strLose = "<span class='neg'>" + Convert.ToDecimal(((DataRowView)container.DataItem)["Lose" + columnNameBinding].ToString()).ToString("N0") + "</span>";
                    }
                    decimal total = Convert.ToDecimal(((DataRowView)container.DataItem)["Total" + columnNameBinding].ToString());
                    string strTotal = total.ToString("N0");
                    if (total < 0)
                    {
                        strTotal = "<span class='neg'>" + total.ToString("N0") + "</span>";
                    }
                    lb.Text =
                        Convert.ToDecimal(((DataRowView)container.DataItem)["Win" + columnNameBinding].ToString()).ToString("N0")
                        + "<br/>" +
                        strLose
                        + "<br/>" +
                        strTotal;
                }
                if (sender.GetType().Name == "Label")
                {
                    Label lb = (Label)sender;
                    GridViewRow container = (GridViewRow)lb.NamingContainer;
                    lb.Text = "Win" + "<br/>" +
                            "Lose" + "<br/> " +
                               "Total";
                }
            }
        }


        protected void ddlAgent_DataBound(object sender, EventArgs e)
        {

        }

        protected void ddlAgent_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
