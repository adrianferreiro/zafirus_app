import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/active_round_entity.dart';
import '../repositories/game_repository.dart';

class GetActiveRoundUseCase {
  final GameRepository _repository;

  GetActiveRoundUseCase(this._repository);

  Future<Either<Failure, ActiveRoundEntity?>> call() =>
      _repository.getActiveRound();
}
