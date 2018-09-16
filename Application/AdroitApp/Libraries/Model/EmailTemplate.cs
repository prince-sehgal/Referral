using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Libraries.Model
{
   public class EmailTemplate
    {
        public int etId { get; set; }
        public string title { get; set; }
        public string subject { get; set; }
        public string description { get; set; }
        public int crtUserId { get; set; }

    }
}
