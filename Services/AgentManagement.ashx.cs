using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using DGSinterface;
using System.Web.SessionState;

namespace AgentSite4.Services
{
    /// <summary>
    /// Summary description for AgentManagement
    /// </summary>
    public class AgentManagement : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            string subIdAgent = context.Session["SubIdAgent"].ToString();
            string dgsAddOnsConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            DataTable table = new DataTable();

            using (SqlConnection cnn = new SqlConnection(dgsAddOnsConnectionString))
            using (SqlCommand comm = new SqlCommand("AgentManagementV2_Get", cnn))
            {
                comm.CommandType = CommandType.StoredProcedure;
                comm.Parameters.AddWithValue("@prmIDAgent", subIdAgent);

                cnn.Open();

                using (SqlDataReader reader = comm.ExecuteReader())
                {
                    table.Load(reader);
                }
            }

            List<AgentNode> tree = BuildTree(table);

            context.Response.ContentType = "application/json";
            try
            {
                context.Response.Write(JsonConvert.SerializeObject(tree, Formatting.None));
            }
            catch (Exception ex)
            {
                ErrorResponse errorResponse = new ErrorResponse();
                errorResponse.Error = ex.Message;
                context.Response.Write(JsonConvert.SerializeObject(errorResponse, Formatting.None));
            }
        }

        private List<AgentNode> BuildTree(DataTable table)
        {
            var nodes = table.AsEnumerable().Select(row => new AgentNode
            {
                IdAgent = row.Field<int>("idAgent"),
                Agent = row.Field<string>("Agent"),
                Password = row.Field<string>("Password"),
                Enable = row.Field<bool>("enable"),
                OnlineAccess = row.Field<bool>("OnlineAccess"),
                IdAgentType = row.Field<byte>("IdAgentType"),
                AgentType = row.Field<string>("AgentType"),
                Distributor = row.Field<int?>("Distributor"),
                IsDistributor = row.Field<bool>("IsDistributor"),
                DontXferPlayerActivity = row.Field<bool>("DontXferPlayerActivity"),
                CommSports = row.Field<byte>("CommSports"),
                CurrentBalance = row.Field<decimal>("CurrentBalance"),
                ThisWeek = row.Field<decimal?>("ThisWeek"),
                LastWeek = row.Field<decimal?>("LastWeek"),
                MakeUp = row.Field<decimal>("MakeUp"),
                AgentLevel = row.Field<int>("AgentLevel")
            }).ToList();

            var nodeDict = nodes.ToDictionary(node => node.IdAgent);
            var tree = new List<AgentNode>();

            foreach (var node in nodes)
            {
                if (node.AgentLevel == 1)
                {
                    tree.Add(node);
                }
                else if (node.Distributor.HasValue && nodeDict.TryGetValue(node.Distributor.Value, out var parentNode))
                {
                    parentNode.Children.Add(node);
                }
            }

            return tree;
        }



        public class AgentNode
        {
            public int IdAgent { get; set; }
            public string Agent { get; set; }
            public string Password { get; set; }
            public bool Enable { get; set; }
            public bool OnlineAccess { get; set; }
            public byte IdAgentType { get; set; }
            public string AgentType { get; set; }
            public int? Distributor { get; set; }
            public bool IsDistributor { get; set; }
            public bool DontXferPlayerActivity { get; set; }
            public byte CommSports { get; set; }
            public decimal CurrentBalance { get; set; }
            public decimal? ThisWeek { get; set; }
            public decimal? LastWeek { get; set; }
            public decimal MakeUp { get; set; }
            public int AgentLevel { get; set; }

            public List<AgentNode> Children { get; set; } = new List<AgentNode>();
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