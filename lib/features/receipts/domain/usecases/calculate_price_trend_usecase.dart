import 'package:logger/logger.dart';
import '../entities/product_analytics_models.dart';

/// Линейная регрессия тренда цены (ТЗ 6.3.24.12.5):
/// rising при относительном изменении > +5%, falling при < -5%, иначе stable.
/// Минимум 3 точки, иначе stable.
class CalculatePriceTrendUseCase {
  CalculatePriceTrendUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  PriceTrend call(List<PricePoint> points) {
    try {
      if (points.length < 3) return PriceTrend.stable;
      final sorted = [...points]..sort((a, b) => a.day.compareTo(b.day));
      final first = _parseDay(sorted.first.day);
      final xs = <double>[
        for (final p in sorted)
          _parseDay(p.day).difference(first).inDays.toDouble(),
      ];
      final ys = <double>[for (final p in sorted) p.priceKopecks.toDouble()];
      final n = xs.length.toDouble();
      final meanX = xs.reduce((a, b) => a + b) / n;
      final meanY = ys.reduce((a, b) => a + b) / n;
      var numerator = 0.0;
      var denominator = 0.0;
      for (var i = 0; i < xs.length; i++) {
        numerator += (xs[i] - meanX) * (ys[i] - meanY);
        denominator += (xs[i] - meanX) * (xs[i] - meanX);
      }
      if (denominator == 0 || meanY == 0) return PriceTrend.stable;
      final coefficient = numerator / denominator;
      final spanDays =
          _parseDay(sorted.last.day).difference(first).inDays.toDouble();
      if (spanDays == 0) return PriceTrend.stable;
      final relativeChange = coefficient * spanDays / meanY;
      if (relativeChange > 0.05) return PriceTrend.rising;
      if (relativeChange < -0.05) return PriceTrend.falling;
      return PriceTrend.stable;
    } catch (e, st) {
      _logger.e('CalculatePriceTrend failed', error: e, stackTrace: st);
      return PriceTrend.stable;
    }
  }

  DateTime _parseDay(String day) {
    final parts = day.split('-');
    return DateTime(
      int.tryParse(parts.elementAtOrNull(0) ?? '') ?? 1970,
      int.tryParse(parts.elementAtOrNull(1) ?? '') ?? 1,
      int.tryParse(parts.elementAtOrNull(2) ?? '') ?? 1,
    );
  }
}