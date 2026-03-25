import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/app_view_state.dart';
import '../../domain/entities/birthday_entity.dart';

part 'birthday_state.freezed.dart';

@freezed
class BirthdaysState with _$BirthdaysState {
  const BirthdaysState._();

  const factory BirthdaysState({
    @Default(AppViewState.idle) AppViewState viewState,
    @Default([]) List<BirthdayEntity> birthdays,
    @Default(null) String? errorMessage,
  }) = _BirthdaysState;

  static BirthdaysState get initialState => const BirthdaysState();
}
