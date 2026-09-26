import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
part 'debt.freezed.dart';

/// Статусы разрешения долга (ТОМ 2 §13.3).
abstract final class DebtResolutionStatus {
  static const String active = 'active';
  static const String forgiven = 'forgiven';
  static const String paidOffline = 'paid_offline';
  static const String resolved = 'resolved';
}

/// Направление долга относительно текущего пользователя.
enum DebtDirection { payable, receivable }

/// Взаимный долг (ТОМ 2 §13.3, ТЗ 6.3.13/6.3.14).
///
/// E2E-поля (amount, description, counterparty_name_dative) хранятся
/// локально открыто и шифруются AES-256-GCM перед формированием
/// sync-пейлоада (Этап 25) — та же стратегия, что у счетов и целей.
/// Закрытие долга НЕ пересчитывает аналитику задним числом:
/// CloseDebtUseCase создаёт компенсирующие транзакции (ТОМ 4 §6).
@freezed
abstract class Debt with _$Debt {
  const factory Debt({
    required String id,
    /// Кому должны (кредитор).
    String? creditorId,
    /// Кто должен (должник). NULL = внешний контрагент.
    String? debtorId,
    /// Семейный долг — пространство; NULL = личный/внешний.
    String? spaceId,
    /// Категория исходной траты (для компенсирующих транзакций).
    String? categoryId,
    /// Копейки, всегда > 0.
    required int amount,
    @Default('RUB') String currency,
    /// «За что» [E2E].
    String? description,
    /// Имя внешнего контрагента в дательном падеже [E2E].
    String? counterpartyNameDative,
    /// Транзакция, породившая долг.
    String? originalTransactionId,
    /// Связь с частью сплит-чека (transaction_splits.id).
    String? splitId,
    /// Срок погашения (UTC).
    DateTime? dueDate,
    /// Дата закрытия.
    DateTime? resolvedAt,
    @Default(DebtResolutionStatus.active) String resolutionStatus,
    @Default(false) bool isExMemberDebt,
    @Default(true) bool autoResolve,
    /// Создатель (только он может редактировать/удалять).
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
  }) = _Debt;
}

extension DebtX on Debt {
  bool get isActive => resolutionStatus == DebtResolutionStatus.active;
  bool get isResolved => resolutionStatus == DebtResolutionStatus.resolved;
  /// Внешний контрагент: одна сторона NULL + имя в дательном (D13-2).
  bool get isExternal => debtorId == null || creditorId == null;
  /// Направление относительно пользователя [userId].
  DebtDirection? directionFor(String userId) {
    if (debtorId == userId) return DebtDirection.payable;
    if (creditorId == userId) return DebtDirection.receivable;
    return null;
  }
  /// Просрочка на момент [nowUtc] (только для активных долгов).
  bool isOverdueAt(DateTime nowUtc) {
    final due = dueDate;
    if (due == null || !isActive) return false;
    return due.isBefore(nowUtc);
  }
}