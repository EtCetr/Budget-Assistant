import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/import/domain/entities/category_suggestion.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/import/domain/usecases/auto_categorize_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: автокатегоризация импорта (ТЗ 6.3.26.11).
/// Уровни: правило пользователя 1.0 -> история (частота) -> маппинг банка 0.6.
/// Порог применения в categorizeAll: confidence >= 0.7.
void main() {
  final skip = sqliteSkipReason();

  group('AutoCategorizeUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late AutoCategorizeUseCase useCase;
    final now = DateTime.utc(2026, 7, 15, 12);

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      useCase = AutoCategorizeUseCase(
        db: db,
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> rule({
      required String id,
      required String trigger,
      String bankName = 'ANY',
      String target = 'c1',
    }) async {
      await db.into(db.categoryRules).insert(CategoryRulesCompanion(
            id: Value(id),
            userId: const Value(kUserId),
            bankName: Value(bankName),
            triggerString: Value(trigger),
            targetCategoryId: Value(target),
            createdAt: Value(now),
            updatedAt: Value(now),
          ));
    }

    Future<void> historyTx({
      required String id,
      required String merchant,
      required String categoryId,
    }) async {
      await db.into(db.transactions).insert(TransactionsCompanion.insert(
            id: id,
            accountId: kAccountId,
            userId: kUserId,
            date: now,
            amount: 10000,
            type: TransactionType.expense,
            merchantName: Value(merchant),
            customCategoryId: Value(categoryId),
            createdAt: now,
            updatedAt: now,
          ));
    }

    ParsedRow row({String merchant = 'Пятёрочка', String? bankCategory}) =>
        ParsedRow(
          rowIndex: 0,
          date: now,
          amountKopecks: -15000,
          merchantName: merchant,
          bankCategory: bankCategory,
        );

    test('правило пользователя даёт уверенность 1.0', () async {
      await rule(id: 'r1', trigger: 'пятёрочка');

      final s = await useCase.suggestFor(
        merchantName: 'Пятёрочка №12',
        userId: kUserId,
      );

      expect(s, isNotNull);
      expect(s!.categoryId, 'c1');
      expect(s.confidence, 1.0);
      expect(s.source, CategorySuggestionSource.userRule);
    });

    test('история транзакций: одна категория во всех совпадениях', () async {
      await historyTx(id: 'h1', merchant: 'Пятёрочка', categoryId: 'c1');
      await historyTx(id: 'h2', merchant: 'Пятёрочка', categoryId: 'c1');

      final s = await useCase.suggestFor(
        merchantName: 'Пятёрочка',
        userId: kUserId,
      );

      expect(s!.source, CategorySuggestionSource.history);
      expect(s.confidence, 1.0);
    });

    test('история ниже порога 0.5 — подсказки нет', () async {
      await historyTx(id: 'h1', merchant: 'Пятёрочка', categoryId: 'c1');
      await historyTx(id: 'h2', merchant: 'Пятёрочка', categoryId: 'c2');
      await historyTx(id: 'h3', merchant: 'Пятёрочка', categoryId: 'i1');

      final s = await useCase.suggestFor(
        merchantName: 'Пятёрочка',
        userId: kUserId,
      );

      expect(s, isNull);
    });

    test('маппинг категории банка даёт уверенность 0.6', () async {
      await rule(id: 'r1', trigger: 'Супермаркеты', bankName: 'ANY');

      final s = await useCase.suggestFor(
        merchantName: 'Ромашка',
        bankCategory: 'Супермаркеты',
        userId: kUserId,
      );

      expect(s!.source, CategorySuggestionSource.bankMapping);
      expect(s.confidence, 0.6);
    });

    test('нет правил и истории — подсказки нет', () async {
      final s = await useCase.suggestFor(
        merchantName: 'Неизвестный магазин',
        userId: kUserId,
      );

      expect(s, isNull);
    });

    test('categorizeAll применяет правило и игнорирует маппинг 0.6', () async {
      await rule(id: 'r1', trigger: 'пятёрочка');
      await rule(id: 'r2', trigger: 'Супермаркеты', bankName: 'ANY');

      final result = await useCase.categorizeAll(
        rows: [
          row(merchant: 'Пятёрочка'),
          ParsedRow(
            rowIndex: 1,
            date: now,
            amountKopecks: -20000,
            merchantName: 'Ромашка',
            bankCategory: 'Супермаркеты',
          ),
        ],
        userId: kUserId,
      );

      expect(result[0].assignedCategoryId, 'c1');
      expect(result[1].assignedCategoryId, isNull);
    });

    test('categorizeAll без подсказок возвращает строки без категории',
        () async {
      final result = await useCase.categorizeAll(
        rows: [row(merchant: 'Неизвестный магазин')],
        userId: kUserId,
      );

      expect(result.single.assignedCategoryId, isNull);
      expect(result.single.merchantName, 'Неизвестный магазин');
    });
  }, skip: skip);
}