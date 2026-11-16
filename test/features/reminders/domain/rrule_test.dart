import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/reminders/domain/models/recurrence_settings.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/build_rrule_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/format_rrule_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/get_next_occurrences_usecase.dart';

/// Этап 24: RRULE — сборка строки, человекочитаемое описание, вхождения.
/// Подмножество iCal: FREQ / INTERVAL / BYDAY / BYMONTHDAY / BYMONTH / UNTIL.
void main() {
  late BuildRRuleUseCase build;
  late FormatRRuleUseCase format;
  late GetNextOccurrencesUseCase next;

  setUp(() {
    build = BuildRRuleUseCase();
    format = FormatRRuleUseCase();
    next = GetNextOccurrencesUseCase(logger: Logger(level: Level.off));
  });

  group('BuildRRuleUseCase', () {
    test('ежедневно без интервала', () {
      expect(
        build(const RecurrenceSettings(freq: RecurrenceFreq.daily)),
        'FREQ=DAILY',
      );
    });

    test('еженедельно по дням недели', () {
      expect(
        build(const RecurrenceSettings(
          freq: RecurrenceFreq.weekly,
          byWeekday: [1, 3, 5],
        )),
        'FREQ=WEEKLY;BYDAY=MO,WE,FR',
      );
    });

    test('интервал больше 1 добавляется', () {
      expect(
        build(const RecurrenceSettings(
          freq: RecurrenceFreq.daily,
          interval: 3,
        )),
        'FREQ=DAILY;INTERVAL=3',
      );
    });

    test('ежемесячно по числу', () {
      expect(
        build(const RecurrenceSettings(
          freq: RecurrenceFreq.monthly,
          byMonthDay: 15,
        )),
        'FREQ=MONTHLY;BYMONTHDAY=15',
      );
    });

    test('ежегодно: месяц и число', () {
      expect(
        build(const RecurrenceSettings(
          freq: RecurrenceFreq.yearly,
          byMonth: 3,
          byMonthDay: 10,
        )),
        'FREQ=YEARLY;BYMONTH=3;BYMONTHDAY=10',
      );
    });

    test('UNTIL форматируется в UTC-штамп', () {
      expect(
        build(RecurrenceSettings(
          freq: RecurrenceFreq.monthly,
          byMonthDay: 1,
          until: DateTime.utc(2026, 12, 31, 23, 59, 59),
        )),
        'FREQ=MONTHLY;BYMONTHDAY=1;UNTIL=20261231T235959Z',
      );
    });

    test('дни недели игнорируются не для weekly', () {
      expect(
        build(const RecurrenceSettings(
          freq: RecurrenceFreq.monthly,
          byWeekday: [1, 2],
          byMonthDay: 5,
        )),
        'FREQ=MONTHLY;BYMONTHDAY=5',
      );
    });

    test('недопустимые номера дней отбрасываются', () {
      expect(
        build(const RecurrenceSettings(
          freq: RecurrenceFreq.weekly,
          byWeekday: [0, 8, 1],
        )),
        'FREQ=WEEKLY;BYDAY=MO',
      );
    });

    test('пустой список дней не добавляет BYDAY', () {
      expect(build(const RecurrenceSettings()), 'FREQ=WEEKLY');
    });
  });

  group('FormatRRuleUseCase', () {
    test('null и пустая строка — однократно', () {
      expect(format(null), 'Однократно');
      expect(format(''), 'Однократно');
    });

    test('ежедневно и с интервалом', () {
      expect(format('FREQ=DAILY'), 'Каждый день');
      expect(format('FREQ=DAILY;INTERVAL=3'), 'Каждые 3 дн.');
    });

    test('еженедельно с днями', () {
      expect(
        format('FREQ=WEEKLY;BYDAY=MO,WE'),
        'Каждую неделю: Пн, Ср',
      );
      expect(format('FREQ=WEEKLY;INTERVAL=2'), 'Каждые 2 нед.');
    });

    test('ежемесячно с числом и интервалом', () {
      expect(
        format('FREQ=MONTHLY;BYMONTHDAY=15'),
        'Каждый месяц: 15-е число',
      );
      expect(format('FREQ=MONTHLY;INTERVAL=6'), 'Каждые 6 мес.');
    });

    test('ежегодно с датой', () {
      expect(
        format('FREQ=YEARLY;BYMONTH=03;BYMONTHDAY=10'),
        'Каждый год: 10 мар',
      );
    });

    test('UNTIL дописывает срок', () {
      expect(
        format('FREQ=MONTHLY;BYMONTHDAY=1;UNTIL=20261231T235959Z'),
        'Каждый месяц: 1-е число до 31 дек 2026',
      );
    });

    test('без FREQ или неизвестный FREQ — свой график', () {
      expect(format('INTERVAL=2'), 'Свой график');
      expect(format('FREQ=HOURLY'), 'Свой график');
    });
  });

  group('GetNextOccurrencesUseCase', () {
    final start = DateTime.utc(2026, 7, 15, 10);

    test('однократное без ограничения — сама дата', () {
      expect(next(startUtc: start), [start]);
    });

    test('однократное в прошлом — пусто', () {
      expect(
        next(startUtc: start, afterUtc: DateTime.utc(2026, 7, 16)),
        isEmpty,
      );
    });

    test('ежедневно: строго 3 вхождения по умолчанию', () {
      final list = next(startUtc: start, rrule: 'FREQ=DAILY');

      expect(list, [
        DateTime.utc(2026, 7, 15, 10),
        DateTime.utc(2026, 7, 16, 10),
        DateTime.utc(2026, 7, 17, 10),
      ]);
    });

    test('count ограничивает выдачу', () {
      expect(next(startUtc: start, rrule: 'FREQ=DAILY', count: 1).length, 1);
    });

    test('afterUtc отсекает прошедшие срабатывания', () {
      final list = next(
        startUtc: start,
        rrule: 'FREQ=DAILY',
        afterUtc: DateTime.utc(2026, 7, 16, 10),
      );

      expect(list.first, DateTime.utc(2026, 7, 16, 10));
      expect(list.length, 3);
    });

    test('еженедельно по понедельникам', () {
      final list = next(
        startUtc: DateTime.utc(2026, 7, 13, 10),
        rrule: 'FREQ=WEEKLY;BYDAY=MO',
      );

      expect(list.length, 3);
      expect(list.every((d) => d.weekday == DateTime.monday), isTrue);
    });

    test('UNTIL ограничивает список', () {
      final list = next(
        startUtc: start,
        rrule: 'FREQ=DAILY;UNTIL=20260717T100000Z',
        count: 10,
      );

      expect(list.length, lessThan(10));
      expect(
        list.every((d) => !d.isAfter(DateTime.utc(2026, 7, 17, 10))),
        isTrue,
      );
    });

    test('битый RRULE — fallback на однократное', () {
      expect(next(startUtc: start, rrule: 'НЕ_ПРАВИЛО'), [start]);
    });

    test('битый RRULE в прошлом — пусто', () {
      expect(
        next(
          startUtc: start,
          rrule: 'НЕ_ПРАВИЛО',
          afterUtc: DateTime.utc(2026, 7, 16),
        ),
        isEmpty,
      );
    });

    test('контракт: строку BuildRRule читает GetNextOccurrences (D24-30)', () {
      final rule = build(const RecurrenceSettings(freq: RecurrenceFreq.daily));
      final list = next(startUtc: start, rrule: rule);

      expect(list.length, 3);
      expect(list.first, start);
    });

    test('контракт: еженедельная строка тоже читается', () {
      final rule = build(const RecurrenceSettings(
        freq: RecurrenceFreq.weekly,
        byWeekday: [1],
      ));
      final list = next(startUtc: DateTime.utc(2026, 7, 13, 10), rrule: rule);

      expect(list.length, 3);
      expect(list.every((d) => d.weekday == DateTime.monday), isTrue);
    });
  });
}