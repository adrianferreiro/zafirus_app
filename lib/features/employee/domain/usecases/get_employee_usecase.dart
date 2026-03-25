import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

class GetEmployeeUseCase {
  final EmployeeRepository _repository;

  GetEmployeeUseCase(this._repository);

  Future<Either<Failure, EmployeeEntity>> call(int employeeId) =>
      _repository.getEmployee(employeeId);
}
