import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, EmployeeEntity>> getEmployee(int employeeId);
}
