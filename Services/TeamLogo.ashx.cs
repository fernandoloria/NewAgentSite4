using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Caching;

namespace TeamLogos
{
    /// <summary>
    /// Summary description for TeamLogo
    /// </summary>
    public class TeamLogo : IHttpHandler
    {

        private static readonly Cache cache = HttpRuntime.Cache;
        public void ProcessRequest(HttpContext context)
        {
            
            int idGame = 0;
            string team = context.Request.QueryString["team"];
            string height = context.Request.QueryString["height"];
            int rot = 0;

            if (!string.IsNullOrEmpty(context.Request.QueryString["idGame"]))
            {
                try
                {
                    idGame = Convert.ToInt32(context.Request.QueryString["idGame"]);

                }
                catch { }
            }

            if (!string.IsNullOrEmpty(context.Request.QueryString["rot"]))
            {
                
                try
                {
                    rot = Convert.ToInt32(context.Request.QueryString["rot"]);
                    string cacheKey = string.Format("TeamLogo_{0}_{1}", idGame, rot);
                    object cachedResult = context.Cache[cacheKey];
                    if (cachedResult == null)
                    {
                        dsTeamLogosTableAdapters.GetWagerVisitorHomeTableAdapter ta = new TeamLogos.dsTeamLogosTableAdapters.GetWagerVisitorHomeTableAdapter();
                        ta.GetData(idGame, rot, ref team);
                        cache.Insert(cacheKey, team, null, DateTime.Now.AddMinutes(60), Cache.NoSlidingExpiration);
                    }
                    else
                    {
                        team = cachedResult as string;
                    }
                }
                catch { }
            }

            if (String.IsNullOrEmpty(height))
            {
                height = "96";
            }
            if (String.IsNullOrEmpty(team))
            {
                team = "v";
            }

            GetTeamLogo gt = new GetTeamLogo();
            ReducirImagen foto = gt.getTeam(idGame, team, height);
            context.Response.ContentType = "Image/Png";
            context.Response.BinaryWrite(foto.datosReducidos);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}