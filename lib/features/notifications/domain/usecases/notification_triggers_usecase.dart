import 'dart:convert';
import 'package:drift/drift.dart' show Variable;
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';
import '../models/notification_type.dart';

/// Результат сработавшего триггера.
class NotificationTriggerResult {
  const NotificationTriggerResult({
    required this.type,
    required this.title,
    required this.body,
    required this.entityId,
    this.spaceId,
    this.dedupDays = 1,
  });
  final NotificationType type;
  final String title;
  final String body;
  final String entityId;
  final String? spaceId;
  final int dedupDays;
}

/// Оценка всех триггеров пушей (ТОМ 5 §2) из локальной БД.
/// Каждый блок обёрнут в try/catch: падение одного не ломает остальные.
/// TODO(18.7): добавить триггеры импорта (duplicate_receipt, duplicate_detected,
///   transfer_detected, hold_confirmed) — вшиваются прямо в флоу импорта.
/// TODO(19): year_review_ready — появится после таблицы yearly_aggregates.
class NotificationTriggersUseCase {
  NotificationTriggersUseCase(this._db);
  final AppDatabase _db;

  String _rub(int kopecks) {
    final rub = kopecks ~/ 100;
    final s = rub.abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return '${rub < 0 ? '-' : ''}$buf ₽';
  }

  int _epoch(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;

  Future<List<NotificationTriggerResult>> evaluate(
    String userId,
    DateTime now,
  ) async {
    final out = <NotificationTriggerResult>[];
    var globalPercent = 80;
    var globalAmount = 0;
    var limitMode = 'global_percent';
    var secrecyDays = 14;
    var enableSecrecy = true;
    var enableDebts = true;
    var enableDeficit = true;
    var enableReminders = true;
    var enableGroup = true;
    var enableBank = true;
    final perType = <String, dynamic>{};
    try {
      final s = await _db.customSelect(
        'SELECT * FROM app_settings WHERE user_id = ?',
        variables: [Variable.withString(userId)],
      ).get();
      if (s.isNotEmpty) {
        final r = s.first;
        globalPercent = r.read<int>('global_alert_percent');
        globalAmount = r.read<int>('global_alert_amount');
        limitMode = r.read<String>('limit_alert_mode');
        secrecyDays = r.read<int>('secrecy_days_before');
        enableSecrecy = r.read<bool>('enable_secrecy_mode');
        enableDebts = r.read<bool>('enable_debt_alerts');
        enableDeficit = r.read<bool>('enable_deficit_forecast_alerts');
        enableReminders = r.read<bool>('enable_reminder_notifications');
        enableGroup = r.read<bool>('enable_group_activity_alerts');
        enableBank = r.read<bool>('enable_bank_statement_reminder');
        try {
          perType.addAll(jsonDecode(r.read<String>('notification_settings_json'))
              as Map<String, dynamic>);
        } catch (_) {}
      }
    } catch (e) {
      AppLogger.w('triggers: settings read failed: $e');
    }
    bool on(NotificationType t, bool fallback) =>
        t.alwaysOn ? true : (perType[t.dbValue] is bool ? perType[t.dbValue] as bool : fallback);

    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 1).subtract(const Duration(seconds: 1));
    final dayAgo = now.subtract(const Duration(hours: 24));

    var spaces = <Map<String, Object?>>[];
    try {
      final rows = await _db.customSelect(
        'SELECT s.id AS id, s.name AS name, s.monthly_budget_limit AS lim '
        'FROM spaces s JOIN memberships m ON m.space_id = s.id '
        "WHERE m.user_id = ? AND m.status = 'active' AND s.status = 'active'",
        variables: [Variable.withString(userId)],
      ).get();
      spaces = [
        for (final r in rows)
          {
            'id': r.read<String>('id'),
            'name': r.read<String>('name'),
            'lim': r.readNullable<int>('lim'),
          },
      ];
    } catch (e) {
      AppLogger.w('triggers: spaces skipped: $e');
    }

    for (final sp in spaces) {
      try {
        final lim = sp['lim'] as int?;
        if (lim == null || lim <= 0) continue;
        final sid = sp['id'] as String;
        final e = await _db.customSelect(
          'SELECT COALESCE(SUM(amount),0) AS s FROM transactions '
          "WHERE space_id = ? AND type = 'expense' AND date >= ? AND date <= ? "
          'AND savings_goal_id IS NULL AND is_withdrawal = 0 '
          "AND audit_status != 'ignored'",
          variables: [
            Variable.withString(sid),
            Variable.withInt(_epoch(monthStart)),
            Variable.withInt(_epoch(monthEnd)),
          ],
        ).get();
        final spent = e.first.read<int>('s');
        final percent = spent * 100 ~/ lim;
        final key = '$sid:${now.year}-${now.month}';
        if (limitMode != 'global_amount' && percent >= globalPercent && percent < 100 &&
            on(NotificationType.limitGlobalPercent, true)) {
          out.add(NotificationTriggerResult(
            type: NotificationType.limitGlobalPercent,
            title: '⚠️ Потрачено $percent% месячного бюджета',
            body: 'Осталось ${_rub(lim - spent)} до конца месяца.',
            entityId: key,
            spaceId: sid,
            dedupDays: 3,
          ));
        }
        if (limitMode != 'global_percent' && globalAmount > 0 && lim - spent <= globalAmount &&
            on(NotificationType.limitGlobalAmount, true)) {
          out.add(NotificationTriggerResult(
            type: NotificationType.limitGlobalAmount,
            title: '📉 До лимита осталось менее ${_rub(globalAmount)}',
            body: 'Свободных денег в месячном бюджете: ${_rub(lim - spent)}.',
            entityId: key,
            spaceId: sid,
            dedupDays: 3,
          ));
        }
      } catch (e) {
        AppLogger.w('triggers: global limits skipped: $e');
      }
    }

    try {
      final limits = await _db.customSelect(
        'SELECT bl.category_id AS cid, bl.limit_amount AS lim, bl.alert_percent AS ap, '
        'COALESCE(c.name, \'Категория\') AS name FROM budget_limits bl '
        'LEFT JOIN categories c ON c.id = bl.category_id '
        'WHERE bl.user_id = ? AND bl.year = ? AND bl.month = ?',
        variables: [
          Variable.withString(userId),
          Variable.withInt(now.year),
          Variable.withInt(now.month),
        ],
      ).get();
      for (final l in limits) {
        final cid = l.read<String>('cid');
        final lim = l.read<int>('lim');
        if (lim <= 0) continue;
        final spent = await _db.customSelect(
          'SELECT COALESCE(SUM(amount),0) AS s FROM transactions '
          "WHERE custom_category_id = ? AND user_id = ? AND type = 'expense' "
          'AND date >= ? AND date <= ? AND savings_goal_id IS NULL '
          "AND is_withdrawal = 0 AND audit_status != 'ignored'",
          variables: [
            Variable.withString(cid),
            Variable.withString(userId),
            Variable.withInt(_epoch(monthStart)),
            Variable.withInt(_epoch(monthEnd)),
          ],
        ).get();
        final s = spent.first.read<int>('s');
        final p = s * 100 ~/ lim;
        if (p >= l.read<int>('ap') && on(NotificationType.limitIndividual, true)) {
          out.add(NotificationTriggerResult(
            type: NotificationType.limitIndividual,
            title: '🛒 Лимит «${l.read<String>('name')}» почти исчерпан ($p%)',
            body: 'Потрачено ${_rub(s)} из ${_rub(lim)}.',
            entityId: '$cid:${now.year}-${now.month}',
            dedupDays: 3,
          ));
        }
      }
    } catch (e) {
      AppLogger.w('triggers: individual limits skipped: $e');
    }

    if (enableDeficit) {
      try {
        final f = await _db.customSelect(
          'SELECT date, total FROM forecast_cache WHERE category_id IS NULL '
          'AND date >= ? AND date <= ? ORDER BY total ASC LIMIT 1',
          variables: [
            Variable.withInt(_epoch(now)),
            Variable.withInt(_epoch(now.add(const Duration(days: 7)))),
          ],
        ).get();
        if (f.isNotEmpty && f.first.read<int>('total') < 0) {
          final d = f.first.read<DateTime>('date');
          final days = d.difference(now).inDays;
          out.add(NotificationTriggerResult(
            type: NotificationType.deficitForecastWarning,
            title: '🔮 Баланс уйдёт в минус через $days дн',
            body: 'Проверьте прогноз расходов и скорректируйте траты.',
            entityId: '${now.year}-${now.month}-${now.day}',
            dedupDays: 2,
          ));
        }
      } catch (e) {
        AppLogger.w('triggers: deficit forecast skipped: $e');
      }
    }

    if (enableDebts) {
      try {
        final debts = await _db.customSelect(
          'SELECT d.id AS id, d.amount AS amount, d.due_date AS due, '
          'd.resolution_status AS status, d.created_at AS created, d.updated_at AS updated, '
          'd.creditor_id AS creditor, d.debtor_id AS debtor, '
          'COALESCE(cu.display_name, \'внешнему контрагенту\') AS cred_d, '
          'COALESCE(du.display_name, \'внешнему контрагенту\') AS deb_d, '
          'COALESCE(cu.display_name, \'Внешний контрагент\') AS cred_n '
          'FROM debts d LEFT JOIN users cu ON cu.id = d.creditor_id '
          'LEFT JOIN users du ON du.id = d.debtor_id '
          'WHERE d.creditor_id = ? OR d.debtor_id = ?',
          variables: [Variable.withString(userId), Variable.withString(userId)],
        ).get();
        for (final d in debts) {
          final id = d.read<String>('id');
          final isDebtor = d.readNullable<String>('debtor') == userId;
          final other = isDebtor ? d.read<String>('cred_d') : d.read<String>('deb_d');
          final amount = _rub(d.read<int>('amount'));
          final status = d.read<String>('status');
          final created = d.read<DateTime>('created');
          final updated = d.read<DateTime>('updated');
          if (created.isAfter(dayAgo)) {
            out.add(NotificationTriggerResult(
              type: NotificationType.debtCreated,
              title: isDebtor ? '🤝 Вы должны $other $amount' : '🤝 Вам должны $amount',
              body: 'Новая запись о долге создана.',
              entityId: id,
              dedupDays: 30,
            ));
          }
          if (status == 'resolved' && updated.isAfter(dayAgo)) {
            out.add(NotificationTriggerResult(
              type: NotificationType.debtClosed,
              title: '✅ Долг закрыт',
              body: 'Долг на $amount закрыт. Баланс обновлён.',
              entityId: id,
              dedupDays: 30,
            ));
          }
          if (status == 'forgiven' && updated.isAfter(dayAgo) && isDebtor) {
            out.add(NotificationTriggerResult(
              type: NotificationType.debtForgiven,
              title: '🕊️ ${d.read<String>('cred_n')} простил вам долг',
              body: 'Сумма: $amount.',
              entityId: id,
              dedupDays: 30,
            ));
          }
          final due = d.readNullable<DateTime>('due');
          if (status == 'active' && due != null && due.isBefore(now.subtract(const Duration(days: 7)))) {
            final n = now.difference(due).inDays;
            out.add(NotificationTriggerResult(
              type: NotificationType.debtOverdue,
              title: '⏳ Долг просрочен на $n дн',
              body: isDebtor ? 'Вы должны $other $amount.' : 'Долг на $amount не закрыт в срок.',
              entityId: id,
              dedupDays: 7,
            ));
          }
        }
      } catch (e) {
        AppLogger.w('triggers: debts skipped: $e');
      }
    }

    if (enableReminders) {
      try {
        final rems = await _db.customSelect(
          'SELECT id, title, expected_amount AS amount, remind_at AS at, '
          'snooze_history AS snooze FROM reminders '
          'WHERE user_id = ? AND completed_at IS NULL',
          variables: [Variable.withString(userId)],
        ).get();
        for (final r in rems) {
          final id = r.read<String>('id');
          final at = r.readNullable<DateTime>('at');
          if (at != null && at.isBefore(now.add(const Duration(hours: 24))) && at.isAfter(now.subtract(const Duration(hours: 2)))) {
            final amount = r.readNullable<int>('amount');
            out.add(NotificationTriggerResult(
              type: NotificationType.reminderDue,
              title: '🔔 ${r.read<String>('title')}',
              body: amount == null || amount == 0 ? 'Напоминание на сегодня.' : 'Сумма: ${_rub(amount)}.',
              entityId: '$id:${at.year}-${at.month}-${at.day}',
            ));
          }
          final snooze = r.readNullable<String>('snooze');
          if (snooze != null && snooze.isNotEmpty) {
            try {
              final list = jsonDecode(snooze) as List;
              if (list.length >= 3) {
                out.add(NotificationTriggerResult(
                  type: NotificationType.reminderSnoozeWarning,
                  title: '⏸ Напоминание отложено ${list.length} раза',
                  body: 'Выполнить или удалить «${r.read<String>('title')}»?',
                  entityId: '$id:snooze',
                  dedupDays: 7,
                ));
              }
            } catch (_) {}
          }
        }
      } catch (e) {
        AppLogger.w('triggers: reminders skipped: $e');
      }
    }

    try {
      final rec = await _db.customSelect(
        'SELECT merchant_name_normalized AS m, average_amount_bucket AS b, detected_at AS d '
        'FROM recurring_transactions WHERE user_id = ? AND detected_at >= ?',
        variables: [Variable.withString(userId), Variable.withInt(_epoch(dayAgo))],
      ).get();
      for (final r in rec) {
        out.add(NotificationTriggerResult(
          type: NotificationType.recurringDetected,
          title: '🔍 Обнаружена подписка «${r.read<String>('m')}»',
          body: 'Примерно ${_rub(r.read<int>('b'))} в месяц. Добавить как напоминание?',
          entityId: r.read<String>('m'),
          dedupDays: 30,
        ));
      }
    } catch (e) {
      AppLogger.w('triggers: recurring skipped: $e');
    }

    if (enableSecrecy) {
      try {
        final target = DateTime(now.year, now.month, now.day).add(Duration(days: secrecyDays));
        final hol = await _db.customSelect(
          'SELECT name FROM holidays WHERE date >= ? AND date < ?',
          variables: [
            Variable.withInt(_epoch(target)),
            Variable.withInt(_epoch(target.add(const Duration(days: 1)))),
          ],
        ).get();
        for (final h in hol) {
          out.add(NotificationTriggerResult(
            type: NotificationType.holidaySecrecyStart,
            title: '🎁 Режим секретности активирован',
            body: '«${h.read<String>('name')}»: траты-подарки скрыты до ${target.day}.${target.month.toString().padLeft(2, '0')}.',
            entityId: '${h.read<String>('name')}:${target.year}',
            dedupDays: 300,
          ));
        }
      } catch (e) {
        AppLogger.w('triggers: holidays skipped: $e');
      }
    }

    if (enableSecrecy) {
      try {
        final big = await _db.customSelect(
          'SELECT id, amount, COALESCE(merchant_name, \'Покупка\') AS m FROM transactions '
          'WHERE user_id = ? AND is_large_expense = 1 AND is_hidden_by_calendar = 0 '
          'AND created_at >= ?',
          variables: [Variable.withString(userId), Variable.withInt(_epoch(dayAgo))],
        ).get();
        for (final t in big) {
          out.add(NotificationTriggerResult(
            type: NotificationType.giftPurchaseAlert,
            title: '🤫 Крупная покупка ${_rub(t.read<int>('amount'))}',
            body: '«${t.read<String>('m')}». Засекретить как подарок?',
            entityId: t.read<String>('id'),
            dedupDays: 30,
          ));
        }
      } catch (e) {
        AppLogger.w('triggers: gift skipped: $e');
      }
    }

    try {
      final goals = await _db.customSelect(
        'SELECT id, name, target_amount AS target, current_amount AS cur, deadline AS dl '
        "FROM savings_goals WHERE user_id = ? AND status = 'active' AND is_archived = 0",
        variables: [Variable.withString(userId)],
      ).get();
      for (final g in goals) {
        final id = g.read<String>('id');
        final target = g.read<int>('target');
        final cur = g.read<int>('cur');
        if (target > 0) {
          final p = cur * 100 ~/ target;
          for (final th in const [50, 75, 90]) {
            if (p >= th) {
              out.add(NotificationTriggerResult(
                type: NotificationType.goalMilestone,
                title: '🚀 Цель «${g.read<String>('name')}» достигнута на $th%',
                body: 'Осталось накопить ${_rub(target - cur)}.',
                entityId: '$id:$th',
                dedupDays: 300,
              ));
            }
          }
        }
        final dl = g.readNullable<DateTime>('dl');
        if (dl != null && dl.isAfter(now) && dl.isBefore(now.add(const Duration(days: 7))) && cur < target) {
          out.add(NotificationTriggerResult(
            type: NotificationType.goalDeadlineApproaching,
            title: '⏳ Дедлайн «${g.read<String>('name')}» через неделю',
            body: 'Успеем? Не хватает ${_rub(target - cur)}.',
            entityId: '$id:${dl.year}-${dl.month}',
            dedupDays: 7,
          ));
        }
      }
    } catch (e) {
      AppLogger.w('triggers: goals skipped: $e');
    }

    if (enableGroup) {
      for (final sp in spaces) {
        final sid = sp['id'] as String;
        try {
          final admin = await _db.customSelect(
            'SELECT m.user_id AS uid, m.last_active_at AS la, COALESCE(u.display_name, \'Админ\') AS n '
            'FROM memberships m LEFT JOIN users u ON u.id = m.user_id '
            "WHERE m.space_id = ? AND m.role = 'admin' AND m.status = 'active' LIMIT 1",
            variables: [Variable.withString(sid)],
          ).get();
          if (admin.isNotEmpty) {
            final a = admin.first;
            final la = a.readNullable<DateTime>('la');
            final adminId = a.read<String>('uid');
            if (la != null && adminId != userId && now.difference(la).inDays >= 14) {
              out.add(NotificationTriggerResult(
                type: NotificationType.adminHeartbeatWarning,
                title: '⚠️ Админ ${a.read<String>('n')} не заходил ${now.difference(la).inDays} дн',
                body: 'Риск блокировки настроек пространства.',
                entityId: '$sid:${now.year}-${now.month}',
                spaceId: sid,
                dedupDays: 14,
              ));
            }
          }
          final joins = await _db.customSelect(
            'SELECT m.user_id AS uid, m.joined_at AS j, m.left_at AS l, '
            'COALESCE(u.display_name, \'Участник\') AS n FROM memberships m '
            'LEFT JOIN users u ON u.id = m.user_id '
            'WHERE m.space_id = ? AND m.user_id != ? AND (m.joined_at >= ? OR m.left_at >= ?)',
            variables: [
              Variable.withString(sid),
              Variable.withString(userId),
              Variable.withInt(_epoch(dayAgo)),
              Variable.withInt(_epoch(dayAgo)),
            ],
          ).get();
          for (final j in joins) {
            final left = j.readNullable<DateTime>('l');
            out.add(NotificationTriggerResult(
              type: NotificationType.memberActivity,
              title: left == null ? '👥 ${j.read<String>('n')} присоединился' : '👥 ${j.read<String>('n')} покинул группу',
              body: sp['name'] as String,
              entityId: '${j.read<String>('uid')}:${left == null ? 'join' : 'left'}',
              spaceId: sid,
              dedupDays: 30,
            ));
          }
        } catch (e) {
          AppLogger.w('triggers: group activity skipped: $e');
        }
      }
    }

    try {
      final conf = await _db.customSelect(
        'SELECT id, entity_type AS t FROM sync_conflicts WHERE resolved_at IS NULL',
      ).get();
      for (final c in conf) {
        out.add(NotificationTriggerResult(
          type: NotificationType.syncConflictManual,
          title: '🔀 Конфликт данных «${c.read<String>('t')}»',
          body: 'Требуется ручной выбор: локальная или серверная версия.',
          entityId: c.read<String>('id'),
          dedupDays: 7,
        ));
      }
    } catch (e) {
      AppLogger.w('triggers: sync conflicts skipped: $e');
    }

    try {
      final recs = await _db.customSelect(
        "SELECT id FROM receipts WHERE status = 'draft' AND created_at <= ?",
        variables: [Variable.withInt(_epoch(dayAgo))],
      ).get();
      for (final r in recs) {
        out.add(NotificationTriggerResult(
          type: NotificationType.unmatchedReceipt,
          title: '🧾 Чек не привязан к операции',
          body: 'Чек в черновиках больше суток. Прикрепить?',
          entityId: r.read<String>('id'),
          dedupDays: 3,
        ));
      }
    } catch (e) {
      AppLogger.w('triggers: receipts skipped: $e');
    }

    if (enableBank && now.day == 25) {
      try {
        final imp = await _db.customSelect(
          'SELECT COUNT(*) AS c FROM import_drafts WHERE created_at >= ?',
          variables: [Variable.withInt(_epoch(monthStart))],
        ).get();
        if (imp.first.read<int>('c') == 0) {
          out.add(NotificationTriggerResult(
            type: NotificationType.bankStatementReminder,
            title: '📥 Пора загрузить выписку за ${now.month}. месяц',
            body: 'Импорт обновит баланс и найдёт переводы.',
            entityId: '${now.year}-${now.month}',
            dedupDays: 29,
          ));
        }
      } catch (e) {
        AppLogger.w('triggers: bank reminder skipped: $e');
      }
    }

    // TODO(19): year_review_ready — появится после yearly_aggregates
    return out;
  }
}