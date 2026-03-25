import '../../../../core/utils/app_view_state.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

class LeaderboardViewState {
  final AppViewState status;
  final List<LeaderboardEntryEntity> data;
  final String? errorMessage;

  const LeaderboardViewState({
    this.status = AppViewState.idle,
    this.data = const [],
    this.errorMessage,
  });

  LeaderboardViewState copyWith({
    AppViewState? status,
    List<LeaderboardEntryEntity>? data,
    String? errorMessage,
  }) => LeaderboardViewState(
        status: status ?? this.status,
        data: data ?? this.data,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
