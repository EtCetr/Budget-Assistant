import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

/// Этап 23.6 (D23.6-2): связанные копии транзакции в выбранных пространствах.
/// Этап 23.6c: добавлена личная копия (includePersonal) для импорта в семью.
class AddTransactionCopiesUseCase {
  AddTransactionCopiesUseCase({required AppDatabase db, required Logger logger})
      : _db = db,
        _logger = logger;

  final AppDatabase _db;
  final Logger _logger;

  Future<int> call({
    required String transactionId,
    required List<String> spaceIds,
    required String userId,
    bool includePersonal = false,
  }) async {
    try {
      if (spaceIds.isEmpty && !includePersonal) return 0;
      final source = await (_db.select(_db.transactions)
            ..where((t) => t.id.equals(transactionId)))
          .getSingleOrNull();
      if (source == null) return 0;

      final now = DateTime.now().toUtc();
      final gid = source.copyGroupId ?? const Uuid().v4();
      if (source.copyGroupId == null) {
        await (_db.update(_db.transactions)
              ..where((t) => t.id.equals(transactionId)))
            .write(TransactionsCompanion(
          copyGroupId: Value(gid),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.pending),
        ));
      }

      final existing = await (_db.select(_db.transactions)
            ..where((t) => t.copyGroupId.equals(gid)))
          .get();
      final presentSpaces = existing.map((e) => e.spaceId).toSet();
      final splits = await (_db.select(_db.transactionSplits)
            ..where((s) => s.transactionId.equals(transactionId)))
          .get();

      Future<void> insertCopy(String? spaceId) async {
        final copyId = const Uuid().v4();
        await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
              id: copyId,
              accountId: source.accountId,
              linkedAccountId: Value(source.linkedAccountId),
              userId: userId,
              spaceId: Value(spaceId),
              date: source.date,
              amount: source.amount,
              originalCurrency: Value(source.originalCurrency),
              originalAmount: Value(source.originalAmount),
              type: source.type,
              bankCategory: Value(source.bankCategory),
              customCategoryId: Value(source.customCategoryId),
              merchantName: Value(source.merchantName),
              comment: Value(source.comment),
              isUserEdited: Value(source.isUserEdited),
              auditStatus: Value(source.auditStatus),
              savingsGoalId: Value(source.savingsGoalId),
              isWithdrawal: Value(source.isWithdrawal),
              isSplit: Value(source.isSplit),
              isLargeExpense: Value(source.isLargeExpense),
              copyGroupId: Value(gid),
              createdAt: now,
              updatedAt: now,
              syncStatus: const Value(SyncStatus.pending),
            ));
        for (final s in splits) {
          await _db.into(_db.transactionSplits).insert(
                TransactionSplitsCompanion.insert(
                  id: const Uuid().v4(),
                  transactionId: copyId,
                  categoryId: s.categoryId,
                  amount: s.amount,
                  description: Value(s.description),
                  createdAt: now,
                  updatedAt: now,
                  syncStatus: const Value(SyncStatus.pending),
                ),
              );
        }
      }

      var created = 0;
      if (includePersonal && !presentSpaces.contains(null)) {
        await insertCopy(null);
        created++;
      }
      for (final spaceId in spaceIds) {
        if (presentSpaces.contains(spaceId)) continue;
        await insertCopy(spaceId);
        created++;
      }
      return created;
    } catch (e, st) {
      _logger.e('AddTransactionCopies failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}