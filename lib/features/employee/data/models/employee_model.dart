import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/employee_entity.dart';

part 'employee_model.freezed.dart';
part 'employee_model.g.dart';

@freezed
class EmployeeModel with _$EmployeeModel {
  const factory EmployeeModel({
    required int id,
    required bool access,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'middle_name') String? middleName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    required String email,
    @JsonKey(name: 'personal_email') String? personalEmail,
    @JsonKey(name: 'date_of_birth') String? dateOfBirth,
    @JsonKey(name: 'hired_on') String? hiredOn,
    @JsonKey(name: 'probation_ends_on') String? probationEndsOn,
    NamedFieldModel? gender,
    NamedFieldModel? position,
    @JsonKey(name: 'job_level') NamedFieldModel? jobLevel,
    NamedFieldModel? location,
    @JsonKey(name: 'employment_type') NamedFieldModel? employmentType,
    NamedFieldModel? division,
    DepartmentModel? department,
    @JsonKey(name: 'reporting_to') PersonRefModel? reportingTo,
    @JsonKey(name: 'direct_reports') @Default([]) List<PersonRefModel> directReports,
    @JsonKey(name: 'termination_effective_on') String? terminationEffectiveOn,
    @JsonKey(name: 'termination_comment') String? terminationComment,
    @JsonKey(name: 'termination_eligible_for_rehire') bool? terminationEligibleForRehire,
    @JsonKey(name: 'termination_type') NamedFieldModel? terminationType,
    @JsonKey(name: 'termination_reason') NamedFieldModel? terminationReason,
    @Default({}) Map<String, dynamic> fields,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _EmployeeModel;

  const EmployeeModel._();

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  EmployeeEntity toEntity() => EmployeeEntity(
        id: id,
        access: access,
        fullName: fullName,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        avatarUrl: avatarUrl,
        email: email,
        personalEmail: personalEmail,
        dateOfBirth: dateOfBirth,
        hiredOn: hiredOn,
        probationEndsOn: probationEndsOn,
        gender: gender?.toEntity(),
        position: position?.toEntity(),
        jobLevel: jobLevel?.toEntity(),
        location: location?.toEntity(),
        employmentType: employmentType?.toEntity(),
        division: division?.toEntity(),
        department: department?.toEntity(),
        reportingTo: reportingTo?.toEntity(),
        directReports: directReports.map((e) => e.toEntity()).toList(),
        terminationEffectiveOn: terminationEffectiveOn,
        terminationComment: terminationComment,
        terminationEligibleForRehire: terminationEligibleForRehire,
        terminationType: terminationType?.toEntity(),
        terminationReason: terminationReason?.toEntity(),
        fields: fields,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

@freezed
class NamedFieldModel with _$NamedFieldModel {
  const factory NamedFieldModel({
    required dynamic id,
    required String name,
  }) = _NamedFieldModel;

  const NamedFieldModel._();

  factory NamedFieldModel.fromJson(Map<String, dynamic> json) =>
      _$NamedFieldModelFromJson(json);

  NamedField toEntity() => NamedField(id: id, name: name);
}

@freezed
class DepartmentModel with _$DepartmentModel {
  const factory DepartmentModel({
    required int id,
    required String name,
    @JsonKey(name: 'parent_id') int? parentId,
    @JsonKey(name: 'manager_id') int? managerId,
    @JsonKey(name: 'department_level_id') int? departmentLevelId,
  }) = _DepartmentModel;

  const DepartmentModel._();

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);

  DepartmentEntity toEntity() => DepartmentEntity(
        id: id,
        name: name,
        parentId: parentId,
        managerId: managerId,
        departmentLevelId: departmentLevelId,
      );
}

@freezed
class PersonRefModel with _$PersonRefModel {
  const factory PersonRefModel({
    required int id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
  }) = _PersonRefModel;

  const PersonRefModel._();

  factory PersonRefModel.fromJson(Map<String, dynamic> json) =>
      _$PersonRefModelFromJson(json);

  PersonRef toEntity() => PersonRef(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
}
