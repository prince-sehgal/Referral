using Libraries.Connectors;
using Libraries.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Libraries.Service
{
   public class AssociateJob_To_CandidateService
    {
        Sql _sf;
        SqlParameter[] _param;
        DataTable _dt;
        public AssociateJob_To_CandidateService()
        {
            _sf = new Sql();
        }
        public int saveAssociateJob_To_Candidate(AssociateJob_To_Candidate ajc)
        {
            _param = new SqlParameter[] {new SqlParameter("@associateJCId", ajc.associateJCId), new SqlParameter("@joiId", ajc.joiId), new SqlParameter("@candidateId", ajc.candidateId), new SqlParameter("@comments", ajc.comments), new SqlParameter("@crtUserId", ajc.crtUserId),new SqlParameter("@csSubCatId",ajc.csSubCatId) };
            return _sf.executeNonQueryWithProc("p_tblAssociateJob_To_Candidate_save", _param);
        }
        public List<AssociateJob_To_Candidate> getAssociateJob_To_Candidate_byCandidateId(int candidateId)
        {
            _param = new SqlParameter[] {new SqlParameter("@candidateId",candidateId) };
            _dt = _sf.returnDTWithProc_executeReader("p_tblAssociateJob_To_Candidate_get_byCandidateId", _param);
            List<AssociateJob_To_Candidate> listAJC = new List<AssociateJob_To_Candidate>();
            if(_dt.Rows.Count>0)
            {
                foreach (DataRow  row in _dt.Rows)
                {
                    AssociateJob_To_Candidate ajc = new AssociateJob_To_Candidate();
                    ajc.clientName =Convert.ToString(row["clientName"]);
                    ajc.recruitmetLeadName =Convert.ToString(row["recruitmetLeadName"]);
                    ajc.recruiterName =Convert.ToString(row["recruiterName"]);
                    ajc.csSubCat =Convert.ToString(row["csSubCat"]);
                    ajc.currentJobTitle = Convert.ToString(row["currentJobTitle"]);
                    ajc.positionTile = Convert.ToString(row["positionTile"]);
                    listAJC.Add(ajc);
                }
            }
            return listAJC;
        }
        public List<Candidates> getCandidates_Not_AlreadyTag_OnSamePosition(string joiId)
        {
            _param = new SqlParameter[] { new SqlParameter("@joiId",joiId)};
            _dt = _sf.returnDTWithProc_executeReader("p_tblCandidate_get_Not_AlreadyTag_OnSamePosition",_param);
            List<Candidates> listCandidates = new List<Candidates>();
            if (_dt.Rows.Count > 0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    Candidates c = new Candidates();
                    c.cId = Convert.ToInt32(row["cId"]);
                    c.email = Convert.ToString(row["email"]);
                    c.firstName = Convert.ToString(row["firstName"]);
                    c.middleName = Convert.ToString(row["middleName"]);
                    c.lastName = Convert.ToString(row["lastName"]);
                    c.phone = Convert.ToString(row["phone"]);
                    c.mobile = Convert.ToString(row["mobile"]);
                    c.secondaryEmail = Convert.ToString(row["secondaryEmail"]);
                    c.street = Convert.ToString(row["street"]);
                    c.postalCode = Convert.ToString(row["postalCode"]);
                    c.city = Convert.ToString(row["city"]);
                    c.state = Convert.ToString(row["state"]);
                    c.country = Convert.ToString(row["country"]);
                    c.experienceInYear = Convert.ToString(row["experienceInYear"]);
                    c.quaId = Convert.ToInt32(row["quaId"]);
                    c.currentJobTitle = Convert.ToString(row["currentJobTitle"]);
                    c.currentEmployer = Convert.ToString(row["currentEmployer"]);
                    c.expectedSalary = Convert.ToDecimal(row["expectedSalary"]);
                    c.currentSalary = Convert.ToDecimal(row["currentSalary"]);
                    c.skillSet = Convert.ToString(row["skillSet"]);
                    c.csSubCatId = Convert.ToInt32(row["csSubCatId"]);
                    c.sourceId = Convert.ToInt32(row["sourceId"]);
                    //c.recruiterId = Convert.ToInt32(row["recruiterId"]);
                    c.resume = Convert.ToString(row["resume"]);
                    c.others = Convert.ToString(row["others"]);
                    //c.recruiterName = Convert.ToString(row["recruiterName"]);
                    c.csSubCat = Convert.ToString(row["csSubCat"]);
                    c.source = Convert.ToString(row["source"]);
                    c.positionTile = Convert.ToString(row["positionTile"]);
                    c.comments = Convert.ToString(row["comments"]);
                    c.noOfAppliedJobs = Convert.ToInt32(row["noOfAppliedJobs"]);
                    listCandidates.Add(c);

                }
            }
            return listCandidates;
        }
        public List<JobOpeningInfo> getJobOpeningInfo_Not_AlreadyTag_OnSameCandidate(int clientId,string candidateIds)
        {
            _param = new SqlParameter[] { new SqlParameter("@clientId", clientId) ,new SqlParameter("@candidateIds",candidateIds) };
            _dt = _sf.returnDTWithProc_executeReader("p_tblJobOpeningInformation_get_Not_AlreadyTag_OnSameCandidate", _param);
            List<JobOpeningInfo> listJobOpeningInfo = new List<JobOpeningInfo>();
            if (_dt.Rows.Count > 0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    JobOpeningInfo j = new JobOpeningInfo();
                    j.joiId = Convert.ToInt32(row["joiId"]);
                    j.positionTile = Convert.ToString(row["positionTile"]);
                    j.contactId = Convert.ToInt32(row["contactId"]);
                    j.contactName = Convert.ToString(row["contactName"]);
                    j.recruitmetLeadId = Convert.ToInt32(row["recruitmetLeadId"]);
                    j.recruitmetLeadName = Convert.ToString(row["recruitmetLeadName"]);
                    j.recruiterId = Convert.ToInt32(row["recruiterId"]);
                    j.recruiterName = Convert.ToString(row["recruiterName"]);
                    j.targetDT = Convert.ToDateTime(row["targetDT"]);
                    j.jobOpeningStatus = Convert.ToString(row["jobOpeningStatus"]);
                    j.clientId = Convert.ToInt32(row["clientId"]);
                    j.clientName = Convert.ToString(row["clientName"]);
                    j.c_amId = Convert.ToInt32(row["c_amId"]);
                    //j.openedDT = Convert.ToDateTime(row["openedDT"]);
                    j.jobType = Convert.ToString(row["jobType"]);
                    j.city = Convert.ToString(row["city"]);
                    j.state = Convert.ToString(row["state"]);
                    j.minWorkExperience = Convert.ToString(row["minWorkExperience"]);
                    j.maxWorkExperience = Convert.ToString(row["maxWorkExperience"]);
                    j.noOfPositions = Convert.ToString(row["noOfPositions"]);
                    j.minCTC = Convert.ToDecimal(row["minCTC"]);
                    j.maxCTC = Convert.ToDecimal(row["maxCTC"]);
                    j.jobDesc = Convert.ToString(row["jobDesc"]);
                    j.jobSummery = Convert.ToString(row["jobSummery"]);
                    j.noOfCV = Convert.ToInt32(row["noOfCV"]);
                    j.accountManager = Convert.ToString(row["accountManager"]);
                    listJobOpeningInfo.Add(j);
                }
            }
            return listJobOpeningInfo;
        }

    }
}

