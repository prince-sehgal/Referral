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
   public class LoginService
    {
        SqlFunctions _sf;
        SqlParameter[] _param;
        DataTable _dt;
        public LoginService()
        {
            _sf = new SqlFunctions();

        }
        public DataTable authenticateUser(string userName, string password)
        {
            _param = new SqlParameter[] { new SqlParameter("@userName",userName),new SqlParameter("@password",password)
            };
           return _sf.returnDTWithProc_executeReader("p_AuthenticateUser",_param);
        }

    }
}
