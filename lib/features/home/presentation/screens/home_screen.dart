import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/app_state_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../birthdays/domain/entities/birthday_entity.dart';
import '../../../birthdays/presentation/providers/birthday_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(birthdaysProvider.notifier).load());
  }

  Future<void> _onLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(logoutUseCaseProvider).call();
    ref.read(currentUserProvider.notifier).state = null;
    if (context.mounted) {
      AppToast.success(context, message: 'Sesión cerrada');
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final birthdaysState = ref.watch(birthdaysProvider);
    final colors = Theme.of(context).colorScheme;
    final initials = user != null
        ? '${user.name[0]}${user.lastName[0]}'.toUpperCase()
        : '??';

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryLight),
              currentAccountPicture: CircleAvatar(
                backgroundColor: colors.primary,
                radius: 36,
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimary,
                  ),
                ),
              ),
              accountName: Text(
                user != null ? '${user.name} ${user.lastName}' : '',
                style: TextStyle(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: Text(
                user?.email ?? '',
                style: TextStyle(color: AppColors.onPrimaryMuted),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, ${user?.name ?? ''}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '¿Qué necesitás hoy?',
              style: TextStyle(color: AppColors.onPrimarySubtle, fontSize: 14),
            ),
            const SizedBox(height: 24),
            _BirthdayHeader(colors: colors),
            const SizedBox(height: 12),
            SizedBox(
              height: 68,
              child: AppStateHandler(
                state: birthdaysState.viewState,
                useSkeletonizer: true,
                emptyMessage: 'No hay cumpleaños hoy',
                errorMessage:
                    birthdaysState.errorMessage ??
                    'No se pudieron cargar los cumpleaños',
                onRetry: () => ref.read(birthdaysProvider.notifier).load(),
                onSuccess: (_) => birthdaysState.birthdays.isNotEmpty
                    ? _BirthdayList(birthdays: birthdaysState.birthdays)
                    : _BirthdayListPlaceholder(),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _QuickCard(
                    icon: Icons.person_outline,
                    label: 'Mi Perfil',
                    onTap: () => context.push(AppRouter.profile),
                  ),
                  _QuickCard(
                    icon: Icons.folder_outlined,
                    label: 'Documentos',
                    onTap: () => context.push(AppRouter.documents),
                  ),
                  _QuickCard(
                    icon: Icons.emoji_events_outlined,
                    label: 'Ranking',
                    onTap: () => context.push(AppRouter.leaderboard),
                  ),
                  _QuickCard(
                    icon: Icons.sports_esports_outlined,
                    label: 'Jugar',
                    onTap: () => context.push(AppRouter.play),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BirthdayHeader extends StatelessWidget {
  final ColorScheme colors;

  const _BirthdayHeader({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.cake, color: colors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          'Cumpleaños hoy',
          style: TextStyle(
            color: colors.onPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _BirthdayList extends StatelessWidget {
  final List<BirthdayEntity> birthdays;

  const _BirthdayList({required this.birthdays});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: birthdays.length,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (context, index) =>
          _BirthdayChip(birthday: birthdays[index]),
    );
  }
}

class _BirthdayChip extends StatelessWidget {
  final BirthdayEntity birthday;

  const _BirthdayChip({required this.birthday});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initials = '${birthday.firstName[0]}${birthday.lastName[0]}'
        .toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: colors.primary,
            child: Text(
              initials,
              style: TextStyle(
                color: colors.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                birthday.fullName,
                style: TextStyle(
                  color: colors.onPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (birthday.position != null)
                Text(
                  birthday.position!,
                  style: TextStyle(
                    color: AppColors.onPrimarySubtle,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: colors.primary, size: 28),
            Text(
              label,
              style: TextStyle(
                color: colors.onPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BirthdayListPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, __) => Container(
        width: 180,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            CircleAvatar(radius: 18),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Nombre aqui'),
                Text('Posición'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
