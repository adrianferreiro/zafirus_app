import '../../../../core/utils/app_view_state.dart';
import '../../domain/entities/document_entity.dart';

class DocumentsViewState {
  final AppViewState status;
  final List<DocumentEntity> data;
  final String? errorMessage;

  const DocumentsViewState({
    this.status = AppViewState.idle,
    this.data = const [],
    this.errorMessage,
  });

  DocumentsViewState copyWith({
    AppViewState? status,
    List<DocumentEntity>? data,
    String? errorMessage,
  }) => DocumentsViewState(
        status: status ?? this.status,
        data: data ?? this.data,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
