using Consuntency.Security;
using Consuntency_BLL.Modal;
using Consuntency_BLL.Service;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Consuntency.Controllers
{
    [CustomAuthorize]
    public class CandidatesController : Controller
    {
        CandidatesService _cds = new CandidatesService();
        CommonService _cs = new CommonService();
        InterviewsService _interviewSer = new InterviewsService();
        // GET: Candidates
        #region Candidates
        public ActionResult candidates()
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
        public JsonResult getQualification()
        {
            string msg = null;
            List<QualificationMaster> listQualification = new List<QualificationMaster>();
            try
            {
                listQualification = _cds.getQualification();
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listQualification = listQualification, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult getCandidateStatusCat_SubCat()
        {
            string msg = null;
            List<CandidateStatusCat_SubCat> listCSCat_SubCat = new List<CandidateStatusCat_SubCat>();
            try
            {
                listCSCat_SubCat = _cds.getCandidateStatusCat_SubCat();
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listCSCat_SubCat=listCSCat_SubCat, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult getSource()
        {
            string msg = null;
            List<Source> listSource = new List<Source>();
            try
            {
                listSource = _cds.getSource();
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listSource=listSource, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult getRecruiter()
        {
            string msg = null;
            List<Recruiter> listRecruiter = new List<Recruiter>();
            try
            {
                listRecruiter = _cds.getRecruiter();
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listRecruiter = listRecruiter, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult check_Candidate_Exists_EmailId_MobileNo(Candidates c)
        {
            string msg = null;
            int emailStatus = 0, mobileStatus = 0;
            DataTable dt = new DataTable();
            try
            {
                dt = _cds.check_Candidate_Exists_EmailId_MobileNo(c);
                if (dt.Rows.Count > 0)
                {
                    emailStatus = Convert.ToInt32(dt.Rows[0]["emailStatus"]);
                    mobileStatus = Convert.ToInt32(dt.Rows[0]["mobileStatus"]);
                }
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { emailStatus = emailStatus, mobileStatus = mobileStatus, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult saveCandidates(Candidates c,List<EducationDetails> listEduDetail,List<ExperienceDetails> listExpDetail)
        {
            string msg = null;
            int cId = 0;
            try
            {
                c.crtUserId = MySession.userId;
                cId = _cds.saveCandidates(c);
                if(cId!=0)
                {
                    if (listEduDetail != null)
                    {
                        foreach (EducationDetails ed in listEduDetail)
                        {
                            ed.cId = cId;
                            if(ed.currentlyPursuing==true)
                            {
                                ed.toMonth = string.Empty;
                                ed.toYear = 0;
                            }
                            _cds.saveEducationDetails(ed);
                        }
                    }
                    if (listExpDetail != null)
                    {
                        foreach (ExperienceDetails ex in listExpDetail)
                        {
                            if(ex.currentlyWork==true)
                            {
                                ex.toMonth = string.Empty;
                                ex.toYear = 0;
                            }
                            ex.cId = cId;
                            _cds.saveExperienceDetails(ex);
                        }
                    }
                }
                msg = cId > 0 ? "s" : "f";
            }

          catch(Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { msg=msg,cId=cId},JsonRequestBehavior.AllowGet);
        }
        public JsonResult saveCandidatesPhoto_Doc(string rs,string ot, int cId)
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

                            if (rs == "yes")
                            {
                                string resume;
                               resume = Convert.ToString(_cs.executeScalarWithQuery("select resume from tblCandidate where cId=" + cId + ""));
                                string tempPath = Server.MapPath("~/Files/" + resume);
                                if (System.IO.File.Exists(tempPath))
                                {
                                    System.IO.File.Delete(tempPath);
                                }
                                status = _cs.executeNonQueryWithQuery("update tblCandidate set resume='" + fname + "' where cId=" + cId+ "");
                                fname = Path.Combine(Server.MapPath("~/Files/"), fname);
                                file.SaveAs(fname);

                                fname = "";
                                rs = "no";
                            }

                           else if (ot == "yes")
                            {
                                string others;
                                others = Convert.ToString(_cs.executeScalarWithQuery("select others from tblCandidate where cId=" + cId + ""));
                                string tempPath = Server.MapPath("~/Files/" + others);
                                if (System.IO.File.Exists(tempPath))
                                {
                                    System.IO.File.Delete(tempPath);
                                }
                                status = _cs.executeNonQueryWithQuery("update tblCandidate set others='" + fname + "' where cId=" + cId + "");
                                fname = Path.Combine(Server.MapPath("~/Files/"), fname);
                                file.SaveAs(fname);

                                fname = "";
                                ot = "no";
                            }

                        }

                    //}

                }
                catch (Exception ex)
                {
                    //return Json("Error occurred. Error details: " + ex.Message);
                }
            }
            msg = status > 0 ? "s" : "f";
            return Json(new { msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult getInterviews_byCandidateId(int candidateId)
        {
            string msg = null;
            List<Interviews> listInterviews = new List<Interviews>();
            try
            {
                listInterviews = _interviewSer.getInterviews(candidateId);
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listInterviews = listInterviews, msg = msg }, JsonRequestBehavior.AllowGet);
        }

        public JsonResult getCandidates()
        {
            string msg = null;
            List<Candidates> listCandidates = new List<Candidates>();
            try
            {
                listCandidates = _cds.getCandidates();
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listCandidates = listCandidates, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult deleteCandidates(string cIds)
        {
            string msg = null;
            int status = 0;
            string errorCode = null;
            try
            {
                try
                {
                    foreach (var cId in cIds.Split(','))
                    {
                        status += _cds.deleteCandidates(Convert.ToInt32(cId));
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
        public JsonResult deleteEducationDetails(int eduId)
        {
            string msg = null;
            int status = 0;
            try
            {
                status = _cds.deleteEducationDetails(eduId);
                msg = status > 0 ? "s" : "f";
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { msg = msg }, JsonRequestBehavior.AllowGet);

        }
        public JsonResult deleteExperienceDetails(int expId)
        {
            string msg = null;
            int status = 0;
            try
            {
                status = _cds.deleteExperienceDetails(expId);
                msg = status > 0 ? "s" : "f";
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { msg = msg }, JsonRequestBehavior.AllowGet);

        }
        public JsonResult getEducationDetails_And_ExperienceDetails_byCId(int cId)
        {
            string msg = null;
            List<EducationDetails> listEduDetail = new List<EducationDetails>();
            List<ExperienceDetails> listExpDetail = new List<ExperienceDetails>();
            try
            {
                listEduDetail = _cds.getEducationDetails_byCId(cId);
                listExpDetail = _cds.getExperienceDetails_byCId(cId);
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listEduDetail = listEduDetail, listExpDetail =listExpDetail, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        #endregion
        #region Associate Job Opening
        public ActionResult associateJobOpening(string candidateIds)
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
        //public JsonResult updateCandidateStatus(string candidateIds, int joiId,string comments,int csSubCatId)
        //{
        //    string msg = null;
        //    int status = 0;
        //    try
        //    {
        //        foreach (var cId in candidateIds.Split(','))
        //        {
        //            status += _cs.executeNonQueryWithQuery("update tblCandidate set joiId=" + joiId + ",comments='" + comments + "',csSubCatId=" + csSubCatId + " where cId="+cId);
        //        }
        //        msg = status > 0 ? "s" : "f";
        //    }
        //    catch(Exception ex)
        //    {
        //        msg = "Error:" + ex.Message;
        //    }
        //    return Json(new { msg = msg },JsonRequestBehavior.AllowGet);

        //}
        #endregion
        #region Show CandidateInfo
        public ActionResult showCandidateInfo(string candidateId)
        {
            if (string.IsNullOrEmpty(candidateId))
            {
                return RedirectToAction("candidates", "Candidates");
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
        public JsonResult getCandidates_byCandidateId(int candidateId)
        {
            string msg = null;
            Candidates c = new Candidates();
            try
            {
                c = _cds.getCandidates_byCandidateId(candidateId);
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { c=c, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        #endregion
        #region update candidate status
        public JsonResult updateCandidateStatus(Candidates c)
        {
            string msg = null;
            int status = 0;
            try
            {
                status = _cds.updateCandidateStatus(c);
                msg = status > 0 ? "s" : "f";
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
                
            }
            return Json(new { msg = msg },JsonRequestBehavior.AllowGet);
        }
        #endregion
    }
}