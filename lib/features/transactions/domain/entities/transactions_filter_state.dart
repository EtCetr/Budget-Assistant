import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions_filter_state.freezed.dart';

enum TransactionsScope { all, mine, family }

enum TransactionTypeFilter { all, expense, income, transfer }

enum TransactionsPeriodPreset { all, today, week, month, year, custom }

@freezed
abstract class TransactionsFilterState with _$TransactionsFilterState {
  const factory TransactionsFilterState({
    @Default(TransactionsScope.all) TransactionsScope scope,
    @Default(TransactionTypeFilter.all) TransactionTypeFilter type,
    @Default(<String>[]) List<String> categoryIds,
    @Default(<String>[]) List<String> accountIds,
    @Default(TransactionsPeriodPreset.all) TransactionsPeriodPreset period,
    DateTime? customFrom,
    DateTime? customTo,
    int? amountFromKopecks,
    int? amountToKopecks,
    @Default(false) bool onlyWithReceipt,
    @Default(false) bool onlySplit,
    @Default(false) bool onlyDebts,
    @Default(false) bool excludeOwn,
    @Default('') String search,
  }) = _TransactionsFilterState;
}

extension TransactionsFilterStateX on TransactionsFilterState {
  bool get hasActiveFilters {
    return type != TransactionTypeFilter.all ||
        categoryIds.isNotEmpty ||
        accountIds.isNotEmpty ||
        period != TransactionsPeriodPreset.all ||
        amountFromKopecks != null ||
        amountToKopecks != null ||
        onlyWithReceipt ||
        onlySplit ||
        onlyDebts ||
        excludeOwn ||
        search.trim().isNotEmpty;
  }
}
