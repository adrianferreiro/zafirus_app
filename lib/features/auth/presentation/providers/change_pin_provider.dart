import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/change_pin_usecase.dart';
import 'auth_provider.dart';
import 'change_pin_state.dart';

class ChangePinNotifier extends StateNotifier<ChangePinState> {
  final ChangePinUseCase _changePin;
  final Ref _ref;

  ChangePinNotifier(this._changePin, this._ref)
      : super(const ChangePinState.initial());

  Future<void> changePin({
    required String currentPin,
    required String newPin,
  }) async {
    state = const ChangePinState.loading();
    final result = await _changePin(currentPin: currentPin, newPin: newPin);
    state = result.fold(
      (failure) => ChangePinState.error(failure.message),
      (_) {
        final user = _ref.read(currentUserProvider);
        if (user != null) {
          _ref.read(currentUserProvider.notifier).state =
              user.copyWith(mustChangePin: false);
        }
        return const ChangePinState.success();
      },
    );
  }

  void reset() => state = const ChangePinState.initial();
}

final changePinProvider = StateNotifierProvider<ChangePinNotifier, ChangePinState>(
  (ref) => ChangePinNotifier(ref.read(changePinUseCaseProvider), ref),
);
