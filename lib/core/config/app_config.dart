import 'flavor.dart';

class AppConfig {
  final Flavor flavor;
  final String baseUrl;

  static late final AppConfig _instance;

  AppConfig._({required this.flavor, required this.baseUrl});

  static void init({required Flavor flavor}) {
    _instance = AppConfig._(
      flavor: flavor,
      baseUrl: _baseUrlFor(flavor),
    );
  }

  static AppConfig get instance => _instance;

  static String _baseUrlFor(Flavor flavor) => switch (flavor) {
        Flavor.dev => 'https://dev-api.example.com',
        Flavor.staging => 'https://staging-api.example.com',
        Flavor.prod => 'https://api.example.com',
      };

  bool get isDev => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProd => flavor == Flavor.prod;
}
