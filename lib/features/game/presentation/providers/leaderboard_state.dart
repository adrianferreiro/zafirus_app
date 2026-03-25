import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/app_view_state.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

part 'leaderboard_state.freezed.dart';

@freezed
class LeaderboardState with _$LeaderboardState {
  const LeaderboardState._();

  const factory LeaderboardState({
    @Default(AppViewState.idle) AppViewState viewState,
    @Default([]) List<LeaderboardEntryEntity> entries,
    @Default(null) String? errorMessage,
  }) = _LeaderboardState;

  static LeaderboardState get initialState => const LeaderboardState();
}
