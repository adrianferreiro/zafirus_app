import '../models/active_round_model.dart';
import '../models/leaderboard_entry_model.dart';
import '../models/vote_result_model.dart';

abstract class GameDatasource {
  Future<List<LeaderboardEntryModel>> getLeaderboard();
  Future<ActiveRoundModel?> getActiveRound();
  Future<VoteResultModel> submitVote({
    required int roundId,
    required int statementId,
  });
}
