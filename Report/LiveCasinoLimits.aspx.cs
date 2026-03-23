using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.ASP;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

namespace AgentSite4.Report
{
    public partial class LiveCasinoLimits  : BasePage, IRequiresSessionState
    {
		
        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;


        string ViGuser = ConfigurationManager.AppSettings["ViGuser"];
        string Currency = "USD";// ConfigurationManager.AppSettings["Currency"];
        string VigSiteID = ConfigurationManager.AppSettings["VigSiteID"];

        string secretKey = ConfigurationManager.AppSettings["SecretKey"];
        string apiUrl = ConfigurationManager.AppSettings["apiURL"];

        void Page_Init(object sender, System.EventArgs e)
        {
            pnAgent.Visible = Convert.ToBoolean(Session["isDistributor"]);
            loadDistributors();
        }

        void Page_Load(object sender, System.EventArgs e)
        {
            if (!IsPostBack)
            {
                //loadAgensDDL(1, ddlDistributor);

                //loadAgensDDL(0, ddlAgent);
                //changeAgent();
            }
        }

        protected void changeAgent()
        {
            int IdAgent = Convert.ToInt32(Session["SubIdAgent"]);
            if (Convert.ToBoolean(Session["isDistributor"]))
            {
                IdAgent = Convert.ToInt32(ddlAgent.SelectedValue);
                if (IdAgent == -1)
                {
                    IdAgent = Convert.ToInt32(Session["SubIdAgent"]);
                }
            }
            loadPlayers(IdAgent);
        }


        protected void loadPlayers(int IdAgent)
        {
            DataTable players = AddOn_GetPlayerList(IdAgent);
            DataTable playersTable = new DataTable();
            playersTable.Columns.Add("Player", typeof(string));
            playersTable.Columns.Add("DailyMaxLoss", typeof(float));
            playersTable.Columns.Add("DailyMaxWin", typeof(float));
            playersTable.Columns.Add("WeeklyMaxLoss", typeof(float));
            playersTable.Columns.Add("WeeklyMaxWin", typeof(float));
            playersTable.Columns.Add("CSSClass", typeof(string));

            int totalPlayers = players.Rows.Count;
            int playersPerRequest = 19;
            int totalRequests = (int)Math.Ceiling((double)totalPlayers / playersPerRequest);

            for (int i = 0; i < totalRequests; i++)
            {
                int startRow = i * playersPerRequest;
                int endRow = Math.Min(startRow + playersPerRequest, totalPlayers);

                PlayerGetLimitRequest request = new PlayerGetLimitRequest();
                request.Method = "BatchGetPlayerLimitsRequest";
                request.TS = (long)(DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalMilliseconds;
                request.ArgumentList = new PlayerGetLimitRequest.Argument[endRow - startRow];

                for (int j = startRow; j < endRow; j++)
                {
                    DataRow row = players.Rows[j];
                    PlayerGetLimitRequest.Argument arg = new PlayerGetLimitRequest.Argument();
                    arg.ViGuser = ViGuser;
                    arg.username = row["Player"].ToString();
                    arg.currency = Currency;
                    arg.siteID = VigSiteID;
                    request.ArgumentList[j - startRow] = arg;
                }

                string jsonPayload = JsonConvert.SerializeObject(request);
                string response = MakeAPIRequest(jsonPayload);

                Response.Write(jsonPayload);
                Response.Write("<br/>");
                Response.Write(SHA1Hash(secretKey + jsonPayload) + " " + jsonPayload);
                Response.Write("<br/>");
                Response.Write(response);

                try
                {
                    JObject jsonResponse = JObject.Parse(response);

                    JArray playersResponse = (JArray)jsonResponse["BatchGetPlayerLimitsResponse"];

                    for (int j = 0; j < playersResponse.Count; j++)
                    {
                        JObject playerResponseJObject = (JObject)playersResponse[j];
                        BatchGetPlayerLimitsResponse playerResponse = playerResponseJObject.ToObject<BatchGetPlayerLimitsResponse>();

                        string username;
                        float dailyMaxLoss;
                        float dailyMaxWin;
                        float weeklyMaxLoss;
                        float weeklyMaxWin;

                        if (playerResponse.Status == "OK" && playerResponse.Exists == "no")
                        {
                            username = request.ArgumentList[j].username;
                            dailyMaxLoss = 0;
                            dailyMaxWin = 0;
                            weeklyMaxLoss = 0;
                            weeklyMaxWin = 0;
                            DataRow newRow = playersTable.NewRow();
                            newRow["Player"] = username;
                            newRow["DailyMaxLoss"] = dailyMaxLoss;
                            newRow["DailyMaxWin"] = dailyMaxWin;
                            newRow["WeeklyMaxLoss"] = weeklyMaxLoss;
                            newRow["WeeklyMaxWin"] = weeklyMaxWin;
                            newRow["CSSClass"] = "newPlayer";
                            playersTable.Rows.Add(newRow);
                        }
                        else
                        {
                            username = playerResponse.Username;
                            dailyMaxLoss = playerResponse.DailyMaxLoss;
                            dailyMaxWin = playerResponse.DailyMaxWin;
                            weeklyMaxLoss = playerResponse.WeeklyMaxLoss;
                            weeklyMaxWin = playerResponse.WeeklyMaxWin;

                            playersTable.Rows.Add(username, dailyMaxLoss, dailyMaxWin, weeklyMaxLoss, weeklyMaxWin);
                        }
                    }
                }
                catch (Exception e)
                {
                    Response.Write(e.Message);
                }


            }

            string data = JsonConvert.SerializeObject(playersTable);
            //Response.Write(data);
            GridView1.DataSource = playersTable;
            GridView1.DataBind();
        }


        protected void setPlayerLimits()
        {
            List<PlayerSetLimitRequest.Argument> modifiedPlayers = new List<PlayerSetLimitRequest.Argument>();
            foreach (GridViewRow row in GridView1.Rows)
            {
                HiddenField hfRowModified = (HiddenField)row.FindControl("hfRowModified");
                if (hfRowModified.Value == "modified")
                {
                    string player = row.Cells[0].Text;
                    TextBox txtDailyMaxLoss = (TextBox)row.FindControl("txtDailyMaxLoss");
                    TextBox txtDailyMaxWin = (TextBox)row.FindControl("txtDailyMaxWin");
                    TextBox txtWeeklyMaxLoss = (TextBox)row.FindControl("txtWeeklyMaxLoss");
                    TextBox txtWeeklyMaxWin = (TextBox)row.FindControl("txtWeeklyMaxWin");

                    float dailyMaxLoss = float.Parse(txtDailyMaxLoss.Text);
                    float dailyMaxWin = float.Parse(txtDailyMaxWin.Text);
                    float weeklyMaxLoss = float.Parse(txtWeeklyMaxLoss.Text);
                    float weeklyMaxWin = float.Parse(txtWeeklyMaxWin.Text);

                    PlayerSetLimitRequest.Argument arg = new PlayerSetLimitRequest.Argument();
                    arg.ViGuser = ViGuser;
                    arg.username = player;
                    arg.currency = Currency;
                    arg.siteID = VigSiteID;
                    arg.DailyMaxLoss = dailyMaxLoss;
                    arg.DailyMaxWin = dailyMaxWin;
                    arg.WeeklyMaxLoss = weeklyMaxLoss;
                    arg.WeeklyMaxWin = weeklyMaxWin;

                    modifiedPlayers.Add(arg);
                    hfRowModified.Value = "";
                }
            }

            Response.Write(JsonConvert.SerializeObject(modifiedPlayers));
            int batchSize = 19;
            for (int i = 0; i < modifiedPlayers.Count; i += batchSize)
            {
                PlayerSetLimitRequest request = new PlayerSetLimitRequest();
                request.Method = "BatchSetPlayerLimitsRequest";
                request.TS = (long)(DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalMilliseconds;

                int currentBatchSize = Math.Min(batchSize, modifiedPlayers.Count - i);
                request.ArgumentList = new PlayerSetLimitRequest.Argument[currentBatchSize];
                for (int j = 0; j < currentBatchSize; j++)
                {
                    request.ArgumentList[j] = modifiedPlayers[i + j];
                }

                string jsonPayload = JsonConvert.SerializeObject(request);
                string response = MakeAPIRequest(jsonPayload);
                Response.Write(jsonPayload);
                Response.Write("<br/>");
                Response.Write(SHA1Hash(secretKey + jsonPayload) + " " + jsonPayload);
                Response.Write("<br/>");
                Response.Write(response);
            }
        }

        protected void setPlayerLimits(int rowIndex)
        {
            GridViewRow row = GridView1.Rows[rowIndex];

            string player = row.Cells[0].Text;
            TextBox txtDailyMaxLoss = (TextBox)row.FindControl("txtDailyMaxLoss");
            TextBox txtDailyMaxWin = (TextBox)row.FindControl("txtDailyMaxWin");
            TextBox txtWeeklyMaxLoss = (TextBox)row.FindControl("txtWeeklyMaxLoss");
            TextBox txtWeeklyMaxWin = (TextBox)row.FindControl("txtWeeklyMaxWin");

            float dailyMaxLoss = float.Parse(txtDailyMaxLoss.Text);
            float dailyMaxWin = float.Parse(txtDailyMaxWin.Text);
            float weeklyMaxLoss = float.Parse(txtWeeklyMaxLoss.Text);
            float weeklyMaxWin = float.Parse(txtWeeklyMaxWin.Text);

            PlayerSetLimitRequest request = new PlayerSetLimitRequest();
            request.Method = "BatchSetPlayerLimitsRequest";
            request.TS = (long)(DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalMilliseconds;
            request.ArgumentList = new PlayerSetLimitRequest.Argument[1];

            PlayerSetLimitRequest.Argument arg = new PlayerSetLimitRequest.Argument();
            arg.ViGuser = ViGuser;
            arg.username = player;
            arg.currency = Currency;
            arg.siteID = VigSiteID;
            arg.DailyMaxLoss = dailyMaxLoss;
            arg.DailyMaxWin = dailyMaxWin;
            arg.WeeklyMaxLoss = weeklyMaxLoss;
            arg.WeeklyMaxWin = weeklyMaxWin;

            request.ArgumentList[0] = arg;

            string jsonPayload = JsonConvert.SerializeObject(request);

            string response = MakeAPIRequest(jsonPayload);

            Response.Write(jsonPayload);
            Response.Write("<br/>");
            Response.Write(SHA1Hash(secretKey + jsonPayload) + " " + jsonPayload);
            Response.Write("<br/>");
            Response.Write(response);
        }


        protected DataTable AddOn_GetPlayerList(int idAgent)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            DataTable table = new DataTable();
            try
            {

                Cnn.Open();
                SqlCommand comm = new SqlCommand("AddOn_GetPlayerList", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
                table.Load(reader);
            }
            catch (Exception myErr)
            {
                Response.Write(myErr.Message);
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            return table;
        }

        protected void loadDistributors()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                int prmIdAgent = Convert.ToInt32(this.Session["SubIdAgent"].ToString());

                SqlCommand comm1 = new SqlCommand("Agent_GetAgentsOrDistributors", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm1.Parameters.Add("@idAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm1.Parameters.Add("@IsDistributor", SqlDbType.Bit)).Value = 1;

                SqlDataReader reader;
                reader = comm1.ExecuteReader();
                ListItem newItem = new ListItem();
                {
                    newItem = new ListItem();
                    newItem.Value = this.Session["IdAgent"].ToString();
                    newItem.Text = this.Session["Agent"].ToString();
                    ddlDistributor.Items.Add(newItem);
                }
                while (reader.Read())
                {
                    newItem = new ListItem();
                    newItem.Value = reader["IdAgent"].ToString();
                    newItem.Text = reader["AGENT"].ToString();
                    ddlDistributor.Items.Add(newItem);
                }

            }
            catch (Exception e)
            {
                lblError.Text = e.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

        }


        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView rowView = (DataRowView)e.Row.DataItem;
                if (rowView["CSSClass"] != null && rowView["CSSClass"].ToString() == "newPlayer")
                {
                    e.Row.CssClass = "newPlayer";
                }
            }
        }


        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            int IdAgent = Convert.ToInt32(ddlAgent.SelectedValue);
            loadPlayers(IdAgent);
        }


        protected void ddlAgent_SelectedIndexChanged(object sender, EventArgs e)
        {
            int IdAgent = Convert.ToInt32(ddlAgent.SelectedValue);
            loadPlayers(IdAgent);
        }

        protected void btnSaveAll_Command(object sender, CommandEventArgs e)
        {
            setPlayerLimits();
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SaveLimits")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                setPlayerLimits(rowIndex);
            }
        }
        protected void ddlDistributor_SelectedIndexChanged(object sender, EventArgs e)
        {
            //loadAgensDDL(0, ddlAgent);
            //int idAgent = Convert.ToInt32(ddlAgent.SelectedValue);
            //loadPlayers(idAgent);
            //changeAgent();
        }

        private void ApplyValueToAllRows(string headerControlId, string rowControlId)
        {
            ContentPlaceHolder contentPlaceHolder = (ContentPlaceHolder)Page.Master.FindControl("MainContent");
            TextBox headerTextBox = (TextBox)contentPlaceHolder.FindControl(headerControlId);
            float value;
            if (float.TryParse(headerTextBox.Text, out value))
            {
                foreach (GridViewRow row in GridView1.Rows)
                {
                    TextBox rowTextBox = (TextBox)row.FindControl(rowControlId);
                    rowTextBox.Text = value.ToString();
                }
            }
        }

        protected void ApplyToAllDailyMaxLoss(object sender, EventArgs e)
        {
            ApplyValueToAllRows("txtAllDailyMaxLoss", "txtDailyMaxLoss");
        }

        protected void ApplyToAllDailyMaxWin(object sender, EventArgs e)
        {
            ApplyValueToAllRows("txtAllDailyMaxWin", "txtDailyMaxWin");
        }

        protected void ApplyToAllWeeklyMaxLoss(object sender, EventArgs e)
        {
            ApplyValueToAllRows("txtAllWeeklyMaxLoss", "txtWeeklyMaxLoss");
        }

        protected void ApplyToAllWeeklyMaxWin(object sender, EventArgs e)
        {
            ApplyValueToAllRows("txtAllWeeklyMaxWin", "txtWeeklyMaxWin");
        }

        protected void ApplyAllValues(object sender, EventArgs e)
        {
            ApplyToAllDailyMaxLoss(sender, e);
            ApplyToAllDailyMaxWin(sender, e);
            ApplyToAllWeeklyMaxLoss(sender, e);
            ApplyToAllWeeklyMaxWin(sender, e);
        }

        protected string MakeAPIRequest(string jsonPayload)
        {
            WebRequest httpWebRequest = WebRequest.Create(apiUrl);
            httpWebRequest.Method = "POST";
            httpWebRequest.ContentType = "application/json";

            string requestEncripted = SHA1Hash(secretKey + jsonPayload) + " " + jsonPayload;

            using (StreamWriter streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
            {
                streamWriter.Write(requestEncripted);
                streamWriter.Close();

                using (StreamReader streamReader = new StreamReader(httpWebRequest.GetResponse().GetResponseStream()))
                {
                    return streamReader.ReadToEnd();
                }
            }
        }

        public static string SHA1Hash(string text)
        {
            SHA1 sha1 = SHA1Managed.Create();
            ASCIIEncoding encoding = new ASCIIEncoding();
            byte[] stream = null;
            StringBuilder sb = new StringBuilder();
            stream = sha1.ComputeHash(encoding.GetBytes(text));
            for (int i = 0; i < stream.Length; i++)
            {
                sb.AppendFormat("{0:x2}", stream[i]);
            }
            string str = sb.ToString();
            return str;
        }

        public class PlayerGetLimitRequest
        {
            private string _method;
            private long _ts;
            private Argument[] _argumentList;

            public string Method
            {
                get { return _method; }
                set { _method = value; }
            }

            public long TS
            {
                get { return _ts; }
                set { _ts = value; }
            }

            public Argument[] ArgumentList
            {
                get { return _argumentList; }
                set { _argumentList = value; }
            }

            public class Argument
            {
                private string _viGuser;
                private string _username;
                private string _currency;
                private string _siteID;

                public string ViGuser
                {
                    get { return _viGuser; }
                    set { _viGuser = value; }
                }

                public string username
                {
                    get { return _username; }
                    set { _username = value; }
                }

                public string currency
                {
                    get { return _currency; }
                    set { _currency = value; }
                }

                public string siteID
                {
                    get { return _siteID; }
                    set { _siteID = value; }
                }
            }
        }

        public class PlayerSetLimitRequest
        {
            private string _method;
            private long _ts;
            private Argument[] _argumentList;

            public string Method
            {
                get { return _method; }
                set { _method = value; }
            }

            public long TS
            {
                get { return _ts; }
                set { _ts = value; }
            }

            public Argument[] ArgumentList
            {
                get { return _argumentList; }
                set { _argumentList = value; }
            }

            public class Argument
            {
                private string _viGuser;
                private string _username;
                private string _currency;
                private string _siteID;
                private float _dailyMaxLoss;
                private float _dailyMaxWin;
                private float _weeklyMaxLoss;
                private float _weeklyMaxWin;

                public string ViGuser
                {
                    get { return _viGuser; }
                    set { _viGuser = value; }
                }

                public string username
                {
                    get { return _username; }
                    set { _username = value; }
                }

                public string currency
                {
                    get { return _currency; }
                    set { _currency = value; }
                }

                public string siteID
                {
                    get { return _siteID; }
                    set { _siteID = value; }
                }

                public float DailyMaxLoss
                {
                    get { return _dailyMaxLoss; }
                    set { _dailyMaxLoss = value; }
                }

                public float DailyMaxWin
                {
                    get { return _dailyMaxWin; }
                    set { _dailyMaxWin = value; }
                }

                public float WeeklyMaxLoss
                {
                    get { return _weeklyMaxLoss; }
                    set { _weeklyMaxLoss = value; }
                }

                public float WeeklyMaxWin
                {
                    get { return _weeklyMaxWin; }
                    set { _weeklyMaxWin = value; }
                }
            }
        }

        public class BatchGetPlayerLimitsResponse
        {
            private string _status;
            private string _exists;
            private string _description;
            private int _dailyMaxLoss;
            private int _dailyMaxWin;
            private int _weeklyMaxLoss;
            private int _weeklyMaxWin;
            private string _username;
            private string _siteID;
            private string _currency;

            public string Status
            {
                get { return _status; }
                set { _status = value; }
            }

            public string Exists
            {
                get { return _exists; }
                set { _exists = value; }
            }

            public string Description
            {
                get { return _description; }
                set { _description = value; }
            }

            public int DailyMaxLoss
            {
                get { return _dailyMaxLoss; }
                set { _dailyMaxLoss = value; }
            }

            public int DailyMaxWin
            {
                get { return _dailyMaxWin; }
                set { _dailyMaxWin = value; }
            }

            public int WeeklyMaxLoss
            {
                get { return _weeklyMaxLoss; }
                set { _weeklyMaxLoss = value; }
            }

            public int WeeklyMaxWin
            {
                get { return _weeklyMaxWin; }
                set { _weeklyMaxWin = value; }
            }

            public string Username
            {
                get { return _username; }
                set { _username = value; }
            }

            public string SiteID
            {
                get { return _siteID; }
                set { _siteID = value; }
            }

            public string Currency
            {
                get { return _currency; }
                set { _currency = value; }
            }
        }



        protected void ddlAgent_DataBound(object sender, EventArgs e)
        {
            int IdAgent = Convert.ToInt32(ddlAgent.SelectedValue);
            loadPlayers(IdAgent);
        }
    }
}
