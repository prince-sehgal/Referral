using Consuntency_BLL.Service;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Consuntency.Controllers
{
    public class LoginController : Controller
    {
        // GET: login
        public ActionResult index()
        {
            return View();
        }
        [HttpPost]
        public ActionResult authenticateUser(string userName,string password)
        {
            DataTable dt = new DataTable();
            LoginService ls = new LoginService();
            dt = ls.authenticateUser(userName,password);        
            if(dt.Rows.Count>0)
            {
                MySession.userId =Convert.ToInt32(dt.Rows[0]["userId"]);
                MySession.userName =Convert.ToString(dt.Rows[0]["firstName"]);
                //MySession.role="all";
                return RedirectToAction("Index", "Home");
            }
            else
            {
                return RedirectToAction("index", "Login");
            }


            //if(userName.ToLower()=="superadmin" && password=="12345")
            //{
            //    Session["userName"] =Convert.ToString(userName);
            //    TempData["errorMsg"] = string.Empty;
            //    return RedirectToAction("Index","Home");
            //}
            //else
            //{
            //    TempData["errorMsg"] = "Please Enter Valid UserName and Password";
            //    return RedirectToAction("index", "Login");
            //}

        }
        public ActionResult logout()
        {
            Session.Abandon();
            return RedirectToAction("index", "Login");
        }
        
    }
}