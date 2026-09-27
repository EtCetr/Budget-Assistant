import 'package:freezed_annotation/freezed_annotation.dart';

part 'forecast_cache_entry.freezed.dart';

/// Строка кэша прогноза баланса (Этап 14, ТОМ 2 §20.1).
///
/// Локальный кэш: без sync_status и created_at — UI читает готовые агрегаты,
/// пересчёт выполняет RecalculateForecastCacheUseCase (Этап 14.4).
@freezed
abstract class ForecastCacheEntry with _$ForecastCacheEntry {
  const factory ForecastCacheEntry({
    required String id,
    required String userId,
    String? spaceId,
    /// Формат 'YYYY-MM'.
    required String monthYear,
    /// NULL = тотал по пространству/пользователю.
    String? categoryId,
    /// Копейки.
    @Default(0) int forecastedAmount,
    required DateTime updatedAt,
  }) = _ForecastCacheEntry;
}