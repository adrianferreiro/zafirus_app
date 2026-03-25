class Endpoints {
  Endpoints._();

  static const String _apiVersion = '/api/v1';

  // Auth
  static const String login = '$_apiVersion/auth/login';
  static const String validateToken = '$_apiVersion/auth/validate-token';
  static const String logout = '$_apiVersion/auth/logout';

  // Employee
  static String employee(int id) => '$_apiVersion/employees/$id';
  static String employeeDocuments(int id) => '$_apiVersion/employees/$id/documents';

  // Birthdays
  static const String birthdaysToday = '$_apiVersion/birthdays/today';
}
