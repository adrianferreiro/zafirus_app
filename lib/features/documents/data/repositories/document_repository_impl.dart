import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/document_datasource.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentDatasource _datasource;

  DocumentRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<DocumentEntity>>> getDocuments(int employeeId) async {
    try {
      final response = await _datasource.getDocuments(employeeId);
      return Right(response.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado'));
    }
  }
}
