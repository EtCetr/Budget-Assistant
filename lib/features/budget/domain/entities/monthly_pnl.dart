import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_pnl.freezed.dart';

@freezed
abstract class MonthlyPnl with _$MonthlyPnl {
  const factory MonthlyPnl({
    required int year,
    required int month,
    required int totalIncome,
    required int totalExpense,
    required int savingsRate,
    required int transactionCount,
  }) = _MonthlyPnl;
}