import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'reminder.freezed.dart';

/// Приоритеты напоминания (ТОМ 2 §16.1, ТЗ 6.3.12.3).
abstract final class ReminderPriority {
  static const String low = 'low';
  static const String normal = 'normal';
  static const String high = 'high';
}

/// Доменная модель напоминания (Этап 14, ТОМ 2 §16.1).
///
/// E2E-поля (title, description, expected_amount) хранятся локально открыто
/// и шифруются AES-256-GCM только перед sync-пейлоадом (Этап 25) — та же
/// стратегия, что у счетов, целей и долгов.
@freezed
abstract class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    required String userId,
    /// NULL = личное, UUID = семейное (Multi-group).
    String? spaceId,
    required String title,
    String? description,
    /// UTC.
    required DateTime remindAt,
    /// iCal RRULE строка (nullable = однократно).
    String? recurrenceRule,
    @Default(false) bool isCompleted,
    /// FK на memberships.id (НЕ users.id) — ТЗ 6.3.12.6.
    String? assigneeId,
    /// Связь с регулярным платежом (без FK: циклическая ссылка).
    String? linkedRecurringId,
    String? linkedCategoryId,
    String? linkedAccountId,
    /// Копейки.
    int? expectedAmount,
    @Default(ReminderPriority.normal) String priority,
    @Default(0) int snoozeCount,
    /// [LOCAL] JSON-массив истории откладываний, не синхронизируется.
    String? snoozeHistory,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
  }) = _Reminder;
}

extension ReminderX on Reminder {
  bool get isPersonal => spaceId == null;
  bool get isFamily => spaceId != null;
  bool isOverdueAt(DateTime nowUtc) => !isCompleted && remindAt.isBefore(nowUtc);
}