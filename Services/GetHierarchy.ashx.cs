using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using System.Xml;
using Newtonsoft.Json;
using Formatting = Newtonsoft.Json.Formatting;
using DGSinterface;

namespace AgentSite4.Services
{
    /// <summary>
    /// Summary description for GetHierarchy
    /// </summary>
    public class GetHierarchy : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            string subIdAgent = context.Session["SubIdAgent"].ToString();
            string idAgent = context.Session["IdAgent"].ToString();
            string dgsAddOnsConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            DataTable table = new DataTable();

            if (context.Session["GetHierarchy"] == null)
            {
                using (SqlConnection cnn = new SqlConnection(dgsAddOnsConnectionString))
                using (SqlCommand comm = new SqlCommand("GetHierarchy", cnn))
                {
                    comm.CommandType = CommandType.StoredProcedure;
                    comm.Parameters.AddWithValue("@prmIdAgent", idAgent);

                    cnn.Open();

                    using (SqlDataReader reader = comm.ExecuteReader())
                    {
                        table.Load(reader);
                    }

                    if (idAgent != subIdAgent)
                    {
                        DataRow newRow = table.NewRow();
                        newRow["Id"] = idAgent;
                        newRow["Account"] = context.Session["Agent"];
                        newRow["Type"] = "D";
                        newRow["Name"] = "";
                        newRow["password"] = "";

                        table.Rows.InsertAt(newRow, 0);

                    }

                    context.Session["GetHierarchy"] = table;
                }
            }
            else
            {
                table = (DataTable)context.Session["GetHierarchy"];
            }

            context.Response.ContentType = "application/json";
            try
            {
                context.Response.Write(JsonConvert.SerializeObject(table, Formatting.None));
            }
            catch (Exception ex)
            {
                ErrorResponse errorResponse = new ErrorResponse();
                errorResponse.Error = ex.Message;
                context.Response.Write(JsonConvert.SerializeObject(errorResponse, Formatting.None));
            }
        }

        

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}