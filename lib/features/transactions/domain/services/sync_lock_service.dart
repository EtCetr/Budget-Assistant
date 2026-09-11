import 'package:budget_assistant/core/ports/clock_port.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';

/// Проверка блокировки синхронизации крупных трат.
///
/// Использует SystemClock.elapsedRealtime() через ClockPort,
/// поэтому перевод часов пользователем НЕ снимает блокировку.
class SyncLockService {
  final ClockPort _clock;

  const SyncLockService(this._clock);

  /// true, если транзакцию ещё нельзя синхронизировать.
  Future<bool> isLocked(Transaction transaction) async {
    final startedAt = transaction.syncLockedStartedAt;
    final durationMs = transaction.syncLockedDurationMs;

    if (startedAt == null || durationMs == null) {
      return false;
    }

    final now = await _clock.elapsedRealtimeMs();

    return now < startedAt + durationMs;
  }

  /// Осталось ли блокировке жить (для отладки/тестов).
  Future<Duration> remainingLockTime(Transaction transaction) async {
    final startedAt = transaction.syncLockedStartedAt;
    final durationMs = transaction.syncLockedDurationMs;

    if (startedAt == null || durationMs == null) {
      return Duration.zero;
    }

    final now = await _clock.elapsedRealtimeMs();
    final unlockAt = startedAt + durationMs;

    if (now >= unlockAt) {
      return Duration.zero;
    }

    return Duration(milliseconds: unlockAt - now);
  }
}
