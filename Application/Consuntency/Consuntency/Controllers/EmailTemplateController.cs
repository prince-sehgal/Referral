using Consuntency.Security;
using Consuntency_BLL.Modal;
using Consuntency_BLL.Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Consuntency.Controllers
{
    [CustomAuthorize]
    public class EmailTemplateController : Controller
    {
        EmailTemplateService _emailTemplateServ = new EmailTemplateService();
        // GET: EmailTemplate
        public ActionResult emailTemplate()
        {
            return View();
            //if (MySession.userName != null)
            //{
            //    return View();
            //}
            //else
            //{
            // return   RedirectToAction("index","Login");
            //}
        }
        public JsonResult saveEmailTemplate(EmailTemplate e)
        {
            string msg = null;
            int status = 0;
            try
            {
                e.crtUserId = MySession.userId;
                status = _emailTemplateServ.saveEmailTemplate(e);
                msg = status > 0 ? "s" : "f";
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult deleteEmailTemplate(string etIds)
        {
            string msg = null;
            int status = 0;
            try
            {

                status = _emailTemplateServ.deleteEmailTemplate(etIds);
                msg = status > 0 ? "s" : "f";
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult getEmailTemplate()
        {
            string msg = null;
            List<EmailTemplate> listET = new List<EmailTemplate>();
            try
            {
                listET = _emailTemplateServ.getEmailTemplate();
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listET=listET, msg = msg }, JsonRequestBehavior.AllowGet);
        }
    }
}