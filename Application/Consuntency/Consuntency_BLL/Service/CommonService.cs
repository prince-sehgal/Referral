﻿using Consuntency_BLL.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Consuntency_BLL.Service
{
   public class CommonService
    {
        SqlParameter[] _param;
        DataTable _dt;
        SqlFunctions _sf;
        public CommonService()
        {
            _sf = new SqlFunctions();
        }

        public object executeScalarWithQuery(string query)
        {
            return _sf.executeScalerWithQuery(query);
        }
        public int executeNonQueryWithQuery(string query)
        {
            return _sf.executeNonQueryWithQuery(query);
        }
        public DataTable returnDTWithQuery_executeReader(string query)
        {
            return _sf.returnDTWithQuery_executeReader(query);
        }

    }
}
