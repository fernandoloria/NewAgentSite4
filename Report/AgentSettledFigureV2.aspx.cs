using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;

namespace AgentSite4.Report
{
    public partial class AgentSettledFigureV2  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            if (GridView1.Rows.Count < 1)
            {
                lblError.Text = "This Agent has no players";
            }
            else
            {
                lblError.Text = "";
            }

            try
            {
                GridView1.HeaderRow.Visible = false;
            }
            catch { }

            foreach (GridViewRow r in GridView1.Rows)
            {
                int lastIndexColumn = GridView1.Columns.Count - 1;
                if (r.Cells[lastIndexColumn].Text == "0")
                {
                    string AgentName = "<div class='portlet-title'><h4>" + r.Cells[0].Text + "</h4></div>" +
                    "<tr class='GameHeader'><th scope='col'>Player</th><th scope='col'>Settled Figure</th><th scope='col'>Current Balance</th><th scope='col'>Balance</th>";
                    r.Cells[0].Text = AgentName;
                    r.Cells[0].ColumnSpan = GridView1.Columns.Count;
                    // r.Cells[0].CssClass = "portlet-title";

                    r.Cells[1].Visible = false;
                    r.Cells[2].Visible = false;
                    r.Cells[3].Visible = false;
                    r.Cells[lastIndexColumn].Visible = false;

                }
                else
                {
                    r.Cells[lastIndexColumn].Visible = false;
                }
            }


        }
    }
}
