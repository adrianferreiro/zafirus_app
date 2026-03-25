import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_state_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/document_entity.dart';
import '../providers/document_provider.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        ref.read(documentsProvider.notifier).load(user.employeeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(documentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Documentos')),
      body: AppStateHandler(
        state: state.viewState,
        useSkeletonizer: true,
        errorMessage: state.errorMessage,
        emptyMessage: 'No hay documentos',
        onRetry: () {
          final user = ref.read(currentUserProvider);
          if (user != null) ref.read(documentsProvider.notifier).load(user.employeeId);
        },
        onSuccess: (_) => state.documents.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.documents.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) =>
                    _DocumentTile(document: state.documents[index]),
              )
            : _DocumentsPlaceholder(),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  final DocumentEntity document;

  const _DocumentTile({required this.document});

  IconData get _icon => switch (document.name.toLowerCase()) {
    final n when n.contains('recibo') => Icons.receipt_long,
    final n when n.contains('contrato') => Icons.description,
    final n when n.contains('certificado') => Icons.workspace_premium,
    _ => Icons.insert_drive_file,
  };

  String? get _subtitle {
    if (document.createdAt == null) return null;
    final date = DateTime.tryParse(document.createdAt!);
    if (date == null) return null;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _open() async {
    final uri = Uri.parse(document.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        leading: Icon(_icon, color: colors.primary),
        title: Text(
          document.name,
          style: TextStyle(color: colors.onPrimary, fontSize: 14),
        ),
        subtitle: _subtitle != null
            ? Text(
                _subtitle!,
                style: TextStyle(
                  color: AppColors.onPrimarySubtle,
                  fontSize: 12,
                ),
              )
            : null,
        trailing: Icon(
          Icons.open_in_new,
          size: 18,
          color: AppColors.onPrimarySubtle,
        ),
        onTap: _open,
      ),
    );
  }
}

class _DocumentsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => const Card(
        child: ListTile(
          leading: Icon(Icons.insert_drive_file),
          title: Text('Document name placeholder'),
          subtitle: Text('01/01/2025'),
          trailing: Icon(Icons.open_in_new, size: 18),
        ),
      ),
    );
  }
}
