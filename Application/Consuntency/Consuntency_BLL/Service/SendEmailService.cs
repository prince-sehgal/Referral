using Consuntency_BLL.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Consuntency_BLL.Service
{
   public class SendEmailService
    {
        SqlFunctions _sf;
        SqlParameter[] _param;
        DataTable _dt;
        public SendEmailService()
        {
            _sf = new SqlFunctions();
        }

        public List<string> getCandidateEmailId_byCandidateIds(string candidateIds)
        {
            List<string> listEmailId = new List<string>();
            _dt = _sf.returnDTWithQuery_executeReader("select email from tblCandidate where cId in("+candidateIds+")");
            if(_dt.Rows.Count>0)
            {
                foreach (DataRow row in _dt.Rows)
                {
                    listEmailId.Add(Convert.ToString(row["email"]));
                }
            }
            return listEmailId;
           
        }
    }
}
