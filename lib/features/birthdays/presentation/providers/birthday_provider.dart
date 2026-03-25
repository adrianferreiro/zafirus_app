import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/birthday_datasource.dart';
import '../../data/datasources/birthday_mock_datasource.dart';
import '../../data/datasources/birthday_remote_datasource.dart';
import '../../data/repositories/birthday_repository_impl.dart';
import '../../domain/entities/birthday_entity.dart';
import '../../domain/repositories/birthday_repository.dart';
import '../../domain/usecases/get_today_birthdays_usecase.dart';

part 'birthday_provider.freezed.dart';

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

// State
@freezed
class BirthdaysState with _$BirthdaysState {
  const factory BirthdaysState.initial() = _Initial;
  const factory BirthdaysState.loading() = _Loading;
  const factory BirthdaysState.loaded(List<BirthdayEntity> birthdays) = _Loaded;
  const factory BirthdaysState.error(String message) = _Error;
}

// Notifier
class BirthdaysNotifier extends StateNotifier<BirthdaysState> {
  final GetTodayBirthdaysUseCase _getBirthdays;

  BirthdaysNotifier(this._getBirthdays) : super(const BirthdaysState.initial());

  Future<void> load() async {
    state = const BirthdaysState.loading();
    final result = await _getBirthdays();
    state = result.fold(
      (failure) => BirthdaysState.error(failure.message),
      (birthdays) => BirthdaysState.loaded(birthdays),
    );
  }
}

final birthdaysProvider = StateNotifierProvider<BirthdaysNotifier, BirthdaysState>(
  (ref) => BirthdaysNotifier(ref.read(getTodayBirthdaysUseCaseProvider)),
);
