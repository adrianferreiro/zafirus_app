import '../models/login_response_model.dart';

abstract class AuthDatasource {
  Future<LoginResponseModel> login({
    required String username,
    required String pin,
  });

  Future<LoginResponseModel> validateToken(String token);

  Future<void> logout(String token);
}
