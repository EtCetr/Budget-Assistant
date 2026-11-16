import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/features/calendar/domain/repositories/holidays_repository.dart';
import 'package:budget_assistant/features/reminders/domain/entities/snooze_history_entry.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/clear_reminder_draft_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/format_snooze_history_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/get_day_context_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/restore_reminder_draft_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/save_reminder_draft_usecase.dart';
import '../../../helpers/fake_reminders_repository.dart';

class _MockHolidays extends Mock implements HolidaysRepository {}

/// Этап 24: черновики формы (автосейв не роняет UI), история откладываний
/// и контекст дня для экрана деталей.
void main() {
  late FakeRemindersRepository repo;
  late Logger logger;
  late SaveReminderDraftUseCase save;
  late RestoreReminderDraftUseCase restore;
  late ClearReminderDraftUseCase clear;
  late FormatSnoozeHistoryUseCase history;

  setUp(() {
    repo = FakeRemindersRepository();
    logger = Logger(level: Level.off);
    save = SaveReminderDraftUseCase(repository: repo, logger: logger);
    restore = RestoreReminderDraftUseCase(repository: repo, logger: logger);
    clear = ClearReminderDraftUseCase(repository: repo, logger: logger);
    history = FormatSnoozeHistoryUseCase(logger: logger);
  });

  group('Черновики формы', () {
    test('автосейв сохраняет черновик', () async {
      await save('u1', makeReminderDraft(title: 'Интернет'));

      expect(repo.draft?.title, 'Интернет');
    });

    test('ошибка автосейва не роняет форму', () async {
      repo.error = Exception('db down');

      await save('u1', makeReminderDraft());

      expect(repo.calls, contains('saveDraft'));
    });

    test('восстановление возвращает свежий черновик', () async {
      await save('u1', makeReminderDraft(title: 'Интернет'));

      expect((await restore('u1'))?.title, 'Интернет');
    });

    test('черновика нет — null', () async {
      expect(await restore('u1'), isNull);
    });

    test('ошибка восстановления — null, без исключения', () async {
      repo.error = Exception('db down');

      expect(await restore('u1'), isNull);
    });

    test('очистка удаляет черновик', () async {
      await save('u1', makeReminderDraft());

      await clear('u1');

      expect(repo.draft, isNull);
    });

    test('ошибка очистки не роняет форму', () async {
      repo.error = Exception('db down');

      await clear('u1');

      expect(repo.calls, contains('deleteDraftByUser'));
    });
  });

  group('FormatSnoozeHistoryUseCase', () {
    test('null и пустая строка — пустой список', () {
      expect(history(null), isEmpty);
      expect(history(''), isEmpty);
    });

    test('валидный JSON парсится', () {
      final json = jsonEncode([
        {
          'atUtc': '2026-07-10T00:00:00Z',
          'fromUtc': '2026-07-12T00:00:00Z',
          'toUtc': '2026-07-15T00:00:00Z',
        },
        {
          'atUtc': '2026-07-15T00:00:00Z',
          'fromUtc': '2026-07-15T00:00:00Z',
          'toUtc': '2026-07-18T00:00:00Z',
        },
      ]);

      final list = history(json);

      expect(list.length, 2);
      expect(list.first.toUtc, DateTime.utc(2026, 7, 15));
    });

    test('битый JSON — пустой список', () {
      expect(history('{не json'), isEmpty);
    });

    test('не массив — пустой список', () {
      expect(history('{"a":1}'), isEmpty);
    });

    test('запись без обязательных полей пропускается', () {
      final json = jsonEncode([
        {'atUtc': '2026-07-10T00:00:00Z'},
      ]);

      expect(history(json), isEmpty);
    });

    test('описание записи: дата и число дней', () {
      final entry = SnoozeHistoryEntry(
        atUtc: DateTime.utc(2026, 7, 10),
        fromUtc: DateTime.utc(2026, 7, 15),
        toUtc: DateTime.utc(2026, 7, 18),
      );

      expect(history.formatEntry(entry), 'Отложено 10.07 на 3 дн.');
    });
  });

  group('GetDayContextUseCase', () {
    late _MockHolidays holidays;
    late GetDayContextUseCase useCase;
    final day = DateTime.utc(2026, 7, 15);

    setUp(() {
      holidays = _MockHolidays();
      when(() => holidays.watchAllEnabled(
            userId: any(named: 'userId'),
            spaceId: any(named: 'spaceId'),
          )).thenAnswer((_) => Stream.value(const []));
      useCase = GetDayContextUseCase(
        holidaysRepository: holidays,
        remindersRepository: repo,
        logger: logger,
      );
    });

    test('пустой день: без праздника и без других напоминаний', () async {
      final ctx = await useCase(day: day, userId: 'u1');

      expect(ctx.holiday, isNull);
      expect(ctx.otherRemindersCount, 0);
    });

    test('считает другие активные, исключая себя и завершённые', () async {
      await repo.insert(makeReminder(id: 'self'));
      await repo.insert(makeReminder(id: 'other'));
      await repo.insert(makeReminder(id: 'done', isCompleted: true));

      final ctx = await useCase(
        day: day,
        userId: 'u1',
        excludeReminderId: 'self',
      );

      expect(ctx.otherRemindersCount, 1);
    });

    test('ошибка источника — пустой контекст без исключения', () async {
      repo.error = Exception('db down');

      final ctx = await useCase(day: day, userId: 'u1');

      expect(ctx.holiday, isNull);
      expect(ctx.otherRemindersCount, 0);
    });
  });
}