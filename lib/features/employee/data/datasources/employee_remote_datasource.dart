import 'package:dio/dio.dart';

import '../../../../core/constants/endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/employee_model.dart';
import 'employee_datasource.dart';

class EmployeeRemoteDatasource implements EmployeeDatasource {
  final DioClient _client;

  EmployeeRemoteDatasource(this._client);

  @override
  Future<EmployeeModel> getEmployee(int employeeId) async {
    try {
      final response = await _client.dio.get(Endpoints.employee(employeeId));
      final data = response.data['data'] as Map<String, dynamic>;
      return EmployeeModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? 'Error al obtener empleado',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
