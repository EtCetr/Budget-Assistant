import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/providers/database_providers.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/core/providers/util_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../data/datasources/product_analytics_source_dao.dart';
import '../../domain/entities/product_analytics_cache_entry.dart';
import '../../domain/entities/product_analytics_models.dart';
import '../../domain/services/product_hash_util.dart';
import '../../domain/usecases/calculate_price_dynamics_usecase.dart';
import '../../domain/usecases/calculate_price_trend_usecase.dart';
import '../../domain/usecases/calculate_top_categories_usecase.dart';
import '../../domain/usecases/calculate_top_products_usecase.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import '../../domain/usecases/recalculate_product_analytics_cache_usecase.dart';
import 'product_analytics_cache_providers.dart';

final Logger _logger = Logger();

/// Границы периода (локальные дни, 'YYYY-MM-DD', включительно).
(String?, String?) rangeForPeriod(String period) {
  String key(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  switch (period) {
    case 'month':
      return (key(DateTime(today.year, today.month, 1)), key(today));
    case 'quarter':
      final q = ((today.month - 1) ~/ 3) * 3 + 1;
      return (key(DateTime(today.year, q, 1)), key(today));
    case 'all':
      return (null, null);
    default:
      return (key(DateTime(today.year, 1, 1)), key(today));
  }
}

class ProductAnalyticsPeriodNotifier extends Notifier<String> {
  @override
  String build() => 'year';

  void set(String period) => state = period;
}

final productAnalyticsPeriodProvider =
    NotifierProvider<ProductAnalyticsPeriodNotifier, String>(
  ProductAnalyticsPeriodNotifier.new,
);

class ProductAnalyticsScopeNotifier extends Notifier<ProductAnalyticsScope> {
  @override
  ProductAnalyticsScope build() => ProductAnalyticsScope.family;

  void set(ProductAnalyticsScope scope) => state = scope;
}

final productAnalyticsScopeProvider =
    NotifierProvider<ProductAnalyticsScopeNotifier, ProductAnalyticsScope>(
  ProductAnalyticsScopeNotifier.new,
);

class ProductAnalyticsTabNotifier extends Notifier<String> {
  @override
  String build() => 'top_products';

  void set(String tab) => state = tab;
}

final productAnalyticsTabProvider =
    NotifierProvider<ProductAnalyticsTabNotifier, String>(
  ProductAnalyticsTabNotifier.new,
);

final productAnalyticsRangeProvider = Provider<(String?, String?)>((ref) {
  return rangeForPeriod(ref.watch(productAnalyticsPeriodProvider));
});

final productAnalyticsSourceDaoProvider =
    Provider<ProductAnalyticsSourceDao>((ref) {
  return ProductAnalyticsSourceDao(ref.watch(appDatabaseProvider));
});

// ─── UseCases ───

final calculatePriceTrendUseCaseProvider =
    Provider<CalculatePriceTrendUseCase>((ref) {
  return CalculatePriceTrendUseCase(logger: _logger);
});

final recalculateProductAnalyticsCacheUseCaseProvider =
    Provider<RecalculateProductAnalyticsCacheUseCase>((ref) {
  return RecalculateProductAnalyticsCacheUseCase(
    sourceDao: ref.watch(productAnalyticsSourceDaoProvider),
    cacheRepo: ref.watch(productAnalyticsCacheRepositoryProvider),
    uuid: ref.watch(uuidProvider),
    logger: _logger,
  );
});

final calculateTopProductsUseCaseProvider =
    Provider<CalculateTopProductsUseCase>((ref) {
  return CalculateTopProductsUseCase(
    trendUseCase: ref.watch(calculatePriceTrendUseCaseProvider),
    logger: _logger,
  );
});

final calculateTopCategoriesUseCaseProvider =
    Provider<CalculateTopCategoriesUseCase>((ref) {
  return CalculateTopCategoriesUseCase(logger: _logger);
});

final calculatePriceDynamicsUseCaseProvider =
    Provider<CalculatePriceDynamicsUseCase>((ref) {
  return CalculatePriceDynamicsUseCase(logger: _logger);
});

final getProductDetailsUseCaseProvider =
    Provider<GetProductDetailsUseCase>((ref) {
  return GetProductDetailsUseCase(
    sourceDao: ref.watch(productAnalyticsSourceDaoProvider),
    trendUseCase: ref.watch(calculatePriceTrendUseCaseProvider),
    logger: _logger,
  );
});

// ─── Данные ───

/// product_hash -> нормализованное имя (локально открыто, Этап 16).
final productAliasesNamesProvider =
    FutureProvider.autoDispose<Map<String, String>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final aliases =
      await ref.watch(productAnalyticsSourceDaoProvider).aliasesByUser(userId);
  return {
    for (final a in aliases) ProductHashUtil.hash(a.normalizedName): a.normalizedName,
  };
});

/// category_id -> (имя, цвет, эмодзи) для отчёта категорий.
final productCategoriesMapProvider = FutureProvider.autoDispose<
    Map<String, (String, String?, String?)>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final spaceId = ref.watch(currentSpaceIdProvider);
  final cats = await ref
      .watch(productAnalyticsSourceDaoProvider)
      .categoriesFor(userId, spaceId);
  return {
    for (final c in cats) c.id: (c.name, c.colorHex, c.iconEmoji),
  };
});

/// Сырые агрегаты кэша за выбранный период и скоуп.
final productAnalyticsCacheProvider =
    FutureProvider.autoDispose<List<ProductAnalyticsCacheEntry>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final spaceId = ref.watch(currentSpaceIdProvider);
  final scope = ref.watch(productAnalyticsScopeProvider);
  final range = ref.watch(productAnalyticsRangeProvider);
  return ref.watch(productAnalyticsCacheRepositoryProvider).forPeriod(
        userId: userId,
        familySpaceId: spaceId,
        includeFamily: scope == ProductAnalyticsScope.family,
        fromDay: range.$1,
        toDay: range.$2,
      );
});

/// Кэш устарел, если пересчёта не было > 24 часов (ТЗ 6.3.24.9).
final productAnalyticsStaleProvider = FutureProvider.autoDispose<bool>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final last = await ref
      .watch(productAnalyticsCacheRepositoryProvider)
      .lastUpdatedAt(userId);
  if (last == null) return true;
  return DateTime.now().toUtc().difference(last).inHours >= 24;
});

final topProductsProvider = FutureProvider.autoDispose<List<TopProduct>>((ref) async {
  final entries = await ref.watch(productAnalyticsCacheProvider.future);
  final names = await ref.watch(productAliasesNamesProvider.future);
  return ref
      .watch(calculateTopProductsUseCaseProvider)
      .call(entries: entries, namesByHash: names);
});

final topCategoriesProvider =
    FutureProvider.autoDispose<List<TopCategory>>((ref) async {
  final products = await ref.watch(topProductsProvider.future);
  final total =
      products.fold<int>(0, (sum, p) => sum + p.totalSpendKopecks);
  return ref
      .watch(calculateTopCategoriesUseCaseProvider)
      .call(products: products, totalSpendKopecks: total);
});

final priceDynamicsProvider =
    FutureProvider.autoDispose<List<PriceChangeEntry>>((ref) async {
  final entries = await ref.watch(productAnalyticsCacheProvider.future);
  final names = await ref.watch(productAliasesNamesProvider.future);
  return ref
      .watch(calculatePriceDynamicsUseCaseProvider)
      .call(entries: entries, namesByHash: names);
});

/// Сводка: уникальных товаров + среднее число позиций в чеке (из сырых чеков).
final productAnalyticsSummaryProvider =
    FutureProvider.autoDispose<ProductAnalyticsSummary>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final range = ref.watch(productAnalyticsRangeProvider);
  final receipts =
      await ref.watch(productAnalyticsSourceDaoProvider).receiptsByUser(userId);
  final confirmed = <ReceiptDb>[
    for (final r in receipts)
      if (r.status != 'draft')
        if (_inRange(r, range)) r,
  ];
  if (confirmed.isEmpty) {
    return const ProductAnalyticsSummary(
      uniqueProducts: 0,
      avgItemsPerCheck: 0,
      checksCount: 0,
    );
  }
  final items = await ref
      .watch(productAnalyticsSourceDaoProvider)
      .itemsForReceipts([for (final r in confirmed) r.id]);
  final unique = <String>{};
  var totalQty = 0.0;
  for (final item in items) {
    if (item.isExcluded) continue;
    final norm = item.normalizedName;
    if (norm == null || norm.trim().isEmpty) continue;
    unique.add(ProductHashUtil.hash(norm));
    totalQty += item.quantity;
  }
  return ProductAnalyticsSummary(
    uniqueProducts: unique.length,
    avgItemsPerCheck:
        confirmed.isEmpty ? 0 : totalQty / confirmed.length,
    checksCount: confirmed.length,
  );
});

bool _inRange(ReceiptDb r, (String?, String?) range) {
  final local = r.receiptDate.toLocal();
  final day = '${local.year.toString().padLeft(4, '0')}-'
      '${local.month.toString().padLeft(2, '0')}-'
      '${local.day.toString().padLeft(2, '0')}';
  if (range.$1 != null && day.compareTo(range.$1!) < 0) return false;
  if (range.$2 != null && day.compareTo(range.$2!) > 0) return false;
  return true;
}

/// Детализация товара (family = весь период, ТЗ 6.3.24.6).
final productDetailsProvider =
    FutureProvider.autoDispose.family<ProductDetails?, String>((ref, hash) async {
  final userId = ref.watch(currentUserIdProvider);
  final names = await ref.watch(productAliasesNamesProvider.future);
  final result = await ref
      .watch(getProductDetailsUseCaseProvider)
      .call(userId: userId, productHash: hash, namesByHash: names);
  return result.valueOrNull;
});