import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_analytics_cache_entry.freezed.dart';

/// Строка кэша аналитики товаров (ТЗ 6.3.24.12.2).
///
/// Отклонения D20:
/// - [day] = 'YYYY-MM-DD' (локальный день покупки) вместо DATE;
/// - [spaceId] = '' вместо NULL для личных чеков (уникальный индекс).
@freezed
abstract class ProductAnalyticsCacheEntry with _$ProductAnalyticsCacheEntry {
  const factory ProductAnalyticsCacheEntry({
    required String id,
    required String userId,
    @Default('') String spaceId,
    required String day,
    required String productHash,
    String? categoryId,
    @Default(0) int purchases,
    @Default(0) int totalSpendKopecks,

    /// Количество (не деньги — double допустим, ТОМ 2 §17.3).
    @Default(0.0) double totalQuantity,
    @Default(0) int avgPriceKopecks,
    required DateTime updatedAt,
  }) = _ProductAnalyticsCacheEntry;
}