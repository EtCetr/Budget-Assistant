import 'package:logger/logger.dart';
import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:uuid/uuid.dart';
import '../entities/parsed_row.dart';
import '../entities/transfer_candidate.dart';

/// Детекция переводов между своими счетами (ТЗ 6.3.26.7).
///
/// Сценарий А (Межбанк): amount совпадает, оба счёта пользователя, ±3 дня.
/// Сценарий Б (СБП): amount совпадает, merchant содержит «СБП», ±5 минут.
///
/// После объединения: type='transfer', linked_account_id, исходные удаляются.
/// Переводы исключены из P&L (type != 'transfer' фильтр).
class DetectTransfersUseCase {
  final AppDatabase _db;
  final Logger _logger;

  DetectTransfersUseCase({
    required AppDatabase db,
    required Logger logger,
  })  : _db = db,
        _logger = logger;

  Future<List<TransferCandidate>> call({
    required List<ParsedRow> importedRows,
    required String sourceAccountId,
    required int interbankToleranceDays,
    required int sbpToleranceMinutes,
  }) async {
    final transfers = <TransferCandidate>[];

    try {
      // Получаем все счета пользователя для проверки принадлежности
      final userAccounts = await (_db.select(_db.accounts)).get();
      final accountIds = userAccounts.map((a) => a.id).toSet();

      // Разделяем расходы и доходы из импорта
      final expenses = importedRows.where((r) => r.amountKopecks < 0).toList();
      final incomes = importedRows.where((r) => r.amountKopecks > 0).toList();

      for (final expense in expenses) {
        final absAmount = expense.amountKopecks.abs();

        for (final income in incomes) {
          if (income.amountKopecks.abs() != absAmount) continue;

          final timeDiff = income.date.difference(expense.date).abs();
          final merchantLower = expense.merchantName.toLowerCase();
          final isSbp = merchantLower.contains('сбп') ||
              merchantLower.contains('sbp') ||
              income.merchantName.toLowerCase().contains('сбп');

          TransferScenario? scenario;

          if (isSbp && timeDiff.inMinutes <= sbpToleranceMinutes) {
            scenario = TransferScenario.sbp;
          } else if (timeDiff.inDays <= interbankToleranceDays) {
            scenario = TransferScenario.interbank;
          }

          if (scenario == null) continue;

          // Проверяем: доход мог быть на другой счёт пользователя
          // (при импорте мы знаем только sourceAccount, target определяем по БД)
          final targetAccount = await _findTargetAccount(
            absAmount: absAmount,
            date: income.date,
            excludeAccountId: sourceAccountId,
            accountIds: accountIds,
            toleranceDays: interbankToleranceDays,
          );

          if (targetAccount != null || scenario == TransferScenario.sbp) {
            transfers.add(TransferCandidate(
              id: const Uuid().v4(),
              scenario: scenario,
              expenseRow: expense,
              incomeRow: income,
              amountKopecks: absAmount,
              sourceAccountId: sourceAccountId,
              targetAccountId: targetAccount ?? sourceAccountId,
              timeDifference: timeDiff,
            ));
          }
        }
      }

      _logger.i('DetectTransfers: найдено ${transfers.length} переводов');
    } catch (e, st) {
      _logger.e('DetectTransfersUseCase failed', error: e, stackTrace: st);
    }

    return transfers;
  }

  Future<String?> _findTargetAccount({
    required int absAmount,
    required DateTime date,
    required String excludeAccountId,
    required Set<String> accountIds,
    required int toleranceDays,
  }) async {
    try {
      final dateStart = date.subtract(Duration(days: toleranceDays));
      final dateEnd = date.add(Duration(days: toleranceDays));

      final matches = await (_db.select(_db.transactions)
            ..where((t) =>
                t.accountId.isNotIn([excludeAccountId]) &
                t.amount.equals(absAmount) &
                t.type.equals(TransactionType.income.name) &
                t.date.isBetween(Variable(dateStart), Variable(dateEnd))))
          .get();

      for (final m in matches) {
        if (accountIds.contains(m.accountId)) return m.accountId;
      }
    } catch (e, st) {
      _logger.e('_findTargetAccount failed', error: e, stackTrace: st);
    }
    return null;
  }
}