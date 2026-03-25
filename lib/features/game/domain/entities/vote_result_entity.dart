import 'package:freezed_annotation/freezed_annotation.dart';

part 'vote_result_entity.freezed.dart';

@freezed
class VoteResultEntity with _$VoteResultEntity {
  const factory VoteResultEntity({
    required String message,
  }) = _VoteResultEntity;
}
