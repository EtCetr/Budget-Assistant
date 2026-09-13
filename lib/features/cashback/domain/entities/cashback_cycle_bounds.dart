import 'package:freezed_annotation/freezed_annotation.dart';

part 'cashback_cycle_bounds.freezed.dart';

/// Границы цикла кэшбэка в UTC (рассчитаны из локального времени, ТОМ 4 Правило 5).
@freezed
abstract class CashbackCycleBounds with _$CashbackCycleBounds {
  const factory CashbackCycleBounds({
    required DateTime startUtc,
    required DateTime endUtc,
  }) = _CashbackCycleBounds;
}