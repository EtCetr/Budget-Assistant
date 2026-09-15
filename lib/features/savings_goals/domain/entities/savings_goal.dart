import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'savings_goal.freezed.dart';

/// Статусы цели (Этап 12, ТОМ 2 §14.1).
abstract final class SavingsGoalStatus {
  static const String active = 'active';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
}

/// Типы цели (ТЗ 6.3.17.4).
abstract final class SavingsGoalType {
  static const String virtual = 'virtual';
  static const String linked = 'linked';
}

/// Область видимости (ТЗ 6.3.17.6).
abstract final class SavingsGoalVisibility {
  static const String personal = 'personal';
  static const String family = 'family';
}

/// Доменная модель цели накопления.
///
/// E2E-поля (name, target_amount, current_amount, draft_amount) хранятся
/// локально открыто и шифруются AES-256-GCM только перед sync-пейлоадом
/// (Этап 25) — та же стратегия, что у счетов и транзакций.
@freezed
abstract class SavingsGoal with _$SavingsGoal {
  const factory SavingsGoal({
    required String id,
    required String userId,

    /// NULL = личная цель, UUID = семейная (Multi-group).
    String? spaceId,
    required String name,

    /// Копейки.
    required int targetAmount,

    /// Копейки. Строго read-only для UI: обновляется только через
    /// UpdateSavingsGoalProgressUseCase.
    @Default(0) int currentAmount,
    DateTime? deadline,

    /// NULL = виртуальная цель.
    String? linkedAccountId,
    required String currency,

    /// Копейки. Последняя сумма пополнения для автоподстановки.
    int? draftAmount,
    @Default(true) bool autoReminderEnabled,
    @Default(SavingsGoalStatus.active) String status,
    @Default(false) bool isArchived,

    /// Момент первого достижения цели: одноразовое конфетти + дата в архиве.
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
  }) = _SavingsGoal;
}

extension SavingsGoalX on SavingsGoal {
  bool get isVirtual => linkedAccountId == null;

  bool get isActive => status == SavingsGoalStatus.active && !isArchived;

  bool get isReached => targetAmount > 0 && currentAmount >= targetAmount;

  /// Прогресс в процентах (0..100) для UI.
  int get progressPercent {
    if (targetAmount <= 0) return 0;
    final percent = currentAmount * 100 / targetAmount;
    return percent.clamp(0, 100).floor();
  }
}