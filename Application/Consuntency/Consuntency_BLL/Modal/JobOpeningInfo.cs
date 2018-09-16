using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Consuntency_BLL.Modal
{
  public  class JobOpeningInfo
    {
        public int joiId { get; set; }
        public string positionTile { get; set; }
        public int contactId { get; set; }
        public string contactName { get; set; }
        public int recruitmetLeadId { get; set; }
        public string recruitmetLeadName { get; set; }
        public int recruiterId { get; set; }
        public string recruiterName { get; set; }
        public DateTime? targetDT { get; set; }
        public string jobOpeningStatus { get; set; }
        public int clientId { get; set; }
        public string clientName { get; set; }
        public int? c_amId { get; set; }
        public DateTime? openedDT { get; set; }
        public string jobType { get; set; }
        public string city { get; set; }
        public string state { get; set; }
        public string minWorkExperience { get; set; }
        public string maxWorkExperience { get; set; }
        public string noOfPositions { get; set; }
        public decimal minCTC { get; set; }
        public decimal maxCTC { get; set; }
        public string jobDesc { get; set; }
        public string jobSummery { get; set; }
        public int crtUserId { get; set; }
        public int noOfCV { get; set; }
        public string accountManager { get; set; }
    }
}
