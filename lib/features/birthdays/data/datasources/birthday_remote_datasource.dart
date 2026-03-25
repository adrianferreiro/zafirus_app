import 'package:dio/dio.dart';

import '../../../../core/constants/endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/birthday_model.dart';
import 'birthday_datasource.dart';

class BirthdayRemoteDatasource implements BirthdayDatasource {
  final DioClient _client;

  BirthdayRemoteDatasource(this._client);

  @override
  Future<List<BirthdayModel>> getTodayBirthdays() async {
    try {
      final response = await _client.dio.get(Endpoints.birthdaysToday);
      final list = response.data['data'] as List;
      return list
          .map((e) => BirthdayModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? 'Error al obtener cumpleaños',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
