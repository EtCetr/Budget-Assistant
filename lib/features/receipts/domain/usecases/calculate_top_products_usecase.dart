import 'package:logger/logger.dart';
import '../entities/product_analytics_cache_entry.dart';
import '../entities/product_analytics_models.dart';
import 'calculate_price_trend_usecase.dart';

/// Отчёт «Топ товаров» (ТЗ 6.3.24.5): группировка кэша по product_hash,
/// ранжирование по числу покупок, затем по суммарным тратам.
class CalculateTopProductsUseCase {
  CalculateTopProductsUseCase({
    required CalculatePriceTrendUseCase trendUseCase,
    required Logger logger,
  })  : _trendUseCase = trendUseCase,
        _logger = logger;

  final CalculatePriceTrendUseCase _trendUseCase;
  final Logger _logger;

  List<TopProduct> call({
    required List<ProductAnalyticsCacheEntry> entries,
    required Map<String, String> namesByHash,
  }) {
    try {
      final byHash = <String, _Agg>{};
      for (final e in entries) {
        final agg = byHash.putIfAbsent(
          e.productHash,
          () => _Agg(hash: e.productHash),
        );
        agg.purchases += e.purchases;
        agg.spend += e.totalSpendKopecks;
        agg.quantity += e.totalQuantity;
        agg.byDay[e.day] = e;
        agg.categoryId ??= e.categoryId;
        if (agg.firstSeen.isEmpty || e.day.compareTo(agg.firstSeen) < 0) {
          agg.firstSeen = e.day;
        }
        if (agg.lastSeen.isEmpty || e.day.compareTo(agg.lastSeen) > 0) {
          agg.lastSeen = e.day;
        }
      }
      final result = <TopProduct>[];
      for (final agg in byHash.values) {
        final points = <PricePoint>[
          for (final e in agg.byDay.values)
            PricePoint(day: e.day, priceKopecks: e.avgPriceKopecks),
        ]..sort((a, b) => a.day.compareTo(b.day));
        result.add(
          TopProduct(
            productHash: agg.hash,
            name: namesByHash[agg.hash] ?? agg.hash.substring(0, 8),
            categoryId: agg.categoryId,
            purchases: agg.purchases,
            totalSpendKopecks: agg.spend,
            totalQuantity: agg.quantity,
            avgPriceKopecks:
                agg.quantity > 0 ? (agg.spend / agg.quantity).round() : 0,
            trend: _trendUseCase(points),
            points: points,
            firstSeen: agg.firstSeen,
            lastSeen: agg.lastSeen,
          ),
        );
      }
      result.sort((a, b) {
        final c = b.purchases.compareTo(a.purchases);
        if (c != 0) return c;
        return b.totalSpendKopecks.compareTo(a.totalSpendKopecks);
      });
      return result;
    } catch (e, st) {
      _logger.e('CalculateTopProducts failed', error: e, stackTrace: st);
      return const [];
    }
  }
}

class _Agg {
  _Agg({required this.hash});

  final String hash;
  final Map<String, ProductAnalyticsCacheEntry> byDay = {};
  int purchases = 0;
  int spend = 0;
  double quantity = 0;
  String? categoryId;
  String firstSeen = '';
  String lastSeen = '';
}