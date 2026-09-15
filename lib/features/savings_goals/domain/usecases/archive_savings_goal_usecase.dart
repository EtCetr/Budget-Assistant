import 'package:logger/logger.dart';
import '../repositories/savings_goals_repository.dart';

/// Архивирование цели.
///
/// Цель остаётся в БД, но скрывается из основного списка.
class ArchiveSavingsGoalUseCase {
  ArchiveSavingsGoalUseCase({
    required SavingsGoalsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final SavingsGoalsRepository _repository;
  final Logger _logger;

  Future<void> call(String goalId) async {
    try {
      await _repository.archive(goalId);
    } catch (e, st) {
      _logger.e('ArchiveSavingsGoalUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}