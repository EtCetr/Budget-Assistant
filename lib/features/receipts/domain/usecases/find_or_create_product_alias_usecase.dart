import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../entities/product_alias.dart';
import '../repositories/product_aliases_repository.dart';
import 'hash_product_name_usecase.dart';

/// Поиск алиаса по хэшу (space ИЛИ global-null); нет -> создание.
/// usage_count инкрементируется при каждом попадании.
class FindOrCreateProductAliasUseCase {
  final ProductAliasesRepository _repo;
  final HashProductNameUseCase _hash;
  final Logger _logger;
  static const _uuid = Uuid();

  FindOrCreateProductAliasUseCase(this._repo, this._hash, this._logger);

  Future<ProductAlias?> call({
    required String originalName,
    required String categoryId,
    required String userId,
    String? spaceId,
  }) async {
    try {
      final hash = _hash(originalName);
      final found = await _repo.findByHash(hash: hash, currentSpaceId: spaceId ?? '');
      if (found != null) {
        await _repo.incrementUsageCount(found.id);
        return found.copyWith(usageCount: found.usageCount + 1);
      }
      final now = DateTime.now().toUtc();
      final alias = ProductAlias(
        id: _uuid.v4(),
        userId: userId,
        spaceId: spaceId,
        originalNameHash: hash,
        normalizedName: normalizeName(originalName),
        categoryId: categoryId,
        usageCount: 1,
        createdAt: now,
        updatedAt: now,
        syncStatus: SyncStatus.pending,
      );
      await _repo.createAlias(alias);
      return alias;
    } catch (e, stack) {
      _logger.e('FindOrCreateProductAlias failed', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Нормализация: lowercase, схлопывание пробелов, trim.
  static String normalizeName(String s) =>
      s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}