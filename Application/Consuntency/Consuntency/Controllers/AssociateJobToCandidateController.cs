using Consuntency.Security;
using Consuntency_BLL.Modal;
using Consuntency_BLL.Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Consuntency.Controllers
{
    [CustomAuthorize]
    public class AssociateJobToCandidateController : Controller
    {
        // GET: AssociateJobToCand
        AssociateJob_To_CandidateService _ajcServ = new AssociateJob_To_CandidateService();
        public ActionResult associateJobOpening(string candidateIds,string ass)
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
        public ActionResult associateCandidate(string joiIds,string ass,string positionTitle)
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

        public JsonResult saveAssociateJob_To_Candidate(List<int> listCandidateIds, List<int> listJoiIds, string comments, int csSubCatId)
        {
            string msg = null;
            int status = 0;
            try
            {
                foreach (var cId in listCandidateIds)
                {
                    AssociateJob_To_Candidate ajc = new AssociateJob_To_Candidate();
                    ajc.candidateId =Convert.ToInt32(cId);
                    ajc.crtUserId = MySession.userId;
                    ajc.comments = comments;
                    ajc.csSubCatId = csSubCatId;
                    foreach (var joiId in listJoiIds)
                    {
                        ajc.joiId =Convert.ToInt32(joiId);
                        status += _ajcServ.saveAssociateJob_To_Candidate(ajc);
                    }
                    //ajc.joiId
                    
                }
                msg = status > 0 ? "s" : "f";
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { msg = msg }, JsonRequestBehavior.AllowGet);

        }
        public JsonResult getAssociateJob_To_Candidate_byCandidateId(int candidateId)
        {
            string msg = null;
            List<AssociateJob_To_Candidate> listAJC = new List<AssociateJob_To_Candidate>();
            try
            {
                listAJC = _ajcServ.getAssociateJob_To_Candidate_byCandidateId(candidateId);
            }
            catch (Exception ex)
            {

                msg = "Error:" + ex.Message;
            }
            return Json(new { listAJC = listAJC,msg=msg },JsonRequestBehavior.AllowGet);
        }
        public JsonResult getCandidates_Not_AlreadyTag_OnSamePosition(string joiId)
        {
            string msg = null;
            List<Candidates> listCandidates = new List<Candidates>();
            try
            {
                listCandidates = _ajcServ.getCandidates_Not_AlreadyTag_OnSamePosition(joiId);
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listCandidates = listCandidates, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult getJobOpeningInfo_Not_AlreadyTag_OnSameCandidate(int clientId, string candidateIds)
        {
            string msg = null;
            List<JobOpeningInfo> listJobOpeningInfo = new List<JobOpeningInfo>();
            try
            {
                listJobOpeningInfo = _ajcServ.getJobOpeningInfo_Not_AlreadyTag_OnSameCandidate(clientId,candidateIds);
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { listJobOpeningInfo = listJobOpeningInfo, msg = msg }, JsonRequestBehavior.AllowGet);
        }
    }
}