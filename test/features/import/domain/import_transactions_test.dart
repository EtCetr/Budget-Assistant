import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/import/domain/entities/column_mapping.dart';
import 'package:budget_assistant/features/import/domain/entities/import_options.dart';
import 'package:budget_assistant/features/import/domain/entities/import_result.dart';
import 'package:budget_assistant/features/import/domain/entities/transfer_profile.dart';
import 'package:budget_assistant/features/import/domain/usecases/auto_categorize_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/auto_detect_columns_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/detect_duplicates_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/import_transactions_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/mark_transfers_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/parse_import_file_usecase.dart';
import '../../../helpers/fake_import_repository.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: сквозной конвейер импорта (ТЗ 6.3.25.19).
/// парсинг -> автокатегоризация -> пометка переводов -> дубли/hold.
/// Переводы v2 НЕ объединяются: transfers в результате всегда пустой список.
void main() {
  final skip = sqliteSkipReason();

  group('ImportTransactionsUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late Directory tmp;
    late ImportTransactionsUseCase useCase;
    late Logger logger;

    const mapping = ColumnMapping(
      dateColumnIndex: 0,
      amountColumnIndex: 1,
      merchantColumnIndex: 2,
    );

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await db.appSettingsDao.getForUser(kUserId);
      tmp = await Directory.systemTemp.createTemp('import_pipeline_test');
      logger = Logger(level: Level.off);
      useCase = ImportTransactionsUseCase(
        parseUseCase: ParseImportFileUseCase(
          autoDetect: AutoDetectColumnsUseCase(logger: logger),
          logger: logger,
        ),
        duplicates: DetectDuplicatesUseCase(db: db, logger: logger),
        markTransfers: MarkTransfersUseCase(),
        categorize: AutoCategorizeUseCase(db: db, logger: logger),
        settingsDao: db.appSettingsDao,
        logger: logger,
      );
    });

    tearDown(() async {
      await db.close();
      if (await tmp.exists()) await tmp.delete(recursive: true);
    });

    Future<String> writeCsv(String content) async {
      final file = File('${tmp.path}/statement.csv');
      await file.writeAsString(content, flush: true);
      return file.path;
    }

    Future<ImportResult?> run({
      required String path,
      ImportOptions options = const ImportOptions(),
      TransferProfile profile = const TransferProfile(),
      String? targetSpaceId,
    }) =>
        useCase(
          storedPath: path,
          format: 'csv',
          config: makeParserConfig(id: 'pc_test'),
          mapping: mapping,
          targetAccountId: kAccountId,
          targetSpaceId: targetSpaceId,
          userId: kUserId,
          options: options,
          transferProfile: profile,
        );

    Future<void> existing({
      required String id,
      int amount = 150000,
      AuditStatus auditStatus = AuditStatus.verified,
    }) async {
      final d = DateTime(2026, 7, 1).toUtc();
      await db.into(db.transactions).insert(TransactionsCompanion.insert(
            id: id,
            accountId: kAccountId,
            userId: kUserId,
            date: d,
            amount: amount,
            type: TransactionType.expense,
            merchantName: const Value('Пятёрочка'),
            customCategoryId: const Value('c1'),
            auditStatus: Value(auditStatus),
            createdAt: d,
            updatedAt: d,
          ));
    }

    test('сквозной конвейер: строки, банк, файл и период', () async {
      final path = await writeCsv(
        '01.07.2026;-1500,00;Пятёрочка\n'
        '02.07.2026;-2000,00;Магазин\n',
      );

      final result = await run(path: path);

      expect(result, isNotNull);
      expect(result!.rows.length, 2);
      expect(result.totalRows, 2);
      expect(result.bankName, 'Т-Банк');
      expect(result.bankCode, 'tbank');
      expect(result.fileName, 'statement.csv');
      expect(result.targetAccountId, kAccountId);
      expect(result.periodStart!.isBefore(result.periodEnd!), isTrue);
      expect(result.transfers, isEmpty);
    });

    test('файл без валидных строк — null', () async {
      final path = await writeCsv('не-дата;abc;Магазин\n');

      expect(await run(path: path), isNull);
    });

    test('автокатегоризация включена: правило проставляет категорию',
        () async {
      final now = DateTime.now().toUtc();
      await db.into(db.categoryRules).insert(CategoryRulesCompanion(
            id: const Value('r1'),
            userId: const Value(kUserId),
            bankName: const Value('ANY'),
            triggerString: const Value('пятёрочка'),
            targetCategoryId: const Value('c2'),
            createdAt: Value(now),
            updatedAt: Value(now),
          ));
      final path = await writeCsv('01.07.2026;-1500,00;Пятёрочка\n');

      final result = await run(path: path);

      expect(result!.rows.single.assignedCategoryId, 'c2');
    });

    test('автокатегоризация выключена: категория не назначается', () async {
      final now = DateTime.now().toUtc();
      await db.into(db.categoryRules).insert(CategoryRulesCompanion(
            id: const Value('r1'),
            userId: const Value(kUserId),
            bankName: const Value('ANY'),
            triggerString: const Value('пятёрочка'),
            targetCategoryId: const Value('c2'),
            createdAt: Value(now),
            updatedAt: Value(now),
          ));
      final path = await writeCsv('01.07.2026;-1500,00;Пятёрочка\n');

      final result = await run(
        path: path,
        options: const ImportOptions(autoCategorize: false),
      );

      expect(result!.rows.single.assignedCategoryId, isNull);
    });

    test('пометка переводов по маркеру, без объединения', () async {
      final path = await writeCsv(
        '01.07.2026;-1500,00;Перевод на свой счёт\n',
      );

      final result = await run(path: path);

      expect(result!.rows.single.isTransfer, isTrue);
      expect(result.transfers, isEmpty);
    });

    test('детект переводов выключен: маркер не помечает строку', () async {
      final path = await writeCsv(
        '01.07.2026;-1500,00;Перевод на свой счёт\n',
      );

      final result = await run(
        path: path,
        options: const ImportOptions(detectTransfers: false),
      );

      expect(result!.rows.single.isTransfer, isFalse);
    });

    test('дубликат существующей операции находится', () async {
      await existing(id: 'e1');
      final path = await writeCsv('01.07.2026;-1500,00;Пятёрочка\n');

      final result = await run(path: path);

      expect(result!.duplicates.length, 1);
      expect(result.duplicates.single.existingTransactionId, 'e1');
      expect(result.holdConfirmations, isEmpty);
    });

    test('hold-операция уходит в подтверждения, а не в дубли', () async {
      await existing(id: 'h1', auditStatus: AuditStatus.pending);
      final path = await writeCsv('01.07.2026;-1500,00;Пятёрочка\n');

      final result = await run(path: path);

      expect(result!.duplicates, isEmpty);
      expect(result.holdConfirmations.length, 1);
      expect(result.holdConfirmations.single.existingTransactionId, 'h1');
    });

    test('детект дублей выключен: существующая операция не мешает', () async {
      await existing(id: 'e1');
      final path = await writeCsv('01.07.2026;-1500,00;Пятёрочка\n');

      final result = await run(
        path: path,
        options: const ImportOptions(detectDuplicates: false),
      );

      expect(result!.duplicates, isEmpty);
      expect(result.holdConfirmations, isEmpty);
    });

    test('семейный скоуп пробрасывается в результат', () async {
      final path = await writeCsv('01.07.2026;-1500,00;Пятёрочка\n');

      final result = await run(path: path, targetSpaceId: kSpaceId);

      expect(result!.targetSpaceId, kSpaceId);
    });
  }, skip: skip);
}