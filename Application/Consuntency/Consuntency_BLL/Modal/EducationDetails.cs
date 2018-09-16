using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Consuntency_BLL.Modal
{
    public class EducationDetails
    {
        public int eduId { get; set; }
        public int cId { get; set; }
        public string institute { get; set; }
        public string departmant { get; set; }
        public string degree { get; set; }
        public Boolean currentlyPursuing { get; set; }
        public string fromMonth { get; set; }
        public int fromYear { get; set; }
        public string toMonth { get; set; }
        public int toYear { get; set; }

    }
}
