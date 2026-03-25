import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/document_entity.dart';

abstract class DocumentRepository {
  Future<Either<Failure, List<DocumentEntity>>> getDocuments(int employeeId);
}
