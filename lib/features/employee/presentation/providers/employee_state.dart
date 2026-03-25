import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/app_view_state.dart';
import '../../domain/entities/employee_entity.dart';

part 'employee_state.freezed.dart';

@freezed
class EmployeeState with _$EmployeeState {
  const EmployeeState._();

  const factory EmployeeState({
    @Default(AppViewState.idle) AppViewState viewState,
    @Default(null) EmployeeEntity? employee,
    @Default(null) String? errorMessage,
  }) = _EmployeeState;

  static EmployeeState get initialState => const EmployeeState();
}
