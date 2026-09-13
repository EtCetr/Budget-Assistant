import 'package:freezed_annotation/freezed_annotation.dart';

part 'cashback_category_summary.freezed.dart';

/// Результат расчёта кэшбэка по одной категории карты за текущий цикл.
@freezed
abstract class CashbackCategorySummary with _$CashbackCategorySummary {
  const factory CashbackCategorySummary({
    required String entryId,
    required String accountId,
    String? categoryId,
    required String categoryName,
    required int percentBps,
    required String lifetimeType,
    required DateTime cycleStartUtc,
    required DateTime cycleEndUtc,
    required int grossExpenseKopecks,
    required int refundKopecks,
    required int netExpenseKopecks,
    required int cashbackKopecks,
    required String currency,
  }) = _CashbackCategorySummary;
}