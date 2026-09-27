import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/recurring_detection_dao.dart';
import '../entities/recurring_transaction.dart';
import '../repositories/recurring_transactions_repository.dart';
import 'calculate_confidence_usecase.dart';

/// Кандидат в регулярные платежи, посчитанный в изоляте.
class RecurringCandidateDto {
  const RecurringCandidateDto({
    required this.merchantName,
    required this.merchantNormalized,
    required this.averageAmount,
    required this.averageAmountBucket,
    required this.averageDayOfMonth,
    required this.occurrenceCount,
    required this.firstSeenUtc,
    required this.lastSeenUtc,
  });

  final String merchantName;
  final String merchantNormalized;
  final int averageAmount;
  final int averageAmountBucket;
  final int averageDayOfMonth;
  final int occurrenceCount;
  final DateTime firstSeenUtc;
  final DateTime lastSeenUtc;
}

/// Нормализация мерчанта: lowercase, только буквы/цифры/пробелы
/// (ключ upsert должен быть стабильным и открытым, ТЗ 6.3.9.15.3b).
String normalizeMerchant(String raw) {
  final lower = raw.toLowerCase().trim();
  final cleaned = lower.replaceAll(RegExp(r'[^a-z0-9а-яё]+'), ' ');
  return cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// Бакет суммы: округление до сотен рублей в копейках
/// (колебания цены +/-10% не создают дублей, ТЗ 6.3.9.9).
int amountBucket(int kopecks) {
  final hundreds = (kopecks.abs() / 10000).round();
  return hundreds * 10000;
}

/// Тяжёлая агрегация в compute-изоляте (ТЗ 6.3.9.15.9a):
/// группировка по (normalized, bucket), >= 3 вхождений и >= 3 разных
/// месяцев (месячный паттерн), средний день списания.
List<RecurringCandidateDto> _detectInIsolate(List<DetectionTxStub> stubs) {
  final groups = <String, List<DetectionTxStub>>{};
  final names = <String, String>{};
  for (final s in stubs) {
    final normalized = normalizeMerchant(s.merchantName);
    if (normalized.isEmpty) continue;
    final key = '$normalized|${amountBucket(s.amountKopecks)}';
    groups.putIfAbsent(key, () => <DetectionTxStub>[]).add(s);
    names[key] = s.merchantName;
  }
  final result = <RecurringCandidateDto>[];
  for (final entry in groups.entries) {
    final list = entry.value;
    if (list.length < 3) continue;
    final months = <String>{};
    int sum = 0;
    int daySum = 0;
    DateTime first = list.first.dateUtc;
    DateTime last = list.first.dateUtc;
    for (final s in list) {
      sum += s.amountKopecks.abs();
      final local = s.dateUtc.toLocal();
      daySum += local.day;
      months.add(
        '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}',
      );
      if (s.dateUtc.isBefore(first)) first = s.dateUtc;
      if (s.dateUtc.isAfter(last)) last = s.dateUtc;
    }
    if (months.length < 3) continue;
    final parts = entry.key.split('|');
    result.add(
      RecurringCandidateDto(
        merchantName: names[entry.key]!,
        merchantNormalized: parts[0],
        averageAmount: sum ~/ list.length,
        averageAmountBucket: int.parse(parts[1]),
        averageDayOfMonth: (daySum / list.length).round().clamp(1, 31),
        occurrenceCount: list.length,
        firstSeenUtc: first,
        lastSeenUtc: last,
      ),
    );
  }
  result.sort((a, b) => b.occurrenceCount.compareTo(a.occurrenceCount));
  return result;
}

/// Автодетект регулярных платежей после импорта >= 6 мес истории
/// (ТЗ 6.3.9). Идемпотентен: повторный запуск обновляет статистику
/// существующих pending-кандидатов, не создаёт дубли (upsert-ключ).
class DetectRecurringPaymentsUseCase {
  DetectRecurringPaymentsUseCase({
    required RecurringDetectionDao dao,
    required RecurringTransactionsRepository repository,
    required CalculateConfidenceUseCase confidence,
    required Logger logger,
  })  : _dao = dao,
        _repository = repository,
        _confidence = confidence,
        _logger = logger;

  final RecurringDetectionDao _dao;
  final RecurringTransactionsRepository _repository;
  final CalculateConfidenceUseCase _confidence;
  final Logger _logger;
  static const Uuid _uuid = Uuid();

  /// Возвращает количество созданных/обновлённых кандидатов.
  Future<int> call({
    required String userId,
    String? spaceId,
    int monthsBack = 6,
  }) async {
    try {
      final since = DateTime.now()
          .toUtc()
          .subtract(Duration(days: monthsBack * 30));
      final stubs = await _dao.getExpenseStubs(
        userId: userId,
        spaceId: spaceId,
        sinceUtc: since,
      );
      if (stubs.isEmpty) return 0;
      final candidates = await compute(_detectInIsolate, stubs);
      int touched = 0;
      final now = DateTime.now().toUtc();
      for (final c in candidates) {
        final existing = await _repository.getByKey(
          userId: userId,
          merchantNormalized: c.merchantNormalized,
          amountBucket: c.averageAmountBucket,
        );
        if (existing == null) {
          await _repository.insert(
            RecurringTransaction(
              id: _uuid.v4(),
              userId: userId,
              merchantName: c.merchantName,
              merchantNameNormalized: c.merchantNormalized,
              averageAmount: c.averageAmount,
              averageAmountBucket: c.averageAmountBucket,
              averageDayOfMonth: c.averageDayOfMonth,
              occurrenceCount: c.occurrenceCount,
              confidence: _confidence(c.occurrenceCount),
              status: RecurringStatus.pendingConfirmation,
              firstSeenDate: c.firstSeenUtc,
              lastSeenDate: c.lastSeenUtc,
              detectedAt: now,
              createdAt: now,
              updatedAt: now,
            ),
          );
          touched++;
        } else if (existing.status == RecurringStatus.pendingConfirmation) {
          await _repository.updateStats(
            id: existing.id,
            occurrenceCount: c.occurrenceCount,
            averageAmount: c.averageAmount,
            averageDayOfMonth: c.averageDayOfMonth,
            lastSeenDate: c.lastSeenUtc,
          );
          touched++;
        }
        // status = 'active' не трогаем: пользователь уже подтвердил платёж.
      }
      _logger.i('DetectRecurring: $touched candidates touched');
      return touched;
    } catch (e, st) {
      _logger.e('DetectRecurringPayments failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}