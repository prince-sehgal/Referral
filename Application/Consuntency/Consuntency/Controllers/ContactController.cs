using Consuntency.Security;
using Consuntency_BLL.Modal;
using Consuntency_BLL.Service;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Consuntency.Controllers
{
    [CustomAuthorize]
    public class ContactController : Controller
    {
        ContactService _conSer = new ContactService();
        // GET: Contact
        public ActionResult contact()
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
        public JsonResult saveContact(Contact co)
        {
            string msg = null;
            int contactId = 0;
            try
            {
                co.crtUserId = MySession.userId;
                contactId = _conSer.saveContact(co);
                msg =contactId > 0 ? "s" : "f";
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { contactId=contactId, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult getContact(int clientId)
        {
            string msg = null;
            List<Contact> listContact = new List<Contact>();
            try
            {

                listContact = _conSer.getContact(clientId);
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listContact = listContact, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult deleteContact(string contactIds)
        {
            string msg = null;
            int status = 0;
            string errorCode = null;
            try
            {
                try
                {
                    foreach (var contactId in contactIds.Split(','))
                    {
                        status += _conSer.deleteContact(Convert.ToInt32(contactId));
                    }
                    
                }
                catch (SqlException ex)
                {
                    errorCode = ex.Number.ToString();
                }


                msg = status > 0 ? "s" : "f";
                msg = errorCode == "547" ? "ec" : msg;
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { msg = msg }, JsonRequestBehavior.AllowGet);

        }
    }
}