import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Base
  static const primary = Color(0xFF0D1F35);
  static const primaryLight = Color(0xFF142840);
  static const primaryDark = Color(0xFF0A1628);

  // Accent
  static const accent = Color(0xFF3A7BD5);
  static const accentLight = Color(0xFF5B9BE6);

  // Surface
  static const surface = Color(0xFF1A3050);
  static const surfaceLight = Color(0xFF1E3A5F);

  // Text
  static const onPrimary = Colors.white;
  static const onPrimaryMuted = Colors.white70;
  static const onPrimarySubtle = Colors.white54;
}

class AppTheme {
  AppTheme._();

  static final light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.accentLight,
      onSecondary: AppColors.primary,
      surface: AppColors.surface,
      onSurface: AppColors.onPrimary,
      surfaceContainerHighest: AppColors.surfaceLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.primaryDark,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.onPrimaryMuted,
      textColor: AppColors.onPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      labelStyle: const TextStyle(color: AppColors.onPrimaryMuted),
      prefixIconColor: AppColors.onPrimaryMuted,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.accent,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      contentTextStyle: const TextStyle(color: AppColors.onPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    ),
  );

  static final dark = light;
}
