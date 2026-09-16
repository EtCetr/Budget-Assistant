import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/convert_currency_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import '../entities/savings_goal.dart';

/// Мультивалютная агрегация для SavingsAnalyticsScreen (ТЗ 6.3.18.4).
/// Конвертация — в Dart через ConvertCurrencyUseCase (согласованное отклонение:
/// не SQL-JOIN), курсы на дату транзакции / на сегодня для целей.
class CalculateSavingsAnalyticsUseCase {
  CalculateSavingsAnalyticsUseCase({
    required ConvertCurrencyUseCase convertCurrency,
    required Logger logger,
  })  : _convertCurrency = convertCurrency,
        _logger = logger;

  final ConvertCurrencyUseCase _convertCurrency;
  final Logger _logger;

  Future<AnalyticsSummary> call({
    required List<SavingsGoal> goals,
    required List<Transaction> savingsTransactions,
    required List<Account> accounts,
    required String baseCurrency,
    required DateTime periodStart,
    required DateTime periodEnd,
    required DateTime prevPeriodStart,
    required DateTime prevPeriodEnd,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      var totalTarget = 0;
      var totalCurrent = 0;
      var targetAtStart = 0;
      var targetAtEnd = 0;
      var stale = false;
      for (final goal in goals) {
        final target = await _convertCurrency(
          amountKopecks: goal.targetAmount,
          fromCurrency: goal.currency,
          toCurrency: baseCurrency,
          dateUtc: now,
        );
        final current = await _convertCurrency(
          amountKopecks: goal.currentAmount,
          fromCurrency: goal.currency,
          toCurrency: baseCurrency,
          dateUtc: now,
        );
        if (target == null || current == null) {
          stale = true;
          continue;
        }
        totalTarget += target;
        totalCurrent += current;
        final created = goal.createdAt.toLocal();
        if (!created.isBefore(periodEnd)) {
          continue;
        }
        if (created.isBefore(periodStart)) {
          targetAtStart += target;
        }
        targetAtEnd += target;
      }
      var contributed = 0;
      var prevContributed = 0;
      for (final txn in savingsTransactions) {
        if (txn.isWithdrawal || txn.auditStatus == AuditStatus.ignored) {
          continue;
        }
        final currency = _txnCurrency(txn, accounts);
        if (currency == null) {
          stale = true;
          continue;
        }
        final converted = await _convertCurrency(
          amountKopecks: txn.amount,
          fromCurrency: currency,
          toCurrency: baseCurrency,
          dateUtc: txn.date,
        );
        if (converted == null) {
          stale = true;
          continue;
        }
        final local = txn.date.toLocal();
        if (_inRange(local, periodStart, periodEnd)) {
          contributed += converted;
        } else if (_inRange(local, prevPeriodStart, prevPeriodEnd)) {
          prevContributed += converted;
        }
      }
      final goalsCreatedInPeriod = goals
          .where((g) => _inRange(g.createdAt.toLocal(), periodStart, periodEnd))
          .length;
      final overall = totalTarget > 0
          ? (totalCurrent * 100 ~/ totalTarget).clamp(0, 100).toInt()
          : 0;
      return AnalyticsSummary(
        activeGoalsCount: goals.where((g) => g.isActive).length,
        completedGoalsCount:
            goals.where((g) => g.status == SavingsGoalStatus.completed).length,
        totalTargetKopecks: totalTarget,
        totalCurrentKopecks: totalCurrent,
        overallProgressPercent: overall,
        contributedInPeriodKopecks: contributed,
        contributionDeltaPercent: prevContributed > 0
            ? ((contributed - prevContributed) * 100 ~/ prevContributed)
            : null,
        goalsCreatedInPeriod: goalsCreatedInPeriod,
        targetDeltaPercent: targetAtStart > 0
            ? ((targetAtEnd - targetAtStart) * 100 ~/ targetAtStart)
            : null,
        hasStaleRates: stale,
      );
    } catch (e, st) {
      _logger.e('CalculateSavingsAnalyticsUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  bool _inRange(DateTime local, DateTime start, DateTime end) =>
      !local.isBefore(DateTime(start.year, start.month, start.day)) &&
      !local.isAfter(end);

  String? _txnCurrency(Transaction txn, List<Account> accounts) {
    for (final account in accounts) {
      if (account.id == txn.accountId) return account.currency;
    }
    return null;
  }
}

class AnalyticsSummary {
  const AnalyticsSummary({
    required this.activeGoalsCount,
    required this.completedGoalsCount,
    required this.totalTargetKopecks,
    required this.totalCurrentKopecks,
    required this.overallProgressPercent,
    required this.contributedInPeriodKopecks,
    required this.contributionDeltaPercent,
    required this.goalsCreatedInPeriod,
    required this.targetDeltaPercent,
    required this.hasStaleRates,
  });

  final int activeGoalsCount;
  final int completedGoalsCount;
  final int totalTargetKopecks;
  final int totalCurrentKopecks;
  final int overallProgressPercent;
  final int contributedInPeriodKopecks;
  final int? contributionDeltaPercent;
  final int goalsCreatedInPeriod;
  final int? targetDeltaPercent;
  final bool hasStaleRates;
}