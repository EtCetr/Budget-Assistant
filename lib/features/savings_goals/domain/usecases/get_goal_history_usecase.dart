import 'package:logger/logger.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/repositories/transactions_repository.dart';

/// История пополнений/изъятий цели + график накопления
/// (ТЗ 6.3.47.6). График — кумулятивная сумма по датам; валюта у цели
/// одна, поэтому конвертация не требуется.
class GetGoalHistoryUseCase {
  GetGoalHistoryUseCase({
    required TransactionsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final TransactionsRepository _repository;
  final Logger _logger;

  Future<GoalHistory> call(String goalId) async {
    try {
      // Репозиторий возвращает транзакции по дате возрастанию.
      final transactions = await _repository.getTransactionsByGoalId(goalId);

      final chartData = <ChartPoint>[];
      int cumulative = 0;
      for (final t in transactions) {
        if (!t.isWithdrawal) {
          cumulative += t.amount;
          chartData.add(ChartPoint(
            date: t.date,
            cumulativeAmountKopecks: cumulative,
          ));
        }
      }

      return GoalHistory(
        transactions: transactions,
        chartData: chartData,
      );
    } catch (e, st) {
      _logger.e('GetGoalHistoryUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}

/// История цели.
class GoalHistory {
  const GoalHistory({
    required this.transactions,
    required this.chartData,
  });

  final List<Transaction> transactions;
  final List<ChartPoint> chartData;
}

/// Точка графика накопления.
class ChartPoint {
  const ChartPoint({
    required this.date,
    required this.cumulativeAmountKopecks,
  });

  final DateTime date;
  final int cumulativeAmountKopecks;
}