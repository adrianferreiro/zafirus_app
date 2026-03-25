import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/birthday_entity.dart';
import '../repositories/birthday_repository.dart';

class GetTodayBirthdaysUseCase {
  final BirthdayRepository _repository;

  GetTodayBirthdaysUseCase(this._repository);

  Future<Either<Failure, List<BirthdayEntity>>> call() =>
      _repository.getTodayBirthdays();
}
