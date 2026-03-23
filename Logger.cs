using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace AgentSite4
{
    public class Logger
    {
        public static void Log(string method, string Msg)
        {
            string path = Environment.SystemDirectory + string.Format("\\logfiles\\dgs\\web\\{0:yyyy_MM_dd}-AgentSite3_log.txt", (object)DateTime.Today);
            try
            {
                StreamWriter streamWriter = File.AppendText(path);
                streamWriter.WriteLine(string.Format("{0:yyyy/MM/dd HH:mm:ss} {1:s} \r\n {2:s}", (object)DateTime.Now, (object)method, (object)Msg));
                streamWriter.WriteLine();
                streamWriter.Close();
            }
            catch
            {
            }
        }
    }
}