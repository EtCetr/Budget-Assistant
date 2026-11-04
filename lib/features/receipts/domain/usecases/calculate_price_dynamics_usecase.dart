import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../entities/product_analytics_cache_entry.dart';
import '../entities/product_analytics_models.dart';

/// Отчёт «Динамика цен» (ТЗ 6.3.24.5, отчёт 3): товары, покупавшиеся
/// минимум в 3 разных месяца периода; метрика — изменение средней цены
/// между первым и последним месяцем; сортировка по модулю изменения.
class CalculatePriceDynamicsUseCase {
  CalculatePriceDynamicsUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  List<PriceChangeEntry> call({
    required List<ProductAnalyticsCacheEntry> entries,
    required Map<String, String> namesByHash,
  }) {
    try {
      final byHash = <String, Map<String, (int, double)>>{};
      for (final e in entries) {
        final month = e.day.length >= 7 ? e.day.substring(0, 7) : e.day;
        final months = byHash.putIfAbsent(e.productHash, () => {});
        final cur = months[month] ?? (0, 0.0);
        months[month] = (cur.$1 + e.totalSpendKopecks, cur.$2 + e.totalQuantity);
      }
      final fmt = DateFormat('MMM yyyy', 'ru');
      final result = <PriceChangeEntry>[];
      for (final entry in byHash.entries) {
        final months = entry.value.keys.toList()..sort();
        if (months.length < 3) continue;
        int avgOf(String m) {
          final v = entry.value[m]!;
          return v.$2 > 0 ? (v.$1 / v.$2).round() : 0;
        }
        final firstAvg = avgOf(months.first);
        final lastAvg = avgOf(months.last);
        if (firstAvg == 0) continue;
        final points = <PricePoint>[
          for (final m in months)
            PricePoint(day: '$m-01', priceKopecks: avgOf(m)),
        ];
        result.add(
          PriceChangeEntry(
            productHash: entry.key,
            name: namesByHash[entry.key] ?? entry.key.substring(0, 8),
            categoryId: null,
            firstMonthLabel: fmt.format(_monthDate(months.first)),
            firstPriceKopecks: firstAvg,
            lastMonthLabel: fmt.format(_monthDate(months.last)),
            lastPriceKopecks: lastAvg,
            changePercent: (lastAvg - firstAvg) / firstAvg * 100,
            changeAbsKopecks: lastAvg - firstAvg,
            points: points,
          ),
        );
      }
      result.sort((a, b) =>
          b.changePercent.abs().compareTo(a.changePercent.abs()));
      return result;
    } catch (e, st) {
      _logger.e('CalculatePriceDynamics failed', error: e, stackTrace: st);
      return const [];
    }
  }

  DateTime _monthDate(String month) {
    final parts = month.split('-');
    return DateTime(
      int.tryParse(parts.elementAtOrNull(0) ?? '') ?? 1970,
      int.tryParse(parts.elementAtOrNull(1) ?? '') ?? 1,
    );
  }
}