import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String pin,
  });

  Future<Either<Failure, UserEntity>> validateToken();

  Future<Either<Failure, void>> logout();
}
