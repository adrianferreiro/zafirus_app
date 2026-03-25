import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_datasource.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeDatasource _datasource;

  EmployeeRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, EmployeeEntity>> getEmployee(int employeeId) async {
    try {
      final response = await _datasource.getEmployee(employeeId);
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado'));
    }
  }
}
