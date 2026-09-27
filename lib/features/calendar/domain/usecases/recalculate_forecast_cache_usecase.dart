import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../entities/forecast_cache_entry.dart';
import '../repositories/forecast_cache_repository.dart';

/// Событие прогноза (дата + сумма + категория), передаётся в изолят.
class ForecastEventDto {
  const ForecastEventDto({
    required this.dateUtc,
    required this.amountKopecks,
    this.categoryId,
    required this.isExpense,
  });

  final DateTime dateUtc;
  final int amountKopecks;
  final String? categoryId;
  final bool isExpense;
}

class _RecalcInput {
  const _RecalcInput({
    required this.userId,
    required this.spaceId,
    required this.monthKey,
    required this.events,
  });

  final String userId;
  final String? spaceId;
  final String monthKey;
  final List<ForecastEventDto> events;
}

/// Тяжёлая часть пересчёта кэша прогноза (ТОМ 2 §20.1): суммы расходов
/// месяца по категориям. Выполняется в compute-изоляте.
List<ForecastCacheEntry> _computeCategoryForecast(_RecalcInput input) {
  final totals = <String?, int>{};
  for (final e in input.events) {
    if (!e.isExpense) continue;
    totals[e.categoryId] = (totals[e.categoryId] ?? 0) + e.amountKopecks;
  }
  final now = DateTime.now().toUtc();
  return [
    for (final entry in totals.entries)
      ForecastCacheEntry(
        id: '${input.userId}_${input.monthKey}_${entry.key ?? 'total'}',
        userId: input.userId,
        spaceId: input.spaceId,
        monthYear: input.monthKey,
        categoryId: entry.key,
        forecastedAmount: entry.value,
        updatedAt: now,
      ),
  ];
}

/// Пересчёт кэша прогноза месяца (ТЗ 6.3.7):
/// события -> compute-изолят -> replaceMonth.
class RecalculateForecastCacheUseCase {
  RecalculateForecastCacheUseCase({
    required ForecastCacheRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final ForecastCacheRepository _repository;
  final Logger _logger;

  Future<void> call({
    required String userId,
    String? spaceId,
    required String monthKey,
    required List<ForecastEventDto> events,
  }) async {
    try {
      final entries = await compute(
        _computeCategoryForecast,
        _RecalcInput(
          userId: userId,
          spaceId: spaceId,
          monthKey: monthKey,
          events: events,
        ),
      );
      await _repository.replaceMonth(
        userId: userId,
        spaceId: spaceId,
        monthYear: monthKey,
        entries: entries,
      );
      _logger.i('Forecast cache recalculated: $monthKey (${entries.length})');
    } catch (e, st) {
      _logger.e('RecalculateForecastCache failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}