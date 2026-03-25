import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_state_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/employee_entity.dart';
import '../providers/employee_provider.dart';

class EmployeeScreen extends ConsumerStatefulWidget {
  const EmployeeScreen({super.key});

  @override
  ConsumerState<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends ConsumerState<EmployeeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        ref.read(employeeProvider.notifier).load(user.employeeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: AppStateHandler(
        state: state.viewState,
        useSkeletonizer: true,
        errorMessage: state.errorMessage,
        onRetry: () {
          final user = ref.read(currentUserProvider);
          if (user != null) ref.read(employeeProvider.notifier).load(user.employeeId);
        },
        onSuccess: (_) => state.employee != null
            ? _EmployeeDetail(employee: state.employee!)
            : _EmployeeDetailPlaceholder(),
      ),
    );
  }
}

class _EmployeeDetail extends StatelessWidget {
  final EmployeeEntity employee;

  const _EmployeeDetail({required this.employee});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initials = '${employee.firstName[0]}${employee.lastName[0]}'
        .toUpperCase();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: CircleAvatar(
            radius: 48,
            backgroundColor: colors.primary,
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: colors.onPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            employee.fullName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        if (employee.position != null)
          Center(
            child: Text(
              employee.position!.name,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.onPrimaryMuted),
            ),
          ),
        const SizedBox(height: 24),
        _Section(
          title: 'Información Personal',
          children: [
            _InfoTile(icon: Icons.email, label: 'Email', value: employee.email),
            if (employee.personalEmail != null)
              _InfoTile(
                icon: Icons.alternate_email,
                label: 'Email personal',
                value: employee.personalEmail!,
              ),
            if (employee.dateOfBirth != null)
              _InfoTile(
                icon: Icons.cake,
                label: 'Fecha de nacimiento',
                value: employee.dateOfBirth!,
              ),
            if (employee.gender != null)
              _InfoTile(
                icon: Icons.person,
                label: 'Género',
                value: employee.gender!.name,
              ),
          ],
        ),
        _Section(
          title: 'Información Laboral',
          children: [
            if (employee.department != null)
              _InfoTile(
                icon: Icons.business,
                label: 'Departamento',
                value: employee.department!.name,
              ),
            if (employee.division != null)
              _InfoTile(
                icon: Icons.account_tree,
                label: 'División',
                value: employee.division!.name,
              ),
            if (employee.jobLevel != null)
              _InfoTile(
                icon: Icons.trending_up,
                label: 'Nivel',
                value: employee.jobLevel!.name,
              ),
            if (employee.employmentType != null)
              _InfoTile(
                icon: Icons.work,
                label: 'Tipo de empleo',
                value: employee.employmentType!.name,
              ),
            if (employee.location != null)
              _InfoTile(
                icon: Icons.location_on,
                label: 'Ubicación',
                value: employee.location!.name,
              ),
            if (employee.hiredOn != null)
              _InfoTile(
                icon: Icons.calendar_today,
                label: 'Fecha de ingreso',
                value: employee.hiredOn!,
              ),
          ],
        ),
        if (employee.reportingTo != null)
          _Section(
            title: 'Reporta a',
            children: [
              _InfoTile(
                icon: Icons.supervisor_account,
                label:
                    '${employee.reportingTo!.firstName} ${employee.reportingTo!.lastName}',
                value: employee.reportingTo!.email,
              ),
            ],
          ),
        if (employee.directReports.isNotEmpty)
          _Section(
            title: 'Reportes directos',
            children: [
              for (final report in employee.directReports)
                _InfoTile(
                  icon: Icons.person_outline,
                  label: '${report.firstName} ${report.lastName}',
                  value: report.email,
                ),
            ],
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20),
      title: Text(
        label,
        style: TextStyle(color: AppColors.onPrimaryMuted, fontSize: 12),
      ),
      subtitle: Text(
        value,
        style: TextStyle(color: AppColors.onPrimary, fontSize: 14),
      ),
    );
  }
}

class _EmployeeDetailPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Center(child: CircleAvatar(radius: 48)),
        const SizedBox(height: 12),
        Center(child: Container(height: 24, width: 180, color: Colors.white)),
        const SizedBox(height: 4),
        Center(child: Container(height: 16, width: 120, color: Colors.white)),
        const SizedBox(height: 24),
        ...List.generate(
          6,
          (_) => const ListTile(
            leading: Icon(Icons.circle, size: 20),
            title: Text('Placeholder label'),
            subtitle: Text('Placeholder value here'),
          ),
        ),
      ],
    );
  }
}
