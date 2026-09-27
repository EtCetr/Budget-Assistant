import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';

part 'recurring_detection_dao.g.dart';

/// Лёгкий стаб транзакции для автодетекта регулярных платежей
/// (ТЗ 6.3.9): только мерчант, сумма и дата — всё, что нужно алгоритму.
class DetectionTxStub {
  const DetectionTxStub({
    required this.merchantName,
    required this.amountKopecks,
    required this.dateUtc,
  });

  final String merchantName;
  final int amountKopecks;
  final DateTime dateUtc;
}

/// Источник сырых данных для DetectRecurringPaymentsUseCase.
/// Фильтры P&L те же, что в календаре (ТОМ 4 §1): без копилок,
/// изъятий, переводов и ignored; секретные (подарки) не анализируем.
@DriftAccessor(tables: [Transactions])
class RecurringDetectionDao extends DatabaseAccessor<AppDatabase>
    with _$RecurringDetectionDaoMixin {
  RecurringDetectionDao(super.db);

  Future<List<DetectionTxStub>> getExpenseStubs({
    required String userId,
    String? spaceId,
    required DateTime sinceUtc,
  }) async {
    final scopeSql =
        spaceId == null ? 'user_id = ?' : '(user_id = ? OR space_id = ?)';
    final scopeVars = spaceId == null
        ? <Variable>[Variable.withString(userId)]
        : <Variable>[
            Variable.withString(userId),
            Variable.withString(spaceId),
          ];
    final sql = '''
SELECT merchant_name, amount, date
FROM transactions
WHERE type = 'expense'
  AND merchant_name IS NOT NULL
  AND is_hidden_by_calendar = 0
  AND audit_status != 'ignored'
  AND savings_goal_id IS NULL
  AND is_withdrawal = 0
  AND date >= ?
  AND $scopeSql
ORDER BY date ASC
''';
    final rows = await customSelect(
      sql,
      variables: [Variable.withDateTime(sinceUtc), ...scopeVars],
      readsFrom: {transactions},
    ).get();
    return [
      for (final r in rows)
        DetectionTxStub(
          merchantName: r.read<String>('merchant_name'),
          amountKopecks: r.read<int>('amount'),
          dateUtc: r.read<DateTime>('date'),
        ),
    ];
  }
}