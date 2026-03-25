import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/app_view_state.dart';
import '../../data/datasources/birthday_datasource.dart';
import '../../data/datasources/birthday_mock_datasource.dart';
import '../../data/datasources/birthday_remote_datasource.dart';
import '../../data/repositories/birthday_repository_impl.dart';
import '../../domain/entities/birthday_entity.dart';
import '../../domain/repositories/birthday_repository.dart';
import '../../domain/usecases/get_today_birthdays_usecase.dart';

// DI chain
final birthdayDatasourceProvider = Provider<BirthdayDatasource>((ref) {
  if (AppConfig.instance.useMock) return BirthdayMockDatasource();
  return BirthdayRemoteDatasource(ref.read(dioClientProvider));
});

final birthdayRepositoryProvider = Provider<BirthdayRepository>(
  (ref) => BirthdayRepositoryImpl(ref.read(birthdayDatasourceProvider)),
);

final getTodayBirthdaysUseCaseProvider = Provider<GetTodayBirthdaysUseCase>(
  (ref) => GetTodayBirthdaysUseCase(ref.read(birthdayRepositoryProvider)),
);

class BirthdaysNotifier extends StateNotifier<AppViewState> {
  final GetTodayBirthdaysUseCase _getBirthdays;
  List<BirthdayEntity> data = [];
  String? errorMessage;

  BirthdaysNotifier(this._getBirthdays) : super(AppViewState.idle);

  Future<void> load() async {
    state = AppViewState.loading;
    final result = await _getBirthdays();
    result.fold(
      (failure) {
        errorMessage = failure.message;
        state = AppViewState.error;
      },
      (birthdays) {
        data = birthdays;
        state = birthdays.isEmpty ? AppViewState.empty : AppViewState.success;
      },
    );
  }
}

final birthdaysProvider = StateNotifierProvider<BirthdaysNotifier, AppViewState>(
  (ref) => BirthdaysNotifier(ref.read(getTodayBirthdaysUseCaseProvider)),
);
