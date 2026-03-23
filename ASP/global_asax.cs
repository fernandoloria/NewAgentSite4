using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;
using System.Web.Profile;

namespace AgentSite4.ASP
{
    [CompilerGlobalScope]
    public class global_asax : Global
    {
        private static bool __initialized;

        [DebuggerNonUserCode]
        public global_asax()
        {
            if (global_asax.__initialized)
                return;
            global_asax.__initialized = true;
        }

        protected DefaultProfile Profile
        {
            get
            {
                return (DefaultProfile)this.Context.Profile;
            }
        }
    }
}