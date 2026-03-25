import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/document_entity.dart';

part 'document_model.freezed.dart';
part 'document_model.g.dart';

@freezed
class DocumentModel with _$DocumentModel {
  const factory DocumentModel({
    required int id,
    required String name,
    required String type,
    @JsonKey(name: 'document_folder_id') required int documentFolderId,
    required String url,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'expires_at') String? expiresAt,
  }) = _DocumentModel;

  const DocumentModel._();

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  DocumentEntity toEntity() => DocumentEntity(
        id: id,
        name: name,
        type: type,
        documentFolderId: documentFolderId,
        url: url,
        createdAt: createdAt,
        updatedAt: updatedAt,
        expiresAt: expiresAt,
      );
}
