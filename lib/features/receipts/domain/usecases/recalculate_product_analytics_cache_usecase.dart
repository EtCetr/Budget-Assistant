import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/product_analytics_source_dao.dart';
import '../entities/product_analytics_cache_entry.dart';
import '../repositories/product_analytics_cache_repository.dart';
import '../services/product_hash_util.dart';

/// Пересчёт product_analytics_cache (ТЗ 6.3.24.12.2): агрегация всех
/// receipt_items с нормализованными именами по (day, product_hash).
/// Запись атомарная: DELETE + INSERT в одной batch-транзакции (Этап 20.1).
class RecalculateProductAnalyticsCacheUseCase {
  RecalculateProductAnalyticsCacheUseCase({
    required ProductAnalyticsSourceDao sourceDao,
    required ProductAnalyticsCacheRepository cacheRepo,
    required Uuid uuid,
    required Logger logger,
  })  : _sourceDao = sourceDao,
        _cacheRepo = cacheRepo,
        _uuid = uuid,
        _logger = logger;

  final ProductAnalyticsSourceDao _sourceDao;
  final ProductAnalyticsCacheRepository _cacheRepo;
  final Uuid _uuid;
  final Logger _logger;

  Future<Result<int>> call({required String userId}) async {
    try {
      final receipts = await _sourceDao.receiptsByUser(userId);
      final confirmed = <ReceiptDb>[
        for (final r in receipts) if (r.status != 'draft') r,
      ];
      if (confirmed.isEmpty) {
        await _cacheRepo.replaceAllForUser(userId, const []);
        return const Success(0);
      }
      final byId = {for (final r in confirmed) r.id: r};
      final items = await _sourceDao.itemsForReceipts(byId.keys.toList());
      final aliases = await _sourceDao.aliasesByUser(userId);
      final aliasByNorm = <String, ProductAliasDb>{
        for (final a in aliases) a.normalizedName.trim().toLowerCase(): a,
      };
      final groups = <String, _Agg>{};
      for (final item in items) {
        if (item.isExcluded) continue;
        final norm = item.normalizedName;
        if (norm == null || norm.trim().isEmpty) continue;
        final receipt = byId[item.receiptId];
        if (receipt == null) continue;
        final local = receipt.receiptDate.toLocal();
        final day = '${local.year.toString().padLeft(4, '0')}-'
            '${local.month.toString().padLeft(2, '0')}-'
            '${local.day.toString().padLeft(2, '0')}';
        final space = receipt.spaceId ?? '';
        final hash = ProductHashUtil.hash(norm);
        final agg = groups.putIfAbsent(
          '$space|$day|$hash',
          () => _Agg(day: day, space: space, hash: hash),
        );
        agg.receiptIds.add(receipt.id);
        agg.spendKopecks += item.totalPrice;
        agg.quantity += item.quantity;
        agg.categoryId ??=
            aliasByNorm[norm.trim().toLowerCase()]?.categoryId ??
                item.categoryId;
      }
      final now = DateTime.now().toUtc();
      final rows = <ProductAnalyticsCacheEntry>[
        for (final g in groups.values)
          ProductAnalyticsCacheEntry(
            id: _uuid.v4(),
            userId: userId,
            spaceId: g.space,
            day: g.day,
            productHash: g.hash,
            categoryId: g.categoryId,
            purchases: g.receiptIds.length,
            totalSpendKopecks: g.spendKopecks,
            totalQuantity: g.quantity,
            avgPriceKopecks:
                g.quantity > 0 ? (g.spendKopecks / g.quantity).round() : 0,
            updatedAt: now,
          ),
      ];
      await _cacheRepo.replaceAllForUser(userId, rows);
      return Success(rows.length);
    } catch (e, st) {
      _logger.e('RecalculateProductAnalyticsCache failed',
          error: e, stackTrace: st);
      return Error(Failure.database('Не удалось пересчитать аналитику: $e'));
    }
  }
}

class _Agg {
  _Agg({required this.day, required this.space, required this.hash});

  final String day;
  final String space;
  final String hash;
  final Set<String> receiptIds = {};
  int spendKopecks = 0;
  double quantity = 0;
  String? categoryId;
}