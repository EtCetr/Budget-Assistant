// lib/features/receipts/presentation/providers/product_aliases_settings_providers.dart
// Этап 21 (ТЗ 6.3.38.6): провайдеры экрана алиасов товаров.
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/providers/member_color_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/receipts/data/datasources/product_aliases_dao.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/product_aliases_settings_usecases.dart';

final productAliasesDaoProvider = Provider<ProductAliasesDao>(
  (ref) => ProductAliasesDao(ref.watch(appDatabaseProvider)),
);

final updateProductAliasUseCaseProvider = Provider<UpdateProductAliasUseCase>(
  (ref) => UpdateProductAliasUseCase(db: ref.watch(appDatabaseProvider)),
);

final deleteProductAliasUseCaseProvider = Provider<DeleteProductAliasUseCase>(
  (ref) => DeleteProductAliasUseCase(db: ref.watch(appDatabaseProvider)),
);

/// Режим фильтра: 'all' | 'mine' | 'family'.
final productAliasesProvider =
    StreamProvider.family<List<ProductAliasDb>, String>((ref, mode) {
  final userId = ref.watch(currentUserIdProvider);
  final scope = ref.watch(memberColorSpaceScopeProvider);
  final db = ref.watch(appDatabaseProvider);
  final q = db.select(db.productAliases)
    ..where((a) => a.userId.equals(userId));
  if (mode == 'mine') {
    q.where((a) => a.spaceId.isNull());
  } else if (mode == 'family') {
    if (scope.isEmpty) {
      q.where((a) => const Constant(false).equals(true));
    } else {
      q.where((a) => a.spaceId.equals(scope));
    }
  }
  q.orderBy([(a) => OrderingTerm.desc(a.usageCount)]);
  return q.watch();
});

/// Категории для диалога редактирования алиаса.
final aliasCategoriesProvider = FutureProvider<List<Category>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final scope = ref.watch(memberColorSpaceScopeProvider);
  final db = ref.watch(appDatabaseProvider);
  final q = db.select(db.categories)
    ..where((c) => c.userId.equals(userId));
  if (scope.isNotEmpty) {
    q.where((c) => c.spaceId.equals(scope) | c.spaceId.isNull());
  }
  return q.get();
});