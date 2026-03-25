import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/app_view_state.dart';
import '../../data/datasources/birthday_datasource.dart';
import '../../data/datasources/birthday_mock_datasource.dart';
import '../../data/datasources/birthday_remote_datasource.dart';
import '../../data/repositories/birthday_repository_impl.dart';
import '../../domain/repositories/birthday_repository.dart';
import '../../domain/usecases/get_today_birthdays_usecase.dart';
import 'birthday_state.dart';

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

class BirthdaysNotifier extends StateNotifier<BirthdaysState> {
  final GetTodayBirthdaysUseCase _getBirthdays;

  BirthdaysNotifier(this._getBirthdays) : super(BirthdaysState.initialState);

  Future<void> load() async {
    state = state.copyWith(viewState: AppViewState.loading);
    final result = await _getBirthdays();
    result.fold(
      (failure) => state = state.copyWith(
        viewState: AppViewState.error,
        errorMessage: failure.message,
      ),
      (birthdays) => state = state.copyWith(
        viewState: birthdays.isEmpty ? AppViewState.empty : AppViewState.success,
        birthdays: birthdays,
      ),
    );
  }
}

final birthdaysProvider = StateNotifierProvider<BirthdaysNotifier, BirthdaysState>(
  (ref) => BirthdaysNotifier(ref.read(getTodayBirthdaysUseCaseProvider)),
);
