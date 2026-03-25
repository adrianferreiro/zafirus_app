import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/document_datasource.dart';
import '../../data/datasources/document_mock_datasource.dart';
import '../../data/datasources/document_remote_datasource.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/usecases/get_documents_usecase.dart';

part 'document_provider.freezed.dart';

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

// State
@freezed
class DocumentsState with _$DocumentsState {
  const factory DocumentsState.initial() = _Initial;
  const factory DocumentsState.loading() = _Loading;
  const factory DocumentsState.loaded(List<DocumentEntity> documents) = _Loaded;
  const factory DocumentsState.error(String message) = _Error;
}

// Notifier
class DocumentsNotifier extends StateNotifier<DocumentsState> {
  final GetDocumentsUseCase _getDocuments;

  DocumentsNotifier(this._getDocuments) : super(const DocumentsState.initial());

  Future<void> load(int employeeId) async {
    state = const DocumentsState.loading();
    final result = await _getDocuments(employeeId);
    state = result.fold(
      (failure) => DocumentsState.error(failure.message),
      (docs) => DocumentsState.loaded(docs),
    );
  }
}

final documentsProvider = StateNotifierProvider<DocumentsNotifier, DocumentsState>(
  (ref) => DocumentsNotifier(ref.read(getDocumentsUseCaseProvider)),
);
