import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/pin_validator.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../providers/change_pin_provider.dart';
import '../providers/change_pin_state.dart';

class ChangePinScreen extends ConsumerStatefulWidget {
  final bool mandatory;

  const ChangePinScreen({super.key, this.mandatory = false});

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(changePinProvider.notifier).changePin(
          currentPin: _currentPinController.text.trim(),
          newPin: _newPinController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePinProvider);

    ref.listen<ChangePinState>(changePinProvider, (_, next) {
      next.maybeWhen(
        success: () {
          AppToast.success(context, message: 'PIN cambiado correctamente');
          ref.read(changePinProvider.notifier).reset();
          if (widget.mandatory) {
            context.go(AppRouter.home);
          } else {
            context.pop();
          }
        },
        error: (message) => AppToast.error(context, message: message),
        orElse: () {},
      );
    });

    return PopScope(
      canPop: !widget.mandatory,
      child: AppScaffold(
        title: 'Cambiar PIN',
        useGradient: true,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.mandatory) ...[
                    Icon(Icons.warning_amber_rounded, size: 40, color: AppColors.accent),
                    const SizedBox(height: 12),
                    Text(
                      'Debés cambiar tu PIN para continuar',
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  TextFormField(
                    controller: _currentPinController,
                    decoration: const InputDecoration(
                      labelText: 'PIN actual',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) =>
                        (v == null || v.length != 6) ? 'Ingresá tu PIN actual de 6 dígitos' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPinController,
                    decoration: const InputDecoration(
                      labelText: 'Nuevo PIN',
                      prefixIcon: Icon(Icons.lock_reset),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) => PinValidator.validate(v),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPinController,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar nuevo PIN',
                      prefixIcon: Icon(Icons.lock_reset),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.length != 6) return 'Confirmá tu nuevo PIN';
                      if (v != _newPinController.text) return 'Los PIN no coinciden';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: state.maybeWhen(
                        loading: () => null,
                        orElse: () => _onSubmit,
                      ),
                      child: state.maybeWhen(
                        loading: () => const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        orElse: () => const Text('Cambiar PIN'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
