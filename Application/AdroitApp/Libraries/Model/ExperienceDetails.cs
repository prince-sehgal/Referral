using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Libraries.Model
{
   public class ExperienceDetails
    {
        public int expId { get; set; }
        public int cId { get; set; }
        public string occupation { get; set; }
        public string company { get; set; }
        public string summery { get; set; }
        public Boolean currentlyWork { get; set; }
        public string fromMonth { get; set; }
        public int fromYear { get; set; }
        public string toMonth { get; set; }
        public int toYear { get; set; }

    }
}
