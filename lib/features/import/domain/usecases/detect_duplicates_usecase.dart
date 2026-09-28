import 'package:logger/logger.dart';
import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../entities/parsed_row.dart';
import '../entities/duplicate_candidate.dart';
import '../entities/hold_confirmation_candidate.dart';
import 'package:uuid/uuid.dart';

/// Результат детекции: разделяет дубликаты и hold-подтверждения.
class DuplicateAnalysisResult {
  final List<DuplicateCandidate> duplicates;
  final List<HoldConfirmationCandidate> holdConfirmations;

  const DuplicateAnalysisResult({
    required this.duplicates,
    required this.holdConfirmations,
  });
}

/// Детекция дубликатов при импорте (ТЗ 6.3.26.5).
///
/// Критерии:
/// 1. amount — точное совпадение (в копейках, abs)
/// 2. date — ±toleranceDays (из app_settings.duplicate_date_tolerance_days)
/// 3. merchant_name — точное совпадение или Levenshtein < 3
///
/// РАЗДЕЛЕНИЕ:
/// - Если существующая audit_status = 'pending' → HoldConfirmation (не дубль!)
/// - Иначе → DuplicateCandidate
class DetectDuplicatesUseCase {
  final AppDatabase _db;
  final Logger _logger;

  DetectDuplicatesUseCase({
    required AppDatabase db,
    required Logger logger,
  })  : _db = db,
        _logger = logger;

  Future<DuplicateAnalysisResult> call({
    required List<ParsedRow> importedRows,
    required String accountId,
    required int toleranceDays,
  }) async {
    final duplicates = <DuplicateCandidate>[];
    final holds = <HoldConfirmationCandidate>[];

    try {
      for (final row in importedRows) {
        final absAmount = row.amountKopecks.abs();
        final dateStart = row.date.subtract(Duration(days: toleranceDays));
        final dateEnd = row.date.add(Duration(days: toleranceDays));

        // Ищем кандидаты в БД
        final candidates = await (_db.select(_db.transactions)
              ..where((t) =>
                  t.accountId.equals(accountId) &
                  t.amount.equals(absAmount) &
                  t.date.isBetween(Variable(dateStart), Variable(dateEnd))))
            .get();

        for (final existing in candidates) {
          final distance = _levenshteinDistance(
            row.merchantName.toLowerCase(),
            (existing.merchantName ?? '').toLowerCase(),
          );

          // Совпадение: точное или Levenshtein < 3
          if (distance > 2) continue;

          final matchScore = _calculateScore(row, existing, distance);
          final id = const Uuid().v4();

          if (existing.auditStatus == AuditStatus.pending) {
            // Это НЕ дубль, а подтверждение hold-операции
            holds.add(HoldConfirmationCandidate(
              id: id,
              importedRow: row,
              existingTransactionId: existing.id,
              existingDate: existing.date,
              existingAmountKopecks: existing.amount,
              existingMerchantName: existing.merchantName,
            ));
          } else {
            duplicates.add(DuplicateCandidate(
              id: id,
              importedRow: row,
              existingTransactionId: existing.id,
              existingDate: existing.date,
              existingAmountKopecks: existing.amount,
              existingMerchantName: existing.merchantName,
              matchScore: matchScore,
            ));
          }
        }
      }

      _logger.i(
          'DetectDuplicates: найдено ${duplicates.length} дублей, '
          '${holds.length} hold-подтверждений');
    } catch (e, st) {
      _logger.e('DetectDuplicatesUseCase failed', error: e, stackTrace: st);
    }

    return DuplicateAnalysisResult(
      duplicates: duplicates,
      holdConfirmations: holds,
    );
  }

  double _calculateScore(
    ParsedRow row,
    TransactionDb existing,
    int levenshteinDist,
  ) {
    var score = 0.0;
    // Amount точное = +0.4
    if (row.amountKopecks.abs() == existing.amount) score += 0.4;
    // Date: чем ближе, тем выше (max +0.3)
    final dayDiff = row.date.difference(existing.date).inDays.abs();
    score += 0.3 * (1.0 - (dayDiff / 3.0).clamp(0.0, 1.0));
    // Merchant: точное = +0.3, Levenshtein 1-2 = +0.15
    if (levenshteinDist == 0) {
      score += 0.3;
    } else if (levenshteinDist <= 2) {
      score += 0.15;
    }
    return score.clamp(0.0, 1.0);
  }

  /// Расстояние Левенштейна между двумя строками.
  int _levenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    final n = s.length;
    final m = t.length;
    final d = List.generate(n + 1, (i) => List.filled(m + 1, 0));

    for (var i = 0; i <= n; i++) {
      d[i][0] = i;
    }
    for (var j = 0; j <= m; j++) {
      d[0][j] = j;
    }

    for (var i = 1; i <= n; i++) {
      for (var j = 1; j <= m; j++) {
        final cost = s[i - 1] == t[j - 1] ? 0 : 1;
        d[i][j] = [
          d[i - 1][j] + 1,
          d[i][j - 1] + 1,
          d[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return d[n][m];
  }
}