using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DGSinterface;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Xml;
using Localization;
using System.Web.Profile;
using System.Web.SessionState;

namespace AgentSite4.Betslip
{
    public partial class Leagues : BasePage, IRequiresSessionState
    {
        private XslCompiledTransform xslStyle;
        private bool clearSession = false;

        protected override void OnInit(EventArgs e)
        {
            string str = this.Server.MapPath("~/betslip") + "\\";
            string themePath = HttpContext.Current.Request.ApplicationPath + "/betslip/";
            byte WagerType = (byte)0;
            if (this.Request.QueryString["WT"] != null)
                WagerType = byte.Parse(this.Request.QueryString["WT"]);
            try
            {
                AddOnWebClient.Wager wagerInstance = new AddOnWebClient.Wager();
                CResultLogin cresultLogin = (CResultLogin)this.Context.Session["userdata"];
                if (cresultLogin.EnableSports)
                {
                    //CResultActiveLeagues activeLeaguesOrg = wagerInstance.GetActiveLeagues(cresultLogin.IdBook, cresultLogin.IdProfile, cresultLogin.IdLineType, WagerType, cresultLogin.IdLanguage);
                    CResultActiveLeagues activeLeagues = GetActiveLeagues(cresultLogin.IdAgent, cresultLogin.IdBook, cresultLogin.IdProfile, cresultLogin.IdLineType, WagerType, cresultLogin.IdLanguage);

                    if (activeLeagues.ErrorCode == CErrorCode.ErrorNone)
                    {
                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.LoadXml(((AResult)activeLeagues).ToXml());
                        this.Transform(str + "Leagues.xslt");
                        StringWriter stringWriter = new StringWriter();
                        xslStyle.Transform((IXPathNavigable)xmlDocument, (XsltArgumentList)null, (TextWriter)stringWriter);
                        StringBuilder stringBuilder = new StringBuilder();
                        stringBuilder.Append("<%@ Register TagPrefix=\"Localized\" Namespace=\"Localization\" Assembly=\"Localization\" %>");
                        stringBuilder.Append(stringWriter.ToString().Replace("xmlns:asp=\"remove\"", "").Replace("xmlns:Localized=\"remove\"", ""));
                        this.PlaceHolder.Controls.Add(this.Page.ParseControl(stringBuilder.ToString()));
                        foreach (Control control in this.PlaceHolder.Controls[0].Controls)
                        {
                            if (control.ID != null && control.ID.Substring(0, 4) == "idx_")
                                ((LinkButton)control).Command += new CommandEventHandler(this.lnk_Command);
                            else if (control.ID != null && control.ID.Substring(0, 4) == "btn_")
                            {
                                if (control.GetType().Name.IndexOf("ImageButton") == -1)
                                    ((Button)control).Click += new EventHandler(this.btnButton_Click);
                                else
                                    ((ImageButton)control).Click += new ImageClickEventHandler(this.btnButton_Click);
                            }
                        }
                    }

                }

            }
            catch (Exception ex)
            {
                this.PlaceHolder.Controls.Add((Control)new LiteralControl(ResourceManager.GetString("RemotingServerNotConnect")));
            }
            if (clearSession)
            {
                Context.Session.Clear();
            }
        }

        private void Transform(string FilePath)
        {
            if (xslStyle != null)
                return;
            xslStyle = new XslCompiledTransform();
            xslStyle.Load(FilePath);
        }

        protected CResultActiveLeagues GetActiveLeagues(int idAgent, short IdBook, short IdProfile, short IdLineType, byte WagerType, byte Language)
        {
            DataTable leagues = null;
            if (this.Request.QueryString["F"] != null)
            {
                leagues = getLeaguesFavorites(idAgent, IdBook, IdLineType, WagerType);
            }
            else
            {
                leagues = getLeaguesDataTable(idAgent, IdBook, IdLineType, WagerType);
            }
            TLeague[] aLeagues = new TLeague[leagues.Rows.Count];
            int i = 0;
            foreach (DataRow linea in leagues.Rows)
            {
                bool Active = true;
                string Description = linea["LeagueDescription"].ToString();
                short IdLeague = Convert.ToInt16(linea["IdLeague"]);
                short IdLeagueRegion = Convert.ToInt16(linea["IDLeagueRegion"]);
                string IdSport = linea["IdSport"].ToString();
                int IdWebRow = Convert.ToInt32(linea["IdWebRow"]);
                string IndexName = linea["RowDescription"].ToString(); //ya esta bien 
                int Order = Convert.ToInt16(linea["RowOrder"]);
                string Region = "";
                TLeague aLeagues2 = new TLeague(IdLeague, Order, IndexName, IdSport, Description, Region, Active, IdWebRow, IdLeagueRegion);
                aLeagues[i] = aLeagues2;

                i = i + 1;
            }
            CResultActiveLeagues cr = new CResultActiveLeagues();
            cr.IdBook = IdBook;
            cr.WagerType = WagerType;
            cr.Leagues = aLeagues;
            return cr;
        }


        protected DataTable getLeaguesDataTable(int idAgent, short IdBook, short IdLineType, byte WagerType)
        {
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            DataTable table = new DataTable();
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("AddOn_WebGetActiveLeagues", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@idAgent", SqlDbType.Int)).Value = idAgent;
                ((SqlParameter)comm.Parameters.Add("@IdBook", SqlDbType.SmallInt)).Value = IdBook;
                ((SqlParameter)comm.Parameters.Add("@IdLineType", SqlDbType.SmallInt)).Value = IdLineType;
                ((SqlParameter)comm.Parameters.Add("@WagerType", SqlDbType.TinyInt)).Value = WagerType;
                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch { }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
        }

        protected DataTable getLeaguesFavorites(int idAgent, short IdBook, short IdLineType, byte WagerType)
        {
            CResultLogin cresultLogin = (CResultLogin)this.Context.Session["userdata"];
            string DGS_AddOnsConnectionString = ConfigurationManager.ConnectionStrings["DGS_AddOnsConnectionString"].ConnectionString;
            SqlConnection Cnn = new SqlConnection(DGS_AddOnsConnectionString);
            DataTable table = new DataTable();
            try
            {
                Cnn.Open();
                SqlCommand comm = new SqlCommand("AddOn_WebGetActiveLeaguesFavorites", Cnn);
                comm.CommandType = CommandType.StoredProcedure;
                ((SqlParameter)comm.Parameters.Add("@idAgent", SqlDbType.Int)).Value = idAgent;
                ((SqlParameter)comm.Parameters.Add("@IdBook", SqlDbType.SmallInt)).Value = IdBook;
                ((SqlParameter)comm.Parameters.Add("@IdLineType", SqlDbType.SmallInt)).Value = IdLineType;
                ((SqlParameter)comm.Parameters.Add("@WagerType", SqlDbType.TinyInt)).Value = WagerType;
                ((SqlParameter)comm.Parameters.Add("@idPlayer", SqlDbType.Int)).Value = cresultLogin.IdPlayer;

                SqlDataReader readerAgent;
                readerAgent = comm.ExecuteReader();
                table.Load(readerAgent);
            }
            catch { }
            finally
            {
                if (Cnn.State == ConnectionState.Open) Cnn.Close();
            }
            return table;
        }

        protected void btnButton_Click(object sender, EventArgs e)
        {
            string sel = "";
            foreach (string index in this.Request.Form.Keys)
            {
                if (index.Substring(0, 3) == "lg_")
                {
                    if (sel != string.Empty)
                        sel += ",";
                    sel += this.Request.Form[index];
                }
            }
            if (((Button)sender).ClientID.ToString().IndexOf("Favorites") > 0)
            {
                ProcessRequest("Favorites", sel);
            }
            else
            {
                ProcessRequest("CreateSports", sel);
            }
        }

        protected void lnk_Command(object sender, CommandEventArgs e)
        {
            ProcessRequest("CreateSports", e.CommandArgument.ToString());
        }


        public void ProcessRequest(string sender, string sel)
        {
            HttpServerUtility server = HttpContext.Current.Server;
            HttpRequest request = HttpContext.Current.Request;
            if (sender == "CreateSports")
            {
                string str = "0";
                if (request.QueryString["WT"] != null && request.QueryString["WT"] != string.Empty)
                    str = request.QueryString["WT"];
                if (ConfigurationManager.AppSettings["UseTradicionalSchedule"] != null)
                {
                    if (ConfigurationManager.AppSettings["UseTradicionalSchedule"].ToString().Trim().ToUpper() == "TRUE")
                        server.Transfer("Schedule.aspx?WT=" + str + "&lg=" + sel, false);
                    else
                        server.Transfer("NewSchedule.aspx?WT=" + str + "&lg=" + sel, false);
                }
                else
                    server.Transfer("Schedule.aspx?WT=" + str + "&lg=" + sel, false);
            }
            else if (sender == "Favorites")
            {
                HttpContext.Current.Response.Redirect("CreateSports.aspx?WT=" + Request.QueryString["WT"] + "&F=1");
            }
        }
    }
}