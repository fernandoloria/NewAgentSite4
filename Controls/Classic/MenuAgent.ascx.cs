using AgentSite4.ASP;
using DGSinterface;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace AgentSite4.Controls
{
    public partial class MenuAgent : System.Web.UI.UserControl
    {
        protected TreeView AgentMenu;
        private int nSubAgents;
        private string sNumbersubAgent;
        private int nCountIndex;

        protected DefaultProfile Profile => (DefaultProfile)this.Context.Profile;

        protected global_asax ApplicationInstance => (global_asax)this.Context.ApplicationInstance;

        public string SubAgents => this.sNumbersubAgent;


        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                bool.Parse(this.Session["Validated"].ToString());
            }
            catch
            {
                this.Response.Redirect("../Logout.aspx");
            }
            this.LoadData();
            System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo(Session["CultureInfo"].ToString());
            System.Threading.Thread.CurrentThread.CurrentCulture = ci;
            System.Threading.Thread.CurrentThread.CurrentUICulture = ci;

        }

        private void LoadData()
        {
            try
            {
                AddOnWebClient.Agent agentInstance = new AddOnWebClient.Agent();
                CResultAgentList cresultAgentList = new CResultAgentList();
                if (!this.IsPostBack)
                {
                    XmlDocument xmlDoc = new XmlDocument();
                    long IdAgent = Convert.ToInt32(Session["IdAgent"]);
                    string agent = this.Session["Agent"].ToString();
                    string key = IdAgent + "," + agent + ",GetReportAgentList";

                    CResultAgentList reportAgentList;
                    if (HttpContext.Current.Cache[key] != null)
                    {
                        reportAgentList = (CResultAgentList)HttpContext.Current.Cache[key];
                    }
                    else
                    {
                        reportAgentList = agentInstance.GetReportAgentList(long.Parse(this.Session["IdAgent"].ToString()), this.Session["Agent"].ToString());
                        HttpContext.Current.Cache.Insert(key, reportAgentList, null, DateTime.Now.AddMinutes(20), System.Web.Caching.Cache.NoSlidingExpiration);
                    }
                    xmlDoc.LoadXml(reportAgentList.ToXml());
                    if (xmlDoc.FirstChild.Attributes["ErrorCode"].Value.ToString() == CErrorCode.ErrorNone.ToString())
                    {
                        this.GenTreeXml(xmlDoc);
                        this.sNumbersubAgent = this.nSubAgents != 0 ? this.nSubAgents.ToString() + " SubAgents" : "";
                        this.Session["NumSubAgents"] = (object)this.sNumbersubAgent;
                    }
                    else if (xmlDoc.FirstChild.Attributes["ErrorCode"].Value.ToString() == CErrorCode.ErrorValidation.ToString())
                        this.Response.Redirect("../Logout.aspx");
                    else
                        this.Response.Redirect("../Report/ErrorHandle.aspx");
                }
                else
                {
                    this.sNumbersubAgent = this.Session["NumSubAgents"].ToString();
                    if (!(this.AgentMenu.SelectedValue != ""))
                        return;
                    string[] strArray = this.AgentMenu.SelectedValue.Split("_".ToCharArray());
                    this.Session["SubIdAgent"] = (object)strArray.GetValue(0).ToString().Replace("s", "");
                    this.Session["SubAgent"] = (object)strArray.GetValue(1).ToString();
                    this.ReloadPage();
                }
            }
            catch (Exception ex)
            {
                this.Response.Redirect("../Report/ErrorHandle.aspx?Er=" + this.Server.UrlEncode(ex.Message.ToString()));
            }
        }

        private void GenTreeXml(XmlDocument xmlDoc)
        {
            TreeNode child = new TreeNode();
            this.AgentMenuParament();
            XmlNodeList xmlNodeList = xmlDoc.SelectNodes("//detail");
            this.nCountIndex = 0;
            child.Value = xmlNodeList[0].Attributes["IdAgent"].Value.ToString() + "_" + xmlNodeList[0].Attributes["Agent"].Value.ToString();
            child.Text = xmlNodeList[0].Attributes["Agent"].Value.ToString();
            child.Target = "mainFrame";
            if (!(xmlNodeList[0].Attributes["IsDistributor"].Value.ToString() == "True"))
                return;
            this.nSubAgents = xmlNodeList.Count - 1;
            this.AgentMenu.Nodes.Add(child);
            ++this.nCountIndex;
            this.GenRecursiveTree(xmlDoc, child.Text, child.Text, 1, this.AgentMenu.Nodes[0]);

            this.AgentMenu.CollapseAll();
            if (this.AgentMenu.Nodes.Count > 0)
            {
                this.AgentMenu.Nodes[0].Expand();
            }
        }

        private void GenRecursiveTree(
          XmlDocument xDoc,
          string ParentAgent,
          string CurrentAgent,
          int nLvl,
          TreeNode TParent)
        {
            string empty = string.Empty;
            bool flag1 = bool.Parse(ConfigurationManager.AppSettings["WithBalance"].ToString());
            bool flag2 = true;
            try
            {
                while (flag2)
                {
                    XmlNodeList xmlNodeList = xDoc.SelectNodes("//detail[@Level=" + (object)nLvl + "]");
                    if (xmlNodeList.Count > 0)
                    {
                        foreach (XmlNode xmlNode in xmlNodeList)
                        {
                            TreeNode child = new TreeNode();
                            string str = !flag1 ? xmlNode.Attributes["Agent"].Value : xmlNode.Attributes["Agent"].Value + " (" + xmlNode.Attributes["CurrentBalance"].Value + ")";
                            child.Value = xmlNode.Attributes["IdAgent"].Value + "_" + xmlNode.Attributes["Agent"].Value;
                            child.Text = str;
                            child.Target = "_self";
                            //child.
                            TreeNode tResult = (TreeNode)null;
                            this.Find(xmlNode.Attributes[nameof(ParentAgent)].Value, TParent, ref tResult);
                            tResult.ChildNodes.Add(child);
                        }
                        ++nLvl;
                    }
                    else
                        flag2 = false;
                }
            }
            catch (Exception ex)
            {
                ex.ToString();
                this.Response.Redirect("../Report/ErrorHandle.aspx");
            }
        }

        private void GenXmlTree(
          int nIndex,
          XmlNodeList List,
          int MaxCount,
          int nNode,
          TreeNode nParent)
        {
            bool flag = bool.Parse(ConfigurationManager.AppSettings["WithBalance"].ToString());
            try
            {
                while (nIndex < MaxCount + 1)
                {
                    TreeNode child = new TreeNode();
                    string str = !flag ? List[nIndex].Attributes["Agent"].Value.ToString() : List[nIndex].Attributes["Agent"].Value.ToString() + " (" + List[nIndex].Attributes["CurrentBalance"].Value.ToString() + ")";
                    child.Value = List[nIndex].Attributes["IdAgent"].Value.ToString() + "_" + List[nIndex].Attributes["Agent"].Value.ToString();
                    child.Text = str;
                    child.Target = "_self";
                    if (List[nIndex].Attributes["IsDistributor"].Value.ToString() == "True")
                    {
                        nParent.ChildNodes.Add(child);
                        ++this.nCountIndex;
                        this.GenXmlTree(nIndex + 1, List, int.Parse(List[nIndex].Attributes["NumberSub"].Value.ToString()) + nIndex, nIndex, nParent.ChildNodes[nParent.ChildNodes.Count - 1]);
                        nIndex = this.nCountIndex;
                    }
                    else
                    {
                        nParent.ChildNodes.Add(child);
                        ++this.nCountIndex;
                        ++nIndex;
                    }
                }
            }
            catch (Exception ex)
            {
                ex.ToString();
                this.Response.Redirect("../Report/ErrorHandle.aspx");
            }
        }

        private void GenerateTree(CResultAgentList oResult)
        {
            TreeNode child = new TreeNode();
            this.AgentMenuParament();
            CAgentMenuList[] array = oResult.List.ToArray();
            child.Value = array[0].IdAgent.ToString() + "_" + array[0].Agent.ToString();
            child.Text = array[0].Agent.ToString();
            if (array[0].IsDistributor == "True")
            {
                this.nSubAgents = oResult.List.Count - 1;
                this.AgentMenu.Nodes.Add(child);
                this.GenTree(1, array, oResult.List.Count - 1, 0, this.AgentMenu.Nodes[0]);
            }
            else
                this.AgentMenu.Nodes.Add(child);
        }

        private void GenTree(int nindex, CAgentMenuList[] List, int MaxCount, int nNode, TreeNode nParent)
        {
            bool flag = bool.Parse(ConfigurationManager.AppSettings["WithBalance"].ToString());
            TreeNode treeNode = (TreeNode)null;
            try
            {
                while (nindex < MaxCount + 1)
                {
                    TreeNode child = new TreeNode();
                    string str = !flag ? List[nindex].Agent : List[nindex].Agent + " (" + List[nindex].CurrentBalance + ")";
                    child.Value = List[nindex].IdAgent.ToString() + "_" + List[nindex].Agent.ToString();
                    child.Text = str;
                    if (List[nindex].IsDistributor == "True")
                    {
                        nParent.ChildNodes.Add(child);
                        this.GenTree(nindex + 1, List, int.Parse(List[nindex].NumberSub.ToString()) + nindex, nindex, nParent.ChildNodes[nParent.ChildNodes.Count - 1]);
                        nindex += int.Parse(List[nindex].NumberSub.ToString()) + 1;
                    }
                    else
                    {
                        nParent.ChildNodes.Add(child);
                        ++nindex;
                    }
                    treeNode = (TreeNode)null;
                }
            }
            catch (Exception ex)
            {
                ex.ToString();
                this.Response.Redirect("../Report/ErrorHandle.aspx");
            }
        }

        private void AgentMenuParament()
        {
            this.AgentMenu.NodeStyle.CssClass = "treeview";
            this.AgentMenu.NodeIndent = int.Parse(ConfigurationManager.AppSettings["NodeIndent"].ToString());
            this.AgentMenu.Width = (Unit)int.Parse(ConfigurationManager.AppSettings["MenuWidth"].ToString());
            this.AgentMenu.Target = "_self";
        }

        private void ReloadPage()
        {
            if (this.Page.ClientScript.IsClientScriptBlockRegistered("Changethescrpt"))
                return;
            this.Page.ClientScript.RegisterClientScriptBlock(typeof(string), "Changethescrpt", "<script language=\"javascript\">top.mainFrame.location.href=\"../report/welcome.aspx\"; top.topFrame.location.href=\"top.aspx\";</script>");
        }

        private void Find(string findNodeText, TreeNode tParent, ref TreeNode tResult)
        {
            if (tParent.Value.Split('_')[1] == findNodeText)
                tResult = tParent;
            foreach (TreeNode childNode in tParent.ChildNodes)
                this.Find(findNodeText, childNode, ref tResult);
        }

        protected void TreeView1_TreeNodeDataBound(object sender, TreeNodeEventArgs e)
        {
            // Add expand icon for nodes that have child nodes
            if (e.Node.ChildNodes.Count > 0)
            {
                e.Node.Text = $"<span class='fa fa-chevron-right'></span> {e.Node.Text}";
            }
        }
    }

}