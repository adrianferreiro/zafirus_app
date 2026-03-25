import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/documents/presentation/screens/documents_screen.dart';
import '../../features/employee/presentation/screens/employee_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String documents = '/documents';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const EmployeeScreen(),
      ),
      GoRoute(
        path: documents,
        builder: (context, state) => const DocumentsScreen(),
      ),
    ],
  );
}
