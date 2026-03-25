import '../models/active_round_model.dart';
import '../models/leaderboard_entry_model.dart';
import '../models/vote_result_model.dart';
import 'game_datasource.dart';

class GameMockDatasource implements GameDatasource {
  final bool _hasActiveRound = true;

  @override
  Future<ActiveRoundModel?> getActiveRound() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!_hasActiveRound) return null;

    return const ActiveRoundModel(
      roundId: 1,
      gameId: 10,
      personName: 'María González',
      statements: [
        StatementModel(id: 1, text: 'Viajé a 12 países diferentes'),
        StatementModel(id: 2, text: 'Tengo un cinturón negro en karate'),
        StatementModel(id: 3, text: 'Toqué en una banda de rock en la universidad'),
      ],
    );
  }

  @override
  Future<VoteResultModel> submitVote({
    required int roundId,
    required int statementId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const VoteResultModel(
      message: '¡Respuesta enviada!',
    );
  }

  @override
  Future<List<LeaderboardEntryModel>> getLeaderboard() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return const [
      LeaderboardEntryModel(
        employeeId: 1001,
        fullName: 'Juan Pérez',
        firstName: 'Juan',
        lastName: 'Pérez',
        avatarUrl: null,
        totalPoints: 14,
        gamesPlayed: 5,
        rank: 1,
      ),
      LeaderboardEntryModel(
        employeeId: 1003,
        fullName: 'Ana Martínez',
        firstName: 'Ana',
        lastName: 'Martínez',
        avatarUrl: null,
        totalPoints: 12,
        gamesPlayed: 5,
        rank: 2,
      ),
      LeaderboardEntryModel(
        employeeId: 1002,
        fullName: 'Pedro López',
        firstName: 'Pedro',
        lastName: 'López',
        avatarUrl: null,
        totalPoints: 11,
        gamesPlayed: 4,
        rank: 3,
      ),
      LeaderboardEntryModel(
        employeeId: 1004,
        fullName: 'Carlos Benítez',
        firstName: 'Carlos',
        lastName: 'Benítez',
        avatarUrl: null,
        totalPoints: 10,
        gamesPlayed: 5,
        rank: 4,
      ),
      LeaderboardEntryModel(
        employeeId: 1005,
        fullName: 'Laura Giménez',
        firstName: 'Laura',
        lastName: 'Giménez',
        avatarUrl: null,
        totalPoints: 9,
        gamesPlayed: 4,
        rank: 5,
      ),
      LeaderboardEntryModel(
        employeeId: 1006,
        fullName: 'Diego Romero',
        firstName: 'Diego',
        lastName: 'Romero',
        avatarUrl: null,
        totalPoints: 8,
        gamesPlayed: 5,
        rank: 6,
      ),
      LeaderboardEntryModel(
        employeeId: 1007,
        fullName: 'María González',
        firstName: 'María',
        lastName: 'González',
        avatarUrl: null,
        totalPoints: 7,
        gamesPlayed: 3,
        rank: 7,
      ),
      LeaderboardEntryModel(
        employeeId: 1008,
        fullName: 'Roberto Acosta',
        firstName: 'Roberto',
        lastName: 'Acosta',
        avatarUrl: null,
        totalPoints: 6,
        gamesPlayed: 4,
        rank: 8,
      ),
      LeaderboardEntryModel(
        employeeId: 1009,
        fullName: 'Sofía Villalba',
        firstName: 'Sofía',
        lastName: 'Villalba',
        avatarUrl: null,
        totalPoints: 5,
        gamesPlayed: 3,
        rank: 9,
      ),
      LeaderboardEntryModel(
        employeeId: 1010,
        fullName: 'Fernando Cabrera',
        firstName: 'Fernando',
        lastName: 'Cabrera',
        avatarUrl: null,
        totalPoints: 3,
        gamesPlayed: 2,
        rank: 10,
      ),
    ];
  }
}
