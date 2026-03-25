import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/app_view_state.dart';
import '../../domain/entities/document_entity.dart';

part 'document_state.freezed.dart';

@freezed
class DocumentsState with _$DocumentsState {
  const DocumentsState._();

  const factory DocumentsState({
    @Default(AppViewState.idle) AppViewState viewState,
    @Default([]) List<DocumentEntity> documents,
    @Default(null) String? errorMessage,
  }) = _DocumentsState;

  static DocumentsState get initialState => const DocumentsState();
}
