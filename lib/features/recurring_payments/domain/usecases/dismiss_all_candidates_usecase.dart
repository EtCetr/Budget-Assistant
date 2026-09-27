import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import '../entities/recurring_transaction.dart';
import '../repositories/recurring_transactions_repository.dart';

/// Результат «Отклонить все» (для undo-snackbar, ТЗ 6.3.9.10).
class DismissAllResult {
  const DismissAllResult({
    required this.deleted,
    required this.newDismissCount,
    required this.autoDetectDisabled,
  });

  final List<RecurringTransaction> deleted;
  final int newDismissCount;
  final bool autoDetectDisabled;
}

/// «Отклонить все»: удаляет pending-кандидатов, инкрементирует
/// recurring_detection_dismiss_count; при >= 3 выключает
/// auto_detect_recurring (защита от спама, ТЗ 6.3.9.10.3).
class DismissAllCandidatesUseCase {
  DismissAllCandidatesUseCase({
    required RecurringTransactionsRepository repository,
    required AppSettingsDao settingsDao,
    required Logger logger,
  })  : _repository = repository,
        _settingsDao = settingsDao,
        _logger = logger;

  final RecurringTransactionsRepository _repository;
  final AppSettingsDao _settingsDao;
  final Logger _logger;
  static const int _spamThreshold = 3;

  Future<DismissAllResult> call(String userId) async {
    try {
      final deleted = await _repository.getPendingConfirmation(userId);
      if (deleted.isEmpty) {
        return const DismissAllResult(
          deleted: [],
          newDismissCount: 0,
          autoDetectDisabled: false,
        );
      }
      await _repository.deleteByStatus(
        userId: userId,
        status: deleted.first.status,
      );
      final settings = await _settingsDao.getForUser(userId);
      final newCount = settings.recurringDetectionDismissCount + 1;
      final disabled = newCount >= _spamThreshold;
      await _settingsDao.updateForUser(
        userId,
        AppSettingsCompanion(
          recurringDetectionDismissCount: Value(newCount),
          autoDetectRecurring:
              disabled ? const Value(false) : const Value.absent(),
        ),
      );
      _logger.i('DismissAll: count=$newCount, autoDetectDisabled=$disabled');
      return DismissAllResult(
        deleted: deleted,
        newDismissCount: newCount,
        autoDetectDisabled: disabled,
      );
    } catch (e, st) {
      _logger.e('DismissAllCandidates failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}