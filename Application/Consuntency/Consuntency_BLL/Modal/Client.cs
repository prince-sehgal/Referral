using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Consuntency_BLL.Modal
{
   public class Client
    {
        public int clientId { get; set; }
        public string clientName { get; set; }
        public string website { get; set; }
        public int recruitmetLeadId { get; set; }
        public string recruitmetLeadName { get; set; }
        public String recruiterName { get; set; }
        public int crtUserId { get; set; }
        public int modUserId { get; set; }
        public int recruiterId { get; set; }
        public string aboutCompany { get; set; }
        public string accountManager { get; set; }


    }
}
