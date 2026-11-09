// lib/features/profile/presentation/providers/profile_providers.dart
// Этап 21 (ТЗ 6.3.39): провайдеры полного профиля.
import 'package:drift/drift.dart' show Variable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/providers/transactions_trigger_provider.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:budget_assistant/features/year_in_review/presentation/providers/year_in_review_providers.dart';

/// Read-only сводка 2×2 (ТЗ 6.3.39.4).
class ProfileStats {
  const ProfileStats({
    required this.spacesCount,
    required this.accountsCount,
    required this.transactionsCount,
    required this.goalsCount,
  });

  final int spacesCount;
  final int accountsCount;
  final int transactionsCount;
  final int goalsCount;
}

final userProfileProvider = StreamProvider<User?>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  return ref.watch(appDatabaseProvider).usersDao.watchById(userId);
});

final profileStatsProvider = FutureProvider<ProfileStats>((ref) async {
  ref.watch(transactionsTriggerProvider);
  final userId = ref.watch(currentUserIdProvider);
  final db = ref.watch(appDatabaseProvider);
  final m = await db.customSelect(
    'SELECT COUNT(*) AS c FROM memberships '
    'WHERE user_id = ? AND status = ?',
    variables: [Variable.withString(userId), Variable.withString('active')],
    readsFrom: {db.memberships},
  ).getSingle();
  final a = await db.customSelect(
    'SELECT COUNT(*) AS c FROM accounts WHERE user_id = ?',
    variables: [Variable.withString(userId)],
    readsFrom: {db.accounts},
  ).getSingle();
  final t = await db.customSelect(
    'SELECT COUNT(*) AS c FROM transactions WHERE user_id = ?',
    variables: [Variable.withString(userId)],
    readsFrom: {db.transactions},
  ).getSingle();
  final g = await db.customSelect(
    'SELECT COUNT(*) AS c FROM savings_goals '
    'WHERE user_id = ? AND status = ?',
    variables: [Variable.withString(userId), Variable.withString('active')],
    readsFrom: {db.savingsGoals},
  ).getSingle();
  return ProfileStats(
    spacesCount: m.read<int>('c'),
    accountsCount: a.read<int>('c'),
    transactionsCount: t.read<int>('c'),
    goalsCount: g.read<int>('c'),
  );
});

/// Суммарный баланс счетов пространства (копейки).
final spaceBalanceProvider = StreamProvider.family<int, String>((ref, spaceId) {
  final db = ref.watch(appDatabaseProvider);
  return db.customSelect(
    'SELECT COALESCE(SUM(current_balance), 0) AS b '
    'FROM accounts WHERE space_id = ?',
    variables: [Variable.withString(spaceId)],
    readsFrom: {db.accounts},
  ).watch().map((rows) => rows.first.read<int>('b'));
});

/// Год с непросмотренной статистикой для бейджа «🆕» (ТЗ 6.3.39.6):
/// агрегат существует, is_viewed = FALSE и наступило 27 декабря того года.
final yearReviewBadgeYearProvider = FutureProvider<int?>((ref) async {
  try {
    final dao = ref.watch(yearlyAggregatesDaoProvider);
    final userId = ref.watch(currentUserIdProvider);
    final byYear = await dao.personalAggregatesByYear(userId);
    final now = DateTime.now();
    final years = byYear.keys.toList()..sort((a, b) => b.compareTo(a));
    for (final year in years) {
      final agg = byYear[year];
      if (agg == null || agg.isViewed) continue;
      if (now.isAfter(DateTime(year, 12, 27))) return year;
    }
    return null;
  } catch (e, st) {
    AppLogger.e('yearReviewBadgeYear failed', e, st);
    return null;
  }
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>(
  (ref) => UpdateProfileUseCase(db: ref.watch(appDatabaseProvider)),
);

final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>(
  (ref) => DeleteAccountUseCase(
    db: ref.watch(appDatabaseProvider),
    storage: SecureStorageService(),
  ),
);