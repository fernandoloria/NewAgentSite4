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
    public partial class TopWinnersAndLosers  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Init(object sender, EventArgs e)
        {
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
        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("BeatTheLineAnalysis.aspx");
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
                    header.Text = "<table style='width: 100%;' cellspacing='0' cellpadding='3' border='0' class='table-dynamic table table-bordered table-striped' align='center'><tbody><tr class='trAgent'><td colspan='15'><h4>" + report.Rows[0][0].ToString() + "</h4></td></tr></tbody></table><div class=\"table-responsive\">";

                    br.Text = "</div><br />";
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
            grid.CssClass = "table-dynamic table table-bordered table-striped";


            // grid.AlternatingRowStyle.CssClass = "TrGameEven";
            grid.HeaderStyle.CssClass = "trAgent";
            // grid.RowStyle.CssClass = "TrGameOdd";

            //BoundField TopType = new BoundField();
            //TopType.HeaderText = "";
            //TopType.DataField = "TopType";
            //grid.Columns.Add(TopType);


            BoundField Player = new BoundField();
            Player.HeaderText = "Player";
            Player.DataField = "Player";
            grid.Columns.Add(Player);

            BoundField TotalWin = new BoundField();
            TotalWin.HeaderText = "Total Win";
            TotalWin.DataField = "TotalWin";
            TotalWin.DataFormatString = "{0:N0}";
            grid.Columns.Add(TotalWin);

            BoundField TotalLose = new BoundField();
            TotalLose.HeaderText = "Total Lose";
            TotalLose.DataField = "TotalLose";
            TotalLose.DataFormatString = "{0:N0}";
            grid.Columns.Add(TotalLose);

            BoundField NetPer = new BoundField();
            NetPer.HeaderText = "Net %";
            NetPer.DataField = "NetPer";
            grid.Columns.Add(NetPer);

            BoundField Total = new BoundField();
            Total.HeaderText = "Total";
            Total.DataField = "Total";
            Total.DataFormatString = "{0:N0}";
            grid.Columns.Add(Total);


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
                SqlCommand comm = new SqlCommand("TopPlayerMiniReport", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
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
                    lb.Text = ((DataRowView)container.DataItem)["WagerType"].ToString() + "<br/>" + Convert.ToDateTime(((DataRowView)container.DataItem)["GameDate"].ToString()).ToString("MM-dd hh:mmtt") + "<br/> " + ((DataRowView)container.DataItem)["Sport"].ToString() + " - " + ((DataRowView)container.DataItem)["Description"].ToString();
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


        protected void ddlAgent_DataBound(object sender, EventArgs e)
        {

        }

        protected void ddlAgent_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
