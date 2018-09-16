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
   public class ClientService
    {
        SqlFunctions _sf;
        SqlParameter[] _param;
        DataTable _dt;
        public ClientService()
        {
            _sf = new SqlFunctions();

        }
        public int saveClient(Client c)
        {
            _param = new SqlParameter[] {new SqlParameter("@clientId",c.clientId), new SqlParameter("@clientName", c.clientName), new SqlParameter("@website", c.website), new SqlParameter("@recruitmetLeadId", c.recruitmetLeadId), new SqlParameter("@crtUserId", c.crtUserId),new SqlParameter("@recruiterId", c.recruiterId),new SqlParameter("@aboutCompany", c.aboutCompany)};
            return Convert.ToInt32(_sf.executeScalerWithProc("p_tblClient_save", _param));
        }

        public List<Client> getClient()
        {
            _dt = _sf.returnDTWithProc_executeReader("p_tblClient_get");
            List<Client> listClient = new List<Client>();
            //listClient.Insert(0,new Client {clientId=0,clientName="Select"});
            if(_dt.Rows.Count>0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    Client c = new Client();
                    c.clientId = Convert.ToInt32(row["clientId"]);
                    c.clientName = Convert.ToString(row["clientName"]);
                    c.website = Convert.ToString(row["website"]);
                    c.recruitmetLeadId = Convert.ToInt32(row["recruitmetLeadId"]);
                    c.recruitmetLeadName =Convert.ToString(row["recruitmetLeadName"]);
                    c.recruiterId = Convert.ToInt32(row["recruiterId"]);
                    c.recruiterName = Convert.ToString(row["recruiterName"]);
                    listClient.Add(c);
                }
            }
            return listClient;
        }
        public List<Client_AccountManager> getClient_AccountManager(int clientId)
        {
            _param = new SqlParameter[] { new SqlParameter("@clientId",clientId)};
            _dt = _sf.returnDTWithProc_executeReader("p_tblClient_AccountManager_get",_param);
            List<Client_AccountManager> listAM = new List<Client_AccountManager>();
            if(_dt.Rows.Count>0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    Client_AccountManager am = new Client_AccountManager();
                    am.c_amId = Convert.ToInt32(row["c_amId"]);
                    am.clientId = Convert.ToInt32(row["clientId"]);
                    am.accountManager = Convert.ToString(row["accountManager"]);
                    am.contactNo = Convert.ToString(row["contactNo"]);
                    am.emailId = Convert.ToString(row["emailId"]);
                    listAM.Add(am);
                }
            }
            return listAM;
        }
        public int deleteClient(int clientId)
        {
            _param = new SqlParameter[] { new SqlParameter("@clientId", clientId) };
            return _sf.executeNonQueryWithProc("p_tblClient_delete", _param);
        }
        public int saveClient_AccountManager(Client_AccountManager am)
        {
            _param = new SqlParameter[] { new SqlParameter("@c_amId", am.c_amId), new SqlParameter("@clientId", am.clientId), new SqlParameter("@accountManager", am.accountManager),new SqlParameter("@contactNo",am.contactNo),new SqlParameter("@emailId",am.emailId) };
            return _sf.executeNonQueryWithProc("p_tblClient_AccountManager_save", _param);
        }
        public int deleteClient_AccountManager(int c_amId,int clientId)
        {
            _param = new SqlParameter[] {new SqlParameter("@c_amId",c_amId), new SqlParameter("@clientId", clientId) };
            return _sf.executeNonQueryWithProc("p_tblClient_AccountManager_delete", _param);
        }
    }
}
