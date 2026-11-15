import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/savings_goals/domain/entities/savings_goal.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/archive_savings_goal_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/complete_savings_goal_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/create_savings_goal_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/link_savings_goal_to_account_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/restore_savings_goal_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/update_savings_goal_progress_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/update_savings_goal_usecase.dart';
import '../../../helpers/fake_savings_goals_repository.dart';

/// Этап 24: жизненный цикл цели. Прогресс меняется ТОЛЬКО через
/// UpdateSavingsGoalProgressUseCase (решение Этапа 12).
void main() {
  late FakeSavingsGoalsRepository repo;
  late Logger logger;
  late CreateSavingsGoalUseCase create;
  late UpdateSavingsGoalUseCase update;
  late UpdateSavingsGoalProgressUseCase progress;
  late CompleteSavingsGoalUseCase complete;
  late ArchiveSavingsGoalUseCase archive;
  late RestoreSavingsGoalUseCase restore;
  late LinkSavingsGoalToAccountUseCase link;

  setUp(() {
    repo = FakeSavingsGoalsRepository();
    logger = Logger(level: Level.off);
    create = CreateSavingsGoalUseCase(repository: repo, logger: logger);
    update = UpdateSavingsGoalUseCase(repository: repo, logger: logger);
    progress =
        UpdateSavingsGoalProgressUseCase(repository: repo, logger: logger);
    complete = CompleteSavingsGoalUseCase(repository: repo, logger: logger);
    archive = ArchiveSavingsGoalUseCase(repository: repo, logger: logger);
    restore = RestoreSavingsGoalUseCase(repository: repo, logger: logger);
    link = LinkSavingsGoalToAccountUseCase(repository: repo, logger: logger);
  });

  group('Создание', () {
    test('цель создаётся с UTC-датами и непустым id', () async {
      final goal = await create(
        userId: 'u1',
        name: 'Отпуск',
        targetAmountKopecks: 10000000,
        currency: 'RUB',
      );

      expect(goal.id, isNotEmpty);
      expect(goal.currentAmount, 0);
      expect(goal.createdAt.isUtc, isTrue);
      expect(goal.updatedAt.isUtc, isTrue);
      expect(goal.syncStatus.name, 'pending');
      expect(repo.goals.containsKey(goal.id), isTrue);
    });

    test('стартовое зачисление попадает в currentAmount', () async {
      final goal = await create(
        userId: 'u1',
        name: 'Отпуск',
        targetAmountKopecks: 10000000,
        currency: 'RUB',
        initialAmountKopecks: 2500000,
      );

      expect(goal.currentAmount, 2500000);
    });

    test('отрицательное стартовое зачисление обнуляется', () async {
      final goal = await create(
        userId: 'u1',
        name: 'Отпуск',
        targetAmountKopecks: 10000000,
        currency: 'RUB',
        initialAmountKopecks: -100,
      );

      expect(goal.currentAmount, 0);
    });

    test('скоуп, счёт, дедлайн и автонапоминание пробрасываются', () async {
      final deadline = DateTime.utc(2027, 1, 1);
      final goal = await create(
        userId: 'u1',
        name: 'Ремонт',
        targetAmountKopecks: 50000000,
        currency: 'USD',
        spaceId: 's1',
        linkedAccountId: 'a1',
        deadline: deadline,
        autoReminderEnabled: false,
      );

      expect(goal.spaceId, 's1');
      expect(goal.linkedAccountId, 'a1');
      expect(goal.deadline, deadline);
      expect(goal.autoReminderEnabled, isFalse);
      expect(goal.currency, 'USD');
    });

    test('ошибка репозитория пробрасывается', () async {
      repo.error = Exception('db down');

      await expectLater(
        create(
          userId: 'u1',
          name: 'Отпуск',
          targetAmountKopecks: 1,
          currency: 'RUB',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Редактирование', () {
    test('накопленный прогресс не меняется при правке', () async {
      repo.goals['g1'] = makeGoal(id: 'g1', current: 5000000);

      await update(
        goal: repo.goals['g1']!,
        newName: 'Отпуск в Праге',
        newTargetAmountKopecks: 20000000,
        newDeadline: DateTime.utc(2027, 5, 1),
        newLinkedAccountId: 'a1',
        newAutoReminderEnabled: false,
      );

      final g = repo.goals['g1']!;
      expect(g.name, 'Отпуск в Праге');
      expect(g.targetAmount, 20000000);
      expect(g.currentAmount, 5000000);
      expect(g.linkedAccountId, 'a1');
      expect(g.autoReminderEnabled, isFalse);
    });

    test('null снимает дедлайн и привязку к счёту', () async {
      repo.goals['g1'] = makeGoal(
        id: 'g1',
        linkedAccountId: 'a1',
        deadline: DateTime.utc(2027, 1, 1),
      );

      await update(
        goal: repo.goals['g1']!,
        newName: 'Отпуск',
        newTargetAmountKopecks: 10000000,
        newDeadline: null,
        newLinkedAccountId: null,
        newAutoReminderEnabled: true,
      );

      expect(repo.goals['g1']!.deadline, isNull);
      expect(repo.goals['g1']!.linkedAccountId, isNull);
      expect(repo.goals['g1']!.isVirtual, isTrue);
    });

    test('ошибка репозитория пробрасывается', () async {
      repo.error = Exception('db down');

      await expectLater(
        update(
          goal: makeGoal(id: 'g1'),
          newName: 'X',
          newTargetAmountKopecks: 1,
          newDeadline: null,
          newLinkedAccountId: null,
          newAutoReminderEnabled: true,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Прогресс', () {
    test('пополнение увеличивает накопленное', () async {
      repo.goals['g1'] = makeGoal(id: 'g1', current: 1000000);

      final reached = await progress(
        goalId: 'g1',
        deltaKopecks: 500000,
        draftAmountKopecks: 500000,
      );

      expect(reached, isFalse);
      expect(repo.goals['g1']!.currentAmount, 1500000);
      expect(repo.progressUpdates.single.amount, 1500000);
      expect(repo.progressUpdates.single.draftAmount, 500000);
    });

    test('первое достижение цели возвращает true', () async {
      repo.goals['g1'] = makeGoal(id: 'g1', current: 9000000);

      final reached = await progress(goalId: 'g1', deltaKopecks: 1000000);

      expect(reached, isTrue);
      expect(repo.goals['g1']!.currentAmount, 10000000);
    });

    test('повторное пополнение достигнутой цели — без повторного конфетти',
        () async {
      repo.goals['g1'] = makeGoal(id: 'g1', current: 10000000);

      final reached = await progress(goalId: 'g1', deltaKopecks: 1000000);

      expect(reached, isFalse);
    });

    test('изъятие больше накопленного отклоняется без записи', () async {
      repo.goals['g1'] = makeGoal(id: 'g1', current: 500000);

      final reached = await progress(goalId: 'g1', deltaKopecks: -1000000);

      expect(reached, isFalse);
      expect(repo.progressUpdates, isEmpty);
      expect(repo.goals['g1']!.currentAmount, 500000);
    });

    test('изъятие в пределах остатка уменьшает накопленное', () async {
      repo.goals['g1'] = makeGoal(id: 'g1', current: 500000);

      await progress(goalId: 'g1', deltaKopecks: -200000);

      expect(repo.goals['g1']!.currentAmount, 300000);
    });

    test('несуществующая цель — false без записи', () async {
      final reached = await progress(goalId: 'missing', deltaKopecks: 100);

      expect(reached, isFalse);
      expect(repo.progressUpdates, isEmpty);
    });
  });

  group('Завершение, архив, привязка', () {
    test('завершение ставит статус и дату', () async {
      repo.goals['g1'] = makeGoal(id: 'g1', current: 10000000);

      await complete('g1');

      expect(repo.goals['g1']!.status, SavingsGoalStatus.completed);
      expect(repo.goals['g1']!.completedAt, isNotNull);
    });

    test('архивирование и восстановление переключают флаг', () async {
      repo.goals['g1'] = makeGoal(id: 'g1');

      await archive('g1');
      expect(repo.goals['g1']!.isArchived, isTrue);
      expect(repo.goals['g1']!.isActive, isFalse);

      await restore('g1');
      expect(repo.goals['g1']!.isArchived, isFalse);
      expect(repo.goals['g1']!.isActive, isTrue);
    });

    test('привязка виртуальной цели к счёту', () async {
      repo.goals['g1'] = makeGoal(id: 'g1');

      await link(goal: repo.goals['g1']!, accountId: 'a1');

      expect(repo.goals['g1']!.linkedAccountId, 'a1');
      expect(repo.goals['g1']!.isVirtual, isFalse);
    });

    test('ошибки репозитория пробрасываются', () async {
      repo.error = Exception('db down');

      await expectLater(complete('g1'), throwsA(isA<Exception>()));
      await expectLater(archive('g1'), throwsA(isA<Exception>()));
      await expectLater(restore('g1'), throwsA(isA<Exception>()));
      await expectLater(
        link(goal: makeGoal(id: 'g1'), accountId: 'a1'),
        throwsA(isA<Exception>()),
      );
    });
  });
}