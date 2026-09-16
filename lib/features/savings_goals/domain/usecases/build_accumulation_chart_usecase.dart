import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/convert_currency_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import '../entities/savings_goal.dart';
import 'calculate_savings_forecast_usecase.dart';

/// График суммарного накопления по всем целям за период (ТЗ 6.3.18.5).
/// Все вычисления строго локально; конвертация по курсу на дату транзакции.
class BuildAccumulationChartUseCase {
  BuildAccumulationChartUseCase({
    required CalculateSavingsForecastUseCase forecast,
    required ConvertCurrencyUseCase convertCurrency,
    required Logger logger,
  })  : _forecast = forecast,
        _convertCurrency = convertCurrency,
        _logger = logger;

  final CalculateSavingsForecastUseCase _forecast;
  final ConvertCurrencyUseCase _convertCurrency;
  final Logger _logger;

  Future<AccumulationChartData> call({
    required List<SavingsGoal> goals,
    required List<Transaction> savingsTransactions,
    required List<Account> accounts,
    required String baseCurrency,
    required DateTime periodStart,
    required DateTime periodEnd,
    required DateTime now,
  }) async {
    try {
      final daySums = <String, int>{};
      var stale = false;
      for (final txn in savingsTransactions) {
        if (txn.isWithdrawal || txn.auditStatus == AuditStatus.ignored) {
          continue;
        }
        final local = txn.date.toLocal();
        if (local.isBefore(DateTime(periodStart.year, periodStart.month, periodStart.day)) ||
            local.isAfter(periodEnd)) {
          continue;
        }
        String? currency;
        for (final account in accounts) {
          if (account.id == txn.accountId) {
            currency = account.currency;
            break;
          }
        }
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
        final key = '${local.year}-${local.month}-${local.day}';
        daySums[key] = (daySums[key] ?? 0) + converted;
      }
      final keys = daySums.keys.toList()..sort();
      final points = <AccumulationPoint>[];
      var cumulative = 0;
      for (final key in keys) {
        cumulative += daySums[key]!;
        final parts = key.split('-');
        points.add(AccumulationPoint(
          date: DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2])),
          cumulativeAmountKopecks: cumulative,
        ));
      }
      var targetLine = 0;
      final nowUtc = DateTime.now().toUtc();
      for (final goal in goals) {
        final target = await _convertCurrency(
          amountKopecks: goal.targetAmount,
          fromCurrency: goal.currency,
          toCurrency: baseCurrency,
          dateUtc: nowUtc,
        );
        if (target == null) {
          stale = true;
          continue;
        }
        targetLine += target;
      }
      var forecast = const <ForecastPoint>[];
      if (points.isNotEmpty) {
        forecast = await _forecast(
          savingsTransactions: savingsTransactions,
          accounts: accounts,
          baseCurrency: baseCurrency,
          now: now,
          projectUntil: periodEnd,
          startCumulativeKopecks: points.last.cumulativeAmountKopecks,
          startDate: points.last.date,
        );
      }
      return AccumulationChartData(
        points: points,
        forecast: forecast,
        targetLineKopecks: targetLine,
        baseCurrency: baseCurrency,
        hasStaleRates: stale,
      );
    } catch (e, st) {
      _logger.e('BuildAccumulationChartUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}

class AccumulationPoint {
  const AccumulationPoint({
    required this.date,
    required this.cumulativeAmountKopecks,
  });

  final DateTime date;
  final int cumulativeAmountKopecks;
}

class AccumulationChartData {
  const AccumulationChartData({
    required this.points,
    required this.forecast,
    required this.targetLineKopecks,
    required this.baseCurrency,
    required this.hasStaleRates,
  });

  final List<AccumulationPoint> points;
  final List<ForecastPoint> forecast;
  final int targetLineKopecks;
  final String baseCurrency;
  final bool hasStaleRates;
}