import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/active_round_entity.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import '../../domain/entities/vote_result_entity.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/game_datasource.dart';

class GameRepositoryImpl implements GameRepository {
  final GameDatasource _datasource;

  GameRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<LeaderboardEntryEntity>>> getLeaderboard() async {
    try {
      final response = await _datasource.getLeaderboard();
      return Right(response.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado'));
    }
  }

  @override
  Future<Either<Failure, ActiveRoundEntity?>> getActiveRound() async {
    try {
      final response = await _datasource.getActiveRound();
      return Right(response?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado'));
    }
  }

  @override
  Future<Either<Failure, VoteResultEntity>> submitVote({
    required int roundId,
    required int statementId,
  }) async {
    try {
      final response = await _datasource.submitVote(
        roundId: roundId,
        statementId: statementId,
      );
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado'));
    }
  }
}
