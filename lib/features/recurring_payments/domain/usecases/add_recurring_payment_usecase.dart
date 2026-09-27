import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../entities/recurring_transaction.dart';
import '../repositories/recurring_transactions_repository.dart';

/// Подтверждение кандидата пользователем (ТЗ 6.3.9.9): идемпотентный
/// upsert по ключу (user_id, merchant_normalized, amount_bucket).
/// Существует запись -> UPDATE статистики + status='active';
/// нет -> INSERT со status='active'.
class AddRecurringPaymentUseCase {
  AddRecurringPaymentUseCase({
    required RecurringTransactionsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final RecurringTransactionsRepository _repository;
  final Logger _logger;

  Future<String> call(RecurringTransaction candidate) async {
    try {
      final now = DateTime.now().toUtc();
      final existing = await _repository.getByKey(
        userId: candidate.userId,
        merchantNormalized: candidate.merchantNameNormalized,
        amountBucket: candidate.averageAmountBucket,
      );
      if (existing != null) {
        await _repository.updateStats(
          id: existing.id,
          occurrenceCount: candidate.occurrenceCount,
          averageAmount: candidate.averageAmount,
          averageDayOfMonth: candidate.averageDayOfMonth,
          lastSeenDate: candidate.lastSeenDate,
          status: RecurringStatus.active,
        );
        return existing.id;
      }
      await _repository.insert(
        candidate.copyWith(
          status: RecurringStatus.active,
          updatedAt: now,
          syncStatus: SyncStatus.pending,
        ),
      );
      return candidate.id;
    } catch (e, st) {
      _logger.e('AddRecurringPayment failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}