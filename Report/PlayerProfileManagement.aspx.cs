using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using AgentSite4.ASP;
using Localization;

namespace AgentSite4.Report
{
    public partial class PlayerProfileManagement : BasePage, IRequiresSessionState
    {

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        protected void Page_Load(object sender, EventArgs e)
        {
            NameValueCollection resource = new NameValueCollection();
            LoadResources(resource);
            for (int i = 0; i < pnDatos.Controls.Count; i++)
            {
                //Response.Write(pnDatos.Controls[i].GetType().Name);
                string controlName = pnDatos.Controls[i].GetType().Name;
                string str = "";
                string cleanControl = "";
                switch (controlName)
                {
                    case "Label":
                        Label ctrl1 = (Label)pnDatos.Controls[i];
                        str = ctrl1.Text;
                        cleanControl = cleanForInput(str);
                        if (String.IsNullOrEmpty(resource.Get(cleanControl)))
                        {
                            //  Response.Write("<item name=\"" + cleanControl + "\">" + str + "</item>");
                            resource.Add(cleanControl, str);
                        }
                        ctrl1.Text = resource.Get(cleanControl);
                        break;
                    case "CheckBox":
                        CheckBox ctrl2 = (CheckBox)pnDatos.Controls[i];
                        str = ctrl2.Text;
                        cleanControl = cleanForInput(str);
                        if (String.IsNullOrEmpty(resource.Get(cleanControl)))
                        {
                            //  Response.Write("<item name=\"" + cleanControl + "\">" + str + "</item>");
                            resource.Add(cleanControl, str);
                        }
                        ctrl2.Text = resource.Get(cleanControl);
                        break;
                    case "LocalizedLabel":
                        LocalizedLabel ctrl3 = (LocalizedLabel)pnDatos.Controls[i];
                        str = ctrl3.Key;
                        cleanControl = cleanForInput(str);
                        if (String.IsNullOrEmpty(resource.Get(cleanControl)))
                        {
                            //   Response.Write("<item name=\"" + cleanControl + "\">" + str + "</item>");
                            resource.Add(cleanControl, str);
                        }
                        ctrl3.Text = resource.Get(cleanControl);
                        break;
                    case "RadioButtonList":
                        RadioButtonList ctrl4 = (RadioButtonList)pnDatos.Controls[i];
                        foreach (ListItem item in ctrl4.Items)
                        {
                            str = item.Text;
                            cleanControl = cleanForInput(str);
                            if (String.IsNullOrEmpty(resource.Get(cleanControl)))
                            {
                                // Response.Write("<item name=\"" + cleanControl + "\">" + str + "</item>");
                                resource.Add(cleanControl, str);
                            }
                            item.Text = resource.Get(cleanControl);
                        }
                        break;
                    case "Button":
                        Button ctrl5 = (Button)pnDatos.Controls[i];
                        str = ctrl5.Text;
                        cleanControl = cleanForInput(str);
                        if (String.IsNullOrEmpty(resource.Get(cleanControl)))
                        {
                            //  Response.Write("<item name=\"" + cleanControl + "\">" + str + "</item>");
                            resource.Add(cleanControl, str);
                        }
                        ctrl5.Text = resource.Get(cleanControl);
                        break;

                }
                //string headerText = GridView1.Columns[i].HeaderText.Replace(" ", "");
                //string localizeText = resource.Get(headerText);
                //if (localizeText == "")
                //{
                //    localizeText = "[" + headerText.Replace(" ", "") + "]";
                //}
                //GridView1.Columns[i].HeaderText = localizeText;
            }

        }


        protected void changeDetailsView(object sender, EventArgs e)
        {
            NameValueCollection resource = new NameValueCollection();
            LoadResources(resource);
            DetailsView ctrl = (DetailsView)sender;
            foreach (DetailsViewRow row in ctrl.Rows)
            {
                foreach (TableCell cell in row.Cells)
                {
                    foreach (Control subCtrl in cell.Controls)
                    {
                        string name = subCtrl.GetType().Name;
                        if (subCtrl.GetType().Name == "CheckBox")
                        {
                            string str = "";
                            string cleanControl = "";
                            CheckBox subCtrlck = (CheckBox)subCtrl;
                            str = subCtrlck.Text;
                            cleanControl = cleanForInput(str);
                            if (String.IsNullOrEmpty(resource.Get(cleanControl)))
                            {
                                // Response.Write("<item name=\"" + cleanControl + "\">" + str + "</item>");
                                resource.Add(cleanControl, str);
                            }
                            subCtrlck.Text = resource.Get(cleanControl);
                        }
                        if (subCtrl.GetType().Name == "Label")
                        {
                            string str = "";
                            string cleanControl = "";
                            Label subCtrlck = (Label)subCtrl;
                            str = subCtrlck.Text;
                            cleanControl = cleanForInput(str);
                            if (String.IsNullOrEmpty(resource.Get(cleanControl)))
                            {
                                //   Response.Write("<item name=\"" + cleanControl + "\">" + str + "</item>");
                                resource.Add(cleanControl, str);
                            }
                            subCtrlck.Text = resource.Get(cleanControl);
                        }
                        if (subCtrl.GetType().Name == "LiteralControl")
                        {
                            string str = "";
                            string cleanControl = "";
                            LiteralControl subCtrlck = (LiteralControl)subCtrl;
                            str = subCtrlck.Text;
                            cleanControl = cleanForInput(str);
                            if (String.IsNullOrEmpty(resource.Get(cleanControl)))
                            {
                                //  Response.Write("<item name=\"" + cleanControl + "\">" + str + "</item>");
                                resource.Add(cleanControl, str);
                            }
                            subCtrlck.Text = resource.Get(cleanControl);
                        }
                    }
                }
            }

        }

        protected void changeGridView(object sender, EventArgs e)
        {
            NameValueCollection resource = new NameValueCollection();
            LoadResources(resource);
            GridView ctrl = (GridView)sender;
            foreach (GridViewRow row in ctrl.Rows)
            {
                foreach (TableCell cell in row.Cells)
                {
                    foreach (Control subCtrl in cell.Controls)
                    {
                        string name = subCtrl.GetType().Name;
                        if (subCtrl.GetType().Name == "CheckBox")
                        {
                            string str = "";
                            string cleanControl = "";
                            CheckBox subCtrlck = (CheckBox)subCtrl;
                            str = subCtrlck.Text;
                            cleanControl = cleanForInput(str);
                            if (String.IsNullOrEmpty(resource.Get(cleanControl)))
                            {
                                // Response.Write("<item name=\"" + cleanControl + "\">" + str + "</item>");
                                resource.Add(cleanControl, str);
                            }
                            subCtrlck.Text = resource.Get(cleanControl);
                        }
                        if (subCtrl.GetType().Name == "Label")
                        {
                            string str = "";
                            string cleanControl = "";
                            Label subCtrlck = (Label)subCtrl;
                            str = subCtrlck.Text;
                            cleanControl = cleanForInput(str);
                            if (String.IsNullOrEmpty(resource.Get(cleanControl)))
                            {
                                //Response.Write("<item name=\"" + cleanControl + "\">" + str + "</item>");
                                resource.Add(cleanControl, str);
                            }
                            subCtrlck.Text = resource.Get(cleanControl);
                        }
                        if (subCtrl.GetType().Name == "LiteralControl")
                        {
                            string str = "";
                            string cleanControl = "";
                            LiteralControl subCtrlck = (LiteralControl)subCtrl;
                            str = subCtrlck.Text;
                            cleanControl = cleanForInput(str);
                            if (String.IsNullOrEmpty(resource.Get(cleanControl)))
                            {
                                //  Response.Write("<item name=\"" + cleanControl + "\">" + str + "</item>");
                                resource.Add(cleanControl, str);
                            }
                            subCtrlck.Text = resource.Get(cleanControl);
                        }
                    }
                }
            }

        }



        protected string cleanForInput(string str)
        {
            string rtnStr = str.Replace(" ", "");
            rtnStr = rtnStr.Replace("&", "");
            rtnStr = rtnStr.Replace(":", "");
            rtnStr = rtnStr.Replace("$", "Money");
            rtnStr = rtnStr.Replace("/", "");
            rtnStr = rtnStr.Replace(".", "");
            rtnStr = rtnStr.Replace(",", "");
            rtnStr = rtnStr.Replace("½", "");

            return rtnStr;
        }

        protected void LoadResources(NameValueCollection resource)
        {
            string filename = string.Format("{0}localized\\{1}\\{2}\\Resource.xml", Request.PhysicalApplicationPath, "language", Session["CultureInfo"].ToString());
            XmlDocument xmlDocument = new XmlDocument();
            xmlDocument.Load(filename);
            foreach (XmlNode xmlNode in xmlDocument.SelectSingleNode("Resource"))
            {

                if (xmlNode.NodeType != XmlNodeType.Comment)
                {
                    resource[xmlNode.Attributes["name"].Value] = xmlNode.InnerXml;
                }
            }
        }

        protected void CloneProfile()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {

                int idPlayer = int.Parse(ddlPlayers.SelectedValue);
                SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfile_ClonePlayerProfile", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.Int)).Value = ddlProfiles.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmNewName", SqlDbType.VarChar)).Value = ddlPlayers.SelectedItem.Text;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = idPlayer;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = Convert.ToInt32(Session["idAgent"]);
                SqlDataReader reader;
                reader = comm.ExecuteReader();
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

        protected void ChangeProfilePlayer()
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {

                int idPlayer = int.Parse(ddlPlayers.SelectedValue);
                SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfile_ChangePlayerProfile", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmidPlayer", SqlDbType.Int)).Value = ddlPlayers.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.Int)).Value = ddlProfiles.SelectedValue;
                SqlDataReader reader;
                reader = comm.ExecuteReader();
            }
            catch (Exception err)
            {
                string error = err.Message;
            }
            finally
            {
                Cnn.Close();
            }

        }

        protected bool AceptChanges()
        {
            bool aceptC = false;
            DataTable table = new DataTable();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfile_ProfileAceptChanges", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.Int)).Value = ddlProfiles.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmIdAgent", SqlDbType.Int)).Value = Session["idAgent"];

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            if (table.Rows.Count > 0)
            {
                DataRow linea = table.Rows[0];
                if (linea[0].ToString() == "1")
                {
                    aceptC = true;
                }
            }
            return aceptC;
        }

        protected int GetProfile()
        {
            int idProfile = 1;
            DataTable table = new DataTable();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("AddOn_Player_GetById", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdPlayer", SqlDbType.Int)).Value = ddlPlayers.SelectedValue;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            if (table.Rows.Count > 0)
            {
                DataRow linea = table.Rows[0];
                idProfile = Convert.ToInt32(linea["idProfile"].ToString());
            }
            return idProfile;
        }

        protected DataRow PlayerProfile_GetInfo()
        {
            int idProfile = Convert.ToInt32(ddlProfiles.SelectedValue);
            DataTable table = new DataTable();
            DataRow row = table.NewRow();
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("PlayerProfile_GetInfo", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.Int)).Value = idProfile;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table.Rows[0];
        }

        protected void Addon_Web_PlayerProfile_General()
        {
            DataTable table = new DataTable();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfile_General", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmidProfile", SqlDbType.Int)).Value = ddlProfiles.SelectedValue;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            if (table.Rows.Count > 0)
            {
                DataRow linea = table.Rows[0];
                PC_PitcherChangeType.SelectedValue = linea["PC_PitcherChangeType"].ToString();
                SG_CancelSide.Checked = Convert.ToBoolean(linea["SG_CancelSide"]);
                SG_CancelTotal.Checked = Convert.ToBoolean(linea["SG_CancelTotal"]);
                SG_CancelRunLine.Checked = Convert.ToBoolean(linea["SG_CancelRunLine"]);
                PC_SkipSide.Checked = Convert.ToBoolean(linea["PC_SkipSide"]);
                PC_SkipTotal.Checked = Convert.ToBoolean(linea["PC_SkipTotal"]);
                PC_SkipRunLine.Checked = Convert.ToBoolean(linea["PC_SkipRunLine"]);
                Soc_Hookups.Checked = Convert.ToBoolean(linea["Soc_Hookups"]);
                Rev_AllowOpen.Checked = Convert.ToBoolean(linea["Rev_AllowOpen"]);
                DuplicateBetsCheckLineChange.Checked = Convert.ToBoolean(linea["DuplicateBetsCheckLineChange"]);
                DuplicateBetsCheckParlays.Checked = Convert.ToBoolean(linea["DuplicateBetsCheckParlays"]);
                DuplicateBetsCheckTeasers.Checked = Convert.ToBoolean(linea["DuplicateBetsCheckTeasers"]);
                DuplicateBetsCheckReverses.Checked = Convert.ToBoolean(linea["DuplicateBetsCheckReverses"]);
                DuplicateBetsCheckIfbets.Checked = Convert.ToBoolean(linea["DuplicateBetsCheckIfbets"]);
                DuplicateBetsCheckIfSBRev.Checked = Convert.ToBoolean(linea["DuplicateBetsCheckIfSBRev"]);
                rdnGeneralPaylays.SelectedValue = linea["rdnGeneralPaylays"].ToString();
                rdnGeneralTeaser.SelectedValue = linea["rdnGeneralTeaser"].ToString();
                FPMaxFav.Text = linea["FPMaxFav"].ToString();
                FPMaxPayout.Text = Convert.ToInt32(linea["FPMaxPayout"]).ToString();
                FPMaxTeams.Text = linea["FPMaxTeams"].ToString();
                FPOddsLimit.Text = linea["FPOddsLimit"].ToString();
                FPAllowDuplicatedBets.Checked = Convert.ToBoolean(linea["FPAllowDuplicatedBets"]);
                FPAllowBothSides.Checked = Convert.ToBoolean(linea["FPAllowBothSides"]);
                FPCheckOfficeFilters.Checked = Convert.ToBoolean(linea["FPCheckOfficeFilters"]);
                CLMaxWager.Text = Convert.ToInt32(linea["CLMaxWager"]).ToString();
            }
        }

        protected void Addon_Web_PlayerProfile_GameType(int idGameType)
        {
            DataTable table = new DataTable();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfile_GameType", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmidProfile", SqlDbType.Int)).Value = ddlProfiles.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmIdGameType", SqlDbType.Int)).Value = idGameType;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            if (table.Rows.Count > 0)
            {
                DataRow linea = table.Rows[0];
                FreeHalfPoints.Text = linea["FreeHalfPoints"].ToString();
                AllowON3NFL.Checked = Convert.ToBoolean(linea["AllowON3NFL"]);
                AllowOFF3NFL.Checked = Convert.ToBoolean(linea["AllowOFF3NFL"]);
                AllowON3CFB.Checked = Convert.ToBoolean(linea["AllowON3CFB"]);
                AllowOFF3CFB.Checked = Convert.ToBoolean(linea["AllowOFF3CFB"]);
                AllowON7NFL.Checked = Convert.ToBoolean(linea["AllowON7NFL"]);
                AllowOFF7NFL.Checked = Convert.ToBoolean(linea["AllowOFF7NFL"]);
                AllowON7CFB.Checked = Convert.ToBoolean(linea["AllowON7CFB"]);
                AllowOFF7CFB.Checked = Convert.ToBoolean(linea["AllowOFF7CFB"]);
                PL_CheckSameTeam.Checked = Convert.ToBoolean(linea["PL_CheckSameTeam"]);
                PL_MaxSameTeam.Text = linea["PL_MaxSameTeam"].ToString();
                TL_CheckSameTeam.Checked = Convert.ToBoolean(linea["TL_CheckSameTeam"]);
                TL_MaxSameTeam.Text = linea["TL_MaxSameTeam"].ToString();
                IL_CheckSameTeam.Checked = Convert.ToBoolean(linea["IL_CheckSameTeam"]);
                IL_MaxSameTeam.Text = linea["IL_MaxSameTeam"].ToString();
                PL_UseWideLine.Checked = Convert.ToBoolean(linea["PL_UseWideLine"]);
                UseWideLine.Checked = Convert.ToBoolean(linea["UseWideLine"]);
                SL_CheckMLnSpread.Checked = Convert.ToBoolean(linea["SL_CheckMLnSpread"]);
                PL_CheckMLnSpread.Checked = Convert.ToBoolean(linea["PL_CheckMLnSpread"]);
                PL_CheckTOnTU.Checked = Convert.ToBoolean(linea["PL_CheckTOnTU"]);
                TL_CheckTOnTU.Checked = Convert.ToBoolean(linea["TL_CheckTOnTU"]);
                RL_CheckMLnSpread.Checked = Convert.ToBoolean(linea["RL_CheckMLnSpread"]);
                RL_CheckTOnTU.Checked = Convert.ToBoolean(linea["RL_CheckTOnTU"]);
            }
        }

        protected void Addon_Web_PlayerProfile_Parlay()
        {
            DataTable table = new DataTable();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfile_Parlay", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmidProfile", SqlDbType.Int)).Value = ddlProfiles.SelectedValue;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

            if (table.Rows.Count > 0)
            {
                DataRow linea = table.Rows[0];
                PL_MaxGames.Text = linea["PL_MaxGames"].ToString();
                PL_TrueOddsOption.Checked = Convert.ToBoolean(linea["PL_TrueOddsOption"]);
                PL_MaxOdds.Text = linea["PL_MaxOdds"].ToString();
                PL_MaxPayout.Text = Convert.ToInt32(linea["PL_MaxPayout"]).ToString();
                PL_MaxTeamBuyPoints.Text = linea["PL_MaxTeamBuyPoints"].ToString();
                PL_MaxBuyPoints.Text = linea["PL_MaxBuyPoints"].ToString();
                PL_AlwaysAction.Checked = Convert.ToBoolean(linea["PL_AlwaysAction"]);
                PL_AllowRunLineTotal.Checked = Convert.ToBoolean(linea["PL_AllowRunLineTotal"]);
                PL_AllowSpreadTotalHK.Checked = Convert.ToBoolean(linea["PL_AllowSpreadTotalHK"]);
                PL_AllowSpreadTotalSOC.Checked = Convert.ToBoolean(linea["PL_AllowSpreadTotalSOC"]);
                PL_TieLoses.Checked = Convert.ToBoolean(linea["PL_TieLoses"]);
                PL_ParlayFormula.SelectedValue = linea["PL_ParlayFormula"].ToString();
                PL_AllowOpenPlays.Checked = Convert.ToBoolean(linea["PL_AllowOpenPlays"]);
                PL_OddsDefault.Text = linea["PL_OddsDefault"].ToString();
                PL_LowerUseDefault.Checked = Convert.ToBoolean(linea["PL_LowerUseDefault"]);
                PL_MaxDogsSide.Checked = Convert.ToBoolean(linea["PL_MaxDogsSide"]);
                PL_MaxDogsTotal.Checked = Convert.ToBoolean(linea["PL_MaxDogsTotal"]);
                PL_MaxDogsMoney.Checked = Convert.ToBoolean(linea["PL_MaxDogsMoney"]);
                PL_MaxSumOdds.Text = linea["PL_MaxSumOdds"].ToString();
                PL_UseMaxSumOdds.Checked = Convert.ToBoolean(linea["PL_UseMaxSumOdds"]);
            }
        }


        protected void PlayerProfile_Update()
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            try
            {
                DataRow row = PlayerProfile_GetInfo();
                SqlCommand comm = new SqlCommand("PlayerProfile_Update", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.SmallInt)).Value = row["idProfile"];
                ((SqlParameter)comm.Parameters.Add("@prmProfileName", SqlDbType.VarChar)).Value = row["ProfileName"]; ;
                ((SqlParameter)comm.Parameters.Add("@prmNotes", SqlDbType.VarChar)).Value = Notes.Text;
                ((SqlParameter)comm.Parameters.Add("@prmAlternateProfile", SqlDbType.VarChar)).Value = row["AlternateProfile"]; ;
                ((SqlParameter)comm.Parameters.Add("@prmAlternateEnable", SqlDbType.Bit)).Value = row["AlternateEnable"];
                ((SqlParameter)comm.Parameters.Add("@prmPromotionPoints", SqlDbType.TinyInt)).Value = row["PromotionPoints"];
                ((SqlParameter)comm.Parameters.Add("@prmSL_IfBets", SqlDbType.Bit)).Value = row["SL_IfBets"];
                ((SqlParameter)comm.Parameters.Add("@prmSL_AlwaysActionMLBTotals", SqlDbType.Bit)).Value = ((CheckBox)dvStraightifBets.Rows[0].FindControl("SL_AlwaysActionMLBTotals")).Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_MaxGames", SqlDbType.TinyInt)).Value = PL_MaxGames.Text;
                ((SqlParameter)comm.Parameters.Add("@prmPL_AllowProps", SqlDbType.Bit)).Value = row["PL_AllowProps"];
                ((SqlParameter)comm.Parameters.Add("@prmPL_AllowGolf", SqlDbType.Bit)).Value = row["PL_AllowGolf"];
                ((SqlParameter)comm.Parameters.Add("@prmPL_AllowMatchUps", SqlDbType.Bit)).Value = row["PL_AllowMatchUps"];
                ((SqlParameter)comm.Parameters.Add("@prmPL_NoListedPitchers", SqlDbType.Bit)).Value = row["PL_NoListedPitchers"];
                ((SqlParameter)comm.Parameters.Add("@prmPL_Juice2TeamParlay", SqlDbType.SmallInt)).Value = row["PL_Juice2TeamParlay"];
                ((SqlParameter)comm.Parameters.Add("@prmPL_TrueOddsOption", SqlDbType.Bit)).Value = PL_TrueOddsOption.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_MaxOdds", SqlDbType.Int)).Value = PL_MaxOdds.Text;
                ((SqlParameter)comm.Parameters.Add("@prmPL_MaxPayout", SqlDbType.Money)).Value = PL_MaxPayout.Text;
                ((SqlParameter)comm.Parameters.Add("@prmPL_MaxTeamBuyPoints", SqlDbType.TinyInt)).Value = PL_MaxTeamBuyPoints.Text;
                ((SqlParameter)comm.Parameters.Add("@prmPL_MaxBuyPoints", SqlDbType.Real)).Value = PL_MaxBuyPoints.Text;
                ((SqlParameter)comm.Parameters.Add("@prmPL_AlwaysAction", SqlDbType.Bit)).Value = PL_AlwaysAction.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_AllowRunLineTotal", SqlDbType.Bit)).Value = PL_AllowRunLineTotal.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_AllowSpreadTotalHK", SqlDbType.Bit)).Value = PL_AllowSpreadTotalHK.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_AllowSpreadTotalSOC", SqlDbType.Bit)).Value = PL_AllowSpreadTotalSOC.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_TieLoses", SqlDbType.Bit)).Value = PL_TieLoses.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_ParlayFormula", SqlDbType.TinyInt)).Value = PL_ParlayFormula.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmPL_AllowOpenPlays", SqlDbType.Bit)).Value = PL_AllowOpenPlays.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_OddsDefault", SqlDbType.Int)).Value = PL_OddsDefault.Text;
                ((SqlParameter)comm.Parameters.Add("@prmPL_LowerUseDefault", SqlDbType.Bit)).Value = PL_LowerUseDefault.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_MaxDogsSide", SqlDbType.Bit)).Value = PL_MaxDogsSide.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_MaxDogsTotal", SqlDbType.Bit)).Value = PL_MaxDogsTotal.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_MaxDogsMoney", SqlDbType.Bit)).Value = PL_MaxDogsMoney.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_UseMaxSumOdds", SqlDbType.Bit)).Value = PL_UseMaxSumOdds.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_MaxSumOdds", SqlDbType.Int)).Value = PL_MaxSumOdds.Text;
                ((SqlParameter)comm.Parameters.Add("@prmIL_MaxParlays", SqlDbType.TinyInt)).Value = ((TextBox)dvStraightifBets.Rows[0].FindControl("IL_MaxParlays")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmIL_MaxLevelParlays", SqlDbType.TinyInt)).Value = ((TextBox)dvStraightifBets.Rows[0].FindControl("IL_MaxLevelParlays")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmIL_MaxTeasers", SqlDbType.TinyInt)).Value = ((TextBox)dvStraightifBets.Rows[0].FindControl("IL_MaxTeasers")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmIL_MaxLevelTeasers", SqlDbType.TinyInt)).Value = ((TextBox)dvStraightifBets.Rows[0].FindControl("IL_MaxLevelTeasers")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmIL_MaxNumberSB", SqlDbType.TinyInt)).Value = ((TextBox)dvStraightifBets.Rows[0].FindControl("IL_MaxNumberSB")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmIL_AskAmount", SqlDbType.Bit)).Value = ((CheckBox)dvStraightifBets.Rows[0].FindControl("IL_AskAmount")).Checked;
                ((SqlParameter)comm.Parameters.Add("@prmIL_AllowChildHigher", SqlDbType.Bit)).Value = ((CheckBox)dvStraightifBets.Rows[0].FindControl("IL_AllowChildHigher")).Checked;
                ((SqlParameter)comm.Parameters.Add("@prmILOddsLimit", SqlDbType.Int)).Value = ((TextBox)dvStraightifBets.Rows[0].FindControl("ILOddsLimit")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmPC_PitcherChangeType", SqlDbType.TinyInt)).Value = PC_PitcherChangeType.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmTL_OpenLose", SqlDbType.Bit)).Value = row["TL_OpenLose"];
                ((SqlParameter)comm.Parameters.Add("@prmTL_TeaserCancel", SqlDbType.Bit)).Value = row["TL_TeaserCancel"];
                ((SqlParameter)comm.Parameters.Add("@prmSG_CancelSide", SqlDbType.Bit)).Value = SG_CancelSide.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmSG_CancelTotal", SqlDbType.Bit)).Value = SG_CancelTotal.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmSG_CancelRunLine", SqlDbType.Bit)).Value = SG_CancelRunLine.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPC_SkipSide", SqlDbType.Bit)).Value = PC_SkipSide.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPC_SkipTotal", SqlDbType.Bit)).Value = PC_SkipTotal.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPC_SkipRunLine", SqlDbType.Bit)).Value = PC_SkipRunLine.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmSoc_Hookups", SqlDbType.Bit)).Value = Soc_Hookups.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmRev_AllowOpen", SqlDbType.Bit)).Value = Rev_AllowOpen.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmDuplicateBetsCheckLineChange", SqlDbType.Bit)).Value = DuplicateBetsCheckLineChange.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmDuplicateBetsCheckParlays", SqlDbType.Bit)).Value = DuplicateBetsCheckParlays.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmDuplicateBetsCheckTeasers", SqlDbType.Bit)).Value = DuplicateBetsCheckTeasers.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmDuplicateBetsCheckReverses", SqlDbType.Bit)).Value = DuplicateBetsCheckReverses.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmDuplicateBetsCheckIfbets", SqlDbType.Bit)).Value = DuplicateBetsCheckIfbets.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmDuplicateBetsCheckIfSBRev", SqlDbType.Bit)).Value = DuplicateBetsCheckIfSBRev.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmDuplicateBetsCheckParlaysSB", SqlDbType.Bit)).Value = rdnGeneralPaylays.SelectedValue == "0" ? true : false;
                ((SqlParameter)comm.Parameters.Add("@prmDuplicateBetsCheckTeasersSB", SqlDbType.Bit)).Value = rdnGeneralTeaser.SelectedValue == "0" ? true : false;
                ((SqlParameter)comm.Parameters.Add("@prmDuplicateBetsCheckSameParlay", SqlDbType.Bit)).Value = rdnGeneralPaylays.SelectedValue == "1" ? true : false;
                ((SqlParameter)comm.Parameters.Add("@prmDuplicateBetsCheckSameTeaser", SqlDbType.Bit)).Value = rdnGeneralTeaser.SelectedValue == "1" ? true : false;
                ((SqlParameter)comm.Parameters.Add("@prmFPAllowBothSides", SqlDbType.Bit)).Value = FPAllowBothSides.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmFPAllowDuplicatedBets", SqlDbType.Bit)).Value = FPAllowDuplicatedBets.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmFPCheckOfficeFilters", SqlDbType.Bit)).Value = FPCheckOfficeFilters.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmFPMaxFav", SqlDbType.TinyInt)).Value = FPMaxFav.Text;
                ((SqlParameter)comm.Parameters.Add("@prmFPMaxPayout", SqlDbType.Money)).Value = FPMaxPayout.Text;
                ((SqlParameter)comm.Parameters.Add("@prmFPMaxTeams", SqlDbType.TinyInt)).Value = FPMaxTeams.Text;
                ((SqlParameter)comm.Parameters.Add("@prmFPOddsLimit", SqlDbType.Int)).Value = FPOddsLimit.Text;
                ((SqlParameter)comm.Parameters.Add("@prmCLMaxWager", SqlDbType.Money)).Value = CLMaxWager.Text;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 285;// AGENT ONLINE

                foreach (SqlParameter par in comm.Parameters)
                {
                    var type = par.DbType;
                    var ParameterName = par.ParameterName;
                    var value = par.Value;

                }
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();

            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

        }

        protected void GameRelatedOptions_Update()
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("GameRelatedOptions_Update", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.SmallInt)).Value = ddlProfiles.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmIdSport", SqlDbType.VarChar)).Value = ddlGeneralidSport.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmIdPeriod", SqlDbType.TinyInt)).Value = ddlGeneralIdPeriod.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmMLFav_Over", SqlDbType.Bit)).Value = ((CheckBox)dvRalatedOptionGame.Rows[0].FindControl("MLFav_Over")).Checked;
                ((SqlParameter)comm.Parameters.Add("@prmMLFav_Under", SqlDbType.Bit)).Value = ((CheckBox)dvRalatedOptionGame.Rows[0].FindControl("MLFav_Under")).Checked;
                ((SqlParameter)comm.Parameters.Add("@prmMLDog_Over", SqlDbType.Bit)).Value = ((CheckBox)dvRalatedOptionGame.Rows[0].FindControl("MLDog_Over")).Checked;
                ((SqlParameter)comm.Parameters.Add("@prmMLDog_Under", SqlDbType.Bit)).Value = ((CheckBox)dvRalatedOptionGame.Rows[0].FindControl("MLDog_Under")).Checked;
                ((SqlParameter)comm.Parameters.Add("@prmSprFav_Over", SqlDbType.Bit)).Value = ((CheckBox)dvRalatedOptionGame.Rows[0].FindControl("SprFav_Over")).Checked;
                ((SqlParameter)comm.Parameters.Add("@prmSprFav_Under", SqlDbType.Bit)).Value = ((CheckBox)dvRalatedOptionGame.Rows[0].FindControl("SprFav_Under")).Checked;
                ((SqlParameter)comm.Parameters.Add("@prmSprDog_Over", SqlDbType.Bit)).Value = ((CheckBox)dvRalatedOptionGame.Rows[0].FindControl("SprDog_Over")).Checked;
                ((SqlParameter)comm.Parameters.Add("@prmSprDog_Under", SqlDbType.Bit)).Value = ((CheckBox)dvRalatedOptionGame.Rows[0].FindControl("SprDog_Under")).Checked;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 285;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();

            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

        }

        protected void PlayerProfileGameType_Update()
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("PlayerProfileGameType_Update", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.SmallInt)).Value = ddlProfiles.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmIdGameType", SqlDbType.Int)).Value = gtIdGameType.Value;
                ((SqlParameter)comm.Parameters.Add("@prmFreeHalfPoints", SqlDbType.TinyInt)).Value = FreeHalfPoints.Text;
                ((SqlParameter)comm.Parameters.Add("@prmAllowON3NFL", SqlDbType.Bit)).Value = AllowON3NFL.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmAllowOFF3NFL", SqlDbType.Bit)).Value = AllowOFF3NFL.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmAllowON3CFB", SqlDbType.Bit)).Value = AllowON3CFB.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmAllowOFF3CFB", SqlDbType.Bit)).Value = AllowOFF3CFB.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmAllowON7NFL", SqlDbType.Bit)).Value = AllowON7NFL.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmAllowOFF7NFL", SqlDbType.Bit)).Value = AllowOFF7NFL.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmAllowON7CFB", SqlDbType.Bit)).Value = AllowON7CFB.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmAllowOFF7CFB", SqlDbType.Bit)).Value = AllowOFF7CFB.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_CheckSameTeam", SqlDbType.Bit)).Value = PL_CheckSameTeam.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_MaxSameTeam", SqlDbType.TinyInt)).Value = PL_MaxSameTeam.Text;
                ((SqlParameter)comm.Parameters.Add("@prmTL_CheckSameTeam", SqlDbType.Bit)).Value = TL_CheckSameTeam.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmTL_MaxSameTeam", SqlDbType.TinyInt)).Value = TL_MaxSameTeam.Text;
                ((SqlParameter)comm.Parameters.Add("@prmIL_CheckSameTeam", SqlDbType.Bit)).Value = IL_CheckSameTeam.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmIL_MaxSameTeam", SqlDbType.TinyInt)).Value = IL_MaxSameTeam.Text;
                ((SqlParameter)comm.Parameters.Add("@prmPL_UseWideLine", SqlDbType.Bit)).Value = PL_UseWideLine.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmUseWideLine", SqlDbType.Bit)).Value = UseWideLine.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmSL_CheckMLnSpread", SqlDbType.Bit)).Value = SL_CheckMLnSpread.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_CheckMLnSpread", SqlDbType.Bit)).Value = PL_CheckMLnSpread.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmPL_CheckTOnTU", SqlDbType.Bit)).Value = PL_CheckTOnTU.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmTL_CheckTOnTU", SqlDbType.Bit)).Value = TL_CheckTOnTU.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmRL_CheckMLnSpread", SqlDbType.Bit)).Value = RL_CheckMLnSpread.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmRL_CheckTOnTU", SqlDbType.Bit)).Value = RL_CheckTOnTU.Checked;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 285;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();

            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

        }

        protected void PlayerProfileStraightLimit_Update(string idSport, DetailsView dv)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("PlayerProfileStraightLimit_Update", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.SmallInt)).Value = ddlProfiles.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmIdSport", SqlDbType.VarChar)).Value = idSport;
                ((SqlParameter)comm.Parameters.Add("@prmSpreadPointsPurchaseMax", SqlDbType.Real)).Value = ((TextBox)dv.Rows[0].FindControl("SpreadPointsPurchaseMax")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmSpreadPriceHalfPoints", SqlDbType.SmallInt)).Value = ((TextBox)dv.Rows[0].FindControl("SpreadPriceHalfPoints")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmSpreadJuiceDefault", SqlDbType.SmallInt)).Value = ((TextBox)dv.Rows[0].FindControl("SpreadJuiceDefault")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmTotalPointsPurchaseMax", SqlDbType.Real)).Value = ((TextBox)dv.Rows[0].FindControl("TotalPointsPurchaseMax")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmTotalPriceHalfPoints", SqlDbType.SmallInt)).Value = ((TextBox)dv.Rows[0].FindControl("TotalPriceHalfPoints")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmTotalJuiceDefault", SqlDbType.SmallInt)).Value = ((TextBox)dv.Rows[0].FindControl("TotalJuiceDefault")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmOn3Surcharge", SqlDbType.SmallInt)).Value = idSport == "NFL" || idSport == "CFB" ? ((TextBox)dv.Rows[0].FindControl("On3Surcharge")).Text : "0";
                ((SqlParameter)comm.Parameters.Add("@prmOff3Surcharge", SqlDbType.SmallInt)).Value = idSport == "NFL" || idSport == "CFB" ? ((TextBox)dv.Rows[0].FindControl("Off3Surcharge")).Text : "0";
                ((SqlParameter)comm.Parameters.Add("@prmOn7Surcharge", SqlDbType.SmallInt)).Value = idSport == "NFL" || idSport == "CFB" ? ((TextBox)dv.Rows[0].FindControl("On7Surcharge")).Text : "0";
                ((SqlParameter)comm.Parameters.Add("@prmOff7Surcharge", SqlDbType.SmallInt)).Value = idSport == "NFL" || idSport == "CFB" ? ((TextBox)dv.Rows[0].FindControl("Off7Surcharge")).Text : "0";
                ((SqlParameter)comm.Parameters.Add("@prmSurchargeTwice_3pts", SqlDbType.Bit)).Value = idSport == "NFL" || idSport == "CFB" ? ((CheckBox)dv.Rows[0].FindControl("SurchargeTwice_3pts")).Checked : false;
                ((SqlParameter)comm.Parameters.Add("@prmSurchargeTwice_7pts", SqlDbType.Bit)).Value = idSport == "NFL" || idSport == "CFB" ? ((CheckBox)dv.Rows[0].FindControl("SurchargeTwice_7pts")).Checked : false;
                ((SqlParameter)comm.Parameters.Add("@prmSkipHalfPoint", SqlDbType.Bit)).Value = ((CheckBox)dv.Rows[0].FindControl("SkipHalfPoint")).Checked;
                ((SqlParameter)comm.Parameters.Add("@prmCanBuyOn3", SqlDbType.Bit)).Value = idSport == "NFL" || idSport == "CFB" ? ((CheckBox)dv.Rows[0].FindControl("CanBuyOn3")).Checked : false;
                ((SqlParameter)comm.Parameters.Add("@prmCanBuyOff3", SqlDbType.Bit)).Value = idSport == "NFL" || idSport == "CFB" ? ((CheckBox)dv.Rows[0].FindControl("CanBuyOff3")).Checked : false;
                ((SqlParameter)comm.Parameters.Add("@prmCanBuyOn7", SqlDbType.Bit)).Value = idSport == "NFL" || idSport == "CFB" ? ((CheckBox)dv.Rows[0].FindControl("CanBuyOn7")).Checked : false;
                ((SqlParameter)comm.Parameters.Add("@prmCanBuyOff7", SqlDbType.Bit)).Value = idSport == "NFL" || idSport == "CFB" ? ((CheckBox)dv.Rows[0].FindControl("CanBuyOff7")).Checked : false;

                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 285;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();

            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

        }

        protected void PlayerProfileParlayLimit_Update(GridViewRow gvOdds)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("PlayerProfileParlayLimit_Update", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.SmallInt)).Value = ddlProfiles.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmNumTeams", SqlDbType.TinyInt)).Value = gvOdds.Cells[0].Text;
                ((SqlParameter)comm.Parameters.Add("@prmIdWagerType", SqlDbType.Int)).Value = ((HiddenField)gvOdds.FindControl("IdWagerType")).Value;
                ((SqlParameter)comm.Parameters.Add("@prmOdds", SqlDbType.Real)).Value = ((TextBox)gvOdds.FindControl("Odds")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmMaxRisk", SqlDbType.Real)).Value = ((TextBox)gvOdds.FindControl("MaxRisk")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmMaxPayout", SqlDbType.Real)).Value = ((TextBox)gvOdds.FindControl("MaxPayout")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmExtraJuice", SqlDbType.TinyInt)).Value = ((TextBox)gvOdds.FindControl("ExtraJuice")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmMaxOpenSpots", SqlDbType.TinyInt)).Value = ((TextBox)gvOdds.FindControl("MaxOpenSpots")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmMaxDogLines", SqlDbType.TinyInt)).Value = ((TextBox)gvOdds.FindControl("MaxDogLines")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmMaxMoneyLines", SqlDbType.TinyInt)).Value = ((TextBox)gvOdds.FindControl("MaxMoneyLines")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmMaxTotalLines", SqlDbType.TinyInt)).Value = ((TextBox)gvOdds.FindControl("MaxTotalLines")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 285;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();

            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

        }

        protected void PlayerProfileParlayLimitDetail_Update(GridViewRow maxTeam)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("PlayerProfileParlayLimitDetail_Update", Cnn);
                comm.CommandType = CommandType.StoredProcedure;

                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.SmallInt)).Value = ddlProfiles.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmIdSport", SqlDbType.VarChar)).Value = maxTeam.Cells[0].Text;
                ((SqlParameter)comm.Parameters.Add("@prmNumTeams", SqlDbType.TinyInt)).Value = ddlNumTeams.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmMaxGames", SqlDbType.TinyInt)).Value = ((TextBox)maxTeam.FindControl("MaxGames")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmMaxDogs", SqlDbType.TinyInt)).Value = ((TextBox)maxTeam.FindControl("MaxDogs")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmUseFormula", SqlDbType.Bit)).Value = false;
                ((SqlParameter)comm.Parameters.Add("@prmMaxMoneyLines", SqlDbType.TinyInt)).Value = ((TextBox)maxTeam.FindControl("MaxMoneyLines")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmMaxTotalLines", SqlDbType.TinyInt)).Value = ((TextBox)maxTeam.FindControl("MaxTotalLines")).Text;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 285;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();

            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

        }

        protected void PlayerProfileParlayBasicSports_Update(GridViewRow basicSports)
        {
            string DGSDATAConnectionString = ConfigurationManager.ConnectionStrings["DGSDATAConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGSDATAConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("PlayerProfileParlayBasicSports_Update", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmIdProfile", SqlDbType.SmallInt)).Value = ddlProfiles.SelectedValue;
                ((SqlParameter)comm.Parameters.Add("@prmIdSport", SqlDbType.VarChar)).Value = basicSports.Cells[0].Text;
                ((SqlParameter)comm.Parameters.Add("@prmBasicSport", SqlDbType.Bit)).Value = ((CheckBox)basicSports.FindControl("BasicSport")).Checked;
                ((SqlParameter)comm.Parameters.Add("@prmIdUser", SqlDbType.SmallInt)).Value = 285;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();

            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }

        }


        protected void btnApply_Click(object sender, EventArgs e)
        {
            PlayerProfile_Update();
            GameRelatedOptions_Update();
            PlayerProfileGameType_Update();
            PlayerProfileStraightLimit_Update("NFL", dvStraightNFL);
            PlayerProfileStraightLimit_Update("CBB", dvStraightCBB);
            PlayerProfileStraightLimit_Update("NBA", dvStraightNBA);
            PlayerProfileStraightLimit_Update("CFB", dvStraightCFB);

            foreach (GridViewRow odds in gvOdds.Rows)
            {
                PlayerProfileParlayLimit_Update(odds);
            }
            foreach (GridViewRow mTeam in gvMaxTeams.Rows)
            {
                PlayerProfileParlayLimitDetail_Update(mTeam);
            }
            foreach (GridViewRow basicSports in gvBasicSports.Rows)
            {
                PlayerProfileParlayLimitDetail_Update(basicSports);
            }

        }
        protected void btnCreate_Click(object sender, EventArgs e)
        {
            CloneProfile();
            ddlProfiles.DataBind();
            ddlProfiles.SelectedValue = GetProfile().ToString();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            try
            {
                // GridView1.DataBind();
                ddlProfiles.SelectedValue = GetProfile().ToString();
            }
            catch { }
        }

        protected void btnSetProfile_Click(object sender, EventArgs e)
        {
            ChangeProfilePlayer();
            ddlProfiles.SelectedValue = GetProfile().ToString();
        }

        protected void ddlProfiles_DataBound(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ddlProfiles.SelectedValue = GetProfile().ToString();
                Addon_Web_PlayerProfile_General();
                Addon_Web_PlayerProfile_Parlay();
            }
        }

        protected void gvGameTypes_DataBound(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string gametype = ((HiddenField)gvGameTypes.Rows[0].FindControl("HiddenField1")).Value;
                Addon_Web_PlayerProfile_GameType(Convert.ToInt32(gametype));
            }
        }





        protected void ddlPlayers_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                ddlProfiles.SelectedValue = GetProfile().ToString();
            }
            catch { }
        }

        protected void ddlAgents_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                ddlPlayers.DataBind();
                //  GridView1.DataBind();
                ddlProfiles.SelectedValue = GetProfile().ToString();
            }
            catch { }
        }




        protected void DetailsView1_DataBound(object sender, EventArgs e)
        {
            for (int i = 0; i < dvRalatedOptionGame.Rows.Count; i++)
            {
                dvRalatedOptionGame.Rows[i].Controls[0].Visible = false;
            }

            changeDetailsView(sender, e);
        }




        protected void gvGameTypes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            foreach (GridViewRow row in gvGameTypes.Rows)
            {
                row.Attributes.CssStyle.Remove("background-color");
            }
            int indexGrid = Convert.ToInt32(e.CommandArgument);
            GridViewRow GridViewR = gvGameTypes.Rows[indexGrid];
            if (e.CommandName == "btnSelect")
            {
                gtIdGameType.Value = ((HiddenField)GridViewR.FindControl("HiddenField1")).Value;
                GridViewR.Attributes.CssStyle.Add("background-color", "#19a8f4");
                Addon_Web_PlayerProfile_GameType(Convert.ToInt32(gtIdGameType.Value));
            }

            //gvGameTypes.DataBind(); 

        }

        protected void ddlGeneralidSport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Addon_Web_PlayerProfile_ddlPeriod();
            dvRalatedOptionGame.DataBind();
        }

        protected void ddlGeneralIdPeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            dvRalatedOptionGame.DataBind();
        }

        protected void ddlGeneralidSport_DataBound(object sender, EventArgs e)
        {
            Addon_Web_PlayerProfile_ddlPeriod();
            dvRalatedOptionGame.DataBind();
        }




        protected void Addon_Web_PlayerProfile_ddlPeriod()
        {
            DataTable table = new DataTable();
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            Cnn.Open();
            try
            {
                SqlCommand comm = new SqlCommand("Addon_Web_PlayerProfile_ddlPeriod", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@prmidSport", SqlDbType.VarChar)).Value = ddlGeneralidSport.SelectedValue;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch (Exception myError)
            {
                string error = myError.Message;
            }

            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            ddlGeneralIdPeriod.Items.Clear();
            while (ddlGeneralIdPeriod.Items.Count > 0)
            {
                ddlGeneralIdPeriod.Items.RemoveAt(0);
            }

            foreach (DataRow linea in table.Rows)
            {
                ListItem item = new ListItem(linea["PeriodDescription"].ToString(), linea["NumberOfPeriod"].ToString());
                ddlGeneralIdPeriod.Items.Add(item);
            }
            ddlGeneralIdPeriod.DataBind();
        }

        protected void gtddlIdSport_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvMaxPoints.DataBind();
        }

        protected void gtddlWagerType_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvMaxPoints.DataBind();
        }

        protected void ddlProfiles_SelectedIndexChanged(object sender, EventArgs e)
        {
            //FALTA por CARGAr //TODO
            //ddlProfiles.SelectedValue = GetProfile().ToString();
            Addon_Web_PlayerProfile_General();
            Addon_Web_PlayerProfile_Parlay();
            disableControls();

        }

        protected void disableControls()
        {
            bool aceptChanges = AceptChanges();
            foreach (Control ctl in pnDatos.Controls)
            {
                if (ctl.GetType().Name.IndexOf("CheckBox") > -1)
                {
                    ((CheckBox)ctl).Enabled = aceptChanges;
                }
                if (ctl.GetType().Name.IndexOf("TextBox") > -1)
                {
                    ((TextBox)ctl).Enabled = aceptChanges;
                }
                if (ctl.GetType().Name.IndexOf("RadioButtonList") > -1)
                {
                    ((RadioButtonList)ctl).Enabled = aceptChanges;
                }
                if (ctl.GetType().Name.IndexOf("CheckBoxList") > -1)
                {
                    ((CheckBoxList)ctl).Enabled = aceptChanges;
                }
                if (ctl.GetType().Name.IndexOf("DetailsView") > -1)
                {
                    ((DetailsView)ctl).Enabled = aceptChanges;
                }
            }
        }

        protected void gvMaxPoints_DataBound(object sender, EventArgs e)
        {
            bool aceptChanges = AceptChanges();
            foreach (GridViewRow r in ((GridView)sender).Rows)
            {
                if (r.RowType == DataControlRowType.DataRow)
                {
                    TableCellCollection tbcCol = (TableCellCollection)r.Cells;
                    foreach (TableCell tblCell in tbcCol)
                    {
                        foreach (Control ctl2 in tblCell.Controls)
                        {
                            if (ctl2.GetType().Name.IndexOf("CheckBox") > -1)
                            {
                                ((CheckBox)ctl2).Enabled = aceptChanges;
                            }
                            if (ctl2.GetType().Name.IndexOf("TextBox") > -1)
                            {
                                ((TextBox)ctl2).Enabled = aceptChanges;
                            }
                        }
                    }

                }
            }
            GridView_DataBound(sender, e);

        }

        protected void dvStraightCBB_DataBound(object sender, EventArgs e)
        {
            changeDetailsView(sender, e);
        }

        protected void dvStraightNFL_DataBound(object sender, EventArgs e)
        {
            changeDetailsView(sender, e);
        }

        protected void dvStraightNBA_DataBound(object sender, EventArgs e)
        {
            changeDetailsView(sender, e);
        }

        protected void dvStraightCFB_DataBound(object sender, EventArgs e)
        {
            changeDetailsView(sender, e);
        }

        protected void dvStraightifBets_DataBound(object sender, EventArgs e)
        {
            changeDetailsView(sender, e);
        }

        protected void GridView_DataBound(object sender, EventArgs e)
        {
            changeGridView(sender, e);
        }
    }
}
