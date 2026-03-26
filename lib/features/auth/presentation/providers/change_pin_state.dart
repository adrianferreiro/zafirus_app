import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_pin_state.freezed.dart';

@freezed
class ChangePinState with _$ChangePinState {
  const factory ChangePinState.initial() = _Initial;
  const factory ChangePinState.loading() = _Loading;
  const factory ChangePinState.success() = _Success;
  const factory ChangePinState.error(String message) = _Error;
}
