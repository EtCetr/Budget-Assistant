import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../models/year_in_review_data.dart';
import '../repositories/yearly_aggregates_repository.dart';

/// Аргументы фонового расчёта (передаются в isolate, всё примитивы).
class _YearAggArgs {
  const _YearAggArgs({
    required this.path,
    required this.userId,
    required this.spaceId,
    required this.year,
    required this.baseCurrency,
  });

  final String path;
  final String userId;
  final String? spaceId;
  final int year;
  final String baseCurrency;
}

/// Фоновый пересчёт годовых итогов в isolate (6.3.37.4): тяжёлая агрегация
/// не блокирует UI. Результат — готовый JSON в yearly_aggregates.
class RecalculateYearlyAggregatesUseCase {
  RecalculateYearlyAggregatesUseCase({
    required YearlyAggregatesRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final YearlyAggregatesRepository _repository;
  final Logger _logger;

  Future<YearInReviewData?> call({
    required String userId,
    required int year,
    required String baseCurrency,
    String? spaceId,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = p.join(dir.path, 'budget_assistant.sqlite');
      final json = await compute(
        _aggregateInIsolate,
        _YearAggArgs(
          path: path,
          userId: userId,
          spaceId: spaceId,
          year: year,
          baseCurrency: baseCurrency,
        ),
      );
      final data =
          YearInReviewData.fromJson(jsonDecode(json) as Map<String, dynamic>);
      await _repository.upsert(
        userId: userId,
        spaceId: spaceId,
        year: year,
        dataJson: json,
      );
      return data;
    } catch (e, st) {
      _logger.e('RecalculateYearlyAggregates failed',
          error: e, stackTrace: st);
      rethrow;
    }
  }
}

/// Сам расчёт. Открывает отдельное соединение с БД внутри isolate
/// (прецедент Этапа 14: запись в БД из фонового isolate через FFI).
Future<String> _aggregateInIsolate(_YearAggArgs args) async {
  final db = AppDatabase.forBackground(
    NativeDatabase.createInBackground(File(args.path)),
  );
  try {
    final yearStart = DateTime.utc(args.year, 1, 1);
    final yearEnd = DateTime.utc(args.year + 1, 1, 1);
    final prevStart = DateTime.utc(args.year - 1, 1, 1);
    final isPersonal = args.spaceId == null;
    final scopeSql =
        isPersonal ? '(t.space_id IS NULL AND t.user_id = ?)' : '(t.space_id = ?)';
    final scopeVars = isPersonal
        ? <Variable>[Variable.withString(args.userId)]
        : <Variable>[Variable.withString(args.spaceId!)];

    // ── Транзакции за год и за прошлый год (для роста дохода) ──
    final txSql = '''
      SELECT t.type AS type, t.user_id AS uid, t.amount AS amount,
             COALESCE(t.original_currency, a.currency) AS cur,
             (SELECT r.rate FROM exchange_rates r
               WHERE r.from_currency = COALESCE(t.original_currency, a.currency)
                 AND r.to_currency = ?
                 AND r.date <= t.date
               ORDER BY r.date DESC LIMIT 1) AS rate,
             t.date AS date, t.custom_category_id AS category_id,
             t.merchant_name AS merchant, t.is_withdrawal AS is_withdrawal,
             t.savings_goal_id AS goal_id, t.is_split AS is_split,
             t.audit_status AS audit_status,
             t.is_hidden_by_calendar AS hidden,
             t.account_id AS account_id,
             t.linked_account_id AS linked_account_id
      FROM transactions t
      JOIN accounts a ON a.id = t.account_id
      WHERE $scopeSql AND t.date >= ? AND t.date < ?
    ''';
    final rows = await db.customSelect(
      txSql,
      variables: [
        Variable.withString(args.baseCurrency),
        ...scopeVars,
        Variable.withDateTime(prevStart),
        Variable.withDateTime(yearEnd),
      ],
    ).get();

    // ── Сплиты (родитель с is_split=1 исключается из итогов) ──
    final splitRows = await db.customSelect(
      '''
      SELECT s.amount AS amount, s.category_id AS category_id,
             t.date AS date,
             COALESCE(t.original_currency, a.currency) AS cur,
             (SELECT r.rate FROM exchange_rates r
               WHERE r.from_currency = COALESCE(t.original_currency, a.currency)
                 AND r.to_currency = ?
                 AND r.date <= t.date
               ORDER BY r.date DESC LIMIT 1) AS rate
      FROM transaction_splits s
      JOIN transactions t ON t.id = s.transaction_id
      JOIN accounts a ON a.id = t.account_id
      WHERE $scopeSql AND t.type = 'expense' AND t.date >= ? AND t.date < ?
      ''',
      variables: [
        Variable.withString(args.baseCurrency),
        ...scopeVars,
        Variable.withDateTime(yearStart),
        Variable.withDateTime(yearEnd),
      ],
    ).get();

    // ── Цели, категории, кэшбэк, счета, регулярки ──
    final goalScope = isPersonal ? 'space_id IS NULL' : "space_id = '${args.spaceId}'";
    final goalRows = await db.customSelect(
      'SELECT status, completed_at, created_at FROM savings_goals '
      'WHERE user_id = ? AND $goalScope',
      variables: [Variable.withString(args.userId)],
    ).get();
    final catRows = await db.customSelect(
      'SELECT id, name, color_hex, icon_emoji FROM categories',
    ).get();
    final matrixRows = await db.customSelect(
      "SELECT category_id, category_name, percent_bps, created_at, expires_at "
      "FROM cashback_matrix WHERE status = 'approved'",
    ).get();
    final accountScope = isPersonal
        ? 'user_id = ? AND space_id IS NULL'
        : 'space_id = ?';
    final accountRows = await db.customSelect(
      'SELECT id, account_type FROM accounts WHERE $accountScope',
      variables: isPersonal
          ? [Variable.withString(args.userId)]
          : [Variable.withString(args.spaceId!)],
    ).get();
    final recRows = await db.customSelect(
      "SELECT merchant_name FROM recurring_transactions "
      "WHERE user_id = ? AND status = 'active'",
      variables: [Variable.withString(args.userId)],
    ).get();
    final firstRow = await db.customSelect(
      'SELECT MIN(date) AS d FROM transactions WHERE user_id = ?',
      variables: [Variable.withString(args.userId)],
    ).get();

    // ══ Агрегация в памяти (данные за год уже отфильтрованы датой) ══
    var stale = false;
    int conv(int amount, String cur, double? rate) {
      if (cur == args.baseCurrency) return amount;
      if (rate == null) {
        stale = true;
        return amount; // без конвертации + флаг (поведение Этапа 12)
      }
      return (amount * rate).round();
    }

    var income = 0;
    var expense = 0;
    var prevIncome = 0;
    var totalSaved = 0;
    var netInvested = 0;
    var familyMy = 0;
    var familySecret = 0;
    var txCount = 0;
    final monthly = <int, int>{};
    final daily = <String, int>{};
    final byCategory = <String, int>{};
    final netByCategory = <String, int>{};
    final catName = <String, String>{};
    final catColor = <String, String?>{};
    final catEmoji = <String, String?>{};
    final merchantTotals = <String, int>{};
    final investIds = <String>{};

    for (final c in catRows) {
      final id = c.read<String>('id');
      catName[id] = c.read<String>('name');
      catColor[id] = c.readNullable<String>('color_hex');
      catEmoji[id] = c.readNullable<String>('icon_emoji');
    }
    for (final a in accountRows) {
      if (a.read<String>('account_type') == 'investment_broker') {
        investIds.add(a.read<String>('id'));
      }
    }

    void addExpense(int amt, DateTime date, String? categoryId) {
      expense += amt;
      monthly[date.month] = (monthly[date.month] ?? 0) + amt;
      final dayKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      daily[dayKey] = (daily[dayKey] ?? 0) + amt;
      final key = categoryId ?? '__none__';
      byCategory[key] = (byCategory[key] ?? 0) + amt;
      netByCategory[key] = (netByCategory[key] ?? 0) + amt;
    }

    for (final r in rows) {
      final type = r.read<String>('type');
      final date = r.read<DateTime>('date');
      final inYear = !date.isBefore(yearStart) && date.isBefore(yearEnd);
      final amt = conv(
        r.read<int>('amount'),
        r.read<String>('cur'),
        r.readNullable<double>('rate'),
      );
      final status = r.read<String>('audit_status');
      final goalId = r.readNullable<String>('goal_id');
      final isWithdrawal = r.read<bool>('is_withdrawal');
      final isSplit = r.read<bool>('is_split');
      final hidden = r.read<bool>('hidden');
      final categoryId = r.readNullable<String>('category_id');

      if (type == 'income' && !isWithdrawal && status != 'ignored') {
        if (inYear && goalId == null) {
          income += amt;
          txCount++;
          netByCategory[categoryId ?? '__none__'] =
              (netByCategory[categoryId ?? '__none__'] ?? 0) - amt;
        }
        if (!inYear) prevIncome += amt;
      } else if (type == 'expense' && status != 'ignored' && !isSplit) {
        if (inYear) {
          if (goalId != null) {
            if (!isWithdrawal) totalSaved += amt;
            continue;
          }
          if (!isPersonal && hidden) {
            // Секретные траты в семье: только общей строкой (6.3.37.8).
            if (r.read<String>('uid') == args.userId) familySecret += amt;
            continue;
          }
          addExpense(amt, date, categoryId);
          txCount++;
          if (!isPersonal && r.read<String>('uid') == args.userId) {
            familyMy += amt;
          }
          final merchant = r.readNullable<String>('merchant');
          if (merchant != null && merchant.trim().isNotEmpty) {
            final key = merchant.trim().toLowerCase();
            merchantTotals[key] = (merchantTotals[key] ?? 0) + amt;
          }
        }
      } else if (type == 'transfer' && inYear) {
        final acc = r.read<String>('account_id');
        final linked = r.readNullable<String>('linked_account_id');
        if (linked != null && investIds.contains(linked) &&
            !investIds.contains(acc)) {
          netInvested += amt;
        } else if (investIds.contains(acc) &&
            (linked == null || !investIds.contains(linked))) {
          netInvested -= amt;
        }
      }
    }

    for (final s in splitRows) {
      final amt = conv(
        s.read<int>('amount'),
        s.read<String>('cur'),
        s.readNullable<double>('rate'),
      );
      addExpense(amt, s.read<DateTime>('date'),
          s.readNullable<String>('category_id'));
    }

    // Топ-3 категории.
    final totalExpense = expense;
    final topCategories = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = <YearCategoryStat>[];
    for (final e in topCategories.take(3)) {
      final id = e.key;
      top.add(YearCategoryStat(
        name: id == '__none__' ? 'Без категории' : (catName[id] ?? 'Категория'),
        amount: e.value,
        percent: totalExpense > 0 ? (e.value * 100 / totalExpense).round() : 0,
        color: catColor[id],
        emoji: catEmoji[id],
      ));
    }

    // Щедрый месяц/день.
    int? bestMonth;
    if (monthly.isNotEmpty) {
      bestMonth = monthly.entries
          .reduce((a, b) => b.value > a.value ? b : a)
          .key;
    }
    String? bestDay;
    var bestDayAmount = 0;
    if (daily.isNotEmpty) {
      final e = daily.entries.reduce((a, b) => b.value > a.value ? b : a);
      bestDay = e.key;
      bestDayAmount = e.value;
    }

    // Цели.
    var goalsTotal = 0;
    var goalsCompleted = 0;
    for (final g in goalRows) {
      final created = g.read<DateTime>('created_at');
      if (!created.isAfter(yearEnd)) goalsTotal++;
      final completed = g.readNullable<DateTime>('completed_at');
      if (completed != null &&
          !completed.isBefore(yearStart) &&
          completed.isBefore(yearEnd)) {
        goalsCompleted++;
      }
    }

    // Кэшбэк: подтверждённые категории × NET-траты в окне действия.
    var cashbackTotal = 0;
    final cashbackByCat = <String, int>{};
    for (final m in matrixRows) {
      final created = m.read<DateTime>('created_at');
      final expires = m.read<DateTime>('expires_at');
      if (expires.isBefore(yearStart) || created.isAfter(yearEnd)) continue;
      final bps = m.read<int>('percent_bps');
      final cid = m.readNullable<String>('category_id');
      String key;
      String name;
      if (cid != null && netByCategory.containsKey(cid)) {
        key = cid;
        name = catName[cid] ?? m.read<String>('category_name');
      } else {
        // Категория без id: ищем по имени.
        final byName = catName.entries
            .where((e) => e.value == m.read<String>('category_name'))
            .map((e) => e.key)
            .toList();
        key = byName.isNotEmpty ? byName.first : '__none__';
        name = m.read<String>('category_name');
      }
      final net = netByCategory[key] ?? 0;
      if (net <= 0) continue;
      final earned = (net * bps / 10000).round();
      if (earned <= 0) continue;
      cashbackTotal += earned;
      cashbackByCat[name] = (cashbackByCat[name] ?? 0) + earned;
    }
    String? bestCashbackCat;
    final cashbackTop = <YearCategoryStat>[];
    if (cashbackByCat.isNotEmpty) {
      final sorted = cashbackByCat.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      bestCashbackCat = sorted.first.key;
      for (final e in sorted.take(3)) {
        cashbackTop.add(
            YearCategoryStat(name: e.key, amount: e.value, percent: 0));
      }
    }

    // Подписки: траты по мерчантам из активных регулярных платежей.
    var subsTotal = 0;
    String? subsMostExpensive;
    var subsMax = 0;
    final recNames = <String>{};
    for (final r in recRows) {
      recNames.add(r.read<String>('merchant_name').trim().toLowerCase());
    }
    for (final e in merchantTotals.entries) {
      if (!recNames.contains(e.key)) continue;
      subsTotal += e.value;
      if (e.value > subsMax) {
        subsMax = e.value;
        subsMostExpensive = e.key;
      }
    }

    // Семейный бюджет.
    final familyTotal = totalExpense;
    final myPercent =
        familyTotal > 0 ? (familyMy * 100 / familyTotal).round() : 0;

    final savingsRate = income > 0
        ? ((income - expense) * 100 / income).round()
        : 0;
    final growth = prevIncome > 0
        ? ((income - prevIncome) * 100 / prevIncome).round()
        : null;
    final firstMonth = firstRow.isNotEmpty
        ? firstRow.first.readNullable<DateTime>('d')?.month
        : null;

    final data = YearInReviewData(
      year: args.year,
      isFamily: !isPersonal,
      baseCurrency: args.baseCurrency,
      totalIncome: income,
      totalExpense: expense,
      incomeGrowthPercent: growth,
      mostGenerousMonth: bestMonth,
      mostGenerousDay: bestDay,
      mostGenerousDayAmount: bestDayAmount,
      topCategories: top,
      hasStaleRates: stale,
      netInvested: netInvested,
      totalSaved: totalSaved,
      goalsCompleted: goalsCompleted,
      goalsTotal: goalsTotal,
      cashbackTotal: cashbackTotal,
      cashbackBestCategory: bestCashbackCat,
      cashbackTop: cashbackTop,
      familyTotalExpense: familyTotal,
      familyMyPercent: myPercent,
      familySecretTotal: familySecret,
      subscriptionsTotal: subsTotal,
      subscriptionsMostExpensive: subsMostExpensive,
      savingsRate: savingsRate,
      transactionCount: txCount,
      firstBudgetMonth: firstMonth,
    );
    return jsonEncode(data.toJson());
  } finally {
    await db.close();
  }
}