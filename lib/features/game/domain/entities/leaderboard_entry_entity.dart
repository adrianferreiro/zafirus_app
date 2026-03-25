import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_entry_entity.freezed.dart';

@freezed
class LeaderboardEntryEntity with _$LeaderboardEntryEntity {
  const factory LeaderboardEntryEntity({
    required int employeeId,
    required String fullName,
    required String firstName,
    required String lastName,
    String? avatarUrl,
    required int totalPoints,
    required int gamesPlayed,
    required int rank,
  }) = _LeaderboardEntryEntity;
}
