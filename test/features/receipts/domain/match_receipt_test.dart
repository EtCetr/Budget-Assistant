import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/receipts/domain/dtos/receipt_match_result.dart';
import 'package:budget_assistant/features/receipts/domain/dtos/transaction_match_candidate.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/match_receipt_to_transaction_usecase.dart';

/// Этап 24: матчинг чека к транзакции (ТЗ 6.3.23.5).
/// Окно ±48 часов и ±5% суммы. Сценарии:
/// А=none, Б=single, В=multiple, Г=pendingBlocked (hold привязать нельзя).
void main() {
  late MatchReceiptToTransactionUseCase useCase;
  final base = DateTime.utc(2026, 7, 15, 12);

  setUp(() {
    useCase = MatchReceiptToTransactionUseCase();
  });

  TransactionMatchCandidate candidate({
    required String id,
    int amount = 100000,
    DateTime? date,
    String audit = 'verified',
  }) =>
      TransactionMatchCandidate(
        id: id,
        dateUtc: date ?? base,
        amountKop: amount,
        auditStatus: audit,
        hasReceipt: false,
      );

  ReceiptMatchResult run(List<TransactionMatchCandidate> candidates) =>
      useCase(candidates: candidates, totalKop: 100000, dateUtc: base);

  test('сценарий А: кандидатов нет', () {
    final r = run(const []);

    expect(r.scenario, MatchScenario.none);
    expect(r.autoCandidates, isEmpty);
    expect(r.pendingCandidates, isEmpty);
  });

  test('сценарий Б: один подтверждённый кандидат', () {
    final r = run([candidate(id: 't1')]);

    expect(r.scenario, MatchScenario.single);
    expect(r.autoCandidates.single.id, 't1');
  });

  test('сценарий В: несколько подтверждённых кандидатов', () {
    final r = run([candidate(id: 't1'), candidate(id: 't2')]);

    expect(r.scenario, MatchScenario.multiple);
    expect(r.autoCandidates.length, 2);
  });

  test('сценарий Г: только hold-операции — привязка заблокирована', () {
    final r = run([candidate(id: 't1', audit: 'pending')]);

    expect(r.scenario, MatchScenario.pendingBlocked);
    expect(r.autoCandidates, isEmpty);
    expect(r.pendingCandidates.single.id, 't1');
  });

  test('подтверждённый кандидат выигрывает у hold', () {
    final r = run([
      candidate(id: 'ok'),
      candidate(id: 'hold', audit: 'pending'),
    ]);

    expect(r.scenario, MatchScenario.single);
    expect(r.autoCandidates.single.id, 'ok');
    expect(r.pendingCandidates.single.id, 'hold');
  });

  test('сумма вне допуска 5% отсеивается', () {
    final r = run([candidate(id: 't1', amount: 106000)]);

    expect(r.scenario, MatchScenario.none);
  });

  test('сумма ровно на границе 5% входит', () {
    final r = run([candidate(id: 't1', amount: 105000)]);

    expect(r.scenario, MatchScenario.single);
  });

  test('дата вне окна 48 часов отсеивается', () {
    final r = run([
      candidate(id: 't1', date: base.add(const Duration(hours: 49))),
    ]);

    expect(r.scenario, MatchScenario.none);
  });

  test('дата ровно на границе 48 часов входит', () {
    final r = run([
      candidate(id: 't1', date: base.subtract(const Duration(hours: 48))),
    ]);

    expect(r.scenario, MatchScenario.single);
  });

  test('статус ignored не считается hold', () {
    final r = run([candidate(id: 't1', audit: 'ignored')]);

    expect(r.scenario, MatchScenario.single);
    expect(r.pendingCandidates, isEmpty);
  });
}