import 'package:freezed_annotation/freezed_annotation.dart';

part 'snooze_history_entry.freezed.dart';

/// Запись истории откладываний (локальное JSON-поле snooze_history).
@freezed
abstract class SnoozeHistoryEntry with _$SnoozeHistoryEntry {
  const factory SnoozeHistoryEntry({
    required DateTime atUtc,
    required DateTime fromUtc,
    required DateTime toUtc,
  }) = _SnoozeHistoryEntry;
}