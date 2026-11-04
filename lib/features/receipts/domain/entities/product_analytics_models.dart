import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_analytics_models.freezed.dart';

/// Тренд цены (линейная регрессия, ТЗ 6.3.24.12.5).
enum PriceTrend { rising, stable, falling }

/// Скоуп аналитики (Multi-group, ТЗ 6.3.24.4).
enum ProductAnalyticsScope { personal, family }

/// Точка ценового ряда (day = 'YYYY-MM-DD').
@freezed
abstract class PricePoint with _$PricePoint {
  const factory PricePoint({
    required String day,
    required int priceKopecks,
  }) = _PricePoint;
}

/// Позиция отчёта «Топ товаров» (ТЗ 6.3.24.5).
@freezed
abstract class TopProduct with _$TopProduct {
  const factory TopProduct({
    required String productHash,
    required String name,
    String? categoryId,
    required int purchases,
    required int totalSpendKopecks,
    required double totalQuantity,
    required int avgPriceKopecks,
    required PriceTrend trend,
    required List<PricePoint> points,
    required String firstSeen,
    required String lastSeen,
  }) = _TopProduct;
}

/// Позиция отчёта «Категории товаров».
@freezed
abstract class TopCategory with _$TopCategory {
  const factory TopCategory({
    required String categoryId,
    required int totalSpendKopecks,
    required int uniqueProducts,
    required double avgQuantityPerPurchase,
    required double percent,
  }) = _TopCategory;
}

/// Позиция отчёта «Динамика цен».
@freezed
abstract class PriceChangeEntry with _$PriceChangeEntry {
  const factory PriceChangeEntry({
    required String productHash,
    required String name,
    String? categoryId,
    required String firstMonthLabel,
    required int firstPriceKopecks,
    required String lastMonthLabel,
    required int lastPriceKopecks,
    required double changePercent,
    required int changeAbsKopecks,
    required List<PricePoint> points,
  }) = _PriceChangeEntry;
}

/// Разбивка покупок товара по магазинам (детальная аналитика).
@freezed
abstract class StoreBreakdown with _$StoreBreakdown {
  const factory StoreBreakdown({
    required String storeName,
    required int purchases,
    required int avgPriceKopecks,
  }) = _StoreBreakdown;
}

/// Детальная аналитика одного товара (ТЗ 6.3.24.6).
@freezed
abstract class ProductDetails with _$ProductDetails {
  const factory ProductDetails({
    required String productHash,
    required String name,
    String? categoryId,
    required int purchases,
    required int totalSpendKopecks,
    required List<PricePoint> points,
    required int minPriceKopecks,
    required String minDay,
    required int maxPriceKopecks,
    required String maxDay,
    required int avgPriceKopecks,
    required PriceTrend trend,
    required double volatilityKopecks,
    required List<StoreBreakdown> stores,
  }) = _ProductDetails;
}

/// Сводка экрана: уникальных товаров + среднее число позиций в чеке.
@freezed
abstract class ProductAnalyticsSummary with _$ProductAnalyticsSummary {
  const factory ProductAnalyticsSummary({
    required int uniqueProducts,
    required double avgItemsPerCheck,
    required int checksCount,
  }) = _ProductAnalyticsSummary;
}