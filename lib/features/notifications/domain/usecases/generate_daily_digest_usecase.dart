import 'dart:convert';
import 'package:drift/drift.dart' show Variable;
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';
import '../models/notification_type.dart';

class DigestResult {
  const DigestResult({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
  });
  final String id;
  final NotificationType type;
  final String title;
  final String body;
}

/// Дайджесты (ТОМ 5 §4.2): дневной/недельный/месячный в 19:00.
/// Условная генерация (§4.3): нулевые блоки физически исключаются.
/// TODO(25): расширить блоки дайджеста (долги, цели, активность) —
///   сейчас агрегирует только непрочитанные системные пуши периода.
class GenerateDailyDigestUseCase {
  GenerateDailyDigestUseCase(this._db);
  final AppDatabase _db;

  int _epoch(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;

  Future<DigestResult?> maybeGenerate(String userId, DateTime now) async {
    try {
      final cfgRows = await _db.customSelect(
        'SELECT digest_config FROM app_settings WHERE user_id = ?',
        variables: [Variable.withString(userId)],
      ).get();
      var cfg = <String, dynamic>{};
      if (cfgRows.isNotEmpty) {
        try {
          cfg = jsonDecode(cfgRows.first.read<String>('digest_config'))
              as Map<String, dynamic>;
        } catch (_) {}
      }
      final String kind;
      final NotificationType type;
      final DateTime since;
      final String title;
      if (now.day == 1) {
        kind = 'monthly';
        type = NotificationType.monthlyDigest;
        since = DateTime(now.year, now.month - 1, 1);
        title = '📊 Итоги месяца';
      } else if (now.weekday == 7) {
        kind = 'weekly';
        type = NotificationType.weeklyDigest;
        since = now.subtract(const Duration(days: 7));
        title = '📆 Итоги недели';
      } else {
        kind = 'daily';
        type = NotificationType.dailyDigest;
        since = DateTime(now.year, now.month, now.day);
        title = '📅 Итоги дня';
      }
      final kindCfg = (cfg[kind] as Map<String, dynamic>?) ?? const {};
      final on = kindCfg['on'] is bool ? kindCfg['on'] as bool : true;
      final time =
          kindCfg['time'] is String ? kindCfg['time'] as String : '19:00';
      if (!on) return null;
      final hour = int.tryParse(time.split(':').first) ?? 19;
      if (now.hour < hour) return null;
      final key = '${type.dbValue}:${since.year}-${since.month}-${since.day}';

      final blocks = <String>[];
      final aggregatedIds = <String>[];

      final notes = await _db.customSelect(
        'SELECT id, type, title FROM notifications WHERE user_id = ? AND is_read = 0 '
        "AND created_at >= ? AND type IN ('member_activity','recurring_detected',"
        "'goal_milestone','debt_created','debt_closed')",
        variables: [Variable.withString(userId), Variable.withInt(_epoch(since))],
      ).get();
      var members = 0;
      var subs = 0;
      var goals = 0;
      var debts = 0;
      for (final n in notes) {
        aggregatedIds.add(n.read<String>('id'));
        switch (n.read<String>('type')) {
          case 'member_activity':
            members++;
            break;
          case 'recurring_detected':
            subs++;
            break;
          case 'goal_milestone':
            goals++;
            break;
          default:
            debts++;
        }
      }
      if (members > 0) blocks.add('$members новых участника');
      if (subs > 0) blocks.add('найдена подписка');
      if (goals > 0) blocks.add('$goals цели с прогрессом');
      if (debts > 0) blocks.add('$debts события по долгам');

      final exp = await _db.customSelect(
        'SELECT COALESCE(SUM(amount),0) AS s FROM transactions WHERE user_id = ? '
        "AND type = 'expense' AND date >= ? AND savings_goal_id IS NULL "
        "AND is_withdrawal = 0 AND audit_status != 'ignored'",
        variables: [Variable.withString(userId), Variable.withInt(_epoch(since))],
      ).get();
      final expense = exp.first.read<int>('s');
      if (expense > 0) {
        blocks.add('потрачено ${expense ~/ 100} ₽');
      }

      if (blocks.isEmpty) {
        return null;
      }
      if (aggregatedIds.isNotEmpty) {
        final placeholders = aggregatedIds.map((_) => '?').join(',');
        await _db.customUpdate(
          'UPDATE notifications SET is_read = 1 WHERE id IN ($placeholders)',
          variables: [for (final i in aggregatedIds) Variable.withString(i)],
        );
      }
      return DigestResult(
        id: key,
        type: type,
        title: title,
        body: '${blocks.join(', ')}.',
      );
    } catch (e, st) {
      AppLogger.e('Digest generation failed', e, st);
      return null;
    }
  }
}