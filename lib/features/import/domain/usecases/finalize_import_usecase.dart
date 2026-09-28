import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../entities/duplicate_candidate.dart';
import '../entities/transfer_candidate.dart';
import '../entities/hold_confirmation_candidate.dart';
import '../entities/import_result.dart';

/// Финализация импорта: обработка дубликатов, переводов, hold + создание транзакций.
/// Обновляет баланс целевого счёта (D: Да, на сумму всех проведённых).
class FinalizeImportUseCase {
  final AppDatabase _db;
  final Logger _logger;

  FinalizeImportUseCase({
    required AppDatabase db,
    required Logger logger,
  })  : _db = db,
        _logger = logger;

  Future<void> call({
    required ImportResult importResult,
    required String userId,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      var totalDeltaKopecks = 0;

      // 1. Обрабатываем hold-подтверждения
      for (final hold in importResult.holdConfirmations) {
        if (hold.selectedAction == HoldAction.confirm) {
          await (_db.update(_db.transactions)
                ..where((t) => t.id.equals(hold.existingTransactionId)))
              .write(TransactionsCompanion(
            auditStatus: const Value(AuditStatus.verified),
            bankTransactionId: Value(hold.importedRow.bankTransactionId),
            updatedAt: Value(now),
            syncStatus: const Value(SyncStatus.pending),
          ));
        }
      }

      // 2. Обрабатываем переводы (merge → создаём transfer, удаляем пары)
      for (final transfer in importResult.transfers) {
        if (transfer.selectedAction == TransferAction.merge) {
          final transferId = const Uuid().v4();
          await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
                id: transferId,
                accountId: transfer.sourceAccountId,
                linkedAccountId: Value(transfer.targetAccountId),
                userId: userId,
                date: transfer.expenseRow.date.toUtc(),
                amount: transfer.amountKopecks,
                type: TransactionType.transfer,
                merchantName: Value(transfer.expenseRow.merchantName),
                createdAt: now,
                updatedAt: now,
                syncStatus: const Value(SyncStatus.pending),
              ));
          // Переводы НЕ влияют на P&L, но влияют на баланс
          // (баланс корректируется по факту расходной части)
        }
      }

      // 3. Собираем ID строк, которые нужно пропустить (дубли skip + переводы merge)
      final skipRowIndices = <int>{};
      for (final dup in importResult.duplicates) {
        if (dup.selectedAction == DuplicateAction.skip) {
          skipRowIndices.add(dup.importedRow.rowIndex);
        }
      }
      for (final transfer in importResult.transfers) {
        if (transfer.selectedAction == TransferAction.merge) {
          skipRowIndices.add(transfer.expenseRow.rowIndex);
          skipRowIndices.add(transfer.incomeRow.rowIndex);
        }
      }

      // 4. Создаём оставшиеся транзакции
      final rowsToCreate = importResult.rows
          .where((r) => !skipRowIndices.contains(r.rowIndex))
          .toList();

      final companions = rowsToCreate.map((row) {
        final type = row.amountKopecks < 0
            ? TransactionType.expense
            : TransactionType.income;
        final absAmount = row.amountKopecks.abs();
        totalDeltaKopecks += row.amountKopecks;

        return TransactionsCompanion.insert(
          id: const Uuid().v4(),
          accountId: importResult.targetAccountId,
          userId: userId,
          spaceId: Value(importResult.targetSpaceId),
          date: row.date.toUtc(),
          amount: absAmount,
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
        );
      }).toList();

      if (companions.isNotEmpty) {
        await _db.batch((b) => b.insertAll(_db.transactions, companions));
      }

      // 5. Обновляем баланс счёта
      if (totalDeltaKopecks != 0) {
        final account = await (_db.select(_db.accounts)
              ..where((a) => a.id.equals(importResult.targetAccountId)))
            .getSingleOrNull();
        if (account != null) {
          await (_db.update(_db.accounts)
                ..where((a) => a.id.equals(importResult.targetAccountId)))
              .write(AccountsCompanion(
            currentBalance: Value(account.currentBalance + totalDeltaKopecks),
            updatedAt: Value(now),
            syncStatus: const Value('pending'),
          ));
        }
      }

      _logger.i(
          'FinalizeImport: создано ${companions.length} транзакций, '
          'дельта баланса: $totalDeltaKopecks коп.');
    } catch (e, st) {
      _logger.e('FinalizeImportUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}