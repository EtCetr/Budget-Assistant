import 'package:logger/logger.dart';
import '../entities/savings_goal.dart';

/// Сортировка таблицы целей в SavingsAnalyticsScreen.
///
/// Упрощённая версия: полная реализация — в микро-коммите 12.7.
class SortGoalsTableUseCase {
  SortGoalsTableUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  List<SavingsGoal> call({
    required List<SavingsGoal> goals,
    required GoalsSortColumn column,
    required bool ascending,
  }) {
    try {
      final sorted = List<SavingsGoal>.from(goals);
      sorted.sort((a, b) {
        final result = switch (column) {
          GoalsSortColumn.name => a.name.compareTo(b.name),
          GoalsSortColumn.progress => a.progressPercent.compareTo(b.progressPercent),
          GoalsSortColumn.current => a.currentAmount.compareTo(b.currentAmount),
          GoalsSortColumn.target => a.targetAmount.compareTo(b.targetAmount),
          GoalsSortColumn.deadline => _compareDeadlines(a.deadline, b.deadline),
        };
        return ascending ? result : -result;
      });
      return sorted;
    } catch (e, st) {
      _logger.e('SortGoalsTableUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  int _compareDeadlines(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }
}

enum GoalsSortColumn { name, progress, current, target, deadline }