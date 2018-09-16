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
   public class ContactService
    {
        SqlParameter[] _param;
        DataTable _dt;
        SqlFunctions _sf;
        public ContactService()
        {
            _sf = new SqlFunctions();
        }

        public int saveContact(Contact co)
        {
            _param = new SqlParameter[] {
                new SqlParameter("@contactId", co.contactId), new SqlParameter("@preName", co.preName), new SqlParameter("@firstName", co.firstName), new SqlParameter("@lastName", co.lastName), new SqlParameter("@clientId", co.clientId), new SqlParameter("@email", co.email), new SqlParameter("@workPhone", co.workPhone), new SqlParameter("@mobile", co.mobile), new SqlParameter("@crtUserId", co.crtUserId)
            };
            return Convert.ToInt32(_sf.executeScalerWithProc("p_tblContact_save", _param));
        }
        public List<Contact> getContact(int clientId)
        {
            _param = new SqlParameter[] {new SqlParameter("@clientId",clientId) };
            _dt = _sf.returnDTWithProc_executeReader("p_tblContact_get",_param);
            List<Contact> listContact = new List<Contact>();
            //listContact.Insert(0,new Contact {contactId=0,firstName="Select" });
            if(_dt.Rows.Count>0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    Contact co = new Contact();
                    co.contactId = Convert.ToInt32(row["contactId"]);
                    co.preName = Convert.ToString(row["preName"]);
                    co.firstName = Convert.ToString(row["firstName"]);
                    co.lastName = Convert.ToString(row["lastName"]);
                    co.clientId = Convert.ToInt32(row["clientId"]);
                    co.clientName = Convert.ToString(row["clientName"]);
                    co.email = Convert.ToString(row["email"]);
                    co.workPhone = Convert.ToString(row["workPhone"]);
                    co.mobile = Convert.ToString(row["mobile"]);
                    listContact.Add(co);
                }
            }
            return listContact;

        }
        public int deleteContact(int contactId)
        {
            _param = new SqlParameter[] { new SqlParameter("@contactId", contactId) };
            return _sf.executeNonQueryWithProc("p_tblContact_delete", _param);
        }
    }
}
