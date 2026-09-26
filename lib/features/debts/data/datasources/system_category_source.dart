import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../../domain/services/system_category_port.dart';

/// Реализация порта системных категорий напрямую через Drift
/// (categories.is_system = TRUE, ТОМ 2 §4.1).
class SystemCategorySource implements SystemCategoryPort {
  SystemCategorySource({required AppDatabase db, required Logger logger})
      : _db = db,
        _logger = logger;

  final AppDatabase _db;
  final Logger _logger;

  static const String debtRepaymentName = 'SYSTEM_DEBT_REPAYMENT';

  @override
  Future<String> getOrCreateDebtRepaymentCategory({
    required String userId,
  }) async {
    try {
      final existing = await (_db.select(_db.categories)
            ..where((c) =>
                c.userId.equals(userId) & c.name.equals(debtRepaymentName))
            ..limit(1))
          .getSingleOrNull();
      if (existing != null) return existing.id;
      final now = DateTime.now().toUtc();
      final id = 'cat_sys_debt_repayment_$userId';
      await _db.into(_db.categories).insertOnConflictUpdate(
            CategoriesCompanion.insert(
              id: id,
              userId: userId,
              name: debtRepaymentName,
              type: 'expense',
              isSystem: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );
      return id;
    } catch (e, st) {
      _logger.e('getOrCreateDebtRepaymentCategory failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}