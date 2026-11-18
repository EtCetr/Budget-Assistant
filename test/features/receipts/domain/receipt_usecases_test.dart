import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/receipts/domain/dtos/parsed_item_draft.dart';
import 'package:budget_assistant/features/receipts/domain/dtos/receipt_match_result.dart';
import 'package:budget_assistant/features/receipts/domain/dtos/transaction_match_candidate.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/confirm_receipt_usecase.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/create_draft_receipt_usecase.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/link_receipt_to_transaction_usecase.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/match_receipt_to_transaction_usecase.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/match_receipt_usecase.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/parse_fiscal_qr_usecase.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/record_naming_decision_usecase.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/scan_receipt_qr_usecase.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/validate_receipt_form_usecase.dart';
import '../../../helpers/fake_receipts_repository.dart';

/// Этап 24: черновик чека, подтверждение, привязка и матчинг (ТЗ 6.3.22–6.3.23).
///
/// ВАЖНО: ConfirmReceiptUseCase сначала валидирует форму, и сумма позиций
/// обязана ТОЧНО сходиться с итогом чека (копейки). Поэтому в тестах
/// подтверждения итог чека = сумме позиций (5000 = одна позиция по 5000).
void main() {
  late FakeReceiptsRepository repo;
  late Logger logger;
  late CreateDraftReceiptUseCase createDraft;
  late ConfirmReceiptUseCase confirm;
  late LinkReceiptToTransactionUseCase link;
  late MatchReceiptUseCase match;
  late RecordNamingDecisionUseCase naming;
  late ScanReceiptQrUseCase scanQr;

  setUp(() {
    repo = FakeReceiptsRepository();
    logger = Logger(level: Level.off);
    createDraft = CreateDraftReceiptUseCase(repository: repo, logger: logger);
    confirm = ConfirmReceiptUseCase(
      repo: repo,
      validate: ValidateReceiptFormUseCase(),
      logger: logger,
    );
    link = LinkReceiptToTransactionUseCase(repo: repo, logger: logger);
    match = MatchReceiptUseCase(
      repo: repo,
      matcher: MatchReceiptToTransactionUseCase(),
    );
    naming = RecordNamingDecisionUseCase(repo: repo, logger: logger);
    final parseQr = ParseFiscalQrUseCase(logger);
    scanQr = ScanReceiptQrUseCase(
      parseQr: parseQr,
      createDraft: createDraft,
      logger: logger,
    );
  });

  group('CreateDraftReceiptUseCase', () {
    Future<String> run({
      String? spaceId,
      String? transactionId,
      List<ParsedItemDraft> items = const [
        ParsedItemDraft(
          name: 'Молоко',
          quantity: 1,
          unitPriceKop: 5000,
          totalPriceKop: 5000,
        ),
      ],
    }) =>
        createDraft(
          userId: 'u1',
          spaceId: spaceId,
          transactionId: transactionId,
          storeName: 'Пятёрочка',
          totalKop: 5000,
          dateUtc: DateTime.utc(2026, 7, 15, 12),
          fiscalDataJson: '{"fn":"123"}',
          rawOcrText: 'текст чека',
          imagePath: '/tmp/receipt.jpg',
          items: items,
        );

    test('чек создаётся со статусом draft, RUB, pending и UTC', () async {
      final id = await run();

      final r = repo.receipts[id]!;
      expect(r.status, 'draft');
      expect(r.currency, 'RUB');
      expect(r.syncStatus, SyncStatus.pending);
      expect(r.createdAt.isUtc, isTrue);
      expect(r.totalAmount, 5000);
    });

    test('пустые скоуп и транзакция превращаются в null', () async {
      final id = await run(spaceId: '', transactionId: '');

      expect(repo.receipts[id]!.spaceId, isNull);
      expect(repo.receipts[id]!.transactionId, isNull);
    });

    test('непустые скоуп и транзакция сохраняются', () async {
      final id = await run(spaceId: 's1', transactionId: 't1');

      expect(repo.receipts[id]!.spaceId, 's1');
      expect(repo.receipts[id]!.transactionId, 't1');
    });

    test('позиции наследуют id чека, без нормализации и категории', () async {
      final id = await run();

      final list = repo.items[id]!;
      expect(list.length, 1);
      expect(list.single.receiptId, id);
      expect(list.single.originalName, 'Молоко');
      expect(list.single.normalizedName, isNull);
      expect(list.single.categoryId, isNull);
      expect(list.single.isExcluded, isFalse);
      expect(list.single.totalPrice, 5000);
      expect(list.single.syncStatus, SyncStatus.pending);
    });

    test('фискальные данные, OCR-текст и путь к фото пробрасываются', () async {
      final id = await run();

      final r = repo.receipts[id]!;
      expect(r.fiscalData, '{"fn":"123"}');
      expect(r.rawOcrText, 'текст чека');
      expect(r.imagePath, '/tmp/receipt.jpg');
    });

    test('чек без позиций допустим (QR не содержит позиций)', () async {
      final id = await run(items: const []);

      expect(repo.items[id], isEmpty);
    });

    test('ошибка репозитория пробрасывается', () async {
      repo.error = Exception('db down');

      await expectLater(run(), throwsA(isA<Exception>()));
    });
  });

  group('ConfirmReceiptUseCase', () {
    test('невалидная форма — отказ без записи', () async {
      final receipt = makeReceipt(id: 'r1', totalAmount: 5000, storeName: '   ');

      final result = await confirm(
        receipt: receipt,
        items: [makeReceiptItem(id: 'i1')],
      );

      expect(result.success, isFalse);
      expect(result.errorCodes, ['store_name_empty']);
      expect(repo.savedItems, isEmpty);
      expect(repo.savedReceipts, isEmpty);
    });

    test('валидный чек подтверждается и уходит в очередь синка', () async {
      final receipt = makeReceipt(id: 'r1', totalAmount: 10000);

      final result = await confirm(
        receipt: receipt,
        items: [
          makeReceiptItem(id: 'i1'),
          makeReceiptItem(id: 'i2', originalName: 'Хлеб'),
        ],
      );

      expect(result.success, isTrue);
      expect(repo.calls, ['saveItems', 'saveReceipt']);
      expect(repo.savedItems.single.count, 2);
      final saved = repo.savedReceipts.single;
      expect(saved.status, 'confirmed');
      expect(saved.syncStatus, SyncStatus.pending);
    });

    test('расхождение суммы позиций и итога отклоняется', () async {
      final result = await confirm(
        receipt: makeReceipt(id: 'r1', totalAmount: 9999),
        items: [makeReceiptItem(id: 'i1')],
      );

      expect(result.success, isFalse);
      expect(result.errorCodes, ['sum_mismatch']);
      expect(repo.savedReceipts, isEmpty);
    });

    test('переданная транзакция используется для привязки', () async {
      final result = await confirm(
        receipt: makeReceipt(id: 'r1', totalAmount: 5000),
        items: [makeReceiptItem(id: 'i1')],
        transactionId: 't1',
      );

      expect(result.success, isTrue);
      expect(repo.links.single.transactionId, 't1');
      expect(repo.savedReceipts.single.transactionId, 't1');
    });

    test('пустая транзакция откатывается к транзакции чека', () async {
      final result = await confirm(
        receipt: makeReceipt(id: 'r1', totalAmount: 5000, transactionId: 't-old'),
        items: [makeReceiptItem(id: 'i1')],
        transactionId: '',
      );

      expect(result.success, isTrue);
      expect(repo.links.single.transactionId, 't-old');
    });

    test('без транзакции привязка не выполняется', () async {
      final result = await confirm(
        receipt: makeReceipt(id: 'r1', totalAmount: 5000),
        items: [makeReceiptItem(id: 'i1')],
      );

      expect(result.success, isTrue);
      expect(repo.links, isEmpty);
    });

    test('ошибка сохранения даёт save_failed', () async {
      repo.error = Exception('db down');

      final result = await confirm(
        receipt: makeReceipt(id: 'r1', totalAmount: 5000),
        items: [makeReceiptItem(id: 'i1')],
      );

      expect(result.success, isFalse);
      expect(result.errorCodes, ['save_failed']);
    });
  });

  group('LinkReceiptToTransactionUseCase', () {
    test('успешная привязка возвращает true', () async {
      repo.receipts['r1'] = makeReceipt(id: 'r1');

      final ok = await link(receiptId: 'r1', transactionId: 't1');

      expect(ok, isTrue);
      expect(repo.receipts['r1']!.status, 'matched');
    });

    test('hold-транзакция: ошибка репозитория даёт false', () async {
      repo.linkError = StateError('Cannot link receipt to pending transaction');

      final ok = await link(receiptId: 'r1', transactionId: 't1');

      expect(ok, isFalse);
    });
  });

  group('MatchReceiptUseCase', () {
    test('кандидаты из БД проходят через чистый матчинг', () async {
      repo.matchCandidates = [
        TransactionMatchCandidate(
          id: 't1',
          dateUtc: DateTime.utc(2026, 7, 15, 12),
          amountKop: 10000,
          auditStatus: 'verified',
          hasReceipt: false,
        ),
      ];

      final result = await match(
        totalKop: 10000,
        dateUtc: DateTime.utc(2026, 7, 15, 12),
      );

      expect(result.scenario, MatchScenario.single);
      expect(repo.calls, contains('findMatchCandidates'));
    });

    test('только hold-кандидаты — сценарий Г', () async {
      repo.matchCandidates = [
        TransactionMatchCandidate(
          id: 't1',
          dateUtc: DateTime.utc(2026, 7, 15, 12),
          amountKop: 10000,
          auditStatus: 'pending',
          hasReceipt: false,
        ),
      ];

      final result = await match(
        totalKop: 10000,
        dateUtc: DateTime.utc(2026, 7, 15, 12),
      );

      expect(result.scenario, MatchScenario.pendingBlocked);
    });
  });

  group('RecordNamingDecisionUseCase', () {
    test('решение пользователя пробрасывается в репозиторий', () async {
      await naming(userId: 'u1', accepted: false);
      await naming(userId: 'u1', accepted: true);

      expect(repo.namingDecisions, [false, true]);
    });

    test('ошибка репозитория пробрасывается', () async {
      repo.error = Exception('db down');

      await expectLater(
        naming(userId: 'u1', accepted: true),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('ScanReceiptQrUseCase', () {
    test('нераспознанный QR — null, черновик не создан', () async {
      final id = await scanQr(raw: 'мусор', userId: 'u1');

      expect(id, isNull);
      expect(repo.receipts, isEmpty);
    });

    test('валидный QR создаёт чек без позиций', () async {
      final id = await scanQr(
        raw: 't=20260715T123000&s=1500.50&fn=1234567890',
        userId: 'u1',
      );

      final r = repo.receipts[id]!;
      expect(r.storeName, 'QR-чек');
      expect(r.totalAmount, 150050);
      expect(r.receiptDate, DateTime.utc(2026, 7, 15, 12, 30));
      expect(repo.items[id], isEmpty);
    });

    test('фискальные признаки сохраняются в JSON чека', () async {
      final id = await scanQr(
        raw: 't=20260715T123000&s=100.00&fn=123&fp=456&i=789&n=1',
        userId: 'u1',
      );

      expect(repo.receipts[id]!.fiscalData, contains('"fn":"123"'));
    });
  });
}