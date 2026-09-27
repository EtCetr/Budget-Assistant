import '../models/recurrence_settings.dart';

/// Собирает iCal RRULE строку из настроек конструктора (ТЗ 6.3.12.4).
/// Пишем строку вручную (наше подмножество); чтение — пакет rrule.
class BuildRRuleUseCase {
  static const Map<int, String> _dayCodes = {
    1: 'MO',
    2: 'TU',
    3: 'WE',
    4: 'TH',
    5: 'FR',
    6: 'SA',
    7: 'SU',
  };

  String call(RecurrenceSettings s) {
    final sb = StringBuffer('FREQ=${s.freq.name.toUpperCase()}');
    if (s.interval > 1) sb.write(';INTERVAL=${s.interval}');
    if (s.freq == RecurrenceFreq.weekly && s.byWeekday.isNotEmpty) {
      final days = s.byWeekday
          .where(_dayCodes.containsKey)
          .map((d) => _dayCodes[d])
          .join(',');
      if (days.isNotEmpty) sb.write(';BYDAY=$days');
    }
    if (s.freq == RecurrenceFreq.monthly && s.byMonthDay != null) {
      sb.write(';BYMONTHDAY=${s.byMonthDay}');
    }
    if (s.freq == RecurrenceFreq.yearly) {
      if (s.byMonth != null) sb.write(';BYMONTH=${s.byMonth}');
      if (s.byMonthDay != null) sb.write(';BYMONTHDAY=${s.byMonthDay}');
    }
    if (s.until != null) {
      final u = s.until!.toUtc();
      String two(int v) => v.toString().padLeft(2, '0');
      final stamp = '${u.year.toString().padLeft(4, '0')}${two(u.month)}'
          '${two(u.day)}T${two(u.hour)}${two(u.minute)}${two(u.second)}Z';
      sb.write(';UNTIL=$stamp');
    }
    return sb.toString();
  }
}