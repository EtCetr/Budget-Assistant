import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../entities/cashback_category_summary.dart';
import '../entities/cashback_entry.dart';
import '../entities/cashback_raw_models.dart';
import '../repositories/cashback_repository.dart';
import 'convert_currency_usecase.dart';
import 'get_cashback_cycle_bounds_usecase.dart';

/// Расчёт кэшбэка по 5 жёстким правилам (ТОМ 4 §3, SUMMARY):
/// 1. Сплит-чеки: при is_split базовая сумма игнорируется, берутся суммы из
///    transaction_splits соответствующей категории.
/// 2. Мультивалютность: траты приводятся к валюте карты по курсу на дату.
/// 3. Переводы исключены (фильтр в SQL репозитория).
/// 4. Возвраты: NET = SUM(expense) - SUM(income с той же категорией).
/// 5. Циклы в локальном часовом поясе (ПН 00:00 / 1-е число 00:00).
class CalculateCashbackUseCase {
  CalculateCashbackUseCase({
    required CashbackRepository cashbackRepository,
    required ConvertCurrencyUseCase convertCurrency,
    required GetCashbackCycleBoundsUseCase cycleBounds,
    required Logger logger,
  })  : _cashbackRepository = cashbackRepository,
        _convertCurrency = convertCurrency,
        _cycleBounds = cycleBounds,
        _logger = logger;

  final CashbackRepository _cashbackRepository;
  final ConvertCurrencyUseCase _convertCurrency;
  final GetCashbackCycleBoundsUseCase _cycleBounds;
  final Logger _logger;

  Future<List<CashbackCategorySummary>> call({
    required String accountId,
    required DateTime now,
  }) async {
    try {
      final entries = await _cashbackRepository.getByAccount(accountId);
      if (entries.isEmpty) return const [];

      final currency = await _cashbackRepository.getAccountCurrency(accountId);
      if (currency == null) {
        _logger.w('Account not found for cashback: $accountId');
        return const [];
      }

      // Группируем записи по типу цикла, чтобы сделать по одному запросу на тип.
      final byLifetime = <String, List<CashbackEntry>>{};
      for (final e in entries) {
        byLifetime.putIfAbsent(e.lifetimeType, () => []).add(e);
      }

      final results = <CashbackCategorySummary>[];
      for (final group in byLifetime.entries) {
        final lifetimeType = group.key;
        final bounds = _cycleBounds(now: now, lifetimeType: lifetimeType);
        final txs = await _cashbackRepository.fetchRelevantTransactions(
          accountId,
          bounds.startUtc,
          bounds.endUtc,
        );
        final splitTxIds = txs.where((t) => t.isSplit).map((t) => t.id).toList();
        final splits = await _cashbackRepository.fetchSplits(splitTxIds);
        final splitsByTx = <String, List<CashbackSplitRaw>>{};
        for (final s in splits) {
          splitsByTx.putIfAbsent(s.transactionId, () => []).add(s);
        }

        final gross = <String, int>{};
        final refund = <String, int>{};

        for (final tx in txs) {
          if (tx.isSplit) {
            // Правило 1: базовая сумма транзакции игнорируется, берём сплиты.
            // Суммы сплитов уже в валюте счёта — конверсия не требуется.
            final parts = splitsByTx[tx.id] ?? const [];
            for (final s in parts) {
              _accumulate(tx.type, s.categoryId, s.amount, gross, refund);
            }
          } else {
            final catId = tx.customCategoryId;
            if (catId == null) continue;
            // Правило 2: мультивалютность.
            final converted = await _toCardCurrency(tx, currency);
            if (converted == null) continue;
            _accumulate(tx.type, catId, converted, gross, refund);
          }
        }

        for (final e in group.value) {
          final catId = e.categoryId;
          final g = catId == null ? 0 : (gross[catId] ?? 0);
          final r = catId == null ? 0 : (refund[catId] ?? 0);
          // Правило 4: NET-сумма, не уходим в минус.
          final net = g - r;
          final netClamped = net > 0 ? net : 0;
          final cashback = (netClamped * e.percentBps) ~/ 10000;
          results.add(CashbackCategorySummary(
            entryId: e.id,
            accountId: accountId,
            categoryId: catId,
            categoryName: e.categoryName,
            percentBps: e.percentBps,
            lifetimeType: lifetimeType,
            status: e.status,
            cycleStartUtc: bounds.startUtc,
            cycleEndUtc: bounds.endUtc,
            grossExpenseKopecks: g,
            refundKopecks: r,
            netExpenseKopecks: netClamped,
            cashbackKopecks: cashback,
            currency: currency,
          ));
        }
      }
      return results;
    } catch (e, st) {
      _logger.e('CalculateCashbackUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  void _accumulate(
    TransactionType type,
    String categoryId,
    int amount,
    Map<String, int> gross,
    Map<String, int> refund,
  ) {
    if (type == TransactionType.expense) {
      gross[categoryId] = (gross[categoryId] ?? 0) + amount;
    } else if (type == TransactionType.income) {
      // Правило 4: возвраты с той же категорией вычитаются из базы кэшбэка.
      refund[categoryId] = (refund[categoryId] ?? 0) + amount;
    }
  }

  /// Правило 2: приведение к валюте карты по курсу на дату транзакции.
  Future<int?> _toCardCurrency(CashbackTransactionRaw tx, String cardCurrency) async {
    final from = tx.originalCurrency;
    if (from == null || from == cardCurrency) return tx.amount;
    final sourceAmount = tx.originalAmount ?? tx.amount;
    return _convertCurrency(
      amountKopecks: sourceAmount,
      fromCurrency: from,
      toCurrency: cardCurrency,
      dateUtc: tx.date,
    );
  }
}