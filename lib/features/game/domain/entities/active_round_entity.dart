import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_round_entity.freezed.dart';

@freezed
class ActiveRoundEntity with _$ActiveRoundEntity {
  const factory ActiveRoundEntity({
    required int roundId,
    required int gameId,
    required String personName,
    required List<StatementEntity> statements,
  }) = _ActiveRoundEntity;
}

@freezed
class StatementEntity with _$StatementEntity {
  const factory StatementEntity({
    required int id,
    required String text,
  }) = _StatementEntity;
}
