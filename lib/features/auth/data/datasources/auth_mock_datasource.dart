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
      throw Exception('Credenciales inválidas');
    }

    return const LoginResponseModel(
      token: 'mock_token_abc123',
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
        name: 'Juan',
        lastName: 'Pérez',
        phone: '+595981123456',
        email: 'juan@example.com',
      );
    }

    throw Exception('Token inválido');
  }

  @override
  Future<void> logout(String token) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
