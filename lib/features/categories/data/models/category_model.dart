// lib/features/categories/data/models/category_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    String? spaceId,
    required String userId,
    String? parentId,
    required String name,
    required String type,
    String? iconEmoji,
    String? colorHex,
    @Default(false) bool isPinnedForCashback,
    @Default(false) bool isSystem,
    int? sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('pending') String syncStatus,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
