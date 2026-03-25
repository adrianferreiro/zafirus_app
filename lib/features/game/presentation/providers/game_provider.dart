import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/app_view_state.dart';
import '../../data/datasources/game_datasource.dart';
import '../../data/datasources/game_mock_datasource.dart';
import '../../data/datasources/game_remote_datasource.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../domain/entities/active_round_entity.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import '../../domain/entities/vote_result_entity.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/usecases/get_active_round_usecase.dart';
import '../../domain/usecases/get_leaderboard_usecase.dart';
import '../../domain/usecases/submit_vote_usecase.dart';

part 'game_provider.freezed.dart';

// DI chain
final gameDatasourceProvider = Provider<GameDatasource>((ref) {
  if (AppConfig.instance.useMock) return GameMockDatasource();
  return GameRemoteDatasource(ref.read(dioClientProvider));
});

final gameRepositoryProvider = Provider<GameRepository>(
  (ref) => GameRepositoryImpl(ref.read(gameDatasourceProvider)),
);

final getLeaderboardUseCaseProvider = Provider<GetLeaderboardUseCase>(
  (ref) => GetLeaderboardUseCase(ref.read(gameRepositoryProvider)),
);

final getActiveRoundUseCaseProvider = Provider<GetActiveRoundUseCase>(
  (ref) => GetActiveRoundUseCase(ref.read(gameRepositoryProvider)),
);

final submitVoteUseCaseProvider = Provider<SubmitVoteUseCase>(
  (ref) => SubmitVoteUseCase(ref.read(gameRepositoryProvider)),
);

// Leaderboard
class LeaderboardNotifier extends StateNotifier<AppViewState> {
  final GetLeaderboardUseCase _getLeaderboard;
  List<LeaderboardEntryEntity> data = [];
  String? errorMessage;

  LeaderboardNotifier(this._getLeaderboard) : super(AppViewState.idle);

  Future<void> load() async {
    state = AppViewState.loading;
    final result = await _getLeaderboard();
    result.fold(
      (failure) {
        errorMessage = failure.message;
        state = AppViewState.error;
      },
      (entries) {
        data = entries;
        state = entries.isEmpty ? AppViewState.empty : AppViewState.success;
      },
    );
  }
}

final leaderboardProvider = StateNotifierProvider<LeaderboardNotifier, AppViewState>(
  (ref) => LeaderboardNotifier(ref.read(getLeaderboardUseCaseProvider)),
);

// Play State (mantiene freezed por estados custom)
@freezed
class PlayState with _$PlayState {
  const factory PlayState.initial() = _PInitial;
  const factory PlayState.loading() = _PLoading;
  const factory PlayState.round(ActiveRoundEntity round) = _PRound;
  const factory PlayState.voting() = _PVoting;
  const factory PlayState.result(VoteResultEntity result) = _PResult;
  const factory PlayState.noRound() = _PNoRound;
  const factory PlayState.error(String message) = _PError;
}

class PlayNotifier extends StateNotifier<PlayState> {
  final GetActiveRoundUseCase _getActiveRound;
  final SubmitVoteUseCase _submitVote;

  PlayNotifier(this._getActiveRound, this._submitVote)
      : super(const PlayState.initial());

  Future<void> fetchRound() async {
    state = const PlayState.loading();
    final result = await _getActiveRound();
    state = result.fold(
      (failure) => PlayState.error(failure.message),
      (round) => round != null ? PlayState.round(round) : const PlayState.noRound(),
    );
  }

  Future<void> vote({required int roundId, required int statementId}) async {
    state = const PlayState.voting();
    final result = await _submitVote(roundId: roundId, statementId: statementId);
    state = result.fold(
      (failure) => PlayState.error(failure.message),
      (voteResult) => PlayState.result(voteResult),
    );
  }

  void reset() => state = const PlayState.initial();
}

final playProvider = StateNotifierProvider<PlayNotifier, PlayState>(
  (ref) => PlayNotifier(
    ref.read(getActiveRoundUseCaseProvider),
    ref.read(submitVoteUseCaseProvider),
  ),
);
