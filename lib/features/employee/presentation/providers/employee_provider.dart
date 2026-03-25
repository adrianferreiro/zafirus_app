import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/app_view_state.dart';
import '../../data/datasources/employee_datasource.dart';
import '../../data/datasources/employee_mock_datasource.dart';
import '../../data/datasources/employee_remote_datasource.dart';
import '../../data/repositories/employee_repository_impl.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import '../../domain/usecases/get_employee_usecase.dart';

// DI chain
final employeeDatasourceProvider = Provider<EmployeeDatasource>((ref) {
  if (AppConfig.instance.useMock) return EmployeeMockDatasource();
  return EmployeeRemoteDatasource(ref.read(dioClientProvider));
});

final employeeRepositoryProvider = Provider<EmployeeRepository>(
  (ref) => EmployeeRepositoryImpl(ref.read(employeeDatasourceProvider)),
);

final getEmployeeUseCaseProvider = Provider<GetEmployeeUseCase>(
  (ref) => GetEmployeeUseCase(ref.read(employeeRepositoryProvider)),
);

class EmployeeNotifier extends StateNotifier<AppViewState> {
  final GetEmployeeUseCase _getEmployee;
  EmployeeEntity? data;
  String? errorMessage;

  EmployeeNotifier(this._getEmployee) : super(AppViewState.idle);

  Future<void> load(int employeeId) async {
    state = AppViewState.loading;
    final result = await _getEmployee(employeeId);
    result.fold(
      (failure) {
        errorMessage = failure.message;
        state = AppViewState.error;
      },
      (employee) {
        data = employee;
        state = AppViewState.success;
      },
    );
  }
}

final employeeProvider = StateNotifierProvider<EmployeeNotifier, AppViewState>(
  (ref) => EmployeeNotifier(ref.read(getEmployeeUseCaseProvider)),
);
