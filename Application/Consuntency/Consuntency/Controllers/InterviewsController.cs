using Consuntency.Security;
using Consuntency_BLL.Modal;
using Consuntency_BLL.Service;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Consuntency.Controllers
{
    [CustomAuthorize]
    public class InterviewsController : Controller
    {
        // GET: Interviews
        ClientService _clientSer = new ClientService();
        InterviewsService _interviewSer = new InterviewsService();
        CommonService _cs = new CommonService();
        public ActionResult interviews(string candidateId)
        {
            return View();
            //if (MySession.userName!=null)
            //{
            //    return View();
            //}
            //else
            //{
            //    return RedirectToAction("index","Login");
            //}

            
        }
        public JsonResult getClient_AccountManager_byClientId(int clientId)
        {
            string msg = null;
            List<Client_AccountManager> listAM = new List<Client_AccountManager>();
            try
            {
                //c.crtUserId = MySession.userId;
                listAM = _clientSer.getClient_AccountManager(clientId);
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new {  listAM = listAM, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult getInterviewName()
        {
            string msg = null;
            List<InterviewNameMaster> listIM = new List<InterviewNameMaster>();
            try
            {

                listIM = _interviewSer.getInterviewName();
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listIM = listIM, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult saveInterviews(Interviews i)
        {
            string msg = null;
            int interviewId = 0;
            try
            {
                i.crtUserId = MySession.userId;
                interviewId = _interviewSer.saveInterviews(i);
                msg = interviewId > 0 ? "s" : "f";
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { interviewId=interviewId, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult saveInterviewsPhoto_Doc(string others, int interviewId)
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

                            if (others == "yes")
                            {
                                string jobSummery;
                                jobSummery = Convert.ToString(_cs.executeScalarWithQuery("select others_Photo_Doc from tblInterviews where interviewId=" + interviewId + ""));
                                string tempPath = Server.MapPath("~/Files/" + jobSummery);
                                if (System.IO.File.Exists(tempPath))
                                {
                                    System.IO.File.Delete(tempPath);
                                }
                                status = _cs.executeNonQueryWithQuery("update tblInterviews set others_Photo_Doc='" + fname + "' where interviewId=" + interviewId + "");
                                fname = Path.Combine(Server.MapPath("~/Files/Interviews"), fname);
                                file.SaveAs(fname);

                                fname = "";
                                others = "no";
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
            return Json(new { msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult getInterviews()
        {
            string msg = null;
            List<Interviews> listInterviews = new List<Interviews>();
            try
            {
                listInterviews = _interviewSer.getInterviews(0);
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listInterviews=listInterviews, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult deleteInterviews(string interviewIds)
        {
            string msg = null;
            int status = 0;
            try
            {
                status = _interviewSer.deleteInterviews(interviewIds);
                msg = status > 0 ? "s" : "f";
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { status = status, msg = msg }, JsonRequestBehavior.AllowGet);
        }
    }
}