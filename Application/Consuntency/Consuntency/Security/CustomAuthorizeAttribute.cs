using Consuntency;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Consuntency.Security
{
    public class CustomAuthorizeAttribute:AuthorizeAttribute
    {
        public override void OnAuthorization(AuthorizationContext filterContext)
        {
            if (string.IsNullOrEmpty(MySession.userName))
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new { controller = "Login", action = "index" }));
            //else
            //{
            //    //AccountModel am = new AccountModel();
            //    //CustomPrincipal mp = new CustomPrincipal(MySession.userName);
            //    //if (!mp.IsInRole(Roles))
            //        filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary( new { controller = "Home", action = "Index" }));
            //}
                
        }
    }
}