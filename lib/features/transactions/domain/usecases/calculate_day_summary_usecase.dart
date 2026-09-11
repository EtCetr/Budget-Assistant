import 'package:budget_assistant/core/enums/transaction_enums.dart';

import '../entities/transaction_day_group.dart';
import '../entities/transaction_ui_model.dart';

class CalculateDaySummaryUseCase {
  DaySummaryUi call(List<TransactionUiModel> transactions) {
    var spent = 0;
    var income = 0;

    for (final tx in transactions) {
      if (tx.auditStatus == AuditStatus.ignored) {
        continue;
      }

      if (tx.type == TransactionType.transfer) {
        continue;
      }

      if (tx.isSplit) {
        continue;
      }

      if (tx.type == TransactionType.expense) {
        spent += tx.amountKopecks;
      }

      if (tx.type == TransactionType.income) {
        income += tx.amountKopecks;
      }
    }

    return DaySummaryUi(
      spentKopecks: spent,
      incomeKopecks: income,
      operationsCount: transactions.length,
    );
  }
}
