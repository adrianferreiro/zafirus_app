import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/app_view_state.dart';
import '../../data/datasources/document_datasource.dart';
import '../../data/datasources/document_mock_datasource.dart';
import '../../data/datasources/document_remote_datasource.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/usecases/get_documents_usecase.dart';
import 'document_state.dart';

final documentDatasourceProvider = Provider<DocumentDatasource>((ref) {
  if (AppConfig.instance.useMock) return DocumentMockDatasource();
  return DocumentRemoteDatasource(ref.read(dioClientProvider));
});

final documentRepositoryProvider = Provider<DocumentRepository>(
  (ref) => DocumentRepositoryImpl(ref.read(documentDatasourceProvider)),
);

final getDocumentsUseCaseProvider = Provider<GetDocumentsUseCase>(
  (ref) => GetDocumentsUseCase(ref.read(documentRepositoryProvider)),
);

class DocumentsNotifier extends StateNotifier<DocumentsState> {
  final GetDocumentsUseCase _getDocuments;

  DocumentsNotifier(this._getDocuments) : super(DocumentsState.initialState);

  Future<void> load(int employeeId) async {
    state = state.copyWith(viewState: AppViewState.loading);
    final result = await _getDocuments(employeeId);
    result.fold(
      (failure) => state = state.copyWith(
        viewState: AppViewState.error,
        errorMessage: failure.message,
      ),
      (docs) => state = state.copyWith(
        viewState: docs.isEmpty ? AppViewState.empty : AppViewState.success,
        documents: docs,
      ),
    );
  }
}

final documentsProvider = StateNotifierProvider<DocumentsNotifier, DocumentsState>(
  (ref) => DocumentsNotifier(ref.read(getDocumentsUseCaseProvider)),
);
