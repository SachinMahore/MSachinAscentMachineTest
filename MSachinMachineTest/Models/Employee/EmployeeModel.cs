using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Web;
using MSachinMachineTest.Data;

namespace MSachinMachineTest.Models
{
    public class EmployeeModel
    {
        public int EmployeeID { get; set; }
        public string EmployeeName { get; set; }
        public string City { get; set; }
        public int RowDisplay { get; set; }
        public int PageNumber { get; set; }

        public List<EmployeeModel> GetEmployeeListData(EmployeeModel model)
        {
            try
            {
                List<EmployeeModel> lstSearch = new List<EmployeeModel>();
                MSachinMachineTestEntities db = new MSachinMachineTestEntities();
                DataTable dtTable = new DataTable();
                using (var cmd = db.Database.Connection.CreateCommand())
                {
                    try
                    {
                        db.Database.Connection.Open();
                        cmd.CommandText = "usp_EmployeeListData";
                        cmd.CommandType = CommandType.StoredProcedure;

                        DbParameter paramDeN = cmd.CreateParameter();
                        paramDeN.ParameterName = "EmployeeName";
                        paramDeN.Value = model.EmployeeName;
                        cmd.Parameters.Add(paramDeN);

                        DbParameter paramCiT = cmd.CreateParameter();
                        paramCiT.ParameterName = "City";
                        paramCiT.Value = model.City;
                        cmd.Parameters.Add(paramCiT);
                      
                        DbParameter paramRD = cmd.CreateParameter();
                        paramRD.ParameterName = "RowDisplay";
                        paramRD.Value = model.RowDisplay;
                        cmd.Parameters.Add(paramRD);

                        DbParameter paramPN = cmd.CreateParameter();
                        paramPN.ParameterName = "PageNumber";
                        paramPN.Value = model.PageNumber == 0 ? 1 : model.PageNumber;
                        cmd.Parameters.Add(paramPN);

                        DbDataAdapter da = DbProviderFactories.GetFactory("System.Data.SqlClient").CreateDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(dtTable);
                        db.Database.Connection.Close();

                        foreach (DataRow dr in dtTable.Rows)
                        {
                            lstSearch.Add(new EmployeeModel()
                            {
                                EmployeeID = Convert.ToInt32(dr["EmployeeID"].ToString()),
                                EmployeeName = dr["EmployeeName"].ToString(),
                                City = dr["City"].ToString(),                               
                            });
                        }
                    }

                    catch (Exception ex)
                    {
                        db.Database.Connection.Close();
                    }
                }

                db.Dispose();
                return lstSearch.ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public string SaveUpdateEmployee(EmployeeModel model)
        {
            MSachinMachineTestEntities db = new MSachinMachineTestEntities();
            if (model.EmployeeID != 0)
            {
                var empDet = db.tbl_Employee.Where(p => p.EmployeeID == model.EmployeeID).FirstOrDefault();
                if (empDet != null)
                {
                    empDet.EmployeeName = model.EmployeeName;
                    empDet.City = model.City;
                  
                }
                db.SaveChanges();
            }
            else
            {
                var saveEmp = new tbl_Employee
                {
                    EmployeeName = model.EmployeeName,
                    City = model.City,
                    
                };
                db.tbl_Employee.Add(saveEmp);
                db.SaveChanges();
            }
            return "Employee Updated Successfully";
        }
    }
}