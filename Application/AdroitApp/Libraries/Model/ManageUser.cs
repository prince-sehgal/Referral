using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Libraries.Model
{
    public class ManageUser
    {
        public int userId { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string emailId { get; set; }
        public string password { get; set; }
        public string confirmPassword { get; set; }
        public string mobileNo { get; set; }
        public string role { get; set; }
        public string portNo { get; set; }
        public string smtpServer { get; set; }
        public string status { get; set; }
        public int recruitmetLeadId { get; set; }
        public string managerName { get; set; }
        public string recruitmetLeadName { get; set; }
        public string emailPassword { get; set; }

    }
}
