import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/leaderboard_entry_entity.dart';
import '../repositories/game_repository.dart';

class GetLeaderboardUseCase {
  final GameRepository _repository;

  GetLeaderboardUseCase(this._repository);

  Future<Either<Failure, List<LeaderboardEntryEntity>>> call() =>
      _repository.getLeaderboard();
}
