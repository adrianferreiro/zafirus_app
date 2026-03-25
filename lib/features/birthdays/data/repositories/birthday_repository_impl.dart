import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/birthday_entity.dart';
import '../../domain/repositories/birthday_repository.dart';
import '../datasources/birthday_datasource.dart';

class BirthdayRepositoryImpl implements BirthdayRepository {
  final BirthdayDatasource _datasource;

  BirthdayRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<BirthdayEntity>>> getTodayBirthdays() async {
    try {
      final response = await _datasource.getTodayBirthdays();
      return Right(response.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado'));
    }
  }
}
