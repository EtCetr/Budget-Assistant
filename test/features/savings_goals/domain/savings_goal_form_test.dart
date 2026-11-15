import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/savings_goals/domain/entities/savings_goal_form_draft.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/build_savings_goal_draft_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/validate_savings_goal_form_usecase.dart';

/// Этап 24: валидация формы цели и построение черновика (ТЗ 6.3.17).
/// Сумма зачисления баланса — Вариант Б (12.5.1): пусто = 100% баланса.
SavingsGoalFormDraft _draft({
  String? goalId,
  String name = 'Отпуск',
  int? target = 10000000,
  DateTime? deadline,
  String goalType = 'virtual',
  String? linkedAccountId,
  bool seedBalanceOnCreate = true,
  int? seedAmountKopecks,
}) =>
    SavingsGoalFormDraft(
      goalId: goalId,
      name: name,
      emoji: '🏖',
      targetAmount: target,
      currency: 'RUB',
      deadline: deadline,
      goalType: goalType,
      linkedAccountId: linkedAccountId,
      autoReminderEnabled: true,
      visibility: 'personal',
      seedBalanceOnCreate: seedBalanceOnCreate,
      seedAmountKopecks: seedAmountKopecks,
      updatedAt: DateTime.utc(2026, 7, 1),
    );

void main() {
  late ValidateSavingsGoalFormUseCase validate;
  late BuildSavingsGoalDraftUseCase build;
  late Logger logger;

  setUp(() {
    logger = Logger(level: Level.off);
    validate = ValidateSavingsGoalFormUseCase(logger: logger);
    build = BuildSavingsGoalDraftUseCase(logger: logger);
  });

  group('Название', () {
    test('пустое название отклоняется', () {
      expect(validate(_draft(name: '')), 'Название цели обязательно');
    });

    test('название из пробелов отклоняется', () {
      expect(validate(_draft(name: '   ')), 'Название цели обязательно');
    });

    test('название длиннее 50 символов отклоняется', () {
      expect(
        validate(_draft(name: 'А' * 51)),
        'Название не должно превышать 50 символов',
      );
    });

    test('название ровно 50 символов допустимо', () {
      expect(validate(_draft(name: 'А' * 50)), isNull);
    });
  });

  group('Целевая сумма', () {
    test('не указана — отклоняется', () {
      expect(
        validate(_draft(target: null)),
        'Целевая сумма должна быть больше нуля',
      );
    });

    test('ноль — отклоняется', () {
      expect(
        validate(_draft(target: 0)),
        'Целевая сумма должна быть больше нуля',
      );
    });
  });

  group('Дедлайн', () {
    test('в прошлом у новой цели отклоняется', () {
      expect(
        validate(_draft(deadline: DateTime.now().subtract(const Duration(days: 2)))),
        'Дедлайн должен быть в будущем',
      );
    });

    test('сегодня у новой цели отклоняется', () {
      expect(
        validate(_draft(deadline: DateTime.now())),
        'Дедлайн должен быть в будущем',
      );
    });

    test('в будущем допустим', () {
      expect(
        validate(_draft(deadline: DateTime.now().add(const Duration(days: 30)))),
        isNull,
      );
    });

    test('при редактировании прошлый дедлайн допустим', () {
      expect(
        validate(_draft(
          goalId: 'g1',
          deadline: DateTime.now().subtract(const Duration(days: 10)),
        )),
        isNull,
      );
    });
  });

  group('Привязка к счёту и зачисление баланса', () {
    test('привязанная цель без счёта отклоняется', () {
      expect(
        validate(_draft(goalType: 'linked')),
        'Выберите счёт для привязанной цели',
      );
    });

    test('нулевая сумма зачисления отклоняется', () {
      expect(
        validate(_draft(
          goalType: 'linked',
          linkedAccountId: 'a1',
          seedAmountKopecks: 0,
        )),
        'Сумма зачисления должна быть больше нуля',
      );
    });

    test('сумма зачисления больше баланса отклоняется', () {
      expect(
        validate(
          _draft(
            goalType: 'linked',
            linkedAccountId: 'a1',
            seedAmountKopecks: 500000,
          ),
          linkedAccountBalanceKopecks: 100000,
        ),
        'Сумма зачисления не может превышать баланс счёта',
      );
    });

    test('пустая сумма = 100% баланса, это допустимо', () {
      expect(
        validate(
          _draft(goalType: 'linked', linkedAccountId: 'a1'),
          linkedAccountBalanceKopecks: 100000,
        ),
        isNull,
      );
    });

    test('сумма в пределах баланса допустима', () {
      expect(
        validate(
          _draft(
            goalType: 'linked',
            linkedAccountId: 'a1',
            seedAmountKopecks: 100000,
          ),
          linkedAccountBalanceKopecks: 100000,
        ),
        isNull,
      );
    });

    test('виртуальная цель не проверяет зачисление', () {
      expect(
        validate(_draft(seedAmountKopecks: 999999)),
        isNull,
      );
    });

    test('выключенное зачисление не проверяется', () {
      expect(
        validate(_draft(
          goalType: 'linked',
          linkedAccountId: 'a1',
          seedBalanceOnCreate: false,
          seedAmountKopecks: 999999,
        )),
        isNull,
      );
    });
  });

  group('BuildSavingsGoalDraftUseCase', () {
    test('все поля пробрасываются, updatedAt в UTC', () {
      final deadline = DateTime.utc(2027, 1, 1);
      final d = build(
        goalId: 'g1',
        name: 'Ремонт',
        emoji: '🔧',
        targetAmountKopecks: 50000000,
        currency: 'USD',
        deadline: deadline,
        goalType: 'linked',
        linkedAccountId: 'a1',
        autoReminderEnabled: false,
        visibility: 'family',
        seedBalanceOnCreate: false,
        seedAmountKopecks: 123456,
      );

      expect(d.goalId, 'g1');
      expect(d.name, 'Ремонт');
      expect(d.emoji, '🔧');
      expect(d.targetAmount, 50000000);
      expect(d.currency, 'USD');
      expect(d.deadline, deadline);
      expect(d.goalType, 'linked');
      expect(d.linkedAccountId, 'a1');
      expect(d.autoReminderEnabled, isFalse);
      expect(d.visibility, 'family');
      expect(d.seedBalanceOnCreate, isFalse);
      expect(d.seedAmountKopecks, 123456);
      expect(d.updatedAt.isUtc, isTrue);
    });

    test('значения по умолчанию: зачисление включено, сумма не задана', () {
      final d = build(
        name: 'Отпуск',
        emoji: '🏖',
        targetAmountKopecks: 10000000,
        currency: 'RUB',
        goalType: 'virtual',
        autoReminderEnabled: true,
        visibility: 'personal',
      );

      expect(d.seedBalanceOnCreate, isTrue);
      expect(d.seedAmountKopecks, isNull);
      expect(d.goalId, isNull);
      expect(d.deadline, isNull);
    });
  });
}