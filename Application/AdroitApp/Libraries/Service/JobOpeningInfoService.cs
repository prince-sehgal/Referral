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
public  class JobOpeningInfoService
    {
        Sql _sf;
        SqlParameter[] _param;
        DataTable _dt;
        public JobOpeningInfoService()
        {
            _sf = new Sql();
            
        }
        public int saveJobOpeningInfo(JobOpeningInfo j)
        {
            _param = new SqlParameter[] {new SqlParameter("@joiId", j.joiId), new SqlParameter("@positionTile", j.positionTile), new SqlParameter("@contactId", j.contactId), new SqlParameter("@recruitmetLeadId", j.recruitmetLeadId), new SqlParameter("@recruiterId", j.recruiterId), new SqlParameter("@targetDT", j.targetDT), new SqlParameter("@jobOpeningStatus", j.jobOpeningStatus), new SqlParameter("@clientId", j.clientId), new SqlParameter("@c_amId", j.c_amId), new SqlParameter("@openedDT", j.openedDT), new SqlParameter("@jobType", j.jobType), new SqlParameter("@city", j.city), new SqlParameter("@state", j.state), new SqlParameter("@minWorkExperience", j.minWorkExperience), new SqlParameter("@maxWorkExperience", j.maxWorkExperience), new SqlParameter("@noOfPositions", j.noOfPositions), new SqlParameter("@minCTC", j.minCTC), new SqlParameter("@maxCTC", j.maxCTC), new SqlParameter("@jobDesc", j.jobDesc),new SqlParameter("@crtUserId",j.crtUserId) };
            return Convert.ToInt32(_sf.executeScalerWithProc("p_tblJobOpeningInformation_save", _param));
        }
        public int deleteJobOpeningInfo(int joiId)
        {
            _param = new SqlParameter[] { new SqlParameter("@joiId", joiId) };
            return _sf.executeNonQueryWithProc("p_tblJobOpeningInformation_delete", _param);
        }
        public List<JobOpeningInfo> getJobOpeningInfo(int clientId)
        {
            _param = new SqlParameter[] { new SqlParameter("@clientId",clientId)};
            _dt = _sf.returnDTWithProc_executeReader("p_tblJobOpeningInformation_get",_param);
            List<JobOpeningInfo> listJobOpeningInfo = new List<JobOpeningInfo>();
            if(_dt.Rows.Count>0)
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
        public List<Recruiter> getRecruiter_byRecruitmetLeadId(int recruitmetLeadId)
        {
            _param = new SqlParameter[] { new SqlParameter("@recruitmetLeadId",recruitmetLeadId) };
            _dt = _sf.returnDTWithProc_executeReader("p_getRecruiter_byRecruitmetLeadId",_param);
            List<Recruiter> listRecruiter = new List<Recruiter>();
            //listRecruiter.Insert(0, new Recruiter { recruiterId = 0, recruiterName = "Select" });
            if (_dt.Rows.Count > 0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    Recruiter r = new Recruiter();
                    r.recruiterId =Convert.ToInt32(row["userId"]);
                    r.recruiterName =Convert.ToString(row["firstName"]);
                    listRecruiter.Add(r);
                }
            }
            return listRecruiter;
        }



        public JobOpeningInfo getJobOpeningInfo_byJoiId(int joiId)
        {
            _param = new SqlParameter[] { new SqlParameter("@joiId", joiId) };
            _dt = _sf.returnDTWithProc_executeReader("p_tblJobOpeningInformation_get_byJoiId", _param);
            JobOpeningInfo  j = new JobOpeningInfo();
            if (_dt.Rows.Count > 0)
            {
                    j.joiId = Convert.ToInt32(_dt.Rows[0]["joiId"]);
                    j.positionTile = Convert.ToString(_dt.Rows[0]["positionTile"]);
                    j.contactId = Convert.ToInt32(_dt.Rows[0]["contactId"]);
                    j.contactName = Convert.ToString(_dt.Rows[0]["contactName"]);
                    j.recruitmetLeadId = Convert.ToInt32(_dt.Rows[0]["recruitmetLeadId"]);
                    j.recruitmetLeadName = Convert.ToString(_dt.Rows[0]["recruitmetLeadName"]);
                    j.recruiterId = Convert.ToInt32(_dt.Rows[0]["recruiterId"]);
                    j.recruiterName = Convert.ToString(_dt.Rows[0]["recruiterName"]);
                    j.targetDT = Convert.ToDateTime(_dt.Rows[0]["targetDT"]);
                    j.jobOpeningStatus = Convert.ToString(_dt.Rows[0]["jobOpeningStatus"]);
                    j.clientId = Convert.ToInt32(_dt.Rows[0]["clientId"]);
                    j.clientName = Convert.ToString(_dt.Rows[0]["clientName"]);
                    j.c_amId = Convert.ToInt32(_dt.Rows[0]["c_amId"]);
                    //j.openedDT = Convert.ToDateTime(_dt.Rows[0]["openedDT"]);
                    j.jobType = Convert.ToString(_dt.Rows[0]["jobType"]);
                    j.city = Convert.ToString(_dt.Rows[0]["city"]);
                    j.state = Convert.ToString(_dt.Rows[0]["state"]);
                    j.minWorkExperience = Convert.ToString(_dt.Rows[0]["minWorkExperience"]);
                    j.maxWorkExperience = Convert.ToString(_dt.Rows[0]["maxWorkExperience"]);
                    j.noOfPositions = Convert.ToString(_dt.Rows[0]["noOfPositions"]);
                    j.minCTC = Convert.ToDecimal(_dt.Rows[0]["minCTC"]);
                    j.maxCTC = Convert.ToDecimal(_dt.Rows[0]["maxCTC"]);
                    j.jobDesc = Convert.ToString(_dt.Rows[0]["jobDesc"]);
                    j.jobSummery = Convert.ToString(_dt.Rows[0]["jobSummery"]);
                    j.accountManager = Convert.ToString(_dt.Rows[0]["accountManager"]);
            }
            return j;
        }
    }
}
