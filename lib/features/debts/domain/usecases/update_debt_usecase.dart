import 'package:budget_assistant/core/logger.dart';
import '../entities/debt.dart';
import '../repositories/debts_repository.dart';

/// Редактирование долга (6.3.13.9): только создатель.
class UpdateDebtUseCase {
  UpdateDebtUseCase({required DebtsRepository repository})
      : _repository = repository;

  final DebtsRepository _repository;

  Future<void> call({
    required Debt debt,
    required String actorUserId,
  }) async {
    try {
      final existing = await _repository.getById(debt.id);
      if (existing == null) throw StateError('Debt not found: ${debt.id}');
      if (existing.createdBy != actorUserId) {
        throw StateError('Only debt creator can edit it: ${debt.id}');
      }
      await _repository.update(debt);
    } catch (e, st) {
      AppLogger.e('UpdateDebtUseCase failed: $e', e, st);
      rethrow;
    }
  }
}