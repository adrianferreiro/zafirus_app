import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/employee_datasource.dart';
import '../../data/datasources/employee_mock_datasource.dart';
import '../../data/datasources/employee_remote_datasource.dart';
import '../../data/repositories/employee_repository_impl.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import '../../domain/usecases/get_employee_usecase.dart';

part 'employee_provider.freezed.dart';

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

// State
@freezed
class EmployeeState with _$EmployeeState {
  const factory EmployeeState.initial() = _Initial;
  const factory EmployeeState.loading() = _Loading;
  const factory EmployeeState.loaded(EmployeeEntity employee) = _Loaded;
  const factory EmployeeState.error(String message) = _Error;
}

// Notifier
class EmployeeNotifier extends StateNotifier<EmployeeState> {
  final GetEmployeeUseCase _getEmployee;

  EmployeeNotifier(this._getEmployee) : super(const EmployeeState.initial());

  Future<void> load(int employeeId) async {
    state = const EmployeeState.loading();
    final result = await _getEmployee(employeeId);
    state = result.fold(
      (failure) => EmployeeState.error(failure.message),
      (employee) => EmployeeState.loaded(employee),
    );
  }
}

final employeeProvider = StateNotifierProvider<EmployeeNotifier, EmployeeState>(
  (ref) => EmployeeNotifier(ref.read(getEmployeeUseCaseProvider)),
);
