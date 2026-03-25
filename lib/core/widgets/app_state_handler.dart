import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../theme/app_theme.dart';
import '../utils/app_view_state.dart';

class AppStateHandler extends StatelessWidget {
  const AppStateHandler({
    super.key,
    required this.state,
    required this.onSuccess,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.idleWidget,
    this.errorMessage,
    this.emptyMessage,
    this.useSkeletonizer = false,
    this.onRetry,
  });

  final AppViewState state;
  final bool useSkeletonizer;
  final Widget Function(BuildContext context) onSuccess;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final Widget? idleWidget;
  final String? errorMessage;
  final String? emptyMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case AppViewState.loading:
        if (useSkeletonizer) {
          return Skeletonizer(
            effect: ShimmerEffect(
              baseColor: AppColors.surface,
              highlightColor: AppColors.surfaceLight,
            ),
            child: onSuccess(context),
          );
        }
        return loadingWidget ?? const Center(child: CircularProgressIndicator());
      case AppViewState.error:
        return errorWidget ??
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.onPrimarySubtle),
                  const SizedBox(height: 12),
                  Text(
                    errorMessage ?? 'Ocurrió un error',
                    style: TextStyle(color: AppColors.onPrimaryMuted, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  if (onRetry != null) ...[
                    const SizedBox(height: 16),
                    FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
                  ],
                ],
              ),
            );
      case AppViewState.empty:
        return emptyWidget ??
            Center(
              child: Text(
                emptyMessage ?? 'No hay datos',
                style: TextStyle(color: AppColors.onPrimarySubtle, fontSize: 14),
              ),
            );
      case AppViewState.success:
        return onSuccess(context);
      case AppViewState.idle:
        return idleWidget ?? const SizedBox.shrink();
    }
  }
}
