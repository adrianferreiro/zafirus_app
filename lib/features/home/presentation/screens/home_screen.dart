import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _onLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(logoutUseCaseProvider).call();
    ref.read(currentUserProvider.notifier).state = null;
    if (context.mounted) context.go(AppRouter.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final initials = user != null
        ? '${user.name[0]}${user.lastName[0]}'.toUpperCase()
        : '??';

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF142840)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 36,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1F35),
                  ),
                ),
              ),
              accountName: Text(
                user != null ? '${user.name} ${user.lastName}' : '',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              accountEmail: Text(
                user?.email ?? '',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mi Perfil'),
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRouter.profile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.of(context).pop();
                _onLogout(context, ref);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      body: const Center(child: Text('Bienvenido a Zafirus')),
    );
  }
}
