import '../../data/models/budget_limit_model.dart';

class BudgetLimit {
  final String id;
  final String? spaceId;
  final String userId;
  final String categoryId;
  final int year;
  final int month;
  final int limitAmount;
  final int alertPercent;
  final int alertAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;

  BudgetLimit({
    required this.id,
    this.spaceId,
    required this.userId,
    required this.categoryId,
    required this.year,
    required this.month,
    required this.limitAmount,
    this.alertPercent = 80,
    this.alertAmount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'pending',
  });

  factory BudgetLimit.fromModel(BudgetLimitModel model) {
    return BudgetLimit(
      id: model.id,
      spaceId: model.spaceId,
      userId: model.userId,
      categoryId: model.categoryId,
      year: model.year,
      month: model.month,
      limitAmount: model.limitAmount,
      alertPercent: model.alertPercent,
      alertAmount: model.alertAmount,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      syncStatus: model.syncStatus,
    );
  }

  BudgetLimitModel toModel() {
    return BudgetLimitModel(
      id: id,
      spaceId: spaceId,
      userId: userId,
      categoryId: categoryId,
      year: year,
      month: month,
      limitAmount: limitAmount,
      alertPercent: alertPercent,
      alertAmount: alertAmount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
    );
  }
}