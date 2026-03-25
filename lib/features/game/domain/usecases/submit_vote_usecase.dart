import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/vote_result_entity.dart';
import '../repositories/game_repository.dart';

class SubmitVoteUseCase {
  final GameRepository _repository;

  SubmitVoteUseCase(this._repository);

  Future<Either<Failure, VoteResultEntity>> call({
    required int roundId,
    required int statementId,
  }) => _repository.submitVote(roundId: roundId, statementId: statementId);
}
