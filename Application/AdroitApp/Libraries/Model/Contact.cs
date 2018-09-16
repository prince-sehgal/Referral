using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Libraries.Model
{
   public class Contact
    {
        public int contactId { get; set; }
        public string preName { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public int clientId { get; set; }
        public string clientName { get; set; }
        public string email { get; set; }
        public string workPhone { get; set; }
        public string mobile { get; set; }
        public int crtUserId { get; set; }
        

    }
}
