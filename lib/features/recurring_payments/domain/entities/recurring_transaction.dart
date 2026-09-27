import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'recurring_transaction.freezed.dart';

/// Статусы регулярного платежа (ТЗ 6.3.9).
abstract final class RecurringStatus {
  static const String pendingConfirmation = 'pending_confirmation';
  static const String active = 'active';
}

/// Уверенность автодетекта (ТЗ 6.3.9.6).
abstract final class RecurringConfidence {
  static const String high = 'high';
  static const String medium = 'medium';
  static const String low = 'low';
}

/// Регулярный платёж (Этап 14, ТОМ 2 §15.1 + расширения ТОМ 6 §6.3.9).
///
/// E2E-поля (merchant_name, average_amount) хранятся локально открыто и
/// шифруются перед sync-пейлоадом (Этап 25). Нормализованное имя и бакет
/// суммы — открыты: это ключ идемпотентного upsert (ТЗ 6.3.9.9).
@freezed
abstract class RecurringTransaction with _$RecurringTransaction {
  const factory RecurringTransaction({
    required String id,
    required String userId,
    /// Личная сущность: фактически всегда NULL (ТЗ 6.3.9.15).
    String? spaceId,
    required String merchantName,
    required String merchantNameNormalized,
    /// Копейки.
    required int averageAmount,
    /// Копейки, округлённые до 100 рублей (ключ upsert).
    required int averageAmountBucket,
    required int averageDayOfMonth,
    @Default(0) int occurrenceCount,
    @Default(RecurringConfidence.medium) String confidence,
    @Default(RecurringStatus.pendingConfirmation) String status,
    DateTime? firstSeenDate,
    DateTime? lastSeenDate,
    /// Без FK: циклическая ссылка с reminders.
    String? linkedReminderId,
    String? categoryId,
    DateTime? detectedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
  }) = _RecurringTransaction;
}