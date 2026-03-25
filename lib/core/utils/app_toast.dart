import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  AppToast._();

  static void success(BuildContext context, {required String message}) =>
      _show(context, message: message, type: ToastificationType.success);

  static void error(BuildContext context, {required String message}) =>
      _show(context, message: message, type: ToastificationType.error);

  static void info(BuildContext context, {required String message}) =>
      _show(context, message: message, type: ToastificationType.info);

  static void warning(BuildContext context, {required String message}) =>
      _show(context, message: message, type: ToastificationType.warning);

  static void _show(
    BuildContext context, {
    required String message,
    required ToastificationType type,
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.bottomCenter,
      borderRadius: BorderRadius.circular(12),
      showProgressBar: false,
    );
  }
}
