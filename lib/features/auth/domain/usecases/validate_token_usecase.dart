import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class ValidateTokenUseCase {
  final AuthRepository _repository;

  ValidateTokenUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() => _repository.validateToken();
}
