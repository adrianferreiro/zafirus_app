import 'package:dio/dio.dart';

import '../../../../core/constants/endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_response_model.dart';
import 'auth_datasource.dart';

class AuthRemoteDatasource implements AuthDatasource {
  final DioClient _client;

  AuthRemoteDatasource(this._client);

  @override
  Future<LoginResponseModel> login({
    required String username,
    required String pin,
  }) async {
    try {
      final response = await _client.dio.post(
        Endpoints.login,
        data: {'username': username, 'pin': pin},
      );
      return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? 'Error del servidor',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
