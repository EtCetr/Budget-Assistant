import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/calendar/domain/entities/holiday.dart';
import 'package:budget_assistant/features/calendar/domain/usecases/create_holiday_usecase.dart';
import 'package:budget_assistant/features/calendar/domain/usecases/delete_holiday_usecase.dart';
import 'package:budget_assistant/features/calendar/domain/usecases/toggle_holiday_usecase.dart';
import 'package:budget_assistant/features/calendar/domain/usecases/update_holiday_usecase.dart';
import '../../../helpers/fake_holidays_repository.dart';

/// Этап 24: праздники — пресеты РФ read-only, личные CRUD (ТЗ 6.3.8).
/// HolidayX — расширение, поэтому entities/holiday.dart импортируется напрямую.
void main() {
  late FakeHolidaysRepository repo;
  late Logger logger;
  late CreateHolidayUseCase create;
  late UpdateHolidayUseCase update;
  late DeleteHolidayUseCase delete;
  late ToggleHolidayUseCase toggle;

  setUp(() {
    repo = FakeHolidaysRepository();
    logger = Logger(level: Level.off);
    create = CreateHolidayUseCase(repository: repo, logger: logger);
    update = UpdateHolidayUseCase(repository: repo, logger: logger);
    delete = DeleteHolidayUseCase(repository: repo, logger: logger);
    toggle = ToggleHolidayUseCase(repository: repo, logger: logger);
  });

  group('HolidayX.matchesDay', () {
    test('ежегодный матчится по месяцу и дню любого года', () {
      final h = makeHoliday(id: 'h', date: DateTime.utc(2026, 7, 15));
      expect(h.matchesDay(DateTime.utc(2027, 7, 15)), isTrue);
      expect(h.matchesDay(DateTime.utc(2027, 7, 16)), isFalse);
    });

    test('одноразовый матчится только точной датой', () {
      final h = makeHoliday(
        id: 'h',
        date: DateTime.utc(2026, 7, 15),
        isAnnuallyRecurring: false,
      );
      expect(h.matchesDay(DateTime.utc(2026, 7, 15)), isTrue);
      expect(h.matchesDay(DateTime.utc(2027, 7, 15)), isFalse);
    });
  });

  group('CreateHolidayUseCase', () {
    test('личный праздник: не пресет, включён, pending', () async {
      await create(CreateHolidayParams(
        userId: 'u1',
        name: 'Юбилей',
        dateUtc: DateTime.utc(2026, 9, 1),
        iconEmoji: '🎉',
      ));

      final h = repo.holidays.values.single;
      expect(h.isPreset, isFalse);
      expect(h.isEnabled, isTrue);
      expect(h.syncStatus, SyncStatus.pending);
      expect(h.name, 'Юбилей');
      expect(h.iconEmoji, '🎉');
    });
  });

  group('UpdateHolidayUseCase', () {
    test('личный праздник обновляется с pending', () async {
      final h = makeHoliday(id: 'h');
      repo.holidays['h'] = h;

      await update(h.copyWith(name: 'Новое имя'));

      expect(repo.holidays['h']!.name, 'Новое имя');
      expect(repo.holidays['h']!.syncStatus, SyncStatus.pending);
    });

    test('пресет не обновляется', () async {
      final h = makeHoliday(id: 'p', isPreset: true, name: 'Новый год');
      repo.holidays['p'] = h;

      await update(h.copyWith(name: 'Сломано'));

      expect(repo.holidays['p']!.name, 'Новый год');
    });
  });

  group('DeleteHolidayUseCase', () {
    test('личный праздник удаляется', () async {
      repo.holidays['h'] = makeHoliday(id: 'h');

      await delete('h');

      expect(repo.holidays, isEmpty);
    });

    test('пресет не удаляется', () async {
      repo.holidays['p'] = makeHoliday(id: 'p', isPreset: true);

      await delete('p');

      expect(repo.holidays.length, 1);
    });

    test('отсутствующий праздник не падает', () async {
      await delete('missing');
      expect(repo.calls, contains('getById'));
    });
  });

  group('ToggleHolidayUseCase', () {
    test('личный праздник переключается', () async {
      repo.holidays['h'] = makeHoliday(id: 'h');

      await toggle('h', false);

      expect(repo.enabledUpdates.single.enabled, isFalse);
      expect(repo.holidays['h']!.isEnabled, isFalse);
    });

    test('пресет не отключается', () async {
      repo.holidays['p'] = makeHoliday(id: 'p', isPreset: true);

      await toggle('p', false);

      expect(repo.enabledUpdates, isEmpty);
      expect(repo.holidays['p']!.isEnabled, isTrue);
    });
  });
}