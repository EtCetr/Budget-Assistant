// lib/core/theme/member_color_palette.dart
// Этап 21 (ТЗ 6.3.46, D17-3): единый источник цветов семьи.
// Базовый цвет детерминирован: palette[userId.hashCode % 12] — консистентен
// на всех устройствах без синхронизации. Override — member_colors.custom_color_hex [E2E].
import 'package:flutter/material.dart';

/// 12 цветов WCAG AA (контраст с белыми инициалами).
const List<Color> kMemberColorPalette = <Color>[
  Color(0xFF5E35B1),
  Color(0xFF1E88E5),
  Color(0xFF00ACC1),
  Color(0xFF43A047),
  Color(0xFFC0CA33),
  Color(0xFFFB8C00),
  Color(0xFFD81B60),
  Color(0xFF8E24AA),
  Color(0xFF3949AB),
  Color(0xFF039BE5),
  Color(0xFF00897B),
  Color(0xFFE53935),
];

/// Детерминированный базовый цвет участника (синхронизация не нужна).
Color baseMemberColor(String userId) =>
    kMemberColorPalette[userId.hashCode.abs() % kMemberColorPalette.length];

/// '#RRGGBB' -> Color. null при невалидном формате.
Color? parseMemberColorHex(String? hex) {
  if (hex == null || hex.length != 7 || !hex.startsWith('#')) return null;
  final value = int.tryParse(hex.substring(1), radix: 16);
  if (value == null) return null;
  return Color(0xFF000000 | value);
}