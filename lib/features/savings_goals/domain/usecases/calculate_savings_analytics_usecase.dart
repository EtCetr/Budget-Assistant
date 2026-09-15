import 'package:logger/logger.dart';
import '../entities/savings_goal.dart';

/// Мультивалютная агрегация для SavingsAnalyticsScreen.
///
/// Упрощённая версия: полная реализация — в микро-коммите 12.7.
class CalculateSavingsAnalyticsUseCase {
  CalculateSavingsAnalyticsUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  Future<AnalyticsSummary> call({
    required List<SavingsGoal> goals,
    required String baseCurrency,
  }) async {
    try {
      // Упрощённая версия: возвращаем базовую статистику
      return AnalyticsSummary(
        activeGoalsCount: goals.where((g) => g.isActive).length,
        completedGoalsCount: goals.where((g) => g.status == 'completed').length,
        totalTargetKopecks: goals.fold(0, (sum, g) => sum + g.targetAmount),
        totalCurrentKopecks: goals.fold(0, (sum, g) => sum + g.currentAmount),
      );
    } catch (e, st) {
      _logger.e('CalculateSavingsAnalyticsUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}

class AnalyticsSummary {
  const AnalyticsSummary({
    required this.activeGoalsCount,
    required this.completedGoalsCount,
    required this.totalTargetKopecks,
    required this.totalCurrentKopecks,
  });

  final int activeGoalsCount;
  final int completedGoalsCount;
  final int totalTargetKopecks;
  final int totalCurrentKopecks;
}