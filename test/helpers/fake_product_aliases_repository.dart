import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/receipts/domain/entities/product_alias.dart';
import 'package:budget_assistant/features/receipts/domain/repositories/product_aliases_repository.dart';

/// Этап 24: заглушка репозитория алиасов товаров.
/// findByHash повторяет SQL: space_id = currentSpaceId ИЛИ space_id IS NULL.
class FakeProductAliasesRepository implements ProductAliasesRepository {
  final Map<String, ProductAlias> aliases = <String, ProductAlias>{};

  Object? error;
  final List<String> calls = <String>[];
  final List<String> incremented = <String>[];
  String? lastHash;
  String? lastSpaceId;

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  @override
  Future<void> createAlias(ProductAlias alias) async {
    _enter('createAlias');
    aliases[alias.id] = alias;
  }

  @override
  Future<void> updateAlias(ProductAlias alias) async {
    _enter('updateAlias');
    aliases[alias.id] = alias;
  }

  @override
  Future<void> deleteAlias(String id) async {
    _enter('deleteAlias');
    aliases.remove(id);
  }

  @override
  Future<ProductAlias?> findByHash({
    required String hash,
    required String currentSpaceId,
  }) async {
    _enter('findByHash');
    lastHash = hash;
    lastSpaceId = currentSpaceId;
    for (final a in aliases.values) {
      if (a.originalNameHash != hash) continue;
      if (a.spaceId == null || a.spaceId == currentSpaceId) return a;
    }
    return null;
  }

  @override
  Future<void> incrementUsageCount(String id) async {
    _enter('incrementUsageCount');
    incremented.add(id);
    final a = aliases[id];
    if (a != null) {
      aliases[id] = a.copyWith(usageCount: a.usageCount + 1);
    }
  }
}

/// Фабрика алиаса товара для тестов.
ProductAlias makeAlias({
  required String id,
  required String hash,
  String normalizedName = 'молоко',
  String categoryId = 'c1',
  String userId = 'u1',
  String? spaceId,
  int usageCount = 1,
}) =>
    ProductAlias(
      id: id,
      userId: userId,
      spaceId: spaceId,
      originalNameHash: hash,
      normalizedName: normalizedName,
      categoryId: categoryId,
      usageCount: usageCount,
      createdAt: DateTime.utc(2026, 7, 1),
      updatedAt: DateTime.utc(2026, 7, 1),
      syncStatus: SyncStatus.pending,
    );