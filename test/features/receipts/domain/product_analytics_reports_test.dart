import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/receipts/domain/entities/product_analytics_cache_entry.dart';
import 'package:budget_assistant/features/receipts/domain/entities/product_analytics_models.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/calculate_price_dynamics_usecase.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/calculate_price_trend_usecase.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/calculate_top_categories_usecase.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/calculate_top_products_usecase.dart';

/// Этап 24: три отчёта ProductAnalyticsScreen (ТЗ 6.3.24.5).
/// Деньги — целые копейки; количество — double (допустимо, ТОМ 2 §17.3).
const _hashA = 'abcdef1234567890';
const _hashB = 'fedcba0987654321';

ProductAnalyticsCacheEntry _entry({
  required String id,
  String hash = _hashA,
  required String day,
  int purchases = 1,
  int spend = 10000,
  double qty = 1,
  int avg = 10000,
  String? categoryId,
}) =>
    ProductAnalyticsCacheEntry(
      id: id,
      userId: 'u1',
      day: day,
      productHash: hash,
      categoryId: categoryId,
      purchases: purchases,
      totalSpendKopecks: spend,
      totalQuantity: qty,
      avgPriceKopecks: avg,
      updatedAt: DateTime.utc(2026),
    );

TopProduct _product({
  required String hash,
  String? categoryId,
  int purchases = 1,
  int spend = 10000,
  double qty = 1,
}) =>
    TopProduct(
      productHash: hash,
      name: hash,
      categoryId: categoryId,
      purchases: purchases,
      totalSpendKopecks: spend,
      totalQuantity: qty,
      avgPriceKopecks: 0,
      trend: PriceTrend.stable,
      points: const [],
      firstSeen: '2026-07-01',
      lastSeen: '2026-07-01',
    );

void main() {
  late Logger logger;
  late CalculatePriceTrendUseCase trend;

  setUpAll(() async {
    // Динамика цен форматирует месяцы через DateFormat('MMM yyyy', 'ru').
    await initializeDateFormatting('ru');
  });

  setUp(() {
    logger = Logger(level: Level.off);
    trend = CalculatePriceTrendUseCase(logger: logger);
  });

  group('Топ товаров', () {
    late CalculateTopProductsUseCase useCase;

    setUp(() {
      useCase = CalculateTopProductsUseCase(
        trendUseCase: trend,
        logger: logger,
      );
    });

    List<TopProduct> run(
      List<ProductAnalyticsCacheEntry> entries, {
      Map<String, String> names = const {},
    }) =>
        useCase(entries: entries, namesByHash: names);

    test('пустой кэш — пустой отчёт', () {
      expect(run(const []), isEmpty);
    });

    test('группировка по хэшу: покупки, траты и количество складываются', () {
      final rows = run([
        _entry(id: 'e1', day: '2026-07-01', purchases: 2, spend: 20000, qty: 2),
        _entry(id: 'e2', day: '2026-07-05', purchases: 3, spend: 30000, qty: 3),
      ]);

      expect(rows.length, 1);
      expect(rows.single.purchases, 5);
      expect(rows.single.totalSpendKopecks, 50000);
      expect(rows.single.totalQuantity, 5);
    });

    test('средняя цена = траты / количество', () {
      final rows = run([
        _entry(id: 'e1', day: '2026-07-01', spend: 30000, qty: 2),
      ]);

      expect(rows.single.avgPriceKopecks, 15000);
    });

    test('нулевое количество — средняя цена 0', () {
      final rows = run([
        _entry(id: 'e1', day: '2026-07-01', spend: 30000, qty: 0),
      ]);

      expect(rows.single.avgPriceKopecks, 0);
    });

    test('имя берётся из карты имён, иначе первые 8 символов хэша', () {
      final withName = run(
        [_entry(id: 'e1', day: '2026-07-01')],
        names: {_hashA: 'Молоко'},
      );
      final withoutName = run([_entry(id: 'e1', day: '2026-07-01')]);

      expect(withName.single.name, 'Молоко');
      expect(withoutName.single.name, 'abcdef12');
    });

    test('сортировка по числу покупок, при равенстве — по тратам', () {
      final rows = run([
        _entry(
          id: 'a1',
          hash: _hashA,
          day: '2026-07-01',
          purchases: 2,
          spend: 10000,
        ),
        _entry(
          id: 'b1',
          hash: _hashB,
          day: '2026-07-01',
          purchases: 2,
          spend: 50000,
        ),
        _entry(
          id: 'b2',
          hash: _hashB,
          day: '2026-07-02',
          spend: 10000,
        ),
      ]);

      expect(rows.first.productHash, _hashB);
      expect(rows.first.purchases, 3);
      expect(rows.last.productHash, _hashA);
    });

    test('первая и последняя покупка по дням', () {
      final rows = run([
        _entry(id: 'e1', day: '2026-07-10'),
        _entry(id: 'e2', day: '2026-07-01'),
        _entry(id: 'e3', day: '2026-07-05'),
      ]);

      expect(rows.single.firstSeen, '2026-07-01');
      expect(rows.single.lastSeen, '2026-07-10');
    });

    test('точки ценового ряда отсортированы по дню', () {
      final rows = run([
        _entry(id: 'e1', day: '2026-07-10', avg: 120),
        _entry(id: 'e2', day: '2026-07-01', avg: 100),
        _entry(id: 'e3', day: '2026-07-05', avg: 110),
      ]);

      expect(
        rows.single.points.map((p) => p.day).toList(),
        ['2026-07-01', '2026-07-05', '2026-07-10'],
      );
    });

    test('тренд считается по точкам товара', () {
      final rows = run([
        _entry(id: 'e1', day: '2026-07-01', avg: 100),
        _entry(id: 'e2', day: '2026-07-02', avg: 110),
        _entry(id: 'e3', day: '2026-07-03', avg: 120),
      ]);

      expect(rows.single.trend, PriceTrend.rising);
    });

    test('категория берётся из первой записи, где она задана', () {
      final rows = run([
        _entry(id: 'e1', day: '2026-07-01'),
        _entry(id: 'e2', day: '2026-07-02', categoryId: 'c1'),
      ]);

      expect(rows.single.categoryId, 'c1');
    });
  });

  group('Категории товаров', () {
    late CalculateTopCategoriesUseCase useCase;

    setUp(() {
      useCase = CalculateTopCategoriesUseCase(logger: logger);
    });

    test('пустой список — пустой отчёт', () {
      expect(
        useCase(products: const [], totalSpendKopecks: 0),
        isEmpty,
      );
    });

    test('группировка по категории и доля от общих трат', () {
      final rows = useCase(
        products: [
          _product(hash: _hashA, categoryId: 'c1', spend: 30000),
          _product(hash: _hashB, categoryId: 'c1', spend: 10000),
        ],
        totalSpendKopecks: 40000,
      );

      expect(rows.length, 1);
      expect(rows.single.categoryId, 'c1');
      expect(rows.single.totalSpendKopecks, 40000);
      expect(rows.single.percent, 100);
      expect(rows.single.uniqueProducts, 2);
    });

    test('товар без категории попадает в other', () {
      final rows = useCase(
        products: [_product(hash: _hashA)],
        totalSpendKopecks: 10000,
      );

      expect(rows.single.categoryId, 'other');
    });

    test('сортировка по суммарным тратам', () {
      final rows = useCase(
        products: [
          _product(hash: _hashA, categoryId: 'small', spend: 10000),
          _product(hash: _hashB, categoryId: 'big', spend: 90000),
        ],
        totalSpendKopecks: 100000,
      );

      expect(rows.first.categoryId, 'big');
      expect(rows.last.categoryId, 'small');
    });

    test('нулевые общие траты — доля 0 без деления на ноль', () {
      final rows = useCase(
        products: [_product(hash: _hashA, categoryId: 'c1')],
        totalSpendKopecks: 0,
      );

      expect(rows.single.percent, 0);
    });

    test('среднее количество на покупку', () {
      final rows = useCase(
        products: [
          _product(hash: _hashA, categoryId: 'c1', purchases: 2, qty: 5),
        ],
        totalSpendKopecks: 10000,
      );

      expect(rows.single.avgQuantityPerPurchase, 2.5);
    });

    test('категория без покупок — среднее количество 0', () {
      final rows = useCase(
        products: [
          _product(hash: _hashA, categoryId: 'c1', purchases: 0, qty: 0),
        ],
        totalSpendKopecks: 0,
      );

      expect(rows.single.avgQuantityPerPurchase, 0);
    });
  });

  group('Динамика цен', () {
    late CalculatePriceDynamicsUseCase useCase;

    setUp(() {
      useCase = CalculatePriceDynamicsUseCase(logger: logger);
    });

    List<PriceChangeEntry> run(
      List<ProductAnalyticsCacheEntry> entries, {
      Map<String, String> names = const {},
    }) =>
        useCase(entries: entries, namesByHash: names);

    test('меньше трёх месяцев — товар не попадает в отчёт', () {
      final rows = run([
        _entry(id: 'e1', day: '2026-06-01'),
        _entry(id: 'e2', day: '2026-07-01'),
      ]);

      expect(rows, isEmpty);
    });

    test('рост цены между первым и последним месяцем', () {
      final rows = run([
        _entry(id: 'e1', day: '2026-05-10', spend: 10000),
        _entry(id: 'e2', day: '2026-06-10', spend: 11000),
        _entry(id: 'e3', day: '2026-07-10', spend: 12000),
      ]);

      expect(rows.length, 1);
      expect(rows.single.firstPriceKopecks, 10000);
      expect(rows.single.lastPriceKopecks, 12000);
      expect(rows.single.changeAbsKopecks, 2000);
      expect(rows.single.changePercent, closeTo(20.0, 0.001));
    });

    test('падение цены даёт отрицательное изменение', () {
      final rows = run([
        _entry(id: 'e1', day: '2026-05-10', spend: 12000),
        _entry(id: 'e2', day: '2026-06-10', spend: 11000),
        _entry(id: 'e3', day: '2026-07-10', spend: 10000),
      ]);

      expect(rows.single.changeAbsKopecks, -2000);
      expect(rows.single.changePercent, lessThan(0));
    });

    test('сортировка по модулю изменения', () {
      final rows = run([
        _entry(id: 'a1', hash: _hashA, day: '2026-05-10', spend: 10000),
        _entry(id: 'a2', hash: _hashA, day: '2026-06-10', spend: 11000),
        _entry(id: 'a3', hash: _hashA, day: '2026-07-10', spend: 12000),
        _entry(id: 'b1', hash: _hashB, day: '2026-05-10', spend: 20000),
        _entry(id: 'b2', hash: _hashB, day: '2026-06-10', spend: 15000),
        _entry(id: 'b3', hash: _hashB, day: '2026-07-10', spend: 10000),
      ]);

      expect(rows.first.productHash, _hashB);
      expect(rows.first.changePercent, closeTo(-50.0, 0.001));
      expect(rows.last.productHash, _hashA);
    });

    test('нулевая цена первого месяца — товар пропускается', () {
      final rows = run([
        _entry(id: 'e1', day: '2026-05-10', spend: 0, qty: 0),
        _entry(id: 'e2', day: '2026-06-10', spend: 11000),
        _entry(id: 'e3', day: '2026-07-10', spend: 12000),
      ]);

      expect(rows, isEmpty);
    });

    test('точки ряда привязаны к первому числу месяца', () {
      final rows = run([
        _entry(id: 'e1', day: '2026-05-10'),
        _entry(id: 'e2', day: '2026-06-10'),
        _entry(id: 'e3', day: '2026-07-10'),
      ]);

      expect(
        rows.single.points.map((p) => p.day).toList(),
        ['2026-05-01', '2026-06-01', '2026-07-01'],
      );
    });

    test('подписи месяцев содержат год и имя товара из карты', () {
      final rows = run(
        [
          _entry(id: 'e1', day: '2026-05-10'),
          _entry(id: 'e2', day: '2026-06-10'),
          _entry(id: 'e3', day: '2026-07-10'),
        ],
        names: {_hashA: 'Молоко'},
      );

      expect(rows.single.name, 'Молоко');
      expect(rows.single.firstMonthLabel, contains('2026'));
      expect(rows.single.lastMonthLabel, contains('2026'));
    });
  });
}