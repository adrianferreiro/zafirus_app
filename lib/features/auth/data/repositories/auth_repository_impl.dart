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

  @override
  Future<Either<Failure, UserEntity>> validateToken() async {
    try {
      final token = await _storage.read(StorageKeys.token);
      if (token == null) return const Left(ServerFailure(message: 'Sin sesión'));

      final response = await _datasource.validateToken(token);
      await _storage.write(StorageKeys.token, response.token);
      return Right(response.toEntity());
    } on ServerException catch (e) {
      await _storage.delete(StorageKeys.token);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      await _storage.delete(StorageKeys.token);
      return Left(ServerFailure(message: 'Error inesperado'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await _storage.read(StorageKeys.token);
      if (token != null) await _datasource.logout(token);
      await _storage.deleteAll();
      return const Right(null);
    } catch (e) {
      await _storage.deleteAll();
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, void>> changePin({
    required String currentPin,
    required String newPin,
  }) async {
    try {
      final token = await _storage.read(StorageKeys.token);
      if (token == null) return const Left(ServerFailure(message: 'Sin sesión'));
      await _datasource.changePin(
        token: token,
        currentPin: currentPin,
        newPin: newPin,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado'));
    }
  }
}
