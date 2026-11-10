import 'package:flutter/material.dart';

/// Токены цветов дизайн-системы.
///
/// Этап 22 (ТЗ 6.10.2): контраст по WCAG AA.
///
/// Важно:
/// - Dark-токены рассчитаны для тёмного фона.
/// - Light-токены рассчитаны для светлого фона.
/// - Нельзя использовать яркие dark semantic colors как текст на светлом фоне.
/// - borderDivider — декоративная линия, не текст и не единственный индикатор
///   важного состояния.
abstract final class AppColors {
  // ===== Dark surfaces =====

  static const Color surfaceBackground = Color(0xFF0F172A);
  static const Color surfaceCard = Color(0xFF1E293B);
  static const Color surfaceElevated = Color(0xFF334155);

  // ===== Dark text =====

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);

  // ===== Dark semantic colors =====

  static const Color colorExpense = Color(0xFFEF4444);
  static const Color colorIncome = Color(0xFF22C55E);
  static const Color colorTransfer = Color(0xFF3B82F6);
  static const Color colorWarning = Color(0xFFF59E0B);
  static const Color colorPendingSync = Color(0xFF94A3B8);
  static const Color colorFAB = Color(0xFFF97316);

  /// Маска приватности для dark mode.
  ///
  /// Было #475569, но оно не проходило UI contrast 3:1 на #0F172A.
  /// #64748B проходит как UI-элемент.
  static const Color colorHiddenMask = Color(0xFF64748B);

  /// Декоративные границы dark mode.
  ///
  /// Контраст ниже 3:1 — не использовать как единственный индикатор состояния,
  /// текста или важной интерактивной границы.
  static const Color borderDivider = Color(0xFF334155);

  // ===== Light surfaces =====

  static const Color lightSurfaceBackground = Color(0xFFF8FAFC);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFE2E8F0);

  // ===== Light text =====

  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);

  // ===== Light semantic colors =====
  //
  // Эти цвета безопаснее для текста и UI на светлом фоне.

  static const Color lightColorExpense = Color(0xFFB91C1C);
  static const Color lightColorIncome = Color(0xFF166534);
  static const Color lightColorTransfer = Color(0xFF1D4ED8);
  static const Color lightColorWarning = Color(0xFF92400E);
  static const Color lightColorPendingSync = Color(0xFF475569);
  static const Color lightColorFAB = Color(0xFFC2410C);
  static const Color lightColorHiddenMask = Color(0xFF64748B);

  /// Декоративные границы light mode.
  static const Color lightBorderDivider = Color(0xFFCBD5E1);
}