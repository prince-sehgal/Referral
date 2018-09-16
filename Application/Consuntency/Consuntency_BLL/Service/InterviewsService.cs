using Consuntency_BLL.DAL;
using Consuntency_BLL.Modal;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Consuntency_BLL.Service
{
   public class InterviewsService
    {
        SqlParameter[] _param;
        DataTable _dt;
        SqlFunctions _sf;
        public InterviewsService()
        {
            _sf = new SqlFunctions();
        }
        public List<InterviewNameMaster> getInterviewName()
        {
            _dt = _sf.returnDTWithProc_executeReader("p_tblInterviewNameMaster_get");
            List<InterviewNameMaster> listIM = new List<InterviewNameMaster>();
            if(_dt.Rows.Count>0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    InterviewNameMaster im = new InterviewNameMaster();
                    im.imId =Convert.ToInt32(row["imId"]);
                    im.interviewName =Convert.ToString(row["interviewName"]);
                    listIM.Add(im);
                }

            }
            return listIM;
        }
        public int saveInterviews(Interviews i)
        {
            _param = new SqlParameter[] { new SqlParameter("@interviewId", i.interviewId), new SqlParameter("@imId", i.imId), new SqlParameter("@candidateId", i.candidateId), new SqlParameter("@clientId", i.clientId), new SqlParameter("@joiId", i.joiId), new SqlParameter("@c_amId", i.c_amId), new SqlParameter("@toDate", i.toDate), new SqlParameter("@toTime", i.toTime), new SqlParameter("@interviewStatus", i.interviewStatus), new SqlParameter("@location", i.location), new SqlParameter("@scheduleComments", i.scheduleComments), new SqlParameter("@crtUserId", i.crtUserId) };
            return Convert.ToInt32(_sf.executeScalerWithProc("p_tblInterviews_save", _param));
        }
        public List<Interviews> getInterviews(int candidateId)
        {
            _param = new SqlParameter[] { new SqlParameter("@candidateId",candidateId) };
            _dt = _sf.returnDTWithProc_executeReader("p_tblInterviews_get",_param);
            List<Interviews> listInterviews = new List<Interviews>();
            if(_dt.Rows.Count>0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    Interviews i = new Interviews();
                    i.interviewId = Convert.ToInt32(row["interviewId"]);
                    i.imId = Convert.ToInt32(row["imId"]);
                    i.candidateId = Convert.ToInt32(row["candidateId"]);
                    i.clientId = Convert.ToInt32(row["clientId"]);
                    i.joiId = Convert.ToInt32(row["joiId"]);
                    i.c_amId = Convert.ToInt32(row["c_amId"]);
                    i.toDate = Convert.ToDateTime(row["toDate"]);
                    i.toTime = Convert.ToString(row["toTime"]);
                    i.interviewStatus = Convert.ToString(row["interviewStatus"]);
                    i.location = Convert.ToString(row["location"]);
                    i.scheduleComments = Convert.ToString(row["scheduleComments"]);
                    i.others_Photo_Doc =Convert.ToString(row["others_Photo_Doc"]);
                    i.positionTitle =Convert.ToString(row["positionTitle"]);
                    i.clientName = Convert.ToString(row["clientName"]);
                    i.candidateName = Convert.ToString(row["firstName"]);
                    i.accountManager = Convert.ToString(row["accountManager"]);
                    i.interviewName = Convert.ToString(row["interviewName"]);
                    listInterviews.Add(i);
                }
            }
            return listInterviews;
        }
        public int deleteInterviews(string interviewIds)
        {
            _param = new SqlParameter[] { new SqlParameter("@interviewIds", interviewIds) };
            return _sf.executeNonQueryWithProc("p_tblInterviews_delete",_param);
        }
    }
}
