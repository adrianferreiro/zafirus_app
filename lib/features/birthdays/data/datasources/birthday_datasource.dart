import '../models/birthday_model.dart';

abstract class BirthdayDatasource {
  Future<List<BirthdayModel>> getTodayBirthdays();
}
