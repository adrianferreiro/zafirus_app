import '../models/employee_model.dart';

abstract class EmployeeDatasource {
  Future<EmployeeModel> getEmployee(int employeeId);
}
