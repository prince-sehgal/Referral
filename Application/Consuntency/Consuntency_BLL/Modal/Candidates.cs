using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Consuntency_BLL.Modal
{
    public class Candidates
    {
        public int cId { get; set; }
        public string email { get; set; }
        public string firstName { get; set; }
        public string middleName { get; set; }
        public string lastName { get; set; }
        public string phone { get; set; }
        public string mobile { get; set; }
        public string secondaryEmail { get; set; }
        public string street { get; set; }
        public string postalCode { get; set; }
        public string city { get; set; }
        public string state { get; set; }
        public string country { get; set; }
        public string experienceInYear { get; set; }
        public int? quaId { get; set; }
        public string currentJobTitle { get; set; }
        public string currentEmployer { get; set; }
        public decimal? expectedSalary { get; set; }
        public decimal? currentSalary { get; set; }
        public string skillSet { get; set; }
        public int? csSubCatId { get; set; }
        public int? sourceId { get; set; }
        //public int? recruiterId { get; set; }
        public string resume { get; set; }
        public string others { get; set; }
        public string csSubCat { get; set; }
        //public string recruiterName { get; set; }
        public string source { get; set; }
        public int crtUserId { get; set; }
        public string positionTile { get; set; }
        public string comments { get; set; }
        public int noOfAppliedJobs { get; set; }

    }
}
