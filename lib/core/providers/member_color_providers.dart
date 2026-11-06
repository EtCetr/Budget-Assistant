// lib/core/providers/member_color_providers.dart
// Резолвер цветов семьи (ТЗ 6.3.46.2, D21-4/D21-5): override из member_colors,
// затем детерминированный базовый цвет. Реактивно через Drift watch().
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/core/router/app_router.dart' as ar;
import 'package:budget_assistant/core/theme/member_color_palette.dart';

/// Ключ скоупа: '' = личный цвет, иначе space_id.
typedef MemberColorScope = ({String userId, String spaceScope});

/// Все override-цвета скоупа (все участники семьи).
final memberColorOverridesProvider =
    StreamProvider.family<List<MemberColor>, String>((ref, spaceScope) {
  final db = ref.watch(appDatabaseProvider);
  return db.memberColorsDao.watchAllInScope(spaceScope);
});

/// Текущий скоуп цветов (D21-5): security-провайдер -> роутер-провайдер -> ''.
final memberColorSpaceScopeProvider = Provider<String>((ref) {
  return ref.watch(currentSpaceIdProvider) ??
      ref.watch(ar.currentSpaceIdProvider) ??
      '';
});

/// Цвет участника: override в скоупе -> личный override -> базовый.
final memberColorForProvider =
    Provider.family<Color, MemberColorScope>((ref, scope) {
  Color? fromScope(String s) {
    final list =
        ref.watch(memberColorOverridesProvider(s)).value ?? const <MemberColor>[];
    for (final row in list) {
      if (row.userId == scope.userId) {
        return parseMemberColorHex(row.customColorHex);
      }
    }
    return null;
  }

  if (scope.spaceScope.isNotEmpty) {
    final inSpace = fromScope(scope.spaceScope);
    if (inSpace != null) return inSpace;
  }
  final personal = fromScope('');
  if (personal != null) return personal;
  return baseMemberColor(scope.userId);
});

/// Удобный цвет для текущего скоупа (виджеты без явного скоупа).
final memberColorInCurrentSpaceProvider =
    Provider.family<Color, String>((ref, userId) {
  final scope = ref.watch(memberColorSpaceScopeProvider);
  return ref
      .watch(memberColorForProvider((userId: userId, spaceScope: scope)));
});