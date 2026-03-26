import '../../../../core/errors/exceptions.dart';
import '../models/login_response_model.dart';
import 'auth_datasource.dart';

class AuthMockDatasource implements AuthDatasource {
  @override
  Future<LoginResponseModel> login({
    required String username,
    required String pin,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (pin == '000000') {
      throw const ServerException(message: 'Credenciales inválidas', statusCode: 401);
    }

    return const LoginResponseModel(
      token: 'mock_token_abc123',
      employeeId: 1001,
      name: 'Juan',
      lastName: 'Pérez',
      phone: '+595981123456',
      email: 'juan@example.com',
    );
  }

  @override
  Future<LoginResponseModel> validateToken(String token) async {
    await Future.delayed(const Duration(seconds: 1));

    if (token == 'mock_token_abc123') {
      return const LoginResponseModel(
        token: 'mock_token_abc123',
        employeeId: 1001,
        name: 'Juan',
        lastName: 'Pérez',
        phone: '+595981123456',
        email: 'juan@example.com',
      );
    }

    throw const ServerException(message: 'Token inválido', statusCode: 401);
  }

  @override
  Future<void> logout(String token) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
