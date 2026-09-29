import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../entities/duplicate_candidate.dart';
import '../entities/finalize_outcome.dart';
import '../entities/import_result.dart';
import '../entities/transfer_candidate.dart';
import '../entities/hold_confirmation_candidate.dart';

/// Финализация импорта (ТЗ 6.3.26):
/// hold -> дубликаты (skip/replace/both) -> переводы (merge/keep) ->
/// создание выбранных строк -> корректировка баланса.
/// Возвращает ID созданных транзакций для проверки секретности.
class FinalizeImportUseCase {
  final AppDatabase _db;
  final Logger _logger;

  FinalizeImportUseCase({required AppDatabase db, required Logger logger})
      : _db = db,
        _logger = logger;

  Future<FinalizeOutcome?> call({
    required ImportResult importResult,
    required String userId,
    required Set<int> selectedRowIndices,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      var updatedExisting = 0;
      var transfersCreated = 0;
      var balanceDelta = 0;
      final created = <CreatedImportedTransaction>[];

      // 1. Hold-подтверждения.
      for (final hold in importResult.holdConfirmations) {
        if (hold.selectedAction != HoldAction.confirm) continue;
        await (_db.update(_db.transactions)
              ..where((t) => t.id.equals(hold.existingTransactionId)))
            .write(TransactionsCompanion(
          auditStatus: const Value(AuditStatus.verified),
          bankTransactionId: Value(hold.importedRow.bankTransactionId),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.pending),
        ));
        updatedExisting++;
      }

      // 2. Дубликаты: skip исключаем, replace обновляем, both оставляем.
      final excluded = <int>{};
      for (final dup in importResult.duplicates) {
        final idx = dup.importedRow.rowIndex;
        switch (dup.selectedAction) {
          case DuplicateAction.skip:
            excluded.add(idx);
          case DuplicateAction.replace:
            excluded.add(idx);
            await (_db.update(_db.transactions)
                  ..where((t) => t.id.equals(dup.existingTransactionId)))
                .write(TransactionsCompanion(
              customCategoryId: Value(dup.importedRow.assignedCategoryId),
              bankCategory: Value(dup.importedRow.bankCategory),
              comment: Value(dup.importedRow.comment),
              bankTransactionId: Value(dup.importedRow.bankTransactionId),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatus.pending),
            ));
            updatedExisting++;
          case DuplicateAction.both:
            break;
        }
      }

      // 3. Переводы: merge создаёт transfer и исключает обе строки.
      for (final tr in importResult.transfers) {
        if (tr.selectedAction != TransferAction.merge) continue;
        excluded.add(tr.expenseRow.rowIndex);
        excluded.add(tr.incomeRow.rowIndex);
        await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
              id: const Uuid().v4(),
              accountId: tr.sourceAccountId,
              linkedAccountId: Value(tr.targetAccountId),
              userId: userId,
              spaceId: Value(importResult.targetSpaceId),
              date: tr.expenseRow.date.toUtc(),
              amount: tr.amountKopecks,
              type: TransactionType.transfer,
              merchantName: Value(tr.expenseRow.merchantName),
              createdAt: now,
              updatedAt: now,
              syncStatus: const Value(SyncStatus.pending),
            ));
        transfersCreated++;
        balanceDelta -= tr.amountKopecks;
      }

      // 4. Создание выбранных строк.
      for (final row in importResult.rows) {
        if (!selectedRowIndices.contains(row.rowIndex)) continue;
        if (excluded.contains(row.rowIndex)) continue;
        final type = row.amountKopecks < 0
            ? TransactionType.expense
            : TransactionType.income;
        final id = const Uuid().v4();
        await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
              id: id,
              accountId: importResult.targetAccountId,
              userId: userId,
              spaceId: Value(importResult.targetSpaceId),
              date: row.date.toUtc(),
              amount: row.amountKopecks.abs(),
              type: type,
              merchantName: Value(row.merchantName),
              bankCategory: Value(row.bankCategory),
              customCategoryId: Value(row.assignedCategoryId),
              bankTransactionId: Value(row.bankTransactionId),
              comment: Value(row.comment),
              originalCurrency: Value(row.originalCurrency),
              originalAmount: Value(row.originalAmountKopecks),
              createdAt: now,
              updatedAt: now,
              syncStatus: const Value(SyncStatus.pending),
            ));
        created.add(CreatedImportedTransaction(id: id, row: row));
        balanceDelta += row.amountKopecks;
      }

      // 5. Баланс целевого счёта (решение владельца D).
      if (balanceDelta != 0) {
        final account = await (_db.select(_db.accounts)
              ..where((a) => a.id.equals(importResult.targetAccountId)))
            .getSingleOrNull();
        if (account != null) {
          await (_db.update(_db.accounts)
                ..where((a) => a.id.equals(importResult.targetAccountId)))
              .write(AccountsCompanion(
            currentBalance: Value(account.currentBalance + balanceDelta),
            updatedAt: Value(now),
            syncStatus: const Value('pending'),
          ));
        }
      }

      _logger.i('FinalizeImport: создано ${created.length}, '
          'обновлено $updatedExisting, переводов $transfersCreated, '
          'дельта $balanceDelta');
      return FinalizeOutcome(
        created: created,
        updatedExistingCount: updatedExisting,
        transfersCreatedCount: transfersCreated,
        balanceDeltaKopecks: balanceDelta,
      );
    } catch (e, st) {
      _logger.e('FinalizeImportUseCase failed', error: e, stackTrace: st);
      return null;
    }
  }
}