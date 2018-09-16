using Consuntency.Security;
using Consuntency_BLL.Modal;
using Consuntency_BLL.Service;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Consuntency.Controllers
{
    [CustomAuthorize]
    public class JobOpeningInfoController : Controller
    {
        JobOpeningInfoService _joi = new JobOpeningInfoService();
        CommonService _cs = new CommonService();
        // GET: JobOpeningInfo
        #region Job Opening
        public ActionResult jobOpeningInfo()
        {
            return View();
            //if (MySession.userName!=null)
            //{
            //    return View();
            //}
            //else
            //{
            //    return RedirectToAction("index", "Login");
            //}
        }
        public JsonResult saveJobOpeningInfo(JobOpeningInfo j)
        {
            string msg = null;
            int joiId = 0;
            try
            {
                j.crtUserId = MySession.userId;           
                joiId = _joi.saveJobOpeningInfo(j);
                msg = joiId > 0 ? "s" : "f";
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new {joiId=joiId, msg = msg }, JsonRequestBehavior.AllowGet);

        }
        public JsonResult deleteJobOpeningInfo(string joiIds)
        {
            string msg = null;
            int status = 0;
            string errorCode = null;
            try
            {
                try
                {
                    foreach (var joiId in joiIds.Split(','))
                    {
                        status += _joi.deleteJobOpeningInfo(Convert.ToInt32(joiId));
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

        public JsonResult saveJobSummeryPhoto_Doc(string js, int joiId)
        {
            int status = 0;
            string msg;
            if (Request.Files.Count > 0)
            {
                try
                {
                    HttpFileCollectionBase files = Request.Files;
                    for (int i = 0; i < files.Count; i++)
                    {
                        HttpPostedFileBase file = files[i];
                        string fname;
                        //if (Request.Browser.Browser.ToUpper() == "IE" || Request.Browser.Browser.ToUpper() == "INTERNETEXPLORER")
                        //{
                        //    string[] testfiles = file.FileName.Split(new char[] { '\\' });
                        //    fname = testfiles[testfiles.Length - 1];
                        //}
                        //else
                        //{
                            string tempFileName = file.FileName;
                            string tempFile = Path.GetExtension(tempFileName);
                            fname = Guid.NewGuid().ToString() + tempFile;

                            if (js == "yes")
                            {
                                string jobSummery;
                               jobSummery=Convert.ToString(_cs.executeScalarWithQuery("select jobSummery from tblJobOpeningInformation where joiId="+joiId+""));
                        string tempPath = Server.MapPath("~/Files/" +jobSummery);
                                if (System.IO.File.Exists(tempPath))
                                {
                                    System.IO.File.Delete(tempPath);
                                }
                               status  =_cs.executeNonQueryWithQuery("update tblJobOpeningInformation set jobSummery='" + fname + "' where joiId=" + joiId + "");
                                fname = Path.Combine(Server.MapPath("~/Files/"), fname);
                                file.SaveAs(fname);

                                fname = "";
                                js = "no";
                            }
                            
                        }

                    }

                //}
                catch (Exception ex)
                {
                    //return Json("Error occurred. Error details: " + ex.Message);
                }
            }
            msg = status > 0 ? "s" : "f";
            return Json( new { msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult getJobOpeningInfo(int clientId)
        {
            string msg = null;
            List<JobOpeningInfo> listJobOpeningInfo = new List<JobOpeningInfo>();
            try
            {
                listJobOpeningInfo = _joi.getJobOpeningInfo(clientId);
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listJobOpeningInfo = listJobOpeningInfo, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult getRecruiter_byRecruitmetLeadId(int recruitmetLeadId)
        {
            string msg = null;
            List<Recruiter> listRecruiter = new List<Recruiter>();
            try
            {
                listRecruiter = _joi.getRecruiter_byRecruitmetLeadId(recruitmetLeadId);
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listRecruiter = listRecruiter, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region Associate Candidate
        public ActionResult showJobOpenInfo(string joiId)
        {
            if(string.IsNullOrEmpty(joiId))
            {
                return RedirectToAction("jobOpeningInfo", "JobOpeningInfo");
            }
            if (MySession.userName != null)
            {
                return View();
            }
            else
            {
                return RedirectToAction("index", "Login");
            }
        }
        public ActionResult associateCandidate(int joiId)
        {
            if (MySession.userName != null)
            {
                return View();
            }
            else
            {
                return RedirectToAction("index", "Login");
            }
        }
        public JsonResult getJobOpeningInfo_byJoiId(int joiId)
        {
            string msg = null;
            JobOpeningInfo j = new JobOpeningInfo();
            try
            {
                j = _joi.getJobOpeningInfo_byJoiId(joiId);
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { j=j, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        #endregion
    }
}
