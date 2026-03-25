import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/birthday_entity.dart';

abstract class BirthdayRepository {
  Future<Either<Failure, List<BirthdayEntity>>> getTodayBirthdays();
}
