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
public    class ManageUserService
    {
        SqlFunctions _sf;
        SqlParameter[] _param;
        DataTable _dt;
        public ManageUserService()
        {
            _sf = new SqlFunctions();

        }
        public int saveUser(ManageUser u)
        {
            _param = new SqlParameter[] { new SqlParameter("@userId", u.userId), new SqlParameter("@firstName", u.firstName), new SqlParameter("@lastName", u.lastName), new SqlParameter("@emailId", u.emailId), new SqlParameter("@password", u.password), new SqlParameter("@confirmPassword", u.confirmPassword), new SqlParameter("@mobileNo", u.mobileNo), new SqlParameter("@role", u.role), new SqlParameter("@portNo", u.portNo), new SqlParameter("@smtpServer", u.smtpServer), new SqlParameter("@status", u.status),new SqlParameter("@recruitmetLeadId",u.recruitmetLeadId),new SqlParameter("@managerName",u.managerName),new SqlParameter("@emailPassword",u.emailPassword) };
            return _sf.executeNonQueryWithProc("p_tblManageUser_save", _param);
        }
        public List<ManageUser> getUser()
        {
            _dt = _sf.returnDTWithProc_executeReader("p_tblManageUser_get");
            List<ManageUser> listUser = new List<ManageUser>();
            if(_dt.Rows.Count>0)
            {

                foreach (DataRow row in _dt.Rows)
                {
                    ManageUser u = new ManageUser();
                    u.userId = Convert.ToInt32(row["userId"]);
                    u.firstName = Convert.ToString(row["firstName"]);
                    u.lastName = Convert.ToString(row["lastName"]);
                    u.emailId = Convert.ToString(row["emailId"]);
                    u.password = Convert.ToString(row["password"]);
                    u.confirmPassword = Convert.ToString(row["confirmPassword"]);
                    u.mobileNo = Convert.ToString(row["mobileNo"]);
                    u.role = Convert.ToString(row["role"]);
                    u.portNo = Convert.ToString(row["portNo"]);
                    u.smtpServer = Convert.ToString(row["smtpServer"]);
                    u.status = Convert.ToString(row["status"]);
                    u.recruitmetLeadId =Convert.ToInt32(row["recruitmetLeadId"]);
                    u.managerName = Convert.ToString(row["managerName"]);
                    u.recruitmetLeadName =Convert.ToString(row["recruitmetLeadName"]);
                    u.emailPassword =Convert.ToString(row["emailPassword"]);
                    listUser.Add(u);
                }
            }
           return listUser;
        }
        public int deleteUser(int userId)
        {
            _param = new SqlParameter[] {new SqlParameter("@userId",userId) };
            return _sf.executeNonQueryWithProc("p_tblManageUser_delete",_param);
        }
        public DataTable checkExistsEmailId_MobileNo(ManageUser u)
        {
            _param = new SqlParameter[] {new SqlParameter("@userId",u.userId),new SqlParameter("@emailId",u.emailId),new SqlParameter("@mobileNo",u.mobileNo),new SqlParameter("@firstName", u.firstName) };
            return _sf.returnDTWithProc_executeReader("p_checkExistsEmailId_MobileNo", _param);
        }
        public List<RecruitmetLead> getRecruitmetLead()
        {
            _dt = _sf.returnDTWithProc_executeReader("p_tblManageUser_getRecruitmetLead");
            List<RecruitmetLead> listRecruitmetLead = new List<RecruitmetLead>();
            listRecruitmetLead.Insert(0, new RecruitmetLead { recruitmetLeadId = 0, recruitmetLeadName = "Select" });
            if (_dt.Rows.Count>0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    RecruitmetLead r = new RecruitmetLead();
                    r.recruitmetLeadId =Convert.ToInt32(row["userId"]);
                    r.recruitmetLeadName =Convert.ToString(row["firstName"]);
                    listRecruitmetLead.Add(r);
                }
            }
            return listRecruitmetLead;
        }
    }
}
