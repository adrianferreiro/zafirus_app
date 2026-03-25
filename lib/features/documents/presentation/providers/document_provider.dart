import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/app_view_state.dart';
import '../../data/datasources/document_datasource.dart';
import '../../data/datasources/document_mock_datasource.dart';
import '../../data/datasources/document_remote_datasource.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/usecases/get_documents_usecase.dart';

// DI chain
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

class DocumentsNotifier extends StateNotifier<AppViewState> {
  final GetDocumentsUseCase _getDocuments;
  List<DocumentEntity> data = [];
  String? errorMessage;

  DocumentsNotifier(this._getDocuments) : super(AppViewState.idle);

  Future<void> load(int employeeId) async {
    state = AppViewState.loading;
    final result = await _getDocuments(employeeId);
    result.fold(
      (failure) {
        errorMessage = failure.message;
        state = AppViewState.error;
      },
      (docs) {
        data = docs;
        state = docs.isEmpty ? AppViewState.empty : AppViewState.success;
      },
    );
  }
}

final documentsProvider = StateNotifierProvider<DocumentsNotifier, AppViewState>(
  (ref) => DocumentsNotifier(ref.read(getDocumentsUseCaseProvider)),
);
