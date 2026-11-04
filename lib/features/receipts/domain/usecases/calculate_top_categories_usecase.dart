import 'package:logger/logger.dart';
import '../entities/product_analytics_models.dart';

/// Отчёт «Категории товаров»: группировка топ-товаров по category_id,
/// ранжирование по суммарным тратам (ТЗ 6.3.24.5, отчёт 2).
class CalculateTopCategoriesUseCase {
  CalculateTopCategoriesUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  List<TopCategory> call({
    required List<TopProduct> products,
    required int totalSpendKopecks,
  }) {
    try {
      final byCat = <String, _Agg>{};
      for (final p in products) {
        final key = p.categoryId ?? 'other';
        final agg = byCat.putIfAbsent(key, () => _Agg());
        agg.spend += p.totalSpendKopecks;
        agg.purchases += p.purchases;
        agg.quantity += p.totalQuantity;
        agg.unique += 1;
      }
      final result = <TopCategory>[
        for (final entry in byCat.entries)
          TopCategory(
            categoryId: entry.key,
            totalSpendKopecks: entry.value.spend,
            uniqueProducts: entry.value.unique,
            avgQuantityPerPurchase: entry.value.purchases > 0
                ? entry.value.quantity / entry.value.purchases
                : 0,
            percent: totalSpendKopecks > 0
                ? entry.value.spend / totalSpendKopecks * 100
                : 0,
          ),
      ];
      result.sort((a, b) => b.totalSpendKopecks.compareTo(a.totalSpendKopecks));
      return result;
    } catch (e, st) {
      _logger.e('CalculateTopCategories failed', error: e, stackTrace: st);
      return const [];
    }
  }
}

class _Agg {
  int spend = 0;
  int purchases = 0;
  double quantity = 0;
  int unique = 0;
}