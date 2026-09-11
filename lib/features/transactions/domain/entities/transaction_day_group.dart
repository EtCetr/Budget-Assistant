import 'package:freezed_annotation/freezed_annotation.dart';

import 'transaction_ui_model.dart';

part 'transaction_day_group.freezed.dart';

@freezed
abstract class DaySummaryUi with _$DaySummaryUi {
  const factory DaySummaryUi({
    required int spentKopecks,
    required int incomeKopecks,
    required int operationsCount,
  }) = _DaySummaryUi;
}

@freezed
abstract class TransactionDayGroupUi with _$TransactionDayGroupUi {
  const factory TransactionDayGroupUi({
    required DateTime day,
    required String title,
    required DaySummaryUi summary,
    required List<TransactionUiModel> transactions,
  }) = _TransactionDayGroupUi;
}

@freezed
abstract class TransactionPageUi with _$TransactionPageUi {
  const factory TransactionPageUi({
    required List<TransactionUiModel> items,
    required bool hasMore,
  }) = _TransactionPageUi;
}
