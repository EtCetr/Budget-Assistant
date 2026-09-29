import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../entities/secrecy_candidate.dart';

/// Применение режима секретности к выбранным кандидатам (ТЗ 6.3.27):
/// транзакция скрывается календарём до даты праздника,
/// назначается категория (подарок не светится в P&L как обычно).
class ApplySecrecyModeUseCase {
  final AppDatabase _db;
  final Logger _logger;

  ApplySecrecyModeUseCase({required AppDatabase db, required Logger logger})
      : _db = db,
        _logger = logger;

  Future<bool> call({
    required List<SecrecyCandidate> selected,
    required Map<int, String> transactionIdByRowIndex,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      var count = 0;
      for (final c in selected) {
        final txId = transactionIdByRowIndex[c.transaction.rowIndex];
        if (txId == null) continue;
        await (_db.update(_db.transactions)
              ..where((t) => t.id.equals(txId)))
            .write(TransactionsCompanion(
          isHiddenByCalendar: const Value(true),
          hiddenUntilDate: Value(c.relatedHolidayDate.toUtc()),
          customCategoryId: Value(c.selectedCategoryId),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.pending),
        ));
        count++;
      }
      _logger.i('ApplySecrecyMode: скрыто $count транзакций');
      return true;
    } catch (e, st) {
      _logger.e('ApplySecrecyModeUseCase failed', error: e, stackTrace: st);
      return false;
    }
  }
}