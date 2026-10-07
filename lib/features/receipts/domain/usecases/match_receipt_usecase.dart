import '../dtos/receipt_match_result.dart';
import '../repositories/receipts_repository.dart';
import 'match_receipt_to_transaction_usecase.dart';

/// Композиция: кандидаты из БД + чистый матчинг (ТЗ 6.3.23.5).
class MatchReceiptUseCase {
  final ReceiptsRepository _repo;
  final MatchReceiptToTransactionUseCase _matcher;

  MatchReceiptUseCase({
    required ReceiptsRepository repo,
    required MatchReceiptToTransactionUseCase matcher,
  })  : _repo = repo,
        _matcher = matcher;

  Future<ReceiptMatchResult> call({
    required int totalKop,
    required DateTime dateUtc,
  }) async {
    final candidates =
        await _repo.findMatchCandidates(totalKop: totalKop, dateUtc: dateUtc);
    return _matcher(
      candidates: candidates,
      totalKop: totalKop,
      dateUtc: dateUtc,
    );
  }
}