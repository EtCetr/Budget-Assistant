import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'holiday.freezed.dart';

/// Праздник для режима секретности и календаря (Этап 14, ТОМ 2 §15.2).
///
/// E2E-поля (name, icon_emoji) хранятся локально открыто и шифруются
/// AES-256-GCM только перед sync-пейлоадом (Этап 25).
/// Пресеты РФ (isPreset = TRUE) не синхронизируются никогда.
@freezed
abstract class Holiday with _$Holiday {
  const factory Holiday({
    required String id,
    String? spaceId,
    String? userId,
    required String name,
    /// UTC. Для ежегодных матчинг по месяц/день.
    required DateTime date,
    @Default(true) bool isAnnuallyRecurring,
    String? iconEmoji,
    String? colorHex,
    @Default(false) bool isPreset,
    @Default(true) bool isEnabled,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
  }) = _Holiday;
}

extension HolidayX on Holiday {
  bool matchesDay(DateTime day) =>
      isAnnuallyRecurring
          ? date.month == day.month && date.day == day.day
          : date.year == day.year && date.month == day.month &&
              date.day == day.day;
}