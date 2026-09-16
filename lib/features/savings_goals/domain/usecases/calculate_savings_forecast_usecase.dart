import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/convert_currency_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';

/// Прогнозная линия: среднее дневное пополнение за последние 30 дней,
/// проекция до конца периода (ТЗ 6.3.18.5). Данных < 7 дней → линии нет.
class CalculateSavingsForecastUseCase {
  CalculateSavingsForecastUseCase({
    required ConvertCurrencyUseCase convertCurrency,
    required Logger logger,
  })  : _convertCurrency = convertCurrency,
        _logger = logger;

  final ConvertCurrencyUseCase _convertCurrency;
  final Logger _logger;

  Future<List<ForecastPoint>> call({
    required List<Transaction> savingsTransactions,
    required List<Account> accounts,
    required String baseCurrency,
    required DateTime now,
    required DateTime projectUntil,
    required int startCumulativeKopecks,
    required DateTime startDate,
  }) async {
    try {
      if (!projectUntil.isAfter(startDate)) return const [];
      final from = now.subtract(const Duration(days: 30));
      var sum = 0;
      final dayKeys = <String>{};
      for (final txn in savingsTransactions) {
        if (txn.isWithdrawal || txn.auditStatus == AuditStatus.ignored) {
          continue;
        }
        if (txn.date.isBefore(from) || txn.date.isAfter(now)) continue;
        String? currency;
        for (final account in accounts) {
          if (account.id == txn.accountId) {
            currency = account.currency;
            break;
          }
        }
        if (currency == null) continue;
        final converted = await _convertCurrency(
          amountKopecks: txn.amount,
          fromCurrency: currency,
          toCurrency: baseCurrency,
          dateUtc: txn.date,
        );
        if (converted == null) continue;
        sum += converted;
        final local = txn.date.toLocal();
        dayKeys.add('${local.year}-${local.month}-${local.day}');
      }
      if (dayKeys.length < 7) return const [];
      final avgPerDay = sum ~/ 30;
      if (avgPerDay <= 0) return const [];
      final days = projectUntil.difference(startDate).inDays;
      if (days <= 0) return const [];
      return [
        ForecastPoint(
          date: startDate,
          forecastedAmountKopecks: startCumulativeKopecks,
        ),
        ForecastPoint(
          date: projectUntil,
          forecastedAmountKopecks: startCumulativeKopecks + avgPerDay * days,
        ),
      ];
    } catch (e, st) {
      _logger.e('CalculateSavingsForecastUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}

class ForecastPoint {
  const ForecastPoint({
    required this.date,
    required this.forecastedAmountKopecks,
  });

  final DateTime date;
  final int forecastedAmountKopecks;
}