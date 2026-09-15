import 'package:logger/logger.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/convert_currency_usecase.dart';
import '../entities/savings_goal.dart';

/// Статистика архива.
///
/// Мультивалютная агрегация через ConvertCurrencyUseCase.
class CalculateArchiveStatsUseCase {
  CalculateArchiveStatsUseCase({
    required ConvertCurrencyUseCase convertCurrency,
    required Logger logger,
  })  : _convertCurrency = convertCurrency,
        _logger = logger;

  final ConvertCurrencyUseCase _convertCurrency;
  final Logger _logger;

  Future<ArchiveStats> call({
    required List<SavingsGoal> goals,
    required String baseCurrency,
  }) async {
    try {
      if (goals.isEmpty) {
        return const ArchiveStats(
          totalSavedKopecks: 0,
          averageProgressPercent: 0,
          hasStaleRates: false,
        );
      }

      var totalSaved = 0;
      var totalProgress = 0.0;
      var hasStaleRates = false;
      final now = DateTime.now().toUtc();

      for (final goal in goals) {
        if (goal.currency == baseCurrency) {
          totalSaved += goal.currentAmount;
        } else {
          final converted = await _convertCurrency(
            amountKopecks: goal.currentAmount,
            fromCurrency: goal.currency,
            toCurrency: baseCurrency,
            dateUtc: now,
          );
          if (converted != null) {
            totalSaved += converted;
          } else {
            hasStaleRates = true;
          }
        }
        if (goal.targetAmount > 0) {
          totalProgress += goal.currentAmount / goal.targetAmount;
        }
      }

      return ArchiveStats(
        totalSavedKopecks: totalSaved,
        averageProgressPercent: (totalProgress / goals.length * 100).round(),
        hasStaleRates: hasStaleRates,
      );
    } catch (e, st) {
      _logger.e('CalculateArchiveStatsUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}

/// Статистика архива.
class ArchiveStats {
  const ArchiveStats({
    required this.totalSavedKopecks,
    required this.averageProgressPercent,
    required this.hasStaleRates,
  });

  final int totalSavedKopecks;
  final int averageProgressPercent;
  final bool hasStaleRates;
}