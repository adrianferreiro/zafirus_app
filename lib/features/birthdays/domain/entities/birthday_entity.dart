import 'package:freezed_annotation/freezed_annotation.dart';

part 'birthday_entity.freezed.dart';

@freezed
class BirthdayEntity with _$BirthdayEntity {
  const factory BirthdayEntity({
    required int id,
    required String fullName,
    required String firstName,
    required String lastName,
    String? avatarUrl,
    String? position,
    String? department,
  }) = _BirthdayEntity;
}
