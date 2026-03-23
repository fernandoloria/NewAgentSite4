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
    public partial class HiddenLeagues  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            foreach (GridViewRow linea in GridView1.Rows)
            {
                CheckBox chk = ((CheckBox)linea.Cells[2].FindControl("CheckBox1"));
                chk.Text = chk.Checked ? "Enabled" : "Disabled";
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
                    string AgentName = "<div class='sportTitle portlet-title'><h4>" + ((HiddenField)r.Cells[0].FindControl("HiddenField2")).Value + "</h4><input type='checkbox' class='hideAll'/> Hide all | <input type='checkbox' class='showAll'/> Show all</div>" +
                    "<tr class='page-titles'><th scope='col'>Sport</th><th scope='col'>League</th><th scope='col'>active</th></tr>";
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

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int indexGrid = Convert.ToInt32(e.CommandArgument);
            GridViewRow GridViewR = GridView1.Rows[indexGrid];

            if (e.CommandName == "btnSave")
            {
                int idLeague = Convert.ToInt32(((HiddenField)GridViewR.Cells[0].FindControl("HiddenField1")).Value);
                bool enable = ((CheckBox)GridViewR.Cells[2].FindControl("CheckBox1")).Checked;
                //saveLimit(idLeague, enable);
            }

        }

        protected void saveLimit(int idLeague, bool enable, int idLineType)
        {
            int idAgent = Convert.ToInt32(ddlAgents.SelectedValue);
            //int idLineType = Convert.ToInt32(ddlLineTypes.SelectedValue);

            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();

            try
            {
                SqlCommand comm = new SqlCommand("AddOn_AgentLeagues_HideShowLeagues", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@idAgent", SqlDbType.Int)).Value = idAgent;
                ((SqlParameter)comm.Parameters.Add("@idLeague", SqlDbType.Int)).Value = idLeague;
                ((SqlParameter)comm.Parameters.Add("@idLineType", SqlDbType.Int)).Value = idLineType;
                ((SqlParameter)comm.Parameters.Add("@enable", SqlDbType.Bit)).Value = enable;

                SqlDataReader reader;
                reader = comm.ExecuteReader();

            }
            catch (Exception myErr)
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
                GridView1.DataBind();
            }
        }

        protected void ddlAgents_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }

        protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
        {
            string nano = "";

        }

        protected void CheckBox1_CheckedChanged1(object sender, EventArgs e)
        {
            GridViewRow gr = (GridViewRow)((DataControlFieldCell)((CheckBox)sender).Parent).Parent;
            int idLeague = Convert.ToInt32(((HiddenField)gr.Cells[0].FindControl("HiddenField1")).Value);
            bool enable = ((CheckBox)gr.Cells[2].FindControl("CheckBox1")).Checked;
            //saveLimit(idLineType, enable);
            if (chkAppyLineType.Checked)
            {
                foreach (ListItem item in ddlLineTypes.Items)
                {
                    int idLineType = Convert.ToInt32(item.Value);
                    saveLimit(idLeague, enable, idLineType);
                }
            }
            else
            {
                int idLineType = Convert.ToInt32(ddlLineTypes.SelectedValue);
                saveLimit(idLeague, enable, idLineType);
            }

        }

        protected void chkAppyLineType_CheckedChanged(object sender, EventArgs e)
        {
            ddlLineTypes.Enabled = !chkAppyLineType.Checked;
            GridView1.DataBind();
        }
    }
}
