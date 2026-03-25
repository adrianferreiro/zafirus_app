import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/leaderboard_entry_entity.dart';

part 'leaderboard_entry_model.freezed.dart';
part 'leaderboard_entry_model.g.dart';

@freezed
class LeaderboardEntryModel with _$LeaderboardEntryModel {
  const factory LeaderboardEntryModel({
    @JsonKey(name: 'employee_id') required int employeeId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'total_points') required int totalPoints,
    @JsonKey(name: 'games_played') required int gamesPlayed,
    required int rank,
  }) = _LeaderboardEntryModel;

  const LeaderboardEntryModel._();

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryModelFromJson(json);

  LeaderboardEntryEntity toEntity() => LeaderboardEntryEntity(
        employeeId: employeeId,
        fullName: fullName,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: avatarUrl,
        totalPoints: totalPoints,
        gamesPlayed: gamesPlayed,
        rank: rank,
      );
}
