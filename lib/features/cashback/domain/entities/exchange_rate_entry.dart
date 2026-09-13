import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_rate_entry.freezed.dart';

/// Курс валют (Этап 10, ТОМ 2 §18.2).
@freezed
abstract class ExchangeRateEntry with _$ExchangeRateEntry {
  const factory ExchangeRateEntry({
    required String id,
    required String fromCurrency,
    required String toCurrency,
    required DateTime date,
    required double rate,
    required String source,
    required DateTime createdAt,
  }) = _ExchangeRateEntry;
}