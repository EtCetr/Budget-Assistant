// lib/features/categories/domain/entities/category.dart
import '../../data/models/category_model.dart';

class Category {
  final String id;
  final String? spaceId;
  final String userId;
  final String? parentId;
  final String name;
  final String type; // 'expense', 'income', 'transfer'
  final String? iconEmoji;
  final String? colorHex;
  final bool isPinnedForCashback;
  final bool isSystem;
  final int? sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;

  Category({
    required this.id,
    this.spaceId,
    required this.userId,
    this.parentId,
    required this.name,
    required this.type,
    this.iconEmoji,
    this.colorHex,
    this.isPinnedForCashback = false,
    this.isSystem = false,
    this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'pending',
  });

  factory Category.fromModel(CategoryModel model) {
    return Category(
      id: model.id,
      spaceId: model.spaceId,
      userId: model.userId,
      parentId: model.parentId,
      name: model.name,
      type: model.type,
      iconEmoji: model.iconEmoji,
      colorHex: model.colorHex,
      isPinnedForCashback: model.isPinnedForCashback,
      isSystem: model.isSystem,
      sortOrder: model.sortOrder,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      syncStatus: model.syncStatus,
    );
  }

  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      spaceId: spaceId,
      userId: userId,
      parentId: parentId,
      name: name,
      type: type,
      iconEmoji: iconEmoji,
      colorHex: colorHex,
      isPinnedForCashback: isPinnedForCashback,
      isSystem: isSystem,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
    );
  }

  Category copyWith({
    String? id,
    String? spaceId,
    String? userId,
    String? parentId,
    String? name,
    String? type,
    String? iconEmoji,
    String? colorHex,
    bool? isPinnedForCashback,
    bool? isSystem,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
  }) {
    return Category(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      userId: userId ?? this.userId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      type: type ?? this.type,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      colorHex: colorHex ?? this.colorHex,
      isPinnedForCashback: isPinnedForCashback ?? this.isPinnedForCashback,
      isSystem: isSystem ?? this.isSystem,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  bool get isRoot => parentId == null;
  bool get isExpense => type == 'expense';
  bool get isIncome => type == 'income';
  bool get isTransfer => type == 'transfer';
}
