using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AdroitApp
{
    public class MySession
    {
        public static string userName
        {
            get
            {
                if (HttpContext.Current.Session["userName"] == null)
                {
                    return null;
                }
                else
                {
                    return HttpContext.Current.Session["userName"].ToString();
                }
            }
            set
            {
                HttpContext.Current.Session["userName"] = value;
            }
        }
        public static int userId
        {
            get
            {
                if (HttpContext.Current.Session["userId"] == null)
                {
                    return 0;
                }
                else
                {
                    return Convert.ToInt32(HttpContext.Current.Session["userId"].ToString());
                }
            }
            set
            {
                HttpContext.Current.Session["userId"] = value;
            }
        }
        public static string role
        {
            get
            {
                if (HttpContext.Current.Session["role"] == null)
                {
                    return null;
                }
                else
                {
                    return HttpContext.Current.Session["role"].ToString();
                }
            }
            set
            {
                HttpContext.Current.Session["role"] = value;
            }
        }
    }
}