using Consuntency.Security;
using Consuntency_BLL.Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Consuntency.Controllers
{
    [CustomAuthorize]
    public class SendEmailController : Controller
    {
        // GET: SendEmail
        SendEmailService _sendEmailServ = new SendEmailService();
        public ActionResult sendEmail(string candidateIds)
        {
            return View();
        }
        public JsonResult getCandidateEmailId_byCandidateIds(string candidateIds)
        {
            string msg = null;
            List<string> listEmailId = new List<string>();
            try
            {
                listEmailId = _sendEmailServ.getCandidateEmailId_byCandidateIds(candidateIds);
            }
            catch (Exception ex)
            {

                msg = "Error:" + ex.Message;
            }
            return Json(new { listEmailId=listEmailId,msg=msg},JsonRequestBehavior.AllowGet);
        }
    }
}