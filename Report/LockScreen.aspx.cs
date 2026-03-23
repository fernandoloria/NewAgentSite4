using System;
using System.Collections.Generic;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AgentSite4.Controls;
using DGSinterface;
using System.Web.SessionState;

namespace AgentSite4.Report
{
    public partial class LockScreen : BasePage, IRequiresSessionState
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["Authenticated"] = false;
                Session["UnlockAttempts"] = 0;
                Session["UnlockAttemptTime"] = DateTime.MinValue;
            }
        }

        protected void btnUnlock_Click(object sender, EventArgs e)
        {
            string expectedPassword = null;
            CResultAgentLogin creds = this.Session["userdata"] as CResultAgentLogin;
            if (creds != null) expectedPassword = creds.Password;
            if (expectedPassword == null && this.Session["Password"] != null)
                expectedPassword = Convert.ToString(this.Session["Password"]);

            if (string.IsNullOrEmpty(expectedPassword))
            {
                lblMessage.Text = "Session expired. Please log in again.";
                return;
            }

            if (txtPassword.Text.ToUpper() == expectedPassword.ToUpper())
            {
                this.Session["Authenticated"] = true;

                if (creds != null && (this.Session["idAgent"] == null || this.Session["Agent"] == null))
                {
                    LoginForm loginForm = new LoginForm();
                    loginForm.DoLogin(creds.Agent, creds.Password);
                }

                this.Session["UnlockAttempts"] = 0;
                this.Session["UnlockAttemptTime"] = null;

                Response.Redirect("~/Report/Welcome.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            int attempts = 0;
            object oAttempts = this.Session["UnlockAttempts"];
            if (oAttempts != null) int.TryParse(oAttempts.ToString(), out attempts);

            DateTime lastAttempt = DateTime.MinValue;
            object oTime = this.Session["UnlockAttemptTime"];
            if (oTime != null) DateTime.TryParse(oTime.ToString(), out lastAttempt);

            int lockSeconds = attempts * 3;
            double elapsed = (DateTime.UtcNow - lastAttempt).TotalSeconds;

            if (attempts > 0 && elapsed < lockSeconds)
            {
                int wait = (int)Math.Ceiling(lockSeconds - elapsed);
                lblMessage.Text = "Please wait " + wait + " more second" + (wait == 1 ? "" : "s") + " before trying again.";
                return;
            }

            attempts++;
            this.Session["UnlockAttempts"] = attempts;
            this.Session["UnlockAttemptTime"] = DateTime.UtcNow;

            if (attempts >= 3)
                lblMessage.Text = "Incorrect password. Please wait a few seconds before trying again.";
            else
                lblMessage.Text = "Incorrect password. Please try again.";
        }




    }
}