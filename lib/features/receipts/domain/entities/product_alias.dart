import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'product_alias.freezed.dart';

@freezed
abstract class ProductAlias with _$ProductAlias {
  const factory ProductAlias({
    required String id,
    required String userId,
    String? spaceId,
    required String originalNameHash,
    required String normalizedName,
    required String categoryId,
    required int usageCount,
    required DateTime createdAt,
    required DateTime updatedAt,
    required SyncStatus syncStatus,
  }) = _ProductAlias;
}