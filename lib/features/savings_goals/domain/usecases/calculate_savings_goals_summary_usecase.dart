import 'package:logger/logger.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/convert_currency_usecase.dart';
import '../entities/savings_goal.dart';

/// Сводка по активным целям (Stats Summary, ТЗ 6.3.16.4).
///
/// Мультивалютная агрегация через ConvertCurrencyUseCase (цепочка курсов
/// Этапа 10), а не SQL-JOIN: единый фолбэк «последний известный курс».
class CalculateSavingsGoalsSummaryUseCase {
  CalculateSavingsGoalsSummaryUseCase({
    required ConvertCurrencyUseCase convertCurrency,
    required Logger logger,
  })  : _convertCurrency = convertCurrency,
        _logger = logger;

  final ConvertCurrencyUseCase _convertCurrency;
  final Logger _logger;

  Future<SavingsGoalsSummary> call({
    required String baseCurrency,
    required List<SavingsGoal> goals,
  }) async {
    try {
      if (goals.isEmpty) {
        return const SavingsGoalsSummary(
          count: 0,
          totalTargetKopecks: 0,
          totalCurrentKopecks: 0,
          averageProgressPercent: 0,
          hasStaleRates: false,
        );
      }

      var totalTarget = 0;
      var totalCurrent = 0;
      var hasStaleRates = false;
      final now = DateTime.now().toUtc();

      for (final goal in goals) {
        if (goal.currency == baseCurrency) {
          totalTarget += goal.targetAmount;
          totalCurrent += goal.currentAmount;
        } else {
          final targetConverted = await _convertCurrency(
            amountKopecks: goal.targetAmount,
            fromCurrency: goal.currency,
            toCurrency: baseCurrency,
            dateUtc: now,
          );
          final currentConverted = await _convertCurrency(
            amountKopecks: goal.currentAmount,
            fromCurrency: goal.currency,
            toCurrency: baseCurrency,
            dateUtc: now,
          );
          if (targetConverted != null) {
            totalTarget += targetConverted;
          } else {
            hasStaleRates = true;
          }
          if (currentConverted != null) {
            totalCurrent += currentConverted;
          }
        }
      }

      final averageProgress = (goals
                  .map((g) => g.progressPercent)
                  .reduce((a, b) => a + b) /
              goals.length)
          .round();

      return SavingsGoalsSummary(
        count: goals.length,
        totalTargetKopecks: totalTarget,
        totalCurrentKopecks: totalCurrent,
        averageProgressPercent: averageProgress,
        hasStaleRates: hasStaleRates,
      );
    } catch (e, st) {
      _logger.e('CalculateSavingsGoalsSummaryUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}

/// Сводка по активным целям.
class SavingsGoalsSummary {
  const SavingsGoalsSummary({
    required this.count,
    required this.totalTargetKopecks,
    required this.totalCurrentKopecks,
    required this.averageProgressPercent,
    required this.hasStaleRates,
  });

  final int count;
  final int totalTargetKopecks;
  final int totalCurrentKopecks;
  final int averageProgressPercent;
  final bool hasStaleRates;

  int get overallProgressPercent {
    if (totalTargetKopecks == 0) return 0;
    return (totalCurrentKopecks * 100 / totalTargetKopecks).floor().clamp(0, 100);
  }
}