<%@ WebHandler Language="C#" Class="Logo" %>

using System;
using System.Web;
using System.Drawing;
using System.IO;

public class Logo : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        Uri uri = new Uri(context.Request.Url.ToString());
        string domain = uri.Host;
        domain = domain.Replace("www.", "");
        domain = domain.Split('.')[0].ToString();
        string imageURL = context.Request.PhysicalApplicationPath + "\\assets\\img\\logo\\logo" + domain + ".png";
        imageURL = context.Request.PhysicalApplicationPath + "\\assets\\img\\logo\\" + "logoabcbetting" + ".png";
        
            if (System.IO.File.Exists(imageURL))
        {
            Bitmap img = new Bitmap(imageURL);
            Bitmap clone = new Bitmap(img.Width, img.Height, System.Drawing.Imaging.PixelFormat.Format32bppPArgb);
            using (Graphics gr = Graphics.FromImage(clone))
            {
                gr.DrawImage(img, new Rectangle(0, 0, clone.Width, clone.Height));
            }

            byte[] logo = new byte[0];

            using (MemoryStream stream = new MemoryStream())
            {
                img.Save(stream, System.Drawing.Imaging.ImageFormat.Png);
                stream.Close();

                logo = stream.ToArray();
            }

            context.Response.ContentType = "image/jpeg";
            context.Response.BinaryWrite(logo);
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}