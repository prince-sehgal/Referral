using Consuntency.Security;
using Consuntency_BLL.Modal;
using Consuntency_BLL.Service;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Consuntency.Controllers
{
    [CustomAuthorize]
    public class UserController : Controller
    {
        // GET: User
        ManageUserService _mu = new ManageUserService();
        public ActionResult manageUser()
        {
            return View();
            //if(MySession.userName!=null)
            //{
            //    return View();
            //}
            //else
            //{
            //    return RedirectToAction("index", "Login");
            //}

        }

        public JsonResult saveUser(ManageUser u)
        {
            string msg = null;
            int status = 0;
            try
            {
                status = _mu.saveUser(u);
                msg = status > 0 ? "s" : "f";
            }
            catch(Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { msg=msg},JsonRequestBehavior.AllowGet);

        }
        public JsonResult getUser()
        {
            string msg = null;
            List<ManageUser> listUser = new List<ManageUser>();
            try
            {
                listUser= _mu.getUser();
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new {listUser=listUser, msg = msg }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult deleteUser(string userIds)
        {
            string msg = null;
            int status = 0;
            string errorCode = null;
            try
            {
                foreach (var userId in userIds.Split(','))
                {
                    try
                    {
                        _mu.deleteUser(Convert.ToInt32(userId));
                    }
                    catch(SqlException ex)
                    {
                        errorCode = ex.Number.ToString();
                    }
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
        public JsonResult checkExistsEmailId_MobileNo(ManageUser u)
        {
            string msg = null;
            int emailIdStatus = 0, mobileNoStatus = 0, firstNameStatus=0;
            DataTable dt = new DataTable();
            try
            {
               dt= _mu.checkExistsEmailId_MobileNo(u);
                if (dt.Rows.Count > 0)
                {
                    emailIdStatus = Convert.ToInt32(dt.Rows[0]["emailIdStatus"]);
                    mobileNoStatus = Convert.ToInt32(dt.Rows[0]["mobileNoStatus"]);
                    firstNameStatus = Convert.ToInt32(dt.Rows[0]["firstNameStatus"]);
                }
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { emailIdStatus=emailIdStatus,mobileNoStatus=mobileNoStatus,firstNameStatus, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult getRecruitmetLead()
        {
            string msg = null;
            List<RecruitmetLead> listRecruitmetLead = new List<RecruitmetLead>();
            try
            {
                listRecruitmetLead = _mu.getRecruitmetLead();
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listRecruitmetLead=listRecruitmetLead, msg = msg }, JsonRequestBehavior.AllowGet);
        }

    }

}