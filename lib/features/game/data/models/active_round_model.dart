import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/active_round_entity.dart';

part 'active_round_model.freezed.dart';
part 'active_round_model.g.dart';

@freezed
class ActiveRoundModel with _$ActiveRoundModel {
  const factory ActiveRoundModel({
    @JsonKey(name: 'round_id') required int roundId,
    @JsonKey(name: 'game_id') required int gameId,
    @JsonKey(name: 'person_name') required String personName,
    required List<StatementModel> statements,
  }) = _ActiveRoundModel;

  const ActiveRoundModel._();

  factory ActiveRoundModel.fromJson(Map<String, dynamic> json) =>
      _$ActiveRoundModelFromJson(json);

  ActiveRoundEntity toEntity() => ActiveRoundEntity(
        roundId: roundId,
        gameId: gameId,
        personName: personName,
        statements: statements.map((s) => s.toEntity()).toList(),
      );
}

@freezed
class StatementModel with _$StatementModel {
  const factory StatementModel({
    required int id,
    required String text,
  }) = _StatementModel;

  const StatementModel._();

  factory StatementModel.fromJson(Map<String, dynamic> json) =>
      _$StatementModelFromJson(json);

  StatementEntity toEntity() => StatementEntity(id: id, text: text);
}
