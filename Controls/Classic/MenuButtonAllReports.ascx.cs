using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AgentSite4.Controls
{
    public partial class MenuButtonAllReports : System.Web.UI.UserControl
    {
        protected List<string> fileList;
        protected void Page_Load(object sender, EventArgs e)
        {
            string reportFolderPath = Server.MapPath("~/Report");

            var fileList = Directory.GetFiles(reportFolderPath, "*.aspx")
                .Select(filePath => Path.GetFileName(filePath))
                .Where(fileName => !fileName.Equals("ErrorHandle.aspx", StringComparison.OrdinalIgnoreCase) &&
                                   !fileName.Equals("AgentCreate.aspx", StringComparison.OrdinalIgnoreCase) &&
                                   !fileName.Equals("AgentPlayerEdit.aspx", StringComparison.OrdinalIgnoreCase) &&
                                   !fileName.Equals("AgentWagerListing.aspx", StringComparison.OrdinalIgnoreCase) &&
                                   !fileName.Equals("CreatePlayer.aspx", StringComparison.OrdinalIgnoreCase) &&
                                   !fileName.Equals("LockScreen.aspx", StringComparison.OrdinalIgnoreCase) &&
                                   !fileName.Equals("AgentCommissionV2.aspx", StringComparison.OrdinalIgnoreCase) &&
                                   !fileName.Equals("ManageSubAgent.aspx", StringComparison.OrdinalIgnoreCase) &&
                                   !fileName.Equals("AnotherFile", StringComparison.OrdinalIgnoreCase)


                                   )
                .ToList();


            if (!IsPostBack)
            {
                filesRepeater.DataSource = fileList;
                filesRepeater.DataBind();
            }
        }
    }
}