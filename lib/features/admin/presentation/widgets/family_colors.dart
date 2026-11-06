// lib/features/admin/presentation/widgets/family_colors.dart
// Обратная совместимость (Этапы 17-18): имена kFamilyPalette / familyColorFor
// сохранены, реализация вынесена в core (Этап 21, долг D17-3 закрыт).
import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/member_color_palette.dart';

export 'package:budget_assistant/core/theme/member_color_palette.dart'
    show kMemberColorPalette, parseMemberColorHex;

const List<Color> kFamilyPalette = kMemberColorPalette;

Color familyColorFor(String userId) => baseMemberColor(userId);