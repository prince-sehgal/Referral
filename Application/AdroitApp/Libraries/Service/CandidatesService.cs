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
    public class CandidatesService
    {
        SqlParameter[] _param;
        DataTable _dt;
        Sql _sf;
        public CandidatesService()
        {
            _sf = new Sql();
        }
        public List<QualificationMaster> getQualification()
        {
            _dt = _sf.returnDTWithProc_executeReader("p_tblQualificationMaster_get");
            List<QualificationMaster> listQualification = new List<QualificationMaster>();
            listQualification.Insert(0, new QualificationMaster { qualId = 0, qualification = "Select" });
            if (_dt.Rows.Count > 0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    QualificationMaster q = new QualificationMaster();
                    q.qualId = Convert.ToInt32(row["qualId"]);
                    q.qualification = row["qualification"].ToString();
                    listQualification.Add(q);
                }

            }
            return listQualification;

        }
        public List<CandidateStatusCat_SubCat> getCandidateStatusCat_SubCat()
        {
            _dt = _sf.returnDTWithProc_executeReader("p_tblCandidateStatusSubCat_getCat_SubCat");
            List<CandidateStatusCat_SubCat> listCSCat_SubCat = new List<CandidateStatusCat_SubCat>();
            if (_dt.Rows.Count > 0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    CandidateStatusCat_SubCat c = new CandidateStatusCat_SubCat();
                    c.csSubCatId = Convert.ToInt32(row["csSubCatId"]);
                    c.csCat = row["csCat"].ToString().Trim();
                    c.csSubCat = row["csSubCat"].ToString();
                    listCSCat_SubCat.Add(c);
                }

            }
            return listCSCat_SubCat;

        }
        public List<Source> getSource()
        {
            _dt = _sf.returnDTWithProc_executeReader("p_tblSource_get");
            List<Source> listSource = new List<Source>();
            listSource.Insert(0, new Source { sourceId = 0, source = "Select" });
            if (_dt.Rows.Count > 0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    Source s = new Source();
                    s.sourceId = Convert.ToInt32(row["sourceId"]);
                    s.source = row["source"].ToString();
                    listSource.Add(s);
                }

            }
            return listSource;

        }
        public List<Recruiter> getRecruiter()
        {
            _dt = _sf.returnDTWithProc_executeReader("p_tblManageUser_getRecruiter");
            List<Recruiter> listRecruiter = new List<Recruiter>();
            listRecruiter.Insert(0, new Recruiter { recruiterId = 0, recruiterName = "Select" });
            if (_dt.Rows.Count > 0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    Recruiter r = new Recruiter();
                    r.recruiterId = Convert.ToInt32(row["userId"]);
                    r.recruiterName = Convert.ToString(row["firstName"]);
                    listRecruiter.Add(r);
                }
            }
            return listRecruiter;
        }
        public DataTable check_Candidate_Exists_EmailId_MobileNo(Candidates c)
        {

            _param = new SqlParameter[] { new SqlParameter("@cId", c.cId), new SqlParameter("@email", c.email), new SqlParameter("@mobile", c.mobile) };
            return _sf.returnDTWithProc_executeReader("p_tblCandidate_checkExistsEmailId_MobileNo", _param);


        }
        public int saveCandidates(Candidates c)
        {
            _param = new SqlParameter[] {
                new SqlParameter("@cId",c.cId),
                new SqlParameter("@email", c.email), new SqlParameter("@firstName", c.firstName), new SqlParameter("@middleName", c.middleName), new SqlParameter("@lastName", c.lastName), new SqlParameter("@phone", c.phone), new SqlParameter("@mobile", c.mobile), new SqlParameter("@secondaryEmail", c.secondaryEmail), new SqlParameter("@street", c.street), new SqlParameter("@postalCode", c.postalCode), new SqlParameter("@city", c.city), new SqlParameter("@state", c.state), new SqlParameter("@country", c.country), new SqlParameter("@experienceInYear", c.experienceInYear), new SqlParameter("@quaId", c.quaId), new SqlParameter("@currentJobTitle", c.currentJobTitle), new SqlParameter("@currentEmployer", c.currentEmployer), new SqlParameter("@expectedSalary", c.expectedSalary), new SqlParameter("@currentSalary", c.currentSalary), new SqlParameter("@skillSet", c.skillSet), new SqlParameter("@csSubCatId", c.csSubCatId), new SqlParameter("@sourceId", c.sourceId),
                new SqlParameter("@crtUserId",c.crtUserId),new SqlParameter("@comments",c.comments)
            };
            return Convert.ToInt32(_sf.executeScalerWithProc("p_tblCandidate_save", _param));
        }
        public int saveEducationDetails(EducationDetails ed)
        {
            _param = new SqlParameter[] { new SqlParameter("@eduId", ed.eduId), new SqlParameter("@cId", ed.cId), new SqlParameter("@institute", ed.institute), new SqlParameter("@departmant", ed.departmant), new SqlParameter("@degree", ed.degree), new SqlParameter("@currentlyPursuing", ed.currentlyPursuing), new SqlParameter("@fromMonth", ed.fromMonth), new SqlParameter("@fromYear", ed.fromYear), new SqlParameter("@toMonth", ed.toMonth), new SqlParameter("@toYear", ed.toYear) };
            return _sf.executeNonQueryWithProc("p_tblEducationDetails_save", _param);
        }

        

        public int saveExperienceDetails(ExperienceDetails ex)
        {
            _param = new SqlParameter[] { new SqlParameter("@expId", ex.expId), new SqlParameter("@cId", ex.cId), new SqlParameter("@occupation", ex.occupation), new SqlParameter("@company", ex.company), new SqlParameter("@summery", ex.summery), new SqlParameter("@currentlyWork", ex.currentlyWork), new SqlParameter("@fromMonth", ex.fromMonth), new SqlParameter("@fromYear", ex.fromYear), new SqlParameter("@toMonth", ex.toMonth), new SqlParameter("@toYear", ex.toYear) };
            return _sf.executeNonQueryWithProc("p_tblExperienceDetails_save", _param);
        }
        public List<Candidates> getCandidates()
        {
            _dt = _sf.returnDTWithProc_executeReader("p_tblCandidate_get");
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
        public int deleteCandidates(int cId)
        {
            _param = new SqlParameter[] { new SqlParameter("@cId", cId) };
            return _sf.executeNonQueryWithProc("p_Candidate_delete", _param);
        }
        public int deleteExperienceDetails(int expId)
        {
            _param = new SqlParameter[] { new SqlParameter("@expId", expId) };
            return _sf.executeNonQueryWithProc("p_tblExperienceDetails_delete", _param);
        }
        public int deleteEducationDetails(int eduId)
        {
            _param = new SqlParameter[] { new SqlParameter("@eduId", eduId) };
            return _sf.executeNonQueryWithProc("p_tblEducationDetails_delete", _param);
        }
        public List<EducationDetails> getEducationDetails_byCId(int cId)
        {
            _param = new SqlParameter[] {new SqlParameter("@cId",cId) };
            _dt = _sf.returnDTWithProc_executeReader("p_tblEducationDetails_get_byCId",_param);
            List<EducationDetails> listEduDetail = new List<EducationDetails>();
            if (_dt.Rows.Count > 0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    EducationDetails ed = new EducationDetails();
                    ed.eduId = Convert.ToInt32(row["eduId"]);
                    ed.institute = Convert.ToString(row["institute"]);
                    ed.departmant = Convert.ToString(row["departmant"]);
                    ed.degree = Convert.ToString(row["degree"]);
                    ed.currentlyPursuing = Convert.ToBoolean(row["currentlyPursuing"]);
                    ed.fromMonth = Convert.ToString(row["fromMonth"]);
                    ed.fromYear = Convert.ToInt32(row["fromYear"]);
                    ed.toMonth = Convert.ToString(row["toMonth"]);
                    ed.toYear = Convert.ToInt32(row["toYear"]);
                    listEduDetail.Add(ed);
                }
            }
            return listEduDetail;
        }
        public List<ExperienceDetails> getExperienceDetails_byCId(int cId)
        {
            _param = new SqlParameter[] {new SqlParameter("@cId",cId) };
            _dt = _sf.returnDTWithProc_executeReader("p_tblExperienceDetails_get_byCId",_param);
            List<ExperienceDetails> listExpDetail = new List<ExperienceDetails>();
            if (_dt.Rows.Count > 0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    ExperienceDetails ex = new ExperienceDetails();
                    ex.expId = Convert.ToInt32(row["expId"]);
                    ex.occupation = Convert.ToString(row["occupation"]);
                    ex.company = Convert.ToString(row["company"]);
                    ex.summery = Convert.ToString(row["summery"]);
                    ex.currentlyWork = Convert.ToBoolean(row["currentlyWork"]);
                    ex.fromMonth = Convert.ToString(row["fromMonth"]);
                    ex.fromYear = Convert.ToInt32(row["fromYear"]);
                    ex.toMonth = Convert.ToString(row["toMonth"]);
                    ex.toYear = Convert.ToInt32(row["toYear"]);
                    listExpDetail.Add(ex);
                }
            }
            return listExpDetail;
        }
        public Candidates getCandidates_byCandidateId(int candidateId)
        {
            _param = new SqlParameter[] {new SqlParameter("@cId",candidateId) };
            _dt = _sf.returnDTWithProc_executeReader("p_tblCandidate_get_byCandidateId",_param);
            Candidates c = new Candidates();
            if (_dt.Rows.Count > 0)
            {
                    c.cId = Convert.ToInt32(_dt.Rows[0]["cId"]);
                    c.email = Convert.ToString(_dt.Rows[0]["email"]);
                    c.firstName = Convert.ToString(_dt.Rows[0]["firstName"]);
                    c.middleName = Convert.ToString(_dt.Rows[0]["middleName"]);
                    c.lastName = Convert.ToString(_dt.Rows[0]["lastName"]);
                    c.phone = Convert.ToString(_dt.Rows[0]["phone"]);
                    c.mobile = Convert.ToString(_dt.Rows[0]["mobile"]);
                    c.secondaryEmail = Convert.ToString(_dt.Rows[0]["secondaryEmail"]);
                    c.street = Convert.ToString(_dt.Rows[0]["street"]);
                    c.postalCode = Convert.ToString(_dt.Rows[0]["postalCode"]);
                    c.city = Convert.ToString(_dt.Rows[0]["city"]);
                    c.state = Convert.ToString(_dt.Rows[0]["state"]);
                    c.country = Convert.ToString(_dt.Rows[0]["country"]);
                    c.experienceInYear = Convert.ToString(_dt.Rows[0]["experienceInYear"]);
                    c.quaId = Convert.ToInt32(_dt.Rows[0]["quaId"]);
                    c.currentJobTitle = Convert.ToString(_dt.Rows[0]["currentJobTitle"]);
                    c.currentEmployer = Convert.ToString(_dt.Rows[0]["currentEmployer"]);
                    c.expectedSalary = Convert.ToDecimal(_dt.Rows[0]["expectedSalary"]);
                    c.currentSalary = Convert.ToDecimal(_dt.Rows[0]["currentSalary"]);
                    c.skillSet = Convert.ToString(_dt.Rows[0]["skillSet"]);
                    c.csSubCatId = Convert.ToInt32(_dt.Rows[0]["csSubCatId"]);
                    c.sourceId = Convert.ToInt32(_dt.Rows[0]["sourceId"]);
                    //c.recruiterId = Convert.ToInt32(_dt.Rows[0]["recruiterId"]);
                    c.resume = Convert.ToString(_dt.Rows[0]["resume"]);
                    c.others = Convert.ToString(_dt.Rows[0]["others"]);
                    //c.recruiterName = Convert.ToString(_dt.Rows[0]["recruiterName"]);
                    c.csSubCat = Convert.ToString(_dt.Rows[0]["csSubCat"]);
                    c.source = Convert.ToString(_dt.Rows[0]["source"]);
                    c.positionTile = Convert.ToString(_dt.Rows[0]["positionTile"]);
                c.comments = Convert.ToString(_dt.Rows[0]["comments"]);
            }
            return c;
        }
        public int updateCandidateStatus(Candidates c)
        {
            _param = new SqlParameter[] {new SqlParameter("@cId",c.cId),new SqlParameter("@csSubCatId",c.csSubCatId),new SqlParameter("@comments",c.comments),new SqlParameter("@crtUserId",c.crtUserId)
            };
            return _sf.executeNonQueryWithProc("updateCandidateStatus",_param);
        }

    }
}
