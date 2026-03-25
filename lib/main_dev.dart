import 'core/config/app_config.dart';
import 'core/config/flavor.dart';
import 'main.dart' as app;

void main() {
  AppConfig.init(flavor: Flavor.dev, useMock: true);
  app.main();
}
