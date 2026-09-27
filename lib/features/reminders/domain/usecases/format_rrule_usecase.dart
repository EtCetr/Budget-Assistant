/// Человекочитаемое описание RRULE на русском (ТЗ 6.3.10/6.3.12:
/// «Каждый день», «Каждые 2 недели: Пн, Ср» и т.д.).
class FormatRRuleUseCase {
  static const Map<String, String> _dayNames = {
    'MO': 'Пн',
    'TU': 'Вт',
    'WE': 'Ср',
    'TH': 'Чт',
    'FR': 'Пт',
    'SA': 'Сб',
    'SU': 'Вс',
  };
  static const Map<String, String> _monthNames = {
    '01': 'янв',
    '02': 'фев',
    '03': 'мар',
    '04': 'апр',
    '05': 'мая',
    '06': 'июн',
    '07': 'июл',
    '08': 'авг',
    '09': 'сен',
    '10': 'окт',
    '11': 'ноя',
    '12': 'дек',
  };

  String call(String? rrule) {
    if (rrule == null || rrule.isEmpty) return 'Однократно';
    try {
      final parts = <String, String>{};
      for (final pair in rrule.split(';')) {
        final kv = pair.split('=');
        if (kv.length == 2) parts[kv[0]] = kv[1];
      }
      final freq = parts['FREQ'];
      final interval = int.tryParse(parts['INTERVAL'] ?? '1') ?? 1;
      if (freq == null) return 'Свой график';
      final sb = StringBuffer();
      switch (freq) {
        case 'DAILY':
          sb.write(interval == 1 ? 'Каждый день' : 'Каждые $interval дн.');
        case 'WEEKLY':
          sb.write(interval == 1 ? 'Каждую неделю' : 'Каждые $interval нед.');
          final days = parts['BYDAY']
              ?.split(',')
              .map((d) => _dayNames[d] ?? d)
              .join(', ');
          if (days != null && days.isNotEmpty) sb.write(': $days');
        case 'MONTHLY':
          sb.write(interval == 1 ? 'Каждый месяц' : 'Каждые $interval мес.');
          final md = parts['BYMONTHDAY'];
          if (md != null) sb.write(': $md-е число');
        default:
          return 'Свой график';
      }
      final until = parts['UNTIL'];
      if (until != null && until.length >= 8) {
        final y = until.substring(0, 4);
        final m = until.substring(4, 6);
        final d = until.substring(6, 8);
        sb.write(' до $d ${_monthNames[m] ?? m} $y');
      }
      return sb.toString();
    } catch (_) {
      return 'Свой график';
    }
  }
}