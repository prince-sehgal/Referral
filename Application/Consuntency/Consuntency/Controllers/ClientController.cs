using Consuntency.Security;
using Consuntency_BLL.Modal;
using Consuntency_BLL.Service;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Consuntency.Controllers
{
    [CustomAuthorize]
    public class ClientController : Controller
    {
        ClientService _clientSer = new ClientService();
        // GET: Client
        public ActionResult client()
        {
            return View();
            //if (MySession.userName != null)
            //{
            //    return View();
            //}
            //else
            //{
            //    return RedirectToAction("index","Login");
            //}
        }
        public JsonResult saveClient(Client c,List<Client_AccountManager> listAccountManager)
        {
            string msg = null;
            int clientId = 0;
            try
            {
                c.crtUserId = MySession.userId;
                clientId = _clientSer.saveClient(c);
                if (clientId > 0 && listAccountManager != null)
                {
                    foreach (Client_AccountManager am in listAccountManager)
                    {
                        am.clientId = clientId;
                        _clientSer.saveClient_AccountManager(am);
                    }
                }
                msg = clientId > 0 ? "s" : "f";
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new {clientId=clientId, msg=msg },JsonRequestBehavior.AllowGet);
        }
        public JsonResult getClient()
        {
            string msg = null;
            List<Client> listClient = new List<Client>();
            List<Client_AccountManager> listAM = new List<Client_AccountManager>();
            try
            {
                //c.crtUserId = MySession.userId;
                listClient = _clientSer.getClient();
                listAM = _clientSer.getClient_AccountManager(0);
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new {listClient=listClient, listAM = listAM, msg = msg }, JsonRequestBehavior.AllowGet);
        }
        public JsonResult deleteClient(string clientIds)
        {
            string msg = null;
            int status = 0;
            string errorCode = null;
            try
            {
                foreach (var clientId in clientIds.Split(','))
                {
                    try
                    {
                        status += _clientSer.deleteClient(Convert.ToInt32(clientId));
                    }
                  catch(SqlException ex)
                    {
                        errorCode = ex.Number.ToString();
                    }
                }
                msg = status > 0 ? "s" : "f";
                msg = errorCode == "547"?"ec":msg;
            }
            catch (Exception ex)
            {
                msg = "Error:" + ex.Message;
            }
            return Json(new { msg = msg }, JsonRequestBehavior.AllowGet);

        }
        public JsonResult deleteClient_AccountManager(int c_amId, int clientId)
        {
            string msg = null;
            int status = 0;
            string errorCode = null;
            try
            {
                status = _clientSer.deleteClient_AccountManager(c_amId,clientId);
            
            }
            catch (SqlException ex)
            {
                errorCode = ex.Number.ToString();
            }
            msg = status > 0 ? "s" : "f";
            msg = errorCode == "547" ? "ec" : msg;
            return Json(new { msg = msg }, JsonRequestBehavior.AllowGet);

        }
    }
}