// lib/features/spaces/presentation/providers/space_archive_providers.dart
// Этап 21 (ТЗ 6.3.52): read-only архив расформированного пространства.
// D21-24: все таба фильтруют по space_id (пространство расформировано);
// флаг is_archived_for_space есть только у транзакций и используется
// для скрытия из активных списков, не для архива.
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/database_provider.dart';

/// Метаданные расформированного пространства для баннера.
class SpaceArchiveInfo {
  const SpaceArchiveInfo({
    required this.name,
    this.iconEmoji,
    this.iconColor,
    this.dissolvedAt,
    required this.membersCount,
    required this.currencyCode,
  });

  final String name; // [E2E] при sync
  final String? iconEmoji;
  final String? iconColor;
  final DateTime? dissolvedAt;
  final int membersCount;
  final String currencyCode;
}

/// Read-only сводка 2×2 (ТЗ 6.3.52.3).
class SpaceArchiveStats {
  const SpaceArchiveStats({
    required this.accountsCount,
    required this.transactionsCount,
    required this.goalsCount,
    required this.totalBalanceKopecks,
  });

  final int accountsCount;
  final int transactionsCount;
  final int goalsCount;
  final int totalBalanceKopecks;
}

final spaceArchiveInfoProvider =
    StreamProvider.family<SpaceArchiveInfo?, String>((ref, spaceId) async* {
  final db = ref.watch(appDatabaseProvider);
  await for (final space in db.spacesDao.watchById(spaceId)) {
    if (space == null) {
      yield null;
      continue;
    }
    final row = await db.customSelect(
      'SELECT COUNT(*) AS c FROM memberships WHERE space_id = ?',
      variables: [Variable.withString(spaceId)],
      readsFrom: {db.memberships},
    ).getSingle();
    yield SpaceArchiveInfo(
      name: space.name,
      iconEmoji: space.iconEmoji,
      iconColor: space.iconColor,
      dissolvedAt: space.dissolvedAt,
      membersCount: row.read<int>('c'),
      currencyCode: space.currencyCode,
    );
  }
});

final spaceArchiveStatsProvider =
    FutureProvider.family<SpaceArchiveStats, String>((ref, spaceId) async {
  final db = ref.watch(appDatabaseProvider);
  final acc = await db.customSelect(
    'SELECT COUNT(*) AS c, COALESCE(SUM(current_balance), 0) AS b '
    'FROM accounts WHERE space_id = ?',
    variables: [Variable.withString(spaceId)],
    readsFrom: {db.accounts},
  ).getSingle();
  final tx = await db.customSelect(
    'SELECT COUNT(*) AS c FROM transactions WHERE space_id = ?',
    variables: [Variable.withString(spaceId)],
    readsFrom: {db.transactions},
  ).getSingle();
  final goals = await db.customSelect(
    'SELECT COUNT(*) AS c FROM savings_goals WHERE space_id = ?',
    variables: [Variable.withString(spaceId)],
    readsFrom: {db.savingsGoals},
  ).getSingle();
  return SpaceArchiveStats(
    accountsCount: acc.read<int>('c'),
    transactionsCount: tx.read<int>('c'),
    goalsCount: goals.read<int>('c'),
    totalBalanceKopecks: acc.read<int>('b'),
  );
});

final spaceArchiveAccountsProvider =
    StreamProvider.family<List<Account>, String>((ref, spaceId) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.accounts)
        ..where((t) => t.spaceId.equals(spaceId))
        ..orderBy([(t) => OrderingTerm.asc(t.customName)]))
      .watch();
});

final spaceArchiveTransactionsProvider =
    StreamProvider.family<List<TransactionDb>, String>((ref, spaceId) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.transactions)
        ..where((t) => t.spaceId.equals(spaceId))
        ..orderBy([(t) => OrderingTerm.desc(t.date)])
        ..limit(200))
      .watch();
});

final spaceArchiveGoalsProvider =
    StreamProvider.family<List<SavingsGoalDb>, String>((ref, spaceId) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.savingsGoals)
        ..where((t) => t.spaceId.equals(spaceId))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
});

final spaceArchiveDebtsProvider =
    StreamProvider.family<List<DebtDb>, String>((ref, spaceId) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.debts)
        ..where((t) => t.spaceId.equals(spaceId))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
});