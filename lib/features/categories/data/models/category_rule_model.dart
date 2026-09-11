// lib/features/categories/data/models/category_rule_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_rule_model.freezed.dart';
part 'category_rule_model.g.dart';

@freezed
abstract class CategoryRuleModel with _$CategoryRuleModel {
  const factory CategoryRuleModel({
    required String id,
    String? spaceId,
    required String userId,
    required String bankName,
    required String triggerString,
    required String targetCategoryId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('pending') String syncStatus,
  }) = _CategoryRuleModel;

  factory CategoryRuleModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryRuleModelFromJson(json);
}
