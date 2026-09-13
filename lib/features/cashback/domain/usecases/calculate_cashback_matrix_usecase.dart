import 'package:logger/logger.dart';
import '../entities/cashback_account_ref.dart';
import '../entities/cashback_category_summary.dart';
import '../entities/cashback_matrix_models.dart';
import 'calculate_cashback_usecase.dart';

/// Матрица выгоды (Этап 10, вариант «а»): сравнительная таблица
/// «категория x карта» по переданному списку счетов (мои или семья).
/// Для каждой категории строит ячейки по всем счетам и подсвечивает
/// лучшую карту (максимальный процент, при равенстве — больший кэшбэк).
///
/// Список счетов передаёт провайдер (источник: мои / семья),
/// поэтому репозиторий UseCase не нужен.
class CalculateCashbackMatrixUseCase {
  CalculateCashbackMatrixUseCase({
    required CalculateCashbackUseCase calculateCashback,
    required Logger logger,
  })  : _calculateCashback = calculateCashback,
        _logger = logger;

  final CalculateCashbackUseCase _calculateCashback;
  final Logger _logger;

  Future<List<CashbackMatrixRow>> call({
    required DateTime now,
    required List<CashbackAccountRef> accounts,
  }) async {
    try {
      if (accounts.isEmpty) return const [];

      final summariesByAccount = <String, List<CashbackCategorySummary>>{};
      for (final account in accounts) {
        summariesByAccount[account.id] = await _calculateCashback(
          accountId: account.id,
          now: now,
        );
      }

      final rowKeys = <String>[];
      final rowNames = <String, String>{};
      final cellsByKey = <String, Map<String, CashbackMatrixCell>>{};

      for (final account in accounts) {
        for (final s in summariesByAccount[account.id]!) {
          final key = s.categoryId ?? 'name:${s.categoryName}';
          if (!cellsByKey.containsKey(key)) {
            rowKeys.add(key);
            rowNames[key] = s.categoryName;
            cellsByKey[key] = {};
          }
          cellsByKey[key]![account.id] = CashbackMatrixCell(
            accountId: account.id,
            accountName: account.name,
            currency: s.currency,
            entryId: s.entryId,
            status: s.status,
            lifetimeType: s.lifetimeType,
            percentBps: s.percentBps,
            netKopecks: s.netExpenseKopecks,
            cashbackKopecks: s.cashbackKopecks,
          );
        }
      }

      final rows = <CashbackMatrixRow>[];
      for (final key in rowKeys) {
        final cells = <CashbackMatrixCell>[
          for (final account in accounts)
            cellsByKey[key]![account.id] ??
                CashbackMatrixCell(
                  accountId: account.id,
                  accountName: account.name,
                  currency: account.currency,
                ),
        ];
        String? bestId;
        var bestBps = -1;
        var bestCash = -1;
        for (final c in cells) {
          final bps = c.percentBps;
          if (bps == null) continue;
          final cash = c.cashbackKopecks ?? 0;
          if (bps > bestBps || (bps == bestBps && cash > bestCash)) {
            bestBps = bps;
            bestCash = cash;
            bestId = c.accountId;
          }
        }
        rows.add(CashbackMatrixRow(
          categoryId: key,
          categoryName: rowNames[key]!,
          cells: cells,
          bestAccountId: bestId,
          bestPercentBps: bestBps < 0 ? 0 : bestBps,
        ));
      }

      rows.sort((a, b) => b.bestPercentBps.compareTo(a.bestPercentBps));
      return rows;
    } catch (e, st) {
      _logger.e(
        'CalculateCashbackMatrixUseCase failed',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }
}