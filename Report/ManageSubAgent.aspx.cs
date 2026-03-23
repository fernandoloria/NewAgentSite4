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
using DGSinterface;
using System.IO;
using System.Text;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Xml;
using AddOnWebClient;

namespace AgentSite4.Report
{
    public partial class ManageSubAgent : BasePage, IRequiresSessionState
    {

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        int idUser = 181;
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                loadAgentDDL(ddlMasterAgent, true);
                loadAgentDDL(ddlMasterTo, true);
                loadAgentDDL(ddlAgentTo, false);
            }
            loadCheckBox();

        }
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadAgentHistory();
            if (!IsPostBack)
            {
                int idAgent = Convert.ToInt32(Request.QueryString["idAgent"]);

                verifiedHierarchy();
                loadAgentProfile(idAgent);
                LoadFreePlayLimit();
                GetPlayerLimits();
                GetApiKeyAgentLimits(1, idAgent);
                GetApiKeyAgentLimits(2, idAgent);
                GetApiKeyAgentLimits(0, idAgent);

            }
            else
            {
                int activeTabIndex = Convert.ToInt32(hfActiveTabIndex.Value);
                ScriptManager.RegisterStartupScript(this, GetType(), "SetActiveTab", "$(document).ready(function() { $('#animateLine li:eq(" + activeTabIndex + ") a').tab('show'); });", true);
            }
            if (!Common.HasRights(ReportPosition.MANAGESUBAGENT))
            {
                Response.End();
            }

        }




        private void LoadAgentHistory()
        {
            try
            {
                AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
                if (Common.HasRights(ReportPosition.SHOWAGENTHISTORY))
                {
                    CResultAgentHistory cresultAgentHistory = new CResultAgentHistory();
                    int prmIdAgent = Convert.ToInt32(Request.QueryString["idAgent"]);
                    string prmStartDate = DateTime.Today.ToString("MM/dd/yyyy");
                    string prmEndDate = DateTime.Today.ToString("MM/dd/yyyy");
                    int prmFilter = 0;
                    short prmIdCurrency = short.Parse(this.Session["IdCurrency"].ToString());
                    if (this.Request.Form["Date1"] != null && this.Request.Form["Date2"] != null)
                    {
                        prmStartDate = this.Request.Form["Date1"].ToString();
                        prmEndDate = this.Request.Form["Date2"].ToString();
                    }
                    if (this.Request.Form["Filter"] != null)
                        prmFilter = int.Parse(this.Request.Form["Filter"].ToString());
                    if (this.Request.Form["cCurrency"] != null)
                        prmIdCurrency = short.Parse(this.Request.Form["cCurrency"].ToString());
                    CResultAgentHistory reportAgentHistory = agentInstance.GetReportAgentHistory(prmIdAgent, prmStartDate, prmEndDate, prmFilter, prmIdCurrency);
                    if (reportAgentHistory.ErrorCode == CErrorCode.ErrorNone)
                    {
                        string str = "../App_Themes/" + this.Theme + "/";
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(reportAgentHistory.ToXml());
                        xmlDocument.DocumentElement.SetAttribute("ThemePath", str);
                        xmlDocument.DocumentElement.SetAttribute("MoneyFormat", ConfigurationManager.AppSettings["MoneyFormatDisplay"].ToString());
                        XslCompiledTransform compiledTransform = new XslCompiledTransform();
                        StringWriter stringWriter = new StringWriter();
                        compiledTransform.Load(this.Server.MapPath("..\\App_Themes\\" + this.Theme + "\\xsl\\AgentHistory.xsl"));
                        compiledTransform.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                        stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                        this.phAgentHistory.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                        foreach (Control control in this.phAgentHistory.Controls[0].Controls)
                        {
                            if (control.ID != null && control.ID == "btn_Continue_top")
                            {
                                if (control is Button btn)
                                {
                                    btn.Click += new EventHandler(this.btnButton_Click);
                                    btn.OnClientClick = "addHashToAction(); return false;"; // Add this line
                                }
                            }
                        }
                    }
                    else if (reportAgentHistory.ErrorCode == CErrorCode.ErrorValidation)
                        this.Response.Redirect("../Logout.aspx");
                    else
                        this.Response.Redirect("~/Report/ErrorHandle.aspx");
                }
                else
                    this.Response.Redirect("../Logout.aspx");
            }
            catch (Exception ex)
            {
                this.Response.Redirect("ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
        }

        protected void btnButton_Click(object sender, EventArgs e)
        {
            string currentUrl = Request.Url.AbsoluteUri;
            string newUrl = currentUrl.Split('#')[0] + "#pnTransactions";
            Response.Redirect(newUrl, false);
        }

        protected void loadAgentProfile(int idAgent)
        {
            verifiedHierarchy();
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();

            SqlCommand comm = new SqlCommand("Agent_GetInfoByID", Cnn);
            comm.CommandType = CommandType.StoredProcedure;
            ((SqlParameter)comm.Parameters.Add("@IdAgent", SqlDbType.Int)).Value = idAgent;
            SqlDataReader reader;

            try
            {
                reader = comm.ExecuteReader();
                while (reader.Read())
                {
                    txtAdresLine1.Text = reader["Address1"].ToString();
                    txtAdressLine2.Text = reader["Address2"].ToString();
                    txtCity.Text = reader["City"].ToString();
                    txtState.Text = reader["State"].ToString();
                    txtCountry.Text = reader["Country"].ToString();
                    txtPhone.Text = reader["Phone"].ToString();
                    txtFax.Text = reader["Fax"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    txtOnlineMessage.Text = reader["OnlineMessage"].ToString();
                    lblAgent.Text = reader["Agent"].ToString();
                    lblCurrentAgent.Text = reader["Agent"].ToString();
                    lblCurrenMaster.Text = reader["Agent"].ToString();
                    bool isDistributor = Convert.ToBoolean(reader["IsDistributor"]);
                    txtPassword.Text = reader["OnlinePassword"].ToString();
                    chkDistributor.Checked = isDistributor;
                    if (!isDistributor)
                    {

                        ddlAgentTo.SelectedValue = idAgent.ToString();
                        pnMove.Visible = true;
                        pnMoveAgents.Visible = false;
                    }
                    else
                    {
                        pnMove.Visible = false;
                        pnMoveAgents.Visible = true;
                    }
                    txtCommission.Text = Convert.ToInt32(reader["CommSports"].ToString()).ToString("N0");
                    ddlMasterAgent.SelectedValue = reader["distributor"].ToString();
                    chkOnlineAccess.Checked = Convert.ToBoolean(reader["OnlineAccess"]);
                    chkDontXFer.Checked = Convert.ToBoolean(reader["DontXferPlayerActivity"]);
                    chkEnable.Checked = Convert.ToBoolean(reader["Enable"]);
                    verifiedProperHierarchy();

                }
                reader.Close();
            }
            catch (Exception err)
            {
                Response.Write(err.Message);
            }
            finally
            {
                Cnn.Close();
            }
        }

        protected void verifiedHierarchy()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();

            bool hasAcces = false;
            int prmDistributor = int.Parse(this.Session["SubIdAgent"].ToString());
            int idAgent = Convert.ToInt32(Request.QueryString["idAgent"]);

            SqlCommand comm = new SqlCommand("VerifiedHierarchy", Cnn);
            comm.CommandType = CommandType.StoredProcedure;
            ((SqlParameter)comm.Parameters.Add("@prmDistributor", SqlDbType.Int)).Value = prmDistributor;
            ((SqlParameter)comm.Parameters.Add("@prmIdgent", SqlDbType.Int)).Value = idAgent;
            SqlDataReader reader;

            try
            {
                reader = comm.ExecuteReader();
                while (reader.Read())
                {
                    hasAcces = Convert.ToBoolean(reader["inHierarchy"]);
                }
                reader.Close();
            }
            catch (Exception err)
            {
                Response.Write(err.Message);
            }
            finally
            {
                Cnn.Close();
            }
            if (!hasAcces)
            {
                Response.Redirect("~/Report/Welcome.aspx");
            }
        }


        protected void loadCheckBox()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            using (SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                SqlCommand comm = new SqlCommand("AgentRights_Get", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                comm.Parameters.AddWithValue("@prmIdAgent", Convert.ToInt32(Session["idAgent"]));
                comm.Parameters.AddWithValue("@prmSubIdAgent", Convert.ToInt32(Request.QueryString["idAgent"]));

                Cnn.Open();

                using (SqlDataReader reader = comm.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string systemCategory = reader["Category"].ToString();
                        int rightStatus = Convert.ToInt32(reader["RightStatus"]);
                        string checkBoxId = "chk_" + reader["IdRight"].ToString() + "_" + reader["IdForm"].ToString();
                        string description = reader["Description"].ToString();

                        CheckBox checkBox = new CheckBox();
                        checkBox.ID = checkBoxId;
                        //checkBox.AutoPostBack = true;
                        checkBox.CssClass = "custom-switch js-switch text-right control-label col-form-label";
                        checkBox.Checked = rightStatus == 2; //Sub has the right
                        checkBox.Text = description;
                        //checkBox.CheckedChanged += new EventHandler(chk_CheckedChanged);
                        HiddenField hiddenField = new HiddenField();
                        hiddenField.ID = "hidden_" + checkBoxId;
                        hiddenField.Value = checkBox.Checked.ToString();
                        pnAgentCheckBoxes.Controls.Add(hiddenField);

                        LiteralControl startDiv = new LiteralControl("<div class=\"col-6 col-sm-4 col-lg-4 col-xl-3\">");
                        LiteralControl endDiv = new LiteralControl("</div>");
                        if (rightStatus != 0)
                        {
                            if (systemCategory.Equals("AGENT", StringComparison.OrdinalIgnoreCase))
                            {
                                pnAgentCheckBoxes.Controls.Add(startDiv);
                                pnAgentCheckBoxes.Controls.Add(new LiteralControl($"<label class=\"btn btn-outline-primary{(checkBox.Checked ? " active" : "")}\">"));
                                checkBox.CssClass = "btn-check";
                                pnAgentCheckBoxes.Controls.Add(checkBox);
                                pnAgentCheckBoxes.Controls.Add(new LiteralControl($"{checkBox.Text}</label>"));
                                pnAgentCheckBoxes.Controls.Add(endDiv);
                            }
                            else if (systemCategory.Equals("AGENT REPORT", StringComparison.OrdinalIgnoreCase))
                            {
                                pnAgentReportCheckBoxes.Controls.Add(startDiv);
                                pnAgentReportCheckBoxes.Controls.Add(new LiteralControl($"<label class=\"btn btn-outline-primary{(checkBox.Checked ? " active" : "")}\">"));
                                checkBox.CssClass = "btn-check";
                                pnAgentReportCheckBoxes.Controls.Add(checkBox);
                                pnAgentReportCheckBoxes.Controls.Add(new LiteralControl($"{checkBox.Text}</label>"));
                                pnAgentReportCheckBoxes.Controls.Add(endDiv);
                            }
                        }

                    }
                }
            }
        }

        protected void SaveAgentProfile()
        {
            verifiedHierarchy();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            int idAgent = Convert.ToInt32(Request.QueryString["idAgent"]);

            string title = "";
            string message = "";

            string name = txtName.Text;
            string address1 = txtAdresLine1.Text;
            string address2 = txtAdressLine2.Text;
            string city = txtCity.Text;
            string state = txtState.Text;
            string country = txtCountry.Text;
            string phone = txtPhone.Text;
            string fax = txtFax.Text;
            string email = txtEmail.Text;
            string onlineMessage = txtOnlineMessage.Text;
            string password = txtPassword.Text;
            byte SCommission = Convert.ToByte(txtCommission.Text);

            int distributor = Convert.ToInt32(ddlMasterAgent.SelectedValue);
            bool enable = Convert.ToBoolean(chkEnable.Checked);
            bool onlineAccess = Convert.ToBoolean(chkOnlineAccess.Checked);
            bool isDistributor = Convert.ToBoolean(chkDistributor.Checked);
            bool donXfer = Convert.ToBoolean(chkDontXFer.Checked);

            using (SqlConnection conn = new SqlConnection(DGS_AddOnsConnectionString))
            {
                SqlCommand cmd = new SqlCommand("AddOn_AgentProfileUpdateV2", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
                cmd.Parameters.Add(new SqlParameter("@prmEnable", SqlDbType.Bit)).Value = enable;
                cmd.Parameters.Add(new SqlParameter("@prmDontXfer", SqlDbType.Bit)).Value = donXfer;
                cmd.Parameters.Add(new SqlParameter("@prmIsDistributor", SqlDbType.Bit)).Value = isDistributor;
                cmd.Parameters.Add(new SqlParameter("@prmIdUser", SqlDbType.Int)).Value = idUser;
                cmd.Parameters.Add(new SqlParameter("@prmDistributor", SqlDbType.Int)).Value = distributor;
                cmd.Parameters.Add(new SqlParameter("@prmName", SqlDbType.VarChar, 20)).Value = name;
                cmd.Parameters.Add(new SqlParameter("@prmPassword", SqlDbType.NVarChar, 255)).Value = password;
                cmd.Parameters.Add(new SqlParameter("@prmCity", SqlDbType.VarChar, 20)).Value = city;
                cmd.Parameters.Add(new SqlParameter("@prmState", SqlDbType.VarChar, 20)).Value = state;
                cmd.Parameters.Add(new SqlParameter("@prmCountry", SqlDbType.VarChar, 30)).Value = country;
                cmd.Parameters.Add(new SqlParameter("@prmAddress1", SqlDbType.VarChar, 50)).Value = address1;
                cmd.Parameters.Add(new SqlParameter("@prmAddress2", SqlDbType.VarChar, 50)).Value = address2;
                cmd.Parameters.Add(new SqlParameter("@prmEmail", SqlDbType.VarChar, 50)).Value = email;
                cmd.Parameters.Add(new SqlParameter("@prmPhone", SqlDbType.VarChar, 15)).Value = phone;
                cmd.Parameters.Add(new SqlParameter("@prmFax", SqlDbType.VarChar, 15)).Value = fax;
                cmd.Parameters.Add(new SqlParameter("@prmCommSports", SqlDbType.TinyInt)).Value = SCommission;
                cmd.Parameters.Add(new SqlParameter("@prmOnlineAccess", SqlDbType.Bit)).Value = onlineAccess;
                cmd.Parameters.Add(new SqlParameter("@prmOnlineMessage", SqlDbType.VarChar, 100)).Value = onlineMessage;


                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    title = "Agent updated successfully";
                    message = "Agent profile has been updated.";
                    DisplayMessage(title, message);
                }
                catch (Exception ex)
                {
                    title = "Error";
                    message = ex.Message;
                    DisplayMessage(title, message);
                }
            }
        }

        protected void AddRight(short idForm, short idRight)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();

            string title = "";
            string message = "";

            //int prmSubIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
            int idAgent = Convert.ToInt32(Request.QueryString["idAgent"]);

            SqlCommand comm = new SqlCommand("AgentRights_AddRight", Cnn);
            comm.CommandType = CommandType.StoredProcedure;
            ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
            ((SqlParameter)comm.Parameters.Add("@prmIdForm", SqlDbType.SmallInt)).Value = idForm;
            ((SqlParameter)comm.Parameters.Add("@prmIdRight", SqlDbType.SmallInt)).Value = idRight;
            ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = idUser;

            SqlDataReader reader;

            try
            {
                reader = comm.ExecuteReader();
                while (reader.Read())
                {

                }
                reader.Close();
            }
            catch (Exception err)
            {
                title = "Error";
                message = err.Message;
                DisplayMessage(title, message);
            }
            finally
            {
                Cnn.Close();
            }
        }

        protected void RemoveRight(short idForm, short idRight)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();

            //int prmSubIdAgent = int.Parse(this.Session["SubIdAgent"].ToString());
            int idAgent = Convert.ToInt32(Request.QueryString["idAgent"]);

            SqlCommand comm = new SqlCommand("AgentRights_RemoveRight", Cnn);
            comm.CommandType = CommandType.StoredProcedure;
            ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = idAgent;
            ((SqlParameter)comm.Parameters.Add("@prmIdForm", SqlDbType.SmallInt)).Value = idForm;
            ((SqlParameter)comm.Parameters.Add("@prmIdRight", SqlDbType.SmallInt)).Value = idRight;
            ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = idUser;

            SqlDataReader reader;

            try
            {
                reader = comm.ExecuteReader();
                while (reader.Read())
                {

                }
                reader.Close();
            }
            catch (Exception err)
            {

            }
            finally
            {
                Cnn.Close();
            }
        }

        protected void loadAgentDDL(DropDownList ddlAgent, bool IsDistributor)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            try
            {
                Cnn.Open();
                int prmIdAgent = Convert.ToInt32(this.Session["SubIdAgent"]);

                SqlCommand comm1 = new SqlCommand("Agent_GetAgentsOrDistributors", Cnn);
                comm1.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm1.Parameters.Add("@idAgent", SqlDbType.Int)).Value = prmIdAgent;
                ((SqlParameter)comm1.Parameters.Add("@IsDistributor", SqlDbType.Bit)).Value = IsDistributor;
                SqlDataReader reader;
                reader = comm1.ExecuteReader();
                ListItem newItem = new ListItem();
                while (reader.Read())
                {
                    newItem = new ListItem();
                    newItem.Value = reader["IdAgent"].ToString();
                    newItem.Text = reader["AGENT"].ToString();
                    ddlAgent.Items.Add(newItem);
                }
                if (ddlAgent.Items.Count == 0)
                {
                    newItem = new ListItem();
                    newItem.Value = this.Session["SubIdAgent"].ToString();
                    newItem.Text = this.Session["SubAgent"].ToString();
                    ddlAgent.Items.Add(newItem);
                }

            }
            catch (Exception e)
            {

            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

        }


        protected void MovePlayers()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            int idAgentFrom = Convert.ToInt32(Request.QueryString["idAgent"]);
            int idAgentTo = Convert.ToInt32(ddlAgentTo.SelectedValue);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("MovePlayers", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@prmIdAgentFrom", idAgentFrom);
                cmd.Parameters.AddWithValue("@prmIdAgentTo", idAgentTo);
                cmd.Parameters.AddWithValue("@prmIdUser", idUser);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                }
            }
        }

        protected void MoveAgents()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            int idAgentFrom = Convert.ToInt32(Request.QueryString["idAgent"]);
            int idAgentTo = Convert.ToInt32(ddlMasterTo.SelectedValue);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("MoveAgents", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@prmIdAgentFrom", idAgentFrom);
                cmd.Parameters.AddWithValue("@prmIdAgentTo", idAgentTo);
                cmd.Parameters.AddWithValue("@prmIdUser", idUser);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                }
            }
        }


        protected void chk_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox check = sender as CheckBox;
            short idForm = 0;
            short idRight = 0;

            string orgName = check.ID.ToString();
            string[] nameSplit = orgName.Split('_');
            idForm = Convert.ToInt16(nameSplit[2]);
            idRight = Convert.ToInt16(nameSplit[1]);

            if (check.Checked)
            {
                AddRight(idForm, idRight);
                string title = "Right updated successfully";
                string message = "Right " + check.Text + " added successfully";
                DisplayMessage(title, message);
            }
            else
            {
                RemoveRight(idForm, idRight);
                string title = "Right updated successfully";
                string message = "Right " + check.Text + " removed successfully";
                DisplayMessage(title, message);
            }

        }

        protected void SaveRightsPanel(Panel pn)
        {
            foreach (Control control in pn.Controls)
            {
                if (control.ID != null && control.ID.StartsWith("chk_"))
                {
                    CheckBox checkBox = control as CheckBox;
                    HiddenField hiddenField = pn.FindControl("hidden_" + checkBox.ID) as HiddenField;
                    if (hiddenField != null)
                    {
                        bool initialChecked = Convert.ToBoolean(hiddenField.Value);
                        bool finalChecked = checkBox.Checked;

                        if (initialChecked != finalChecked)
                        {
                            string[] nameSplit = checkBox.ID.Split('_');
                            short idForm = Convert.ToInt16(nameSplit[2]);
                            short idRight = Convert.ToInt16(nameSplit[1]);

                            if (finalChecked)
                            {
                                AddRight(idForm, idRight);
                            }
                            else
                            {
                                RemoveRight(idForm, idRight);
                            }
                        }
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            ViewState["IsSaving"] = true;
            SaveAgentProfile();
            string fpmessage = SaveFreePlayLimit();
            SaveRightsPanel(pnAgentCheckBoxes);
            SaveRightsPanel(pnAgentReportCheckBoxes);
            SavePlayerLimits();
            SalvarOtherLimites();

            string title = "Profile saved successfully";
            string message = "Profile saved successfully" + (!String.IsNullOrEmpty(fpmessage) ? "and " + fpmessage : "");
            DisplayMessage(title, message);

            string currentUrl = HttpContext.Current.Request.Url.AbsoluteUri;
            Response.Redirect(currentUrl);//TODO al usar loadCheckBox duplica los controles, hay que solo recargar los rights (preder o apagar los checkbox)

            //loadCheckBox();
        }

        protected void LoadFreePlayLimit()
        {
            int idAgent = Convert.ToInt32(Request.QueryString["idAgent"]);
            int ruleByIdAgent = Convert.ToInt32(Session["SubIdAgent"]);
            DataTable limit = GetWeeklyFreePlayLimit(idAgent);
            string message = "";
            if (limit.Rows.Count > 0)
            {
                DataRow limitRow = limit.Rows[0];

                int currentIdAgent = Convert.ToInt32(limitRow["idAgent"]);
                decimal currentFreePlayLimit = Convert.ToDecimal(limitRow["WeeklyFreePlayLimit"]);
                int currentRuleByIdAgent = Convert.ToInt32(limitRow["RuleByIdAgent"]);
                txtFreePlayLimit.Text = currentFreePlayLimit.ToString("N0");
                if (ruleByIdAgent != currentRuleByIdAgent)
                {
                    int isParentOrChild = VerifyHierarchyOrder(ruleByIdAgent, currentRuleByIdAgent);
                    switch (isParentOrChild)
                    {
                        case 1:
                            txtFreePlayLimit.Enabled = false;
                            message = "Weekly Free Play Limit can't be updated because the rule was created above your hierarchy level.";
                            litRuleCreatedIcon.Text = "<i class=\"fa-solid fa-circle-exclamation text-danger\" data-bs-toggle=\"tooltip\" data-bs-placement=\"top\" title=\"" + message + "\"></i>";
                            break;
                        case 2:
                            string agent = GetAgentInfo(currentRuleByIdAgent);
                            message = "This limit was set up by " + agent + ". If you don't want to overwrite, switch sessions.";
                            litRuleCreatedIcon.Text = "<i class=\"fa-solid fa-circle-exclamation text-warning\" data-bs-toggle=\"tooltip\" data-bs-placement=\"top\" title=\"" + message + "\"></i>";
                            break;
                    }
                }
            }
            if (String.IsNullOrEmpty(message))
            {
                litRuleCreatedIcon.Visible = false;
            }
        }

        protected string SaveFreePlayLimit()
        {

            int idAgent = Convert.ToInt32(Request.QueryString["idAgent"]);
            decimal freePlayLimit = String.IsNullOrEmpty(txtFreePlayLimit.Text) ? 0 : Convert.ToDecimal(txtFreePlayLimit.Text);
            int ruleByIdAgent = Convert.ToInt32(Session["SubIdAgent"]);
            bool acceptChanges = false;
            string rtn = "";
            DataTable limit = GetWeeklyFreePlayLimit(idAgent);
            if (limit.Rows.Count > 0)
            {
                DataRow limitRow = limit.Rows[0];
                int currentIdAgent = Convert.ToInt32(limitRow["idAgent"]);
                decimal currentFreePlayLimit = Convert.ToDecimal(limitRow["WeeklyFreePlayLimit"]);
                int currentRuleByIdAgent = Convert.ToInt32(limitRow["RuleByIdAgent"]);

                if (freePlayLimit != currentFreePlayLimit)
                {
                    if (ruleByIdAgent != currentRuleByIdAgent)
                    {
                        int isParentOrChild = VerifyHierarchyOrder(ruleByIdAgent, currentRuleByIdAgent);

                        switch (isParentOrChild)
                        {
                            case 0:
                                // this is an error this agent was move to a diferent hierarchy
                                DeleteWeeklyFreePlayLimit(idAgent);
                                InsertWeeklyFreePlayLimit(idAgent, freePlayLimit, ruleByIdAgent);
                                rtn = "Weekly Free Play Limit updated";
                                break;
                            case 1:
                                //this rule was created by some high in the hierarchy
                                rtn = "Weekly Free Play Limit can't be updated because the rule was created above your hierarchy level.";
                                break;
                            case 2:
                                UpdateWeeklyFreePlayLimit(idAgent, freePlayLimit, ruleByIdAgent); //this will overrule any child rule
                                rtn = "Weekly Free Play Limit updated and overwrite sub agent rule";
                                break;
                        }
                    }
                    else
                    {
                        UpdateWeeklyFreePlayLimit(idAgent, freePlayLimit, ruleByIdAgent);
                        rtn = "Weekly Free Play Limit updated";
                    }
                }
            }
            else if (freePlayLimit > 0)
            {
                InsertWeeklyFreePlayLimit(idAgent, freePlayLimit, ruleByIdAgent);
                rtn = "Weekly Free Play Limit updated";
            }
            return rtn;

        }



        protected void SavePlayerLimits()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            int idAgent = Convert.ToInt32(Request.QueryString["idAgent"]);
            int ruleByIdAgent = Convert.ToInt32(Session["SubIdAgent"]);

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("AgentPlayerLimits_Save", connection);
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@IdAgent", idAgent);
                command.Parameters.AddWithValue("@CreditLimitMin", string.IsNullOrEmpty(creditLimitMin.Text) ? -1 : decimal.Parse(creditLimitMin.Text));
                command.Parameters.AddWithValue("@CreditLimitMax", string.IsNullOrEmpty(creditLimitMax.Text) ? -1 : decimal.Parse(creditLimitMax.Text));
                command.Parameters.AddWithValue("@ParlayLimitMin", string.IsNullOrEmpty(parlayLimitMin.Text) ? -1 : decimal.Parse(parlayLimitMin.Text));
                command.Parameters.AddWithValue("@ParlayLimitMax", string.IsNullOrEmpty(parlayLimitMax.Text) ? -1 : decimal.Parse(parlayLimitMax.Text));
                command.Parameters.AddWithValue("@ContestLimitMin", string.IsNullOrEmpty(contestLimitMin.Text) ? -1 : decimal.Parse(contestLimitMin.Text));
                command.Parameters.AddWithValue("@ContestLimitMax", string.IsNullOrEmpty(contestLimitMax.Text) ? -1 : decimal.Parse(contestLimitMax.Text));
                command.Parameters.AddWithValue("@WagerLimitMin", string.IsNullOrEmpty(wagerLimitMin.Text) ? -1 : decimal.Parse(wagerLimitMin.Text));
                command.Parameters.AddWithValue("@WagerLimitMax", string.IsNullOrEmpty(wagerLimitMax.Text) ? -1 : decimal.Parse(wagerLimitMax.Text));
                command.Parameters.AddWithValue("@TeaserLimitMin", string.IsNullOrEmpty(teaserLimitMin.Text) ? -1 : decimal.Parse(teaserLimitMin.Text));
                command.Parameters.AddWithValue("@TeaserLimitMax", string.IsNullOrEmpty(teaserLimitMax.Text) ? -1 : decimal.Parse(teaserLimitMax.Text));
                command.Parameters.AddWithValue("@RuleByIdAgent", ruleByIdAgent); // Replace ruleByIdAgent with actual value
                command.Parameters.AddWithValue("@LastModification", DateTime.Now);

                connection.Open();
                command.ExecuteNonQuery();
            }
        }


        protected void GetPlayerLimits()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            int idAgent = Convert.ToInt32(Request.QueryString["idAgent"]);
            int ruleByIdAgent = Convert.ToInt32(Session["SubIdAgent"]);
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("AgentPlayerLimits_Get", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@IdAgent", idAgent);

                connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                if (reader.Read())
                {
                    creditLimitMin.Text = reader["CreditLimitMin"] != DBNull.Value && Convert.ToDecimal(reader["CreditLimitMin"]) != -1 ? Convert.ToDecimal(reader["CreditLimitMin"]).ToString("N0") : "";
                    creditLimitMax.Text = reader["CreditLimitMax"] != DBNull.Value && Convert.ToDecimal(reader["CreditLimitMax"]) != -1 ? Convert.ToDecimal(reader["CreditLimitMax"]).ToString("N0") : "";
                    parlayLimitMin.Text = reader["ParlayLimitMin"] != DBNull.Value && Convert.ToDecimal(reader["ParlayLimitMin"]) != -1 ? Convert.ToDecimal(reader["ParlayLimitMin"]).ToString("N0") : "";
                    parlayLimitMax.Text = reader["ParlayLimitMax"] != DBNull.Value && Convert.ToDecimal(reader["ParlayLimitMax"]) != -1 ? Convert.ToDecimal(reader["ParlayLimitMax"]).ToString("N0") : "";
                    contestLimitMin.Text = reader["ContestLimitMin"] != DBNull.Value && Convert.ToDecimal(reader["ContestLimitMin"]) != -1 ? Convert.ToDecimal(reader["ContestLimitMin"]).ToString("N0") : "";
                    contestLimitMax.Text = reader["ContestLimitMax"] != DBNull.Value && Convert.ToDecimal(reader["ContestLimitMax"]) != -1 ? Convert.ToDecimal(reader["ContestLimitMax"]).ToString("N0") : "";
                    wagerLimitMin.Text = reader["WagerLimitMin"] != DBNull.Value && Convert.ToDecimal(reader["WagerLimitMin"]) != -1 ? Convert.ToDecimal(reader["WagerLimitMin"]).ToString("N0") : "";
                    wagerLimitMax.Text = reader["WagerLimitMax"] != DBNull.Value && Convert.ToDecimal(reader["WagerLimitMax"]) != -1 ? Convert.ToDecimal(reader["WagerLimitMax"]).ToString("N0") : "";
                    teaserLimitMin.Text = reader["TeaserLimitMin"] != DBNull.Value && Convert.ToDecimal(reader["TeaserLimitMin"]) != -1 ? Convert.ToDecimal(reader["TeaserLimitMin"]).ToString("N0") : "";
                    teaserLimitMax.Text = reader["TeaserLimitMax"] != DBNull.Value && Convert.ToDecimal(reader["TeaserLimitMax"]) != -1 ? Convert.ToDecimal(reader["TeaserLimitMax"]).ToString("N0") : "";

                }
                reader.Close();
            }
        }


        protected void SaveApiKeyAgentLimits(int idApiKey, int idAgent, decimal dailyLose, decimal dailyWin, decimal weeklyLose, decimal weeklyWin)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("ApiKeyAgentLimits_Save", connection);
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@idApiKey", idApiKey);
                command.Parameters.AddWithValue("@idAgent", idAgent);
                command.Parameters.AddWithValue("@dailyLose", dailyLose);
                command.Parameters.AddWithValue("@dailyWin", dailyWin);
                command.Parameters.AddWithValue("@weeklyLose", weeklyLose);
                command.Parameters.AddWithValue("@weeklyWin", weeklyWin);

                connection.Open();
                command.ExecuteNonQuery();
            }
        }


        protected void GetApiKeyAgentLimits(int idApiKey, int idAgent)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("ApiKeyAgentLimits_Get", connection);
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@idApiKey", idApiKey);
                command.Parameters.AddWithValue("@idAgent", idAgent);

                connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                if (reader.Read())
                {
                    if (idApiKey == 1) // CRASH
                    {
                        txtCrashDailyLoss.Text = reader["dailyLose"] != DBNull.Value && Convert.ToDecimal(reader["dailyLose"]) != -1 ? Convert.ToDecimal(reader["dailyLose"]).ToString("N0") : "";
                        txtCrashDailyWin.Text = reader["dailyWin"] != DBNull.Value && Convert.ToDecimal(reader["dailyWin"]) != -1 ? Convert.ToDecimal(reader["dailyWin"]).ToString("N0") : "";
                        txtCrashWeeklyLoss.Text = reader["weeklyLose"] != DBNull.Value && Convert.ToDecimal(reader["weeklyLose"]) != -1 ? Convert.ToDecimal(reader["weeklyLose"]).ToString("N0") : "";
                        txtCrashWeeklyWin.Text = reader["weeklyWin"] != DBNull.Value && Convert.ToDecimal(reader["weeklyWin"]) != -1 ? Convert.ToDecimal(reader["weeklyWin"]).ToString("N0") : "";
                    }
                    else if (idApiKey == 2) // MINES
                    {
                        txtMinesDailyLoss.Text = reader["dailyLose"] != DBNull.Value && Convert.ToDecimal(reader["dailyLose"]) != -1 ? Convert.ToDecimal(reader["dailyLose"]).ToString("N0") : "";
                        txtMinesDailyWin.Text = reader["dailyWin"] != DBNull.Value && Convert.ToDecimal(reader["dailyWin"]) != -1 ? Convert.ToDecimal(reader["dailyWin"]).ToString("N0") : "";
                        txtMinesWeeklyLoss.Text = reader["weeklyLose"] != DBNull.Value && Convert.ToDecimal(reader["weeklyLose"]) != -1 ? Convert.ToDecimal(reader["weeklyLose"]).ToString("N0") : "";
                        txtMinesWeeklyWin.Text = reader["weeklyWin"] != DBNull.Value && Convert.ToDecimal(reader["weeklyWin"]) != -1 ? Convert.ToDecimal(reader["weeklyWin"]).ToString("N0") : "";
                    }
                    else if (idApiKey == 0) // Live Casino
                    {
                        txtAllDailyMaxLoss.Text = reader["dailyLose"] != DBNull.Value && Convert.ToDecimal(reader["dailyLose"]) != -1 ? Convert.ToDecimal(reader["dailyLose"]).ToString("N0") : "";
                        txtAllDailyMaxWin.Text = reader["dailyWin"] != DBNull.Value && Convert.ToDecimal(reader["dailyWin"]) != -1 ? Convert.ToDecimal(reader["dailyWin"]).ToString("N0") : "";
                        txtAllWeeklyMaxLoss.Text = reader["weeklyLose"] != DBNull.Value && Convert.ToDecimal(reader["weeklyLose"]) != -1 ? Convert.ToDecimal(reader["weeklyLose"]).ToString("N0") : "";
                        txtAllWeeklyMaxWin.Text = reader["weeklyWin"] != DBNull.Value && Convert.ToDecimal(reader["weeklyWin"]) != -1 ? Convert.ToDecimal(reader["weeklyWin"]).ToString("N0") : "";
                    }

                }
                reader.Close();
            }
        }


        protected void SalvarOtherLimites()
        {
            try
            {
                int idAgent = Convert.ToInt32(Request.QueryString["idAgent"]);
                decimal crashDailyLoss = string.IsNullOrEmpty(txtCrashDailyLoss.Text) ? -1 : decimal.Parse(txtCrashDailyLoss.Text);
                decimal crashDailyWin = string.IsNullOrEmpty(txtCrashDailyWin.Text) ? -1 : decimal.Parse(txtCrashDailyWin.Text);
                decimal crashWeeklyLoss = string.IsNullOrEmpty(txtCrashWeeklyLoss.Text) ? -1 : decimal.Parse(txtCrashWeeklyLoss.Text);
                decimal crashWeeklyWin = string.IsNullOrEmpty(txtCrashWeeklyWin.Text) ? -1 : decimal.Parse(txtCrashWeeklyWin.Text);

                decimal minesDailyLoss = string.IsNullOrEmpty(txtMinesDailyLoss.Text) ? -1 : decimal.Parse(txtMinesDailyLoss.Text);
                decimal minesDailyWin = string.IsNullOrEmpty(txtMinesDailyWin.Text) ? -1 : decimal.Parse(txtMinesDailyWin.Text);
                decimal minesWeeklyLoss = string.IsNullOrEmpty(txtMinesWeeklyLoss.Text) ? -1 : decimal.Parse(txtMinesWeeklyLoss.Text);
                decimal minesWeeklyWin = string.IsNullOrEmpty(txtMinesWeeklyWin.Text) ? -1 : decimal.Parse(txtMinesWeeklyWin.Text);

                decimal liveCasinoDailyMaxLoss = string.IsNullOrEmpty(txtAllDailyMaxLoss.Text) ? -1 : decimal.Parse(txtAllDailyMaxLoss.Text);
                decimal liveCasinoDailyMaxWin = string.IsNullOrEmpty(txtAllDailyMaxWin.Text) ? -1 : decimal.Parse(txtAllDailyMaxWin.Text);
                decimal liveCasinoWeeklyMaxLoss = string.IsNullOrEmpty(txtAllWeeklyMaxLoss.Text) ? -1 : decimal.Parse(txtAllWeeklyMaxLoss.Text);
                decimal liveCasinoWeeklyMaxWin = string.IsNullOrEmpty(txtAllWeeklyMaxWin.Text) ? -1 : decimal.Parse(txtAllWeeklyMaxWin.Text);

                // Guardar los límites de CRASH
                if (crashDailyLoss >= 0 && crashDailyWin >= 0 && crashWeeklyLoss >= 0 && crashWeeklyWin >= 0)
                {
                    SaveApiKeyAgentLimits(1, idAgent, crashDailyLoss, crashDailyWin, crashWeeklyLoss, crashWeeklyWin);
                }
                else
                {
                    throw new InvalidOperationException("All fields for CRASH must have a value of 0 or more.");
                }

                if (minesDailyLoss >= 0 && minesDailyWin >= 0 && minesWeeklyLoss >= 0 && minesWeeklyWin >= 0)
                {
                    SaveApiKeyAgentLimits(2, idAgent, minesDailyLoss, minesDailyWin, minesWeeklyLoss, minesWeeklyWin);
                }
                else
                {
                    throw new InvalidOperationException("All fields for Mines must have a value of 0 or more.");
                }

                if (liveCasinoDailyMaxLoss >= 0 && liveCasinoDailyMaxWin >= 0 && liveCasinoWeeklyMaxLoss >= 0 && liveCasinoWeeklyMaxWin >= 0)
                {
                    SaveApiKeyAgentLimits(0, idAgent, liveCasinoDailyMaxLoss, liveCasinoDailyMaxWin, liveCasinoWeeklyMaxLoss, liveCasinoWeeklyMaxWin);
                }
                else
                {
                    throw new InvalidOperationException("All fields for Live Casino must have a value of 0 or more.");
                }
            }
            catch (InvalidOperationException ex)
            { 
            }
        }





        protected void btnMovePlayers_Click(object sender, EventArgs e)
        {
            MovePlayers();
            string title = "Players Moved";
            string message = "All players from " + lblAgent.Text + " ware moved to " + ddlAgentTo.SelectedItem.Text;
            DisplayMessage(title, message);
        }

        protected void btnMoveAgents_Click(object sender, EventArgs e)
        {
            MoveAgents();
            string title = "Hierarchy Updated";
            string message = "All agents from " + lblAgent.Text + " ware moved to " + ddlMasterTo.SelectedItem.Text;
            DisplayMessage(title, message);
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.location.href='AgentManagement.aspx'; </" + "script>");

        }



        protected void chkDistributor_CheckedChanged(object sender, EventArgs e)
        {
            verifiedProperHierarchy();

        }

        protected void verifiedProperHierarchy()
        {
            bool hasError = false;
            string title = "";
            string strMessage = "";

            bool isDistributor = chkDistributor.Checked;

            AgentOrMaster agentOrMaster = CheckAgentStatus();
            if (isDistributor && agentOrMaster.HasPlayers)
            {
                hasError = true;
                chkDistributor.Checked = false;
                pnMove.Visible = true;
                title = "Error";
                strMessage = "Unable to switch this agent to distributor because it has players.";
            }

            if (!isDistributor && agentOrMaster.HasSubAgents)
            {
                hasError = true;
                chkDistributor.Checked = true;
                pnMoveAgents.Visible = true;
                title = "Error";
                strMessage = "Unable to switch this Agent to a distributor because it has agents.";
            }
            if (agentOrMaster.HasPlayers && agentOrMaster.HasSubAgents)
            {
                hasError = true;
                title = "Error";
                strMessage = "An agent cannot be a Master and Agent at the same time. Please move his players or his agents to another, in order to save any changes to this Agent.";
                pnMove.Visible = true;
                pnMoveAgents.Visible = true;
            }
            if (hasError)
            {
                DisplayMessage(title, strMessage);
                btnSave.Enabled = false;
            }
            btnSave.Enabled = !hasError;
        }


        private void DisplayMessage(string title, string message)
        {
            string endTag = "</" + "script>";
            string script = string.Format(@"
                        <script language='javascript'>
                            document.addEventListener('DOMContentLoaded', function() {{
                                swal({{ title: '{0}', text: '{1}', timer: 5000, showConfirmButton: false }});
                            }});
                            {2}", title, message, endTag);
            Page.ClientScript.RegisterStartupScript(this.GetType(), "alertScript", script);
        }

        protected void chkCheckAll_CheckedChanged(object sender, EventArgs e)
        {
            chkCheckAll.Text = !chkCheckAll.Checked ? "Check All" : "Uncheck All";

            CheckOrUncheckAll(pnAgentCheckBoxes);
            CheckOrUncheckAll(pnAgentReportCheckBoxes);
        }

        private void CheckOrUncheckAll(Panel panel)
        {
            foreach (Control che in panel.Controls)
            {
                if ((che is CheckBox))
                {
                    ((CheckBox)che).Checked = chkCheckAll.Checked;
                    short idForm = 0;
                    short idRight = 0;
                    string orgName = ((CheckBox)che).ID.ToString();
                    if (orgName.IndexOf("chkCheckAll") > -1)
                    {
                        continue;
                    }
                    string[] nameSplit = orgName.Split('_');
                    idForm = Convert.ToInt16(nameSplit[2]);
                    idRight = Convert.ToInt16(nameSplit[1]);
                    if (chkCheckAll.Checked)
                    {
                        try
                        {
                            AddRight(idForm, idRight);
                        }
                        catch { }
                    }
                    else
                    {
                        try
                        {
                            RemoveRight(idForm, idRight);
                        }
                        catch { }
                    }
                }
            }
        }


        public AgentOrMaster CheckAgentStatus()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            AgentOrMaster status = new AgentOrMaster();

            try
            {
                using (SqlConnection conn = new SqlConnection(DGS_AddOnsConnectionString))
                {
                    SqlCommand cmd = new SqlCommand("CheckIfAgentHasPlayersOrSubAgents", conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    SqlParameter prmIdAgent = new SqlParameter("@prmIdAgent", SqlDbType.Int);
                    prmIdAgent.Value = Convert.ToInt32(Request.QueryString["idAgent"]);
                    cmd.Parameters.Add(prmIdAgent);

                    SqlParameter hasPlayersParam = new SqlParameter("@outHasPlayers", SqlDbType.Bit);
                    hasPlayersParam.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(hasPlayersParam);

                    SqlParameter hasSubAgentsParam = new SqlParameter("@outHasSubAgents", SqlDbType.Bit);
                    hasSubAgentsParam.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(hasSubAgentsParam);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    status.HasPlayers = Convert.ToBoolean(hasPlayersParam.Value);
                    status.HasSubAgents = Convert.ToBoolean(hasSubAgentsParam.Value);
                }
            }
            catch (Exception ex)
            {
            }

            return status;
        }

        protected void InsertWeeklyFreePlayLimit(int idAgent, decimal freePlayLimit, int ruleByIdAgent)
        {

            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("WeeklyFreePlayLimit_Insert", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = idAgent;
                cmd.Parameters.Add("@prmWeeklyFreePlayLimit", SqlDbType.Money).Value = freePlayLimit;
                cmd.Parameters.Add("@prmRuleByIdAgent", SqlDbType.Int).Value = ruleByIdAgent;

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                }
            }

        }

        protected string GetAgentInfo(int idAgent)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            string agent = string.Empty;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("AddOn_GetAgentInfo", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@idAgent", SqlDbType.Int).Value = idAgent;

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        agent = reader["Agent"].ToString();
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                }
            }

            return agent;
        }


        protected DataTable GetWeeklyFreePlayLimit(int idAgent)
        {
            DataTable dt = new DataTable();
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("WeeklyFreePlayLimit_Get", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = idAgent;

                try
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
                catch (Exception ex)
                {

                }
            }

            return dt;
        }

        protected void UpdateWeeklyFreePlayLimit(int idAgent, decimal freePlayLimit, int ruleByIdAgent)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("WeeklyFreePlayLimit_Update", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = idAgent;
                cmd.Parameters.Add("@prmWeeklyFreePlayLimit", SqlDbType.Money).Value = freePlayLimit;
                cmd.Parameters.Add("@prmRuleByIdAgent", SqlDbType.Int).Value = ruleByIdAgent;

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {

                }
            }
        }

        protected void DeleteWeeklyFreePlayLimit(int idAgent)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("WeeklyFreePlayLimit_Delete", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = idAgent;

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {

                }
            }
        }


        protected int VerifyHierarchyOrder(int idAgent, int distributor)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            int outIsParentOrChild = 0;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("VerifyHerrchieOrder", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@prmIdAgent", SqlDbType.Int).Value = idAgent;
                cmd.Parameters.Add("@prmDistributor", SqlDbType.Int).Value = distributor;
                cmd.Parameters.Add("@outIsParentOrChild", SqlDbType.Int).Direction = ParameterDirection.Output;

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    outIsParentOrChild = Convert.ToInt32(cmd.Parameters["@outIsParentOrChild"].Value);
                }
                catch (Exception ex)
                {

                }
            }

            return outIsParentOrChild;
        }





        protected void ddlAgentTo_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedAgent = ddlAgentTo.SelectedItem.Text;
            btnMovePlayers.Text = "Move Players to: " + selectedAgent;
            btnMovePlayers.Enabled = true;


        }

        public class AgentOrMaster
        {
            private bool _hasPlayers;
            private bool _hasSubAgents;

            public bool HasPlayers
            {
                get { return _hasPlayers; }
                set { _hasPlayers = value; }
            }

            public bool HasSubAgents
            {
                get { return _hasSubAgents; }
                set { _hasSubAgents = value; }
            }
        }
    }
}
