import 'dart:math';

import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/lookup_item.dart';
import '../../domain/entities/transaction_ui_model.dart';
import '../../domain/entities/transactions_filter_state.dart';
import '../../domain/repositories/transactions_log_repository.dart';

/// Drift-реализация репозитория лога транзакций (Этап 7).
/// Все фильтры применяются ТОЛЬКО в SQL (DECISIONS.md).
class DriftTransactionsLogRepository implements TransactionsLogRepository {
  DriftTransactionsLogRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<TransactionUiModel>> fetchPage({
    required TransactionsFilterState filter,
    required String currentUserId,
    required String? currentSpaceId,
    required int limit,
    required int offset,
  }) async {
    try {
      final t = _db.transactions;
      final c = _db.categories;
      final u = _db.users;

      final expressions = <Expression<bool>>[
        _scopeExpression(
          scope: filter.scope,
          currentUserId: currentUserId,
          currentSpaceId: currentSpaceId,
        ),
      ];

      final typeExpr = _typeExpression(filter.type);
      if (typeExpr != null) expressions.add(typeExpr);

      if (filter.categoryIds.isNotEmpty) {
        expressions.add(t.customCategoryId.isIn(filter.categoryIds));
      }

      if (filter.accountIds.isNotEmpty) {
        expressions.add(t.accountId.isIn(filter.accountIds));
      }

      final range = _dateRange(filter);
      if (range != null) {
        expressions.add(t.date.isBiggerOrEqualValue(range.$1));
        expressions.add(t.date.isSmallerOrEqualValue(range.$2));
      }

            // Фильтр по сумме работает с ПОДПИСАННОЙ суммой, как она показана в UI:
      // расход = −amount, доход/перевод = +amount.
      final isExpense = t.type.equalsValue(TransactionType.expense);
      final negatedAmount = t.amount * const Constant(-1);

      if (filter.amountFromKopecks != null) {
        final from = filter.amountFromKopecks!;
        expressions.add(
          (isExpense & negatedAmount.isBiggerOrEqualValue(from)) |
              (isExpense.not() & t.amount.isBiggerOrEqualValue(from)),
        );
      }
      if (filter.amountToKopecks != null) {
        final to = filter.amountToKopecks!;
        expressions.add(
          (isExpense & negatedAmount.isSmallerOrEqualValue(to)) |
              (isExpense.not() & t.amount.isSmallerOrEqualValue(to)),
        );
      }

      if (filter.onlyWithReceipt) {
        expressions.add(t.receiptId.isNotNull());
      }

      if (filter.onlySplit) {
        expressions.add(t.isSplit.equals(true));
      }

      if (filter.onlyDebts) {
        // Таблицы debts ещё нет (Этап 13): долгов не существует,
        // поэтому под фильтр не попадает ни одна транзакция.
        // TODO(Этап 13): заменить на EXISTS-подзапрос по таблице debts.
        expressions.add(const Constant(false));
      }
      // «Без моих»: исключить собственные транзакции пользователя.
      // Комбинируется с любым сегментом (Все / Семейные).
      if (filter.excludeOwn) {
        expressions.add(t.userId.equals(currentUserId).not());
      }

      final search = filter.search.trim();
      if (search.isNotEmpty) {
        final term = '%$search%';
        expressions.add(
          t.merchantName.like(term) | t.comment.like(term) | c.name.like(term),
        );
      }

      final query =
          _db.select(t).join([
              leftOuterJoin(c, c.id.equalsExp(t.customCategoryId)),
              leftOuterJoin(u, u.id.equalsExp(t.userId)),
            ])
            ..where(expressions.reduce((a, b) => a & b))
            ..orderBy([
              OrderingTerm.desc(t.date),
              OrderingTerm.desc(t.createdAt),
            ])
            ..limit(limit, offset: offset);

      final rows = await query.get();
      return rows.map(_mapRow).toList();
    } catch (e, s) {
      AppLogger.e('fetchPage failed: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<List<LookupItem>> fetchCategories() async {
    try {
      final rows = await (_db.select(
        _db.categories,
      )..orderBy([(c) => OrderingTerm.asc(c.name)])).get();
      return rows.map((c) => LookupItem(id: c.id, name: c.name)).toList();
    } catch (e, s) {
      AppLogger.e('fetchCategories failed: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<List<LookupItem>> fetchAccounts() async {
    try {
      final rows = await (_db.select(
        _db.accounts,
      )..orderBy([(a) => OrderingTerm.asc(a.bankName)])).get();
      return rows
          .map(
            (a) => LookupItem(
              id: a.id,
              name: a.customName.isNotEmpty ? a.customName : a.bankName,
            ),
          )
          .toList();
    } catch (e, s) {
      AppLogger.e('fetchAccounts failed: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<void> hideAsGift(String transactionId) async {
    try {
      final now = DateTime.now().toUtc();
      await (_db.update(
        _db.transactions,
      )..where((t) => t.id.equals(transactionId))).write(
        TransactionsCompanion(
          isHiddenByCalendar: const Value(true),
          syncStatus: const Value(SyncStatus.pending),
          updatedAt: Value(now),
        ),
      );
    } catch (e, s) {
      AppLogger.e('hideAsGift failed: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<void> ignore(String transactionId) async {
    try {
      final now = DateTime.now().toUtc();
      await (_db.update(
        _db.transactions,
      )..where((t) => t.id.equals(transactionId))).write(
        TransactionsCompanion(
          auditStatus: const Value(AuditStatus.ignored),
          syncStatus: const Value(SyncStatus.pending),
          updatedAt: Value(now),
        ),
      );
    } catch (e, s) {
      AppLogger.e('ignore failed: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<void> updateCategory({
    required String transactionId,
    required String categoryId,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      await (_db.update(
        _db.transactions,
      )..where((t) => t.id.equals(transactionId))).write(
        TransactionsCompanion(
          customCategoryId: Value(categoryId),
          syncStatus: const Value(SyncStatus.pending),
          updatedAt: Value(now),
        ),
      );
    } catch (e, s) {
      AppLogger.e('updateCategory failed: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<void> createCompensatingIncome(String originalTransactionId) async {
    try {
      final original = await (_db.select(
        _db.transactions,
      )..where((t) => t.id.equals(originalTransactionId))).getSingleOrNull();

      if (original == null) {
        AppLogger.w('Original transaction not found: $originalTransactionId');
        return;
      }

      final now = DateTime.now().toUtc();

      await _db
          .into(_db.transactions)
          .insert(
            TransactionsCompanion.insert(
              id: _newId(),
              accountId: original.accountId,
              userId: original.userId,
              spaceId: Value(original.spaceId),
              date: now,
              amount: original.amount,
              type: TransactionType.income,
              merchantName: Value(original.merchantName),
              customCategoryId: Value(original.customCategoryId),
              syncStatus: const Value(SyncStatus.pending),
              createdAt: now,
              updatedAt: now,
            ),
          );
    } catch (e, s) {
      AppLogger.e('createCompensatingIncome failed: $e', e, s);
      rethrow;
    }
  }

  @override
  Stream<int> watchPendingSyncCount() {
    final countExp = _db.transactions.id.count();
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([countExp])
      ..where(_db.transactions.syncStatus.equalsValue(SyncStatus.pending));
    return query.map((row) => row.read(countExp) ?? 0).watchSingle();
  }
  
  @override
  Future<void> unhideAsGift(String transactionId) async {
    try {
      final now = DateTime.now().toUtc();
      await (_db.update(
        _db.transactions,
      )..where((t) => t.id.equals(transactionId))).write(
        TransactionsCompanion(
          isHiddenByCalendar: const Value(false),
          hiddenUntilDate: const Value(null),
          syncStatus: const Value(SyncStatus.pending),
          updatedAt: Value(now),
        ),
      );
    } catch (e, s) {
      AppLogger.e('unhideAsGift failed: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<void> restoreFromIgnored(String transactionId) async {
    try {
      final now = DateTime.now().toUtc();
      await (_db.update(
        _db.transactions,
      )..where((t) => t.id.equals(transactionId))).write(
        TransactionsCompanion(
          auditStatus: const Value(AuditStatus.verified),
          syncStatus: const Value(SyncStatus.pending),
          updatedAt: Value(now),
        ),
      );
    } catch (e, s) {
      AppLogger.e('restoreFromIgnored failed: $e', e, s);
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Helpers
  // ═══════════════════════════════════════════════════════════════

  TransactionUiModel _mapRow(TypedResult row) {
    final t = row.readTable(_db.transactions);
    final c = row.readTableOrNull(_db.categories);
    final u = row.readTableOrNull(_db.users);

    return TransactionUiModel(
      id: t.id,
      userId: t.userId,
      spaceId: t.spaceId,
      accountId: t.accountId,
      categoryId: t.customCategoryId,
      type: t.type,
      amountKopecks: t.amount,
      currencyCode: t.originalCurrency ?? 'RUB',
      date: t.date,
      merchantName: t.merchantName,
      comment: t.comment,
      receiptId: t.receiptId,
      isSplit: t.isSplit,
      auditStatus: t.auditStatus,
      syncStatus: t.syncStatus,
      categoryName: c?.name ?? '',
      categoryColorHex: c?.colorHex ?? '#9CA3AF',
      memberDisplayName: u?.displayName,
      memberColorHex: null,
      isHiddenByCalendar: t.isHiddenByCalendar,
    );
  }

  Expression<bool> _scopeExpression({
    required TransactionsScope scope,
    required String currentUserId,
    required String? currentSpaceId,
  }) {
    final t = _db.transactions;

    switch (scope) {
      case TransactionsScope.all:
        if (currentSpaceId == null) {
          return t.userId.equals(currentUserId);
        }
        return t.spaceId.equals(currentSpaceId) |
            t.userId.equals(currentUserId);

      case TransactionsScope.mine:
        return t.userId.equals(currentUserId);

      case TransactionsScope.family:
        // Продуктовое решение (отклонение от ТЗ 6.3.2.3):
        // «Семейные» = ВСЕ транзакции активного пространства, включая мои.
        // «Только члены семьи, без меня» = чип «Без моих» (excludeOwn).
        // Изоляция Multi-group сохранена: данные других пространств не попадают.
        if (currentSpaceId == null) return const Constant(false);
        return t.spaceId.equals(currentSpaceId);
    }
  }

  Expression<bool>? _typeExpression(TransactionTypeFilter type) {
    final t = _db.transactions;
    switch (type) {
      case TransactionTypeFilter.all:
        return null;
      case TransactionTypeFilter.expense:
        return t.type.equalsValue(TransactionType.expense);
      case TransactionTypeFilter.income:
        return t.type.equalsValue(TransactionType.income);
      case TransactionTypeFilter.transfer:
        return t.type.equalsValue(TransactionType.transfer);
    }
  }

  (DateTime, DateTime)? _dateRange(TransactionsFilterState filter) {
    final now = DateTime.now();
    switch (filter.period) {
      case TransactionsPeriodPreset.all:
        return null;
      case TransactionsPeriodPreset.today:
        final start = DateTime(now.year, now.month, now.day);
        return _toUtcRange(start, start);
      case TransactionsPeriodPreset.week:
        final startLocal = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: now.weekday - 1));
        return _toUtcRange(startLocal, startLocal.add(const Duration(days: 6)));
      case TransactionsPeriodPreset.month:
        final startLocal = DateTime(now.year, now.month, 1);
        final endLocal = DateTime(
          now.year,
          now.month + 1,
          1,
        ).subtract(const Duration(days: 1));
        return _toUtcRange(startLocal, endLocal);
      case TransactionsPeriodPreset.year:
        final startLocal = DateTime(now.year, 1, 1);
        final endLocal = DateTime(
          now.year + 1,
          1,
          1,
        ).subtract(const Duration(days: 1));
        return _toUtcRange(startLocal, endLocal);
      case TransactionsPeriodPreset.custom:
        final from = filter.customFrom;
        final to = filter.customTo;
        if (from == null || to == null) return null;
        return _toUtcRange(from, to);
    }
  }

  (DateTime, DateTime) _toUtcRange(DateTime startLocal, DateTime endLocal) {
    final from = DateTime(
      startLocal.year,
      startLocal.month,
      startLocal.day,
    ).toUtc();
    final to = DateTime(
      endLocal.year,
      endLocal.month,
      endLocal.day,
      23,
      59,
      59,
      999,
    ).toUtc();
    return (from, to);
  }

  String _newId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
