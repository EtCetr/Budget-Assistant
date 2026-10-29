import 'dart:convert';
import 'package:drift/drift.dart' show Variable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/providers/database_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';

/// Сырая строка app_settings текущего пользователя (для экранов 6.3.40/6.3.41).
final appSettingsRawProvider = FutureProvider<Map<String, Object?>>((ref) async {
  final uid = ref.watch(currentUserIdProvider);
  final db = ref.watch(appDatabaseProvider);
  await db.customInsert(
    'INSERT OR IGNORE INTO app_settings (id, user_id) VALUES (?, ?)',
    variables: [
      Variable.withString('settings_$uid'),
      Variable.withString(uid),
    ],
  );
  final rows = await db
      .customSelect('SELECT * FROM app_settings WHERE user_id = ?',
          variables: [Variable.withString(uid)])
      .get();
  if (rows.isEmpty) return const {};
  final r = rows.first;
  return {
    'notification_settings_json': r.read<String>('notification_settings_json'),
    'digest_config': r.read<String>('digest_config'),
    'enable_debt_alerts': r.read<bool>('enable_debt_alerts'),
    'enable_deficit_forecast_alerts':
        r.read<bool>('enable_deficit_forecast_alerts'),
    'enable_reminder_notifications':
        r.read<bool>('enable_reminder_notifications'),
    'enable_group_activity_alerts':
        r.read<bool>('enable_group_activity_alerts'),
    'enable_bank_statement_reminder':
        r.read<bool>('enable_bank_statement_reminder'),
    'enable_secrecy_mode': r.read<bool>('enable_secrecy_mode'),
    'enable_year_in_review_alerts':
        r.read<bool>('enable_year_in_review_alerts'),
  };
});

/// Точечное обновление колонки app_settings + инвалидация кэша.
Future<void> saveSettingsColumn(
  WidgetRef ref,
  String column,
  Object value,
) async {
  final uid = ref.read(currentUserIdProvider);
  final db = ref.read(appDatabaseProvider);
  final v = value is bool
      ? Variable.withBool(value)
      : Variable.withString(value as String);
  await db.customUpdate(
    'UPDATE app_settings SET $column = ? WHERE user_id = ?',
    variables: [v, Variable.withString(uid)],
  );
  ref.invalidate(appSettingsRawProvider);
}

Map<String, dynamic> parseJsonMap(Object? raw) {
  if (raw is! String || raw.isEmpty) return {};
  try {
    return jsonDecode(raw) as Map<String, dynamic>;
  } catch (_) {
    return {};
  }
}