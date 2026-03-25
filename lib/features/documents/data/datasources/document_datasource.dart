import '../models/document_model.dart';

abstract class DocumentDatasource {
  Future<List<DocumentModel>> getDocuments(int employeeId);
}
