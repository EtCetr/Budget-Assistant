import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/build_reminder_draft_usecase.dart';
import 'package:budget_assistant/features/reminders/domain/usecases/validate_reminder_form_usecase.dart';
import '../../../helpers/fake_reminders_repository.dart';

/// Этап 24: валидация формы напоминания и сборка параметров создания.
void main() {
  late ValidateReminderFormUseCase validate;
  late BuildReminderDraftUseCase build;
  final now = DateTime.utc(2026, 7, 15, 9);

  setUp(() {
    validate = ValidateReminderFormUseCase();
    build = BuildReminderDraftUseCase();
  });

  String? check({
    String title = 'Оплатить интернет',
    String? description,
    DateTime? remindAt,
    int? amount,
    String scope = 'personal',
    String? assigneeId,
    bool isNew = true,
  }) =>
      validate(
        draft: makeReminderDraft(
          title: title,
          description: description,
          remindAt: remindAt ?? DateTime.utc(2026, 7, 20, 10),
          expectedAmountKopecks: amount,
          scope: scope,
          assigneeId: assigneeId,
        ),
        isNew: isNew,
        nowUtc: now,
      );

  group('ValidateReminderFormUseCase', () {
    test('пустое название', () {
      expect(check(title: ''), 'Укажите название');
      expect(check(title: '   '), 'Укажите название');
    });

    test('название длиннее 100 символов', () {
      expect(
        check(title: 'А' * 101),
        'Название: не более 100 символов',
      );
    });

    test('название ровно 100 символов допустимо', () {
      expect(check(title: 'А' * 100), isNull);
    });

    test('описание длиннее 500 символов', () {
      expect(
        check(description: 'А' * 501),
        'Описание: не более 500 символов',
      );
    });

    test('дата не указана', () {
      final result = validate(
        draft: makeReminderDraft(remindAt: DateTime.utc(2026, 7, 20)),
        isNew: true,
        nowUtc: now,
      );
      expect(result, isNull);

      final noDate = validate(
        draft: makeReminderDraft().copyWith(remindAt: null),
        isNew: true,
        nowUtc: now,
      );
      expect(noDate, 'Укажите дату и время');
    });

    test('новая дата в прошлом отклоняется', () {
      expect(
        check(remindAt: DateTime.utc(2026, 7, 10)),
        'Дата должна быть в будущем',
      );
    });

    test('при редактировании прошлая дата допустима', () {
      expect(
        check(remindAt: DateTime.utc(2026, 7, 10), isNew: false),
        isNull,
      );
    });

    test('сумма должна быть больше нуля', () {
      expect(check(amount: 0), 'Сумма должна быть больше 0');
      expect(check(amount: -100), 'Сумма должна быть больше 0');
      expect(check(amount: 150000), isNull);
    });

    test('ответственный только для семейной области', () {
      expect(
        check(assigneeId: 'm1'),
        'Ответственный возможен только для семейной области',
      );
      expect(check(scope: 'family', assigneeId: 'm1'), isNull);
    });

    test('валидный черновик проходит', () {
      expect(check(), isNull);
    });
  });

  group('BuildReminderDraftUseCase', () {
    test('личная область: пространство и ответственный сбрасываются', () {
      final p = build(
        draft: makeReminderDraft(assigneeId: 'm1'),
        userId: 'u1',
        familySpaceId: 's1',
      );

      expect(p.spaceId, isNull);
      expect(p.assigneeId, isNull);
    });

    test('семейная область: пространство и ответственный сохраняются', () {
      final p = build(
        draft: makeReminderDraft(scope: 'family', assigneeId: 'm1'),
        userId: 'u1',
        familySpaceId: 's1',
      );

      expect(p.spaceId, 's1');
      expect(p.assigneeId, 'm1');
    });

    test('семейная область без активного пространства — личное', () {
      final p = build(
        draft: makeReminderDraft(scope: 'family', assigneeId: 'm1'),
        userId: 'u1',
      );

      expect(p.spaceId, isNull);
      expect(p.assigneeId, isNull);
    });

    test('название обрезается, пустое описание становится null', () {
      final p = build(
        draft: makeReminderDraft(title: '  Интернет  ', description: '   '),
        userId: 'u1',
      );

      expect(p.title, 'Интернет');
      expect(p.description, isNull);
    });

    test('сумма, правило, связи и приоритет пробрасываются', () {
      final p = build(
        draft: makeReminderDraft(
          description: '  ежемесячно  ',
          recurrenceRule: 'FREQ=MONTHLY;BYMONTHDAY=15',
          expectedAmountKopecks: 90000,
          linkedCategoryId: 'c1',
          linkedAccountId: 'a1',
          linkedRecurringId: 'rec1',
          priority: 'high',
        ),
        userId: 'u1',
      );

      expect(p.description, 'ежемесячно');
      expect(p.recurrenceRule, 'FREQ=MONTHLY;BYMONTHDAY=15');
      expect(p.expectedAmount, 90000);
      expect(p.linkedCategoryId, 'c1');
      expect(p.linkedAccountId, 'a1');
      expect(p.linkedRecurringId, 'rec1');
      expect(p.priority, 'high');
      expect(p.remindAtUtc, DateTime.utc(2026, 7, 15, 10));
    });
  });
}