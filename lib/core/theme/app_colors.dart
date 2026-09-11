import 'package:flutter/material.dart';

/// Токены цветов дизайн-системы.
abstract final class AppColors {
  // Поверхности
  static const Color surfaceBackground = Color(0xFF0F172A);
  static const Color surfaceCard = Color(0xFF1E293B);
  static const Color surfaceElevated = Color(0xFF334155);

  // Текст
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);

  // Смысловые цвета
  static const Color colorExpense = Color(0xFFEF4444);
  static const Color colorIncome = Color(0xFF22C55E);
  static const Color colorTransfer = Color(0xFF3B82F6);
  static const Color colorWarning = Color(0xFFF59E0B);
  static const Color colorPendingSync = Color(0xFF94A3B8);
  static const Color colorFAB = Color(0xFFF97316);

  // Границы
  static const Color borderDivider = Color(0xFF334155);
}
