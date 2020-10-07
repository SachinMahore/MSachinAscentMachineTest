using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MSachinMachineTest.Models;

namespace MSachinMachineTest.Controllers.Employee
{
    public class EmployeeController : Controller
    {
        // GET: Employee
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult GetEmployeeListData(EmployeeModel model)
        {
            try
            {
                return Json((new EmployeeModel()).GetEmployeeListData(model), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }
        public ActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Create(EmployeeModel collection)
        {

            try
            {
                var model = new EmployeeModel().SaveUpdateEmployee(collection);

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}