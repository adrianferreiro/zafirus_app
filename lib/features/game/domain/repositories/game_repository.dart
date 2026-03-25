import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/active_round_entity.dart';
import '../entities/leaderboard_entry_entity.dart';
import '../entities/vote_result_entity.dart';

abstract class GameRepository {
  Future<Either<Failure, List<LeaderboardEntryEntity>>> getLeaderboard();
  Future<Either<Failure, ActiveRoundEntity?>> getActiveRound();
  Future<Either<Failure, VoteResultEntity>> submitVote({
    required int roundId,
    required int statementId,
  });
}
