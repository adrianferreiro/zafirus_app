import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_state_handler.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import '../providers/game_provider.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(leaderboardProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(leaderboardProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ranking')),
      body: AppStateHandler(
        state: state.viewState,
        useSkeletonizer: true,
        errorMessage: state.errorMessage,
        emptyMessage: 'No hay ranking disponible',
        onRetry: () => ref.read(leaderboardProvider.notifier).load(),
        onSuccess: (_) => state.entries.isNotEmpty
            ? _LeaderboardContent(entries: state.entries)
            : _LeaderboardPlaceholder(),
      ),
    );
  }
}

class _LeaderboardContent extends StatelessWidget {
  final List<LeaderboardEntryEntity> entries;

  const _LeaderboardContent({required this.entries});

  @override
  Widget build(BuildContext context) {
    final top3 = entries.take(3).toList();
    final rest = entries.skip(3).toList();

    return Column(
      children: [
        const SizedBox(height: 16),
        if (top3.isNotEmpty) _Podium(top3: top3),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: rest.length,
            itemBuilder: (context, index) => _EntryTile(entry: rest[index]),
          ),
        ),
      ],
    );
  }
}

class _Podium extends StatelessWidget {
  final List<LeaderboardEntryEntity> top3;

  const _Podium({required this.top3});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (top3.length > 1)
          _PodiumItem(entry: top3[1], height: 90, medal: '🥈'),
        if (top3.isNotEmpty)
          _PodiumItem(entry: top3[0], height: 120, medal: '🥇', isFirst: true),
        if (top3.length > 2)
          _PodiumItem(entry: top3[2], height: 70, medal: '🥉'),
      ],
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final LeaderboardEntryEntity entry;
  final double height;
  final String medal;
  final bool isFirst;

  const _PodiumItem({
    required this.entry,
    required this.height,
    required this.medal,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initials = '${entry.firstName[0]}${entry.lastName[0]}'.toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(medal, style: TextStyle(fontSize: isFirst ? 28 : 22)),
          const SizedBox(height: 4),
          CircleAvatar(
            radius: isFirst ? 32 : 24,
            backgroundColor: colors.primary,
            child: Text(
              initials,
              style: TextStyle(
                color: colors.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: isFirst ? 18 : 14,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 90,
            child: Text(
              entry.firstName,
              style: TextStyle(
                color: colors.onPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${entry.totalPoints} pts',
              style: TextStyle(
                color: colors.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 90,
            height: height,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
            ),
            alignment: Alignment.center,
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                color: AppColors.onPrimaryMuted,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  final LeaderboardEntryEntity entry;

  const _EntryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initials = '${entry.firstName[0]}${entry.lastName[0]}'.toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '#${entry.rank}',
                style: TextStyle(
                  color: AppColors.onPrimaryMuted,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 18,
              backgroundColor: colors.primary,
              child: Text(
                initials,
                style: TextStyle(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.fullName,
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${entry.gamesPlayed} partidas',
                    style: TextStyle(color: AppColors.onPrimarySubtle, fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              '${entry.totalPoints} pts',
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildPodium(90),
            _buildPodium(120),
            _buildPodium(70),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Text('#0'),
                    SizedBox(width: 12),
                    CircleAvatar(radius: 18),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Player name here'),
                          Text('0 partidas'),
                        ],
                      ),
                    ),
                    Text('00 pts'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildPodium(double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(radius: 24),
          const SizedBox(height: 8),
          Container(height: 14, width: 70, color: Colors.white),
          const SizedBox(height: 8),
          Container(
            width: 90,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
