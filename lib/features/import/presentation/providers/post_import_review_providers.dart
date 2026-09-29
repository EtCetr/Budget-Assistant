import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';

/// Категории расхода для dropdown (Drift в провайдере, не в UI).
final reviewCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  return (db.select(db.categories)
        ..where((c) => c.userId.equals(userId) & c.type.equals('expense'))
        ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
      .get();
});

/// Целевой счёт импорта (для баннера).
final reviewTargetAccountProvider =
    FutureProvider.family<Account?, String>((ref, accountId) async {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.accounts)
        ..where((a) => a.id.equals(accountId)))
      .getSingleOrNull();
});