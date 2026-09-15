import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../entities/savings_goal.dart';
import '../repositories/savings_goals_repository.dart';

/// Создание цели накопления.
///
/// current_amount = 0 (пополнения через ContributeToSavingsGoalUseCase).
class CreateSavingsGoalUseCase {
  CreateSavingsGoalUseCase({
    required SavingsGoalsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final SavingsGoalsRepository _repository;
  final Logger _logger;

  Future<SavingsGoal> call({
    required String userId,
    required String name,
    required int targetAmountKopecks,
    required String currency,
    DateTime? deadline,
    String? linkedAccountId,
    bool autoReminderEnabled = true,
    String? spaceId,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final goal = SavingsGoal(
        id: const Uuid().v4(),
        userId: userId,
        spaceId: spaceId,
        name: name,
        targetAmount: targetAmountKopecks,
        currentAmount: 0,
        deadline: deadline,
        linkedAccountId: linkedAccountId,
        currency: currency,
        autoReminderEnabled: autoReminderEnabled,
        createdAt: now,
        updatedAt: now,
      );
      await _repository.insert(goal);
      return goal;
    } catch (e, st) {
      _logger.e('CreateSavingsGoalUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}