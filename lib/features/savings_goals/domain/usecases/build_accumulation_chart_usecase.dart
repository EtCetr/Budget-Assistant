import 'package:logger/logger.dart';

/// Построение графика накопления (SQL оконная функция).
///
/// Упрощённая версия: полная реализация — в микро-коммите 12.7.
class BuildAccumulationChartUseCase {
  BuildAccumulationChartUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  Future<List<AccumulationPoint>> call({
    required String userId,
    String? spaceId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Упрощённая версия: возвращаем пустой список
      // Полная реализация будет в 12.7 с SQL оконной функцией
      return const [];
    } catch (e, st) {
      _logger.e('BuildAccumulationChartUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}

class AccumulationPoint {
  const AccumulationPoint({
    required this.date,
    required this.cumulativeAmountKopecks,
  });

  final DateTime date;
  final int cumulativeAmountKopecks;
}