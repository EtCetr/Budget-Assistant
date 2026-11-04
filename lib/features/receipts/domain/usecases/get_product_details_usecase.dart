import 'dart:math' as math;

import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:logger/logger.dart';
import '../../data/datasources/product_analytics_source_dao.dart';
import '../entities/product_analytics_models.dart';
import '../services/product_hash_util.dart';
import 'calculate_price_trend_usecase.dart';

/// Детальная аналитика товара (ТЗ 6.3.24.6): история цены по дням,
/// мин/макс/средняя, волатильность (stddev), разбивка по магазинам.
/// Считается из сырых чеков (кэш не хранит разбивку по магазинам).
class GetProductDetailsUseCase {
  GetProductDetailsUseCase({
    required ProductAnalyticsSourceDao sourceDao,
    required CalculatePriceTrendUseCase trendUseCase,
    required Logger logger,
  })  : _sourceDao = sourceDao,
        _trendUseCase = trendUseCase,
        _logger = logger;

  final ProductAnalyticsSourceDao _sourceDao;
  final CalculatePriceTrendUseCase _trendUseCase;
  final Logger _logger;

  Future<Result<ProductDetails?>> call({
    required String userId,
    required String productHash,
    required Map<String, String> namesByHash,
    String? categoryId,
  }) async {
    try {
      final receipts = await _sourceDao.receiptsByUser(userId);
      final byId = {for (final r in receipts) r.id: r};
      final items = await _sourceDao.itemsForReceipts(byId.keys.toList());
      final dayAgg = <String, (int, double)>{};
      final storeAgg = <String, _Store>{};
      final countedReceipts = <String>{};
      var purchases = 0;
      var totalSpend = 0;
      var totalQty = 0.0;
      for (final item in items) {
        if (item.isExcluded) continue;
        final norm = item.normalizedName;
        if (norm == null || norm.trim().isEmpty) continue;
        if (ProductHashUtil.hash(norm) != productHash) continue;
        final receipt = byId[item.receiptId];
        if (receipt == null || receipt.status == 'draft') continue;
        final local = receipt.receiptDate.toLocal();
        final day = '${local.year.toString().padLeft(4, '0')}-'
            '${local.month.toString().padLeft(2, '0')}-'
            '${local.day.toString().padLeft(2, '0')}';
        final d = dayAgg[day] ?? (0, 0.0);
        dayAgg[day] = (d.$1 + item.totalPrice, d.$2 + item.quantity);
        final s = storeAgg.putIfAbsent(receipt.storeName, () => _Store());
        s.receiptIds.add(receipt.id);
        s.spend += item.totalPrice;
        s.qty += item.quantity;
        if (countedReceipts.add(receipt.id)) purchases += 1;
        totalSpend += item.totalPrice;
        totalQty += item.quantity;
      }
      if (dayAgg.isEmpty) return const Success(null);
      final points = <PricePoint>[
        for (final e in dayAgg.entries)
          PricePoint(
            day: e.key,
            priceKopecks: e.value.$2 > 0
                ? (e.value.$1 / e.value.$2).round()
                : 0,
          ),
      ]..sort((a, b) => a.day.compareTo(b.day));
      var minPoint = points.first;
      var maxPoint = points.first;
      for (final p in points) {
        if (p.priceKopecks < minPoint.priceKopecks) minPoint = p;
        if (p.priceKopecks > maxPoint.priceKopecks) maxPoint = p;
      }
      final avg = totalQty > 0 ? (totalSpend / totalQty).round() : 0;
      final mean = points.isEmpty
          ? 0.0
          : points.map((p) => p.priceKopecks).reduce((a, b) => a + b) /
              points.length;
      final variance = points.isEmpty
          ? 0.0
          : points
                  .map((p) => (p.priceKopecks - mean) * (p.priceKopecks - mean))
                  .reduce((a, b) => a + b) /
              points.length;
      final stores = <StoreBreakdown>[
        for (final e in storeAgg.entries)
          StoreBreakdown(
            storeName: e.key,
            purchases: e.value.receiptIds.length,
            avgPriceKopecks:
                e.value.qty > 0 ? (e.value.spend / e.value.qty).round() : 0,
          ),
      ]..sort((a, b) => b.purchases.compareTo(a.purchases));
      return Success(
        ProductDetails(
          productHash: productHash,
          name: namesByHash[productHash] ?? productHash.substring(0, 8),
          categoryId: categoryId,
          purchases: purchases,
          totalSpendKopecks: totalSpend,
          points: points,
          minPriceKopecks: minPoint.priceKopecks,
          minDay: minPoint.day,
          maxPriceKopecks: maxPoint.priceKopecks,
          maxDay: maxPoint.day,
          avgPriceKopecks: avg,
          trend: _trendUseCase(points),
          volatilityKopecks: math.sqrt(variance),
          stores: stores,
        ),
      );
    } catch (e, st) {
      _logger.e('GetProductDetails failed', error: e, stackTrace: st);
      return Error(Failure.database('Не удалось загрузить детализацию: $e'));
    }
  }
}

class _Store {
  final Set<String> receiptIds = {};
  int spend = 0;
  double qty = 0;
}