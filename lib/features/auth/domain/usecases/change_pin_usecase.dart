import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class ChangePinUseCase {
  final AuthRepository _repository;

  ChangePinUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String currentPin,
    required String newPin,
  }) => _repository.changePin(currentPin: currentPin, newPin: newPin);
}
