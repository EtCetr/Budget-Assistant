import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurrence_settings.freezed.dart';

/// Частота повторения (конструктор RRULE, ТЗ 6.3.12.4).
enum RecurrenceFreq { daily, weekly, monthly, yearly }

/// Настройки повторения для BuildRRuleUseCase.
/// Подмножество iCal RRULE: FREQ, INTERVAL, BYDAY, BYMONTHDAY, BYMONTH, UNTIL.
@freezed
abstract class RecurrenceSettings with _$RecurrenceSettings {
  const factory RecurrenceSettings({
    @Default(RecurrenceFreq.weekly) RecurrenceFreq freq,
    @Default(1) int interval,
    /// 1..7 = Пн..Вс (DateTime.monday..sunday).
    @Default(<int>[]) List<int> byWeekday,
    /// 1..31 для monthly/yearly.
    int? byMonthDay,
    /// 1..12 для yearly.
    int? byMonth,
    DateTime? until,
  }) = _RecurrenceSettings;
}