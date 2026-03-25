class Endpoints {
  Endpoints._();

  static const String _apiVersion = '/api/v1';

  // Auth
  static const String login = '$_apiVersion/auth/login';
  static const String validateToken = '$_apiVersion/auth/validate-token';
  static const String logout = '$_apiVersion/auth/logout';
}
