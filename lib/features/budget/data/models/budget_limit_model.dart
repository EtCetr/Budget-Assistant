import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_limit_model.freezed.dart';
part 'budget_limit_model.g.dart';

@freezed
abstract class BudgetLimitModel with _$BudgetLimitModel {
  const factory BudgetLimitModel({
    required String id,
    String? spaceId,
    required String userId,
    required String categoryId,
    required int year,
    required int month,
    required int limitAmount,
    @Default(80) int alertPercent,
    @Default(0) int alertAmount,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('pending') String syncStatus,
  }) = _BudgetLimitModel;

  factory BudgetLimitModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetLimitModelFromJson(json);
}