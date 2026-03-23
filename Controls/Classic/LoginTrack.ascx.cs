using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Text.RegularExpressions;
using DGSinterface;
using System.Web.Services.Description;

namespace AgentSite4.Controls
{
    public partial class LoginTrack : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TrackSession();
        }

        protected void TrackSession()
        {
            if (Session["LastAction"] != null)
            {
                DateTime lastAction = (DateTime)Session["LastAction"];
                if (DateTime.Now > lastAction.AddMinutes(2))
                {
                    UpdateSession(false); 
                   
                }
            }
            else
            {
                InsertSession(); 
            }
        }

        protected void InsertSession()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            DateTime lastAction = DateTime.Now;
            try
            {
                using (SqlConnection conn = new SqlConnection(DGS_AddOnsConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("InsertAgentLogon", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.AddWithValue("@prmIdAgent", Session["IdAgent"]);
                        cmd.Parameters.AddWithValue("@prmIP", GetIP());
                        cmd.Parameters.AddWithValue("@prmURL", Request.Url.AbsoluteUri);
                        cmd.Parameters.AddWithValue("@prmLoginDate", lastAction);
                        cmd.Parameters.AddWithValue("@prmLastAction", lastAction);

                        SqlParameter outputId = new SqlParameter("@outIdAgentLogons", SqlDbType.Int)
                        {
                            Direction = ParameterDirection.Output
                        };
                        cmd.Parameters.Add(outputId);

                        conn.Open();
                        cmd.ExecuteNonQuery();

                        Session["IdAgentLogons"] = (int)outputId.Value;
                        Session["LastAction"] = lastAction;
                    }
                }
            }
            catch { }
        }

        protected void UpdateSession(bool logoff)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            DateTime lastAction = DateTime.Now;
            try
            {
                using (SqlConnection conn = new SqlConnection(DGS_AddOnsConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("AGENTLOGONS_Update", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.AddWithValue("@prmIdAgentLogons", Session["IdAgentLogons"]);
                        cmd.Parameters.AddWithValue("@prmLastAction", lastAction);
                        cmd.Parameters.AddWithValue("@prmLogoff", logoff);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                        Session["LastAction"] = lastAction;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Ocurrió un error en la operación: " + ex.Message, ex);
            }
        }

        protected string GetIP()
        {
            HttpRequest request = HttpContext.Current.Request;
            string list = request.UserHostAddress;
            string serverVariable1 = request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            string serverVariable2 = request.ServerVariables["HTTP_CLIENT_IP"];
            if (serverVariable1 != null || serverVariable2 != null)
            {
                Regex regex = new Regex("(\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})");
                if (serverVariable1 != null)
                    list = AppendIPs(regex.Matches(serverVariable1), list);
                if (serverVariable2 != null)
                    list = AppendIPs(regex.Matches(serverVariable2), list);
            }
            return list;
        }

        protected string AppendIPs(MatchCollection col, string list)
        {
            string str = list;
            for (int index = 0; index < col.Count; ++index)
            {
                if (str != string.Empty && str != null)
                    str += ",";
                str += col[index].Value;
            }
            return str;
        }
    }
    

}

