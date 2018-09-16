using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;

namespace Consuntency.Security
{
    public class CustomPrincipal : IPrincipal
    {
        //private Account Account;
        //private AccountModel am = new AccountModel();
        private string userName;
        public  CustomPrincipal(string userName)
        {
            this.userName = userName;
            this.Identity = new GenericIdentity(userName);

        }

        public IIdentity Identity
        {
            get;
            set;   
        }

        public bool IsInRole(string role)
        {
            var roles = role;
            return "all" == role;
        }
    }
}