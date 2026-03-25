import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_entity.freezed.dart';

@freezed
class DocumentEntity with _$DocumentEntity {
  const factory DocumentEntity({
    required int id,
    required String name,
    required String type,
    required int documentFolderId,
    required String url,
    String? createdAt,
    String? updatedAt,
    String? expiresAt,
  }) = _DocumentEntity;
}
