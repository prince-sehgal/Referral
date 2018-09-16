using Libraries.Connectors;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Libraries.Service
{
   public class LoginService
    {
        Sql _sf;
        SqlParameter[] _param;
        DataTable _dt;
        public LoginService()
        {
            _sf = new Sql();

        }
        public DataTable authenticateUser(string userName, string password)
        {
            _param = new SqlParameter[] { new SqlParameter("@userName",userName),new SqlParameter("@password",password)
            };
           return _sf.returnDTWithProc_executeReader("p_AuthenticateUser",_param);
        }

    }
}
