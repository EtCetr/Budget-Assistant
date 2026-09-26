import 'package:budget_assistant/core/logger.dart';
import '../repositories/debts_repository.dart';

/// «Продлить срок» (6.3.13.9): только создатель долга.
class ExtendDebtDueDateUseCase {
  ExtendDebtDueDateUseCase({required DebtsRepository repository})
      : _repository = repository;

  final DebtsRepository _repository;

  Future<void> call({
    required String debtId,
    required DateTime newDueDateUtc,
    required String actorUserId,
  }) async {
    try {
      final debt = await _repository.getById(debtId);
      if (debt == null) throw StateError('Debt not found: $debtId');
      if (debt.createdBy != actorUserId) {
        throw StateError('Only debt creator can extend due date: $debtId');
      }
      await _repository.extendDueDate(
        debtId: debtId,
        newDueDateUtc: newDueDateUtc,
      );
    } catch (e, st) {
      AppLogger.e('ExtendDebtDueDateUseCase failed: $e', e, st);
      rethrow;
    }
  }
}