import 'package:flutter/material.dart';

/// Цвета семьи (D17-3): детерминированно из userId.hashCode % 12.
/// Ручной выбор цвета (member_colors) — долг Этапа 21.
const List<Color> kFamilyPalette = [
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

Color familyColorFor(String userId) =>
    kFamilyPalette[userId.hashCode.abs() % kFamilyPalette.length];