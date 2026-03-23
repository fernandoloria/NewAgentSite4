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
using AgentSite4.cASEnums;

namespace AgentSite4.Report
{
    public partial class ManageFreePlayByLeague  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Common.HasRights(ReportPosition.MANAGEFREEPLAYBYLEAGUE))
            {
                Response.End();
            }


        }


        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            foreach (GridViewRow linea in GridView1.Rows)
            {
                CheckBox chk = ((CheckBox)linea.Cells[2].FindControl("CheckBox1"));
                chk.Text = chk.Checked ? "Denied" : "Allowed";
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
                    string AgentName = "<div class='sportTitle portlet-title'><h4>" + ((HiddenField)r.Cells[0].FindControl("HiddenField2")).Value + "</h4><input type='checkbox' class='hideAll'/> Allow all | <input type='checkbox' class='showAll'/> Deny all</div>" +
                    "<tr class='GameHeader'><th scope='col'>Sport</th><th scope='col'>League</th><th scope='col'>Allow/Deny</th></tr>";
                    r.Cells[0].Text = AgentName;
                    r.Cells[0].ColumnSpan = GridView1.Columns.Count;
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

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int indexGrid = Convert.ToInt32(e.CommandArgument);
            GridViewRow GridViewR = GridView1.Rows[indexGrid];

            if (e.CommandName == "btnSave")
            {
                int idLeague = Convert.ToInt32(((HiddenField)GridViewR.Cells[0].FindControl("HiddenField1")).Value);
                bool enable = ((CheckBox)GridViewR.Cells[2].FindControl("CheckBox1")).Checked;

            }

        }

        protected void ManageFreePlayByLeague_Insert(int idLeague, bool deny)
        {
            int idAgent = Convert.ToInt32(ddlAgents.SelectedValue);
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            using (SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                Cnn.Open();
                try
                {
                    SqlCommand comm = new SqlCommand("ManageFreePlayByLeague_Insert", Cnn);
                    comm.CommandType = CommandType.StoredProcedure;

                    comm.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = idAgent;
                    comm.Parameters.Add("@prmidLeague", SqlDbType.Int).Value = idLeague;
                    comm.Parameters.Add("@prmDeny", SqlDbType.Bit).Value = deny;

                    comm.ExecuteNonQuery();
                }
                catch (Exception myErr)
                {

                }
                finally
                {
                    GridView1.DataBind();
                }
            }
        }


        protected void ddlAgents_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }

        protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
        {

        }

        protected void CheckBox1_CheckedChanged1(object sender, EventArgs e)
        {
            GridViewRow gr = (GridViewRow)((DataControlFieldCell)((CheckBox)sender).Parent).Parent;
            int idLeague = Convert.ToInt32(((HiddenField)gr.Cells[0].FindControl("HiddenField1")).Value);
            bool enable = ((CheckBox)gr.Cells[2].FindControl("CheckBox1")).Checked;
            ManageFreePlayByLeague_Insert(idLeague, enable);


        }

    }
}
