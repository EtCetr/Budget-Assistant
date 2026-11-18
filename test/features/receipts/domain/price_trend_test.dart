import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/receipts/domain/entities/product_analytics_models.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/calculate_price_trend_usecase.dart';

/// Этап 24: тренд цены — линейная регрессия (ТЗ 6.3.24.12.5).
/// rising при относительном изменении > +5%, falling при < -5%.
/// Минимум 3 точки, иначе stable.
void main() {
  late CalculatePriceTrendUseCase useCase;

  setUp(() {
    useCase = CalculatePriceTrendUseCase(logger: Logger(level: Level.off));
  });

  test('меньше трёх точек — stable', () {
    const points = [
      PricePoint(day: '2026-07-01', priceKopecks: 10000),
      PricePoint(day: '2026-07-02', priceKopecks: 20000),
    ];

    expect(useCase(points), PriceTrend.stable);
    expect(useCase(const []), PriceTrend.stable);
  });

  test('рост цены: 100 -> 110 -> 120', () {
    const points = [
      PricePoint(day: '2026-07-01', priceKopecks: 100),
      PricePoint(day: '2026-07-02', priceKopecks: 110),
      PricePoint(day: '2026-07-03', priceKopecks: 120),
    ];

    expect(useCase(points), PriceTrend.rising);
  });

  test('падение цены: 120 -> 110 -> 100', () {
    const points = [
      PricePoint(day: '2026-07-01', priceKopecks: 120),
      PricePoint(day: '2026-07-02', priceKopecks: 110),
      PricePoint(day: '2026-07-03', priceKopecks: 100),
    ];

    expect(useCase(points), PriceTrend.falling);
  });

  test('цена не меняется — stable', () {
    const points = [
      PricePoint(day: '2026-07-01', priceKopecks: 100),
      PricePoint(day: '2026-07-02', priceKopecks: 100),
      PricePoint(day: '2026-07-03', priceKopecks: 100),
    ];

    expect(useCase(points), PriceTrend.stable);
  });

  test('рост в пределах 5% считается стабильным', () {
    const points = [
      PricePoint(day: '2026-07-01', priceKopecks: 100),
      PricePoint(day: '2026-07-02', priceKopecks: 101),
      PricePoint(day: '2026-07-03', priceKopecks: 102),
    ];

    expect(useCase(points), PriceTrend.stable);
  });

  test('все точки в один день — stable (нет оси времени)', () {
    const points = [
      PricePoint(day: '2026-07-01', priceKopecks: 100),
      PricePoint(day: '2026-07-01', priceKopecks: 200),
      PricePoint(day: '2026-07-01', priceKopecks: 300),
    ];

    expect(useCase(points), PriceTrend.stable);
  });

  test('нулевые цены — stable без деления на ноль', () {
    const points = [
      PricePoint(day: '2026-07-01', priceKopecks: 0),
      PricePoint(day: '2026-07-02', priceKopecks: 0),
      PricePoint(day: '2026-07-03', priceKopecks: 0),
    ];

    expect(useCase(points), PriceTrend.stable);
  });

  test('порядок точек на входе не важен', () {
    const points = [
      PricePoint(day: '2026-07-03', priceKopecks: 120),
      PricePoint(day: '2026-07-01', priceKopecks: 100),
      PricePoint(day: '2026-07-02', priceKopecks: 110),
    ];

    expect(useCase(points), PriceTrend.rising);
  });
}