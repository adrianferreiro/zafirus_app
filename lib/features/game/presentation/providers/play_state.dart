import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/active_round_entity.dart';
import '../../domain/entities/vote_result_entity.dart';

part 'play_state.freezed.dart';

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
