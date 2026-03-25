import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/document_entity.dart';
import '../repositories/document_repository.dart';

class GetDocumentsUseCase {
  final DocumentRepository _repository;

  GetDocumentsUseCase(this._repository);

  Future<Either<Failure, List<DocumentEntity>>> call(int employeeId) =>
      _repository.getDocuments(employeeId);
}
