import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'cashback_entry.freezed.dart';

/// Запись матрицы кэшбэка (Этап 10, ТОМ 2 §14.3).
///
/// [categoryName] — название категории банка (в Supabase шифруется E2E,
/// локально открыто для SQL-поиска — см. sync_table_spec).
/// [categoryId] — привязка к локальной категории для расчёта NET-суммы
/// (ТОМ 4, Правило 1: используется в JOIN с transaction_splits).
@freezed
abstract class CashbackEntry with _$CashbackEntry {
  const factory CashbackEntry({
    required String id,
    required String accountId,
    String? categoryId,
    required String categoryName,
    required int percentBps,
    required String status,
    required String lifetimeType,
    required DateTime expiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    required SyncStatus syncStatus,
  }) = _CashbackEntry;
}