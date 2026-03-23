using AgentSite4.ASP;
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

namespace AgentSite4.Report
{
    public partial class PlayerManagement : BasePage, IRequiresSessionState
    {

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                AddOn_Agent_GetAgents();
            }

        }

        protected void AddOn_Agent_GetAgents()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            try
            {
                int prmIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
                List<string> encryptedIds = new List<string>();

                using (SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString))
                {
                    Cnn.Open();

                    using (SqlCommand comm1 = new SqlCommand("AddOn_Agent_GetAgents", Cnn))
                    {
                        comm1.CommandType = CommandType.StoredProcedure;
                        comm1.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = prmIdAgent;

                        using (SqlDataReader reader = comm1.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                int idAgent = reader.GetInt32(reader.GetOrdinal("IdAgent"));
                                string timestamp = DateTime.UtcNow.ToString("yyyyMMddHHmmssfff");
                                string idToEncrypt = $"{idAgent}_{timestamp}";
                                string encryptedId = cASEnums.Encrypt.EncryptString(idToEncrypt);
                                encryptedIds.Add(encryptedId);
                            }
                        }
                    }
                }

                hdfAccounts.Value = string.Join(",", encryptedIds.ToArray());
            }
            catch (Exception e)
            {
                // Manejar excepción según sea necesario
            }
        }

    }
}