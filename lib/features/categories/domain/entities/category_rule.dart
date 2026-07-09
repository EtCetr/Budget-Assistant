// lib/features/categories/domain/entities/category_rule.dart
import '../../data/models/category_rule_model.dart';

class CategoryRule {
  final String id;
  final String? spaceId;
  final String userId;
  final String bankName; // 'ANY' or specific bank
  final String triggerString; // OPEN field for SQL LIKE
  final String targetCategoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;

  CategoryRule({
    required this.id,
    this.spaceId,
    required this.userId,
    required this.bankName,
    required this.triggerString,
    required this.targetCategoryId,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'pending',
  });

  factory CategoryRule.fromModel(CategoryRuleModel model) {
    return CategoryRule(
      id: model.id,
      spaceId: model.spaceId,
      userId: model.userId,
      bankName: model.bankName,
      triggerString: model.triggerString,
      targetCategoryId: model.targetCategoryId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      syncStatus: model.syncStatus,
    );
  }

  CategoryRuleModel toModel() {
    return CategoryRuleModel(
      id: id,
      spaceId: spaceId,
      userId: userId,
      bankName: bankName,
      triggerString: triggerString,
      targetCategoryId: targetCategoryId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
    );
  }

  CategoryRule copyWith({
    String? id,
    String? spaceId,
    String? userId,
    String? bankName,
    String? triggerString,
    String? targetCategoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
  }) {
    return CategoryRule(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      userId: userId ?? this.userId,
      bankName: bankName ?? this.bankName,
      triggerString: triggerString ?? this.triggerString,
      targetCategoryId: targetCategoryId ?? this.targetCategoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  /// Check if rule matches transaction
  bool matches({required String merchantName, required String bankName}) {
    final bankMatch = this.bankName == 'ANY' || this.bankName == bankName;
    final triggerMatch = merchantName.toLowerCase().contains(
      triggerString.toLowerCase(),
    );
    return bankMatch && triggerMatch;
  }
}
