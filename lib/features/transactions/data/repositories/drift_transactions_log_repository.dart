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
///
/// Этап 24 (D24-9): одна операция = одна группа копий. В скоупе «Все»
/// показываем представителя группы (личная копия важнее семейной),
/// «Личное» = группы с личной копией, «Семейные» = копии пространства.
class DriftTransactionsLogRepository implements TransactionsLogRepository {
  DriftTransactionsLogRepository(this._db);

  final AppDatabase _db;

  /// Представитель группы копий: личная копия, затем самая ранняя.
  static const _groupDedup = CustomExpression<bool>(
    '(transactions.copy_group_id IS NULL OR transactions.id = ('
    'SELECT x.id FROM transactions x '
    'WHERE x.copy_group_id = transactions.copy_group_id '
    'ORDER BY (x.space_id IS NULL) DESC, x.created_at ASC, x.id ASC LIMIT 1))',
  );

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

      // Фильтр суммы по МОДУЛЮ: «от 200» ловит и трату 250, и доход 280.
      final absAmount = CustomExpression<int>('ABS(${t.amount.name})');
      if (filter.amountFromKopecks != null) {
        expressions.add(absAmount.isBiggerOrEqualValue(filter.amountFromKopecks!));
      }
      if (filter.amountToKopecks != null) {
        expressions.add(absAmount.isSmallerOrEqualValue(filter.amountToKopecks!));
      }

      if (filter.onlyWithReceipt) {
        expressions.add(t.receiptId.isNotNull());
      }
      if (filter.onlySplit) {
        expressions.add(t.isSplit.equals(true));
      }
      if (filter.onlyDebts) {
        expressions.add(
          const CustomExpression<bool>(
            '(EXISTS (SELECT 1 FROM debts '
            'WHERE debts.original_transaction_id = transactions.id) '
            'OR EXISTS (SELECT 1 FROM transaction_splits AS ts '
            'INNER JOIN debts ON debts.split_id = ts.id '
            'WHERE ts.transaction_id = transactions.id))',
          ),
        );
      }
      if (filter.excludeOwn) {
        expressions.add(t.userId.equals(currentUserId).not());
      }
      if (filter.excludeLargeExpenses) {
        expressions.add(t.isLargeExpense.equals(false));
      }
      if (filter.onlySecret) {
        expressions.add(t.isHiddenByCalendar.equals(true));
      }

      final search = filter.search.trim();
      if (search.isNotEmpty) {
        final term = '%$search%';
        expressions.add(
          t.merchantName.like(term) | t.comment.like(term) | c.name.like(term),
        );
      }

      final query = _db.select(t).join([
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

      // Состав групп копий — одним запросом на страницу (без N+1).
      final gids = <String>{};
      for (final r in rows) {
        final g = r.readTable(t).copyGroupId;
        if (g != null) gids.add(g);
      }
      final groups = <String, _GroupInfo>{};
      if (gids.isNotEmpty) {
        final groupRows = await (_db.select(_db.transactions)
              ..where((x) => x.copyGroupId.isIn(gids.toList())))
            .get();
        for (final g in groupRows) {
          final info = groups.putIfAbsent(g.copyGroupId!, _GroupInfo.new);
          final sid = g.spaceId;
          if (sid == null) {
            info.personal = true;
          } else {
            info.spaces.add(sid);
          }
        }
      }

      return rows.map((r) => _mapRow(r, groups)).toList();
    } catch (e, s) {
      AppLogger.e('fetchPage failed: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<List<LookupItem>> fetchCategories() async {
    try {
      final rows = await (_db.select(_db.categories)
            ..orderBy([(c) => OrderingTerm.asc(c.name)]))
          .get();
      return rows.map((c) => LookupItem(id: c.id, name: c.name)).toList();
    } catch (e, s) {
      AppLogger.e('fetchCategories failed: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<List<LookupItem>> fetchAccounts() async {
    try {
      final rows = await (_db.select(_db.accounts)
            ..orderBy([(a) => OrderingTerm.asc(a.bankName)]))
          .get();
      return rows
          .map((a) => LookupItem(
                id: a.id,
                name: a.customName.isNotEmpty ? a.customName : a.bankName,
              ))
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
      await (_db.update(_db.transactions)
            ..where((t) => t.id.equals(transactionId)))
          .write(TransactionsCompanion(
        isHiddenByCalendar: const Value(true),
        syncStatus: const Value(SyncStatus.pending),
        updatedAt: Value(now),
      ));
    } catch (e, s) {
      AppLogger.e('hideAsGift failed: $e', e, s);
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
      await (_db.update(_db.transactions)
            ..where((t) => t.id.equals(transactionId)))
          .write(TransactionsCompanion(
        customCategoryId: Value(categoryId),
        syncStatus: const Value(SyncStatus.pending),
        updatedAt: Value(now),
      ));
    } catch (e, s) {
      AppLogger.e('updateCategory failed: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<void> createCompensatingIncome(String originalTransactionId) async {
    try {
      final original = await (_db.select(_db.transactions)
            ..where((t) => t.id.equals(originalTransactionId)))
          .getSingleOrNull();
      if (original == null) {
        AppLogger.w('Original transaction not found: $originalTransactionId');
        return;
      }
      final now = DateTime.now().toUtc();
      await _db.into(_db.transactions).insert(
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
      await (_db.update(_db.transactions)
            ..where((t) => t.id.equals(transactionId)))
          .write(TransactionsCompanion(
        isHiddenByCalendar: const Value(false),
        hiddenUntilDate: const Value(null),
        syncStatus: const Value(SyncStatus.pending),
        updatedAt: Value(now),
      ));
    } catch (e, s) {
      AppLogger.e('unhideAsGift failed: $e', e, s);
      rethrow;
    }
  }

  @override
  Future<void> toggleLargeExpense(String transactionId) async {
    try {
      final now = DateTime.now().toUtc();
      await _db.customUpdate(
        '''
UPDATE transactions
SET is_large_expense = NOT is_large_expense,
    sync_status = 'pending',
    updated_at = ?
WHERE id = ?
''',
        variables: [
          Variable.withDateTime(now),
          Variable.withString(transactionId),
        ],
      );
    } catch (e, s) {
      AppLogger.e('toggleLargeExpense failed: $e', e, s);
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────

  TransactionUiModel _mapRow(TypedResult row, Map<String, _GroupInfo> groups) {
    final t = row.readTable(_db.transactions);
    final c = row.readTableOrNull(_db.categories);
    final u = row.readTableOrNull(_db.users);
    final gid = t.copyGroupId;
    final info = gid == null ? null : groups[gid];
    final sid = t.spaceId;

    return TransactionUiModel(
      id: t.id,
      userId: t.userId,
      spaceId: sid,
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
      isLargeExpense: t.isLargeExpense,
      copyGroupId: gid,
      hasPersonalCopy: info?.personal ?? (sid == null),
      groupSpaceIds: info?.spaces.toList() ?? (sid == null ? const [] : [sid]),
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
        // D24-9: группа показывается один раз — берём представителя.
        final base = currentSpaceId == null
            ? t.userId.equals(currentUserId)
            : (t.spaceId.equals(currentSpaceId) | t.userId.equals(currentUserId));
        return base & _groupDedup;
      case TransactionsScope.mine:
        // «Личное»: группы, у которых есть личная копия (в т.ч. расшаренные).
        return t.userId.equals(currentUserId) & t.spaceId.isNull();
      case TransactionsScope.family:
        // «Семейные» = все операции активного пространства, включая мои.
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
        final startLocal = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: now.weekday - 1));
        return _toUtcRange(startLocal, startLocal.add(const Duration(days: 6)));
      case TransactionsPeriodPreset.month:
        final startLocal = DateTime(now.year, now.month, 1);
        final endLocal = DateTime(now.year, now.month + 1, 1)
            .subtract(const Duration(days: 1));
        return _toUtcRange(startLocal, endLocal);
      case TransactionsPeriodPreset.year:
        final startLocal = DateTime(now.year, 1, 1);
        final endLocal =
            DateTime(now.year + 1, 1, 1).subtract(const Duration(days: 1));
        return _toUtcRange(startLocal, endLocal);
      case TransactionsPeriodPreset.custom:
        final from = filter.customFrom;
        final to = filter.customTo;
        if (from == null || to == null) return null;
        return _toUtcRange(from, to);
    }
  }

  (DateTime, DateTime) _toUtcRange(DateTime startLocal, DateTime endLocal) {
    final from =
        DateTime(startLocal.year, startLocal.month, startLocal.day).toUtc();
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

class _GroupInfo {
  bool personal = false;
  final Set<String> spaces = <String>{};
}