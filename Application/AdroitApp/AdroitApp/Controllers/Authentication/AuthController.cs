using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using Libraries.Service;

namespace AdroitApp.Controllers.Authentication
{
    public class AuthController : Controller
    {
        //
        // GET: /Auth/

        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Authenticate(string userName, string password)
        {
            DataTable dt = new DataTable();
            LoginService ls = new LoginService();
            dt = ls.authenticateUser(userName, password);
            if (dt.Rows.Count > 0)
            {
                MySession.userId = Convert.ToInt32(dt.Rows[0]["userId"]);
                MySession.userName = Convert.ToString(dt.Rows[0]["firstName"]);
                //MySession.role="all";
                return RedirectToAction("Index", "Home");
            }
            else
            {
                return RedirectToAction("index", "Login");
            }
        }
        public ActionResult Suspend()
        {
            Session.Abandon();
            return RedirectToAction("index", "Login");
        }
    }
}
