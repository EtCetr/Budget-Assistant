import 'package:logger/logger.dart';
import '../entities/savings_goal.dart';

/// Поля сортировки таблицы целей (ТЗ 6.3.18.6).
enum GoalSortField { name, target, current, progress, deadline }

/// Сортировка списка целей для таблицы аналитики.
class SortGoalsTableUseCase {
  SortGoalsTableUseCase({required Logger logger}) : _logger = logger;
  final Logger _logger;

  List<SavingsGoal> call({
    required List<SavingsGoal> goals,
    required GoalSortField field,
    required bool ascending,
  }) {
    try {
      final sorted = List<SavingsGoal>.from(goals);
      int cmp(SavingsGoal a, SavingsGoal b) {
        switch (field) {
          case GoalSortField.name:
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          case GoalSortField.target:
            return a.targetAmount.compareTo(b.targetAmount);
          case GoalSortField.current:
            return a.currentAmount.compareTo(b.currentAmount);
          case GoalSortField.progress:
            return a.progressPercent.compareTo(b.progressPercent);
          case GoalSortField.deadline:
            final ad = a.deadline;
            final bd = b.deadline;
            if (ad == null && bd == null) return 0;
            if (ad == null) return 1;
            if (bd == null) return -1;
            return ad.compareTo(bd);
        }
      }
      sorted.sort((a, b) => ascending ? cmp(a, b) : -cmp(a, b));
      return sorted;
    } catch (e, st) {
      _logger.e('SortGoalsTableUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}