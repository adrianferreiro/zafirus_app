import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/vote_result_entity.dart';

part 'vote_result_model.freezed.dart';
part 'vote_result_model.g.dart';

@freezed
class VoteResultModel with _$VoteResultModel {
  const factory VoteResultModel({
    required String message,
  }) = _VoteResultModel;

  const VoteResultModel._();

  factory VoteResultModel.fromJson(Map<String, dynamic> json) =>
      _$VoteResultModelFromJson(json);

  VoteResultEntity toEntity() => VoteResultEntity(message: message);
}
