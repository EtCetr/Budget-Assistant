import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Темы приложения.
///
/// Дизайн-токены (AppColors) — тёмные, поэтому тёмная тема является
/// темой по умолчанию (ThemeMode.dark в app.dart). Светлая тема оставлена
/// для будущего переключателя в настройках (Этап 21).
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2563EB),
        secondary: AppColors.colorFAB,
        surface: Color(0xFFF8FAFC),
        onSurface: Color(0xFF0F172A),
        onSurfaceVariant: Color(0xFF475569),
        surfaceContainerHighest: Color(0xFFE2E8F0),
        outline: Color(0xFFCBD5E1),
        outlineVariant: Color(0xFFE2E8F0),
        error: AppColors.colorExpense,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE2E8F0),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF8FAFC),
        foregroundColor: Color(0xFF0F172A),
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.colorTransfer,
        secondary: AppColors.colorFAB,
        surface: AppColors.surfaceBackground,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textSecondary,
        surfaceContainerHighest: AppColors.surfaceCard,
        outline: AppColors.borderDivider,
        outlineVariant: AppColors.borderDivider,
        error: AppColors.colorExpense,
      ),
      scaffoldBackgroundColor: AppColors.surfaceBackground,
      cardColor: AppColors.surfaceCard,
      dividerColor: AppColors.borderDivider,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
    );
  }
}