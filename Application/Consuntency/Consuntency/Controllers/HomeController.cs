using Consuntency.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Consuntency.Controllers
{
    [CustomAuthorize]
    public class HomeController : Controller
    {
        // GET: home
        public ActionResult index()
        {
            return View();
            //if (MySession.userName != null)
            //{
            //    return View();
            //}
            //else
            //{
            //    return RedirectToAction("index", "Login");
            //}

        }
    }
}