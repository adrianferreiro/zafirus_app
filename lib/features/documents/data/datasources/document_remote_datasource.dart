import 'package:dio/dio.dart';

import '../../../../core/constants/endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/document_model.dart';
import 'document_datasource.dart';

class DocumentRemoteDatasource implements DocumentDatasource {
  final DioClient _client;

  DocumentRemoteDatasource(this._client);

  @override
  Future<List<DocumentModel>> getDocuments(int employeeId) async {
    try {
      final response = await _client.dio.get(Endpoints.employeeDocuments(employeeId));
      final list = response.data['data'] as List;
      return list
          .map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? 'Error al obtener documentos',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
