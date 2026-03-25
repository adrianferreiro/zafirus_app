import '../models/document_model.dart';
import 'document_datasource.dart';

class DocumentMockDatasource implements DocumentDatasource {
  @override
  Future<List<DocumentModel>> getDocuments(int employeeId) async {
    await Future.delayed(const Duration(seconds: 1));

    return const [
      DocumentModel(
        id: 1,
        name: 'Recibo de sueldo - Junio 2025',
        type: 'file',
        documentFolderId: 1,
        url: 'https://example.com/docs/recibo_junio_2025.pdf',
        createdAt: '2025-06-30T10:00:00.000Z',
        updatedAt: '2025-06-30T10:00:00.000Z',
        expiresAt: null,
      ),
      DocumentModel(
        id: 2,
        name: 'Recibo de sueldo - Mayo 2025',
        type: 'file',
        documentFolderId: 1,
        url: 'https://example.com/docs/recibo_mayo_2025.pdf',
        createdAt: '2025-05-31T10:00:00.000Z',
        updatedAt: '2025-05-31T10:00:00.000Z',
        expiresAt: null,
      ),
      DocumentModel(
        id: 3,
        name: 'Contrato laboral',
        type: 'file',
        documentFolderId: 2,
        url: 'https://example.com/docs/contrato.pdf',
        createdAt: '2022-03-01T10:00:00.000Z',
        updatedAt: '2022-03-01T10:00:00.000Z',
        expiresAt: null,
      ),
      DocumentModel(
        id: 4,
        name: 'Certificado de capacitación',
        type: 'file',
        documentFolderId: 3,
        url: 'https://example.com/docs/certificado.pdf',
        createdAt: '2024-11-15T10:00:00.000Z',
        updatedAt: '2024-11-15T10:00:00.000Z',
        expiresAt: '2026-11-15T10:00:00.000Z',
      ),
    ];
  }
}
