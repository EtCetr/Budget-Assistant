import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import '../entities/recurring_transaction.dart';
import '../repositories/recurring_transactions_repository.dart';

/// Undo для «Отклонить все» (ТЗ 6.3.9.10): восстанавливает кандидатов
/// и откатывает счётчик отказов на 1 (не ниже 0).
class RestoreDismissedCandidatesUseCase {
  RestoreDismissedCandidatesUseCase({
    required RecurringTransactionsRepository repository,
    required AppSettingsDao settingsDao,
    required Logger logger,
  })  : _repository = repository,
        _settingsDao = settingsDao,
        _logger = logger;

  final RecurringTransactionsRepository _repository;
  final AppSettingsDao _settingsDao;
  final Logger _logger;

  Future<void> call(String userId, List<RecurringTransaction> deleted) async {
    try {
      if (deleted.isEmpty) return;
      await _repository.insertAll(deleted);
      final settings = await _settingsDao.getForUser(userId);
      final reverted =
          (settings.recurringDetectionDismissCount - 1).clamp(0, 999);
      await _settingsDao.updateForUser(
        userId,
        AppSettingsCompanion(
          recurringDetectionDismissCount: Value(reverted),
        ),
      );
      _logger.i('RestoreDismissed: ${deleted.length} rows, count=$reverted');
    } catch (e, st) {
      _logger.e('RestoreDismissedCandidates failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}