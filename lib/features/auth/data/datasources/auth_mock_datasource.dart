import '../../../../core/errors/exceptions.dart';
import '../models/login_response_model.dart';
import 'auth_datasource.dart';

class AuthMockDatasource implements AuthDatasource {
  bool _mustChangePin = false;

  @override
  Future<LoginResponseModel> login({
    required String username,
    required String pin,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (pin == '000000') {
      throw const ServerException(
        message: 'Credenciales inválidas',
        statusCode: 401,
      );
    }

    return LoginResponseModel(
      token: 'mock_token_abc123',
      employeeId: 1001,
      name: 'Juan',
      lastName: 'Pérez',
      phone: '+595981123456',
      email: 'juan@example.com',
      mustChangePin: _mustChangePin,
    );
  }

  @override
  Future<LoginResponseModel> validateToken(String token) async {
    await Future.delayed(const Duration(seconds: 1));

    if (token == 'mock_token_abc123') {
      return LoginResponseModel(
        token: 'mock_token_abc123',
        employeeId: 1001,
        name: 'Juan',
        lastName: 'Pérez',
        phone: '+595981123456',
        email: 'juan@example.com',
        mustChangePin: _mustChangePin,
      );
    }

    throw const ServerException(message: 'Token inválido', statusCode: 401);
  }

  @override
  Future<void> logout(String token) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> changePin({
    required String token,
    required String currentPin,
    required String newPin,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (currentPin == '000000') {
      throw const ServerException(
        message: 'PIN actual incorrecto',
        statusCode: 400,
      );
    }

    _mustChangePin = false;
  }
}
