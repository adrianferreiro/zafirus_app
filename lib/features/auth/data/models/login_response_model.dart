import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

@freezed
class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    required String token,
    @JsonKey(name: 'employee_id') required int employeeId,
    required String name,
    @JsonKey(name: 'last_name') required String lastName,
    required String phone,
    required String email,
  }) = _LoginResponseModel;

  const LoginResponseModel._();

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  UserEntity toEntity() => UserEntity(
        token: token,
        employeeId: employeeId,
        name: name,
        lastName: lastName,
        phone: phone,
        email: email,
      );
}
