import '../../../../core/formatting/date_title_formatter.dart';
import '../entities/transaction_day_group.dart';
import '../entities/transaction_ui_model.dart';
import 'calculate_day_summary_usecase.dart';

class GroupTransactionsByDayUseCase {
  GroupTransactionsByDayUseCase(this._calculateDaySummary);

  final CalculateDaySummaryUseCase _calculateDaySummary;

  List<TransactionDayGroupUi> call(List<TransactionUiModel> transactions) {
    final Map<DateTime, List<TransactionUiModel>> grouped = {};

    for (final tx in transactions) {
      final local = tx.date.toLocal();
      final day = DateTime(local.year, local.month, local.day);

      grouped.putIfAbsent(day, () => []).add(tx);
    }

    final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return days.map((day) {
      final items = grouped[day]!..sort((a, b) => b.date.compareTo(a.date));

      return TransactionDayGroupUi(
        day: day,
        title: DateTitleFormatter.day(day),
        summary: _calculateDaySummary(items),
        transactions: items,
      );
    }).toList();
  }
}
