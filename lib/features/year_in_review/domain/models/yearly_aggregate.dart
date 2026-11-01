import 'package:freezed_annotation/freezed_annotation.dart';

part 'yearly_aggregate.freezed.dart';

/// Доменная сущность строки кэша годовых итогов (домен не знает про Drift).
@freezed
abstract class YearlyAggregate with _$YearlyAggregate {
  const factory YearlyAggregate({
    required String id,
    required String userId,
    required String? spaceId,
    required int year,
    required String dataJson,
    required bool isViewed,
    required DateTime lastCalculatedAt,
    required String syncStatus,
  }) = _YearlyAggregate;
}

/// Год в списке экрана «Статистика по годам».
@freezed
abstract class YearInReviewYearInfo with _$YearInReviewYearInfo {
  const factory YearInReviewYearInfo({
    required int year,
    /// Есть ли уже посчитанный кэш в yearly_aggregates.
    @Default(false) bool isCalculated,
    @Default(false) bool isViewed,
    @Default(0) int transactionCount,
  }) = _YearInReviewYearInfo;
}