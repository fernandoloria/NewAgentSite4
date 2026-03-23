using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace AgentSite4.Services
{
    /// <summary>
    /// Summary description for GetTree
    /// </summary>
    public class GetTree : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            string subIdAgent = context.Session["IdAgent"].ToString();
            string dgsAddOnsConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            DataTable agentTable = new DataTable();
            DataTable playerTable = new DataTable();

            using (SqlConnection cnn = new SqlConnection(dgsAddOnsConnectionString))
            {
                using (SqlCommand comm = new SqlCommand("GetAgentsByIdAgent", cnn))
                {
                    comm.CommandType = CommandType.StoredProcedure;
                    comm.Parameters.AddWithValue("@prmIdAgent", subIdAgent);
                    cnn.Open();
                    using (SqlDataReader reader = comm.ExecuteReader())
                    {
                        agentTable.Load(reader);
                    }
                    cnn.Close();
                }

                using (SqlCommand comm = new SqlCommand("GetPlayersByIdAgent", cnn))
                {
                    comm.CommandType = CommandType.StoredProcedure;
                    comm.Parameters.AddWithValue("@prmIdAgent", subIdAgent);
                    cnn.Open();
                    using (SqlDataReader reader = comm.ExecuteReader())
                    {
                        playerTable.Load(reader);
                    }
                    cnn.Close();
                }
            }

            List<AgentNode> tree = BuildTree(agentTable, playerTable);

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

        private List<AgentNode> BuildTree(DataTable agentTable, DataTable playerTable)
        {
            var agents = agentTable.AsEnumerable().Select(row => new AgentNode
            {
                IdAgent = row.Field<int>("idAgent"),
                Agent = row.Field<string>("Agent"),
                Password = row.Field<string>("Password"),
                Enable = row.Field<bool>("Enable"),
                Distributor = row.Field<int?>("Distributor"),
                IsDistributor = row.Field<bool>("IsDistributor"),
                AgentLevel = row.Field<int>("Agentlevel"),
                Players = new List<PlayerNode>()
            }).ToList();

            var players = playerTable.AsEnumerable().Select(row => new PlayerNode
            {
                IdPlayer = row.Field<int>("IdPlayer"),
                IdAgent = row.Field<int>("IdAgent"),
                Player = row.Field<string>("Player"),
                Name = row.Field<string>("Name"),
                OnlinePassword = row.Field<string>("OnlinePassword")
            }).ToList();

            var agentDict = agents.ToDictionary(agent => agent.IdAgent);
            var tree = new List<AgentNode>();

            foreach (var agent in agents)
            {
                if (agent.AgentLevel == 1)
                {
                    tree.Add(agent);
                }
                else if (agent.Distributor.HasValue && agentDict.TryGetValue(agent.Distributor.Value, out var parentAgent))
                {
                    parentAgent.Children.Add(agent);
                }

                if (!agent.IsDistributor)
                {
                    agent.Players.AddRange(players.Where(player => player.IdAgent == agent.IdAgent));
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
            public int? Distributor { get; set; }
            public bool IsDistributor { get; set; }
            public int AgentLevel { get; set; }
            public List<AgentNode> Children { get; set; } = new List<AgentNode>();
            public List<PlayerNode> Players { get; set; } = new List<PlayerNode>();
        }

        public class PlayerNode
        {
            public int IdPlayer { get; set; }
            public int IdAgent { get; set; }
            public string Player { get; set; }
            public string Name { get; set; }
            public string OnlinePassword { get; set; }
        }

        public class ErrorResponse
        {
            public string Error { get; set; }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
