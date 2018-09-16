using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Consuntency_BLL.Modal
{
  public  class Interviews
    {
        public int interviewId { get; set; }
        public int imId { get; set; }
        public int candidateId { get; set; }
        public int clientId { get; set; }
        public int joiId { get; set; }
        public int c_amId { get; set; }
        public DateTime toDate { get; set; }
        public string toTime { get; set; }
        public string interviewStatus { get; set; }
        public string location { get; set; }
        public string scheduleComments { get; set; }
        public int crtUserId { get; set; }
        public string others_Photo_Doc { get; set; }
        public string clientName { get; set; }
        public string candidateName { get; set; }
        public string accountManager { get; set; }
        public string positionTitle { get; set; }
        public string interviewName { get; set; }
    }
}
