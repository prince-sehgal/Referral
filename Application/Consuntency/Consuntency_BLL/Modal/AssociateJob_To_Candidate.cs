using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Consuntency_BLL.Modal
{
 public  class AssociateJob_To_Candidate
    {
        public int associateJCId { get; set; }
        public int joiId { get; set; }
        public int candidateId { get; set; }
        public string comments { get; set; }
        public int crtUserId { get; set; }
        public int csSubCatId { get; set; }
        public string recruitmetLeadName { get; set; }
        public string recruiterName { get; set; }
        public string csSubCat { get; set; }
        public string clientName { get; set; }
        public string positionTile { get; set; }
        public string currentJobTitle { get; set; }


    }
}
