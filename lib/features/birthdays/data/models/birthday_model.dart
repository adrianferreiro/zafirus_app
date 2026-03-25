import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/birthday_entity.dart';

part 'birthday_model.freezed.dart';
part 'birthday_model.g.dart';

@freezed
class BirthdayModel with _$BirthdayModel {
  const factory BirthdayModel({
    required int id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? position,
    String? department,
  }) = _BirthdayModel;

  const BirthdayModel._();

  factory BirthdayModel.fromJson(Map<String, dynamic> json) =>
      _$BirthdayModelFromJson(json);

  BirthdayEntity toEntity() => BirthdayEntity(
        id: id,
        fullName: fullName,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: avatarUrl,
        position: position,
        department: department,
      );
}
