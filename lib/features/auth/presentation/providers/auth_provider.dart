import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/auth_mock_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/validate_token_usecase.dart';

part 'auth_provider.freezed.dart';

// Current user
final currentUserProvider = StateProvider<UserEntity?>((ref) => null);

// DI chain
final authDatasourceProvider = Provider<AuthDatasource>((ref) {
  if (AppConfig.instance.useMock) return AuthMockDatasource();
  return AuthRemoteDatasource(ref.read(dioClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.read(authDatasourceProvider),
    ref.read(secureStorageProvider),
  ),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.read(authRepositoryProvider)),
);

final validateTokenUseCaseProvider = Provider<ValidateTokenUseCase>(
  (ref) => ValidateTokenUseCase(ref.read(authRepositoryProvider)),
);

final logoutUseCaseProvider = Provider<LogoutUseCase>(
  (ref) => LogoutUseCase(ref.read(authRepositoryProvider)),
);

// State
@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.success(UserEntity user) = _Success;
  const factory LoginState.error(String message) = _Error;
}

// Notifier
class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  final Ref _ref;

  LoginNotifier(this._loginUseCase, this._ref) : super(const LoginState.initial());

  Future<void> login({required String username, required String pin}) async {
    state = const LoginState.loading();
    final result = await _loginUseCase(username: username, pin: pin);
    state = result.fold(
      (failure) => LoginState.error(failure.message),
      (user) {
        _ref.read(currentUserProvider.notifier).state = user;
        return LoginState.success(user);
      },
    );
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref.read(loginUseCaseProvider), ref),
);
