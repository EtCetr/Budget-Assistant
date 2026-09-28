import 'package:logger/logger.dart';
import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../entities/parsed_row.dart';

/// AI-подсказка: является ли транзакция подарком?
///
/// 3 критерия с весами:
/// 1. Категория «Подарки» или похожие → +0.5
/// 2. Мерчанты, типичные для подарков → +0.3
/// 3. Сумма выше среднего чека × 2 → +0.2
///
/// Confidence: 0.0–1.0. Дефолт чекбокса: >= 0.3 → TRUE.
class DetectGiftCandidateUseCase {
  final Logger _logger;

  static const _giftMerchants = [
    'золотое яблоко', 'летуаль', 'иль де ботэ', 'zara',
    'h&m', 'детский мир', 'hamley', 'подарки', 'flowers',
    'цветы', 'toy', 'игруш',
  ];

  DetectGiftCandidateUseCase({required Logger logger}) : _logger = logger;

  Future<double> call({
    required ParsedRow row,
    required AppDatabase db,
  }) async {
    try {
      var confidence = 0.0;
      final merchantLower = row.merchantName.toLowerCase();

      // 1. Категория содержит «подарок» / «gift»
      if (row.bankCategory != null) {
        final catLower = row.bankCategory!.toLowerCase();
        if (catLower.contains('подарок') ||
            catLower.contains('gift') ||
            catLower.contains('present')) {
          confidence += 0.5;
        }
      }

      // 2. Типичные мерчанты для подарков
      if (_giftMerchants.any((m) => merchantLower.contains(m))) {
        confidence += 0.3;
      }

      // 3. Сумма выше среднего чека по истории
      try {
        final history = await (db.select(db.transactions)
              ..where((t) =>
                  t.merchantName.isNotNull() &
                  t.type.equals('expense'))
              ..limit(500))
            .get();

        if (history.isNotEmpty) {
          final totalAmount = history.fold<int>(0, (sum, t) => sum + t.amount);
          final avgAmount = totalAmount ~/ history.length;
          if (row.amountKopecks.abs() > avgAmount * 2) {
            confidence += 0.2;
          }
        }
      } catch (_) {
        // Не критично, просто не добавляем вес
      }

      return confidence.clamp(0.0, 1.0);
    } catch (e, st) {
      _logger.e('DetectGiftCandidateUseCase failed', error: e, stackTrace: st);
      return 0.0;
    }
  }
}