import '../../../../core/utils/app_view_state.dart';
import '../../domain/entities/employee_entity.dart';

class EmployeeViewState {
  final AppViewState status;
  final EmployeeEntity? data;
  final String? errorMessage;

  const EmployeeViewState({
    this.status = AppViewState.idle,
    this.data,
    this.errorMessage,
  });

  EmployeeViewState copyWith({
    AppViewState? status,
    EmployeeEntity? data,
    String? errorMessage,
  }) => EmployeeViewState(
        status: status ?? this.status,
        data: data ?? this.data,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
