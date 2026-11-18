import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/split_receipt_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/entities/split_position_draft.dart';
import '../../../helpers/fake_receipts_repository.dart';

class _MockPosition extends Mock implements SplitPositionDraft {}

/// Этап 24: разделение чека по категориям (ТЗ 6.3.48.7).
/// Коды ошибок для снекбара: MIN_TWO_POSITIONS / NON_POSITIVE_AMOUNT /
/// MISSING_CATEGORY / SUM_MISMATCH.
///
/// SplitPositionDraft мокается: конструктор в контексте не верифицирован,
/// UseCase читает только id / amount / categoryId / description.
SplitPositionDraft _position({
  String id = 'p1',
  required int amount,
  String? categoryId = 'c1',
}) {
  final m = _MockPosition();
  when(() => m.id).thenReturn(id);
  when(() => m.amount).thenReturn(amount);
  when(() => m.categoryId).thenReturn(categoryId);
  when(() => m.description).thenReturn(null);
  return m;
}

void main() {
  late FakeReceiptsRepository repo;
  late SplitReceiptUseCase useCase;

  setUp(() {
    repo = FakeReceiptsRepository();
    useCase = SplitReceiptUseCase(repo: repo, logger: Logger(level: Level.off));
  });

  Future<void> run(List<SplitPositionDraft> positions) => useCase(
        receiptId: 'r1',
        positions: positions,
        actorUserId: 'u1',
      );

  test('чек не найден — StateError', () async {
    await expectLater(
      run([_position(amount: 5000), _position(id: 'p2', amount: 5000)]),
      throwsA(isA<StateError>()),
    );
  });

  test('чек без привязки к транзакции — StateError', () async {
    repo.receipts['r1'] = makeReceipt(id: 'r1');

    await expectLater(
      run([_position(amount: 5000), _position(id: 'p2', amount: 5000)]),
      throwsA(isA<StateError>()),
    );
  });

  test('меньше двух позиций — MIN_TWO_POSITIONS', () async {
    repo.receipts['r1'] = makeReceipt(id: 'r1', transactionId: 't1');

    await expectLater(
      run([_position(amount: 10000)]),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          'MIN_TWO_POSITIONS',
        ),
      ),
    );
  });

  test('нулевая сумма позиции — NON_POSITIVE_AMOUNT', () async {
    repo.receipts['r1'] = makeReceipt(id: 'r1', transactionId: 't1');

    await expectLater(
      run([_position(amount: 0), _position(id: 'p2', amount: 10000)]),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          'NON_POSITIVE_AMOUNT',
        ),
      ),
    );
  });

  test('позиция без категории — MISSING_CATEGORY', () async {
    repo.receipts['r1'] = makeReceipt(id: 'r1', transactionId: 't1');

    await expectLater(
      run([
        _position(amount: 5000, categoryId: null),
        _position(id: 'p2', amount: 5000),
      ]),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          'MISSING_CATEGORY',
        ),
      ),
    );
  });

  test('сумма позиций не сходится с итогом чека — SUM_MISMATCH', () async {
    repo.receipts['r1'] = makeReceipt(id: 'r1', transactionId: 't1');

    await expectLater(
      run([_position(amount: 4000), _position(id: 'p2', amount: 5000)]),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          'SUM_MISMATCH',
        ),
      ),
    );
  });

  test('валидное разделение применяется атомарно', () async {
    repo.receipts['r1'] = makeReceipt(id: 'r1', transactionId: 't1');

    await run([
      _position(amount: 6000),
      _position(id: 'p2', amount: 4000, categoryId: 'c2'),
    ]);

    final applied = repo.appliedSplits.single;
    expect(applied.receiptId, 'r1');
    expect(applied.transactionId, 't1');
    expect(applied.actorUserId, 'u1');
    expect(applied.positions.length, 2);
  });

  test('ошибка применения пробрасывается', () async {
    repo.receipts['r1'] = makeReceipt(id: 'r1', transactionId: 't1');
    repo.error = Exception('db down');

    await expectLater(
      run([_position(amount: 5000), _position(id: 'p2', amount: 5000)]),
      throwsA(isA<Exception>()),
    );
  });
}