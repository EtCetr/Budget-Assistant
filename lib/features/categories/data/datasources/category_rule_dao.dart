// lib/features/categories/data/datasources/category_rule_dao.dart
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/category_rule_model.dart';

part 'category_rule_dao.g.dart';

@DriftAccessor(tables: [CategoryRules])
class CategoryRuleDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryRuleDaoMixin {
  CategoryRuleDao(super.db);

  Future<List<CategoryRuleModel>> getRulesByBankAndSpace(
    String bankName,
    String? spaceId,
  ) async {
    try {
      final query = select(categoryRules);

      if (spaceId == null) {
        query.where(
          (t) => t.bankName.equals(bankName) | t.bankName.equals('ANY'),
        );
      } else {
        query.where(
          (t) =>
              (t.spaceId.equals(spaceId) | t.spaceId.isNull()) &
              (t.bankName.equals(bankName) | t.bankName.equals('ANY')),
        );
      }

      final results = await query.get();

      return results
          .map(
            (row) => CategoryRuleModel(
              id: row.id,
              spaceId: row.spaceId,
              userId: row.userId,
              bankName: row.bankName,
              triggerString: row.triggerString,
              targetCategoryId: row.targetCategoryId,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
              syncStatus: row.syncStatus,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get category rules: $e');
    }
  }

  Future<void> insertRule(CategoryRuleModel rule) async {
    try {
      await into(categoryRules).insert(
        CategoryRulesCompanion(
          id: Value(rule.id),
          spaceId: Value(rule.spaceId),
          userId: Value(rule.userId),
          bankName: Value(rule.bankName),
          triggerString: Value(rule.triggerString),
          targetCategoryId: Value(rule.targetCategoryId),
          createdAt: Value(rule.createdAt),
          updatedAt: Value(rule.updatedAt),
          syncStatus: Value(rule.syncStatus),
        ),
      );
    } catch (e) {
      throw Exception('Failed to insert category rule: $e');
    }
  }
}
