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
   public class EmailTemplateService
    {
        SqlParameter[] _param;
        DataTable _dt;
        SqlFunctions _sf;
        public EmailTemplateService()
        {
            _sf = new SqlFunctions();
        }
        public int saveEmailTemplate(EmailTemplate e)
        {
            _param = new SqlParameter[] {new SqlParameter("@etId",e.etId), new SqlParameter("@title", e.title), new SqlParameter("@description", e.description), new SqlParameter("@crtUserId", e.crtUserId) ,new SqlParameter("@subject",e.subject) };
            return _sf.executeNonQueryWithProc("p_tblEmailTemplate_save", _param);
        }
        public int deleteEmailTemplate(string etIds)
        {
            _param = new SqlParameter[] { new SqlParameter("@etIds", etIds) };
            return _sf.executeNonQueryWithProc("p_tblEmailTemplate_delete", _param);
        }
        public List<EmailTemplate> getEmailTemplate()
        {
            _dt = _sf.returnDTWithProc_executeReader("p_tblEmailTemplate_get");
            List<EmailTemplate> listET = new List<EmailTemplate>();
            if(_dt.Rows.Count>0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    EmailTemplate et = new EmailTemplate();
                    et.etId =Convert.ToInt32(row["etId"]);
                    et.title =Convert.ToString(row["title"]);
                    et.description =Convert.ToString(row["description"]);
                    et.subject = Convert.ToString(row["subject"]);
                    listET.Add(et);
                }
            }
            return listET;
        }
    }
}
