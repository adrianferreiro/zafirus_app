import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String token,
    required int employeeId,
    required String name,
    required String lastName,
    required String phone,
    required String email,
    @Default(false) bool mustChangePin,
  }) = _UserEntity;
}
