import '../../../../core/utils/app_view_state.dart';
import '../../domain/entities/birthday_entity.dart';

class BirthdaysViewState {
  final AppViewState status;
  final List<BirthdayEntity> data;
  final String? errorMessage;

  const BirthdaysViewState({
    this.status = AppViewState.idle,
    this.data = const [],
    this.errorMessage,
  });

  BirthdaysViewState copyWith({
    AppViewState? status,
    List<BirthdayEntity>? data,
    String? errorMessage,
  }) => BirthdaysViewState(
        status: status ?? this.status,
        data: data ?? this.data,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
