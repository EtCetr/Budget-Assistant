// lib/features/receipts/domain/usecases/product_aliases_settings_usecases.dart
// Этап 21 (ТЗ 6.3.38.6): редактирование и удаление алиасов товаров.
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/receipts/data/datasources/product_aliases_dao.dart';

class UpdateProductAliasUseCase {
  const UpdateProductAliasUseCase({required AppDatabase db}) : _db = db;

  final AppDatabase _db;

  Future<void> call({
    required String id,
    required String normalizedName,
    required String categoryId,
  }) async {
    final name = normalizedName.trim();
    if (name.isEmpty) {
      throw StateError('Название товара не может быть пустым');
    }
    try {
      await ProductAliasesDao(_db).updateFields(
        id,
        name,
        categoryId,
      );
      AppLogger.i('Product alias updated: $id');
    } catch (e, st) {
      AppLogger.e('UpdateProductAlias failed', e, st);
      rethrow;
    }
  }
}

class DeleteProductAliasUseCase {
  const DeleteProductAliasUseCase({required AppDatabase db}) : _db = db;

  final AppDatabase _db;

  Future<void> call(String id) async {
    try {
      await ProductAliasesDao(_db).deleteById(id);
      AppLogger.i('Product alias deleted: $id');
    } catch (e, st) {
      AppLogger.e('DeleteProductAlias failed', e, st);
      rethrow;
    }
  }
}