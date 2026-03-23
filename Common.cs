using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace AgentSite4
{
    public class Common
    {
        public static bool HasRights(ulong right)
        {
            return true;
            //bool flag = false;
            //ulong num1 = (ulong)HttpContext.Current.Session["AgentRights"];
            //ulong num2 = (ulong)HttpContext.Current.Session["AgentRights"];
            //if (((long)num1 & (long)right) == (long)right)
            //    flag = true;
            //else if (((long)num2 & (long)right) == (long)right)
            //    flag = true;
            //return flag;
        }

        public static bool HasRights(string rightDescription)
        {
            return true;
            long prmIdAgent = long.Parse(HttpContext.Current.Session["IdAgent"].ToString());
            bool hasRights = false;
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                SqlCommand comm1 = new SqlCommand("AddOn_AgentRights_GetRights_Description", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm1.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm1.Parameters.Add("@prmDescription", SqlDbType.VarChar)).Value = rightDescription;
                SqlDataReader reader = comm1.ExecuteReader();
                DataTable table = new DataTable();
                table.Load(reader);
                if (table.Rows.Count > 0)
                {
                    hasRights = Convert.ToBoolean(table.Rows[0]["hasRight"]);
                }
            }
            catch
            {
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            return hasRights;
        }

        public static string GetClientIP()
        {
            HttpRequest request = HttpContext.Current.Request;
            string list = request.UserHostAddress;
            string serverVariable1 = request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            string serverVariable2 = request.ServerVariables["HTTP_CLIENT_IP"];
            if (serverVariable1 != null || serverVariable2 != null)
            {
                Regex regex = new Regex("(\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})");
                if (serverVariable1 != null)
                    list = Common.AppendIPs(regex.Matches(serverVariable1), list);
                if (serverVariable2 != null)
                    list = Common.AppendIPs(regex.Matches(serverVariable2), list);
            }
            return list;
        }

        private static string AppendIPs(MatchCollection col, string list)
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