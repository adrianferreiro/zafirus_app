import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_entity.freezed.dart';

@freezed
class EmployeeEntity with _$EmployeeEntity {
  const factory EmployeeEntity({
    required int id,
    required bool access,
    required String fullName,
    required String firstName,
    String? middleName,
    required String lastName,
    String? avatarUrl,
    required String email,
    String? personalEmail,
    String? dateOfBirth,
    String? hiredOn,
    String? probationEndsOn,
    NamedField? gender,
    NamedField? position,
    NamedField? jobLevel,
    NamedField? location,
    NamedField? employmentType,
    NamedField? division,
    DepartmentEntity? department,
    PersonRef? reportingTo,
    @Default([]) List<PersonRef> directReports,
    String? terminationEffectiveOn,
    String? terminationComment,
    bool? terminationEligibleForRehire,
    NamedField? terminationType,
    NamedField? terminationReason,
    @Default({}) Map<String, dynamic> fields,
    String? createdAt,
    String? updatedAt,
  }) = _EmployeeEntity;
}

@freezed
class NamedField with _$NamedField {
  const factory NamedField({
    required dynamic id,
    required String name,
  }) = _NamedField;
}

@freezed
class DepartmentEntity with _$DepartmentEntity {
  const factory DepartmentEntity({
    required int id,
    required String name,
    int? parentId,
    int? managerId,
    int? departmentLevelId,
  }) = _DepartmentEntity;
}

@freezed
class PersonRef with _$PersonRef {
  const factory PersonRef({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
  }) = _PersonRef;
}
