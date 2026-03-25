import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _datasource;
  final SecureStorageService _storage;

  AuthRepositoryImpl(this._datasource, this._storage);

  @override
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String pin,
  }) async {
    try {
      final response = await _datasource.login(username: username, pin: pin);
      await _storage.write(StorageKeys.token, response.token);
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado'));
    }
  }
}
