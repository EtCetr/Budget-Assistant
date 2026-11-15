import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/categories/domain/entities/category.dart';
import 'package:budget_assistant/features/categories/domain/entities/category_rule.dart';
import 'package:budget_assistant/features/categories/domain/usecases/auto_categorize_transaction_usecase.dart';
import 'package:budget_assistant/features/categories/domain/usecases/create_category_usecase.dart';
import 'package:budget_assistant/features/categories/domain/usecases/delete_category_usecase.dart';
import 'package:budget_assistant/features/categories/domain/usecases/update_category_usecase.dart';
import '../../../helpers/fake_category_repository.dart';

/// Этап 24: категории и автокатегоризация по правилам банка.
void main() {
  late FakeCategoryRepository repo;
  late Logger logger;
  late CreateCategoryUseCase create;
  late UpdateCategoryUseCase update;
  late DeleteCategoryUseCase delete;
  late AutoCategorizeTransactionUseCase auto;

  setUp(() {
    repo = FakeCategoryRepository();
    logger = Logger(level: Level.off);
    create = CreateCategoryUseCase(
      repository: repo,
      logger: logger,
      uuid: const Uuid(),
    );
    update = UpdateCategoryUseCase(repository: repo, logger: logger);
    delete = DeleteCategoryUseCase(repository: repo, logger: logger);
    auto = AutoCategorizeTransactionUseCase(
      repository: repo,
      logger: logger,
      uuid: const Uuid(),
    );
  });

  group('CreateCategoryUseCase', () {
    Future<Result<Category>> run({
      String name = 'Продукты',
      String type = 'expense',
      bool pinned = false,
      String? parentId,
      String? spaceId,
    }) =>
        create.execute(
          userId: 'u1',
          name: name,
          type: type,
          spaceId: spaceId,
          parentId: parentId,
          iconEmoji: '🛒',
          colorHex: '#22C55E',
          isPinnedForCashback: pinned,
        );

    test('пустое название отклоняется без записи', () async {
      final result = await run(name: '');

      expect(result.isFailure, isTrue);
      expect(result.error, isA<ValidationFailure>());
      expect(repo.categories, isEmpty);
    });

    test('название из пробелов отклоняется', () async {
      expect((await run(name: '   ')).error, isA<ValidationFailure>());
    });

    test('неизвестный тип отклоняется', () async {
      expect((await run(type: 'crypto')).error, isA<ValidationFailure>());
    });

    test('expense, income и transfer допустимы', () async {
      for (final type in ['expense', 'income', 'transfer']) {
        final result = await run(type: type);
        expect(result.isSuccess, isTrue, reason: 'Тип $type должен проходить');
      }
    });

    test('новая категория: pending, UTC, непустой id, имя обрезано', () async {
      final category = (await run(name: '  Продукты  ')).value;

      expect(category.id, isNotEmpty);
      expect(category.name, 'Продукты');
      expect(category.syncStatus, 'pending');
      expect(category.createdAt.isUtc, isTrue);
      expect(category.updatedAt.isUtc, isTrue);
      expect(repo.categories.containsKey(category.id), isTrue);
    });

    test('закрепление для кэшбэка и оформление пробрасываются', () async {
      final category = (await run(
        pinned: true,
        parentId: 'root',
        spaceId: 's1',
      ))
          .value;

      expect(category.isPinnedForCashback, isTrue);
      expect(category.parentId, 'root');
      expect(category.spaceId, 's1');
      expect(category.iconEmoji, '🛒');
      expect(category.colorHex, '#22C55E');
    });

    test('ошибка репозитория превращается в DatabaseFailure', () async {
      repo.error = Exception('db down');

      final result = await run();

      expect(result.error, isA<DatabaseFailure>());
      expect(repo.categories, isEmpty);
    });
  });

  group('UpdateCategoryUseCase', () {
    Future<Result<void>> run({
      String name = 'Продукты',
      String type = 'expense',
      String? parentId,
    }) =>
        update.execute(
          categoryId: 'c1',
          name: name,
          type: type,
          parentId: parentId,
          iconEmoji: '🛒',
          colorHex: '#22C55E',
        );

    test('пустое название отклоняется без записи', () async {
      final result = await run(name: '');

      expect(result.error, isA<ValidationFailure>());
      expect(repo.calls, isEmpty);
    });

    test('неизвестный тип отклоняется', () async {
      expect((await run(type: 'crypto')).error, isA<ValidationFailure>());
      expect(repo.calls, isEmpty);
    });

    test('категория не может быть родителем самой себе', () async {
      final result = await run(parentId: 'c1');

      expect(result.error, isA<ValidationFailure>());
      expect(repo.calls, isEmpty);
    });

    test('имя обрезается, поля пробрасываются', () async {
      final result = await run(name: '  Еда  ', parentId: 'root');

      expect(result.isSuccess, isTrue);
      expect(repo.lastUpdate?.name, 'Еда');
      expect(repo.lastUpdate?.parentId, 'root');
      expect(repo.lastUpdate?.categoryId, 'c1');
      expect(repo.lastUpdate?.iconEmoji, '🛒');
    });

    test('исключение репозитория превращается в DatabaseFailure', () async {
      repo.error = Exception('db down');

      expect((await run()).error, isA<DatabaseFailure>());
    });

    test('готовая ошибка репозитория пробрасывается как есть', () async {
      repo.updateFailure = const Failure.notFound('Категория не найдена');

      expect((await run()).error, isA<NotFoundFailure>());
    });
  });

  group('DeleteCategoryUseCase', () {
    test('удаление делегируется репозиторию', () async {
      repo.categories['c1'] = makeCategory(id: 'c1');

      final result = await delete.execute('c1');

      expect(result.isSuccess, isTrue);
      expect(repo.calls, contains('deleteCategory'));
      expect(repo.categories, isEmpty);
    });

    test('исключение репозитория превращается в DatabaseFailure', () async {
      repo.error = Exception('db down');

      expect((await delete.execute('c1')).error, isA<DatabaseFailure>());
    });

    test('текущее поведение: Failure репозитория игнорируется (TODO(24.2c))',
        () async {
      repo.deleteFailure = const Failure.database('нельзя удалить');

      final result = await delete.execute('c1');

      expect(result.isSuccess, isTrue);
    });
  });

  group('AutoCategorizeTransactionUseCase.execute', () {
    Future<Result<String?>> run({
      String merchantName = 'Перекрёсток',
      String bankName = 'Т-Банк',
      String? spaceId,
    }) =>
        auto.execute(
          merchantName: merchantName,
          bankName: bankName,
          spaceId: spaceId,
        );

    test('пустой мерчант: правила не запрашиваются', () async {
      final result = await run(merchantName: '   ');

      expect(result.isSuccess, isTrue);
      expect(result.value, isNull);
      expect(repo.calls, isEmpty);
    });

    test('правил нет — категория не подобрана', () async {
      expect((await run()).value, isNull);
    });

    test('совпадение по подстроке без учёта регистра', () async {
      repo.rules.add(makeRule(id: 'r1', triggerString: 'перекрёсток'));

      final result = await run(merchantName: 'PEREKRESTOK Перекрёсток №12');

      expect(result.value, 'c1');
    });

    test('банк не совпал — правило не применяется', () async {
      repo.rules.add(makeRule(id: 'r1', bankName: 'Сбер'));

      expect((await run(bankName: 'Т-Банк')).value, isNull);
    });

    test('банк ANY подходит любому банку', () async {
      repo.rules.add(makeRule(id: 'r1', bankName: 'ANY'));

      expect((await run(bankName: 'Любой банк')).value, 'c1');
    });

    test('первое совпавшее правило выигрывает', () async {
      repo.rules.add(makeRule(id: 'r1', targetCategoryId: 'c1'));
      repo.rules.add(
        makeRule(id: 'r2', triggerString: 'пере', targetCategoryId: 'c2'),
      );

      expect((await run()).value, 'c1');
    });

    test('банк и скоуп передаются в репозиторий', () async {
      await run(bankName: 'Сбер', spaceId: 's1');

      expect(repo.lastBankName, 'Сбер');
      expect(repo.lastSpaceId, 's1');
    });

    test('ошибка репозитория превращается в DatabaseFailure', () async {
      repo.error = Exception('db down');

      expect((await run()).error, isA<DatabaseFailure>());
    });
  });

  group('AutoCategorizeTransactionUseCase.createRule', () {
    Future<Result<CategoryRule>> run({
      String triggerString = 'перекрёсток',
      String targetCategoryId = 'c1',
    }) =>
        auto.createRule(
          userId: 'u1',
          bankName: '  Т-Банк  ',
          triggerString: triggerString,
          targetCategoryId: targetCategoryId,
          spaceId: 's1',
        );

    test('пустая строка-триггер отклоняется', () async {
      final result = await run(triggerString: '  ');

      expect(result.error, isA<ValidationFailure>());
      expect(repo.rules, isEmpty);
    });

    test('пустая целевая категория отклоняется', () async {
      expect((await run(targetCategoryId: '')).error, isA<ValidationFailure>());
    });

    test('правило создаётся с pending и UTC, триггер обрезается', () async {
      final rule = (await run(triggerString: '  Перекрёсток  ')).value;

      expect(rule.id, isNotEmpty);
      expect(rule.triggerString, 'Перекрёсток');
      expect(rule.targetCategoryId, 'c1');
      expect(rule.spaceId, 's1');
      expect(rule.syncStatus, 'pending');
      expect(rule.createdAt.isUtc, isTrue);
      expect(rule.updatedAt.isUtc, isTrue);
      expect(repo.rules.length, 1);
    });

    test('текущее поведение: bankName без обрезки (TODO(24.2c))', () async {
      final rule = (await run()).value;

      // UseCase обрезает только triggerString. Пробелы в bankName ломают
      // точное сравнение в CategoryRule.matches — правило не сработает.
      expect(rule.bankName, '  Т-Банк  ');
    });

    test('ошибка репозитория превращается в DatabaseFailure', () async {
      repo.error = Exception('db down');

      expect((await run()).error, isA<DatabaseFailure>());
    });
  });

  group('CategoryRule.matches', () {
    test('регистр не важен', () {
      final rule = makeRule(id: 'r1', triggerString: 'ПЕРЕКРЁСТОК');

      expect(
        rule.matches(merchantName: 'перекрёсток №1', bankName: 'Т-Банк'),
        isTrue,
      );
    });

    test('чужой банк не подходит', () {
      final rule = makeRule(id: 'r1', bankName: 'Сбер');

      expect(
        rule.matches(merchantName: 'Перекрёсток', bankName: 'Т-Банк'),
        isFalse,
      );
    });

    test('подстрока не найдена', () {
      final rule = makeRule(id: 'r1');

      expect(
        rule.matches(merchantName: 'АЗС Лукойл', bankName: 'Т-Банк'),
        isFalse,
      );
    });
  });

  group('Category: признаки типа', () {
    test('корневая категория без родителя', () {
      expect(makeCategory(id: 'c1').isRoot, isTrue);
      expect(makeCategory(id: 'c2', parentId: 'c1').isRoot, isFalse);
    });

    test('типы expense / income / transfer различаются', () {
      expect(makeCategory(id: 'a', type: 'expense').isExpense, isTrue);
      expect(makeCategory(id: 'b', type: 'income').isIncome, isTrue);
      expect(makeCategory(id: 'c', type: 'transfer').isTransfer, isTrue);
      expect(makeCategory(id: 'd', type: 'income').isExpense, isFalse);
    });
  });
}