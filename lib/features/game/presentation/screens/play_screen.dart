import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../domain/entities/active_round_entity.dart';
import '../providers/game_provider.dart';

class PlayScreen extends ConsumerStatefulWidget {
  const PlayScreen({super.key});

  @override
  ConsumerState<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends ConsumerState<PlayScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(playProvider.notifier).fetchRound());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playProvider);

    ref.listen<PlayState>(playProvider, (_, next) {
      next.maybeWhen(
        noRound: () {
          AppToast.info(context, message: 'No hay ronda activa, intentá de nuevo');
          ref.read(playProvider.notifier).reset();
        },
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Jugar')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: state.when(
          initial: () => _PlayButton(
            onPressed: () => ref.read(playProvider.notifier).fetchRound(),
          ),
          loading: () => AppSkeleton(
            child: Column(
              children: [
                const Center(
                  child: Column(
                    children: [
                      CircleAvatar(radius: 24),
                      SizedBox(height: 8),
                      Text('Nombre de la persona'),
                      SizedBox(height: 4),
                      Text('¿Cuál es la mentira?'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ...List.generate(3, (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('Una afirmación de ejemplo aquí'),
                  ),
                )),
              ],
            ),
          ),
          noRound: () => _PlayButton(
            onPressed: () => ref.read(playProvider.notifier).fetchRound(),
          ),
          round: (round) => _RoundView(round: round),
          voting: () => const Center(child: CircularProgressIndicator()),
          result: (result) => _ResultView(
            result: result,
            onPlayAgain: () => ref.read(playProvider.notifier).fetchRound(),
          ),
          error: (message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, style: TextStyle(color: AppColors.onPrimaryMuted)),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.read(playProvider.notifier).fetchRound(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _PlayButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sports_esports, size: 64, color: colors.primary),
          const SizedBox(height: 16),
          Text(
            '¿Listo para jugar?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Esperá a que la admin active la ronda',
            style: TextStyle(color: AppColors.onPrimarySubtle, fontSize: 14),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Buscar ronda'),
          ),
        ],
      ),
    );
  }
}

class _RoundView extends ConsumerWidget {
  final ActiveRoundEntity round;

  const _RoundView({required this.round});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Icon(Icons.person, size: 48, color: colors.primary),
              const SizedBox(height: 8),
              Text(
                round.personName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '¿Cuál es la mentira?',
                style: TextStyle(color: AppColors.onPrimarySubtle, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        ...round.statements.map(
          (statement) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _StatementCard(
              statement: statement,
              onTap: () => ref.read(playProvider.notifier).vote(
                    roundId: round.roundId,
                    statementId: statement.id,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatementCard extends StatelessWidget {
  final StatementEntity statement;
  final VoidCallback onTap;

  const _StatementCard({required this.statement, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                statement.text,
                style: TextStyle(color: colors.onPrimary, fontSize: 15),
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.touch_app, color: AppColors.onPrimarySubtle, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final dynamic result;
  final VoidCallback onPlayAgain;

  const _ResultView({required this.result, required this.onPlayAgain});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: colors.primary),
          const SizedBox(height: 16),
          Text(
            result.message as String,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Esperá a que la admin revele la respuesta',
            style: TextStyle(color: AppColors.onPrimarySubtle, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onPlayAgain,
            icon: const Icon(Icons.refresh),
            label: const Text('Siguiente ronda'),
          ),
        ],
      ),
    );
  }
}
