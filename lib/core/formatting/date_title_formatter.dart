import 'package:intl/intl.dart';

import '../../features/transactions/presentation/labels/transactions_log_labels.dart';

class DateTitleFormatter {
  static String day(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final normalized = DateTime(day.year, day.month, day.day);

    if (normalized == today) {
      return '${TransactionsLogLabels.today}, ${DateFormat.MMMMd('ru').format(normalized)}';
    }

    if (normalized == yesterday) {
      return '${TransactionsLogLabels.yesterday}, ${DateFormat.MMMMd('ru').format(normalized)}';
    }

    return DateFormat.MMMEd('ru').format(normalized);
  }
}
