import 'flavor.dart';

class AppConfig {
  final Flavor flavor;
  final String baseUrl;
  final bool useMock;

  static late final AppConfig _instance;

  AppConfig._({required this.flavor, required this.baseUrl, required this.useMock});

  static void init({required Flavor flavor, bool useMock = false}) {
    _instance = AppConfig._(
      flavor: flavor,
      baseUrl: _baseUrlFor(flavor),
      useMock: useMock,
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
