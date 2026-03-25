import 'package:dio/dio.dart';

import '../../../../core/constants/endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/active_round_model.dart';
import '../models/leaderboard_entry_model.dart';
import '../models/vote_result_model.dart';
import 'game_datasource.dart';

class GameRemoteDatasource implements GameDatasource {
  final DioClient _client;

  GameRemoteDatasource(this._client);

  @override
  Future<List<LeaderboardEntryModel>> getLeaderboard() async {
    try {
      final response = await _client.dio.get(Endpoints.gameLeaderboard);
      final list = response.data['data'] as List;
      return list
          .map((e) => LeaderboardEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? 'Error al obtener ranking',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<ActiveRoundModel?> getActiveRound() async {
    try {
      final response = await _client.dio.get(Endpoints.gameActiveRound);
      if (response.data['data'] == null) return null;
      return ActiveRoundModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? 'Error al obtener ronda',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<VoteResultModel> submitVote({
    required int roundId,
    required int statementId,
  }) async {
    try {
      final response = await _client.dio.post(
        Endpoints.gameVote(roundId),
        data: {'statement_id': statementId},
      );
      return VoteResultModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? 'Error al enviar voto',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
