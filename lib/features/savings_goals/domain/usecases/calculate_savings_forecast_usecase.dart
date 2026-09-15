import 'package:logger/logger.dart';

/// Прогнозная линия графика (среднее за 30 дней).
///
/// Упрощённая версия: полная реализация — в микро-коммите 12.7.
class CalculateSavingsForecastUseCase {
  CalculateSavingsForecastUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  Future<List<ForecastPoint>> call({
    required String userId,
    String? spaceId,
    required DateTime endDate,
  }) async {
    try {
      // Упрощённая версия: возвращаем пустой список
      return const [];
    } catch (e, st) {
      _logger.e('CalculateSavingsForecastUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}

class ForecastPoint {
  const ForecastPoint({
    required this.date,
    required this.forecastedAmountKopecks,
  });

  final DateTime date;
  final int forecastedAmountKopecks;
}